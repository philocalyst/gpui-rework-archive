from pathlib import Path
r=Path(__file__).parent
s=Path('/home/user/gpui-region-batch-evidence/verify_dossier.py').read_text()
a=s.index("for n,stages,f,total in [")
b=s.index('spec=json.loads',a)
s=s[:a]+'''for n,stages,f,total in [('gpu-precise-first',['test','clippy'],'test.out',[346,0,3]),('offline-precise',['test','clippy'],'test.out',[79,0,0]),('full-native-precise',['build','test','port','clippy'],'test.out',[1102,0,45]),('minimal-library-precise',['unit-build','port','clippy'],'unit-build.out',[328,0,25]),('default-precise',['test','clippy'],'test.out',[1009,0,13])]:
 completed(c/n,stages);assert count(c/n/f)==total,(n,count(c/n/f))
for n in ['full-native-precise','minimal-library-precise']:assert count(c/n/'port.out')==[17,0,0]
for n,total in [('native-checks-precise',11),('minimal-native-checks-precise',4)]:
 files=list((c/n).glob('*.status.json'));assert len(files)==total
 for p in files:assert json.loads(p.read_text())['exit']==0
completed(c/'cost-build-copy_bounds-retry',['build','test','gpu-test','port','clippy','gpu-clippy'])
assert count(c/'cost-build-copy_bounds-retry/test.out')==[392,0,39]
assert count(c/'cost-build-copy_bounds-retry/gpu-test.out')==[77,0,0]
assert count(c/'cost-build-copy_bounds-retry/port.out')==[17,0,0]
for n in ['control','bounds','predecessor']:
 completed(root/'raw/reused-controls'/n,['build','test','gpu-test','port','clippy','gpu-clippy'])
 completed(root/'raw/inherited'/n/'full-native',['build','test','port','clippy'])
 for p in (root/'raw/inherited'/n/'native-checks').glob('*.status.json'):assert json.loads(p.read_text())['exit']==0
assert json.loads((c/'negative-omit/test.status.json').read_text())['exit']==101
assert 'outside case=0, tick=1, format=Rgba8UnormSrgb' in (c/'negative-omit/test.log').read_text()
assert json.loads((c/'negative-authority-retry/native.status.json').read_text())['exit']==101
fault=(c/'negative-authority-retry/native.log').read_text()
assert 'native patch vs independent full GPU renderer' in fault and 'paint_tests::scroll_copy_tests::Rows' in fault
import ast
left=ast.literal_eval(next(x.strip()[6:] for x in fault.splitlines() if x.strip().startswith('left: [')))
right=ast.literal_eval(next(x.strip()[7:] for x in fault.splitlines() if x.strip().startswith('right: [')))
assert len(left)==len(right)==20480
changed=[i for i,(a,b) in enumerate(zip(left,right)) if a!=b];assert len(changed)==2893 and changed[0]==0 and (left[0],right[0])==(62,54)
''' +s[b:]
s=s.replace('len(variants)==4 and spec[\'seed\']==20261103','len(variants)==5 and spec[\'seed\']==20261104')
a=s.index('perms=list(');b=s.index("random.Random(spec['seed']).shuffle",a)
s=s[:a]+'''sequences=[]
for k in range(5):
 sequence=[(v+k)%5 for v in [0,1,4,2,3]];sequences.extend([sequence,sequence[::-1]])
sequences=sequences*2
assert all(sum(s[i]==v for s in sequences)==4 for i in range(5) for v in range(5))
assert all(sum(s.index(a)<s.index(b) for s in sequences)==10 for a,b in itertools.combinations(range(5),2))
from collections import Counter
adj=Counter((a,b) for s in sequences for a,b in zip(s,s[1:]));assert len(adj)==20 and set(adj.values())=={4}
groups=[]
for ci,case in enumerate(cases):
 for pair in range(20):groups.append([dict(case=case,pair=pair,variant=variants[v],frames=64) for v in sequences[(pair+ci)%20]])
''' +s[b:]
s=s.replace("[('qualification',336,4),('allocations',112,4),('timing',2688,64)]", "[('qualification',420,4),('allocations',140,4),('timing',2800,64)]")
a="  assert all(x[6 if phase=='allocations' else 3]==size and x[5 if phase=='allocations' else 4]==size*4 for x in row['rows'])"
b="""  copied=size;image=size*4
  if row['variant'] in ['candidate','copy_bounds'] and row['case'] in ['scroll','both','list-flat','list-tiny']:
   overlap=240 if row['case']=='list-tiny' else 355120;copied+=2*overlap;image+=4*overlap
  assert all(x[6 if phase=='allocations' else 3]==copied and x[5 if phase=='allocations' else 4]==image for x in row['rows'])"""
assert a in s;s=s.replace(a,b)
s=s.replace("for baseline in ['control','predecessor','bounds']:","for baseline in [v for v in variants if v!='candidate']:").replace('range(24)','range(20)').replace('k=24','k=20').replace("spec['thresholds'].get(case,spec['thresholds']['every_other_case'])[baseline]", "spec['thresholds'][case][baseline]")
s=s.replace("assert fail==[('stream','predecessor'),('stream-owner','predecessor')],fail", "# The verdict is derived from every fixed comparison; no expected pass/fail is supplied.")
s=s.replace("assert json.loads((c/'core-lines.json').read_text())['core_non_test_code_lines']==37613", "assert json.loads((c/'shipping-lines-candidate.json').read_text())['core_non_test_code_lines']==37977\nassert json.loads((c/'shipping-lines-copy-bounds.json').read_text())['core_non_test_code_lines']==37933")
a=" if n=='candidate':\n  q=s['region'];assert hashlib.sha256(data[q['unit_elf_offset']:q['unit_elf_offset']+q['bytes']]).hexdigest()==q['sha256']";assert a in s;s=s.replace(a,"")
s=s.replace('2688 timing/336 qualification/112 allocation','2800 timing/420 qualification/140 allocation')
(r/'verify_dossier.py').write_text(s)
compile(s,str(r/'verify_dossier.py'),'exec')
print('prepared independent five-way dossier verifier before timing')
