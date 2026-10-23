from pathlib import Path
import hashlib,json,os,signal,subprocess,sys,time
root=Path('/tmp/gpui-delivery-cost-sol');out=Path('/tmp/gpui-delivery-integration-captures')
git=['git','-c','safe.directory='+str(root),'-C',str(root)]
label=sys.argv[1]; command=sys.argv[2:]
assert command and not os.environ.get('RUSTC_BOOTSTRAP')
assert not subprocess.check_output(git+['status','--porcelain'],text=True)
paths=subprocess.check_output(git+['ls-files','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','reactivity/crates','reactivity/vendor','reactivity/ports/hummingbird'],text=True).splitlines()
paths=[p for p in paths if '/qualification/' not in p and '/evidence/' not in p and (Path(p).suffix in ('.rs','.wgsl','.toml') or Path(p).name=='Cargo.lock')]
def guard():
 return {p:hashlib.sha256((root/p).read_bytes()).hexdigest() for p in paths if (root/p).is_file()}
before=guard();(out/(label+'-before.json')).write_text(json.dumps(before,indent=2)+'\n')
info={'source':subprocess.check_output(git+['rev-parse','HEAD'],text=True).strip(),'cwd':str(root),'command':command,'environment':{k:os.environ.get(k) for k in ['RUSTC','RUSTDOC','RUSTC_BOOTSTRAP','RUSTFLAGS','CARGO_ENCODED_RUSTFLAGS','CARGO_TARGET_DIR','CARGO_BUILD_JOBS','GPUI_SPIRV_VAL','PKG_CONFIG','PKG_CONFIG_PATH']},'timeout_seconds':900,'compiler':subprocess.check_output(['rustc','-Vv'],text=True),'cargo':subprocess.check_output(['cargo','-Vv'],text=True),'note':'Functional compilation/execution gate, not performance timing; no bootstrap'}
(out/(label+'-command.json')).write_text(json.dumps(info,indent=2)+'\n')
with (out/(label+'.jsonl')).open('w') as stdout,(out/(label+'.log')).open('w') as stderr:
 p=subprocess.Popen(command,cwd=root,stdout=stdout,stderr=stderr,start_new_session=True)
 try: status=p.wait(timeout=900)
 except subprocess.TimeoutExpired:
  os.killpg(p.pid,signal.SIGTERM)
  try:p.wait(timeout=5)
  except subprocess.TimeoutExpired:os.killpg(p.pid,signal.SIGKILL);p.wait()
  status=124
(out/(label+'.exit')).write_text(str(status)+'\n')
after=guard();(out/(label+'-after.json')).write_text(json.dumps(after,indent=2)+'\n');assert before==after,'source changed'
print(json.dumps({'gate':label,'exit':status,'source':info['source'],'guard':True}),flush=True)
raise SystemExit(status)
