from pathlib import Path
import hashlib,json,os,subprocess,shutil,time
root=Path('/tmp/gpui-inspector-pointer-sol');out=Path('/tmp/gpui-inspector-pointer-final-qualification');pin='d0bd2f4ea541cf3483c71d5e8228aea5a8a1c7cc'
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip()==pin
h=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
base=json.loads((out/'before.json').read_text())['files'];files={str(root/n):h(root/n) for n in base}
for name in ('/tmp/gpui-inspector-pointer-native-client.py','/tmp/gpui-inspector-native-fixture/Cargo.toml','/tmp/gpui-inspector-native-fixture/Cargo.lock','/tmp/gpui-inspector-native-fixture/src/main.rs'):files[name]=h(Path(name))
assert all(files[str(root/n)]==v for n,v in base.items())
env=dict(os.environ);env.pop('RUSTFLAGS',None);env.pop('CARGO_ENCODED_RUSTFLAGS',None);env.update(CARGO_BUILD_JOBS='2',CARGO_TARGET_DIR='/tmp/gpui-presented-basis-target',RUSTC_BOOTSTRAP='1')
meta={'source':pin,'files':files,'commands':[],'generic_rustflags':'unset','build_jobs':2,'guarded_files':len(files)}
(out/'broad-before.json').write_text(json.dumps(meta,indent=2)+'\n')
# Freeze the already-passing default harness hashes before the native clean.
artifacts=[]
for line in (out/'default-private.log').read_text().splitlines():
 if line.startswith('{'):
  e=json.loads(line)
  if e.get('reason')=='compiler-artifact' and e.get('executable'):
   p=Path(e['executable']);artifacts.append({'path':str(p),'sha256':h(p),'bytes':p.stat().st_size,'fresh':e['fresh']})
meta['default_test_artifacts']=artifacts

def run(name,args):
 record={'name':name,'argv':args,'start_utc':time.strftime('%Y-%m-%d %H:%M:%S UTC',time.gmtime())};meta['commands'].append(record)
 with(out/(name+'.log')).open('w')as log:code=subprocess.call(args,cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT)
 record['exit']=code;(out/(name+'.exit')).write_text(str(code)+'\n');(out/'broad-metadata.json').write_text(json.dumps(meta,indent=2)+'\n');print(name,code,flush=True)
 assert code==0,name
cargo=['cargo'];manifest=['--manifest-path','reactivity/Cargo.toml','--locked','-p','gpui']
run('clean-native',cargo+['clean','--manifest-path','reactivity/Cargo.toml','--profile','dev','-p','gpui'])
run('native-private',cargo+['test']+manifest+['--features','native,x11','--lib','focus_release_tests','--message-format=json-render-diagnostics','--','--nocapture'])
events=[json.loads(s) for s in(out/'native-private.log').read_text().splitlines() if s.startswith('{')];compiled=[e for e in events if e.get('reason')=='compiler-artifact' and e['target']['name']=='gpui'];assert compiled and all(not e['fresh'] for e in compiled);meta['native_initial_gpui_fresh']=False
for e in compiled:
 if e.get('executable'):
  p=Path(e['executable']);meta['native_test_artifact']={'path':str(p),'sha256':h(p),'bytes':p.stat().st_size}
run('native-oracle',cargo+['test']+manifest+['--features','native,x11','--lib','runtime::inspector::tests','--','--nocapture'])
run('native-public',cargo+['test']+manifest+['--features','native,x11','--test','pointer','--test','pointer_focus','--test','inspector'])
run('strict-default',cargo+['clippy']+manifest+['--all-targets','--','-D','warnings'])
run('strict-native',cargo+['clippy']+manifest+['--features','native,x11','--all-targets','--','-D','warnings'])
run('apple-library',cargo+['check']+manifest+['--features','desktop','--lib','--target','aarch64-apple-darwin','-Zbuild-std=std,panic_abort'])
run('msvc-library',cargo+['check']+manifest+['--features','desktop','--lib','--target','x86_64-pc-windows-msvc','-Zbuild-std=std,panic_abort'])
run('public-fixture-build',cargo+['build','--manifest-path','/tmp/gpui-inspector-native-fixture/Cargo.toml','--locked','--message-format=json-render-diagnostics','-vv'])
binary=Path('/tmp/gpui-inspector-pointer-native-frozen');shutil.copyfile('/tmp/gpui-presented-basis-target/debug/inspector-native-fixture',binary);binary.chmod(0o555);meta['native_binary']={'path':str(binary),'bytes':binary.stat().st_size,'sha256':h(binary)}
run('public-native-client',['dbus-run-session','--','/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3','/tmp/gpui-inspector-pointer-native-client.py',str(binary),'--output',str(out/'public-native-client.json'),'--display',':171','--xvfb','/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb','--xdotool','/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool','--atspi-launcher','/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher'])
after={n:h(Path(n))for n in files};assert after==files;meta['source_unchanged']=True;assert h(binary)==meta['native_binary']['sha256'];(out/'broad-after.json').write_text(json.dumps(after,indent=2)+'\n');(out/'broad-metadata.json').write_text(json.dumps(meta,indent=2)+'\n');print(json.dumps({'source':pin,'passed':True,'guarded_files':len(files)}),flush=True)
