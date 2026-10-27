import pathlib,json,hashlib,csv,statistics,re,gzip
root=pathlib.Path(__file__).resolve().parent
# Dossier installation places this file one level above raw staging.
raw=root/'raw' if (root/'raw').is_dir() else root
if (root/'manifest.json').exists():
 for path,h in json.loads((root/'manifest.json').read_text()).items(): assert hashlib.sha256((root/path).read_bytes()).hexdigest()==h,path
paired=raw/'paired';summary=json.loads((paired/'summary.json').read_text());cells={};finals={}
for record in summary['runs']:
 rep,case,name=record['repeat'],record['case'],record['variant'];rows,n,mode=case.split('-');stem=f'{rep}-{case}-{name}'
 status=json.loads((paired/(stem+'.status.json')).read_text());assert status['exit']==0 and status['command'][-8:-5]==['taskset','-c','2']
 data=list(csv.DictReader((paired/(stem+'.csv')).open()));assert len(data)==40 and [int(x['batch']) for x in data]==list(range(40))
 assert all(x['rows']==rows and x['fields']==n and x['mode']==mode and x['ops']=='100' for x in data)
 for clock in ['cpu','wall']:
  values=sorted(int(x[clock+'_ns'])/100 for x in data)
  for q in [.5,.95,.99]: assert record[clock][str(q)]==values[round(39*q)]
 lines=(paired/(stem+'.log')).read_text().splitlines();final=next(x for x in lines if x.startswith('FINAL,'));assert final==record['final']==finals.setdefault(case,final)
 expected=0 if mode=='unrelated' and (n=='1' or name=='candidate') else 4000
 tasks=next(x for x in lines if x.startswith('TASKS,'));assert tasks==record['tasks']==f'TASKS,frozen={expected},dispatched={expected},accepted={expected}'
 counters=next(x for x in lines if x.startswith('COUNTERS,'));assert counters==record['counters'] and f'owner_reruns: {expected*2},' in counters
 cells[rep,case,name]=record
assert len(cells)==240 and len(finals)==24
primary={};controls={}
for case,report in summary['ratios'].items():
 ratios=[cells[i,case,'candidate']['cpu']['0.5']/cells[i,case,'control']['cpu']['0.5'] for i in range(5)]
 assert ratios==report['paired_ratios'] and report['median']==statistics.median(ratios) and report['range']==[min(ratios),max(ratios)]
 rows,n,mode=case.split('-')
 if rows=='40' and n in ['2','4'] and mode=='unrelated':primary[case]=report['median']<=.8
 if n=='1' or mode!='unrelated':controls[case]=report['median']<=1.05
for phase in ['first','fixture','qualified','docs','allocation-build','certificate','composed','composed-docs','control','control-qualified','control-allocation','negative']:
 assert json.loads((raw/phase/'guard-after.json').read_text())==[]
assert not any(json.loads((raw/'guard-after-timing.json').read_text()).values())
assert json.loads((raw/'composed/guard-after-native.json').read_text())==[]
for phase,count in [('qualified',690),('docs',28),('certificate',7),('composed',763),('composed-docs',28)]:
 assert json.loads((raw/phase/'test.status.json').read_text())['exit']==0
 assert sum(map(int,re.findall(r'test result: ok\. (\d+) passed',(raw/phase/'test.out').read_text())))==count
for phase in ['qualified','allocation-build','certificate','composed','control-allocation']:
 assert json.loads((raw/phase/'clippy.status.json').read_text())['exit']==0
for i in range(6):
 assert json.loads((raw/'composed'/f'native-{i}.status.json').read_text())['exit']==0
 assert '1 passed; 0 failed' in (raw/'composed'/f'native-{i}.out').read_text()
assert json.loads((raw/'negative/test.status.json').read_text())['exit']==101
assert 'changed member must dispatch its dependent: Empty' in (raw/'negative/test.out').read_text()
for phase in ['fixture','control']:assert json.loads((raw/phase/'build.status.json').read_text())['exit']==101
for phase in ['qualified','control-qualified']:
 assert len(gzip.decompress((raw/phase/'routing-assembly.txt.gz').read_bytes()))>100
 assert json.loads((raw/phase/'artifact.json').read_text())['sha256']==json.loads((paired/'metadata.json').read_text())['hashes']['candidate' if phase=='qualified' else 'control']
alloc=json.loads((raw/'allocations/summary.json').read_text());assert len(alloc['runs'])==48;alloc_cells={}
for record in alloc['runs']:
 name,rows,n,mode=record['variant'],record['rows'],record['fields'],record['mode'];stem=f'{name}-{rows}-{n}-{mode}'
 assert json.loads((raw/'allocations'/(stem+'.status.json')).read_text())['exit']==0
 for line in (raw/'allocations'/(stem+'.log')).read_text().splitlines():
  if line.startswith(('ALLOC,','COLD_ALLOC,','LAYOUT,','FINAL,','TASKS,')):
   key,*parts=line.split(',');assert record[key]=={k:int(v) for k,v in (p.split('=') for p in parts)}
 assert record['ALLOC']['retained_delta']==0;alloc_cells[name,rows,n,mode]=record
for name,rows,n,mode in alloc_cells:
 a,b=(alloc_cells[v,rows,n,mode] for v in ['candidate','control']);assert a['FINAL']==b['FINAL'] and a['LAYOUT']==b['LAYOUT']
 if n==1 or mode!='unrelated':assert a['ALLOC']==b['ALLOC']
assert alloc_cells['candidate',40,2,'unrelated']['ALLOC']['requests']==86
assert alloc_cells['control',40,2,'unrelated']['ALLOC']['requests']==9334
print('Verified 240 processes / 960000 complete settled operations, 48 allocation probes, exact final outputs/task counts, source guards, tests and six actual native scripts.')
print('Primary gates:',primary,'control gates:',controls)
print('Numerical gates:',all(primary.values()) and all(controls.values()),'; hardware/competitor and paired-uncertainty limits remain separate.')
