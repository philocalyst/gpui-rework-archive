from pathlib import Path
import shutil,json,hashlib
r=Path(__file__).parent;d=Path('/home/user/gpui-mask-grid-audit-lab/reactivity/evidence/mask-grid-audit');assert not (d/'raw').exists()
shutil.copytree(r,d/'raw',ignore=shutil.ignore_patterns('__pycache__','dossier-verification*','seal*'));shutil.copy2(r/'verify_dossier.py',d/'verify.py');(d/'manifest.json').write_text(json.dumps({str(p.relative_to(d)):hashlib.file_digest(p.open('rb'),'sha256').hexdigest() for p in d.rglob('*') if p.is_file() and p.name!='manifest.json'},indent=2))
