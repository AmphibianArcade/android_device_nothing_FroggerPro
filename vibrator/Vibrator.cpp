/*
 * SPDX-FileCopyrightText: The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

#include "Vibrator.h"

#include <cutils/properties.h>
#include <inttypes.h>
#include <log/log.h>

#include <atomic>
#include <cmath>
#include <thread>

#include "aac_vibra_function.h"
#include "ics_haptic_function.h"

#define RICHTAP_JND_EFFECT_CLICK 12296
#define RICHTAP_JND_EFFECT_TICK 12297
#define RICHTAP_JND_STRENGTH 100

#define DOUBLE_CLICK_GAP_MS 70
#define DOUBLE_CLICK_DURATION_MS 88

#define SFDC_F0_MIN 50.0f
#define SFDC_F0_MAX 500.0f

#define HE_V1_VERSION 1
#define HE_V1_TYPE_TRANSIENT 0x1001
#define HE_V1_INTENSITY 100
#define HE_V1_FREQUENCY 65

#define COMPOSE_DELAY_MAX_MS 1000
#define COMPOSE_SIZE_MAX 16
#define COMPOSE_SCALE_GAMMA 1.2f

#define PRIMITIVE_CLICK_MS 18
#define PRIMITIVE_TICK_MS 12

namespace aidl {
namespace android {
namespace hardware {
namespace vibrator {

static std::atomic<uint32_t> gComposeGen{0};

static void sfdcF0Callback(float f0) {
    ALOGD("sfdc f0 update: %.1f", f0);
}

static bool primitiveToEffect(CompositePrimitive p, uint32_t* id, int32_t* durationMs) {
    switch (p) {
        case CompositePrimitive::CLICK:
        case CompositePrimitive::THUD:
            *id = RICHTAP_JND_EFFECT_CLICK;
            *durationMs = PRIMITIVE_CLICK_MS;
            return true;
        case CompositePrimitive::LIGHT_TICK:
        case CompositePrimitive::LOW_TICK:
            *id = RICHTAP_JND_EFFECT_TICK;
            *durationMs = PRIMITIVE_TICK_MS;
            return true;
        default:
            return false;
    }
}

static uint8_t scaleToAmplitude(float scale) {
    uint8_t amplitude = (uint8_t)std::lround(powf(scale, COMPOSE_SCALE_GAMMA) * 0xff);
    if (scale > 0.0f && amplitude < 2) {
        amplitude = 2;
    }
    return amplitude;
}

static void updateF0() {
    static const int32_t he[5] = {HE_V1_VERSION, HE_V1_TYPE_TRANSIENT, 0, HE_V1_INTENSITY,
                                  HE_V1_FREQUENCY};
    float f0;

    if (sfdc_calibrate(he, 5) >= 0) {
        f0 = sfdc_get_transient_fc();
    } else {
        f0 = sfdc_get_continuous_f0();
    }

    if (f0 >= SFDC_F0_MIN && f0 <= SFDC_F0_MAX) {
        aac_vibra_setting_f0(0, f0);
    }
}

Vibrator::Vibrator() {
    uint32_t deviceType = 0;

    int32_t ret = aac_vibra_init(&deviceType);
    if (ret) {
        ALOGE("AAC init failed: %d\n", ret);
        return;
    }

    aac_vibra_looper_start();

    if (sfdc_initialize(sfdcF0Callback) < 0) {
        ALOGW("sfdc init failed, running without f0 tracking\n");
    } else {
        float f0 = sfdc_get_manufactory_f0();
        if (f0 >= SFDC_F0_MIN && f0 <= SFDC_F0_MAX) {
            aac_vibra_setting_f0(0, f0);
            ALOGI("seeded manufactory f0: %.1f\n", f0);
        }
    }

    ALOGI("AAC init success: %u\n", deviceType);
}

ndk::ScopedAStatus Vibrator::getCapabilities(int32_t* _aidl_return) {
    *_aidl_return = IVibrator::CAP_ON_CALLBACK | IVibrator::CAP_PERFORM_CALLBACK |
                    IVibrator::CAP_AMPLITUDE_CONTROL | IVibrator::CAP_COMPOSE_EFFECTS |
                    IVibrator::CAP_GET_RESONANT_FREQUENCY;

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::off() {
    ++gComposeGen;
    if (!aac_vibra_looper_stopPerformHe()) {
        ALOGE("AAC stop failed\n");
        return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_SERVICE_SPECIFIC));
    }

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::on(int32_t timeoutMs,
                                const std::shared_ptr<IVibratorCallback>& callback) {
    updateF0();

    int32_t ret = aac_vibra_looper_on(timeoutMs);
    if (ret < 0) {
        ALOGE("AAC on failed: %d\n", ret);
        return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_SERVICE_SPECIFIC));
    }

    if (callback != nullptr) {
        std::thread([=] {
            usleep(ret * 1000);
            callback->onComplete();
        }).detach();
    }

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::perform(Effect effect, EffectStrength es __unused,
                                     const std::shared_ptr<IVibratorCallback>& callback,
                                     int32_t* _aidl_return) {
    uint32_t id;

    switch (effect) {
        case Effect::CLICK:
        case Effect::DOUBLE_CLICK:
        case Effect::TICK:
        case Effect::THUD:
        case Effect::POP:
        case Effect::HEAVY_CLICK:
            id = RICHTAP_JND_EFFECT_CLICK;
            break;
        case Effect::TEXTURE_TICK:
            id = RICHTAP_JND_EFFECT_TICK;
            break;
        default:
            return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
    }

    updateF0();
    aac_vibra_setAmplitude(0xff);

    int32_t ret = aac_vibra_looper_prebaked_effect(id, RICHTAP_JND_STRENGTH);
    if (ret < 0) {
        ALOGE("AAC perform failed: %d\n", ret);
        return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_SERVICE_SPECIFIC));
    }

    if (effect == Effect::DOUBLE_CLICK) {
        std::thread([=] {
            usleep(DOUBLE_CLICK_GAP_MS * 1000);
            aac_vibra_looper_prebaked_effect(RICHTAP_JND_EFFECT_CLICK, RICHTAP_JND_STRENGTH);
        }).detach();
        ret = DOUBLE_CLICK_DURATION_MS;
    }

    if (callback != nullptr) {
        std::thread([=] {
            usleep(ret * 1000);
            callback->onComplete();
        }).detach();
    }

    *_aidl_return = ret;

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::getSupportedEffects(std::vector<Effect>* _aidl_return) {
    *_aidl_return = {Effect::CLICK, Effect::DOUBLE_CLICK, Effect::TICK,        Effect::THUD,
                     Effect::POP,   Effect::HEAVY_CLICK,  Effect::TEXTURE_TICK};

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::setAmplitude(float amplitude) {
    uint8_t tmp = (uint8_t)(amplitude * 0xff);

    aac_vibra_dynamic_scale(tmp);

    int32_t ret = aac_vibra_setAmplitude(tmp);
    if (ret) {
        ALOGE("AAC set amplitude failed: %d\n", ret);
        return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_SERVICE_SPECIFIC));
    }

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::setExternalControl(bool enabled __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::getCompositionDelayMax(int32_t* maxDelayMs) {
    *maxDelayMs = COMPOSE_DELAY_MAX_MS;

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::getCompositionSizeMax(int32_t* maxSize) {
    *maxSize = COMPOSE_SIZE_MAX;

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::getSupportedPrimitives(std::vector<CompositePrimitive>* supported) {
    *supported = {CompositePrimitive::NOOP, CompositePrimitive::CLICK, CompositePrimitive::THUD,
                  CompositePrimitive::LIGHT_TICK, CompositePrimitive::LOW_TICK};

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::getPrimitiveDuration(CompositePrimitive primitive,
                                                  int32_t* durationMs) {
    uint32_t id;

    if (primitive == CompositePrimitive::NOOP) {
        *durationMs = 0;
        return ndk::ScopedAStatus::ok();
    }

    if (!primitiveToEffect(primitive, &id, durationMs)) {
        return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
    }

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::compose(const std::vector<CompositeEffect>& composite,
                                     const std::shared_ptr<IVibratorCallback>& callback) {
    if (composite.empty() || composite.size() > COMPOSE_SIZE_MAX) {
        return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_ILLEGAL_ARGUMENT));
    }

    for (const auto& e : composite) {
        uint32_t id;
        int32_t ms;

        if (e.delayMs < 0 || e.delayMs > COMPOSE_DELAY_MAX_MS || e.scale < 0.0f ||
            e.scale > 1.0f) {
            return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_ILLEGAL_ARGUMENT));
        }
        if (e.primitive != CompositePrimitive::NOOP && !primitiveToEffect(e.primitive, &id, &ms)) {
            return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
        }
    }

    uint32_t gen = ++gComposeGen;
    std::thread([=] {
        updateF0();
        for (const auto& e : composite) {
            uint32_t id;
            int32_t ms;

            if (gComposeGen.load() != gen) return;
            if (e.delayMs > 0) {
                usleep(e.delayMs * 1000);
                if (gComposeGen.load() != gen) return;
            }
            if (!primitiveToEffect(e.primitive, &id, &ms)) continue;
            aac_vibra_setAmplitude(scaleToAmplitude(e.scale));
            aac_vibra_looper_prebaked_effect(id, RICHTAP_JND_STRENGTH);
            usleep(ms * 1000);
        }
        if (callback != nullptr && gComposeGen.load() == gen) {
            callback->onComplete();
        }
    }).detach();

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::getSupportedAlwaysOnEffects(
        std::vector<Effect>* _aidl_return __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::alwaysOnEnable(int32_t id __unused, Effect effect __unused,
                                            EffectStrength strength __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::alwaysOnDisable(int32_t id __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::getResonantFrequency(float* resonantFreqHz) {
    float f0 = sfdc_get_continuous_f0();
    if (f0 < SFDC_F0_MIN || f0 > SFDC_F0_MAX) {
        f0 = sfdc_get_manufactory_f0();
    }
    if (f0 < SFDC_F0_MIN || f0 > SFDC_F0_MAX) {
        return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_ILLEGAL_STATE));
    }

    *resonantFreqHz = f0;

    return ndk::ScopedAStatus::ok();
}

ndk::ScopedAStatus Vibrator::getQFactor(float* qFactor __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::getFrequencyResolution(float* freqResolutionHz __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::getFrequencyMinimum(float* freqMinimumHz __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::getBandwidthAmplitudeMap(std::vector<float>* _aidl_return __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::getPwlePrimitiveDurationMax(int32_t* durationMs __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::getPwleCompositionSizeMax(int32_t* maxSize __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::getSupportedBraking(std::vector<Braking>* supported __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

ndk::ScopedAStatus Vibrator::composePwle(const std::vector<PrimitivePwle>& composite __unused,
                                         const std::shared_ptr<IVibratorCallback>& callback
                                                 __unused) {
    return ndk::ScopedAStatus(AStatus_fromExceptionCode(EX_UNSUPPORTED_OPERATION));
}

}  // namespace vibrator
}  // namespace hardware
}  // namespace android
}  // namespace aidl
