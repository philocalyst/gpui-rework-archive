#!/usr/bin/env python3
import csv, hashlib, json, pathlib, statistics
root=pathlib.Path(__file__).resolve().parent
manifest=json.loads((root/'manifest.json').read_text())
for name,digest in manifest.items():
    assert hashlib.sha256((root/name).read_bytes()).hexdigest()==digest,name
raw=root/'raw'; paired=raw/'paired-sparse'
s=json.loads((paired/'summary.json').read_text())
for record in s['runs']:
    name=f"{record['repeat']}-{record['rows']}-{record['variant']}"
    data=list(csv.DictReader((paired/(name+'.csv')).open()))
    assert len(data)==200
    assert [int(d['batch']) for d in data]==list(range(200))
    assert all(int(d['ops'])==10 and int(d['rows'])==record['rows'] for d in data)
    for clock in ['cpu','wall']:
        values=sorted(int(d[clock+'_ns'])/10 for d in data)
        for p in [.5,.95,.99]:
            assert values[round(199*p)]==record[clock][str(p)]
for rows,reported in s['ratios'].items():
    values=[]
    for repeat in range(5):
        cells={r['variant']:r['cpu']['0.5'] for r in s['runs'] if r['rows']==int(rows) and r['repeat']==repeat}
        values.append(cells['sparse']/cells['baseline'])
    assert values==reported['paired_ratios']
    assert statistics.median(values)==reported['median']
assert s['ratios']['40']['median']<.8
assert s['ratios']['0']['range'][0]<1.05<s['ratios']['0']['range'][1]
assert 'changed layout WWW' in (raw/'negative/test.out').read_text()
assert '0 passed; 1 failed' in (raw/'negative/test.out').read_text()
assert json.loads((raw/'guard-final.json').read_text())['changed']==[]
print('Verified 50 runs, 10000 batches, 100000 updates; admission inconclusive.')
