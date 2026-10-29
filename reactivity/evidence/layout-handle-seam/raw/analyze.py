from pathlib import Path
import json,sys,re
r=Path(sys.argv[1]);cases=json.loads((r/'trace/trace.json').read_text());frames=[]
for c in cases:
 before=None
 for f in c['frames']:
  prefix=f"{c['case']}-{f['operation']}";actual=(r/'trace'/f'{prefix}.actual.rgba').read_bytes();fresh=(r/'trace'/f'{prefix}.fresh.rgba').read_bytes();assert actual==fresh and f['fresh_cpu_wrong_bytes']==0
  rows=f['layout']['rows'];ids=[x['identity'] for x in rows];handles=[x['handle'] for x in rows];assert len(set(ids))==len(ids) and len(set(handles))==len(handles)
  assert f['layout']['preorder_handles_sorted'];assert sum(len(x['children']) for x in rows)==len(rows)-1
  parents={x['handle']:x['parent'] for x in rows}
  for row in rows:
   for child in row['children']:assert parents[child]==row['handle']
  comp=f['comparison'];w=f['producer']['work'];matches=[]
  if before:
   old={x['identity']:x for x in before['layout']['rows']};matches=comp['semantic_matches']
   assert comp['survived']==len(matches)==len(set(ids)&old.keys())
   for m in matches:
    prior=old[m['identity']];now=rows[m['new_rank']]
    assert m['same_handle']==(prior['handle']==now['handle']);assert m['same_own_style']==(prior['style']==now['style']);assert m['same_layout']==(prior['layout']==now['layout'])
   previous=(r/'trace'/f"{c['case']}-{before['operation']}.actual.rgba").read_bytes();assert sum(a!=b for a,b in zip(previous,actual))==f['changed_pixel_bytes']
  frames.append(dict(case=c['case'],operation=f['operation'],nodes=len(rows),work=w,surviving_handles=sum(m['same_handle'] for m in matches),own_core_style_equal_layout_changed=[m['identity'] for m in matches if m['same_own_style'] and not m['same_layout']],projected_old_handle_order_sorted=comp and comp['projected_old_survivor_handles_sorted_in_new_preorder'],changed_pixel_bytes=f['changed_pixel_bytes'],storage=f['layout']['storage'],diagnostic=f['layout']['diagnostic'],allocations={k:f[k] for k in ['source_allocation','capture_allocation','comparison_allocation','report_allocation']}))
  before=f
assert len(frames)==18
get=lambda c,o:next(f for f in frames if (f['case'],f['operation'])==(c,o))
for c in ['keyed-4','keyed-256']:
 for o in ['insert','remove','move']:
  f=get(c,o);assert f['work']['layout_rebuild_reason_bits']==2 and f['work']['layout_full_rebuilds']==1 and f['surviving_handles']==0
 assert get(c,'move')['projected_old_handle_order_sorted'] is False
assert get('keyed-256','insert')['work']['survived']==267 and get('keyed-256','insert')['work']['layout_insertions']==269
assert 10 in get('keyed-256','insert')['own_core_style_equal_layout_changed']
f=get('unkeyed-4','move');assert f['surviving_handles']==12 and f['work']['layout_computes']==0 and f['changed_pixel_bytes']==704
for o in ['replace','return']:
 f=get('resources',o);assert f['surviving_handles']==3 and f['work']['layout_insertions']==0 and f['work']['layout_explicit_dirty_calls']==2 and f['work']['layout_measure_queries']==4
for o in ['narrow','return']:
 f=get('constraints',o);assert f['surviving_handles']==4 and f['work']['layout_insertions']==0 and f['work']['layout_explicit_dirty_calls']==1
 assert set([3,4])<=set(f['own_core_style_equal_layout_changed']) and f['changed_pixel_bytes']==2544
out=dict(verdict='TRACE ONLY; existing authority seam identified; no optimization/adoption/timing',frames=frames,requirements={'semantic_to_layout_handle_retention':'existing on unchanged topology; wholesale replacement on changed ordered identities','measurement_route':'fresh preorder handles sorted; projected survivor reorder breaks binary-search assumption','cache_and_dependency_authority':'existing scheduler/invalidation; own core style or handle equality insufficient','generic_structural_journal':'missing','mixed_cpu_gpu_parity':'FAILED inherited; not rerun by fresh CPU diagnostic','speedup':'unmeasured; previous software endpoint wait-dominated'})
Path(__file__).with_name('analysis.json').write_text(json.dumps(out,indent=2)+'\n');print('verified 18 live/fresh CPU frames and semantic/qualified-handle/dependency witnesses; no GPU or timing claim')
