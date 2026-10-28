"""Independent staged-heap interpreter: codec, spatial lists, pixels and visits."""
from pathlib import Path
import json,struct,hashlib,sys
root=Path(sys.argv[1]);simulated=0;positive=0;mutants=[]
def read(p):return json.loads(p.read_text())
def packed(v):return struct.pack('<'+'I'*len(v),*v)
def words(v):return struct.unpack('<'+'I'*(len(v)//4),v)
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
assert read(root/'guard.json')==[]
for a in read(root/'artifacts.json').values():assert sha(Path(a['preserved']))==a['sha256']
for scene in ['sparse','overlap','staircase']:
 for n in [1,9,32,256,1024]:
  p=read(root/f'public/{scene}/{n}/public.json');assert len(p['initial_draws'])==n
  for e in p['events']:
   assert e['counters']['source_reads']==1
   assert e['candidate_snapshot_reads']==e['candidate_draw_enumerations']==0
   assert all(e['counters'][k]==0 for k in ['owner_reruns','layout_runs','descriptions','paint_passes'])
  assert p['events'][-1]['rejected_invalid_request']
  if scene=='staircase':
   owners=[0]*4096
   for i,d in enumerate(p['initial_draws']):
    l,t,r,b=map(int,d['rect'])
    for y in range(t,b):owners[y*64+l:y*64+r]=[i]*(r-l)
   assert set(owners)==set(range(n))
cases=read(root/'jobs/summary.json')+[dict(name='resource-control',mutant=0)]
for case in cases:
 path=root/'resource-control' if case['name']=='resource-control' else root/'jobs'/case['name'];jobs=read(path/'jobs.json');memory=bytearray(jobs['arena_bytes']);surface=[0]*4096;deferred={};actual={}
 def word(offset):
  assert offset%4==0 and 0<=offset<=len(memory)-4,(case['name'],offset,len(memory))
  return struct.unpack_from('<I',memory,offset)[0]
 def entry(pointer,key):
  if pointer==0:return 0,0
  leaf=word(pointer+key//32*4)
  return (word(leaf+key%32*8),word(leaf+key%32*8+4)) if leaf else (0,0)
 def execute(f,authority):
  global simulated
  desc=[word(f['root']+i*4) for i in range(16)];args=f['args'];mutant=args[5]&0x7fffffff
  def field(slot,col):
   if desc[5]:
    if slot//32!=desc[4]//32:return 0
    offset,count=desc[0],desc[9]
   else:offset,count=entry(desc[0],slot//32+(mutant==2))
   if mutant==3 and count:count-=1
   row=slot%32
   if offset==0 or row>=count:return 0
   if word(offset)==0:return word(offset+4+(row*12+col)*4)
   base=word(offset+4+col*12);bits=word(offset+8+col*12);start=word(offset+12+col*12)
   if bits==0:return base
   bit=row*bits;address=offset+start*4+bit//32*4;value=word(address)>>(bit%32)
   if bit%32+bits>32:value|=word(address+4)<<(32-bit%32)
   return (base+(value&((1<<bits)-1)))&0xffffffff
  decoded=[field(slot,c) for slot in range(desc[3]) for c in range(12)]
  for j in range(args[6]):
   key,length=args[7+2*j:9+2*j];offset,_=entry(desc[1],key);decoded.extend(memory[offset:offset+length])
  capacity=args[7+2*args[6]]
  def spatial(tile):
   if desc[13]==0:return []
   pointer=word(desc[13]+tile*4)
   if pointer==0:return []
   count=word(pointer);return [word(pointer+4+i*4) for i in range(count)]
  if capacity:
   for tile in range(64):
    pointer=word(desc[13]+tile*4) if desc[13] else 0;count=word(pointer) if pointer else 0
    decoded.extend([count]+[word(pointer+i*4) if i<=count else 0 for i in range(1,capacity+1)])
  visits=[0]*4096
  def paint(row,clip):
   if not row[10]:return
   l,t,r,b=clip;l=max(l,row[5]);t=max(t,row[6]);r=min(r,row[7]);b=min(b,row[8])
   if l>=r or t>=b:return
   for y in range(t,b):
    for x in range(l,r):
     color=row[9]
     if row[10]&2:
      pointer,_=entry(desc[1],row[11]);width=word(pointer);height=word(pointer+4);sums=[0]*3
      for sy in range(4):
       for sx in range(4):
        left=x-row[5]-(sx<2);top=y-row[6]-(sy<2);fx=(sx*2+5)%8;fy=(sy*2+5)%8
        for dy in range(2):
         for dx in range(2):
          xx=min(width-1,max(0,left+dx));yy=min(height-1,max(0,top+dy));value=word(pointer+8+(yy*width+xx)*4);weight=(fx if dx else 8-fx)*(fy if dy else 8-fy)
          for c in range(3):sums[c]+=((value>>(c*8))&255)//255*weight
      color=0xff000000
      for c,total in enumerate(sums):
       v=total/1024;v=12.92*v if v<=.0031308 else 1.055*v**(1/2.4)-.055;color|=int(v*255+.5)<<(c*8)
     if color>>24==255:surface[y*64+x]=color
  if mutant==1 or desc[6:8]==authority:
   l,t,r,b=args[1:5]
   for y in range(t,b):surface[y*64+l:y*64+r]=[desc[8]]*(r-l)
   if desc[13]:
    for tile in range(64):
     x=tile%8*8;y=tile//8*8;clip=(max(l,x),max(t,y),min(r,x+8),min(b,y+8));x0,y0,x1,y1=clip
     if x0>=x1 or y0>=y1:continue
     pages=spatial(tile)
     if mutant==10 and len(pages)>1:pages=pages[:-1]
     if mutant==11:pages.reverse()
     count=0
     for page in pages:
      _,rows=entry(desc[0],page);count+=rows
      for row in range(rows):paint([field(page*32+row,c) for c in range(12)],clip)
     for y in range(y0,y1):visits[y*64+x0:y*64+x1]=[count]*(x1-x0)
   else:
    slot=desc[4]
    for _ in range(desc[2]):row=[field(slot,c) for c in range(12)];paint(row,(l,t,r,b));slot=row[3]
    for y in range(t,b):visits[y*64+l:y*64+r]=[desc[2]]*(r-l)
  actual[f['id']]=(packed(decoded),packed(surface),packed(visits));simulated+=1
 for frame in jobs['frames']:
  for write in frame['writes']:
   data=packed(write['words']);memory[write['offset']:write['offset']+len(data)]=data
  if frame['defer']:deferred[frame['id']]=frame
  else:execute(frame,frame['authority'])
  for old in frame['submit_deferred']:execute(deferred.pop(old),frame['authority'])
 assert not deferred
 errors=[]
 for frame in jobs['frames']:
  i=frame['id'];audit,pixels,visits=actual[i];expected=(path/frame['expected']).read_bytes();full=(path/frame['pixels']).read_bytes();readback=path/f'gpu-readback/audit-{i}.bin'
  assert len(audit)==len(expected) and len(pixels)==16384
  if readback.exists():
   assert readback.read_bytes()==audit,(case['name'],i,'codec/spatial audit')
   assert (path/f'gpu-readback/pixels-{i}.rgba').read_bytes()==pixels,(case['name'],i,'pixels')
   assert (path/f'gpu-readback/visits-{i}.u32').read_bytes()==visits,(case['name'],i,'visits')
   e=(sum(a!=b for a,b in zip(audit,expected)),sum(a!=b for a,b in zip(pixels,full)))
   if e!=(0,0):errors.append(dict(fence=i,audit_byte_errors=e[0],pixel_byte_errors=e[1]))
  if not case['mutant']:
   assert readback.exists() and audit==expected and pixels==full
   assert sum(words(visits))==frame['expected_visits'];positive+=1
  if case['name']!='resource-control' and not case['mutant'] and not case['name'].startswith(('geometry','structural')):
   scene,n=case['name'].split('-')[:2];selected=i+2 if frame['defer'] else i
   assert full==(root/f'public/{scene}/{n}'/('initial.rgba' if selected==0 else f'paint-{selected-1}.rgba')).read_bytes()
  if case['name']=='geometry-m0':
   selected=i+2 if frame['defer'] else i
   assert full==(root/'public/geometry'/('initial.rgba' if selected==0 else f'geometry-{selected-1}.rgba')).read_bytes()
 name='gpu-resource-control' if case['name']=='resource-control' else 'gpu-'+case['name']
 assert read(root/(name+'.status.json'))['exit']==(101 if case['mutant'] else 0)
 if case['mutant']:
  assert errors and 'decode/resource/pixels differ at fence' in (root/(name+'.err')).read_text();mutants.append(dict(case=case['name'],errors=errors))
 else:assert read(path/'ledger.json')['all_released']
for n in [256,1024]:
 name=f'sparse-{n}-overlap-compressed-m0';p=root/'jobs'/name;d=read(p/'ledger.json')
 assert all(f['publication']['spatial_work']=={} for f in d['frames'][1:])
 assert sum(words((p/'gpu-readback/visits-2.u32').read_bytes()))==32768
print(json.dumps(dict(simulated_frames=simulated,exact_actual_gpu_frames=positive,cpu_tests=read(root/'checks/checks.json')['tests'],gpu_mutants=mutants,verified=True),indent=2))
