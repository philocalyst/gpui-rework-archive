from pathlib import Path
import hashlib,json,itertools,statistics
root=Path(__file__).resolve().parent;r=root/'raw'
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=json.loads((root/'manifest.json').read_text())
for p,h in manifest.items():assert sha(root/p)==h,p
f=json.loads((r/'freeze.json').read_text())
for p,h in f['scripts'].items():assert sha(r/p)==h
for p,h in f['driver_files'].items():assert sha(Path(p))==h
assert all(not v['changed_build_paths'] for v in f['source_guards'].values())
for a in json.loads((r/'artifacts.json').read_text()).values():assert sha(Path(a['artifact']['preserved']))==a['artifact']['sha256']
orders=json.loads((r/'order.json').read_text());assert len(orders)==9
analysis=json.loads((r/'analysis.json').read_text());assert len(analysis['rows'])==27
for mode in ['stream','scroll','both']:
 group=[o['order'] for o in orders if o['mode']==mode];assert len(group)==3
 for slot in range(3):assert {o[slot] for o in group}=={'control','sparse','zgx'}
for row in analysis['rows']:
 p=r/'runs'/row['mode']/str(row['group'])/row['name'];status=json.loads((p/'status.json').read_text());assert status['exit']==0 and status['failure'] is None
 summary=json.loads((p/'summary.json').read_text());raw=json.loads((p/'tasks.json').read_text());observations=[o for o in raw['observations'] if summary['interval_start']<=o['at']<=summary['interval_end']];assert len(observations)>2 and row['interval_seconds']>=2.8
 last={};totals={'main':0,'raster':0,'other':0}
 for i,o in enumerate(observations):
  for task in o['tasks']:
   k=(task['tid'],task['started']);old=last.get(k,task['cpu_ticks'] if i==0 else 0);delta=task['cpu_ticks']-old;assert delta>=0
   kind='main' if task['main'] else 'raster' if task['name'].startswith('llvmpipe-') else 'other';totals[kind]+=delta;last[k]=task['cpu_ticks']
 seconds={k:v/raw['clock_ticks_per_second'] for k,v in totals.items()}
 for k,v in seconds.items():assert abs(v-row['task_seconds'][k])<1e-12 and abs(v/row['interval_seconds']-row['task_cores'][k])<1e-12
 assert abs(row['process_cpu_seconds']-sum(seconds.values())-row['residual_seconds'])<1e-12
for mode,apps in analysis['aggregates'].items():
 for name,values in apps.items():
  selected=[x for x in analysis['rows'] if x['mode']==mode and x['name']==name]
  for k in ['main','raster','other']:assert statistics.median(x['task_cores'][k] for x in selected)==values['task_cores_median'][k]
for p,item in json.loads((r/'loaded-modules.json').read_text()).items():assert sha(Path(p))==item['sha256']
assert json.loads((r/'guard-after.json').read_text())=={'scripts_unchanged':True,'driver_files_unchanged':True}
print('verified',len(manifest),'files;27 native observations;3 unchanged executable identities; raw task CPU attribution and residuals; no performance qualification')
