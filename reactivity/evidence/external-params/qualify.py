#!/usr/bin/env python3
"""Freeze a private delegated Core probe, restore instrumentation, then execute it."""
from pathlib import Path
import argparse, hashlib, io, json, os, shutil, subprocess, tarfile
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[1]
PIN='4de6a23d70bbd3babae6902fc877cb900fb20599'
p=argparse.ArgumentParser()
p.add_argument('--baseline',action='store_true')
p.add_argument('--counts',action='store_true')
a=p.parse_args()
name=('baseline' if a.baseline else 'candidate')+('-counts' if a.counts else '-tests')
EVIDENCE=Path('/tmp/gpui-external-params-evidence')/name
EVIDENCE.mkdir(parents=True,exist_ok=False)
CORE=ROOT/'vendor/wgpu-core'
if a.baseline:
    CORE=EVIDENCE/'core'
    archive=subprocess.check_output(['git','-c',f'safe.directory={ROOT.parent}','-C',str(ROOT.parent),'archive',PIN,'reactivity/vendor/wgpu-core'])
    with tarfile.open(fileobj=io.BytesIO(archive)) as files:
        for member in files.getmembers():
            parts=Path(member.name).parts[3:]
            if not parts:continue
            member.name=str(Path(*parts)); files.extract(member,CORE,filter='data')
qualification=(HERE/'qualification.rs').read_text()
if a.baseline:
    qualification=qualification.replace('device.default_external_texture_params_buffer.as_deref()', 'Some(device.default_external_texture_params_buffer.as_ref())')
    qualification=qualification.replace('assert!(params(&device).is_none());','assert!(params(&device).is_some());')
    # Same observer and work; baseline owns the old buffer plus staging upload.
    qualification=qualification.replace('assert!(events.maps.lock().unwrap().is_empty());','assert_eq!(events.maps.lock().unwrap().len(), 0);')
    qualification=qualification.replace('assert!(events.copies.lock().unwrap().is_empty());','assert_eq!(events.copies.lock().unwrap().len(), 1);')
    qualification=qualification.replace('assert_eq!(events.buffers.lock().unwrap().len(), 1);','assert_eq!(events.buffers.lock().unwrap().len(), 3);')
(EVIDENCE/'qualification.rs').write_text(qualification)
for file in ['proxy.rs','encoder-proxy.rs','allocator.rs']:
    shutil.copyfile(HERE/file,EVIDENCE/file)
resource=CORE/'src/device/resource.rs'; lock=CORE/'Cargo.lock'
original=resource.read_bytes(); original_lock=lock.read_bytes()
(EVIDENCE/'shipping-resource.rs').write_bytes(original)
env=os.environ.copy()
env.pop('RUSTFLAGS',None);env.pop('CARGO_ENCODED_RUSTFLAGS',None)
env['CARGO_BUILD_JOBS']='1';env['CARGO_TARGET_DIR']='/tmp/gpui-external-params-target'
features='wgsl,vulkan,noop' if a.counts else 'wgsl,vulkan,noop,trace,replay'
common=['--offline','--locked','--manifest-path',str(CORE/'Cargo.toml'),'--features',features,'--config','patch.crates-io.wgpu-hal.path='+json.dumps(str(ROOT/'vendor/wgpu-hal'))]
try:
    resource.write_bytes(original+('\n#[cfg(test)]\n#[allow(unused_imports, dead_code)]\n#[path = '+json.dumps(str(EVIDENCE/'qualification.rs'))+']\nmod external_params_qualification;\n').encode())
    lock.write_bytes((ROOT/'evidence/lazy-indirect/matched-core.Cargo.lock').read_bytes())
    subprocess.run(['cargo','clean','--manifest-path',str(CORE/'Cargo.toml'),'-p','wgpu-core','--config',common[-1]],cwd=ROOT.parent,env=env,check=True,stdout=(EVIDENCE/'clean.log').open('w'),stderr=subprocess.STDOUT)
    command=['cargo','test',*common,'--no-run','--message-format=json','--jobs','1']
    (EVIDENCE/'command.json').write_text(json.dumps(command,indent=2)+'\n')
    with (EVIDENCE/'artifacts.jsonl').open('w') as stdout,(EVIDENCE/'build.log').open('w') as stderr:
        result=subprocess.run(command,cwd=ROOT.parent,env=env,stdout=stdout,stderr=stderr)
    if result.returncode:raise SystemExit(result.returncode)
    artifacts=[json.loads(line) for line in (EVIDENCE/'artifacts.jsonl').read_text().splitlines()]
    artifact=next(x for x in artifacts if x.get('reason')=='compiler-artifact' and x.get('executable') and x['target']['name']=='wgpu_core' and x['profile']['test'])
    assert not artifact['fresh'],artifact
    shutil.copyfile(artifact['executable'],EVIDENCE/'probe');(EVIDENCE/'probe').chmod(0o555)
    fp=EVIDENCE/'fingerprints';fp.mkdir()
    for directory in (Path(env['CARGO_TARGET_DIR'])/'debug/.fingerprint').glob('wgpu-core-*'):
        for file in directory.glob('*.json'):
            shutil.copyfile(file,fp/(directory.name+'-'+file.name))
    (EVIDENCE/'rustc.txt').write_bytes(subprocess.check_output(['rustc','-vV'],env=env))
    (EVIDENCE/'source-guards.json').write_text(json.dumps({str(file):hashlib.sha256(file.read_bytes()).hexdigest() for file in [resource,lock,ROOT.parent/'.cargo/config.toml',HERE/'qualify.py',EVIDENCE/'qualification.rs',EVIDENCE/'probe']},indent=2)+'\n')
finally:
    resource.write_bytes(original);lock.write_bytes(original_lock)
filter_name='external_constructor_counts_headers_and_drop' if a.counts or a.baseline else 'external_'
with (EVIDENCE/'run.log').open('w') as output:
    result=subprocess.run([str(EVIDENCE/'probe'),filter_name,'--test-threads=1','--nocapture'],cwd=ROOT.parent,env=env,stdout=output,stderr=subprocess.STDOUT)
print(str(EVIDENCE), 'exit', result.returncode, flush=True)
raise SystemExit(result.returncode)
