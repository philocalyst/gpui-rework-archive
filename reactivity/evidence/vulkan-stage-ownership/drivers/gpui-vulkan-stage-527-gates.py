from pathlib import Path
import hashlib,json,shutil,subprocess
root=Path('/tmp/gpui-vulkan-stage-ownership')
out=Path('/tmp/gpui-vulkan-stage-527-gates')
out.mkdir(exist_ok=False)
git=['git','-c',f'safe.directory={root}','-C',str(root)]
head=subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip()
paths=subprocess.check_output(git+['ls-files','reactivity/crates','reactivity/vendor','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/.cargo'],text=True).splitlines()
digest=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def guard():
 return {p:digest(root/p) for p in paths}
before=guard()
assert not subprocess.check_output(git+['diff','--name-only'],text=True).strip()
(out/'source.json').write_text(json.dumps(before,indent=2)+'\n')
rows=[json.loads(s) for s in Path('/tmp/gpui-vulkan-stage-527-render-build.jsonl').read_text().splitlines() if s.startswith('{')]
executables={}
for name in ['gpui_gpu','presentation','render']:
 matches=[r for r in rows if r.get('reason')=='compiler-artifact' and r['target']['name']==name and r.get('executable')]
 assert len(matches)==1
 source=Path(matches[0]['executable']);copy=out/name
 shutil.copyfile(source,copy);copy.chmod(0o755)
 executables[name]={'cargo_artifact':str(source),'copy':str(copy),'sha256':digest(copy)}
(out/'executables.json').write_text(json.dumps(executables,indent=2)+'\n')
commands=[(name,str(out/name)+' --nocapture --test-threads=1') for name in ['gpui_gpu','presentation','render']]+[
 ('clippy','cargo clippy --offline --locked -p gpui_gpu --features vulkan-tests --all-targets --jobs 2 -- -D warnings'),
 ('apple','RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui_gpu --features vulkan-tests --all-targets --target aarch64-apple-darwin -Zbuild-std=std,panic_abort --jobs 2'),
 ('msvc','RUSTC_BOOTSTRAP=1 cargo check --offline --locked -p gpui_gpu --features vulkan-tests --all-targets --target x86_64-pc-windows-msvc -Zbuild-std=std,panic_abort --jobs 2'),
 ('fmt','rustfmt --check --edition 2021 vendor/wgpu-hal/src/vulkan/device.rs'),
]
results=[]
for name,command in commands:
 assert guard()==before
 for binary in executables.values(): assert digest(Path(binary['copy']))==binary['sha256']
 print(json.dumps({'starting':name,'source':head}),flush=True)
 path=out/f'{name}.log'
 with path.open('w') as log:
  result=subprocess.run(['bash','-c','source /tmp/gpui-native-env.sh\nexport CARGO_BUILD_JOBS=2\nexport CARGO_TARGET_DIR=/root/gpui-ce3/reactivity/target\n'+command],cwd=root/'reactivity',stdout=log,stderr=subprocess.STDOUT)
 results.append({'case':name,'command':command,'exit':result.returncode,'log_sha256':digest(path)})
 (out/'results.json').write_text(json.dumps({'source':head,'checks':results},indent=2)+'\n')
 print(json.dumps(results[-1]),flush=True)
 assert result.returncode==0
 assert guard()==before
(out/'source-unchanged.txt').write_text(head+'\n')
