from pathlib import Path
import json,hashlib,subprocess,shutil,os
root=Path('/root/gpui-cephal-hidden-marker');out=Path('/tmp/gpui-cephal-hidden-control');h=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
shipping=['reactivity/crates/core/src/layout.rs','reactivity/vendor/cephal/src/tree/traits.rs','reactivity/vendor/cephal/src/compute/mod.rs','reactivity/vendor/cephal/src/tree/cache/mod.rs','reactivity/vendor/cephal/GPUI-PROVENANCE.json','reactivity/Cargo.lock']
for p in shipping:assert h(root/p)==hashlib.sha256(subprocess.check_output(['git','show','eb610aaea2:'+p],cwd=root)).hexdigest(),p
sources={str(root/p):h(root/p) for p in shipping}
for p in [root/'reactivity/crates/core/tests/layout/hidden.rs',Path('/tmp/gpui-cephal-hidden-driver/src/main.rs'),Path('/tmp/gpui-cephal-hidden-driver/Cargo.toml'),Path('/tmp/gpui-cephal-hidden-driver/Cargo.lock')]:sources[str(p)]=h(p)
artifacts=[]
for line in (out/'build.jsonl').read_text().splitlines():
 try:a=json.loads(line)
 except ValueError:continue
 if a.get('reason')!='compiler-artifact':continue
 if a['target']['name'] in ['cephal','gpui_reactivity_core','gpui-cephal-hidden-driver']:
  artifacts.append(a)
  for f in a['filenames']:
   p=Path(f)
   if p.suffix=='.rlib':shutil.copy2(p,out/p.name)
 if a.get('executable'):shutil.copy2(a['executable'],out/'driver')
exe=h(out/'driver')
for rep in range(3):
 for mode in ['empty','ordinary','hidden','warm-hide']:
  for p,v in sources.items():assert h(p)==v
  assert h(out/'driver')==exe
  with (out/f'{rep}-{mode}.csv').open('wb') as stdout,(out/f'{rep}-{mode}.stderr').open('wb') as stderr:subprocess.run([str(out/'driver'),mode],check=True,stdout=stdout,stderr=stderr)
  for p,v in sources.items():assert h(p)==v
  assert h(out/'driver')==exe
(out/'pins.json').write_text(json.dumps({'base_commit':'eb610aaea2322789ebd2f06761fb5342e6318ff9','scope':'shipping source equals base; uncommitted test-only fixture and driver source pinned separately','sources':sources,'artifacts':artifacts,'binary_hashes':{str(p):h(p) for p in out.iterdir() if p.name=='driver' or p.suffix=='.rlib'},'guards_passed':True},indent=2)+'\n')
print('baseline12 fresh processes and every cold oracle passed')
