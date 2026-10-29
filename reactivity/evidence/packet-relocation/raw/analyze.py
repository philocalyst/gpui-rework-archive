from pathlib import Path
import json,struct,collections,sys
root=Path(__file__).parent
src=Path(sys.argv[1]) if len(sys.argv)>1 else root/'first/trace/trace.json'
rows=json.loads(src.read_text())
INLINE=1<<31; MARKER=0x7fc00003

def clip_meaning(frame,index):
 n=frame['clips'][index]
 # Packet lowering can collapse a chain, but equal full dependency data is sufficient here.
 return [n['rect'],n['inverse'],n['radius'],n['raster'],None if n['parent'] is None else clip_meaning(frame,n['parent'])]

def decode(frame):
 p=frame['packet']; words=p['records']; draws=frame['scene']['draws']; result=[]; used=set(); ordinal=0
 mapping=frame['observation']['semantic_emission']; assert mapping['current_lookup_matches_live_version']
 ids={i:(r['identity'],i-r['start']) for r in mapping['current']['rows'] for i in range(r['start'],r['end'])}
 assert len(ids)==len(draws)
 bank=p['groups'][0][2] if p['groups'] else 0
 # No paint bank in these fixtures; banked formats must not be silently decoded as raw colors.
 assert bank==0,('uncovered paint-bank format',frame['case'])
 for first,n,start,compact in p['groups']:
  assert first==ordinal
  assert start==len(used)
  if compact:
   used.update(range(start,start+5))
  for i in range(n):
   base=start+5+2*i if compact else start+6*i
   count=2 if compact else 6
   used.update(range(base,base+count));d=draws[ordinal]
   fields={}
   for label,word in [('local',base),('inverse_x',start if compact else base+1),('inverse_y',start+1 if compact else base+2),('clip',start+2 if compact else base+3),('color',start+3 if compact else base+4),('material',base+1 if compact else base+5)]:
    for lane in range(4):
     if label=='material' and lane==3:continue
     fields[label+str(lane)]=(word,lane,words[word][lane])
   cw=start+4 if compact else base+5;cl=0 if compact else 3
   fields['correction']=(cw,cl,words[cw][cl]); assert not words[cw][cl]&INLINE
   assert (words[cw][cl]&0x3fffffff)<len(p['corrections'])
   if compact:
    fields['common']=(base+1,3,words[base+1][3]); assert words[base+1][3]==start
    assert words[start+4][1:]==[0,0,0]
   clip=words[start+2 if compact else base+3]
   if d['clip_chain'] is not None:
    assert clip[0]==MARKER
   if d['image_key']:
    meta=dict(p['image_addresses'])[d['image_key']]
    assert fields['material0'][2]==meta[0]
   result.append(dict(identity=ids[ordinal],ordinal=ordinal,address=base|(0 if compact else INLINE),base=base,compact=bool(compact),fields=fields,scene=d))
   ordinal+=1
 end=len(used)
 assert used==set(range(end))
 expected_clip_count=len(frame['clips']) if any(d['clip_chain'] for d in draws) else 0
 assert len(words)==end+5*expected_clip_count
 for d in result:
  f=d['fields']
  if f['clip0'][2]==MARKER:
   idx=(f['clip1'][2]-end)//5
   assert f['clip1'][2]==end+5*idx and 0<=idx<expected_clip_count
   assert idx==d['scene']['clip_chain']['index']
 for i in range(expected_clip_count):
  parent=words[end+5*i+3][3]
  if parent: assert (parent-end)%5==0 and 0<=(parent-end)//5<i
 addresses={d['address'] for d in result}
 for ref in p['references']:assert ref in addresses
 for a,b in p['ranges']:
  if b==INLINE:assert a in addresses
  else:assert 0<=a<=b<=len(p['references'])
 return result,end

for f in rows:f['_draws'],f['_end']=decode(f)

def classify(a,b,x,y,name):
 da,db=x['scene'],y['scene']; fa,fb=x['fields'],y['fields']
 if name.startswith('local') or name.startswith('inverse'):
  return 'changed dependency','layout/transform or its numeric error/lowering changed'
 if name.startswith('color'):
  return 'changed content','encoded paint color or material shape parameter'
 if name=='clip1' and fa['clip0'][2]==fb['clip0'][2]==MARKER:
  ca,cb=da['clip_chain']['index'],db['clip_chain']['index']
  if clip_meaning(a,ca)==clip_meaning(b,cb):return 'relocated reference','same complete clip dependency at another packet word'
  return 'changed dependency','clip target meaning changed as well as its address'
 if name.startswith('clip'):return 'changed dependency','clip geometry or representation changed'
 if name=='common':
  names=['inverse_x','inverse_y','clip','color']
  equal=all(da[k]==db[k] for k in ['inverse','clip','color','clip_chain'])
  return ('relocated reference','same common interpretation at another physical word') if equal else ('changed dependency','common address changed and referenced interpretation also changed')
 if name=='correction':
  va,vb=fa[name][2],fb[name][2]
  equal=(va&0xc0000000)==(vb&0xc0000000) and a['packet']['corrections'][va&0x3fffffff]==b['packet']['corrections'][vb&0x3fffffff]
  return ('relocated reference','same correction payload, different ordinal') if equal else ('changed dependency','correction payload or interpretation flag changed')
 if name.startswith('material'):
  if name=='material0' and da['image_key'] and da['image_key']==db['image_key']:
   return 'relocated reference','same immutable image key, different packed suffix address'
  if name in ['material0','material1'] and da['mask_key'] and da['mask_key']==db['mask_key']:
   return 'relocated reference','same mask key, changed atlas coordinate'
  return 'changed dependency','material resource/shape/format interpretation changed'
 raise AssertionError(name)

def pair(a,b,pairs,authority):
 details=[];different_formats=[];seen=set();examples=[]
 for oi,ni in pairs:
  x,y=a['_draws'][oi],b['_draws'][ni]
  if x['compact']!=y['compact']:
   different_formats.append([oi,ni]);continue
  local=[]
  assert x['fields'].keys()==y['fields'].keys()
  for name,(ow,ol,ov) in x['fields'].items():
   nw,nl,nv=y['fields'][name]
   if ov==nv:continue
   kind,reason=classify(a,b,x,y,name)
   item=dict(field=name,old_word=ow,new_word=nw,old_lane=ol,new_lane=nl,old=ov,new=nv,kind=kind,reason=reason,old_ordinal=oi,new_ordinal=ni)
   local.append(item)
   key=(ow,ol,nw,nl)
   if key not in seen:details.append(item);seen.add(key)
  # Reconstruct each matched interpreted lane from old values plus its complete patch set.
  patched={k:v[2] for k,v in x['fields'].items()}
  for d in local:patched[d['field']]=d['new']
  assert patched=={k:v[2] for k,v in y['fields'].items()}
  if local:examples.append(dict(identity=x['identity'],new_identity=y['identity'],old_ordinal=oi,new_ordinal=ni,old_address=x['address'],new_address=y['address'],old_record=a['packet']['records'][x['base']:x['base']+(2 if x['compact'] else 6)],new_record=b['packet']['records'][y['base']:y['base']+(2 if y['compact'] else 6)],changes=local))
 return dict(authority=authority,paired_draws=len(pairs),changed_32bit_lanes=len(details),classes=dict(collections.Counter(d['kind'] for d in details)),details=details,format_changes=different_formats,examples=examples)

summaries=[]
for case in dict.fromkeys(f['case'] for f in rows):
 frames=[f for f in rows if f['case']==case]
 for a,b in zip(frames,frames[1:]):
  old={d['identity']:d['ordinal'] for d in a['_draws']};new={d['identity']:d['ordinal'] for d in b['_draws']}
  pairs=[(oi,new[k]) for k,oi in old.items() if k in new]
  aligned=pair(a,b,pairs,'surviving semantic identity plus local draw ordinal; interpretation still checked')
  aa=a['packet']['records'];bb=b['packet']['records']
  pos=sum(x!=y for aw,bw in zip(aa,bb) for x,y in zip(aw,bw))+4*abs(len(aa)-len(bb))
  entry=dict(case=case,operation=b['operation'],old_words=len(aa),new_words=len(bb),positional_changed_or_added_removed_lanes=pos,old_draws=len(a['_draws']),new_draws=len(b['_draws']),semantic=aligned,unmatched_old_draws=[v for k,v in old.items() if k not in new],unmatched_new_draws=[v for k,v in new.items() if k not in old],image_stats=b['image_stats'],diagnostic=b['diagnostic'],upload_bytes=b['gpu']['upload_bytes'])
  if case=='mixed':
   pairs=[(0,0)]+([(i,i+1) for i in range(1,9)] if b['operation']=='insert' else [(i+1,i) for i in range(1,9)])
   entry['fixture_role_pairing']=pair(a,b,pairs,'diagnostic correspondence by fixed fixture role; reminted semantic nodes are NOT authorized for reuse')
  # CSR positional edits: stable logical referent is relocation; changed contributor is a dependency change.
  oa={d['address']:d['identity'] for d in a['_draws']};na={d['address']:d['identity'] for d in b['_draws']}
  refs=[]
  for i in range(max(len(a['packet']['references']),len(b['packet']['references']))):
   x=a['packet']['references'][i] if i<len(a['packet']['references']) else None;y=b['packet']['references'][i] if i<len(b['packet']['references']) else None
   if x!=y:refs.append(dict(index=i,old=x,new=y,kind='relocated reference' if x is not None and y is not None and oa[x]==na[y] else 'changed dependency'))
  entry['csr_positional_changes']=refs
  tile_rows=[]
  def tile(frame, addresses, bounds):
   start,end=bounds
   if end==INLINE:return ('uniform',[addresses[start]],[start])
   values=frame['packet']['references'][start:end]
   return ('ordered',[addresses[v] for v in values],values)
  for index,(ar,br) in enumerate(zip(a['packet']['ranges'],b['packet']['ranges'])):
   ak,ai,av=tile(a,oa,ar);bk,bi,bv=tile(b,na,br)
   tile_rows.append(dict(tile=index,old_kind=ak,new_kind=bk,old_identities=ai,new_identities=bi,same_ordered_referents=(ak,ai)==(bk,bi),changed_addresses=sum(x!=y for x,y in zip(av,bv))+abs(len(av)-len(bv)),old_range=ar,new_range=br))
  entry['tile_referents']=tile_rows

  # Clip suffix comparison by same positional index is diagnostic only. Every lane is accounted; no claim of identity.
  clipchanges=[]
  ca=(len(aa)-a['_end'])//5;cb=(len(bb)-b['_end'])//5
  for i in range(min(ca,cb)):
   for w in range(5):
    for lane in range(4):
     x=aa[a['_end']+5*i+w][lane];y=bb[b['_end']+5*i+w][lane]
     if x==y:continue
     kind='changed dependency';reason='positional clip geometry/interpretation changed'
     if w==3 and lane==3 and x and y:
      ix=(x-a['_end'])//5;iy=(y-b['_end'])//5
      if clip_meaning(a,ix)==clip_meaning(b,iy):kind='relocated reference';reason='same parent dependency at relocated suffix word'
     clipchanges.append(dict(index=i,record_word=w,lane=lane,old=x,new=y,kind=kind,reason=reason))
  entry['clip_suffix']=dict(old_nodes=ca,new_nodes=cb,positional_changes=clipchanges,new_or_removed_nodes=abs(ca-cb))
  summaries.append(entry)
report=dict(scope='diagnostic actual CPU staging arrays; no GPU readback, pixel qualification, lifetime or speed claim',frames=len(rows),transitions=summaries,requirements={'packet_prefix_reference_interpretation':'implemented diagnostic, tested fixtures only','semantic_mapping':'existing live observer, exact version and identity; no production journal','mixed_cpu_gpu_parity':'FAILED inherited 48-byte mismatch; not rerun','paint_bank_parent_clip_gradient_relocation':'absent where not observed, source-traced only','dependency_resource_closure':'missing','submitted_version_lifetime':'source-traced current serial path; no new asynchronous lifetime implementation','coherent_shared_memory':'missing; staged writes','performance':'unmeasured'})
(root/'analysis.json').write_text(json.dumps(report,indent=2))
for x in summaries:
 p=x.get('fixture_role_pairing',x['semantic']);print(x['case'],x['operation'],'words',x['old_words'],x['new_words'],'semantic',x['semantic']['paired_draws'],x['semantic']['classes'],'role',p['classes'],'upload',x['upload_bytes'])
