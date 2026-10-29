"""Diagnostic reversible address encoding over captured actual packet words.
No GPU implementation, journal, optimized producer, or measured performance.
The captured group directory is charged scratch; it is not a proposed runtime directory.
"""
from pathlib import Path
import json,copy,collections,sys
root=Path(__file__).parent
path=Path(sys.argv[1]) if len(sys.argv)>1 else root/'first/trace/trace.json'
frames=json.loads(path.read_text());MARKER=0x7fc00003

def sites(frame):
 groups=frame['packet']['groups'];common=[];clip=[]
 for _,n,s,c in groups:
  if c:
   common.extend((s+5+2*i+1,3,s+5+2*i) for i in range(n))
   if frame['packet']['records'][s+2][0]==MARKER:clip.append((s+2,1))
  else:
   for i in range(n):
    if frame['packet']['records'][s+6*i+3][0]==MARKER:clip.append((s+6*i+3,1))
 _,n,s,c=groups[-1];end=s+(5+2*n if c else 6*n)
 parents=[(i+3,3) for i in range(end,len(frame['packet']['records']),5) if frame['packet']['records'][i+3][3]]
 return common,clip,parents,end

def encode(frame):
 out=copy.deepcopy(frame['packet']['records']);common,clip,parents,end=sites(frame)
 for word,lane,base in common:out[word][lane]=base-out[word][lane]
 for word,lane in clip:out[word][lane]=(out[word][lane]-end)//5
 for word,lane in parents:out[word][lane]=(out[word][lane]-end)//5+1
 return out,end

def decode(frame,encoded,descriptor):
 out=copy.deepcopy(encoded);common,clip,parents,_=sites(frame)
 for word,lane,base in common:out[word][lane]=base-out[word][lane]
 for word,lane in clip:out[word][lane]=descriptor+5*out[word][lane]
 for word,lane in parents:out[word][lane]=descriptor+5*(out[word][lane]-1)
 return out

for frame in frames:
 encoded,base=encode(frame);assert decode(frame,encoded,base)==frame['packet']['records']
 frame['_encoded']=encoded;frame['_base']=base
analysis=json.loads((root/'analysis.json').read_text());results=[]
for transition in analysis['transitions']:
 case=transition['case'];new=next(i for i,f in enumerate(frames) if f['case']==case and f['operation']==transition['operation']);a,b=frames[new-1],frames[new]
 pairing=transition.get('fixture_role_pairing',transition['semantic'])
 # Compare exactly the same changed lane sites in raw and encoded alternatives.
 # Encoding only transforms reference sites, so changed non-reference sites are preserved.
 changes=[]
 for detail in pairing['details']:
  ow,ol,nw,nl=(detail[k] for k in ['old_word','old_lane','new_word','new_lane'])
  if a['_encoded'][ow][ol]!=b['_encoded'][nw][nl]:changes.append(detail)
 def identities(f):
  return {(r['identity'],i-r['start']):i for r in f['observation']['semantic_emission']['current']['rows'] for i in range(r['start'],r['end'])}
 ai,bi=identities(a),identities(b)
 pairs=[(v,bi[k]) for k,v in ai.items() if k in bi]
 if case=='mixed':pairs=[(0,0)]+([(i,i+1) for i in range(1,9)] if b['operation']=='insert' else [(i+1,i) for i in range(1,9)])
 def cells(f):
  result={}
  for first,n,start,compact in f['packet']['groups']:
   for i in range(n):
    base=start+5+2*i if compact else start+6*i
    words=list(range(start,start+5))+[base,base+1] if compact else list(range(base,base+6))
    result[first+i]=[(w,lane) for w in words for lane in range(4)]
  return result
 ac,bc=cells(a),cells(b);all_pairs=set()
 for oi,ni in pairs:
  assert len(ac[oi])==len(bc[ni])
  all_pairs.update((ow,ol,nw,nl) for (ow,ol),(nw,nl) in zip(ac[oi],bc[ni]))
 raw=sum(a['packet']['records'][ow][ol]!=b['packet']['records'][nw][nl] for ow,ol,nw,nl in all_pairs)
 encoded_count=sum(a['_encoded'][ow][ol]!=b['_encoded'][nw][nl] for ow,ol,nw,nl in all_pairs)
 assert raw==pairing['changed_32bit_lanes'] and encoded_count==len(changes), 'all unchanged and padding lanes checked too'
 same=raw-encoded_count
 stale=decode(b,b['_encoded'],a['_base'])
 wrong=sum(x!=y for aw,bw in zip(stale,b['packet']['records']) for x,y in zip(aw,bw))
 # Lossless round-trip only; source group/role snapshots are not optimized journal inputs.
 results.append(dict(case=case,operation=b['operation'],pairing=pairing['authority'],raw_changed_matched_lanes=raw,domain_changed_matched_lanes=len(changes),removed_address_lane_differences=same,descriptor_bytes=4,descriptor_changed=a['_base']!=b['_base'],raw_prefix_bytes=len(b['_encoded'])*16,encoded_prefix_plus_descriptor_bytes=len(b['_encoded'])*16+4,decoded_full_output_bytes=len(b['_encoded'])*16,group_snapshot_scratch_bytes=len(b['packet']['groups'])*32,stale_descriptor_wrong_lanes=wrong,changed_remaining_classes=dict(collections.Counter(d['kind'] for d in changes))))
report=dict(scope='actual reversible Python address encoding, diagnostic only; unchanged total full producer/GPU bytes',roundtrip_frames=len(frames),frame_roots_need_versioned_descriptor=True,clip_parent_nonzero_cases=sum(len(sites(f)[2]) for f in frames),controls='raw original prefix versus relative clip-domain/common-backdistance; CSR/images/masks/corrections unchanged',results=results)
(root/'domain-model.json').write_text(json.dumps(report,indent=2))
for r in results:print(r['case'],r['operation'],r['raw_changed_matched_lanes'],'->',r['domain_changed_matched_lanes'],'stale',r['stale_descriptor_wrong_lanes'])
