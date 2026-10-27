#!/usr/bin/env python3
from pathlib import Path
import hashlib,json,re,subprocess,struct
root=Path(__file__).resolve().parent;raw=root/'raw';manifest=json.loads((root/'manifest.json').read_text())
for path,digest in manifest.items():assert hashlib.sha256((root/path).read_bytes()).hexdigest()==digest,path
expected={
 'focused-first':{'test':101},'focused-corrected':{'test':101},'focused-qualified':{'test':101},
 'focused-ime-epoch':{'test':0},'full-first':{'test':101},'full-headers':{'test':0,'clippy':101},
 'full-clippy-qualified':{'clippy':0},'native-first':{'build':0,'test':0,'port':0,'clippy':0},
 'final-failure-witness':{'test':0,'clippy':0},'final-default-witness':{'test':0},'negative':{'test':101}}
for phase,statuses in expected.items():
 d=raw/phase;assert json.loads((d/'guard-after.json').read_text())==[],phase
 for name,code in statuses.items():assert json.loads((d/(name+'.status.json')).read_text())['exit']==code,(phase,name)
def count(path):
 text=path.read_text();matches=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed;',text);assert 'test result: FAILED' not in text;return sum(int(a) for a,b in matches if int(b)==0)
assert count(raw/'full-headers/test.out')==967
assert count(raw/'native-first/test.out')==1040
assert count(raw/'native-first/port.out')==8
for phase in ['final-default-witness','final-failure-witness']:
 assert count(raw/phase/'test.out')==7
 assert 'failed_newer_pitch_preserves_older_candidate_ack_and_repairs ... ok' in (raw/phase/'test.out').read_text()
assert '0 passed; 1 failed' in (raw/'negative/test.out').read_text()
for p in (raw/'native-checks').glob('*.status.json'):
 assert json.loads(p.read_text())['exit']==0
 assert count(p.with_name(p.name.replace('.status.json','.out')))==1
assert len(list((raw/'native-checks').glob('*.status.json')))==8
assert json.loads((raw/'native-checks/guard-after.json').read_text())==[]
for phase,filename in [('reference-snapshot-mapped','reference.png'),('candidate-snapshot-mapped','candidate.png')]:
 d=raw/phase;assert json.loads((d/'guard-after.json').read_text())==[]
 image=(d/filename).read_bytes();assert image[:8]==b'\x89PNG\r\n\x1a\n' and struct.unpack('>II',image[16:24])==(960,720)
 a=json.loads((d/'artifact.json').read_text());p=Path(a['path']);assert hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256']
assert json.loads((raw/'core-lines-final.json').read_text())['core_non_test_code_lines']==36657
assert json.loads((raw/'core-lines-final.json').read_text())['source_commit']=='9d172e052ad8aac6d93a4d004b7788cc48355efc'
assert json.loads((raw/'core-lines-control.json').read_text())['core_non_test_code_lines']==36578
assert json.loads((raw/'final-test-only-change.json').read_text())['changed_paths']==['reactivity/crates/gpui/tests/line_height.rs']
summary=json.loads((raw/'machine-final/summary.json').read_text())
for variant,row in summary.items():
 a=row['artifact'];p=Path(a['path']);assert p.stat().st_size==a['bytes'] and hashlib.sha256(p.read_bytes()).hexdigest()==a['sha256']
 symbols={}
 for line in subprocess.check_output(['nm','-S','-C',str(p)],text=True).splitlines():
  m=re.match(r'^([0-9a-f]+) ([0-9a-f]+) [tT] (.+)$',line)
  if m:symbols[m[3]]=(m[1],int(m[2],16))
 for function in row['functions']:assert symbols[function['symbol']]==(function['address'],function['bytes'])
# Independently reconstruct diagnostic ink spans from the immutable PNGs.
audit=json.loads((raw/'image-audit.json').read_text())['rows']
for variant,phase,filename in [('reference','reference-snapshot-mapped','reference.png'),('candidate','candidate-snapshot-mapped','candidate.png')]:
 pixels=subprocess.check_output(['convert',str(raw/phase/filename),'-depth','8','rgb:-']);assert len(pixels)==960*720*3
 for region,(x0,y0,x1,y1,bg) in {'stream':(28,118,932,262,(25,34,48)),'title':(20,20,940,48,(16,20,28))}.items():
  spans=[]
  for y in range(y0,y1):
   active=sum(any(pixels[(y*960+x)*3+c]>bg[c]+4 for c in range(3)) for x in range(x0,x1))>=5
   if active:
    if spans and spans[-1][1]==y:spans[-1][1]=y+1
    else:spans.append([y,y+1])
  assert spans==audit[variant][region]['ink_row_spans_threshold_background_plus4']
assert audit['reference']['stream']['span_start_deltas']==audit['candidate']['stream']['span_start_deltas']==[20]*6
print(json.dumps({'verified_files':len(manifest),'full_default_tests':967,'full_native_tests':1040,'final_focused_tests_each_profile':7,'actual_native_scripts':8,'shipping_lines':36657,'shipping_delta':79,'scope':'behavior prerequisite qualified; cross-framework quality and performance remain unqualified'},indent=2))
