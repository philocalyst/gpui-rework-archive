from pathlib import Path
import csv,gzip,hashlib,json,re,statistics
root=Path(__file__).resolve().parent;raw=root/'raw'
def read(p):return json.loads((root/p).read_text())
def digest(p):return hashlib.sha256(p.read_bytes()).hexdigest()
manifest=read('manifest.json')
assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for name,h in manifest.items():assert digest(root/name)==h,name
for p in raw.rglob('*guard*.json'):
 j=json.loads(p.read_text());assert not any(j.values()) if isinstance(j,dict) else not j,p
for p in raw.rglob('*.status.json'):
 expected=101 if str(p.relative_to(raw)) in ['candidate/test.status.json','negative/test.status.json'] else 0
 assert json.loads(p.read_text())['exit']==expected,p
for phase,total in [('control',73),('qualified',75),('full',975),('composed',1048)]:
 s=(raw/phase/'test.out').read_text();assert 'test result: FAILED' not in s
 assert sum(map(int,re.findall(r'test result: ok\. (\d+) passed;',s)))==total,phase
assert 'ChangedCommon' in (raw/'candidate/test.log').read_text()+(raw/'candidate/test.out').read_text()
assert 'new tile membership / painter order' in (raw/'negative/test.log').read_text()+(raw/'negative/test.out').read_text()
assert len(list((raw/'composed').glob('native-*.status.json')))==6
meta=read('raw/paired/metadata.json');summary=read('raw/paired/summary.json');runs=summary['runs'];assert len(runs)==210
images={};finals={};seen=set()
def image_check(directory,stem,case,record):
 for phase in ['initial','final']:
  data=gzip.decompress((directory/(stem+'.'+phase+'.rgba.gz')).read_bytes());assert len(data)==960*720*4
  h=hashlib.sha256(data).hexdigest();assert h==record['images'][phase]==images.setdefault((case,phase),h)
for rec in runs:
 case=rec['case'];repeat=rec['repeat'];name=rec['variant'];key=(repeat,case,name);assert key not in seen;seen.add(key)
 stem=f'{repeat}-{case}-{name}';rows=list(csv.DictReader((raw/'paired'/(stem+'.csv')).open()));assert len(rows)==60
 labels,fields,mode=case.split('-');assert [int(x['frame']) for x in rows]==list(range(60))
 assert all((x['labels'],x['fields'],x['mode'])==(labels,fields,mode) for x in rows)
 for metric in ['host_ns','complete_ns']:
  vals=sorted(int(x[metric]) for x in rows);assert rec[metric]==dict(p50=statistics.median(vals),p95=vals[56],p99=vals[59])
 for metric in ['validated_draws','binning_tile_visits','upload_bytes','bind_groups','mask_upload_bytes','cpu_index_bytes','gpu_buffer_bytes','atlas_bytes']:
  v=[int(x[metric]) for x in rows];assert rec[metric]=={'median':statistics.median(v),'range':[min(v),max(v)]}
 for flag in ['canonical_sparse','packet_reused']:assert rec[flag]==sum(x[flag]=='true' for x in rows)
 assert rec['packet_reused']==(60 if name=='candidate' and mode!='full' else 0)
 log=(raw/'paired'/(stem+'.log')).read_text();final=next(s for s in log.splitlines() if s.startswith('FINAL,'));assert final==rec['final']==finals.setdefault(case,final)
 assert rec['cold_wall_ns']==int(re.search(r'COLD,wall_ns=(\d+)',log)[1])
 assert rec['max_rss_kib']==int(re.search(r'Maximum resident set size \(kbytes\): (\d+)',(raw/'paired'/(stem+'.time')).read_text())[1])
 image_check(raw/'paired',stem,case,rec)
ratios={}
for labels,fields,mode in meta['cases']:
 case=f'{labels}-{fields}-{mode}';pairs=[]
 for repeat in range(5):
  p={x['variant']:x for x in runs if x['case']==case and x['repeat']==repeat};assert len(p)==2;pairs.append(p['candidate']['complete_ns']['p50']/p['control']['complete_ns']['p50'])
 ratios[case]={'paired_ratios':pairs,'median':statistics.median(pairs),'range':[min(pairs),max(pairs)]}
assert ratios==summary['ratios']
primary={k:v['median']<=.8 for k,v in ratios.items() if k in ['1000-2-exact','1000-4-exact']}
controls={k:v['median']<=1.05 for k,v in ratios.items() if k.split('-')[1]=='1' or k.endswith('full')}
verdict={'primary':primary,'controls':controls,'numerical_pass':all(primary.values()) and all(controls.values())};assert verdict==read('verdict.json')
a=read('raw/allocations/summary.json');assert len(a['runs'])==42
for rec in a['runs']:
 stem=rec['variant']+'-'+rec['case'];log=(raw/'allocations'/(stem+'.log')).read_text().splitlines()
 rows=[{k:int(v) for k,v in (p.split('=') for p in s.split(',')[1:])} for s in log if s.startswith('ALLOC,')];assert rows==rec['allocations'];assert [x['frame'] for x in rows]==list(range(60))
 for metric in rows[0]:
  if metric=='frame':continue
  v=[x[metric] for x in rows];assert rec['summary'][metric]==dict(median=statistics.median(v),range=[min(v),max(v)])
 assert rec['layout']=={k:int(v) for k,v in (p.split('=') for p in next(s for s in log if s.startswith('LAYOUT,')).split(',')[1:])}
 assert rec['final']==next(s for s in log if s.startswith('FINAL,'))==finals[rec['case']]
 image_check(raw/'allocations',stem,rec['case'],rec)
for name,phase in [('control','control'),('candidate','qualified')]:
 rec=read('raw/'+phase+'/artifact.json');assert rec['sha256']==meta['hashes'][name]
 assert json.loads(rec['fingerprint']['features'])==['default','gpu-tests','simd','vulkan-tests']
 for shader in read('raw/'+phase+'/shader-identities.json'):
  p=raw/'shader'/shader['sha256'];assert digest(p)==shader['sha256'];assert shader['embedded']
 binary=Path(rec['path'])
 if binary.exists():
  assert digest(binary)==rec['sha256'];assert p.read_bytes() in binary.read_bytes()
 for receipt in [rec,a['artifacts'][name]]:
  binary=Path(receipt['path'])
  if binary.exists():assert digest(binary)==receipt['sha256'] and binary.stat().st_size==receipt['bytes']
assert read('raw/core-lines.json')['core_non_test_code_lines']==37367
print(json.dumps({'verified_files':len(manifest),'measured_processes':len(runs),'allocation_processes':42,'verdict':verdict},indent=2))
