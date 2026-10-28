from pathlib import Path
import json, hashlib, subprocess, shutil
r=Path(__file__).parent
w=Path('/home/user/gpui-scene-support-lab')
d=w/'reactivity/evidence/scene-support'
assert not (d/'raw').exists()
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()=='92bfac4445c8b518b945c384fe6ff83ed772ae4f'
assert (r/'matrix-analysis/verdict.json').is_file()
report=(r/'dossier-report.txt').read_text()
(d/'preregistration.md').write_text((d/'README.md').read_text())
raw=d/'raw';raw.mkdir()
shutil.copytree(r,raw/'candidate',ignore=shutil.ignore_patterns('__pycache__'))
for n in ['control','bounds','predecessor']:
 shutil.copytree(Path('/home/user/gpui-region-batch-evidence')/('cost-build-'+n),raw/'reused-controls'/n)
for label,source in [('control','/home/user/gpui-glyph-damage-control-evidence'),('bounds','/home/user/gpui-glyph-damage-bounds-evidence'),('predecessor','/home/user/gpui-glyph-submit-evidence')]:
 for part in ['full-native','native-checks']:
  shutil.copytree(Path(source)/part,raw/'inherited'/label/part)
for part,old in [('full-native','full-native-precise'),('native-checks','native-checks-precise')]:
 shutil.copytree(Path('/home/user/gpui-scroll-sparse-evidence')/old,raw/'inherited/scroll_precise'/part)
for name,before,after in [
 ('production','5a07d7c28ffe500a5d24e25fdf1f31ce4857811f','92bfac4445c8b518b945c384fe6ff83ed772ae4f'),
 ('omission','92bfac4445c8b518b945c384fe6ff83ed772ae4f','8cb6281f6cec7d93bee1792bd0bd85a8603ef935'),
 ('pending','92bfac4445c8b518b945c384fe6ff83ed772ae4f','ce224ce7e2b94a331ce98caebf32d90794921ef3')]:
 (raw/(name+'.patch')).write_bytes(subprocess.check_output(['git','diff',before,after,'--','reactivity/crates'],cwd=w))
for name in ['COST.json','PROCESS_ORDER.json']:
 assert (d/name).read_bytes()==subprocess.check_output(['git','show','b4188e7cedc008f6d8b48f03da6173af54c7458d:reactivity/evidence/scene-support/'+name],cwd=w)
shutil.copy2(r/'verify_dossier.py',d/'verify.py')
(d/'README.md').write_text(report)
manifest={str(p.relative_to(d)):hashlib.file_digest(p.open('rb'),'sha256').hexdigest() for p in d.rglob('*') if p.is_file() and p!=d/'manifest.json'}
(d/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print('packaged',len(manifest),'files')
