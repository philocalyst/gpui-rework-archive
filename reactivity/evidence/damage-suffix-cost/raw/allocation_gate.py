from pathlib import Path
import json,statistics,hashlib
r=Path(__file__).parent;spec=json.loads((r/'cost-definition.json').read_text())
records=json.loads((r/'matrix-allocations/results.json').read_text());assert len(records)==56
qualification=json.loads((r/'matrix-qualification/results.json').read_text());assert len(qualification)==168
for phase in ['allocations','qualification']:
 d=r/('matrix-'+phase);assert json.loads((d/'guard-after.json').read_text())==[] and not (d/'failure.txt').exists()
summary={};work={};verdict={};fields=['requests','requested_bytes','net_bytes','peak_bytes','image_bytes','copied_pixels']
for case in spec['cases']:
 summary[case]={}
 for v in spec['variants']:
  row=next(x for x in records if x['case']==case and x['variant']==v);warm=[x for x in row['rows'] if x[0]>=16];assert len(warm)==4
  setup=[line.split(',') for line in (r/'matrix-allocations'/(row['label']+'.out')).read_text().splitlines() if line.startswith('SETUP_ALLOC,')];assert len(setup)==2
  summary[case][v]=dict(warm={name:statistics.median(x[i+1] for x in warm) for i,name in enumerate(fields)},first_update=dict(zip(fields,row['rows'][0][1:])),mount=dict(zip(fields[:4],map(int,setup[0][3:]))),first_presentation=dict(zip(fields[:4],map(int,setup[1][3:]))))
 for pair in range(3):
  c=next(x for x in qualification if x['case']==case and x['pair']==pair and x['variant']=='candidate')
  b=next(x for x in qualification if x['case']==case and x['pair']==pair and x['variant']=='baseline')
  assert c['setup'][-2:]==b['setup'][-2:]
  assert all(x[2]<=y[2] and x[3:]==y[3:] for x,y in zip(c['rows'],b['rows'])),(case,pair,'composited support grew or copy/image changed')
 work[case]={v:{name:statistics.median(x[i] for row in qualification if row['case']==case and row['variant']==v for x in row['rows'] if x[0]>=16) for i,name in [(2,'composited_pixels'),(3,'copied_pixels'),(4,'image_bytes')]} for v in spec['variants']}
 verdict[case]={}
 for field in spec['allocation_gates']['fields']:
  b=summary[case]['baseline']['warm'][field];a=summary[case]['candidate']['warm'][field]
  verdict[case][field]=dict(reference=b,candidate=a,passed=a<=b)
sha=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
(r/'work-summary.json').write_text(json.dumps(dict(every_frame_candidate_support_no_greater=True,copy_image_exactly_equal=True,qualification_source_sha256=sha(r/'matrix-qualification/results.json'),cases=work),indent=2))
result=dict(all_pass=all(x['passed'] for case in verdict.values() for x in case.values()),gates=verdict,source_sha256=sha(r/'matrix-allocations/results.json'),scope='Invoking-thread requests/requested/net/peak bytes: four warm updates after16 warmups. Not process/driver/GPU allocations. Cold costs separately retained.')
(r/'allocation-summary.json').write_text(json.dumps(summary,indent=2));(r/'allocation-verdict.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2));assert result['all_pass']
