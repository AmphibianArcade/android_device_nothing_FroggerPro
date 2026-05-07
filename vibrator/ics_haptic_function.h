#pragma once

extern "C" {
extern int sfdc_initialize(void (*callback)(float f0));
extern int sfdc_calibrate(const int32_t* he, int lenInts);
extern float sfdc_get_manufactory_f0();
extern float sfdc_get_continuous_f0();
extern float sfdc_get_transient_fc();
extern int sfdc_set_ntc_enable(int enable);
}
