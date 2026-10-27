#!/usr/bin/env python3
import csv,hashlib,json,pathlib,statistics
root=pathlib.Path(__file__).resolve().parent
for p,h in json.loads((root/'manifest.json').read_text()).items():assert hashlib.sha256((root/p).read_bytes()).hexdigest()==h,p
raw=root/'raw';p=raw/'paired-bounded';s=json.loads((p/'summary.json').read_text());cells={}
for r in s['runs']:
    stem=f"{r['repeat']}-{r['rows']}-{r['variant']}"
    assert json.loads((p/(stem+'.status.json')).read_text())['exit']==0
    rows=list(csv.DictReader((p/(stem+'.csv')).open()));assert len(rows)==200
    assert [int(x['batch']) for x in rows]==list(range(200)) and all(int(x['ops'])==10 and int(x['rows'])==r['rows'] for x in rows)
    for clock in ['cpu','wall']:
        values=sorted(int(x[clock+'_ns'])/10 for x in rows)
        for q in [.5,.95,.99]:assert values[round(199*q)]==r[clock][str(q)]
    cells[r['repeat'],r['rows'],r['variant']]=r['cpu']['0.5']
assert len(cells)==100
for count in [0,1,4,40,400]:
    for base in ['full','sparse','cache']:
        ratios=[cells[i,count,'bounded']/cells[i,count,base] for i in range(5)]
        report=s['ratios'][str(count)][base]
        assert report['paired_ratios']==ratios and report['median']==statistics.median(ratios)
assert s['ratios']['0']['cache']['median']>1.05 and s['ratios']['4']['cache']['median']>1.05
for name,passes in [('capacity',True),('negative',False)]:
    rows=list(csv.DictReader((raw/name/'cost.csv').open()));values=[int(r['live_total']) for r in rows if r['variant']=='true']
    assert values[-1]==0 and (max(values)<=256*1024)==passes
assert '4 passed; 0 failed' in (raw/'first/test.out').read_text()
assert json.loads((raw/'first/guard-after.json').read_text())==[]
assert json.loads((raw/'negative/guard-after.json').read_text())==[]
print('Verified 100 runs; retained memory gate passes, mutant fails, CPU admission misses two cells.')
