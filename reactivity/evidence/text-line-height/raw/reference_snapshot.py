from pathlib import Path
import subprocess,hashlib,json,os,time,sys
root=Path(__file__).resolve().parent;out=root/('reference-snapshot-'+sys.argv[1]);out.mkdir(exist_ok=False);wt=Path('/home/user/zgx-reference-local');binary=Path('/home/user/zgx-state-target/release/examples/component_workload')
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt).decode().strip()=='a3678578980ef239058c557338ef9c544d356b0c'
assert not subprocess.check_output(['git','status','--porcelain'],cwd=wt).strip()
paths=subprocess.check_output(['git','ls-files','-z'],cwd=wt).decode().split('\0')
def inputs():return {p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in paths if p and (wt/p).is_file()}
before=inputs();(out/'inputs.json').write_text(json.dumps(before));digest=hashlib.sha256(binary.read_bytes()).hexdigest()
env={**os.environ,'DISPLAY':':94','XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4','ZGX_MODE':'idle','ZGX_SECONDS':'0','ZGX_INITIAL_TICKS':'190','ZGX_FONT_FILE':str(wt/'comparisons/fonts/DejaVuSans.ttf')}
p=None
try:
 with (out/'run.out').open('w') as a,(out/'run.log').open('w') as b:
  p=subprocess.Popen([str(binary)],env=env,stdout=a,stderr=b);deadline=time.monotonic()+30;wid=None;previous=None
  while time.monotonic()<deadline:
   assert p.poll() is None,(out/'run.log').read_text()
   if wid is None:
    r=subprocess.run(['xdotool','search','--pid',str(p.pid),'--name','zgx performance lab'],env=env,capture_output=True,text=True)
    if r.returncode==0 and r.stdout.strip():wid=r.stdout.splitlines()[0]
   if wid:
    image=out/'reference.png';capture=subprocess.run(['import','-window',wid,str(image)],env=env,capture_output=True)
    if capture.returncode:
     with (out/'capture-attempts.jsonl').open('a') as f:f.write(json.dumps({'exit':capture.returncode,'stderr':capture.stderr.decode(errors='replace')})+'\n')
     time.sleep(.3);continue
    pixel=subprocess.check_output(['convert',str(image),'-format','%[pixel:p{20,110}]','info:'],text=True).strip();data=image.read_bytes();current=hashlib.sha256(data).hexdigest()
    if pixel.endswith('(25,34,48)') and current==previous:break
    previous=current
   time.sleep(.3)
  else:raise AssertionError('reference image did not settle')
  subprocess.run(['wmctrl','-ic',hex(int(wid))],env=env,check=True);code=p.wait(timeout=15);assert code==0
 (out/'artifact.json').write_text(json.dumps({'path':str(binary),'sha256':digest,'bytes':binary.stat().st_size,'source':'a3678578980ef239058c557338ef9c544d356b0c','purpose':'idle typography only; unmatched build profiles prohibit performance comparison'},indent=2))
 after=inputs();changes=[p for p in set(before)|set(after) if before.get(p)!=after.get(p)];(out/'guard-after.json').write_text(json.dumps(changes));assert not changes and hashlib.sha256(binary.read_bytes()).hexdigest()==digest
 print('reference idle image settled, captured and closed',flush=True)
finally:
 if p is not None and p.poll() is None:p.terminate();p.wait(timeout=10)
