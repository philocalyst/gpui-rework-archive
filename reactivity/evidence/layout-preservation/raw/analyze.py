from pathlib import Path
import json,sys
b=Path(sys.argv[1]); cases=json.loads((b/'live/trace.json').read_text()); out=[]
for case in cases:
 for frame in case['frames']:
  w=frame['preservation']['work']; p=frame['producer']['work']; st=frame['layout']['storage']; state=frame['preservation']
  assert frame['fresh_cpu_wrong_bytes']==0
  known=sum(st[k] for k in ['layout_header_bytes','topology_bytes','lane_capacity_bytes','cache_heap_bytes','runtime_handle_capacity_bytes'])+state['state_header_bytes']+state['route_capacity_bytes']+state['pending_bytes']
  out.append(dict(case=case['case'],step=frame['step'],mode=frame['mode'],source_allocation=frame['source_allocation'],diagnostic_capture_allocation=frame['diagnostic_capture_allocation'],diagnostic_comparison_report_allocation=frame['diagnostic_comparison_report_allocation'],work=w,producer=p,known_layout_payload_bytes=known,storage=st,state_header_bytes=state['state_header_bytes'],route_capacity_bytes=state['route_capacity_bytes'],pending_bytes=state['pending_bytes'],same_handles=sum(x['same_handle'] for x in frame['comparison']['semantic_matches']) if frame['comparison'] else None,removed_generations_checked=frame['retired_handles_checked']))
index={(x['case'],x['step'],x['mode']):x for x in out}
a=index['keyed-256',1,'Automatic'];o=index['keyed-256',1,'Ordered'];ap=index['keyed-256',1,'Append']
assert a['producer']['layout_insertions']==269 and o['work']['inserted_nodes']==2 and o['same_handles']==267
assert o['producer']['layout_changed_writes']==7 and a['producer']['layout_changed_writes']==269
assert o['producer']['layout_cheap_answers']==9 and a['producer']['layout_cheap_answers']==779
assert o['work']['sibling_relinks']==1 and ap['work']['sibling_relinks']==2
assert o['work']['sibling_checks']==269 and o['work']['correspondence_checks']==269
assert o['route_capacity_bytes']==0
assert index['measured',1,'Ordered']['route_capacity_bytes']==96
assert index['unkeyed-4',3,'Ordered']['producer']['layout_computes']==0
for c in ['resources','constraints']:
 for step in [1,2]:
  z=index[c,step,'Ordered'];assert z['work']['plan_allocations']==0 and z['producer']['layout_measure_queries']>0
faults=json.loads((b/'faults/trace.json').read_text());assert len(faults)==4
for f in faults:
 if f['case']=='failed-newer':assert f['failure']['committed'] is None and f['recovery']['work']['layout_full_rebuilds']==1 and f['older_ack_accepted']
 if f['case']=='wrong-route':assert 'PresentationPanicked' in f['rejected'] and f['older_ack_accepted']
 if f['case']=='poison-recovery':assert f['producer']['work']['layout_full_rebuilds']==1
result=dict(scope='84 feature-selector CPU layout/pixel frames against fresh/full reconstruction; no timing, GPU parity or adoption',frames=len(out),rows=out,faults=faults)
assert len(out)==84
(Path(__file__).parent/'analysis.json').write_text(json.dumps(result,indent=2)+'\n')
print('analyzed 84 frames and four failure/routing cases')
