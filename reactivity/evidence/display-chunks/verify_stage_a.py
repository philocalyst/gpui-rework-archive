from pathlib import Path
import hashlib,json,subprocess,sys,tempfile,shutil,os
root=Path(__file__).resolve().parent;r=root/'stage-a'
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
manifest=read(root/'stage-a-manifest.json')
for name,h in manifest.items():assert sha(root/name)==h,name
for name in ['initial','bounded-journal','authority-damage','coincident-authority']:
 d=r/name;assert read(d/'guard.json')==[] and read(d/'status.json')['exit']==0
 assert (d/'source.txt').read_text().strip() in ['757ee25d743b8f4e7e932ebda7844e69e49b0867','1985c8022de682573953e44e17bd7932c4754620','47f526141c359b8e949dcb98b87172a9454124d2','d26605f251cf4979552ab14a0d3ce8b624b790bd']
expected=read(r/'coincident-authority/model/results.json')
assert expected['tests']==2834 and expected['index_mutant_rejected'] and expected['lease_mutant_rejected']
assert expected['lifetime'][-1]['arena_high_water']==2400 and expected['lifetime'][-1]['pending_upload_bytes']==0
assert len(expected['backpressure'])==40
assert sha(Path(sys.executable))==read(r/'python.json')['executable_sha256']
with tempfile.TemporaryDirectory(prefix='gpui-chunks-verify-') as tmp:
 t=Path(tmp)
 for name in ['chunks.py','experiment.py']:shutil.copy2(r/name,t/name)
 p=subprocess.run([sys.executable,str(t/'chunks.py'),str(t/'out')],capture_output=True,text=True,env=dict(os.environ,PYTHONDONTWRITEBYTECODE='1'))
 assert p.returncode==0,p.stderr
 actual=read(t/'out/results.json');assert actual==expected
print(json.dumps(dict(files=len(manifest),deterministic_checks=2834,mutants=2,stages_B_C_pending=True,scope='Stage A model checkpoint, no actual GPU/resource/public binding qualification')))
