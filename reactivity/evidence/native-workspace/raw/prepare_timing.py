from pathlib import Path
import json,hashlib,subprocess,shutil,datetime,random,itertools
from collections import Counter
r=Path(__file__).parent;w=Path('/home/user/gpui-native-workspace-lab')
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()=='03ca419868b0d538e6847e59b60424a31aa32dfa'
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
for p in ['COST.json','PROCESS_ORDER.json']:
 assert (r/p).read_bytes()==subprocess.check_output(['git','show','03ca419868b0d538e6847e59b60424a31aa32dfa:reactivity/evidence/native-workspace/'+p],cwd=w)
spec=json.loads((r/'COST.json').read_text());assert sha(r/'PROCESS_ORDER.json')==spec['process_manifest_sha256']
seq=[]
for k in range(4):
 s=[(v+k)%4 for v in [0,1,3,2]];seq.extend([s,s[::-1]])
assert all(sum(s[i]==v for s in seq)==2 for i in range(4) for v in range(4))
adj=Counter((a,b) for s in seq for a,b in zip(s,s[1:]));assert len(adj)==12 and set(adj.values())=={2}
expected=[dict(mode=m,group=i,order=[spec['names'][v] for v in seq[(i+ci)%8]]) for ci,m in enumerate(spec['modes']) for i in range(8)];random.Random(spec['seed']).shuffle(expected)
assert expected==json.loads((r/'PROCESS_ORDER.json').read_text())
for n in spec['names']:
 for stage in ['capture','idle','stream','scroll','both']:
  s=json.loads((r/'preflight'/n/stage/'status.json').read_text());assert s['exit']==0 and s['failure'] is None
for x in json.loads((r/'native-image-equality.json').read_text())['comparisons']:assert x['exit']==0 and x['stderr']=='0'
records=json.loads((r/'frozen/artifacts.json').read_text());cost={}
for n,d in records.items():
 a=d['artifact'];p=Path(a['preserved']);assert sha(p)==a['sha256'];cmd=['size','-A',str(p)];q=subprocess.run(cmd,capture_output=True,text=True);assert q.returncode==0
 (r/(n+'-elf-sections.txt')).write_text(q.stdout)
 cost[n]=dict(source=d['source'],ELF_bytes=a['bytes'],sha256=a['sha256'],sections_command=cmd)
(r/'native-code-costs.json').write_text(json.dumps(dict(artifacts=cost,candidate_shipping_lines=38016,candidate_shipping_ledger_inherited_from='f7b3f60c70faf6d548fffda530d4de83b2570e34',scope='Whole native ELFs under matched fat-LTO profile; shipping/header/retained-capacity ledger inherited only by verified exact source equality. No new library/build-script/dependency/shader code.'),indent=2))
(r/'native-image-inspection.json').write_text(json.dumps(dict(inspected=['preflight/candidate/capture/native.png','preflight/zgx/capture/native.png'],font_sha256='7da195a74c55bef988d0d48f9508bd5d849425c1770dba5d7bfc6ce9ed848954',observations=['Both captures show the same controls, token content/line wrapping, row95 onward, client dimensions and panel placement.','GPUI glyph strokes appear heavier/softer than ZGX with the same font bytes. This visible difference was present in the earlier comparison and remains unresolved.'],cross_renderer_pixel_or_quality_equivalence=False),indent=2))
free=shutil.disk_usage('/home/user').free;assert free>8*1024**3
procs=subprocess.check_output(['ps','-eo','pid,etime,pcpu,comm'],text=True)
assert all(line.split()[-1] not in ['cargo','rustc','rust-lld','ld.lld','gcc','clang','cc1','clippy-driver'] for line in procs.splitlines()[1:])
(r/'timing-preflight.json').write_text(json.dumps(dict(free_bytes=free,processes=procs,utc=datetime.datetime.now(datetime.timezone.utc).isoformat(),fixed_processes=128,preflights_passed=20),indent=2))
p=r/'timing-inputs.json';assert not p.exists()
p.write_text(json.dumps(dict(scripts={n:sha(r/n) for n in ['native.py','analyze.py','verify_dossier.py','freeze.py','prepare_timing.py','COST.json','PROCESS_ORDER.json','build-gates.json','source-worktrees.json']},artifacts_sha256=sha(r/'frozen/artifacts.json'),source='03ca419868b0d538e6847e59b60424a31aa32dfa',frozen_before_timing=True),indent=2))
print('128-process native schedule and verifier frozen; 20 preflights and exact GPUI image checks pass')
print({n:v['ELF_bytes'] for n,v in cost.items()})
