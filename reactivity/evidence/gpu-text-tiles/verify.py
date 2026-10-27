from pathlib import Path
import csv,gzip,hashlib,json,re,statistics
root=Path(__file__).resolve().parent;raw=root/'raw'
def read(p):return json.loads((root/p).read_text())
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
manifest=read('manifest.json');assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for name,h in manifest.items():assert sha(root/name)==h,name
for p in raw.rglob('*guard*.json'):
 j=json.loads(p.read_text());assert not any(j.values()) if isinstance(j,dict) else not j,p
failed={'candidate/test.status.json','qualified/test.status.json','boundary/test.status.json','rounding/test.status.json','negative/test.status.json'}
for p in raw.rglob('*.status.json'):assert json.loads(p.read_text())['exit']==(101 if str(p.relative_to(raw)) in failed else 0),p
for phase,total in [('control',73),('packet-control',75),('corrected',77),('certified',78),('full',975),('composed',1048)]:
 s=(raw/phase/'test.out').read_text();assert 'test result: FAILED' not in s;assert sum(map(int,re.findall(r'test result: ok\. (\d+) passed;',s)))==total,phase
assert 'old dirty tile membership must survive movement' in (raw/'negative/test.log').read_text()
assert len(list((raw/'composed').glob('native-*.status.json')))==6
images={};finals={}
def image_check(directory,stem,case,record):
 for phase in ['initial','final']:
  data=gzip.decompress((directory/(stem+'.'+phase+'.rgba.gz')).read_bytes());assert len(data)==960*720*4
  h=hashlib.sha256(data).hexdigest();assert h==record['images'][phase]==images.setdefault((case,phase),h)
def timing(phase,repeats,count):
 meta=read(f'raw/{phase}/metadata.json');summary=read(f'raw/{phase}/summary.json');runs=summary['runs'];assert len(runs)==count;seen=set()
 for rec in runs:
  case=rec['case'];repeat=rec['repeat'];name=rec['variant'];key=(repeat,case,name);assert key not in seen;seen.add(key);stem=f'{repeat}-{case}-{name}'
  rows=list(csv.DictReader((raw/phase/(stem+'.csv')).open()));assert len(rows)==60 and [int(x['frame']) for x in rows]==list(range(60));labels,fields,mode=case.split('-')
  assert all((x['labels'],x['fields'],x['mode'])==(labels,fields,mode) for x in rows)
  for metric in ['host_ns','complete_ns']:
   v=sorted(int(x[metric]) for x in rows);assert rec[metric]==dict(p50=statistics.median(v),p95=v[56],p99=v[59])
  for metric in ['validated_draws','binning_tile_visits','upload_bytes','bind_groups','mask_upload_bytes','cpu_index_bytes','gpu_buffer_bytes','atlas_bytes']:
   v=[int(x[metric]) for x in rows];assert rec[metric]=={'median':statistics.median(v),'range':[min(v),max(v)]}
  for flag in ['canonical_sparse','packet_reused']:assert rec[flag]==sum(x[flag]=='true' for x in rows)
  assert rec['packet_reused']==(60 if mode!='full' and (name=='candidate' or phase=='mechanism') else 0)
  log=(raw/phase/(stem+'.log')).read_text();final=next(s for s in log.splitlines() if s.startswith('FINAL,'));assert final==rec['final']==finals.setdefault(case,final)
  assert rec['cold_wall_ns']==int(re.search(r'COLD,wall_ns=(\d+)',log)[1]);assert rec['max_rss_kib']==int(re.search(r'Maximum resident set size \(kbytes\): (\d+)',(raw/phase/(stem+'.time')).read_text())[1]);image_check(raw/phase,stem,case,rec)
 ratios={}
 for labels,fields,mode in meta['cases']:
  case=f'{labels}-{fields}-{mode}';pairs=[]
  for repeat in range(repeats):
   p={x['variant']:x for x in runs if x['case']==case and x['repeat']==repeat};assert len(p)==2;pairs.append(p['candidate']['complete_ns']['p50']/p['control']['complete_ns']['p50'])
  ratios[case]={'paired_ratios':pairs,'median':statistics.median(pairs),'range':[min(pairs),max(pairs)]}
 assert ratios==summary['ratios']
 for name,receipt in [('control','packet-control' if phase=='mechanism' else 'control'),('candidate','certified')]:
  a=read(f'raw/{receipt}/artifact.json');assert a['sha256']==meta['hashes'][name];assert json.loads(a['fingerprint']['features'])==['default','gpu-tests','simd','vulkan-tests'];p=Path(a['path'])
  if p.exists():assert sha(p)==a['sha256'] and p.stat().st_size==a['bytes']
 return ratios
ratios=timing('paired',5,210);timing('mechanism',3,30)
primary={k:v['median']<=.8 for k,v in ratios.items() if k in ['1000-1-stream','1000-2-exact','1000-4-exact']};controls={k:v['median']<=1.05 for k,v in ratios.items() if k.endswith('full') or k.split('-')[1]=='1' and k.endswith('exact')};verdict={'primary':primary,'controls':controls,'numerical_pass':all(primary.values()) and all(controls.values())};assert verdict==read('verdict.json')
a=read('raw/allocations/summary.json');assert len(a['runs'])==42
for rec in a['runs']:
 stem=rec['variant']+'-'+rec['case'];log=(raw/'allocations'/(stem+'.log')).read_text().splitlines()
 rows=[{k:int(v) for k,v in (p.split('=') for p in s.split(',')[1:])} for s in log if s.startswith('ALLOC,')];assert rows==rec['allocations'] and [x['frame'] for x in rows]==list(range(60))
 for metric in rows[0]:
  if metric=='frame':continue
  v=[x[metric] for x in rows];assert rec['summary'][metric]==dict(median=statistics.median(v),range=[min(v),max(v)])
 repairs=[{k:int(v) for k,v in (p.split('=') for p in s.split(',')[1:])} for s in log if s.startswith('REPAIR,')];assert repairs==rec['repairs'];assert len(repairs)==(60 if rec['variant']=='candidate' else 0)
 for x in repairs:assert 0<=x['composited_pixels']<=x['damage_pixels']<=x['copied_pixels']==960*720
 assert rec['layout']=={k:int(v) for k,v in (p.split('=') for p in next(s for s in log if s.startswith('LAYOUT,')).split(',')[1:])}
 assert rec['final']==next(s for s in log if s.startswith('FINAL,'))==finals[rec['case']];image_check(raw/'allocations',stem,rec['case'],rec)
for name in ['control','candidate']:
 a=read(f'raw/{name}-allocation/artifact.json');p=Path(a['path'])
 if p.exists():assert sha(p)==a['sha256'] and p.stat().st_size==a['bytes']
for phase in ['control','packet-control','certified']:
 a=read(f'raw/{phase}/artifact.json');binary=Path(a['path'])
 for shader in read(f'raw/{phase}/shader-identities.json'):
  p=raw/'shader'/shader['sha256'];assert sha(p)==shader['sha256'] and shader['embedded']
  if binary.exists():assert p.read_bytes() in binary.read_bytes()
assert read('raw/core-lines.json')['core_non_test_code_lines']==37461
print(json.dumps({'verified_files':len(manifest),'timed_processes':240,'allocation_processes':42,'verdict':verdict},indent=2))
