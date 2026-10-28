from pathlib import Path
import hashlib,json,statistics,subprocess,itertools
root=Path(__file__).resolve().parent;r=root/'raw'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=json.loads((root/'manifest.json').read_text())
for p,h in manifest.items():assert sha(root/p)==h,p
for n,count in [('control',17),('sparse',17),('zgx',1)]:
 g=r/('build-'+n)
 for stage in ['build','test']:
  s=json.loads((g/(stage+'.status.json')).read_text());assert s['exit']==0 and s['minimum_free_bytes']>=8*1024**3 and not s['storage_stop']
 assert f'{count} passed; 0 failed; 0 ignored' in (g/'test.out').read_text()
 assert json.loads((g/'guard-after.json').read_text())==[]
 e=json.loads((g/'environment.json').read_text());assert e['CARGO_PROFILE_RELEASE_LTO']=='fat' and e['CARGO_PROFILE_RELEASE_CODEGEN_UNITS']=='1' and e['CARGO_PROFILE_RELEASE_OPT_LEVEL']=='3'
a=json.loads((r/'analysis.json').read_text());assert a['processes']==72
orders=json.loads((r/'timing/order.json').read_text());assert len(orders)==24
for mode in ['idle','stream','scroll','both']:
 assert {tuple(g['order']) for g in orders if g['mode']==mode}==set(itertools.permutations(['control','sparse','zgx']))
 for n in ['control','sparse','zgx']:
  rates=[];ticks=[];qualified=[]
  for group in range(6):
   p=r/'timing'/mode/str(group)/n;s=json.loads((p/'status.json').read_text());summary=json.loads((p/'summary.json').read_text());samples=json.loads((p/'samples.json').read_text());assert s['exit']==0
   observed=[x for x in samples if summary['visible_seconds']+1<=x['at']<=summary['visible_seconds']+6 and x['state']!='Z'];dt=observed[-1]['at']-observed[0]['at'];cpu=observed[-1]['cpu_seconds']-observed[0]['cpu_seconds'];assert dt>=4.8 and dt==summary['interval_seconds'] and cpu==summary['cpu_seconds']
   assert cpu/dt==summary['cpu_cores'];assert statistics.mean(x['rss_bytes'] for x in observed)==summary['mean_rss_bytes'];assert max(x['rss_bytes'] for x in observed)==summary['max_rss_bytes']
   assert summary['font_sha256']=='7da195a74c55bef988d0d48f9508bd5d849425c1770dba5d7bfc6ce9ed848954'
   expected_pass=mode=='idle' or 464<=summary['ticks']<=488
   assert (s['failure'] is None)==expected_pass
   if not expected_pass:assert 'unequal/insufficient admitted work' in s['failure']
   if n=='zgx':assert summary['ticks']==(0 if mode=='idle' else 479)
   rates.append(cpu/dt);ticks.append(summary['ticks']);qualified.append(expected_pass)
  saved=a['rows'][mode][n];assert saved['cpu_cores_all']==rates and saved['cpu_cores_median']==statistics.median(rates) and saved['ticks_all']==ticks and saved['qualified']==qualified
  assert all(qualified) if mode=='idle' or n=='zgx' else not any(qualified)
for n in ['control','sparse','zgx']:
 for stage in ['capture','idle','stream','scroll','both']:
  p=r/'preflight'/n/stage;s=json.loads((p/'status.json').read_text());assert s['exit']==0 and s['failure'] is None
q=json.loads((r/'native-image-equality.json').read_text());assert q['exit']==0 and q['stderr']=='0'
p=subprocess.run(['compare','-metric','AE',str(r/'preflight/control/capture/native.png'),str(r/'preflight/sparse/capture/native.png'),'null:'],capture_output=True,text=True);assert p.returncode==0 and p.stderr=='0'
guard=json.loads((r/'guard-after-timing.json').read_text());assert all(v==[] for v in guard['sources'].values()) and guard['scripts_unchanged']
for name,h in json.loads((r/'timing-inputs.json').read_text())['scripts'].items():assert sha(r/name)==h
frozen=json.loads((r/'frozen/artifacts.json').read_text());seen=set()
for n in frozen:
 for stage in ['build','test']:
  aa=json.loads((r/('build-'+n)/(stage+'-artifacts.json')).read_text());assert len(aa)==1
  for x in aa:assert sha(Path(x['preserved']))==x['sha256'];seen.add(x['sha256'])
 if n!='zgx':
  shader=(r/'frozen'/f'{n}-ui.wgsl').read_bytes();elf=Path(frozen[n]['artifact']['preserved']).read_bytes();assert hashlib.sha256(shader).hexdigest()=='ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1';assert shader in elf
for p in (r/'timing').rglob('artifact.json'):
 x=json.loads(p.read_text());assert x==frozen[p.parent.name]['artifact']
assert 'llvmpipe' in (r/'frozen/vulkan.out').read_text();assert not json.loads((r/'frozen/device.json').read_text())['dev_dri_exists']
print('verified',len(manifest),'files;72 timed processes,36 cadence failures,15 native preflights,35 application tests;',len(seen),'preserved executable identities; no performance victory')
