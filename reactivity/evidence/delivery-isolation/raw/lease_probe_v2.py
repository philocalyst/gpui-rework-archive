from pathlib import Path
import hashlib,json,os,subprocess
out=Path('/tmp/gpui-delivery-isolation-captures/initial-lease-probe-v2');out.mkdir(exist_ok=True)
r=json.loads(Path('/tmp/gpui-source-value-isolation-evidence/contracts-public-bound/results.json').read_text())
command=r['results'][0]['command'][:-1]
command[command.index('--out-dir')+1]=str(out)
arcstr=next(Path('/tmp/gpui-source-value-isolation-root-target/debug/build/arcstr').glob('*/out/*.rmeta'))
canvas=next(Path(next(arg.removeprefix('dependency=') for arg in command if '/gpui_canvas/' in arg)).glob('*.rmeta'))
command+=['--extern','arcstr='+str(arcstr),'--extern','gpui_canvas='+str(canvas)]
libs=[Path(v) for v in r['libraries'].values()]+[arcstr,canvas]
def guard():return {str(p):hashlib.sha256(p.read_bytes()).hexdigest() for p in libs}
before=guard();(out/'before.json').write_text(json.dumps(before,indent=2)+'\n');assert not os.environ.get('RUSTC_BOOTSTRAP')
result={'source_pin':r['source_pin'],'successor_checkout':'f1234d8451','compiler':subprocess.check_output([command[0],'-Vv'],text=True),'bootstrap':False,'cases':[]}
for name,typ in [('arcstr','arcstr::ArcStr'),('image','gpui::Image'),('std_text_geometry','std::sync::Arc<gpui_canvas::TextGeometry>'),('triomphe_text_geometry','triomphe::Arc<gpui_canvas::TextGeometry>')]:
 source='use gpui::{FieldId, Signal, Source};\nstruct Owner { value: Signal<'+typ+'> }\nconst SOURCE: Source<Owner, '+typ+'> = Source::new(FieldId::new(1), "value", |m| &m.value, |m| &mut m.value);\n#[test] fn declaration() { let _ = SOURCE; }\n'
 path=out/(name+'.rs');path.write_text(source);args=command+[str(path)]
 completed=subprocess.run(args,capture_output=True,text=True,timeout=45)
 (out/(name+'.stdout')).write_text(completed.stdout);(out/(name+'.stderr')).write_text(completed.stderr)
 codes=[]
 for line in completed.stderr.splitlines():
  try:j=json.loads(line)
  except ValueError:continue
  if j.get('code'):codes.append(j['code']['code'])
 result['cases'].append({'name':name,'type':typ,'expected':'positive','exit':completed.returncode,'codes':codes,'command':args})
after=guard();assert before==after;result['artifact_guards_match']=True
(out/'after.json').write_text(json.dumps(after,indent=2)+'\n');(out/'result.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps([{k:v for k,v in case.items() if k!='command'} for case in result['cases']]),flush=True)
