import pathlib,json,csv,hashlib,statistics,re
root=pathlib.Path(__file__).resolve().parent
for f,h in json.loads((root/'manifest.json').read_text()).items():assert hashlib.sha256((root/f).read_bytes()).hexdigest()==h,f
raw=root/'raw';p=raw/'paired-cold';s=json.loads((p/'summary.json').read_text());cells={}
for r in s['runs']:
    stem=f"{r['repeat']}-{r['rows']}-{r['variant']}"
    assert json.loads((p/(stem+'.status.json')).read_text())['exit']==0
    rows=list(csv.DictReader((p/(stem+'.csv')).open()));assert len(rows)==200
    assert [int(x['batch']) for x in rows]==list(range(200))
    assert all(int(x['rows'])==r['rows'] and x['ops']=='10' for x in rows)
    for clock in ['cpu','wall']:
        values=sorted(int(x[clock+'_ns'])/10 for x in rows)
        for q in [.5,.95,.99]:assert values[round(199*q)]==r[clock][str(q)]
    cells[r['repeat'],r['rows'],r['variant']]=r
assert len(cells)==100
for rows,comparisons in s['ratios'].items():
    for name,report in comparisons.items():
        ratios=[cells[i,int(rows),'cold']['cpu']['0.5']/cells[i,int(rows),name]['cpu']['0.5'] for i in range(5)]
        assert ratios==report['paired_ratios'] and statistics.median(ratios)==report['median']
    assert comparisons['cache']['median']<=1.05
for rows in ['0','40']:assert s['ratios'][rows]['sparse']['median']<=.8
assert s['ratios']['400']['cache']['range'][1]>1.05
for phase,maximum in [('qualified-fixture',45046),('negative',3290692)]:
    rows=[r for r in csv.DictReader((raw/phase/'capacity.csv').open()) if r['variant']=='true']
    assert max(int(r['live_total']) for r in rows)==maximum
    assert int(next(r for r in rows if r['stage']=='clear')['live_total'])==0
    gate=json.loads((raw/phase/'memory-gate.json').read_text())
    assert gate['passed']==(maximum<=262144)
    assert json.loads((raw/phase/'guard-after.json').read_text())==[]
for name in ['sparse','cache','bounded']:assert json.loads((raw/'controls'/(name+'-guard-after.json')).read_text())==[]
assert json.loads((raw/'qualified-fixture/guard-after-timing.json').read_text())==[]
assert json.loads((raw/'composed/guard-after.json').read_text())==[]
assert 'trim_scratch' in (raw/'qualified-fixture/cache-assembly.txt').read_text()
t=(raw/'composed/test.out').read_text();assert sum(map(int,re.findall(r'test result: ok\. (\d+) passed',t)))==1045
assert '1 passed; 0 failed' in (raw/'composed/native.out').read_text()
assert 'Finished `release`' in (raw/'composed/clippy.log').read_text()
print('Verified 100 processes / 200000 complete calls, bounded retention and failing mutant, 1045 composed tests and actual native test; median CPU gates pass but paired uncertainty remains.')
