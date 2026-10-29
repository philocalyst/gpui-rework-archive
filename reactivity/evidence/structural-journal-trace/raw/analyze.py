from pathlib import Path
import json,sys
r=Path(__file__).parent/sys.argv[1];trace=json.loads((r/'trace/trace.json').read_text());previous={};summary=[]
def extents(nodes):
 ends=[len(nodes)]*len(nodes);stack=[]
 for i,n in enumerate(nodes):
  while stack and stack[-1]!=n['parent']:ends[stack.pop()]=i
  stack.append(i)
 return {n['identity']:[i,ends[i]] for i,n in enumerate(nodes)}
for row in trace['results']:
 case=row['case'];op=row['operation'];obs=row['observation'];logical=obs['logical'];ids={n['identity']:n for n in logical};spans=extents(logical)
 assert len(ids)==len(logical)
 if op=='failed-newer':
  assert obs['source_epoch']>obs['complete_epoch'];summary.append(dict(case=case,operation=op,work=obs['work'],eligible=row['eligible']));continue
 for suffix in ['actual','cpu','fresh','full']:
  p=r/'trace'/f'{case}-{op}.{suffix}.rgba';assert p.read_bytes()==(r/'trace'/f'{case}-{op}.actual.rgba').read_bytes() and p.stat().st_size==16384
 if op=='initial':previous[case]=row;continue
 old=previous[case];old_nodes=old['observation']['logical'];old_ids={n['identity']:n for n in old_nodes};old_spans=extents(old_nodes)
 survived=set(ids)&set(old_ids);minted=set(ids)-set(old_ids);retired=set(old_ids)-set(ids);moved=[i for i in survived if ids[i]['index']!=old_ids[i]['index']]
 work=obs['work'];assert work['reconciled']==len(logical)==work['identity_index_input'];assert work['survived']==len(survived) and work['minted']==len(minted) and work['relocated']==len(moved)
 old_bounds={n['identity']:n['bounds'] for n in row['before']['nodes']};new_bounds={n['identity']:n['bounds'] for n in row['snapshot']['nodes']}
 group=logical[2]['identity'];span=spans[group];inside={n['identity'] for n in logical[span[0]:span[1]]}
 changed_outside=[dict(identity=i,old=old_bounds[i],new=new_bounds[i]) for i in survived&set(old_bounds)&set(new_bounds)-inside if old_bounds[i]!=new_bounds[i]]
 if op in ['insert','remove']:assert changed_outside,(case,op)
 if op=='insert':
  bad=(r/'trace'/f'{case}-mutant-actual.rgba').read_bytes();good=(r/'trace'/f'{case}-mutant-expected.rgba').read_bytes();wrong=sum(a!=b for a,b in zip(bad,good));assert wrong==row['subtree_damage_mutant']['wrong_bytes'] and wrong>0
 summary.append(dict(case=case,operation=op,old_nodes=len(old_nodes),new_nodes=len(logical),survived=len(survived),minted=len(minted),retired=len(retired),relocated=len(moved),logical_node_payload_reconstructed_bytes=len(logical)*obs['node_bytes'],group_old_span=old_spans.get(group),group_new_span=span,changed_outside_group=changed_outside,work=work,counters=obs['counters'],allocations=row['allocation'],gpu=row['gpu'],identity_index_kind=obs['identity_index_kind'],identity_index_heap_bytes=obs['identity_index_heap_bytes'],subtree_damage_mutant=row['subtree_damage_mutant']))
 previous[case]=row
(r/'summary.json').write_text(json.dumps(summary,indent=2))
for s in summary:
 if s['operation']!='failed-newer':print(s['case'],s['operation'],'nodes',s['old_nodes'],s['new_nodes'],'survive/mint/retire/move',s['survived'],s['minted'],s['retired'],s['relocated'],'layout/paint',s['work']['layout_insertions'],s['work']['paint_nodes'],'upload',s['gpu']['upload_bytes'],'outside',len(s['changed_outside_group']))
