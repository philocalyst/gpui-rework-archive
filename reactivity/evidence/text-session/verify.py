#!/usr/bin/env python3
import csv, hashlib, json, pathlib, statistics, re
root=pathlib.Path(__file__).resolve().parent
for p,h in json.loads((root/'manifest.json').read_text()).items():
    assert hashlib.sha256((root/p).read_bytes()).hexdigest()==h,p
raw=root/'raw'; data=raw/'paired-compat'; summary=json.loads((data/'summary.json').read_text()); cells={}
for r in summary['runs']:
    stem=f"{r['repeat']}-{r['rows']}-{r['variant']}"
    assert json.loads((data/(stem+'.status.json')).read_text())['exit']==0
    rows=list(csv.DictReader((data/(stem+'.csv')).open()))
    assert len(rows)==200 and [int(x['batch']) for x in rows]==list(range(200))
    assert all(int(x['ops'])==10 and int(x['rows'])==r['rows'] for x in rows)
    for clock in ['cpu','wall']:
        values=sorted(int(x[clock+'_ns'])/10 for x in rows)
        for q in [.5,.95,.99]: assert values[round(199*q)]==r[clock][str(q)]
    cells[r['repeat'],r['rows'],r['variant']]=r['cpu']['0.5']
assert len(cells)==100
reported=json.loads((raw/'compatibility/cpu-ratios.json').read_text())
for count in [0,1,4,40,400]:
    for baseline in ['full','sparse']:
        ratios=[cells[i,count,'cache']/cells[i,count,baseline] for i in range(5)]
        assert ratios==reported[str(count)][baseline]['paired_ratios']
        assert statistics.median(ratios)==reported[str(count)][baseline]['median']
    assert reported[str(count)]['sparse']['median'] <= (.8 if count in [0,40] else 1.05)
for p in (raw/'ledger-compat').glob('*.csv'):
    rows=list(csv.DictReader(p.open())); assert rows[-1]['stage']=='drop' and int(rows[-1]['live_total'])==0
rows=list(csv.DictReader((raw/'long-capacity/cost.csv').open()));cached=[r for r in rows if r['variant']=='true'];assert int(cached[-1]['live_total'])==0
assert next(int(r['live_total']) for r in cached if r['stage']=='short')==3256796
mutant=(raw/'negative/test.out').read_text();assert 'ForeignLayout' in mutant and '0 passed; 1 failed' in mutant
assert (raw/'clippy/status').read_text().strip()=='0'
assert (raw/'native-runtime-direct/test.status').read_text().strip()=='0'
assert '1 passed; 0 failed' in (raw/'native-runtime-direct/test.out').read_text()
results=re.findall(r'test result: (\w+)\. (\d+) passed; (\d+) failed; (\d+) ignored',(raw/'compatibility/test.out').read_text())
assert len(results)==111 and sum(int(r[1]) for r in results)==1044 and all(r[0]=='ok' and r[2]=='0' for r in results)
assert json.loads((raw/'compatibility/guard-final.json').read_text())==[]
print('Verified compatible cache: 100 runs, 20000 batches, CPU gates pass; memory/native limitations retained.')
