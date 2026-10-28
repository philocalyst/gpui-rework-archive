from pathlib import Path
import hashlib,json,os,subprocess,shutil,time
root=Path('/tmp/gpui-rapid-pointer-sol');out=Path('/tmp/gpui-pointer-niche-evidence')
h=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
env=dict(os.environ);env.pop('RUSTFLAGS',None);env.pop('CARGO_ENCODED_RUSTFLAGS',None);env.update(CARGO_BUILD_JOBS='2',CARGO_TARGET_DIR='/tmp/gpui-presented-basis-target',RUSTC_BOOTSTRAP='1')
pin=subprocess.check_output(['git','rev-parse','HEAD'],cwd=root,text=True).strip();assert pin=='6021d0009db4069e5c7f96400890baa75630f047'
keys=json.loads((root/'reactivity/evidence/rapid-pointer/baseline-4d/controls/before.json').read_text())['hashes']
files={str(root/k):h(root/k) for k in keys}
consumer=Path('/tmp/gpui-rapid-pointer-consumer/reactivity/ports/hummingbird')
for p in consumer.rglob('*'):
 if p.is_file() and ('src' in p.parts or p.name in ('Cargo.toml','Cargo.lock')):files[str(p)]=h(p)
for name in ('/tmp/gpui-rapid-pointer-native-client.py','/tmp/gpui-rapid-pointer-native-loop-client.py','/tmp/gpui-pointer-code-control/src/main.rs','/tmp/gpui-pointer-code-control/Cargo.toml','/tmp/gpui-pointer-code-control/Cargo.lock'):files[name]=h(Path(name))
meta={'source':pin,'guarded_files':len(files),'files':files,'commands':[],'generic_rustflags':'unset','build_jobs':2}
(out/'before.json').write_text(json.dumps(meta,indent=2)+'\n')
def run(name,args):
 record={'name':name,'argv':args};meta['commands'].append(record)
 with (out/(name+'.log')).open('w') as log:code=subprocess.call(args,cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT)
 record['exit']=code;(out/(name+'.exit')).write_text(str(code)+'\n');(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n')
 if code:raise SystemExit('FAILED '+name)
cargo=['cargo'];manifest=['--manifest-path','reactivity/Cargo.toml','--locked','-p','gpui']
run('native-private',cargo+['test']+manifest+['--features','native,x11','--lib','focus_release_tests','--','--nocapture'])
run('native-public',cargo+['test']+manifest+['--features','native,x11','--test','pointer','--test','pointer_focus'])
run('strict-default',cargo+['clippy']+manifest+['--all-targets','--','-D','warnings'])
run('strict-native',cargo+['clippy']+manifest+['--features','native,x11','--all-targets','--','-D','warnings'])
run('apple-library',cargo+['check']+manifest+['--features','desktop','--lib','--target','aarch64-apple-darwin','-Zbuild-std=std,panic_abort'])
run('msvc-library',cargo+['check']+manifest+['--features','desktop','--lib','--target','x86_64-pc-windows-msvc','-Zbuild-std=std,panic_abort'])
run('external-consumer-build',cargo+['build','--manifest-path',str(consumer/'Cargo.toml'),'--locked','--features','native'])
binary=Path('/tmp/gpui-pointer-niche-hb-frozen');shutil.copyfile('/tmp/gpui-presented-basis-target/debug/hummingbird-gpui-port',binary);binary.chmod(0o555)
meta['native_binary']={'path':str(binary),'bytes':binary.stat().st_size,'sha256':h(binary)}
client_args=[str(binary),'--xvfb','/nix/store/iw8dx6lhrkdc5wzszjzqzl677y68y88r-xvfb-21.1.24/bin/Xvfb','--xdotool','/nix/store/qvckv6m6ycsa8f26w0f20mzk5w4v9ciq-xdotool-4.20260303.1/bin/xdotool','--atspi-launcher','/nix/store/4g39rajyrxqn3na1kd4pykdigsr82af5-at-spi2-core-2.60.6/libexec/at-spi-bus-launcher','--renderer','cpu']
for name,client,display in [('native-original','/tmp/gpui-rapid-pointer-native-client.py',':169'),('native-loop','/tmp/gpui-rapid-pointer-native-loop-client.py',':170')]:
 run(name,['dbus-run-session','--','/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3',client]+client_args+['--display',display,'--output',str(out/(name+'.json'))])
after={k:h(Path(k)) for k in files};meta['source_unchanged']=files==after;assert files==after
(out/'metadata.json').write_text(json.dumps(meta,indent=2)+'\n');(out/'after.json').write_text(json.dumps(after,indent=2)+'\n');print(json.dumps({'passed':True,'source':pin,'guarded_files':len(files)}))
