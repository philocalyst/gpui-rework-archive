from pathlib import Path
import json,hashlib,re,subprocess
root=Path(__file__).resolve().parent;r=root/'raw'
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=read(root/'manifest.json');assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
parent_ref=read(r/'parent-reference.json');pd=Path(parent_ref['dossier']);assert sha(pd/'manifest.json')==parent_ref['manifest_sha256'];assert sha(r/'parent-analysis.json')==parent_ref['analysis_sha256']==sha(pd/'raw/corrected/analysis.json');assert read(r/'parent-reverification.json')['exit']==0
f=read(r/'timing-inputs.json')
for p,h in f['files'].items():assert sha(r/p)==h
for p,h in f['environment_files'].items():assert sha(Path(p))==h
for p in ['guard-before-observations.json','guard-after-observations.json','guard-analysis.json']:assert read(r/p)==[]
g=r/'build-candidate';assert read(g/'guard-after.json')==[] and '17 passed; 0 failed' in (g/'test.out').read_text()
for stage in ['build','test']:assert read(g/(stage+'.status.json'))['exit']==0
assert (g/'source.txt').read_text().strip()==f['sources']['candidate']['compiled_source']==f['sources']['candidate']['current_source'];assert read(g/'inputs.json')==read(r/'candidate-current-inputs.json')
a=read(r/'artifacts.json')['candidate'];assert sha(Path(a['preserved']))==a['sha256'];data=Path(a['preserved']).read_bytes();sh=read(r/'shader.json');assert hashlib.sha256(data[sh['offset']:sh['offset']+sh['bytes']]).hexdigest()==sh['sha256']==sha(r/'ui.wgsl')=='07a94fa243212e5261309a7f5d7234e7c7f0ae668302cac1fae27f6939fa7a7e';assert b'MASK_PACKET' in data
assert read(r/'shader-admission-reverification.json')['exit']==0
order=[dict(initial=i,mode=m) for i in [0,190] for m in ['idle','scroll','stream','both']];assert read(r/'ORDER.json')==order;analysis=read(r/'analysis.json');assert len(analysis['rows'])==8
fields=['submission','bank_count','banked','draws','masks','unit_axes','unit_dimensions','references','mask_references','lowered_references','samples','mask_samples','lowered_samples','uniform_tiles','selected_tiles','selected_samples','selected_lowered_samples','miss_enumerated','lowered_pixel_references','whole_pixel_misses','edge'];allp=[]
parent=json.loads((r/'parent-analysis.json').read_text());parent_rows={(x['initial'],x['mode']):x for x in parent['rows']}
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
  values=line.split(',')[1:];assert len(values)==21;assert values[2] in ['true','false'];v={k:(x=='true' if k=='banked' else int(x)) for k,x in zip(fields,values)};assert v['banked']==(v['bank_count']>0);assert 0<=v['unit_axes']<=v['masks']<=v['draws'] and 0<=v['unit_dimensions']<=v['masks'];assert 0<=v['lowered_references']<=v['mask_references']<=v['references']
  for x,y in [('samples','references'),('mask_samples','mask_references'),('lowered_samples','lowered_references')]:assert v[x]==1024*v[y]
  assert not v['banked'] and v['bank_count']==0 and (v['selected_tiles']>0 if v['lowered_references'] else True);assert v['selected_lowered_samples']==v['lowered_samples'] and v['selected_lowered_samples']<=v['selected_samples']<=v['samples']
  assert v['edge']==8
  assert v['miss_enumerated']==int(v['submission']==1)
  if v['miss_enumerated']:assert 0<v['whole_pixel_misses']<v['lowered_pixel_references'] and v['lowered_pixel_references']*16==v['lowered_samples']
  else:assert v['whole_pixel_misses']==v['lowered_pixel_references']==0
  packets.append(v)
 assert packets and packets[0]['submission']==1 and packets==row['packets'] and all(a['submission']<b['submission'] for a,b in zip(packets,packets[1:]));allp.extend(packets)
 assert packets[0]['samples']<parent_rows[(row['initial'],row['mode'])]['packets'][0]['samples']
 for field in ['draws','masks','unit_axes','unit_dimensions']:assert packets[0][field]==parent_rows[(row['initial'],row['mode'])]['packets'][0][field]
 if row['mode']=='idle':
  q=subprocess.run(['compare','-metric','AE',str(r/f"oracle-{row['initial']}.png"),str(p/'native.png'),'null:'],capture_output=True,text=True);assert dict(exit=q.returncode,stdout=q.stdout,stderr=q.stderr)==row['image_comparison']==dict(exit=0,stdout='',stderr='0')
assert analysis['packets']==len(allp) and analysis['processes']==8 and analysis['bank_counts']==sorted({p['bank_count'] for p in allp}) and analysis['banked_packets']==sum(p['banked'] for p in allp)
for field in ['mask_references','lowered_references']:assert analysis['total_'+field]==sum(p[field] for p in allp)
assert analysis['selected_packets']==sum(p['selected_tiles']>0 for p in allp) and analysis['selected_tiles']==sum(p['selected_tiles'] for p in allp)
print(json.dumps(dict(files=len(manifest),processes=8,packets=len(allp),bank_counts=analysis['bank_counts'],banked_packets=analysis['banked_packets'],selected_packets=analysis['selected_packets'],verified=True,scope='Actual native packet selection audit; planned counts only; no performance claim.')))
