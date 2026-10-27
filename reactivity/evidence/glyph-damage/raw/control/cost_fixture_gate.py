from pathlib import Path
import os,sys,json,hashlib,subprocess,shutil,re
root=Path(__file__).parent;w=Path('/home/user/gpui-glyph-damage-control-lab');t=Path('/home/user/gpui-glyph-damage-control-target');out=root/sys.argv[1];out.mkdir(exist_ok=False)
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
def inputs():
 return {p:hashlib.sha256((w/p).read_bytes()).hexdigest() for p in subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=w).decode().split('\0') if p and (w/p).is_file()}
before=inputs();(out/'inputs.json').write_text(json.dumps(before));(out/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w))
base=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release']
cmds=[
 ('test',base+['test']+common+['-p','gpui','-p','gpui_canvas','--features','gpui/x11','--lib','runtime::damage_header_ledger::runtime_damage_headers','--','--exact','--nocapture']),
 ('clippy',base+['clippy']+common+['-p','gpui','-p','gpui_canvas','--features','gpui/x11','--all-targets','--','-D','warnings']),
 ('gpu-headers',base+['test']+common+['-p','gpui_gpu','--lib','renderer::retained::damage_header_ledger::retained_damage_headers','--','--exact','--nocapture']),
 ('gpu-clippy',base+['clippy']+common+['-p','gpui_gpu','--features','vulkan-tests','--all-targets','--','-D','warnings']),
]
failed=False
for name,cmd in cmds:
 assert shutil.disk_usage('/home/user').free>8*1024**3
 with (out/(name+'.out')).open('w') as a,(out/(name+'.log')).open('w') as b:p=subprocess.run(cmd,cwd=w/'reactivity',env={**os.environ,'CARGO_TARGET_DIR':str(t),'CARGO_BUILD_JOBS':'2','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','XDG_RUNTIME_DIR':'/home/user/gpui-xdg'},stdout=a,stderr=b)
 (out/(name+'.status.json')).write_text(json.dumps({'command':cmd,'exit':p.returncode}));print(name,p.returncode,flush=True)
 artifacts=[]
 for path in re.findall(r'Running [^\n]* \(([^)]+)\)',(out/(name+'.log')).read_text()):
  b=Path(path);h=hashlib.sha256(b.read_bytes()).hexdigest();d=Path('/home/user/gpui-preserved-test-binaries')/h
  if not d.exists():shutil.copy2(b,d)
  assert hashlib.sha256(d.read_bytes()).hexdigest()==h;artifacts.append(dict(path=str(b),sha256=h,preserved=str(d),bytes=b.stat().st_size))
 (out/(name+'-artifacts.json')).write_text(json.dumps(artifacts,indent=2))
 if p.returncode:failed=True;break
after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes and not failed
