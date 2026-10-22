from pathlib import Path
import hashlib,json,subprocess

root=Path('/root/gpui-ce3')
out=Path('/tmp/gpui-auto-blank-checks')
out.mkdir(exist_ok=False)
git=['git','-c',f'safe.directory={root}','-C',str(root)]
head=subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()
paths=subprocess.check_output(git+['ls-files','reactivity/crates','reactivity/vendor','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/.cargo'],text=True).splitlines()
digest=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def guard():
    return {p:digest(root/p) for p in paths}
before=guard()
(out/'source.json').write_text(json.dumps(before,indent=2)+'\n')
commands=[
    ('units','/tmp/gpui-auto-blank-native-test-bin --test-threads=4'),
    ('clippy','cargo clippy --offline --locked -p gpui --features desktop,x11,wayland,gpui_canvas/parallel,cephal/verify-cache --all-targets --jobs 2 -- -D warnings'),
    ('apple','RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui --features desktop,gpui_canvas/parallel --all-targets --target aarch64-apple-darwin -Zbuild-std=std,panic_abort --jobs 2'),
    ('msvc','RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui --features desktop,gpui_canvas/parallel --all-targets --target x86_64-pc-windows-msvc -Zbuild-std=std,panic_abort --jobs 2'),
    ('fmt','cargo fmt --check -p gpui'),
]
rows=[]
for name,command in commands:
    assert guard()==before
    print(json.dumps({'starting':name,'source':head}),flush=True)
    path=out/f'{name}.log'
    with path.open('w') as log:
        r=subprocess.run(['bash','-c','source /tmp/gpui-native-env.sh\nexport CARGO_BUILD_JOBS=2\n'+command],cwd=root/'reactivity',stdout=log,stderr=subprocess.STDOUT)
    rows.append({'case':name,'command':command,'exit':r.returncode,'log_sha256':digest(path)})
    (out/'checks.json').write_text(json.dumps({'source':head,'checks':rows},indent=2)+'\n')
    print(json.dumps(rows[-1]),flush=True)
    assert r.returncode==0
    assert guard()==before
(out/'source-unchanged.txt').write_text(head+'\n')
