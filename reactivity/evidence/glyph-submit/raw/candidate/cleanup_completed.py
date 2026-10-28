from pathlib import Path
import json,hashlib,subprocess,shutil
r=Path(__file__).parent
roots=[Path('/home/user/gpui-glyph-damage'+s+'-target') for s in ['', '-control','-bounds','-predecessor','-negative']]
entries={}
def visit(o):
 if isinstance(o,dict):
  p=o.get('path');q=o.get('preserved');h=o.get('sha256')
  if p and q and h and any(Path(p).is_relative_to(t) for t in roots) and Path(p).suffix not in ['.rlib','.rmeta']:entries.setdefault(p,set()).add((q,h))
  for v in o.values():visit(v)
 elif isinstance(o,list):
  for v in o:visit(v)
for s in ['', '-control','-bounds','-predecessor','-negative']:
 for p in Path('/home/user/gpui-glyph-damage'+s+'-evidence').rglob('*artifact*.json'):visit(json.loads(p.read_text()))
ps=subprocess.check_output(['ps','-eo','comm=,args='],text=True)
assert not any(line.strip().split()[0] in ['cargo','rustc'] and any(str(t) in line for t in roots) for line in ps.splitlines())
record=dict(reason='Only exact verified duplicates in completed targets. Prior inline attempt stopped at an assertion on historical receipt identity; historical receipts can refer to earlier versions of the same target path. This attempt hashes the current target and selects its matching receipt before any deletion. Any prefix removed by the earlier attempt had already passed exact preserved-ELF verification. Global preserved files are never deleted.',free_before=shutil.disk_usage('/home/user').free,files=[],skipped=[]);checked=set()
for p,versions in entries.items():
 p=Path(p)
 if not p.exists():continue
 h=hashlib.sha256(p.read_bytes()).hexdigest();matches=[q for q,sha in versions if sha==h and Path(q).exists()]
 if not matches:record['skipped'].append(str(p));continue
 q=Path(matches[0])
 if h not in checked:assert hashlib.sha256(q.read_bytes()).hexdigest()==h;checked.add(h)
 record['files'].append(dict(path=str(p),preserved=str(q),sha256=h,bytes=p.stat().st_size))
(r/'completed-comparator-elf-cleanup-plan.json').write_text(json.dumps(record,indent=2))
for f in record['files']:Path(f['path']).unlink()
record['free_after']=shutil.disk_usage('/home/user').free
(r/'completed-comparator-elf-cleanup.json').write_text(json.dumps(record,indent=2));print('removed',len(record['files']),'duplicates; free',record['free_after'])
