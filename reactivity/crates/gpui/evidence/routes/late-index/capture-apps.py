from pathlib import Path
import csv,hashlib,json,os,re,statistics,subprocess,time

OUT=Path('/root/gpui-pan-viewports/reactivity/crates/gpui/evidence/routes/late-index')
bins={}
for name in ['baseline','candidate']:
    build=Path(f'/tmp/gpui-route-{name}-unit-build.log').read_text()
    bins[name]=Path(re.search(r'Executable unittests src/lib.rs \(([^)]+)\)',build)[1])
bins['baseline']=Path('/tmp/gpui-routes-c11-baseline-f2559c8f21f5c6998c59c931dcf3110172262835419be58bcf610000be6662aa')
hashes={name:hashlib.sha256(path.read_bytes()).hexdigest() for name,path in bins.items()}
rows=[]; start=time.monotonic()
for pair in range(5):
    for name in (['baseline','candidate'] if pair%2==0 else ['candidate','baseline']):
        assert hashlib.sha256(bins[name].read_bytes()).hexdigest()==hashes[name]
        output=subprocess.check_output([str(bins[name]),'runtime::style_ledger::retained_style_cost','--exact','--ignored','--nocapture'],text=True,preexec_fn=lambda:os.sched_setaffinity(0,{2}))
        assert 'test result: ok. 1 passed;' in output
        (OUT/f'apps-{pair:02}-{name}.txt').write_text(output)
        costs=re.findall(r'cost,([^,\n]+),([0-9]+),([0-9]+)',output);assert len(costs)==75,len(costs)
        for index,(operation,count,ns) in enumerate(costs):rows.append(dict(pair=pair,binary=name,round=index//25,operation=operation,count=int(count),ns=int(ns),ns_per_call=int(ns)/int(count)))
with (OUT/'apps-paired.csv').open('w') as f:
    w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
summary=[]
for operation in dict.fromkeys(row['operation'] for row in rows):
    item=dict(operation=operation)
    for name in bins:
        part=[row['ns_per_call'] for row in rows if row['operation']==operation and row['binary']==name];assert len(part)==15
        item[f'{name}_ns']=statistics.median(part)
    item['time_change_percent']=(item['candidate_ns']/item['baseline_ns']-1)*100;summary.append(item)
with (OUT/'apps-summary.csv').open('w') as f:
    w=csv.DictWriter(f,fieldnames=list(summary[0]));w.writeheader();w.writerows(summary)
manifest=dict(source_commits={'baseline':'40382ed1d9','candidate':'c8c84c15be'},binaries={k:dict(path=str(v),sha256=hashes[k]) for k,v in bins.items()},elapsed_seconds=round(time.monotonic()-start,3),cpu=2,rounds=5,scope='Existing unchanged style-cost public-operation fixtures; 3 warm batches per fresh process,5 alternating pairs. Mount fixture excludes drop from timer. Native input/upload/scanout excluded.',paired_sha256=hashlib.sha256((OUT/'apps-paired.csv').read_bytes()).hexdigest())
(OUT/'apps-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n');print(json.dumps(manifest))
