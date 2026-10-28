from pathlib import Path
import json,hashlib
r=Path(__file__).parent;t=Path('/home/user/gpui-region-batch-target/release/build/gpui_gpu');out=r/'generated-shaders';assert out.is_dir();rows=[]
for p in t.glob('*/out/*'):
 if not p.is_file() or p.suffix not in ['.wgsl','.spv','.json','.rs']:continue
 data=p.read_bytes();h=hashlib.sha256(data).hexdigest();d=out/(h+'-'+p.name)
 if not d.exists():d.write_bytes(data)
 assert d.read_bytes()==data;rows.append({'path':str(p),'saved':str(d),'bytes':len(data),'sha256':h})
ui={q['sha256'] for q in rows if q['path'].endswith('/ui.wgsl')};assert ui=={'ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1'};region={q['sha256'] for q in rows if q['path'].endswith('/region.wgsl')};assert len(region)==1
binaries=[]
for stage in ['boundary-admission','offline-cached','full-native']:
 af='build-artifacts.json' if stage=='full-native' else 'test-artifacts.json'
 for a in json.loads((r/stage/af).read_text()):
  if stage!='full-native' and a['cargo']['target']['name'] not in ['gpui_gpu','render']:continue
  data=Path(a['preserved']).read_bytes();assert hashlib.sha256(data).hexdigest()==a['sha256'];embedded=[]
  for q in rows:
   if q['sha256'] in {x['sha256'] for x in embedded}:continue
   raw=Path(q['saved']).read_bytes();offset=data.find(raw)
   if offset>=0:embedded.append({'name':Path(q['path']).name,'sha256':q['sha256'],'offset':offset,'bytes':len(raw)})
  assert any(x['sha256'] in ui for x in embedded)
  if stage!='offline-cached' and a['cargo']['target']['name']!='gpui_gpu':assert any(x['sha256'] in region for x in embedded)
  binaries.append({'stage':stage,'artifact':a,'embedded':embedded})
(out/'receipt.json').write_text(json.dumps({'generated_files':rows,'binaries':binaries,'note':'Original typed/generated equality test passed. Both generated WGSL programs embedded in executed default GPU render integration test and native example. GPU unit binary dead strips unused regional caller. Offline feature uses separately validated original artifact/fallback and no region pipeline.'},indent=2));print('shader receipts',len(rows),len(binaries),'region',region)
