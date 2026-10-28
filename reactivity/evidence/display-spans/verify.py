"""Re-derive wire costs and exact pixels/words independently of model code."""
from pathlib import Path
import hashlib,json,struct,subprocess
root=Path(__file__).resolve().parent;raw=root/'raw';p=raw/'structural-oracle'
def read(p):return json.loads(p.read_text())
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def pack(v):return struct.pack('<'+'I'*len(v),*v)
manifest=read(root/'manifest.json')
assert set(manifest)=={str(x.relative_to(root)) for x in root.rglob('*') if x.is_file() and x.name!='manifest.json'}
for name,h in manifest.items():assert sha(root/name)==h,name
for name in ['initial','corrected','invalid-transform','semantic-bounds','structural-oracle']:
 d=raw/name;assert read(d/'guard.json')==[];assert read(d/'inputs-before.json')==read(d/'inputs-after.json')
assert read(raw/'initial/build.status.json')['exit']==101
assert read(raw/'corrected/public.status.json')['exit']==101
assert read(raw/'invalid-transform/model.status.json')['exit']==1
for stage in ['build','public','model','gpu','clippy']:assert read(p/(stage+'.status.json'))['exit']==0
assert read(raw/'gpu-mutants/guard.json')==[]
art=read(p/'artifacts.json');shader=(raw/'consume.wgsl').read_bytes();sr=read(p/'shader.json')
for a in art.values():assert sha(Path(a['preserved']))==a['sha256'] and Path(a['preserved']).stat().st_size==a['bytes']
elf=Path(art['consume']['preserved']).read_bytes();assert elf[sr['elf_offset']:sr['elf_offset']+len(shader)]==shader
assert hashlib.sha256(shader).hexdigest()==sr['sha256']
built=[read_line for line in (p/'build.out').read_text().splitlines() if (read_line:=json.loads(line)).get('reason')=='compiler-artifact' and read_line['target']['name'] in ['consume','public_trace']]
assert len(built)==2 and all(not x['fresh'] for x in built)
public=read(p/'public/public-trace.json');assert public['stale_rejected'] and public['failed_newer_keeps_prior']
f={x['name']:x for x in public['frames']}
assert [len(f[n]['snapshot']['nodes']) for n in ['initial','insertion','removal']]==[9,10,9]
assert f['property']['counters']['source_reads']==1
assert all(f['property']['counters'][n]==0 for n in ['layout_runs','owner_reruns','descriptions','paint_passes'])
assert f['insertion']['counters']['owner_reruns']==f['removal']['counters']['owner_reruns']==1
for name,frame in f.items():assert (p/'public'/frame['pixels']).read_bytes()==(p/'public'/f'public-{name}-oracle.rgba').read_bytes()
# Retain the earlier apparent pass, but confirm why it cannot count as structural coverage.
old=read(raw/'semantic-bounds/public/public-trace.json')
assert [len(x['snapshot']['nodes']) for x in old['frames'] if x['name'] in ['initial','insertion','removal']]==[9,9,9]
metrics={(x['series'],x['name']):x for x in read(p/'model/metrics.json')}
gpu={(x['series'],x['job']):x for x in read(p/'gpu.out')['frames']}
checks=read(p/'model/checks.json');assert checks['codec']==dict(roundtrips=132,raw_escapes=20,width_mutant_rejected=True)
assert len(checks['mutants'])==3 and all(x['rejected'] for x in checks['mutants'])

def decode(memory,root,slot):
 b=slot//32;leaf=memory[root+b//32];page=memory[leaf+b%32]
 if memory[page]==0:return memory[page+1+slot%32*12:page+1+(slot%32+1)*12]
 fields=[]
 for c in range(12):
  base,bits,offset=memory[page+1+c*3:page+4+c*3]
  # Independent whole-column integer extraction, not the model/shader two-word algorithm.
  column=int.from_bytes(pack(memory[page+offset:page+offset+bits]),'little') if bits else 0
  fields.append(base+((column>>(slot%32*bits))&((1<<bits)-1)))
 return fields

def full_paint(rows,order,clear):
 out=[clear]*4096
 for slot in order:
  r=rows[slot]
  if not r[10] or r[9]>>24!=255:continue
  for y in range(max(0,r[6]),min(64,r[8])):
   for x in range(max(0,r[5]),min(64,r[7])):out[y*64+x]=r[9]
 return out

frames=0
for series in read(p/'model/jobs.json'):
 memory=[0];previous=[0xffffffff]*4096;oldrows=[];oldloc={};prior_roots=[]
 for job in series['jobs']:
  d=job['descriptor'];m=metrics[series['name'],job['name']];g=gpu[series['name'],job['name']]
  before=memory.copy()
  for write in job['writes']:
   assert write['offset']==len(memory);memory.extend(write['words'])
  assert memory[:len(before)]==before
  rows=[decode(memory,d[0],j) for j in range(d[4])]
  assert [x for row in rows for x in row]==job['canonical']
  slot=d[1];order=[]
  for _ in range(d[2]):
   assert slot<len(rows) and rows[slot][10];order.append(slot);slot=slot+1 if d[3]==0 else rows[slot][3]
  assert len(order)==len(set(order))
  ids=[rows[i][0] for i in order];assert len(ids)==len(set(ids))
  size={s:1 for s in order};rank={s:i for i,s in enumerate(order)}
  for s in reversed(order):
   parent=rows[s][2]
   if parent!=0xffffffff:
    assert rank[parent]<rank[s];size[parent]+=size[s]
  assert all(rows[s][4]==size[s] for s in order)
  if not d[3]:
   for s in order:
    assert all(rank[s]<rank[t]<rank[s]+size[s] for t in order if rows[t][2]==s)
  expected=full_paint(rows,order,d[12]) if d[5]==d[6] else previous
  assert pack(expected)==(p/'model'/job['pixels']).read_bytes()
  l,t,r,b=d[8:12]
  for i,(old,new) in enumerate(zip(previous,expected,strict=True)):
   assert old==new or l<=i%64<r and t<=i//64<b
  stem=series['name']+'-'+job['name']
  assert (p/'model/gpu-readback'/f'{stem}.rgba').read_bytes()==pack(expected)
  assert (p/'model/gpu-readback'/f'{stem}.words').read_bytes()==pack(job['canonical'])
  written=sum(len(x['words'])*4 for x in job['writes'])
  assert written+64==m['uploaded_bytes']==g['payload_bytes']+g['descriptor_bytes']
  assert m['queue_writes']==g['queue_writes']==len(job['writes'])+1
  assert g['gpu_arena_bytes']==series['arena_words']*4
  assert g['submissions']==1 and g['completion_waits']==2
  assert m['retained_arena_bytes']==len(memory)*4
  assert m['logical_rows_rewritten']==sum(i>=len(oldrows) or row!=oldrows[i] for i,row in enumerate(rows))
  assert m['logical_bytes_rewritten']==48*m['logical_rows_rewritten']
  loc={rows[s][0]:s for s in order}
  assert m['logical_bytes_moved']==48*sum(i in oldloc and oldloc[i]!=s for i,s in loc.items())
  assert m['layout_index_scan_nodes']==6*len(order) and m['cpu_canonical_wire_bytes_materialized']==48*len(order)
  assert m['render_record_visits']==(max(0,r-l)*max(0,b-t)*len(order) if d[5]==d[6] else 0)
  oldloc=loc;oldrows=rows;previous=expected;frames+=1
 assert len(memory)==series['arena_words']
assert frames==checks['frames']==172 and len(gpu)==frames
for status in read(raw/'gpu-mutants/summary.json'):
 d=raw/'gpu-mutants'/status['name'];assert read(d/'status.json')==status and status['exit']==101
 mutation=read(d/'mutation.json');old=mutation['original_last_job'];changed=mutation['changed_last_job']
 assert old['canonical']==changed['canonical']
 def diffs(a,b):
  if isinstance(a,dict):assert a.keys()==b.keys();return sum(diffs(a[k],b[k]) for k in a)
  if isinstance(a,list):assert len(a)==len(b);return sum(diffs(x,y) for x,y in zip(a,b))
  return int(a!=b)
 assert diffs(old,changed)==1
 assert sha(d/'jobs.json')==status['job_sha256']
 stem=mutation['positive_series']+'-'+changed['name'];actual=(d/'gpu-readback'/f'{stem}.rgba').read_bytes();expected=(d/changed['pixels']).read_bytes()
 words=(d/'gpu-readback'/f'{stem}.words').read_bytes();canonical=pack(changed['canonical'])
 assert sum(a!=b for a,b in zip(actual,expected,strict=True))==status['pixel_diff_bytes']
 assert sum(a!=b for a,b in zip(words,canonical,strict=True))==status['canonical_diff_bytes']
 assert status['pixel_diff_bytes'] or status['canonical_diff_bytes']
print(json.dumps(dict(files=len(manifest),frames=frames,codec_roundtrips=132,gpu_mutants=4,public_structural_nodes=[9,10,9],shipping_change=False,scope='Executable representation models; software Vulkan; no performance/adoption/shared-memory/hardware/competitor claim')))
