#!/usr/bin/env python3
"""Run private Core qualification without leaving hooks or lock changes in source."""
from pathlib import Path
import argparse
import io
import json
import os
import subprocess
import tarfile
import tempfile

HERE = Path(__file__).resolve().parent
REACTIVITY = HERE.parents[1]
REPO = REACTIVITY.parent
CORE = REACTIVITY / 'vendor/wgpu-core'
SOURCE_PIN = '06b15c1835291b40b6bbc426b8a5eee72cc2a35a'

parser = argparse.ArgumentParser()
parser.add_argument('--baseline', action='store_true')
parser.add_argument('--counts', action='store_true')
args = parser.parse_args()
env = os.environ.copy()
env['CARGO_BUILD_JOBS'] = '2'
env.setdefault('CARGO_TARGET_DIR', '/tmp/gpui-lazy-indirect-qualification-target')
features = 'wgsl,vulkan,noop' if args.counts or args.baseline else 'wgsl,vulkan,noop,trace,replay'
filter_name = 'lazy_native_constructor_counts_and_sizes' if args.counts or args.baseline else 'lazy_'
patch = 'patch.crates-io.wgpu-hal.path=' + json.dumps(str(REACTIVITY / 'vendor/wgpu-hal'))

with tempfile.TemporaryDirectory(prefix='gpui-lazy-indirect-baseline-') as temporary:
    core = CORE
    if args.baseline:
        core = Path(temporary)
        archive = subprocess.check_output(['git', '-C', str(REPO), 'archive', SOURCE_PIN, 'reactivity/vendor/wgpu-core'])
        with tarfile.open(fileobj=io.BytesIO(archive)) as files:
            for member in files.getmembers():
                parts = Path(member.name).parts[3:]
                if not parts:
                    continue
                member.name = str(Path(*parts))
                files.extract(member, core, filter='data')
        qualification = (HERE / 'qualification.rs').read_text()
        common = qualification[:qualification.index('#[test]')]
        native = qualification[qualification.index('#[test]\nfn lazy_native_constructor_counts_and_sizes'):qualification.index('#[cfg(feature = "trace")]')]
        native = native.replace('assert!(device.indirect_validation.as_ref().unwrap().get().is_none());', 'assert!(device.indirect_validation.is_some());')
        (core / 'qualification.rs').write_text(common + native)
        for name in ['proxy.rs', 'allocator.rs']:
            (core / name).write_bytes((HERE / name).read_bytes())
        qualification_path = core / 'qualification.rs'
    else:
        qualification_path = HERE / 'qualification.rs'
    library = core / 'src/lib.rs'
    lock = core / 'Cargo.lock'
    draw = core / 'src/indirect_validation/draw.rs'
    original_draw = draw.read_bytes()
    original_library = library.read_bytes()
    original_lock = lock.read_bytes()
    try:
        # A private external module can inspect invariants without adding a test
        # hook, public API, or generated delegation boilerplate to product source.
        module = '\n#[cfg(test)]\n#[allow(unused_imports, dead_code)]\n#[path = ' + json.dumps(str(qualification_path)) + ']\nmod lazy_indirect_qualification;\n'
        library.write_bytes(original_library + module.encode())
        if not args.baseline:
            pool_module = '\n#[cfg(test)]\n#[path = ' + json.dumps(str(HERE / 'pool-qualification.rs')) + ']\nmod lazy_pool_qualification;\n'
            draw.write_bytes(original_draw + pool_module.encode())
        lock.write_bytes((HERE / 'matched-core.Cargo.lock').read_bytes())
        subprocess.run(['cargo', 'test', '--locked', '--manifest-path', str(core / 'Cargo.toml'), '--features', features, '--config', patch, filter_name, '--', '--test-threads=1', '--nocapture'], cwd=REPO, env=env, check=True)
    finally:
        library.write_bytes(original_library)
        draw.write_bytes(original_draw)
        lock.write_bytes(original_lock)
