from pathlib import Path
import subprocess,shutil
repo=Path('/home/user/gpui-rework-archive');r=Path(__file__).parent
files=['reactivity/crates/gpui/src/runtime.rs','reactivity/crates/gpui/src/runtime/paint.rs','reactivity/crates/gpui/src/native.rs','reactivity/crates/gpui/src/native/scroll_bench.rs','reactivity/crates/gpui/src/native/upgrade.rs']
patch=subprocess.check_output(['git','diff','c62df431b53b2258ecb23d307859fd442884b759','1e46391250d84f7b20a6e56643b28296c70b8b0c','--',*files],cwd=repo);(r/'common-image-authority.patch').write_bytes(patch)
for variant in ['predecessor','bounds']:
 w=Path('/home/user/gpui-glyph-damage-'+variant+'-lab');t=Path('/home/user/gpui-glyph-damage-'+variant+'-target');out=Path('/home/user/gpui-glyph-damage-'+variant+'-evidence');assert not any(p.exists() for p in [w,t,out])
 subprocess.run(['git','worktree','add','--no-checkout','-b','local/glyph-damage-'+variant,str(w),'957719565444c9900c6e6c20916a6fb88c933395'],cwd=repo,check=True)
 subprocess.run(['git','sparse-checkout','set','reactivity/crates','reactivity/vendor','reactivity/evidence/glyph-damage-'+variant,'.cargo'],cwd=w,check=True);subprocess.run(['git','checkout'],cwd=w,check=True);out.mkdir()
 subprocess.run(['git','apply','--check'],input=patch,cwd=w,check=True);subprocess.run(['git','apply'],input=patch,cwd=w,check=True)
 g=w/'reactivity/crates/gpui/src';shutil.copy2('/home/user/gpui-glyph-damage-control-lab/reactivity/crates/gpui/src/native/text_repair_tests.rs',g/'native/text_repair_tests.rs')
 p=g/'native/paint_tests.rs';p.write_text(p.read_text().replace('fn read(gpu:','pub(super) fn read(gpu:',1))
 p=g/'native.rs';s=p.read_text();assert 'mod text_repair_tests;' not in s;s=s.replace('mod paint_tests;','''mod paint_tests;
#[cfg(all(test,any(feature = "x11", feature = "x11-minimal"),target_os = "linux"))]
mod text_repair_tests;''',1).replace('        super::paint_tests::run(gpu);','        super::paint_tests::run(gpu);\n        super::text_repair_tests::run(gpu);',1);p.write_text(s)
 changed=[g/'runtime.rs',g/'runtime/paint.rs',g/'native.rs',g/'native/scroll_bench.rs',g/'native/upgrade.rs',g/'native/paint_tests.rs',g/'native/text_repair_tests.rs']
 if variant=='bounds':
  for name in ['reactivity/crates/canvas/src/canvas/text_patch.rs','reactivity/crates/canvas/tests/text_patch_damage.rs']:
   p=w/name;p.write_bytes(subprocess.check_output(['git','show','5c7bf163d78461ad096448cecfeadfa2ff9d4576:'+name],cwd=repo));changed.append(p)
 d=w/('reactivity/evidence/glyph-damage-'+variant);d.mkdir(parents=True)
 (d/'PROTOCOL.md').write_text(f'''# {variant} mechanism control

Start from failed local-publication957719565444c9900c6e6c20916a6fb88c933395,
including qualified image placement. Apply the exact image-authority prerequisite
from the independently failing/corrected original control c62df431b53b→1e46391250.
Add its identical ordinary-window pixel witness. {'Bounds additionally uses only Canvas exact changed-glyph support from5c7bf163d784; no raw diagnostic vector or sparse GPU repair.' if variant=='bounds' else 'Preserve the original all-glyph bounding repair and ordinary GPU path.'}
The registered four-way protocol and process order are in candidate4a1e6f24c748.
Install the identical test-only small-text/cost/storage overlay. No performance
verdict or old-failure revision follows from this control. Unique target, frozen
inputs, preserved artifacts, native full-pixel witness and fixed qualification
matrix are required before timing. All changes remain local.
''')
 subprocess.run(['rustfmt','+nightly-2026-10-23','--edition','2024','--config','skip_children=true',*[str(p) for p in changed]],check=True)
 subprocess.run(['git','add','reactivity'],cwd=w,check=True);subprocess.run(['git','commit','-qm','experiment: compose corrected '+variant+' mechanism control'],cwd=w,check=True)
 print(variant,'production',subprocess.check_output(['git','rev-parse','HEAD'],cwd=w).decode().strip(),flush=True)
 subprocess.run(['python3',str(r/'apply_cost_overlay.py'),str(w)],check=True)
