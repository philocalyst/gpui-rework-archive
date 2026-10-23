#!/usr/bin/env python3
"""Exercise public WGPU device-lost delivery with a temporary, restored fault."""
from pathlib import Path
import os
import subprocess
import tempfile

HERE = Path(__file__).resolve().parent
REACTIVITY = HERE.parents[1]
source = REACTIVITY / 'vendor/wgpu-core/src/indirect_validation/mod.rs'
original = source.read_bytes()
needle = b'        let dispatch = match Dispatch::new('
injection = b'''        // Qualification-only fault; never present in committed product source.
        #[cfg(feature = "std")]
        if std::env::var_os("GPUI_TEST_FAIL_INDIRECT_SETUP").is_some() {
            return Err(DeviceError::Lost);
        }
'''
env = os.environ.copy()
env['CARGO_BUILD_JOBS'] = '2'
env.setdefault('CARGO_TARGET_DIR', '/tmp/gpui-lazy-indirect-qualification-target')
target = Path(env['CARGO_TARGET_DIR']).resolve()
try:
    assert original.count(needle) == 1
    source.write_bytes(original.replace(needle, injection + needle))
    subprocess.run(['cargo', 'build', '--locked', '--manifest-path', str(HERE / 'native/Cargo.toml')], cwd=REACTIVITY.parent, env=env, check=True)
    env['GPUI_TEST_FAIL_INDIRECT_SETUP'] = '1'
    with tempfile.TemporaryDirectory(prefix='gpui-lazy-indirect-lost-trace-') as trace:
        subprocess.run([str(target / 'debug/lazy-indirect-native-qualification'), trace, 'lost'], env=env, check=True, timeout=30)
finally:
    source.write_bytes(original)
