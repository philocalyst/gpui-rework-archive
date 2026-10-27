import pathlib,re,hashlib,json,subprocess,os
root=pathlib.Path(__file__).resolve().parent;out=root/'composed';wt=pathlib.Path('/home/user/gpui-sparse-outline-lab')
log=(out/'test.log').read_text();binary=pathlib.Path(re.search(r'Running unittests src/lib.rs \(([^)]*/gpui/[^)]+)\)',log).group(1));digest=hashlib.sha256(binary.read_bytes()).hexdigest()
env={'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','DBUS_SESSION_BUS_ADDRESS':'unix:path=/nonexistent'}
(out/'native-artifact.json').write_text(json.dumps({'binary':str(binary),'sha256':digest,'bytes':binary.stat().st_size,'environment':env},indent=2))
for i in range(6):
 old=json.loads(pathlib.Path(f'/home/user/gpui-source-batch-evidence/composed/native-{i}.status.json').read_text());cmd=[str(binary)]+old['command'][1:]
 with (out/f'native-{i}.out').open('w') as a,(out/f'native-{i}.log').open('w') as b:r=subprocess.run(cmd,env={**os.environ,**env},stdout=a,stderr=b,timeout=180)
 (out/f'native-{i}.status.json').write_text(json.dumps({'command':cmd,'exit':r.returncode}));assert r.returncode==0;assert '1 passed; 0 failed' in (out/f'native-{i}.out').read_text();print(i,'pass',flush=True)
before=json.loads((out/'inputs.json').read_text());changes=[p for p,h in before.items() if not (wt/p).is_file() or hashlib.sha256((wt/p).read_bytes()).hexdigest()!=h];(out/'guard-after-native.json').write_text(json.dumps(changes));assert not changes;assert hashlib.sha256(binary.read_bytes()).hexdigest()==digest
