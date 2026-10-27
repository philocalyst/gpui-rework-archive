from pathlib import Path
import json,re,hashlib,shutil,sys
r=Path(__file__).parent/sys.argv[1];assert json.loads((r/'guard-after.json').read_text())==[];rows=[]
for log in r.glob('*.log'):
 for path in re.findall(r'Running [^\n]* \(([^)]+)\)',log.read_text()):
  p=Path(path);h=hashlib.sha256(p.read_bytes()).hexdigest();d=Path('/home/user/gpui-preserved-test-binaries')/h
  if not d.exists():shutil.copy2(p,d)
  assert hashlib.sha256(d.read_bytes()).hexdigest()==h
  rows.append(dict(path=str(p),sha256=h,preserved=str(d),bytes=p.stat().st_size))
(r/'artifacts.json').write_text(json.dumps(rows,indent=2));print('preserved',len(rows))
