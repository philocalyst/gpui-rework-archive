from pathlib import Path
import json,shutil,hashlib
r=Path(__file__).parent;d=Path('/home/user/gpui-mask-quad-native-lab/reactivity/evidence/mask-quad-native');assert not (d/'raw').exists()
shutil.copytree(r,d/'raw',ignore=shutil.ignore_patterns('__pycache__','dossier-verification*','seal*'));shutil.copy2(r/'verify_dossier.py',d/'verify_dossier.py')
manifest={str(p.relative_to(d)):hashlib.file_digest(p.open('rb'),'sha256').hexdigest() for p in d.rglob('*') if p.is_file() and p.name!='manifest.json'};(d/'manifest.json').write_text(json.dumps(manifest,indent=2));print('packaged',len(manifest),'files')
