from pathlib import Path
import json,hashlib,re,statistics,random,subprocess
root=Path(__file__).resolve().parent;r=root/'raw'
def sha(p):return hashlib.file_digest(Path(p).open('rb'),'sha256').hexdigest()
def read(p):return json.loads(p.read_text())
manifest=read(root/'manifest.json');assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
f=read(r/'timing-inputs.json');spec=read(r/'SPEC.json');analysis=read(r/'analysis.json')
for p,h in f['files'].items():assert sha(r/p)==h,p
for p,h in f['environment_files'].items():assert sha(p)==h
for p in ['guard-before-timing.json','guard-after-timing.json','guard-analysis.json']:assert read(r/p)==[]
q=read(r/'qualification-reference.json');d=Path(q['dossier']);assert sha(d/'manifest.json')==q['manifest_sha256'] and sha(d/'verify.py')==q['verifier_sha256'];v=subprocess.run(['python3',str(d/'verify.py')],capture_output=True,text=True);assert v.returncode==0,v.stderr
assert read(r/'qualification-reverification.json')['exit']==0
artifacts=read(r/'artifacts.json');profiles=read(r/'profiles.json');assert profiles['baseline']==profiles['candidate'];assert profiles['candidate']['CARGO_PROFILE_RELEASE_LTO']=='fat' and profiles['candidate']['CARGO_PROFILE_RELEASE_CODEGEN_UNITS']=='1'
assert (r/'build-baseline/toolchain.txt').read_bytes()==(r/'build-candidate/toolchain.txt').read_bytes()
for name,a in artifacts.items():
 assert sha(a['preserved'])==a['sha256'];g=r/('build-'+name);assert read(g/'guard-after.json')==[] and '17 passed; 0 failed' in (g/'test.out').read_text()
 for stage in ['build','test']:assert read(g/(stage+'.status.json'))['exit']==0
 source=f['sources'][name];assert (g/'source.txt').read_text().strip()==source['compiled_source'];before=read(g/'inputs.json');current=read(r/(name+'-current-inputs.json'))
 for p,h in before.items():
  if any(p==x or p.startswith(x+'/') for x in source['build_paths']):assert current[p]==h
 # Documentation seals can differ; compiled inputs are checked against both immutable Git objects.
 w=Path(source['worktree']);assert not subprocess.check_output(['git','diff','--name-only',source['compiled_source'],source['current_source'],'--',*source['build_paths']],cwd=w).strip()
 for sh in [s for s in read(r/'shaders.json') if s['name']==name]:
  raw=(r/(name+'-ui.wgsl')).read_bytes();data=Path(a['preserved']).read_bytes();assert len(raw)==sh['bytes'] and hashlib.sha256(raw).hexdigest()==sh['sha256'] and data[sh['elf_offset']:sh['elf_offset']+sh['bytes']]==raw
assert read(r/'image-comparison.json')=={str(i):dict(exit=0,stdout='',stderr='0') for i in [0,190]}
for i in [0,190]:
 p=subprocess.run(['compare','-metric','AE',str(r/f'preflight/baseline/capture-{i}/native.png'),str(r/f'preflight/candidate/capture-{i}/native.png'),'null:'],capture_output=True,text=True);assert p.returncode==0 and p.stderr.strip()=='0'
orders=[dict(mode=m,group=g,order=['baseline','candidate'] if g%2==0 else ['candidate','baseline']) for m in spec['modes'] for g in range(8)];random.Random(spec['seed']).shuffle(orders);assert read(r/'PROCESS_ORDER.json')==orders and sha(r/'PROCESS_ORDER.json')==spec['order_sha256']
expected=[(g['mode'],g['group'],n) for g in orders for n in g['order']];assert [(x['mode'],x['group'],x['name']) for x in analysis['rows']]==expected

def validate(p,name,mode,seconds,initial,timed):
 status=read(p/'status.json');assert status['timed']==timed
 if not (p/'summary.json').exists():return status,None,False,False
 s=read(p/'summary.json');log=(p/'app.log').read_text();env=read(p/'environment.json');assert s['name']==name and s['mode']==mode and s['route']=='exact' and s['initial']==initial
 assert env['ZGX_MODE']==mode and env['ZGX_SECONDS']==str(seconds) and env['ZGX_INITIAL_TICKS']==str(initial) and env['GPUI_LAB_TRACE']=='1' and 'GPUI_LAB_INGRESS' not in env
 assert env['LP_NUM_THREADS']=='4' and env['DISPLAY']==':94' and env['GPUI_LAB_RENDERER']=='gpu'
 assert ('source_ingress='+('exact' if mode=='stream' else 'owner')) in log and 'PRESENTATION_ERROR' not in log and 'workload_error=' not in log
 assert s['font_sha256']=='7da195a74c55bef988d0d48f9508bd5d849425c1770dba5d7bfc6ce9ed848954'
 font=Path(env['ZGX_FONT_FILE']).read_bytes();fnv=0xcbf29ce484222325
 for byte in font:fnv=((fnv^byte)*0x100000001b3)&((1<<64)-1)
 assert f'font_file_fnv64={fnv:016x}' in log
 geom=(p/'geometry.txt').read_text();assert 'WIDTH=960\n' in geom and 'HEIGHT=720\n' in geom
 assert read(p/'artifact.json')['sha256']==artifacts[name]['sha256']
 matches=re.findall(r'workload_ticks=(\d+) admitted_ticks=(\d+) workload_scroll_offset=([^\n]+)',log);assert len(matches)==1;total,ticks,offset=matches[0];assert int(total)==int(ticks)+initial and int(ticks)==s['ticks'];assert s['reference_or_model_final']==dict(total_ticks=int(total),scroll_offset=float(offset))
 ack=[dict(source_epoch=int(x),presentation_epoch=int(y),at_ns=int(z)) for x,y,z in re.findall(r'^GPUI_ACK,(\d+),(\d+),(\d+)$',log,re.M)];assert ack==read(p/'acks.json') and ack;assert len(ack)==s['native_acknowledgements']==int(re.findall(r'native_acknowledgements=(\d+)',log)[0])
 gaps=[(b['at_ns']/1e9,(b['at_ns']-a['at_ns'])/1e6) for a,b in zip(ack,ack[1:])];assert all(d>=0 for t,d in gaps)
 first=sum(t<1 and d>25 for t,d in gaps);later=sum(t>=1 and d>25 for t,d in gaps);assert (first,later,first+later)==(s['first_second_gaps_over25ms'],s['later_gaps_over25ms'],s['total_gaps_over25ms'])
 cadence=int(ticks)==0 if mode=='idle' else 58*seconds<=int(ticks)<=61*seconds;gap=first<=2 and later==0;assert s['cadence_pass']==cadence and s['gap_gate_pass']==gap
 samples=read(p/'samples.json');assert len(samples)==s['samples']
 if timed:
  interval=[x for x in samples if s['visible_seconds']+1<=x['at']<=s['visible_seconds']+6 and x['state']!='Z'];dt=interval[-1]['at']-interval[0]['at'];cpu=interval[-1]['cpu_seconds']-interval[0]['cpu_seconds'];assert dt>=4.8
  assert (s['interval_start'],s['interval_end'],s['interval_seconds'],s['cpu_seconds'],s['cpu_cores'])==(interval[0]['at'],interval[-1]['at'],dt,cpu,cpu/dt)
  assert s['mean_rss_bytes']==statistics.mean(x['rss_bytes'] for x in interval) and s['max_rss_bytes']==max(x['rss_bytes'] for x in interval)
 execution=status['exit']==0 and status['failure'] is None
 return status,s,execution,execution and cadence and gap
for name in ['baseline','candidate']:
 for i in [0,190]:assert validate(r/'preflight'/name/('capture-'+str(i)),name,'idle',4,i,False)[2]
 for mode in ['stream','scroll','both']:assert validate(r/'preflight'/name/mode,name,mode,3,0,False)[2]
for row in analysis['rows']:
 p=r/'timing'/row['mode']/str(row['group'])/row['name'];status,s,execution,work=validate(p,row['name'],row['mode'],8,0,True);assert (status,s,execution,work)==(row['status'],row['summary'],row['execution_pass'],row['work_pass'])
def quantile(xs,q):
 a=sorted(xs);at=(len(a)-1)*q;i=int(at);return a[i]+(a[min(i+1,len(a)-1)]-a[i])*(at-i)
passed=[]
for mode in spec['modes']:
 rows=[x for x in analysis['rows'] if x['mode']==mode];eligible=len(rows)==16 and all(x['work_pass'] for x in rows);c=analysis['comparisons'][mode]
 for name in ['baseline','candidate']:
  cells=[x for x in rows if x['name']==name];ss=[x['summary'] for x in cells if x['summary'] is not None];agg=analysis['aggregates'][mode][name]
  assert (agg['observations'],agg['execution_passes'],agg['work_passes'])==(8,sum(x['execution_pass'] for x in cells),sum(x['work_pass'] for x in cells))
  for field in ['ticks','first_second_gaps_over25ms','later_gaps_over25ms','total_gaps_over25ms']:assert agg[field]==[s[field] for s in ss]
  for field in ['cpu_cores','mean_rss_bytes','max_rss_bytes','visible_seconds']:
   values=[s[field] for s in ss if field in s];assert agg[field+'_median']==(statistics.median(values) if len(values)==8 else None)
 if not eligible:assert not c['eligible'] and not c['passed'] and 'median_paired_cpu_ratio' not in c;passed.append(False);continue
 if mode=='idle':
  b=statistics.median(x['summary']['cpu_cores'] for x in rows if x['name']=='baseline');v=statistics.median(x['summary']['cpu_cores'] for x in rows if x['name']=='candidate');assert c['eligible'] and c['baseline_cpu']==b and c['candidate_cpu']==v and c['ratio'] is None and c['passed']==(v<=b);passed.append(v<=b);continue
 pairs=[]
 for group in range(8):
  b=next(x['summary']['cpu_cores'] for x in rows if x['name']=='baseline' and x['group']==group);v=next(x['summary']['cpu_cores'] for x in rows if x['name']=='candidate' and x['group']==group);pairs.append(dict(group=group,baseline_cpu=b,candidate_cpu=v,ratio=v/b if b>0 else None))
 assert c['pairs']==pairs
 if any(x['ratio'] is None for x in pairs):assert not c['eligible'] and not c['passed'];passed.append(False);continue
 ratios=[x['ratio'] for x in pairs];point=statistics.median(ratios);rng=random.Random(spec['seed']);boot=[statistics.median(rng.choices(ratios,k=8)) for _ in range(10000)];assert c['eligible'] and c['median_paired_cpu_ratio']==point and c['paired_bootstrap_95']==[quantile(boot,.025),quantile(boot,.975)] and c['limit']==spec['limits'][mode] and c['passed']==(point<=spec['limits'][mode]);passed.append(c['passed'])
assert analysis['all_execution_pass']==all(x['execution_pass'] for x in analysis['rows']);assert analysis['candidate_passes']==(analysis['all_execution_pass'] and all(passed))
print(json.dumps(dict(files=len(manifest),fixed_processes=64,preflights=10,workload_tests=34,early_shader_admission_reverified=True,candidate_passes=analysis['candidate_passes'],scope='Software Vulkan; no ZGX/hardware/scanout or quality victory.')))
