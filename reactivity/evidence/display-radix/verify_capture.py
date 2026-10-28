"""Independent replay of staged heap memory, decode, authority and final pixels.
Does not import candidate code or use candidate pixel output as its renderer.
"""
from pathlib import Path
import json,struct,hashlib,sys,math
root=Path(sys.argv[1]);checked=0;mutants=[]
def read(p):return json.loads(p.read_text())
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def integers(data):return list(struct.unpack('<'+'I'*(len(data)//4),data))
def packed(v):return struct.pack('<'+'I'*len(v),*v)
assert read(root/'guard.json')==[]
for name,a in read(root/'artifacts.json').items():assert sha(Path(a['preserved']))==a['sha256']
assert read(root/'clippy.status.json')['exit']==0
for n in [1,9,32,256,1024]:
 p=read(root/f'public/{n}/public.json');assert p['n']==len(p['initial_draws'])==n
 for e in p['events']:
  assert e['candidate_snapshot_reads']==e['candidate_draw_enumerations']==0
  assert e['candidate_property_reads']==e['counters']['source_reads']==1
  for k in ['owner_reruns','layout_runs','descriptions','paint_passes']:assert e['counters'][k]==0
 assert p['events'][-1]['rejected_invalid_request']
for case in read(root/'jobs/summary.json'):
 directory=root/'jobs'/case['name'];jobs=read(directory/'jobs.json');ledger=read(directory/'ledger.json');memory=bytearray(jobs['arena_bytes']);surface=[0]*4096;deferred={};actual={};errors=[]
 def word(byte):return struct.unpack_from('<I',memory,byte)[0]
 def entry(pointer,key):
  if not pointer:return 0,0
  leaf=word(pointer+(key//32)*4)
  return (word(leaf+(key%32)*8),word(leaf+(key%32)*8+4)) if leaf else (0,0)
 def command(f,auth):
  global checked
  args=f['args'];rp=f['root'];desc=[word(rp+i*4) for i in range(16)];mutation=args[5]
  def field(slot,col):
   if desc[5]:
    if slot//32!=desc[4]//32:return 0
    pointer,count=desc[0],desc[9]
   else:pointer,count=entry(desc[0],slot//32+(mutation==2))
   if mutation==3 and count:count-=1
   row=slot%32
   if not pointer or row>=count:return 0
   if word(pointer)==0:return word(pointer+4+(row*12+col)*4)
   base=word(pointer+4+col*12);bits=word(pointer+8+col*12);at=word(pointer+12+col*12)
   if not bits:return base
   bit=row*bits;address=pointer+at*4+(bit//32)*4
   value=word(address)>>(bit%32)
   if bit%32+bits>32:value|=word(address+4)<<(32-bit%32)
   return (base+(value&((1<<bits)-1)))&0xffffffff
  decoded=[field(slot,c) for slot in range(desc[3]) for c in range(12)]
  for j in range(args[6]):
   key,length=args[7+j*2:9+j*2];offset,_=entry(desc[1],key);decoded.extend(memory[offset:offset+length])
  if mutation==1 or desc[6:8]==auth:
   l,t,r,b=args[1:5]
   for y in range(t,b):
    for x in range(l,r):surface[y*64+x]=desc[8]
   slot=desc[4]
   for _ in range(desc[2]):
    row=[field(slot,c) for c in range(12)];left,top,right,bottom=row[5:9]
    if row[10] and (row[10]&2 or row[9]>>24==255):
     for y in range(max(t,top),min(b,bottom)):
      for x in range(max(l,left),min(r,right)):
       color=row[9]
       if row[10]&2:
        pointer,length=entry(desc[1],row[11]);width=word(pointer);height=word(pointer+4);sum_rgb=[0,0,0]
        for sy in range(4):
         for sx in range(4):
          px=x-left-(sx<2);py=y-top-(sy<2);fx=(sx*2+5)%8;fy=(sy*2+5)%8
          for dy in range(2):
           for dx in range(2):
            xx=max(0,min(width-1,px+dx));yy=max(0,min(height-1,py+dy));texel=word(pointer+8+4*(yy*width+xx));weight=(fx if dx else 8-fx)*(fy if dy else 8-fy)
            for c in range(3):sum_rgb[c]+=((texel>>(8*c))&255)//255*weight
        color=0xff000000
        for c,total in enumerate(sum_rgb):
         value=total/1024;encoded=12.92*value if value<=0.0031308 else 1.055*value**(1/2.4)-0.055;color|=int(encoded*255+0.5)<<(c*8)
       surface[y*64+x]=color
    slot=row[3]
  actual[f['id']]=(packed(decoded),packed(surface));checked+=1
 for frame in jobs['frames']:
  for w in frame['writes']:
   data=packed(w['words']);memory[w['offset']:w['offset']+len(data)]=data
  if frame['defer']:deferred[frame['id']]=frame
  else:command(frame,frame['authority'])
  for old in frame['submit_deferred']:command(deferred.pop(old),frame['authority'])
 assert not deferred
 # Positive readbacks must agree with independent staged-memory execution and
 # captured full GPUI/Canvas pixels. Mutants must fail that full oracle, not crash.
 for frame in jobs['frames']:
  i=frame['id'];audit,pixels=actual[i];expected=(directory/frame['expected']).read_bytes();full=(directory/frame['pixels']).read_bytes();err=(sum(a!=b for a,b in zip(audit,expected)),sum(a!=b for a,b in zip(pixels,full)))
  assert len(audit)==len(expected) and len(pixels)==len(full)==16384
  path=directory/f'gpu-readback/audit-{i}.bin'
  if path.exists():
   assert path.read_bytes()==audit,(case['name'],i,'audit simulation')
   assert (directory/f'gpu-readback/pixels-{i}.rgba').read_bytes()==pixels,(case['name'],i,'pixel simulation')
   if err!=(0,0):errors.append(dict(fence=i,audit_byte_errors=err[0],pixel_byte_errors=err[1]))
  if not case['mutant']:assert path.exists() and err==(0,0)
 if case['mutant']:
  assert errors and read(root/f"gpu-{case['name']}.status.json")['exit']==101
  assert 'decode/resource/pixels differ at fence' in (root/f"gpu-{case['name']}.err").read_text()
  mutants.append(dict(case=case['name'],errors=errors))
 else:
  assert ledger['all_released'] and read(root/f"gpu-{case['name']}.status.json")['exit']==0
  assert read(root/f"gpu-{case['name']}.out")['peak_pending_frames']==(1 if ledger['mode']=='serial-uncompressed' else 3)
  if case['name'].startswith('point-'):
   n=int(case['name'].split('-')[1]);source=root/f'public/{n}'
   for frame in jobs['frames']:
    i=frame['id'];oracle=frame['pixels'];selected=i+2 if frame['defer'] else i
    assert (directory/oracle).read_bytes()==(source/('initial.rgba' if selected==0 else f'paint-{selected-1}.rgba')).read_bytes()
   for f in ledger['frames'][1:]:
    assert f['change']['identity_lookups']==1 and f['change']['damage_records']==2 and f['change']['dirty_pages']==1
    assert f['publication']['publication'].get('resource_entries_examined',0)==0
    assert f['publication']['resource_directory']=={} and f['cpu_update_mirror_bytes']==0
    assert f['change']['rows_decoded']<=32
assert read(root/'jobs/premature-reuse.json')['rejected']
print(json.dumps(dict(independently_simulated_frames=checked,positive_exact_gpu_frames=241,gpu_mutants=mutants,cpu_checks=read(root/'checks/checks.json')['checks']),indent=2))
