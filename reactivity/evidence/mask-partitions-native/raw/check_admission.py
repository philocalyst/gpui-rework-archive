from pathlib import Path
import json,hashlib,subprocess
r=Path(__file__).parent;rows=[]
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
for name in ['qualification','audit']:
 q=json.loads((r/(name+'-reference.json')).read_text());d=Path(q['dossier']);assert sha(d/'manifest.json')==q['manifest_sha256'] and sha(d/'verify.py')==q['verifier_sha256'];p=subprocess.run(['python3',str(d/'verify.py')],capture_output=True,text=True);rows.append(dict(kind=name,exit=p.returncode,stdout=p.stdout,stderr=p.stderr));assert p.returncode==0,p.stderr
(r/'admission-before-preflight.json').write_text(json.dumps(dict(passed=True,checks=rows),indent=2));print('Independent GPU and actual-native selection prerequisites pass; preflights admitted.')
