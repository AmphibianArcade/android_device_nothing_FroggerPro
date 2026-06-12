#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.fixups_blob import (
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None

namespace_imports = [
    'hardware/qcom-caf/sm8750',
    'hardware/qcom-caf/wlan',
    'hardware/qcom-caf/wlan/qcwcn',
    'vendor/qcom/opensource/commonsys/display',
    'vendor/qcom/opensource/commonsys-intf/display',
    'vendor/qcom/opensource/dataservices',
]

lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    (
        'libtensorflowlite_jni',
    ): lib_fixup_vendor_suffix,
}

blob_fixups: blob_fixups_user_type = {
    (
        'vendor/lib64/libVoiceSdk.so',
        'vendor/lib64/libcapiv2uvvendor.so',
        'vendor/lib64/liblistensoundmodel2vendor.so',
    ): blob_fixup()
        .replace_needed('libtensorflowlite_c.so', 'libtensorflowlite_c_vendor.so'),
    'vendor/etc/init/nicmd.rc': blob_fixup()
        .regex_replace(
            r'(service\s+vendor\.nicmd\s+/system/vendor/bin/nicmd\s*\n\s*class\s+main)',
            r'\1\n    user root\n    group root'
        ),
    'vendor/etc/init/vendor.dpmd.rc': blob_fixup()
        .regex_replace(
            r'(service\s+vendor\.dpmd\s+/vendor/bin/vendor\.dpmd\s*\n)',
            r'\1    user root\n'
        ),
    'vendor/etc/init/qms.rc': blob_fixup()
        .regex_replace(
            r'(service\s+vendor\.qms\s+/vendor/bin/qms\s*\n)',
            r'\1    user root\n'
        ),
}  # fmt: skip

module = ExtractUtilsModule(
    'FroggerPro',
    'nothing',
    namespace_imports=namespace_imports,
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    add_firmware_proprietary_file=True,
)

if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()