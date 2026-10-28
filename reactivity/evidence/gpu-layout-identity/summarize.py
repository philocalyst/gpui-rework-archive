"""Aggregate exact raw current-thread allocator records, with owner/static explicit."""
import json
from pathlib import Path
OUT=Path(__file__).resolve().parent
rows=[]
for n in [1,2,8]:
 reference=None
 for mode in ['owned','shared']:
  for label in ['numeric','lease']:
   text=(OUT/label/f'{mode}-{n}.txt').read_text().splitlines()
   fields=next(l for l in text if l.startswith('combined,'))
   row={k:int(v) for k,v in (f.split('=') for f in fields.split(',')[1:])}
   pixels=[l for l in text if l.startswith('pixels,')]
   if reference is None:reference=pixels
   assert pixels==reference,(label,mode,n)
   row.update(case=label,mode=mode,windows=n,process_static=8 if label=='numeric' else 0)
   row['retained_with_owner']=row['retained_heap']+row['owner_stack']
   row['peak_with_owner']=row['peak_heap']+row['owner_stack']
   rows.append(row)
(OUT/'summary.json').write_text(json.dumps(rows,indent=2)+'\n')
print('| Design | Windows | Mode | Requests | Heap + owner | Peak + owner | Static |')
print('| --- | ---: | --- | ---: | ---: | ---: | ---: |')
for r in rows:print(f'| {r["case"]} | {r["windows"]} | {r["mode"]} | {r["requests"]:,} | {r["retained_with_owner"]:,} B | {r["peak_with_owner"]:,} B | {r["process_static"]} B |')
