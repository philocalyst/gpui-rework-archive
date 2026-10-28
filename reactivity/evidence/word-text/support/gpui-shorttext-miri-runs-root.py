from pathlib import Path
import hashlib
import json
import os
import signal
import subprocess

root = Path('/tmp/gpui-short-text-root')
out = Path('/tmp/gpui-short-text-miri-3d6')
out.mkdir(exist_ok=False)
pin='3d6bbcde4b67b9e99fe35b23db3bf216a79835f8'
git=['git','-c',f'safe.directory={root}','-C',str(root)]
assert subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()==pin
assert not subprocess.check_output(git+['status','--porcelain'],text=True).strip()
files=[root/name for name in subprocess.check_output(git+['ls-files'],text=True).splitlines()]
guard=lambda:{str(path):hashlib.sha256(path.read_bytes()).hexdigest() for path in files}
before=guard()
(out/'before.json').write_text(json.dumps(before,indent=2)+'\n')
assert not os.environ.get('RUSTC_BOOTSTRAP')
results=[]
for target,short in [('x86_64-unknown-linux-gnu','x86_64'),('i686-unknown-linux-gnu','i686'),('s390x-unknown-linux-gnu','s390x')]:
    env=os.environ.copy()
    env['MIRI_SYSROOT']=f'/tmp/gpui-short-text-miri-sysroot-{short}'
    gates=[]
    if short!='x86_64':
        gates.append((f'{short}-setup',['cargo','miri','setup','--target',target],900,{}))
    for model,flags in [('stacked',''),('tree',' -Zmiri-tree-borrows')]:
        gates.append((f'{short}-{model}',['cargo','miri','test','--manifest-path',str(root/'Cargo.toml'),'--locked','--offline','--all-targets','--target',target,'--','--test-threads=1'],600,
                      {'MIRIFLAGS':'-Zmiri-strict-provenance -Zmiri-symbolic-alignment-check -Zmiri-seed=0'+flags}))
    for name,argv,timeout,overlay in gates:
        gate_env=env|overlay
        (out/(name+'-command.json')).write_text(json.dumps({'source':pin,'argv':argv,'timeout_seconds':timeout,'environment':{key:gate_env.get(key) for key in ['RUSTC','RUSTDOC','MIRI','MIRI_SYSROOT','MIRIFLAGS','RUST_SRC_PATH','CARGO_TARGET_DIR','CARGO_BUILD_JOBS','RUSTC_BOOTSTRAP']}},indent=2)+'\n')
        with (out/(name+'.log')).open('w') as log:
            child=subprocess.Popen(argv,cwd=root,env=gate_env,stdout=log,stderr=log,start_new_session=True)
            try:
                status=child.wait(timeout=timeout)
            except subprocess.TimeoutExpired:
                os.killpg(child.pid,signal.SIGTERM)
                try:child.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    os.killpg(child.pid,signal.SIGKILL)
                    child.wait()
                status=124
        (out/(name+'.exit')).write_text(str(status)+'\n')
        assert guard()==before
        results.append({'gate':name,'exit':status})
        (out/'results.json').write_text(json.dumps(results,indent=2)+'\n')
        print(json.dumps(results[-1]),flush=True)
        if name.endswith('-setup') and status!=0:
            break
(out/'after.json').write_text(json.dumps(guard(),indent=2)+'\n')
