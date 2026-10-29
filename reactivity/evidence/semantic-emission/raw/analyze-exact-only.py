from pathlib import Path
import json,sys
r=Path(__file__).parent/sys.argv[1];summaries=[]
def check(x,case):
 obs=x['observation'];store=obs['semantic_emission'];m=store['current'];rows=m['rows'];logical=obs['logical'];draws=x['scene']['draws'];deps=m['dependencies'];n=len(rows);assert n==len(logical)==len(deps)
 assert [v['identity'] for v in rows]==[v['identity'] for v in logical]
 next_draw=0
 for i,row in enumerate(rows):
  assert row['start']==next_draw;next_draw=row['end'];assert row['start']<=row['end']<=row['subtree_end']<=len(draws)
  # Independent diagnostic ancestry enumeration, never a producer adapter.
  descendants=[]
  for j in range(i,n):
   p=j
   while p is not None and p!=i:p=logical[p]['parent']
   if p==i:descendants.append(j)
  assert descendants==list(range(i,row['node_end']))
  assert row['subtree_end']==rows[row['node_end']-1]['end']
  own=draws[row['start']:row['end']]
  supports=[[d['bounds'][0],d['bounds'][1],d['bounds'][0]+d['bounds'][2],d['bounds'][1]+d['bounds'][3]] for d in own]
  support=[min(b[0] for b in supports),min(b[1] for b in supports),max(b[2] for b in supports),max(b[3] for b in supports)] if supports else None
  assert support==deps[i]['support'],(case,i,support,deps[i]['support'])
 assert next_draw==len(draws)
 assert m['work']['rows']==m['work']['stack_pushes']==m['work']['stack_pops']==n
 assert m['work']['cursor_reads']==2*n and m['work']['support_draw_visits']==len(draws)
 assert m['work']['row_bytes_written']==n*(m['row_bytes']+8)
 assert m['heap_bytes']==m['row_capacity_bytes']+m['dependency_capacity_bytes']
 assert store['retained_heap_bytes']==m['heap_bytes']+(store['previous']['heap_bytes'] if store['previous'] else 0)
 return dict(case=case,operation=x['operation'],nodes=n,draws=len(draws),zero_nodes=sum(v['start']==v['end'] for v in rows),multiple_nodes=sum(v['end']>v['start']+1 for v in rows),mapping=m,retained_mapping_heap=store['retained_heap_bytes'],mapping_header=store['store_header_bytes'],valid_lookup=store['current_lookup_matches_live_version'],gpu=x['gpu'],global_work=obs['work'],allocation=x.get('allocation'))
rows=json.loads((r/'trace/trace.json').read_text())['results'];previous={}
for x in rows:
 case=x['case'];op=x['operation']
 if op=='failed-newer':
  assert not x['observation']['semantic_emission']['current_lookup_matches_live_version'];continue
 q=check(x,case);summaries.append(q)
 for kind in ['cpu','fresh','full']:assert (r/'trace'/f'{case}-{op}.actual.rgba').read_bytes()==(r/'trace'/f'{case}-{op}.{kind}.rgba').read_bytes()
 if op in ['insert','move']:
  old=previous[case];oldrows=old['observation']['semantic_emission']['current']['rows'];newrows=q['mapping']['rows'];group=newrows[2];old_by_id={v['identity']:(i,v) for i,v in enumerate(oldrows)}
  changed=[];escaped=[]
  for i,new in enumerate(newrows):
   if new['identity'] not in old_by_id:continue
   oldi,prior=old_by_id[new['identity']]
   def normalized(draw):return {k:v for k,v in draw.items() if k!='index'}
   before=[normalized(d) for d in old['scene']['draws'][prior['start']:prior['end']]];after=[normalized(d) for d in x['scene']['draws'][new['start']:new['end']]]
   if before!=after:
    item=dict(identity=new['identity'],old_node=oldi,new_node=i,old_range=[prior['start'],prior['end']],new_range=[new['start'],new['end']],old_support=old['observation']['semantic_emission']['current']['dependencies'][oldi]['support'],new_support=q['mapping']['dependencies'][i]['support'])
    changed.append(item)
    if not (2<=i<group['node_end']):escaped.append(item)
  q['surviving_changed_output']=changed;q['outside_group_changed_output']=escaped;q['group_node_extent']=[2,group['node_end']];q['group_command_extent']=[group['start'],group['subtree_end']]
  if op=='insert':assert escaped
 previous[case]=x
variety=json.loads((r/'variety/trace.json').read_text());var=[]
for x in variety:
 q=check(x,'variety');q['one_node_one_command_wrong_rows']=x['one_node_one_command_wrong_rows'];q['resource_counts']={k:x['scene'][k] for k in ['masks','images','gradients','resource_entries','resource_handles_bytes']};q['image_draws']=sum(d['image_key'] is not None for d in x['scene']['draws']);q['glyph_draws']=sum(d['mask_key'] is not None for d in x['scene']['draws']);var.append(q)
 for kind in ['cpu','fresh','full']:assert (r/'variety'/f"{x['operation']}.actual.rgba").read_bytes()==(r/'variety'/f"{x['operation']}.{kind}.rgba").read_bytes()
result=dict(scope='actual producer event mapping, diagnostic comparison only; no reuse/publication/timing authority',structural=summaries,variety=var)
(r/'analysis.json').write_text(json.dumps(result,indent=2))
for x in summaries:
 if x['operation'] in ['insert','move']:print(x['case'],x['operation'],x['nodes'],x['draws'],'zero/multi',x['zero_nodes'],x['multiple_nodes'],'outside',x['outside_group_changed_output'],'retained',x['retained_mapping_heap'])
for x in var:print('variety',x['operation'],x['nodes'],x['draws'],'zero/multi',x['zero_nodes'],x['multiple_nodes'],'resources',x['resource_counts'])
