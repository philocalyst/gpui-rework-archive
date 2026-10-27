from pathlib import Path
import json,hashlib,re,subprocess,os,shutil
root=Path(__file__).resolve().parent;out=root/'list-allocation-ledgers';out.mkdir(exist_ok=False)
log=(root/'full-final/test.log').read_text();p=Path(re.search(r'Running tests/list_source.rs \(([^)]+)\)',log).group(1));h=hashlib.sha256(p.read_bytes()).hexdigest();saved=Path('/home/user/gpui-preserved-test-binaries')/h
if not saved.exists():shutil.copy2(p,saved)
p=saved
(out/'artifact.json').write_text(json.dumps({'path':str(p),'sha256':h,'bytes':p.stat().st_size},indent=2))
for mode in range(4):
 cmd=[str(p),'complete_list_source_allocation_ledger','--exact','--nocapture','--test-threads=1'];r=subprocess.run(cmd,env={**os.environ,'GPUI_LIST_SOURCE_LEDGER_MODE':str(mode)},capture_output=True,text=True)
 (out/f'mode-{mode}.out').write_text(r.stdout);(out/f'mode-{mode}.log').write_text(r.stderr);(out/f'mode-{mode}.status.json').write_text(json.dumps({'command':cmd,'mode':mode,'exit':r.returncode}));assert r.returncode==0 and '1 passed; 0 failed' in r.stdout
 print(r.stderr,flush=True)
assert hashlib.sha256(p.read_bytes()).hexdigest()==h
