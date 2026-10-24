from pathlib import Path
import hashlib,json,os,subprocess
out=Path('/tmp/gpui-delivery-isolation-captures/contracts-v2');out.mkdir(exist_ok=True)
old=Path('/tmp/gpui-source-value-isolation-evidence/contracts-public-bound');spec=json.loads((old/'results.json').read_text())
metadata={};directories=set()
for line in Path('/tmp/gpui-delivery-isolation-captures/library-build.jsonl').read_text().splitlines():
 try:r=json.loads(line)
 except ValueError:continue
 if r.get('reason')!='compiler-artifact':continue
 for name in r.get('filenames',[]):
  if name.endswith(('.rmeta','.rlib','.so','.dylib','.dll')):directories.add(str(Path(name).parent))
  if name.endswith('.rmeta'):
   metadata[r['target']['name']]=name;directories.add(str(Path(name).parent))
assert all(n in metadata for n in ['gpui','gpui_canvas','arcstr','triomphe'])
command=[os.environ['RUSTC'],'--edition=2024','--test','--emit=metadata','--error-format=json','--out-dir',str(out),'-C','symbol-mangling-version=v0','--cfg','tokio_unstable']
for name in ['gpui','gpui_canvas','arcstr','triomphe']:command+=['--extern',name+'='+metadata[name]]
for path in sorted(directories):command+=['-L','dependency='+path]
def guard():return {name:hashlib.sha256(Path(path).read_bytes()).hexdigest() for name,path in metadata.items()}
assert not os.environ.get('RUSTC_BOOTSTRAP');before=guard();(out/'before.json').write_text(json.dumps(before,indent=2)+'\n')
cases=[]
for r in spec['results']:
 path=out/(r['case']+'.rs');path.write_bytes((old/path.name).read_bytes());cases.append((r['case'],r['expected'],path))
for name,typ in [('arcstr','arcstr::ArcStr'),('image','gpui::Image'),('std_text_geometry','std::sync::Arc<gpui_canvas::TextGeometry>'),('triomphe_text_geometry','triomphe::Arc<gpui_canvas::TextGeometry>')]:
 path=out/(name+'.rs');path.write_text('use gpui::{FieldId, Signal, Source};\nstruct Owner { value: Signal<'+typ+'> }\nconst SOURCE: Source<Owner, '+typ+'> = Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);\n#[test] fn declaration() { let _ = SOURCE; }\n');cases.append((name,None,path))
results=[]
for name,expected,path in cases:
 args=command+[str(path)];completed=subprocess.run(args,capture_output=True,text=True,timeout=45)
 (out/(name+'.stdout')).write_text(completed.stdout);(out/(name+'.stderr')).write_text(completed.stderr);codes=[]
 for line in completed.stderr.splitlines():
  try:r=json.loads(line)
  except ValueError:continue
  if r.get('code'):codes.append(r['code']['code'])
 ok=(completed.returncode==0) if expected is None else completed.returncode!=0 and expected in codes
 results.append({'case':name,'expected':expected,'exit':completed.returncode,'codes':codes,'pass':ok,'source_sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'command':args})
 print(name,'PASS' if ok else 'FAIL',completed.returncode,codes,flush=True)
after=guard();assert before==after
(out/'after.json').write_text(json.dumps(after,indent=2)+'\n');(out/'result.json').write_text(json.dumps({'libraries':metadata,'bootstrap':False,'results':results,'artifact_guards_match':True},indent=2)+'\n')
raise SystemExit(0 if all(r['pass'] for r in results) else 1)
