#!/usr/bin/env python3
import pathlib,json,csv,hashlib,statistics,gzip
root=pathlib.Path(__file__).resolve().parent
for p,h in json.loads((root/'manifest.json').read_text()).items():assert hashlib.sha256((root/p).read_bytes()).hexdigest()==h,p
raw=root/'raw';paired=raw/'paired';s=json.loads((paired/'summary.json').read_text());cells={}
for r in s['runs']:
 stem=f"{r['repeat']}-{r['variant']}";assert json.loads((paired/(stem+'.status.json')).read_text())['exit']==0
 rows=[x for x in csv.DictReader((paired/(stem+'.csv')).open()) if x['case']==r['case']];assert [int(x['frame']) for x in rows]==list(range(60))
 for clock in ['host','complete']:
  values=sorted(float(x[clock+'_us']) for x in rows)
  for q in [.5,.95,.99]:assert values[round(59*q)]==r[clock][str(q)]
 image=paired/(stem+'-images');a=gzip.decompress((image/(r['case']+'-initial.rgba.gz')).read_bytes());b=gzip.decompress((image/(r['case']+'-final.rgba.gz')).read_bytes());assert a==b
 assert hashlib.sha256(a).hexdigest()==r['pixels_sha256'];cells[r['repeat'],r['case'],r['variant']]=r
assert len(cells)==50
for case,reported in s['ratios'].items():
 for clock in ['host','complete']:
  ratios=[]
  for i in range(5):
   a=cells[i,case,'candidate'];b=cells[i,case,'control'];assert a['pixels_sha256']==b['pixels_sha256'];ratios.append(a[clock]['0.5']/b[clock]['0.5'])
  assert ratios==reported[clock]['paired_ratios'] and statistics.median(ratios)==reported[clock]['median']
assert s['ratios']['stripes']['complete']['median'] < .8
assert s['ratios']['text-stripes']['complete']['median'] < .8
assert s['ratios']['flat']['complete']['median'] > 1.05
assert '60 passed; 0 failed' in (raw/'qualified/test.out').read_text()
assert '10 passed; 0 failed' in (raw/'qualified/test.out').read_text()
assert 'uniform_float_tiles_preserve_reference_output_bits ... FAILED' in (raw/'candidate/test.out').read_text()
assert (raw/'negative/test.status').read_text().strip()=='101'
assert 'fractional edge must retain correlated samples' in (raw/'negative/test.log').read_text()
for phase in ['control','candidate','qualified','sdr-only','negative']:
 assert json.loads((raw/phase/'guard-after.json').read_text())==[]
for phase in ['control','qualified']:
 assert json.loads((raw/phase/'artifact.json').read_text())['embedded']
print('Verified 3000 samples and exact complete pixels; preserved HDR and fractional-edge failures; admission rejected on flat regression.')
