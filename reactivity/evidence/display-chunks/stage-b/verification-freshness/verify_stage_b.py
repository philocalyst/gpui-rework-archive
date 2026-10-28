"""Independent byte-level replay of the actual root-addressed GPU workload."""
from pathlib import Path
import hashlib,json,struct,subprocess
root=Path(__file__).resolve().parent;r=root/'stage-b';p=r/'gpu-array-readback'
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def pack(v):return struct.pack('<'+'I'*len(v),*v)
def word(b,at):return struct.unpack_from('<I',b,at)[0]
manifest=read(root/'stage-b-manifest.json')
for name,h in manifest.items():assert sha(root/name)==h,name
for name in ['gpu-initial','gpu-array-readback']:
 d=r/name;assert read(d/'guard.json')==[]
 for stage in ['build','stage-a','direct-assets','jobs','gpu-serial','gpu-overlap','gpu-overlap-raw']:assert read(d/(stage+'.status.json'))['exit']==0
 assert read(d/'gpu-missing-resource-lease.status.json')['exit']==101
assert read(r/'gpu-initial/clippy.status.json')['exit']==101
assert read(p/'clippy.status.json')['exit']==0
font=read(p/'font.json');assert sha(r/'DejaVuSans.ttf')==font['sha256'] and (r/'DejaVuSans.ttf').stat().st_size==font['bytes']
art=read(p/'artifacts.json');old=read(r/'gpu-initial/artifacts.json')
for a in art.values():assert sha(Path(a['preserved']))==a['sha256'] and Path(a['preserved']).stat().st_size==a['bytes']
assert art['direct_resources']==old['direct_resources']
sr=read(p/'shader.json');shader=(r/'heap_audit.wgsl').read_bytes();elf=Path(art['heap_audit']['preserved']).read_bytes();assert elf[sr['elf_offset']:sr['elf_offset']+len(shader)]==shader and sha(r/'heap_audit.wgsl')==sr['sha256']
fresh={v['target']['name']:v['fresh'] for line in (p/'build.out').read_text().splitlines() if (v:=json.loads(line)).get('reason')=='compiler-artifact' and v['target']['name'] in ['heap_audit','direct_resources']}
assert fresh==dict(heap_audit=False,direct_resources=True)
public=read(p/'assets/direct.json');assert len(public['events'])==16
assert public['candidate_initial_snapshot_count']==public['candidate_initial_draw_enumeration_count']==1
nodes=public['initial_snapshot']['nodes'];draws=public['initial_draws'];assert len(nodes)==len(draws)==9
rects=[tuple(map(int,d['rect'])) for d in draws];colors=[int.from_bytes(bytes(int(x*255) for x in d['color']),'little') for d in draws]
target=next(i for i,n in enumerate(nodes) if n['identity']==public['target']['identity'])
def paint():
 pixels=[0xffffffff]*4096
 for (l,t,rr,b),color in zip(rects,colors):
  for y in range(t,b):
   for x in range(l,rr):pixels[y*64+x]=color
 return pack(pixels)
assert paint()==(p/'assets/initial.rgba').read_bytes()
for event in public['events']:
 assert event['target']==public['target']
 assert event['candidate_snapshot_reads']==event['candidate_draw_enumerations']==0 and event['candidate_property_reads']==1
 assert event['counters']['source_reads']==1
 assert all(event['counters'][k]==0 for k in ['owner_reruns','layout_runs','descriptions','paint_passes'])
 colors[target]=event['color'];assert paint()==(p/'assets'/event['pixels']).read_bytes()
assert [e['index'] for e in public['events'] if not e['accepted']]==[4,10]
assets=read(p/'assets/assets.json');assert len(assets['cases'])==3
for case in assets['cases']:
 assert {x['kind'] for x in case['resources']}=={'text-mask','image'}
 for resource in case['resources']:
  data=(p/'assets'/resource['file']).read_bytes();assert len(data)==resource['bytes']
  if resource['kind']=='image':
   expected=bytes(v for i in range(64) for v in [(i*3+case['index']*7)%256,(i+case['index']*13)%256,(255-i*2)%256,255]);assert data==expected
  else:assert len(data)==resource['width']*resource['height'] and any(x not in [0,255] for x in data)
frames=0;mutant_errors=0
for mode in ['serial','overlap','overlap-raw','missing-resource-lease']:
 d=p/'jobs'/mode;script=read(d/'jobs.json');ledger=read(d/'ledger.json');assert ledger['all_allocations_released'];assert len(script['frames'])==17
 memory=bytearray(script['arena_bytes']);pending={};submitted={};simulated={};executed=[];actual={};peak=0
 def execute(i):
  f=pending[i];base=f['root'];assert word(memory,base)+word(memory,base+4)==len(f['lengths'])
  data=b''.join(bytes(memory[word(memory,base+8+j*4):word(memory,base+8+j*4)+size]) for j,size in enumerate(f['lengths']))
  simulated[i]=data;executed.append(i);submitted[i]=True
 def finish(i):
  assert submitted.pop(i);del pending[i]
 for f,entry in zip(script['frames'],ledger['frames'],strict=True):
  for i in f['wait_before']:finish(i)
  payload=0
  for write in f['writes']:
   data=pack(write['words']);a=write['offset'];assert a%4==0 and a+len(data)<=len(memory);memory[a:a+len(data)]=data;payload+=len(data)
  assert payload==entry['padded_upload_bytes'];assert all(len(w['words'])*4-w['payload_bytes']<4 for w in f['writes'])
  assert entry['heap']['pending_upload_bytes']==0
  if f['id']:
   assert entry['source_counts']['identity_lookups']==1 and entry['source_counts']['rows_decoded']==9 and entry['candidate_initial_snapshot_reads']==0
  pending[f['id']]=f;peak=max(peak,len(pending));submitted[f['id']]=False
  if not f['defer']:execute(f['id'])
  for i in f['submit_deferred']:assert not submitted[i];execute(i)
 for i in script['end_waits']:finish(i)
 assert not pending
 if mode!='missing-resource-lease':
  gpu=read(p/f'gpu-{mode}.out');assert gpu['arena_bytes']==script['arena_bytes'];assert gpu['peak_pending_frames']==peak
  assert gpu['peak_queued_before_wait']==(1 if mode=='serial' else 3)
  reports={v['frame']:v for v in gpu['reports'] if 'frame' in v}
  for f in script['frames']:
   expected=(d/f['expected']).read_bytes();observed=(d/'gpu-readback'/f"readback-{f['id']}.u32").read_bytes()
   assert simulated[f['id']]==expected
   assert observed==pack(list(expected));frames+=1
   rep=reports[f['id']];assert rep['payload_bytes']==sum(len(w['words'])*4 for w in f['writes'])
   assert rep['parameter_bytes']==4*(3+len(f['lengths'])) and rep['queue_writes']==len(f['writes'])+1
 else:
  # Actual run stops at its first failed readback. Preserve all produced output;
  # the independently simulated full script is not an executed continuation.
  for file in (d/'gpu-readback').glob('readback-*.u32'):
   i=int(file.stem.split('-')[-1]);observed=file.read_bytes();assert observed==pack(list(simulated[i]));expected=(d/script['frames'][i]['expected']).read_bytes()
   errors=sum(a!=b for a,b in zip(simulated[i],expected,strict=True));mutant_errors+=errors
   if i==0:assert errors==267
  assert set(x.name for x in (d/'gpu-readback').glob('*'))=={'readback-0.u32','readback-1.u32','readback-2.u32'}
assert frames==51 and mutant_errors==267
print(json.dumps(dict(files=len(manifest),exact_gpu_root_readbacks=51,actual_resource_mutant_wrong_bytes=267,ordinary_public_source_edits=16,actual_overlap_queued=3,scope='B1/C1 subgates only: root byte lifetime and restricted offline binding; no combined display renderer, shared memory, performance or adoption claim')))
