from pathlib import Path
import json,subprocess,hashlib,re
r=Path(__file__).parent;w=Path('/home/user/gpui-damage-suffix-lab');source='df8ca59f69813e7dd05711fead98ed4278f1688d'
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()==source
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
gates={'gpu-initial':['test','clippy'],'full-native-initial':['build','test'],'full-native-remainder':['port','clippy'],'minimal-library-initial':['unit-build','port','clippy'],'default-initial':['test'],'default-clippy-remainder':['clippy'],'offline-initial':['test','clippy'],'native-checks-initial':[f'native-{i}' for i in range(6)]+['native-list-default','native-overscan','native-list-controlled','native_atspi_ime_cjk_preview_old_candidate_ack_and_commit','native_atspi_ime_explicit_line_height_preview_ack_and_commit'],'minimal-native-checks-initial':['native-todo','native-list-default','native-overscan','native-list-controlled']}
rows={};artifacts={}
for gate,stages in gates.items():
 d=r/gate;assert json.loads((d/'guard-after.json').read_text())==[];rows[gate]={}
 if (d/'inputs.json').exists():
  assert (d/'source.txt').read_text().strip()==source
  for p,h in json.loads((d/'inputs.json').read_text()).items():assert sha(w/p)==h,p
 for stage in stages:
  status=json.loads((d/(stage+'.status.json')).read_text());assert status['exit']==0
  totals=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',(d/(stage+'.out')).read_text());rows[gate][stage]=dict(status=status,passed=sum(int(x[0]) for x in totals),ignored=sum(int(x[2]) for x in totals))
  p=d/(stage+'-artifacts.json')
  if p.exists():
   for a in json.loads(p.read_text()):artifacts[a['sha256']]=a
for a in artifacts.values():assert sha(Path(a['preserved']))==a['sha256']
negative=r/'negative-omit';assert json.loads((negative/'guard-after.json').read_text())==[];s=json.loads((negative/'test.status.json').read_text());assert s['exit']==101 and not s['stopped'];assert 'lost reverse mismatch at 44,2' in (negative/'test.log').read_text()
(r/'qualification.json').write_text(json.dumps(dict(source=source,gates=rows,unique_executables=len(artifacts),negative=json.loads((negative/'witness.json').read_text()),limits='Correctness and cost qualification only. Native cadence, complete warm regression matrix and final ZGX/hardware gates remain outstanding. Reserve-precheck stops are preserved in original gates and completed missing stages are separate.'),indent=2));print('qualified',len(artifacts),'unique executable identities', {k:{s:v['passed'] for s,v in x.items()} for k,x in rows.items()})
