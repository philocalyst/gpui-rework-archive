from pathlib import Path
import json,hashlib,statistics
r=Path(__file__).parent;rows=[];maps={};freeze=json.loads((r/'freeze.json').read_text())
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
for name,h in freeze['scripts'].items():assert sha(r/name)==h
for p,h in freeze['driver_files'].items():assert sha(Path(p))==h
for mode in ['stream','scroll','both']:
 for group in range(3):
  for name in ['control','sparse','zgx']:
   p=r/'runs'/mode/str(group)/name;status=json.loads((p/'status.json').read_text());assert status['exit']==0 and status['failure'] is None
   summary=json.loads((p/'summary.json').read_text());raw=json.loads((p/'tasks.json').read_text());obs=[x for x in raw['observations'] if summary['interval_start']<=x['at']<=summary['interval_end']];assert len(obs)>2
   hz=raw['clock_ticks_per_second'];last={};charges={};births=[];disappeared=set();previous=set()
   for index,o in enumerate(obs):
    present=set()
    for t in o['tasks']:
     key=f"{t['tid']}:{t['started']}";present.add(key)
     if index and key not in last:births.append(key)
     delta=t['cpu_ticks']-last.get(key,t['cpu_ticks'] if index==0 else 0);assert delta>=0
     kind='main' if t['main'] else 'raster' if t['name'].startswith('llvmpipe-') else 'other'
     charge=charges.setdefault(key,{'name':t['name'],'kind':kind,'cpu_ticks':0});assert charge['kind']==kind;charge['cpu_ticks']+=delta;last[key]=t['cpu_ticks']
    disappeared|=previous-present;previous=present
   duration=summary['interval_seconds'];seconds={k:sum(t['cpu_ticks']/hz for t in charges.values() if t['kind']==k) for k in ['main','raster','other']};rate={k:v/duration for k,v in seconds.items()};total=sum(seconds.values());residual=summary['cpu_seconds']-total
   row={'mode':mode,'group':group,'name':name,'interval_seconds':duration,'process_cpu_seconds':summary['cpu_seconds'],'process_cores':summary['cpu_cores'],'task_seconds':seconds,'task_cores':rate,'residual_seconds':residual,'new_tasks':births,'disappeared_tasks':sorted(disappeared),'tasks':charges,'ticks':summary['ticks'],'native_acks':summary['native_acknowledgements']};rows.append(row)
   libs=[]
   for line in (p/'maps.txt').read_text().splitlines():
    parts=line.split(None,5)
    if len(parts)==6 and parts[5].startswith('/') and any(x in parts[5] for x in ['libvulkan','libLLVM','libEGL','libGLX','libgallium']):libs.append(parts[5])
   for file in set(libs):maps.setdefault(file,{'sha256':sha(Path(file)),'observed':[]})['observed'].append(f'{mode}/{group}/{name}')
aggregates={}
for mode in ['stream','scroll','both']:
 aggregates[mode]={}
 for name in ['control','sparse','zgx']:
  selected=[x for x in rows if x['mode']==mode and x['name']==name];aggregates[mode][name]={'task_cores_median':{k:statistics.median(x['task_cores'][k] for x in selected) for k in ['main','raster','other']},'process_cores_median':statistics.median(x['process_cores'] for x in selected),'ticks':[x['ticks'] for x in selected],'residual_seconds':[x['residual_seconds'] for x in selected]}
(r/'analysis.json').write_text(json.dumps({'rows':rows,'aggregates':aggregates,'note':'CPU attribution only; task names do not identify source stacks or blocked waits'},indent=2));(r/'loaded-modules.json').write_text(json.dumps(maps,indent=2));(r/'guard-after.json').write_text(json.dumps({'scripts_unchanged':True,'driver_files_unchanged':True}))
for mode,items in aggregates.items():
 for name,item in items.items():print(mode,name,{k:round(v,4) for k,v in item['task_cores_median'].items()},'total',round(item['process_cores_median'],4),'residual',item['residual_seconds'])
