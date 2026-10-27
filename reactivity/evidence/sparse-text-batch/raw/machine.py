from pathlib import Path
import subprocess,json,gzip,hashlib
root=Path(__file__).resolve().parent;out=root/'machine';out.mkdir(exist_ok=False);summary={}
for n,receipt in [('candidate',root/'artifact-pin/cost-artifact.json'),('control',Path('/home/user/gpui-source-batch-evidence/artifact-pin/cost-artifact.json'))]:
 artifact=json.loads(receipt.read_text());p=Path(artifact['path']);assert hashlib.sha256(p.read_bytes()).hexdigest()==artifact['sha256'];nm=subprocess.check_output(['nm','-SC','--defined-only',str(p)],text=True)
 with gzip.open(out/(n+'-symbols.txt.gz'),'wt') as f:f.write(nm)
 selectors=['::deliver_ready','::try_sparse_text','::try_patch_text','::after_text_batch','::acknowledge']
 chosen=[s for s in nm.splitlines() if any(x in s for x in selectors)]
 summary[n]={'binary':str(p),'sha256':artifact['sha256'],'bytes':p.stat().st_size,'selected':chosen}
 raw=subprocess.check_output(['objdump','-d','--demangle',str(p)],text=True);parts=raw.split('\n\n');selected='\n\n'.join(s for s in parts if s.splitlines() and any(x in s.splitlines()[0] for x in selectors))
 with gzip.open(out/(n+'-assembly.txt.gz'),'wt') as f:f.write(selected)
(out/'summary.json').write_text(json.dumps(summary,indent=2));print({n:{'bytes':s['bytes'],'routines':len(s['selected'])} for n,s in summary.items()})
