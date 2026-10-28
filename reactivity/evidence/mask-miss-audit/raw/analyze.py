from pathlib import Path
import json,re,subprocess
from guard import check
r=Path(__file__).parent;check('guard-analysis.json');order=json.loads((r/'ORDER.json').read_text());rows=[]
fields=['submission','bank_count','banked','draws','masks','unit_axes','unit_dimensions','references','mask_references','lowered_references','samples','mask_samples','lowered_samples','uniform_tiles','selected_tiles','selected_samples','selected_lowered_samples','miss_enumerated','lowered_pixel_references','whole_pixel_misses']
for o in order:
 p=r/'observations'/str(o['initial'])/o['mode'];status=json.loads((p/'status.json').read_text());assert status['exit']==0 and status['failure'] is None;s=json.loads((p/'summary.json').read_text());log=(p/'app.log').read_text();packets=[]
 for line in log.splitlines():
  if not line.startswith('MASK_PACKET,'):continue
  values=line.split(',')[1:];assert len(values)==len(fields);v={k:(x=='true' if k=='banked' else int(x)) for k,x in zip(fields,values)}
  assert v['banked']==(v['bank_count']>0) and v['unit_axes']<=v['masks']<=v['draws'] and v['unit_dimensions']<=v['masks']
  assert v['miss_enumerated']==int(v['submission']==1)
  if v['miss_enumerated']:assert 0<v['whole_pixel_misses']<v['lowered_pixel_references'] and v['lowered_pixel_references']*16==v['lowered_samples']
  else:assert v['whole_pixel_misses']==v['lowered_pixel_references']==0
  assert v['lowered_references']<=v['mask_references']<=v['references'];assert v['samples']==4096*v['references'] and v['mask_samples']==4096*v['mask_references'] and v['lowered_samples']==4096*v['lowered_references'];packets.append(v)
 assert all(not v['banked'] and v['bank_count']==0 and (v['selected_tiles']>0 if v['lowered_references'] else True) and v['selected_lowered_samples']==v['lowered_samples'] and v['selected_lowered_samples']<=v['selected_samples']<=v['samples'] for v in packets)
 assert packets and packets[0]['submission']==1 and all(a['submission']<b['submission'] for a,b in zip(packets,packets[1:]))
 comparison=None
 if o['mode']=='idle':
  q=subprocess.run(['compare','-metric','AE',str(r/f"oracle-{o['initial']}.png"),str(p/'native.png'),'null:'],capture_output=True,text=True);comparison=dict(exit=q.returncode,stdout=q.stdout,stderr=q.stderr);assert comparison==dict(exit=0,stdout='',stderr='0')
 rows.append(dict(**o,status=status,summary=s,packets=packets,image_comparison=comparison))
allp=[v for row in rows for v in row['packets']];result=dict(rows=rows,processes=len(rows),packets=len(allp),bank_counts=sorted({p['bank_count'] for p in allp}),banked_packets=sum(p['banked'] for p in allp),total_mask_references=sum(p['mask_references'] for p in allp),total_lowered_references=sum(p['lowered_references'] for p in allp),selected_packets=sum(p['selected_tiles']>0 for p in allp),selected_tiles=sum(p['selected_tiles'] for p in allp),scope='Instrumented native tile selection, planned full-packet references; no performance ratio, GPU instruction count or damage-cropped-work claim.')
(r/'analysis.json').write_text(json.dumps(result,indent=2));print(json.dumps({k:v for k,v in result.items() if k!='rows'},indent=2))
