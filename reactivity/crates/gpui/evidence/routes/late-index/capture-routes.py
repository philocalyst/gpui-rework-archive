from pathlib import Path
import csv,hashlib,json,os,subprocess,time,statistics

ROOT=Path('/root/gpui-pan-viewports')
OUT=ROOT/'reactivity/crates/gpui/evidence/routes/late-index'
OUT.mkdir(parents=True,exist_ok=True)
bins={'baseline':Path('/tmp/gpui-routes-c11-baseline-303e7901280e2467e490563535b33a88faf5ea9f50918d6a1b8ac24e8cef0c1d'),'candidate':Path('/tmp/gpui-pan-viewports-release-target/release/examples/route_storage_measure')}
sources={'baseline':'40382ed1d9','candidate':'c8c84c15be'}
digests={k:hashlib.sha256(v.read_bytes()).hexdigest() for k,v in bins.items()}
fixture=ROOT/'reactivity/crates/gpui/examples/route_storage_measure.rs'
manifest=dict(source_commits=sources,binaries={k:dict(path=str(v),sha256=digests[k]) for k,v in bins.items()},fixture_sha256=hashlib.sha256(fixture.read_bytes()).hexdigest(),rounds=11,cpu=2,scope='Fresh-process alternating warm-code recording owners; no native/peer/scanout or cold-start claim. Complete route disable/restore and 100 activations are included; inspection and pixel preflight excluded from measured phases.')
rows=[]; start=time.monotonic()
for pair in range(11):
    for name in (['baseline','candidate'] if pair%2==0 else ['candidate','baseline']):
        assert hashlib.sha256(bins[name].read_bytes()).hexdigest()==digests[name]
        result=subprocess.check_output([str(bins[name])],text=True,preexec_fn=lambda:os.sched_setaffinity(0,{2}))
        (OUT/f'raw-{pair:02}-{name}.csv').write_text(result)
        parsed=list(csv.DictReader(result.splitlines())); assert len(parsed)==60
        for row in parsed:rows.append(dict(pair=pair,binary=name,**row))
manifest['elapsed_seconds']=round(time.monotonic()-start,3)
with (OUT/'paired.csv').open('w') as f:
    writer=csv.DictWriter(f,fieldnames=list(rows[0]));writer.writeheader();writer.writerows(rows)
summary=[]
for key in dict.fromkeys(tuple(row[k] for k in ['count','every','exact','stage']) for row in rows):
    group=[row for row in rows if tuple(row[k] for k in ['count','every','exact','stage'])==key]
    item=dict(zip(['count','every','exact','stage'],key))
    for name in bins:
        part=[row for row in group if row['binary']==name];assert len(part)==11
        for column in ['ns','allocations','requested','delta','retained','peak']:
            values=[int(row[column]) for row in part]
            if column!='ns': assert len(set(values))==1,(key,name,column,values)
            item[f'{name}_{column}']=statistics.median(values)
    item['time_change_percent']=(item['candidate_ns']/item['baseline_ns']-1)*100
    summary.append(item)
with (OUT/'summary.csv').open('w') as f:
    writer=csv.DictWriter(f,fieldnames=list(summary[0]));writer.writeheader();writer.writerows(summary)
for path in sorted(OUT.glob('raw-*.csv')):manifest.setdefault('raw_sha256',{})[path.name]=hashlib.sha256(path.read_bytes()).hexdigest()
manifest['paired_sha256']=hashlib.sha256((OUT/'paired.csv').read_bytes()).hexdigest()
(OUT/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps(manifest,indent=2))
