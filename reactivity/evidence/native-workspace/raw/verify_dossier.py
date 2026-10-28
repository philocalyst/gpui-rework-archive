from pathlib import Path
import hashlib,json,statistics,subprocess,itertools,random,re
from collections import Counter
root=Path(__file__).resolve().parent;r=root/'raw'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
def quantile(xs,p):
 a=sorted(xs);at=(len(a)-1)*p;i=int(at);return a[i]+(a[min(i+1,len(a)-1)]-a[i])*(at-i)
manifest=json.loads((root/'manifest.json').read_text())
assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p!=root/'manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
spec=json.loads((root/'COST.json').read_text());assert spec==json.loads((r/'COST.json').read_text())
names=['control','sparse','candidate','zgx'];modes=['idle','stream','scroll','both']
assert spec['names']==names and spec['modes']==modes and spec['seed']==20261107 and spec['processes']==128
assert spec['seconds']==8 and spec['groups_per_mode']==8 and spec['cadence_hz']==[58,61]
assert spec['candidate_cpu_ratio_limit']==.8 and spec['idle_cpu_cores_limit']==.01 and spec['bootstrap_resamples']==10000
gates=json.loads((r/'build-gates.json').read_text());profiles={}
for n,count in [('control',17),('sparse',17),('candidate',17),('zgx',1)]:
 g=r/gates[n]
 for stage in ['build','test']:
  s=json.loads((g/(stage+'.status.json')).read_text());assert s['exit']==0 and s['minimum_free_bytes']>=8*1024**3 and not s['storage_stop']
 assert f'{count} passed; 0 failed; 0 ignored' in (g/'test.out').read_text()
 assert json.loads((g/'guard-after.json').read_text())==[]
 e=json.loads((g/'environment.json').read_text());assert e['CARGO_PROFILE_RELEASE_LTO']=='fat' and e['CARGO_PROFILE_RELEASE_CODEGEN_UNITS']=='1' and e['CARGO_PROFILE_RELEASE_OPT_LEVEL']=='3'
 profiles[n]={k:v for k,v in e.items() if k not in ['CARGO_TARGET_DIR','CARGO_BUILD_JOBS']}
assert all(v==profiles['candidate'] for v in profiles.values())
seq=[]
for k in range(4):
 s=[(v+k)%4 for v in [0,1,3,2]];seq.extend([s,s[::-1]])
assert all(sum(s[i]==v for s in seq)==2 for i in range(4) for v in range(4))
assert all(sum(s.index(a)<s.index(b) for s in seq)==4 for a,b in itertools.combinations(range(4),2))
adj=Counter((a,b) for s in seq for a,b in zip(s,s[1:]));assert len(adj)==12 and set(adj.values())=={2}
expected=[dict(mode=mode,group=i,order=[names[v] for v in seq[(i+ci)%8]]) for ci,mode in enumerate(modes) for i in range(8)]
random.Random(20261107).shuffle(expected);orders=json.loads((r/'timing/order.json').read_text());assert orders==expected==json.loads((root/'PROCESS_ORDER.json').read_text())
assert sha(root/'PROCESS_ORDER.json')==spec['process_manifest_sha256']==sha(r/'timing/order.json')
a=json.loads((r/'analysis.json').read_text());assert a['processes']==128 and a['order_sha256']==spec['process_manifest_sha256']
assert len(list((r/'timing').rglob('status.json')))==128
all_items={};failures=[]
for mode in modes:
 all_items[mode]={}
 for n in names:
  items=[]
  for group in range(8):
   p=r/'timing'/mode/str(group)/n;status=json.loads((p/'status.json').read_text())
   if not (p/'summary.json').exists():
    assert status['failure'] is not None
    items.append(dict(summary={},qualified=False,status=status));failures.append((mode,group,n,status['failure']));continue
   x=json.loads((p/'summary.json').read_text());samples=json.loads((p/'samples.json').read_text());assert status['exit']==0
   observed=[q for q in samples if x['visible_seconds']+1<=q['at']<=x['visible_seconds']+6 and q['state']!='Z'];assert len(observed)>=2
   dt=observed[-1]['at']-observed[0]['at'];cpu=observed[-1]['cpu_seconds']-observed[0]['cpu_seconds'];assert dt>=4.8 and dt==x['interval_seconds'] and cpu==x['cpu_seconds']
   assert cpu/dt==x['cpu_cores'];assert statistics.mean(q['rss_bytes'] for q in observed)==x['mean_rss_bytes'];assert max(q['rss_bytes'] for q in observed)==x['max_rss_bytes']
   assert x['font_sha256']=='7da195a74c55bef988d0d48f9508bd5d849425c1770dba5d7bfc6ce9ed848954'
   env=json.loads((p/'environment.json').read_text());assert env['ZGX_MODE']==mode and env['ZGX_SECONDS']=='8' and env['ZGX_INITIAL_TICKS']=='0' and env['LP_NUM_THREADS']=='4'
   log=(p/'app.log').read_text();assert 'font_file_fnv64=ce252980ec1255ff' in log and 'PRESENTATION_ERROR' not in log and 'workload_error=' not in log
   if n=='zgx':
    final=[json.loads(line) for line in (p/'app.out').read_text().splitlines() if line.startswith('{') and '"adapter":"components"' in line];assert len(final)==1 and final[0]['renderer']=='gpu';ticks=final[0]['ticks']
   else:
    found=re.findall(r'workload_ticks=(\d+) admitted_ticks=(\d+) workload_scroll_offset=([^\n]+)',log);assert len(found)==1 and found[0][0]==found[0][1];ticks=int(found[0][1])
    ack=re.findall(r'native_acknowledgements=(\d+)',log);assert len(ack)==1 and int(ack[0])==x['native_acknowledgements']
   assert ticks==x['ticks'];geometry=(p/'geometry.txt').read_text();assert 'WIDTH=960\n' in geometry and 'HEIGHT=720\n' in geometry
   expected_pass=(ticks==0 and (n!='candidate' or x['cpu_cores']<=.01)) if mode=='idle' else 464<=ticks<=488
   assert (status['failure'] is None)==expected_pass
   if not expected_pass:
    assert ('idle CPU gate' if mode=='idle' else 'unequal/insufficient admitted work') in status['failure'];failures.append((mode,group,n,status['failure']))
   items.append(dict(summary=x,qualified=expected_pass,status=status))
  all_items[mode][n]=items;saved=a['rows'][mode][n]
  for key,field in [('cpu_cores_all','cpu_cores'),('ticks_all','ticks'),('interval_seconds_all','interval_seconds'),('native_acknowledgements_all','native_acknowledgements'),('visible_seconds_all','visible_seconds')]:assert saved[key]==[v['summary'].get(field) for v in items]
  rates=saved['cpu_cores_all'];assert saved['cpu_cores_median']==(statistics.median(rates) if all(v is not None for v in rates) else None)
  assert saved['qualified']==[v['qualified'] for v in items] and saved['failures']==[v['status']['failure'] for v in items]
  rss=[v['summary'].get('mean_rss_bytes') for v in items];peak=[v['summary'].get('max_rss_bytes') for v in items]
  assert saved['median_mean_rss_bytes']==(statistics.median(rss) if all(v is not None for v in rss) else None)
  assert saved['maximum_sampled_rss_bytes']==(max(peak) if all(v is not None for v in peak) else None)
 for left,right in [('candidate','zgx'),('candidate','control'),('candidate','sparse')]:
  ratios=[];equal=[]
  for x,y in zip(all_items[mode][left],all_items[mode][right]):
   xx=x['summary'];yy=y['summary'];den=yy.get('cpu_cores');ratios.append(xx['cpu_cores']/den if x['qualified'] and y['qualified'] and den else None);equal.append(xx.get('ticks')==yy.get('ticks') if xx and yy else None)
  saved=a['comparisons'][mode][left+'/'+right];assert saved['paired_cpu_rate_ratios']==ratios and saved['equal_total_ticks_each_pair']==equal
  if all(v is not None for v in ratios):
   rng=random.Random(20261107);boot=[statistics.median(rng.choices(ratios,k=8)) for _ in range(10000)]
   assert saved['median_ratio']==statistics.median(ratios) and saved['bootstrap_95_type7']==[quantile(boot,.025),quantile(boot,.975)]
  else:assert 'median_ratio' not in saved and 'bootstrap_95_type7' not in saved
 if mode=='idle':expected_gate=all(v['qualified'] and v['summary'].get('ticks')==0 and v['summary'].get('cpu_cores',float('inf'))<=.01 for v in all_items[mode]['candidate'])
 else:
  qualified=all(v['qualified'] for n in ['candidate','zgx'] for v in all_items[mode][n]);ratio=a['comparisons'][mode]['candidate/zgx'].get('median_ratio');expected_gate=qualified and ratio is not None and ratio<=.8
  assert a['gates'][mode]['candidate_and_zgx_all_qualified']==qualified and a['gates'][mode]['median_ratio']==ratio and a['gates'][mode]['limit']==.8
 assert a['gates'][mode]['pass_gate']==expected_gate
assert a['local_native_gates_pass']==all(v['pass_gate'] for v in a['gates'].values())
for n in names:
 for stage in ['capture','idle','stream','scroll','both']:
  p=r/'preflight'/n/stage;s=json.loads((p/'status.json').read_text());assert s['exit']==0 and s['failure'] is None
q=json.loads((r/'native-image-equality.json').read_text())
for n in ['sparse','candidate']:
 saved=next(x for x in q['comparisons'] if x['variant']==n);assert saved['exit']==0 and saved['stderr']=='0'
 p=subprocess.run(['compare','-metric','AE',str(r/'preflight/control/capture/native.png'),str(r/'preflight'/n/'capture/native.png'),'null:'],capture_output=True,text=True);assert p.returncode==0 and p.stderr=='0'
guard=json.loads((r/'guard-after-timing.json').read_text());assert all(v==[] for v in guard['sources'].values()) and guard['scripts_unchanged'] and guard['artifacts_unchanged']
frozen_inputs=json.loads((r/'timing-inputs.json').read_text())
for name,h in frozen_inputs['scripts'].items():assert sha(r/name)==h
assert sha(root/'verify.py')==frozen_inputs['scripts']['verify_dossier.py'] and sha(r/'frozen/artifacts.json')==frozen_inputs['artifacts_sha256']
frozen=json.loads((r/'frozen/artifacts.json').read_text());seen=set()
for n in names:
 for stage in ['build','test']:
  aa=json.loads((r/gates[n]/(stage+'-artifacts.json')).read_text());assert len(aa)==1
  for x in aa:assert sha(Path(x['preserved']))==x['sha256'];seen.add(x['sha256'])
 if n!='zgx':
  shader=(r/'frozen'/f'{n}-ui.wgsl').read_bytes();elf=Path(frozen[n]['artifact']['preserved']).read_bytes();assert hashlib.sha256(shader).hexdigest()=='ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1' and shader in elf
for p in (r/'timing').rglob('artifact.json'):assert json.loads(p.read_text())==frozen[p.parent.name]['artifact']
assert 'llvmpipe' in (r/'frozen/vulkan.out').read_text();assert not json.loads((r/'frozen/device.json').read_text())['dev_dri_exists']
print(f'verified {len(manifest)} files; 128 timed processes, {len(failures)} failed observations, 20 native preflights, 52 application tests; {len(seen)} preserved executable identities; local_native_gates_pass={a["local_native_gates_pass"]}; hardware/quality/scanout gates remain open')
