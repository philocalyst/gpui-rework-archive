from pathlib import Path
import json,hashlib,re,subprocess
root=Path(__file__).resolve().parent;r=root/'raw/corrected'
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=read(root/'manifest.json');assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
f=read(r/'timing-inputs.json')
for p,h in f['files'].items():assert sha(r/p)==h
for p,h in f['environment_files'].items():assert sha(Path(p))==h
for p in ['guard-before-observations.json','guard-after-observations.json','guard-analysis.json']:assert read(r/p)==[]
g=r/'build-candidate';assert read(g/'guard-after.json')==[] and '17 passed; 0 failed' in (g/'test.out').read_text()
for stage in ['build','test']:assert read(g/(stage+'.status.json'))['exit']==0
assert (g/'source.txt').read_text().strip()==f['sources']['candidate']['compiled_source']==f['sources']['candidate']['current_source'];assert read(g/'inputs.json')==read(r/'candidate-current-inputs.json')
a=read(r/'artifacts.json')['candidate'];assert sha(Path(a['preserved']))==a['sha256'];data=Path(a['preserved']).read_bytes();sh=read(r/'shader.json');assert hashlib.sha256(data[sh['offset']:sh['offset']+sh['bytes']]).hexdigest()==sh['sha256']==sha(r/'ui.wgsl')=='d1a06065c06f9b9f4296b23442e19519e9c3d00e99e06f30b8e5a64f631e3697';assert b'MASK_PACKET' in data
assert read(r/'shader-admission-reverification.json')['exit']==0
order=[dict(initial=i,mode=m) for i in [0,190] for m in ['idle','scroll','stream','both']];assert read(r/'ORDER.json')==order;analysis=read(r/'analysis.json');assert len(analysis['rows'])==8
fields=['submission','bank_count','banked','draws','masks','unit_axes','unit_dimensions','references','mask_references','lowered_references','samples','mask_samples','lowered_samples','uniform_tiles'];allp=[]
for expected,row in zip(order,analysis['rows']):
 assert {k:row[k] for k in expected}==expected;p=r/'observations'/str(row['initial'])/row['mode'];status=read(p/'status.json');assert status==row['status'] and status['exit']==0 and status['failure'] is None and not status['timed'];s=read(p/'summary.json');assert s==row['summary'] and s['name']=='candidate' and s['mode']==row['mode'] and s['initial']==row['initial']
 env=read(p/'environment.json');assert env['GPUI_MASK_DIAGNOSTIC']=='1' and env['ZGX_SECONDS']=='3' and env['ZGX_INITIAL_TICKS']==str(row['initial']) and env['ZGX_MODE']==row['mode'] and env['LP_NUM_THREADS']=='4' and env['DISPLAY']==':94'
 log=(p/'app.log').read_text();assert 'PRESENTATION_ERROR' not in log and 'workload_error=' not in log and ('source_ingress='+('exact' if row['mode']=='stream' else 'owner')) in log
 m=re.findall(r'workload_ticks=(\d+) admitted_ticks=(\d+) workload_scroll_offset=([^\n]+)',log);assert len(m)==1;total,ticks,offset=m[0];assert int(total)==int(ticks)+row['initial'] and int(ticks)==s['ticks'];assert s['reference_or_model_final']==dict(total_ticks=int(total),scroll_offset=float(offset))
 if row['mode']=='idle':assert s['ticks']==0
 geom=(p/'geometry.txt').read_text();assert 'WIDTH=960\n' in geom and 'HEIGHT=720\n' in geom;assert s['font_sha256']==sha(Path(env['ZGX_FONT_FILE']))=='7da195a74c55bef988d0d48f9508bd5d849425c1770dba5d7bfc6ce9ed848954';assert read(p/'artifact.json')['sha256']==a['sha256']
 acks=[dict(source_epoch=int(x),presentation_epoch=int(y),at_ns=int(z)) for x,y,z in re.findall(r'^GPUI_ACK,(\d+),(\d+),(\d+)$',log,re.M)];assert acks==read(p/'acks.json') and len(acks)==s['native_acknowledgements'];assert len(read(p/'samples.json'))==s['samples']
 packets=[]
 for line in log.splitlines():
  if not line.startswith('MASK_PACKET,'):continue
  values=line.split(',')[1:];assert len(values)==14;assert values[2] in ['true','false'];v={k:(x=='true' if k=='banked' else int(x)) for k,x in zip(fields,values)};assert v['banked']==(v['bank_count']>0);assert 0<=v['unit_axes']<=v['masks']<=v['draws'] and 0<=v['unit_dimensions']<=v['masks'];assert 0<=v['lowered_references']<=v['mask_references']<=v['references']
  for x,y in [('samples','references'),('mask_samples','mask_references'),('lowered_samples','lowered_references')]:assert v[x]==4096*v[y]
  packets.append(v)
 assert packets and packets==row['packets'] and all(a['submission']<b['submission'] for a,b in zip(packets,packets[1:]));allp.extend(packets)
 if row['mode']=='idle':
  q=subprocess.run(['compare','-metric','AE',str(r/f"oracle-{row['initial']}.png"),str(p/'native.png'),'null:'],capture_output=True,text=True);assert dict(exit=q.returncode,stdout=q.stdout,stderr=q.stderr)==row['image_comparison']==dict(exit=0,stdout='',stderr='0')
assert analysis['packets']==len(allp) and analysis['processes']==8 and analysis['bank_counts']==sorted({p['bank_count'] for p in allp}) and analysis['banked_packets']==sum(p['banked'] for p in allp)
for field in ['mask_references','lowered_references']:assert analysis['total_'+field]==sum(p[field] for p in allp)
# Preserve the rejected initial classifier and independently check its bank fact.
initial=root/'raw';oldf=read(initial/'timing-inputs.json')
for p,h in oldf['files'].items():assert sha(initial/p)==h
for p in ['guard-before-observations.json','guard-after-observations.json','guard-analysis.json']:assert read(initial/p)==[]
olda=read(initial/'artifacts.json')['candidate'];assert sha(Path(olda['preserved']))==olda['sha256'] and olda['sha256']!=a['sha256']
old=read(initial/'analysis.json');assert len(old['rows'])==8;old_packets=[]
for row in old['rows']:
 p=initial/'observations'/str(row['initial'])/row['mode'];status=read(p/'status.json');assert status['exit']==0 and status['failure'] is None and status==row['status']
 parsed=[]
 for line in (p/'app.log').read_text().splitlines():
  if line.startswith('MASK_PACKET,'):
   v=line.split(',')[1:];assert len(v)==14;parsed.append({k:(x=='true' if k=='banked' else int(x)) for k,x in zip(fields,v)})
 assert parsed==row['packets'];old_packets.extend(parsed)
assert old['packets']==len(old_packets) and old['bank_counts']==sorted({p['bank_count'] for p in old_packets}) and old['banked_packets']==sum(p['banked'] for p in old_packets)
w=Path('/home/user/gpui-mask-coverage-lab');source=f['sources']['candidate']['compiled_source'];code=subprocess.check_output(['git','show',source+':reactivity/crates/gpu/src/renderer.rs'],cwd=w).decode();assert 'material & 0xe0000000 == 0 && atlas[2] != 0' in code
assert any(p['mask_references']<p['references'] for p in allp), 'corrected classification must distinguish non-mask references'
print(json.dumps(dict(files=len(manifest),corrected_processes=8,corrected_packets=len(allp),initial_rejected_processes=8,initial_packets=len(old_packets),bank_counts=analysis['bank_counts'],banked_packets=analysis['banked_packets'],verified=True,scope='Corrected instrumented path counts only; initial mask classifier rejected; no performance claim.')))
