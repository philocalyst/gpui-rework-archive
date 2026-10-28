from pathlib import Path
import json,statistics
r=Path(__file__).parent;d=json.loads((r/'cost-definition.json').read_text());p=r/'matrix-allocations';rows=json.loads((p/'results.json').read_text());assert len(rows)==140 and json.loads((p/'guard-after.json').read_text())==[];summary={}
for case in d['cases']:
 summary[case]={}
 for n in d['variants']:
  a=next(row for row in rows if row['case']==case and row['variant']==n);frames=[v for v in a['rows'] if v[0]>=16];assert len(frames)==4
  cold=[line.split(',') for line in (p/(a['label']+'.out')).read_text().splitlines() if line.startswith('SETUP_ALLOC,')];assert len(cold)==2
  fields=['count_total','bytes_total','bytes_current','bytes_max','image_bytes','copied_pixels']
  summary[case][n]={'warm':{f:statistics.median(v[i+1] for v in frames) for i,f in enumerate(fields)},'cold':{c[2]:dict(zip(fields[:4],map(int,c[3:]))) for c in cold},'first_update':dict(zip(fields,a['rows'][0][1:]))}
(r/'matrix-allocation-summary.json').write_text(json.dumps(summary,indent=2))
for case in ['stream','stream-owner','text-0-1-source','text-1000-1-owner','text-1000-4-owner']:
 print(case,{n:{k:v for k,v in a['warm'].items() if k in ['count_total','bytes_total','bytes_current','bytes_max']} for n,a in summary[case].items()})
