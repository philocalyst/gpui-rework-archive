from pathlib import Path
import importlib.util,json,hashlib,time,datetime,subprocess
spec=importlib.util.spec_from_file_location('trace','/tmp/gpui-fearless-counter-trace.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
raw=Path('/tmp/gpui-fearless-evidence');out=raw/'counter-geometry-only';out.mkdir(exist_ok=True)
flavors=['baseline','geometry-only','geometry-only-scalar'];ledger=[r for r in json.loads((raw/'isolated-build-ledger.json').read_text())if r['name']in flavors];assert len(ledger)==3
by={r['name']:r for r in ledger}
def guard(name):
 records={}
 for r in ledger:
  for field in ['source_files','artifact_files']:
   for p,sha in r[field].items():
    actual=hashlib.sha256(Path(p).read_bytes()).hexdigest();assert actual==sha,(name,p,sha,actual);records[p]=actual
 (out/(name+'-guard.json')).write_text(json.dumps(records,indent=2)+'\n')
def snapshot(name):
 d={p:Path(p).read_text()for p in ['/proc/loadavg','/proc/pressure/cpu','/proc/pressure/memory','/proc/pressure/io']};d['processes']=subprocess.check_output(['ps','-eo','pid,comm,pcpu,stat'],text=True);d['utc']=datetime.datetime.now(datetime.timezone.utc).isoformat();(out/(name+'-context.json')).write_text(json.dumps(d,indent=2)+'\n')
guard('before');snapshot('before');stats={};records=[];start=time.perf_counter()
for rnd in range(3):
 order=flavors[rnd:]+flavors[:rnd]
 for f in order:
  assert time.perf_counter()-start<10,'quiet window exceeded'
  binary=str(Path(by[f]['target'])/'release/examples/cpu');r=module.trace(binary);assert len(r['records'])==12,(f,len(r['records']))
  for row in r['records']:
   fields=row['csv'].split(',');key=(fields[0],fields[1]);value=fields[3:]
   if key in stats:assert stats[key]==value,(key,f)
   stats[key]=value
  r['round']=rnd;r['flavor']=f;records.append(r);(out/f'{rnd}-{f}.json').write_text(json.dumps(r,indent=2)+'\n');print(json.dumps({'round':rnd,'flavor':f,'elapsed':time.perf_counter()-start}),flush=True)
guard('after');snapshot('after');(out/'records.json').write_text(json.dumps(records,indent=2)+'\n');(out/'metadata.json').write_text(json.dumps({'ledger':ledger,'mechanism':'Counter diagnostics only. Existing unchanged cpu process traced at stdout syscall boundaries. Includes original case setup,warm frame,3 timed full frames,formatting. User-mode grouped events. No traced timings used as performance evidence. Counts retained with enabled/running to reject multiplexing. Trap scheduling can disturb cache/branch state. No speed conclusions from counter ratios alone.'},indent=2)+'\n');print(json.dumps({'complete':True,'processes':len(records),'phases':sum(len(r['records'])for r in records),'elapsed':time.perf_counter()-start}))
