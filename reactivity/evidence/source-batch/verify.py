import pathlib,json,csv,hashlib,statistics,gzip,re
root=pathlib.Path(__file__).resolve().parent
for f,h in json.loads((root/'manifest.json').read_text()).items():assert hashlib.sha256((root/f).read_bytes()).hexdigest()==h,f
raw=root/'raw';p=raw/'paired';s=json.loads((p/'summary.json').read_text());cells={};finals={}
for r in s['runs']:
    stem=f"{r['repeat']}-{r['case']}-{r['variant']}";status=json.loads((p/(stem+'.status.json')).read_text());assert status['exit']==0
    assert status['command'][-8:-5]==['taskset','-c','2']
    data=list(csv.DictReader((p/(stem+'.csv')).open()));assert len(data)==40
    rows,n,mode=r['case'].split('-');assert [int(x['batch']) for x in data]==list(range(40))
    assert all(x['rows']==rows and x['fields']==n and x['mode']==mode and x['ops']=='100' for x in data)
    for clock in ['cpu','wall']:
        values=sorted(int(x[clock+'_ns'])/100 for x in data)
        for q in [.5,.95,.99]:assert values[round(39*q)]==r[clock][str(q)]
    log=(p/(stem+'.log')).read_text().splitlines();final=next(x for x in log if x.startswith('FINAL,'));assert final==r['final']==finals.setdefault(r['case'],final)
    counter=next(x for x in log if x.startswith('COUNTERS,'));assert counter==r['counters']
    expected=0 if mode=='exact' and (n=='1' or r['variant']=='candidate') else 4000
    assert f'owner_reruns: {expected},' in counter
    cells[r['repeat'],r['case'],r['variant']]=r
assert len(cells)==210
for case,report in s['ratios'].items():
    ratios=[cells[i,case,'candidate']['cpu']['0.5']/cells[i,case,'control']['cpu']['0.5'] for i in range(5)]
    assert ratios==report['paired_ratios'] and statistics.median(ratios)==report['median']
    rows,n,mode=case.split('-')
    if rows=='40' and n in ['2','4'] and mode=='exact':assert max(ratios)<.8
    if n=='1' or mode!='exact':assert report['median']<=1.05
for phase in ['fixture','control','negative','composed','fixture-allocation','control-allocation']:
    assert json.loads((raw/phase/'guard-after.json').read_text())==[]
for phase in ['fixture-allocation','control-allocation']:
    assert json.loads((raw/phase/'guard-after-timing.json').read_text())==[]
for phase in ['fixture','control']:
    assert len(gzip.decompress((raw/phase/'routing-assembly.txt.gz').read_bytes()))>100
for phase,expected in [('fixture',711),('composed',1049)]:
    t=(raw/phase/'test.out').read_text();assert sum(map(int,re.findall(r'test result: ok\. (\d+) passed',t)))==expected
    assert 'Finished `release`' in (raw/phase/'clippy.log').read_text()
for i in range(6):
    assert json.loads((raw/'composed'/f'native-{i}.status.json').read_text())['exit']==0
    assert '1 passed; 0 failed' in (raw/'composed'/f'native-{i}.out').read_text()
assert (raw/'negative/test.status').read_text().strip()=='101'
assert 'contains_text("owner:new0")' in (raw/'negative/test.out').read_text()
alloc=json.loads((raw/'allocations/summary.json').read_text());assert len(alloc)==30
for r in alloc:
    stem=f"{r['rows']}-{r['fields']}-{r['mode']}-{r['variant']}";assert json.loads((raw/'allocations'/(stem+'.status.json')).read_text())['exit']==0
    for line in (raw/'allocations'/(stem+'.log')).read_text().splitlines():
        if line.split(',')[0] in ['ALLOC','COLD_ALLOC','TRANSPORT_ALLOC','LAYOUT']:
            parsed={k:int(v) for k,v in [item.split('=') for item in line.split(',')[1:]]};assert parsed==r[line.split(',')[0]]
    assert r['ALLOC']['retained_delta']==0
four={r['variant']:r for r in alloc if r['rows']==40 and r['fields']==4 and r['mode']=='exact'}
assert four['control']['ALLOC']['requests']==1194 and four['candidate']['ALLOC']['requests']==120
assert four['control']['LAYOUT']==four['candidate']['LAYOUT']
print('Verified 210 processes / 840000 complete publication operations, exact output, 30 allocation probes, 711 default / 1049 composed tests and six actual native scripts; numerical gates pass, hardware and uncertainty limits remain.')
