import pathlib, json, csv, hashlib, statistics, re
root = pathlib.Path(__file__).resolve().parent
for f,h in json.loads((root/'manifest.json').read_text()).items():
    assert hashlib.sha256((root/f).read_bytes()).hexdigest() == h, f
raw=root/'raw'
for campaign,baseline,processes in [('paired','original',140),('guards-paired','control',70)]:
    p=raw/campaign;s=json.loads((p/'summary.json').read_text());cells={};finals={}
    for r in s['runs']:
        stem=f"{r['repeat']}-{r['case']}-{r['variant']}"
        status=json.loads((p/(stem+'.status.json')).read_text());assert status['exit']==0
        ops=(1000 if r['case']=='shallow' else 20) if campaign=='guards-paired' else 5
        rows=list(csv.DictReader((p/(stem+'.csv')).open()))
        assert len(rows)==40 and [int(x['batch']) for x in rows]==list(range(40))
        assert all(x['case']==r['case'] and int(x['ops'])==ops for x in rows)
        if campaign=='guards-paired':assert status['command'][-6:-3]==['taskset','-c','2']
        for clock in ['cpu','wall']:
            v=sorted(int(x[clock+'_ns'])/ops for x in rows)
            for q in [.5,.95,.99]:assert v[round(39*q)]==r[clock][str(q)]
        final=next(x for x in (p/(stem+'.log')).read_text().splitlines() if x.startswith('FINAL,'))
        assert final==r['final']==finals.setdefault(r['case'],final)
        cells[r['repeat'],r['case'],r['variant']]=r
    assert len(cells)==processes
    for case,variants in s['ratios'].items():
        for name,report in variants.items():
            ratios=[cells[i,case,name]['cpu']['0.5']/cells[i,case,baseline]['cpu']['0.5'] for i in range(5)]
            assert ratios==report['paired_ratios'] and statistics.median(ratios)==report['median']
    if campaign=='guards-paired':
        assert s['ratios']['shuffled']['candidate']['median']<.8
        assert s['ratios']['single-full']['candidate']['median']>1.05
        assert s['ratios']['shallow']['candidate']['median']>1.05
for phase in ['candidate','original','previous','inline','guards/candidate','guards/control']:
    assert json.loads((raw/phase/'guard-after-timing.json').read_text())==[]
    if not phase.startswith('guards/'):
        t=(raw/phase/'test.out').read_text()
        assert sum(int(x) for x in re.findall(r'test result: ok\. (\d+) passed',t))==46
assert '1 passed; 0 failed' in (raw/'candidate/miri.out').read_text()
assert (raw/'negative/test.status').read_text().strip()=='101'
assert 'FAILED' in (raw/'negative/test.out').read_text()
t=(raw/'composed/test.out').read_text()
assert sum(int(x) for x in re.findall(r'test result: ok\. (\d+) passed',t))==1044
assert '1 passed; 0 failed' in (raw/'composed/native.out').read_text()
assert json.loads((raw/'composed/inputs-after.json').read_text())['mismatches']==[]
assert 'Finished `release`' in (raw/'composed/clippy.log').read_text()
print('Verified 210 processes, 476000 complete calls, exact outputs, Miri/mutant and composed/native gates; no-regression qualification fails.')
