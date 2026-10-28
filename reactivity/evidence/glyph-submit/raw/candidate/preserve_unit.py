from pathlib import Path
import json,re,hashlib,shutil,sys
r=Path(sys.argv[1]);assert json.loads((r/'guard-after.json').read_text())==[]
logs=[p for p in r.glob('*.log') if p.name in ['test.log','unit-build.log']]
paths=[]
for log in logs:paths += re.findall(r'(?:Running|Executable) unittests src/lib.rs \(([^)]*/gpui/[^)]+)\)',log.read_text())
assert len(set(paths))==1,paths
p=Path(paths[0]);h=hashlib.sha256(p.read_bytes()).hexdigest();d=Path('/home/user/gpui-preserved-test-binaries')/h
if not d.exists():shutil.copy2(p,d)
assert hashlib.sha256(d.read_bytes()).hexdigest()==h
(r/'unit-artifact.json').write_text(json.dumps(dict(path=str(p),sha256=h,preserved=str(d),bytes=p.stat().st_size),indent=2));print(h,p.stat().st_size)
