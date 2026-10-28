from pathlib import Path
import json,hashlib,subprocess
r=Path(__file__).parent;t=Path('/home/user/gpui-mask-miss-target/release/build/gpui_gpu');out=r/'generated-shaders';out.mkdir(exist_ok=False)
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
rows=[]
for p in sorted(t.glob('*/out/ui.wgsl')):
 data=p.read_bytes();h=sha(p);(out/(h+'-ui.wgsl')).write_bytes(data);rows.append(dict(path=str(p),sha256=h,bytes=len(data)))
assert rows and len({x['sha256'] for x in rows})==1
artifacts=json.loads((r/'gpu-initial/test-artifacts.json').read_text());chosen=[a for a in artifacts if a['cargo']['target']['name']=='render' and '/crates/gpu/' in a['cargo']['manifest_path']];assert len(chosen)==1;a=chosen[0];assert a['executed'] and not a['cargo']['fresh'] and sha(Path(a['preserved']))==a['sha256']
raw=(out/(rows[0]['sha256']+'-ui.wgsl')).read_bytes();offset=Path(a['preserved']).read_bytes().find(raw);assert offset>=0
fixture='reactivity/crates/gpu/tests/support/mask_lattice.rs';w=Path('/home/user/gpui-mask-miss-lab');base=Path('/home/user/gpui-mask-lattice-oracle-lab');assert (w/fixture).read_bytes()==(base/fixture).read_bytes()
for p in ['reactivity/crates/gpu/src/renderer/mask_lattice.rs']:
 assert (w/p).read_bytes()==(Path('/home/user/gpui-mask-lattice-lab')/p).read_bytes()
(out/'receipt.json').write_text(json.dumps(dict(generated=rows,executed_render=a,embedded=dict(sha256=rows[0]['sha256'],bytes=len(raw),offset=offset),fixture_sha256=sha(w/fixture),scope='Fresh corrected GPU package and executed GPU render ELF; native profile/offline modules not yet qualified.'),indent=2));print('generated WGSL',rows[0]['sha256'],'bytes',len(raw),'embedded',offset)
