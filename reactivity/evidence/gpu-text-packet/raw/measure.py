from pathlib import Path
import subprocess,json,hashlib,csv,statistics,platform,time,os,gzip,math,re
root=Path(__file__).resolve().parent;out=root/'paired';out.mkdir(exist_ok=False)
cases=[(r,n,m) for r in [0,25,1000] for m in ['exact','full'] for n in [1,2,4]]+[(r,1,'stream') for r in [0,25,1000]]
receipts={n:json.loads((root/p/'artifact.json').read_text()) for n,p in [('control','control'),('candidate','qualified')]};paths={n:Path(a['path']) for n,a in receipts.items()};font=Path('/home/user/zgx-reference-local/comparisons/fonts/DejaVuSans.ttf');hashes={n:hashlib.sha256(p.read_bytes()).hexdigest() for n,p in {**paths,'font':font}.items()}
for n in paths:assert hashes[n]==receipts[n]['sha256'];assert json.loads(receipts[n]['fingerprint']['features'])==['default','gpu-tests','simd','vulkan-tests']
worktrees={n:Path('/home/user/gpui-gpu-text-packet'+suffix+'-lab') for n,suffix in [('control','-control'),('candidate','')]}
def inputs(wt):
 return {p:hashlib.sha256((wt/p).read_bytes()).hexdigest() for p in subprocess.check_output(['git','ls-files','-z','reactivity','.cargo','clippy.toml'],cwd=wt).decode().split('\0') if p and (wt/p).is_file()}
assert all(not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip() for w in worktrees.values())
before={n:inputs(w) for n,w in worktrees.items()};(out/'inputs-before.json').write_text(json.dumps(before));heads={n:subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip() for n,w in worktrees.items()}
# Native-only integration after the GPU artifact must not change its sources or fixture.
compiled=(root/'qualified/source.txt').read_text().strip();assert not subprocess.check_output(['git','diff',compiled,'HEAD','--','reactivity/crates/gpu','reactivity/crates/canvas','reactivity/crates/core','reactivity/crates/gpui/examples/support/zgx_workload','reactivity/vendor','.cargo','reactivity/Cargo.toml','reactivity/Cargo.lock','reactivity/rust-toolchain.toml','clippy.toml'],cwd=worktrees['candidate']).strip()
env={'XDG_RUNTIME_DIR':'/home/user/gpui-xdg','VK_ICD_FILENAMES':'/usr/share/vulkan/icd.d/lvp_icd.json','LP_NUM_THREADS':'4'}
meta={'cases':cases,'warmup':10,'frames':60,'affinity':'2-5','environment':env,'hashes':hashes,'binaries':{n:str(p) for n,p in paths.items()},'font':str(font),'current_heads':heads,'built_sources':{n:(root/p/'source.txt').read_text().strip() for n,p in [('control','control'),('candidate','qualified')]},'endpoint':'Canonical delta construction plus GPU preparation/submission/queue completion; cached shaped layouts prepared outside timing; no native scanout','compiler':subprocess.check_output(['rustc','+nightly-2026-10-23','-Vv'],text=True),'platform':platform.platform(),'start':time.time()};(out/'metadata.json').write_text(json.dumps(meta,indent=2))
runs=[];images={};finals={}
for repeat in range(5):
 for cell,(labels,fields,mode) in enumerate(cases):
  case=f'{labels}-{fields}-{mode}';names=['control','candidate'] if (repeat+cell)%2==0 else ['candidate','control']
  for name in names:
   stem=f'{repeat}-{case}-{name}';cmd=['/usr/bin/time','-v','-o',str(out/(stem+'.time')),'taskset','-c','2-5',str(paths[name]),str(labels),str(fields),mode,str(font),str(out/stem)]
   with (out/(stem+'.csv')).open('w') as a,(out/(stem+'.log')).open('w') as b:r=subprocess.run(cmd,env={**os.environ,**env},stdout=a,stderr=b)
   (out/(stem+'.status.json')).write_text(json.dumps({'command':cmd,'exit':r.returncode}));assert r.returncode==0,stem
   rows=list(csv.DictReader((out/(stem+'.csv')).open()));assert len(rows)==60 and [int(r['frame']) for r in rows]==list(range(60));assert all((r['labels'],r['fields'],r['mode'])==(str(labels),str(fields),mode) for r in rows)
   log=(out/(stem+'.log')).read_text();final=next(s for s in log.splitlines() if s.startswith('FINAL,'));assert final==finals.setdefault(case,final)
   image_hashes={}
   for phase in ['initial','final']:
    file=out/(stem+'.'+phase+'.rgba');data=file.read_bytes();assert len(data)==960*720*4;digest=hashlib.sha256(data).hexdigest();assert digest==images.setdefault((case,phase),digest);image_hashes[phase]=digest
    compressed=gzip.compress(data,compresslevel=1,mtime=0);assert gzip.decompress(compressed)==data;file.with_suffix(file.suffix+'.gz').write_bytes(compressed);file.unlink()
   record={'repeat':repeat,'case':case,'variant':name,'final':final,'images':image_hashes,'canonical_sparse':sum(r['canonical_sparse']=='true' for r in rows),'packet_reused':sum(r['packet_reused']=='true' for r in rows)}
   if name=='control' or mode=='full':assert record['packet_reused']==0
   for clock in ['host_ns','complete_ns']:
    v=sorted(int(r[clock]) for r in rows);record[clock]={'p50':statistics.median(v),'p95':v[math.ceil(.95*len(v))-1],'p99':v[math.ceil(.99*len(v))-1]}
   record['cold_wall_ns']=int(re.search(r'COLD,wall_ns=(\d+)',log).group(1));record['max_rss_kib']=int(re.search(r'Maximum resident set size \(kbytes\): (\d+)',(out/(stem+'.time')).read_text()).group(1))
   for key in ['validated_draws','binning_tile_visits','upload_bytes','bind_groups','mask_upload_bytes','cpu_index_bytes','gpu_buffer_bytes','atlas_bytes']:
    v=[int(r[key]) for r in rows];record[key]={'median':statistics.median(v),'range':[min(v),max(v)]}
   runs.append(record)
  print(repeat,case,{r['variant']:round(r['complete_ns']['p50']/1000,2) for r in runs if r['repeat']==repeat and r['case']==case},flush=True)
ratios={}
for labels,fields,mode in cases:
 case=f'{labels}-{fields}-{mode}';v=[]
 for repeat in range(5):
  pair={r['variant']:r for r in runs if r['repeat']==repeat and r['case']==case};v.append(pair['candidate']['complete_ns']['p50']/pair['control']['complete_ns']['p50'])
 ratios[case]={'paired_ratios':v,'median':statistics.median(v),'range':[min(v),max(v)]}
(out/'summary.json').write_text(json.dumps({'runs':runs,'ratios':ratios},indent=2));after={n:inputs(w) for n,w in worktrees.items()};changes={n:[p for p in set(before[n])|set(after[n]) if before[n].get(p)!=after[n].get(p)] for n in worktrees};(out/'guard-after.json').write_text(json.dumps(changes));assert not any(changes.values());assert all(hashlib.sha256(p.read_bytes()).hexdigest()==hashes[n] for n,p in {**paths,'font':font}.items());print(json.dumps(ratios,indent=2))
