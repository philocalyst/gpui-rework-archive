from pathlib import Path
import json,statistics,hashlib
r=Path(__file__).parent;definition=json.loads((r/'cost-definition.json').read_text());d=r/'matrix-allocations';records=json.loads((d/'results.json').read_text());assert len(records)==140
assert json.loads((d/'guard-after.json').read_text())==[] and not (d/'failure.txt').exists()
summary={};fields=['requests','requested_bytes','net_bytes','peak_bytes','image_bytes','copied_pixels']
for case in definition['cases']:
 summary[case]={}
 for v in definition['variants']:
  row=next(x for x in records if x['case']==case and x['variant']==v);warm=[x for x in row['rows'] if x[0]>=16];assert len(warm)==4
  setup=[line.split(',') for line in (d/(row['label']+'.out')).read_text().splitlines() if line.startswith('SETUP_ALLOC,')];assert len(setup)==2
  summary[case][v]=dict(warm={name:statistics.median(x[i+1] for x in warm) for i,name in enumerate(fields)},first_update=dict(zip(fields,row['rows'][0][1:])),mount=dict(zip(fields[:4],map(int,setup[0][3:]))),first_presentation=dict(zip(fields[:4],map(int,setup[1][3:]))))
qualification=json.loads((r/'matrix-qualification/results.json').read_text());assert len(qualification)==420
work={}
for case in definition['cases']:
 for pair in range(3):
  candidate=next(x for x in qualification if x['case']==case and x['pair']==pair and x['variant']=='candidate')
  baseline=next(x for x in qualification if x['case']==case and x['pair']==pair and x['variant']=='scroll_precise')
  assert [x[2:] for x in candidate['rows']]==[x[2:] for x in baseline['rows']],(case,pair,'changed composited/copy/image work')
 work[case]={v:{name:statistics.median(x[i] for row in qualification if row['case']==case and row['variant']==v for x in row['rows'] if x[0]>=16) for i,name in [(2,'composited_pixels'),(3,'copied_pixels'),(4,'image_bytes')]} for v in definition['variants']}
(r/'work-summary.json').write_text(json.dumps(dict(exact_candidate_precise_work_equal=True,qualification_source_sha256=hashlib.file_digest((r/'matrix-qualification/results.json').open('rb'),'sha256').hexdigest(),cases=work),indent=2))
gate=definition['allocation_gates'];verdict={}
for case in gate['cases']:
 b=summary[case][gate['reference']]['warm']['requests'];a=summary[case]['candidate']['warm']['requests'];delta=b-a
 verdict[case]=dict(reference=b,candidate=a,reduction=delta,minimum=gate['minimum_warm_request_reduction'],passed=delta>=gate['minimum_warm_request_reduction'])
result=dict(all_pass=all(x['passed'] for x in verdict.values()),gates=verdict,source_sha256=hashlib.file_digest((d/'results.json').open('rb'),'sha256').hexdigest(),scope='Invoking-thread allocator requests/bytes; four warm updates after 16 warmups, not total process or GPU allocations. First-use and retained image costs reported separately.')
(r/'allocation-summary.json').write_text(json.dumps(summary,indent=2));(r/'allocation-verdict.json').write_text(json.dumps(result,indent=2));print(json.dumps(result,indent=2));assert result['all_pass']
