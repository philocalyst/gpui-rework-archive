from pathlib import Path
import shutil,hashlib,json
r=Path(__file__).parent;d=Path('/home/user/gpui-native-phase-lab/reactivity/evidence/native-phase');raw=d/'raw';assert not raw.exists()
shutil.copytree(r,raw,ignore=shutil.ignore_patterns('__pycache__','dossier-verification*','seal*'))
shutil.copy2(r/'verify_dossier.py',d/'verify_dossier.py')
manifest={str(p.relative_to(d)):hashlib.file_digest(p.open('rb'),'sha256').hexdigest() for p in d.rglob('*') if p.is_file() and p.name!='manifest.json'}
(d/'manifest.json').write_text(json.dumps(manifest,indent=2));print('packaged',len(manifest),'files')
