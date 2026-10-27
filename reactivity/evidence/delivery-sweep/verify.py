import pathlib,json,csv,hashlib,statistics,gzip,re
root=pathlib.Path(__file__).resolve().parent
for f,h in json.loads((root/'manifest.json').read_text()).items():
    assert hashlib.sha256((root/f).read_bytes()).hexdigest()==h,f
raw=root/'raw';p=raw/'paired';summary=json.loads((p/'summary.json').read_text());cells={};finals={}
for record in summary['runs']:
    stem=f"{record['repeat']}-{record['case']}-{record['variant']}"
    status=json.loads((p/(stem+'.status.json')).read_text());assert status['exit']==0
    assert status['command'][-6:-3]==['taskset','-c','2']
    rows=list(csv.DictReader((p/(stem+'.csv')).open()));assert len(rows)==40
    n,mode=record['case'].split('-');assert [int(r['batch']) for r in rows]==list(range(40))
    assert all(r['lanes']==n and r['mode']==mode and r['ops']=='100' for r in rows)
    for clock in ['cpu','wall']:
        values=sorted(int(r[clock+'_ns'])/100 for r in rows)
        for q in [.5,.95,.99]:assert values[round(39*q)]==record[clock][str(q)]
    final=next(s for s in (p/(stem+'.log')).read_text().splitlines() if s.startswith('FINAL,'))
    assert final==record['final']==finals.setdefault(record['case'],final)
    cells[record['repeat'],record['case'],record['variant']]=record
assert len(cells)==160
for case,report in summary['ratios'].items():
    ratios=[cells[i,case,'candidate']['cpu']['0.5']/cells[i,case,'control']['cpu']['0.5'] for i in range(5)]
    assert ratios==report['paired_ratios'] and statistics.median(ratios)==report['median']
assert summary['ratios']['64-all']['median']>.8
assert summary['ratios']['64-rotate']['median']>1.05
for phase in ['candidate-qualified','control-qualified']:
    assert json.loads((raw/phase/'guard-after.json').read_text())==[]
    assert json.loads((raw/phase/'guard-after-timing.json').read_text())==[]
    for name in ['assembly.txt.gz','symbols.txt.gz','stage64-assembly.txt.gz']:
        assert len(gzip.decompress((raw/phase/name).read_bytes()))>100
assert 'jmp    *%rcx' in gzip.decompress((raw/'control-qualified/stage64-assembly.txt.gz').read_bytes()).decode()
t=(raw/'candidate-qualified/test.out').read_text()
assert sum(map(int,re.findall(r'test result: ok\. (\d+) passed',t)))==707
assert 'structural_sweep_matches_indexed_oracle_for_wrap_backlog_and_limits ... ok' in t
assert 'two_reader_inputs_settle_before_their_dependent_freezes_once ... ok' in t
assert 'Finished `release`' in (raw/'candidate-qualified/clippy.log').read_text()
assert (raw/'negative/test.status').read_text().strip()=='101'
assert 'left: [100, 101, 102, 103, 0, 1, 2, 3]' in (raw/'negative/test.out').read_text()
print('Verified 160 processes / 640000 complete fixture steps, exact state/pixels/counters, 707 tests and fairness mutant; performance rejected.')
