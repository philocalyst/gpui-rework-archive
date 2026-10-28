from pathlib import Path
import json,hashlib,shutil
r=Path(__file__).parent;p=r/'generated-shaders/receipt.json';receipt=json.loads(p.read_text());shutil.copyfile(p,r/'generated-shaders/receipt-initial.json')
a=json.loads((r/'full-native-initial/unit-artifact.json').read_text());data=Path(a['preserved']).read_bytes();assert hashlib.sha256(data).hexdigest()==a['sha256'];embedded=[]
for item in receipt['generated_files']:
 if item['sha256'] in {x['sha256'] for x in embedded}:continue
 b=Path(item['saved']).read_bytes();offset=data.find(b)
 if offset>=0:embedded.append(dict(name=Path(item['path']).name,sha256=item['sha256'],offset=offset,bytes=len(b)))
assert any(x['name']=='ui.wgsl' for x in embedded)
receipt['binaries'].append(dict(gate='full-native-unit-actual-x11',artifact=a,embedded=embedded))
receipt['execution_scope']='GPU and offline render test ELFs and full-native unit ELF were executed in qualification; the standalone default-profile native example ELF is build-qualified here, not yet executed. The initial script printed an overbroad executed-binaries label; per-artifact executed fields were preserved.'
p.write_text(json.dumps(receipt,indent=2));print('Four embedded-shader identities; three executed test ELFs and one build-qualified native example.')
