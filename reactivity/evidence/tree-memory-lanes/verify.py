import pathlib,json,csv,hashlib,statistics
root=pathlib.Path(__file__).resolve().parent
for f,h in json.loads((root/'manifest.json').read_text()).items():assert hashlib.sha256((root/f).read_bytes()).hexdigest()==h,f
raw=root/'raw';p=raw/'paired';s=json.loads((p/'summary.json').read_text());cells={};finals={}
for r in s['runs']:
 stem=f"{r['repeat']}-{r['case']}-{r['variant']}";assert json.loads((p/(stem+'.status.json')).read_text())['exit']==0
 rows=list(csv.DictReader((p/(stem+'.csv')).open()));assert len(rows)==40 and [int(x['batch']) for x in rows]==list(range(40));assert all(x['case']==r['case'] and x['ops']=='5' for x in rows)
 for clock in ['cpu','wall']:
  v=sorted(int(x[clock+'_ns'])/5 for x in rows)
  for q in [.5,.95,.99]:assert v[round(39*q)]==r[clock][str(q)]
 final=next(x for x in (p/(stem+'.log')).read_text().splitlines() if x.startswith('FINAL,'));assert final==r['final']==finals.setdefault(r['case'],final)
 cells[r['repeat'],r['case'],r['variant']]=r
assert len(cells)==180
for case,variants in s['ratios'].items():
 for name,report in variants.items():
  ratios=[cells[i,case,name]['cpu']['0.5']/cells[i,case,'original']['cpu']['0.5'] for i in range(5)]
  assert ratios==report['paired_ratios'] and statistics.median(ratios)==report['median']
assert s['ratios']['shuffled']['hint']['median']<.8
assert s['ratios']['contiguous']['hint']['median']>1.05
assert s['ratios']['contiguous']['levels']['median']>1.05
for phase in ['qualified','original','scalar','levels','nohint','proof']:
 assert json.loads((raw/phase/'guard-after.json').read_text())==[]
 assert json.loads((raw/phase/'guard-after-timing.json').read_text())==[]
 text=(raw/phase/'test.out').read_text()
 for count in [7,22,14,3]:assert f'{count} passed; 0 failed' in text
 artifact=json.loads((raw/phase/'artifact.json').read_text());assert (artifact['prefetcht0_count']>0)==(phase=='qualified')
assert '1 passed; 0 failed' in (raw/'qualified/miri.out').read_text()
assert (raw/'negative/test.status').read_text().strip()=='101'
assert 'assertion `left == right` failed' in (raw/'negative/test.out').read_text()
print('Verified 180 processes / 36000 complete calls, exact layouts/stats, Miri and mutant; general candidate rejected.')
