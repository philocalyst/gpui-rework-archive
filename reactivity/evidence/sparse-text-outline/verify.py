from pathlib import Path
import csv,gzip,hashlib,json,re,statistics
root=Path(__file__).resolve().parent;raw=root/'raw';cfg=json.loads((root/'configuration.json').read_text());question=cfg['kind']=='question'
for p,h in json.loads((root/'manifest.json').read_text()).items():assert hashlib.sha256((root/p).read_bytes()).hexdigest()==h,p
cases=[(r,n,m) for r in [0,1,40] for m in (['unrelated','dependent'] if question else ['exact','owner']) for n in [1,2,4]]+[(r,4,m) for r in [0,1,40] for m in (['owner','opaque'] if question else ['opaque'])]
def measured(directory,cases,repeats,owned=False):
 out=raw/directory;summary=json.loads((out/'summary.json').read_text());meta=json.loads((out/'metadata.json').read_text());assert (meta['warmup'],meta['batches'],meta['ops'],meta['cpu_affinity'])==(200,40,100,2)
 assert meta['cases']==[list(x) for x in cases]
 published={(r['repeat'],r['case'],r['variant']):r for r in summary['runs']};cells={};finals={};cold={}
 for rep in range(repeats):
  for rows,n,mode in cases:
   case=f'{rows}-{n}-{mode}'
   for name in ['control','candidate']:
    stem=f'{rep}-{case}-{name}';status=json.loads((out/(stem+'.status.json')).read_text());assert status['exit']==0
    assert status['command'][-8:-5]==['taskset','-c','2'] and status['command'][-5]==meta['binaries'][name]
    assert status['command'][-4:]==[str(rows),str(n),mode,meta['font']]
    data=list(csv.DictReader((out/(stem+'.csv')).open()));assert len(data)==40 and [int(v['batch']) for v in data]==list(range(40))
    assert all(v['rows']==str(rows) and v['fields']==str(n) and v['mode']==mode and v['ops']=='100' for v in data)
    record=published[rep,case,name]
    for clock in ['cpu','wall']:
     values=sorted(int(v[clock+'_ns'])/100 for v in data)
     for q in [.5,.95,.99]:assert values[round(39*q)]==record[clock][str(q)]
    lines=(out/(stem+'.log')).read_text().splitlines();final=next(s for s in lines if s.startswith('FINAL,'));assert final==record['final']==finals.setdefault(case,final)
    counters=next(s for s in lines if s.startswith('COUNTERS,'));assert counters==record['counters']
    if question:
     tasks=0 if mode=='unrelated' and (n==1 or name=='candidate' or owned) else 4000
     assert record['tasks']==next(s for s in lines if s.startswith('TASKS,'))==f'TASKS,frozen={tasks},dispatched={tasks},accepted={tasks}'
     expected=tasks*2
    else:expected=0 if mode=='exact' else 4000
    assert f'owner_reruns: {expected},' in counters
    cells[rep,case,name]=record
    ns=int(next(s for s in lines if s.startswith('COLD,')).split('wall_ns=')[1]);rss=int(re.search(r'Maximum resident set size \(kbytes\): (\d+)',(out/(stem+'.time')).read_text()).group(1));cold.setdefault(case,{}).setdefault(name,[]).append((ns,rss))
 assert len(published)==len(cells)==len(cases)*repeats*2
 for rows,n,mode in cases:
  case=f'{rows}-{n}-{mode}';values=[cells[i,case,'candidate']['cpu']['0.5']/cells[i,case,'control']['cpu']['0.5'] for i in range(repeats)];report=summary['ratios'][case]
  assert report=={'paired_ratios':values,'median':statistics.median(values),'range':[min(values),max(values)]}
 assert not any(json.loads((out/'guard-after.json').read_text()).values())
 cold_summary={case:{name:{label:{'median':statistics.median(v[i] for v in values),'range':[min(v[i] for v in values),max(v[i] for v in values)]} for i,label in enumerate(['cold_wall_ns','max_rss_kib'])} for name,values in variants.items()} for case,variants in cold.items()}
 assert cold_summary==json.loads((raw/(directory+'-cold-rss.json')).read_text())
 return summary
summary=measured('paired',cases,5)
if question:measured('mechanism',[(1,2,'dependent'),(40,4,'owner'),(40,2,'unrelated'),(40,4,'unrelated')],3,True)
elif cfg.get('mechanism_cases'):measured('mechanism',[tuple(c) for c in cfg['mechanism_cases']],3)
for p in raw.rglob('guard*.json'):
 d=json.loads(p.read_text());assert not any(d.values()) if isinstance(d,dict) else d==[],str(p)
for phase,expected in cfg['tests'].items():
 assert json.loads((raw/phase/'test.status.json').read_text())['exit']==0
 assert sum(map(int,re.findall(r'test result: ok\. (\d+) passed',(raw/phase/'test.out').read_text())))==expected
for phase in cfg['clippy']:assert json.loads((raw/phase/'clippy.status.json').read_text())['exit']==0
for phase in cfg['clippy_failures']:assert json.loads((raw/phase/'clippy.status.json').read_text())['exit']==101
for i in range(6):
 assert json.loads((raw/'composed'/f'native-{i}.status.json').read_text())['exit']==0
 assert '1 passed; 0 failed' in (raw/'composed'/f'native-{i}.out').read_text()
assert json.loads((raw/'negative/test.status.json').read_text())['exit']==101
assert cfg['negative_message'] in (raw/'negative/test.out').read_text()
meta=json.loads((raw/'paired/metadata.json').read_text());artifact=json.loads((raw/cfg.get('candidate_receipt','artifact-pin/cost-artifact.json')).read_text());assert artifact['sha256']==meta['hashes']['candidate'] and artifact['path']==meta['binaries']['candidate'] and artifact['features']==['default','simd']
assert json.loads((raw/cfg['control_receipt']).read_text())['sha256']==meta['hashes']['control']
alloc=json.loads((raw/'allocations/summary.json').read_text());assert len(alloc['runs'])==len(cases)*2;finals={};allocation_cells={}
for row in alloc['runs']:
 name,r,n,m=row['variant'],row['rows'],row['fields'],row['mode'];stem=f'{name}-{r}-{n}-{m}';assert json.loads((raw/'allocations'/(stem+'.status.json')).read_text())['exit']==0
 for line in (raw/'allocations'/(stem+'.log')).read_text().splitlines():
  if line.startswith(('ALLOC,','COLD_ALLOC,','TRANSPORT_ALLOC,','LAYOUT,','FINAL,','TASKS,')):
   key,*parts=line.split(',');assert row[key]=={k:int(v) for k,v in (p.split('=') for p in parts)}
 assert row['ALLOC']['retained_delta']==0 and row['FINAL']==finals.setdefault((r,n,m),row['FINAL']);allocation_cells[name,r,n,m]=row
assert len(allocation_cells)==len(cases)*2
for r,n,m in cases:
 a,b=[allocation_cells[v,r,n,m] for v in ['candidate','control']];assert a['LAYOUT']==b['LAYOUT']
 if n==1 or m!=('unrelated' if question else 'exact'):assert a['ALLOC']==b['ALLOC']
assert len(list((raw/'machine').glob('*.gz')))>=4
for p in (raw/'machine').glob('*.gz'):assert len(gzip.decompress(p.read_bytes()))>100
primary={};controls={}
for case,ratio in summary['ratios'].items():
 r,n,m=case.split('-');direct='unrelated' if question else 'exact'
 if r=='40' and n in ['2','4'] and m==direct:primary[case]=ratio['median']<=.8
 if n=='1' or m!=direct:controls[case]=ratio['median']<=1.05
verdict={'primary':primary,'controls':controls,'numerical_pass':all(primary.values()) and all(controls.values())};assert verdict==json.loads((root/'verdict.json').read_text())
print('PASS: raw samples, exact outputs/work counters, allocation probes, build/source/ELF receipts, negative witness receipt (inherited when declared), default/composed suites and six actual native scripts verified.')
print('Numerical adoption gates:',verdict['numerical_pass'],'; failed controls:',[k for k,v in controls.items() if not v]);print('No competitor or hardware verdict.')
