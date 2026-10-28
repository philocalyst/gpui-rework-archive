from pathlib import Path
import json,hashlib,shutil,subprocess
r=Path(__file__).parent;w=Path('/home/user/gpui-native-workspace-lab');d=w/'reactivity/evidence/native-workspace'
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip()
assert subprocess.check_output(['git','rev-parse','HEAD'],cwd=w,text=True).strip()=='03ca419868b0d538e6847e59b60424a31aa32dfa'
assert not (d/'raw').exists()
(d/'PROTOCOL.md').write_bytes((d/'README.md').read_bytes())
shutil.copytree(r,d/'raw',ignore=shutil.ignore_patterns('__pycache__'))
shutil.copyfile(r/'report.txt',d/'README.md');shutil.copyfile(r/'verify_dossier.py',d/'verify.py')
manifest={str(p.relative_to(d)):hashlib.file_digest(p.open('rb'),'sha256').hexdigest() for p in d.rglob('*') if p.is_file() and p!=d/'manifest.json'}
(d/'manifest.json').write_text(json.dumps(manifest,indent=2));print('packaged',len(manifest),'files')
