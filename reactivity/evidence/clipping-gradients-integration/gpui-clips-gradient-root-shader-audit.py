from pathlib import Path
import hashlib,json,mmap,subprocess
root=Path('/tmp/gpui-clips-gradient-root')
build=Path('/tmp/gpui-clips-gradient-root-final-build')
artifacts=Path('/tmp/gpui-clips-gradient-root-final-artifacts')
out=Path('/tmp/gpui-clips-gradient-root-shader-audit')
out.mkdir(exist_ok=False)
rows=[json.loads(line) for line in (build/'stdout.log').read_text().splitlines()]
outputs=[row for row in rows if row.get('reason')=='build-script-executed' and '#gpui_gpu@' in row['package_id']]
assert len(outputs)==1
folder=Path(outputs[0]['out_dir'])
manifest=json.loads((folder/'ui-artifacts.json').read_text())
sha=lambda value:hashlib.sha256(value).hexdigest()
assert sha((root/'reactivity/crates/gpu/src/shader.rs').read_bytes())==manifest['typed_rust_sha256']
wgsl=(folder/'ui.wgsl').read_bytes()
assert sha(wgsl)==manifest['wgsl_sha256']
need=[('ui.wgsl',wgsl)]
checks=[]
for row in manifest['artifacts']:
 name=f'ui-{row["variant"]}-{row["entry"]}.spv'
 data=(folder/name).read_bytes()
 assert len(data)==row['bytes'] and sha(data)==row['sha256']
 result=subprocess.run(['/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val','--target-env','vulkan1.0',str(folder/name)],capture_output=True,text=True)
 assert result.returncode==0,result.stderr
 need.append((name,data));checks.append({'name':name,'bytes':len(data),'sha256':sha(data),'validator_exit':0})
 (out/name).write_bytes(data)
elfs=[]
for path in artifacts.glob('*/binary.json'):
 identity=json.loads(path.read_text())
 if identity['target']['name'] not in ['gpui','gpui_gpu'] or identity['target']['kind']!=['lib']:continue
 binary=path.parent/'test'
 with binary.open('rb') as stream,mmap.mmap(stream.fileno(),0,access=mmap.ACCESS_READ) as mapped:
  assert sha(mapped)==identity['sha256']
  positions=[{'name':name,'offset':mapped.find(data),'bytes':len(data),'sha256':sha(data)} for name,data in need]
  assert all(p['offset']>=0 for p in positions),positions
 elfs.append({'target':identity['target']['name'],'path':str(binary),'bytes':identity['bytes'],'sha256':identity['sha256'],'embedded':positions})
assert {e['target'] for e in elfs}=={'gpui','gpui_gpu'}
(out/'ui.wgsl').write_bytes(wgsl)
(out/'ui-artifacts.json').write_text(json.dumps(manifest,indent=2)+'\n')
report={'source':'d3e6885c6bab6a07fafcd3f4faae7cbb3023e0c7','build_output':outputs[0],'wgsl_bytes':len(wgsl),'wgsl_sha256':sha(wgsl),'typed_rust_sha256':manifest['typed_rust_sha256'],'spirv':checks,'elfs':elfs,'scope':'Actual frozen functional ELF byte embedding and SPIR-V validation; GPU storage-layout test separately compares generated text to fresh typed Rust generation. No performance inference.'}
(out/'result.json').write_text(json.dumps(report,indent=2)+'\n')
print(json.dumps({key:value for key,value in report.items() if key not in ['build_output','elfs','spirv']}))
