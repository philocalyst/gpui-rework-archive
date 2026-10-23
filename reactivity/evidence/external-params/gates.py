#!/usr/bin/env python3
from pathlib import Path
import hashlib,json,os,shutil,subprocess,sys
ROOT=Path(__file__).resolve().parents[2]
E=Path('/tmp/gpui-external-params-evidence/gates');E.mkdir(exist_ok=False)
CORE=ROOT/'vendor/wgpu-core'
BASE=Path('/tmp/gpui-external-params-evidence/baseline-counts/core')
env=os.environ.copy();env.pop('RUSTFLAGS',None);env.pop('CARGO_ENCODED_RUSTFLAGS',None)
env['CLIPPY_CONF_DIR']=str(ROOT.parent)
env['CARGO_BUILD_JOBS']='1';env['CARGO_TARGET_DIR']='/tmp/gpui-external-params-target';env['RUSTC_BOOTSTRAP']='1'
patch='patch.crates-io.wgpu-hal.path='+json.dumps(str(ROOT/'vendor/wgpu-hal'))
locks={p:p.read_bytes() for p in [CORE/'Cargo.lock',BASE/'Cargo.lock']}
matched=(ROOT/'evidence/lazy-indirect/matched-core.Cargo.lock').read_bytes()
source=CORE/'src/device/resource.rs';source_sha=hashlib.sha256(source.read_bytes()).hexdigest()
def run(name,core,verb,features,extra=(),lint=(),expected=0):
    assert hashlib.sha256(source.read_bytes()).hexdigest()==source_sha
    cmd=['cargo',verb,'--offline','--locked','--manifest-path',str(core/'Cargo.toml'),'--features',features,'--config',patch,'--jobs','1',*extra]
    if lint:cmd+=['--',*lint]
    (E/(name+'-command.json')).write_text(json.dumps(cmd,indent=2)+'\n')
    print('BEGIN',name,flush=True)
    with (E/(name+'.log')).open('w') as log:
        result=subprocess.run(cmd,cwd=ROOT.parent,env=env,stdout=log,stderr=subprocess.STDOUT)
    print('END',name,result.returncode,flush=True)
    (E/(name+'-exit.txt')).write_text(str(result.returncode)+'\n')
    fingerprints=E/(name+'-fingerprints');fingerprints.mkdir()
    for directory in Path(env['CARGO_TARGET_DIR']).rglob('.fingerprint/wgpu-core-*'):
        for file in directory.glob('*.json'):
            shutil.copyfile(file,fingerprints/(directory.parent.parent.name+'-'+directory.name+'-'+file.name))
    if expected is not None and result.returncode!=expected:raise SystemExit(result.returncode or 1)
    assert hashlib.sha256(source.read_bytes()).hexdigest()==source_sha
try:
    for p in locks:p.write_bytes(matched)
    run('baseline-strict',BASE,'clippy','wgsl,vulkan,noop,trace,replay',extra=['--all-targets'],lint=['-D','warnings'],expected=None)
    run('candidate-strict',CORE,'clippy','wgsl,vulkan,noop,trace,replay',extra=['--all-targets'],lint=['-D','warnings'],expected=None)
    # These categories are inherited from the pinned Core, recorded separately.
    run('candidate-scoped-strict',CORE,'clippy','wgsl,vulkan,noop,trace,replay',extra=['--all-targets'],lint=['-D','warnings','-A','clippy::result_large_err','-A','clippy::collapsible_match','-A','clippy::enum_variant_names'])
    run('linux-no-default',CORE,'check','wgsl,noop',extra=['--no-default-features'])
    for name,target,features in [('wasm-webgl','wasm32-unknown-unknown','wgsl,webgl'),('apple-metal','x86_64-apple-darwin','wgsl,metal'),('msvc-dx12','x86_64-pc-windows-msvc','wgsl,dx12')]:
        run(name,CORE,'check',features,extra=['--target',target,'-Zbuild-std=std,panic_abort'])
finally:
    for p,original in locks.items():p.write_bytes(original)
(E/'source-sha256.txt').write_text(source_sha+'\n')
