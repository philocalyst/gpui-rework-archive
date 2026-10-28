from pathlib import Path
import json,hashlib,shutil,subprocess
r=Path(__file__).parent;w=Path('/home/user/gpui-native-profile-control-lab');d=w/'reactivity/evidence/native-profile';assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();assert not (d/'raw').exists()
shutil.copytree(r,d/'raw',ignore=shutil.ignore_patterns('__pycache__'))
shutil.copyfile(r/'report.txt',d/'README.md');shutil.copyfile(r/'verify_dossier.py',d/'verify.py')
manifest={str(p.relative_to(d)):hashlib.file_digest(p.open('rb'),'sha256').hexdigest() for p in d.rglob('*') if p.is_file() and p.name not in ['manifest.json','verification.txt']}
(d/'manifest.json').write_text(json.dumps(manifest,indent=2));print('packaged',len(manifest),'files')
