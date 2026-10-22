from pathlib import Path
import subprocess, json, hashlib, time, datetime, csv, io, statistics
base=Path('/tmp/gpui-fearless-evidence'); out=base/'paired-timing-coordinate';out.mkdir(exist_ok=True)
flavors=['baseline','abi','coordinate','abi-scalar','coordinate-scalar']
cases=['one','nearest','shear','p3','premul','hdr','tiny','shared48']
def snapshot(name):
 data={p:Path(p).read_text() for p in ['/proc/loadavg','/proc/pressure/cpu','/proc/pressure/memory','/proc/pressure/io']}
 data['processes']=subprocess.check_output(['ps','-eo','pid,comm,pcpu,stat'],text=True)
 data['utc']=datetime.datetime.now(datetime.timezone.utc).isoformat()
 (out/(name+'.json')).write_text(json.dumps(data,indent=2)+'\n')
ledger=json.loads((base/'isolated-build-ledger.json').read_text())
ledger=[row for row in ledger if row['name'] in flavors]
assert len(ledger)==5
by_flavor={row['name']:row for row in ledger}
def guard(phase):
    records={}
    for row in ledger:
        for field in ['source_files','artifact_files']:
            for path, expected in row[field].items():
                actual=hashlib.sha256(Path(path).read_bytes()).hexdigest()
                assert actual==expected,(phase,path,expected,actual)
                records[path]=actual
    (out/(phase+'-source-artifact-guard.json')).write_text(json.dumps(records,indent=2)+'\n')
guard('before')
snapshot('before')
metadata={'source_commits':{'baseline':'05af5841e15cdddd9f0bce62b9f35ccc9966c312','aos':'8e29a3d7f3','soa':'d4166fd673'},'compiler':subprocess.check_output(['rustc','-vV'],text=True),'binary_sha256':{},'source_sha256':{},'build_logs_sha256':{},'policy':'Root-authorized quiet window. Sequential interleaved processes; no builds or CPU tests. Three rounds. Whole CPU example includes glyph/text, uniform/proof controls, transformed primitives; image example includes tap/filter/decode, source packing and output reduction. Internal timings remain original source Instant measurements. No affinity or governor changes.'}
metadata['isolated_build_ledger']=ledger
metadata['source_commits']={row['name']:row['source_commit'] for row in ledger}
for row in ledger:
 for path,sha in row['artifact_files'].items(): metadata['binary_sha256'][path]=sha
for name in ['cpu.rs','image_axis.rs']:
 values=[]
 for source in ['/tmp/gpui-fearless-baseline','/tmp/gpui-fearless-abi-source','/tmp/gpui-fearless-coordinate-source']:
  p=Path(source)/'reactivity/crates/canvas/examples'/name
  values.append(hashlib.sha256(p.read_bytes()).hexdigest())
 assert len(set(values))==1,(name,values)
 metadata['source_sha256'][name]=values[0]
(out/'metadata.json').write_text(json.dumps(metadata,indent=2)+'\n')
rows=[];digests={};cpu_stats={};start=time.perf_counter();deadline=start+88
for round_index in range(3):
 order=flavors[round_index:]+flavors[:round_index]
 for kind,case in [('cpu','all')]+[('images',c) for c in cases]:
  for flavor in order:
   if time.perf_counter()>deadline:raise RuntimeError('timing window limit reached; retained partial records')
   binary=Path(by_flavor[flavor]['target'])/'release/examples'/('cpu' if kind=='cpu' else 'image_axis')
   expected=by_flavor[flavor]['artifact_files'][str(binary)]
   assert hashlib.sha256(binary.read_bytes()).hexdigest()==expected
   cmd=[str(binary)]+([] if kind=='cpu' else [case])
   result=subprocess.run(cmd,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,check=True)
   assert hashlib.sha256(binary.read_bytes()).hexdigest()==expected
   prefix=out/f'{round_index}-{flavor}-{kind}-{case}'
   prefix.with_suffix('.stdout').write_text(result.stdout);prefix.with_suffix('.stderr').write_text(result.stderr)
   for fields in csv.reader(io.StringIO(result.stdout)):
    if kind=='cpu' and len(fields)==14 and fields[1] in ['true','false']:
     key=(fields[0],fields[1]); stats=fields[3:]
     if key in cpu_stats:assert cpu_stats[key]==stats,(key,flavor,stats,cpu_stats[key])
     cpu_stats[key]=stats
     rows.append(dict(round=round_index,flavor=flavor,kind=kind,case=fields[0],proofs=fields[1],microseconds=float(fields[2])))
    if kind=='images' and len(fields)==10 and fields[0]==case:
     key=case; digest=fields[-1]
     if key in digests:assert digests[key]==digest,(key,flavor,digest,digests[key])
     digests[key]=digest
     rows.append(dict(round=round_index,flavor=flavor,kind=kind,case=case,frame=int(fields[1]),microseconds=float(fields[2]),allocations=int(fields[3]),allocation_bytes=int(fields[4]),digest=digest))
   (out/'rows.json').write_text(json.dumps(rows,indent=2)+'\n')
  print(json.dumps({'round':round_index,'kind':kind,'case':case,'elapsed_seconds':round(time.perf_counter()-start,3)}),flush=True)
guard('after')
snapshot('after')
summary=[]
keys=sorted(set((r['kind'],r['case'],r.get('proofs','')) for r in rows))
for kind,case,proofs in keys:
 group={}
 for flavor in flavors:
  matching=[r['microseconds'] for r in rows if r['flavor']==flavor and r['kind']==kind and r['case']==case and r.get('proofs','')==proofs and (kind!='images' or r['frame']>0)]
  if matching:group[flavor]=statistics.median(matching)
 baseline=group['baseline'];summary.append(dict(kind=kind,case=case,proofs=proofs,median_microseconds=group,ratio_to_baseline={f:v/baseline for f,v in group.items()}))
(out/'summary.json').write_text(json.dumps(summary,indent=2)+'\n')
print(json.dumps({'complete':True,'elapsed_seconds':time.perf_counter()-start,'records':len(rows),'image_digests':digests}),flush=True)
