from pathlib import Path
import subprocess,os,json,hashlib
base=Path('/tmp/gpui-gamut-capture');base.mkdir(exist_ok=True)
specs=[('final-native','consumer','consumer',['--features','primitive']),('final-fallback','consumer','consumer-fallback',['--no-default-features','--features','primitive']),('final-floor','floor-consumer','floor',[]),('original-common','original-consumer','original',[]),('bare-common','bare-consumer','bare',['--features','primitive']),('expansion-common','expansion-consumer','expansion',['--features','primitive'])]
for label,project,target,flags in specs:
 p=Path('/tmp/gpui-gamut-'+project);target=Path('/tmp/gpui-gamut-'+target+'-target')
 # Native project is named consumer, the other projects carry consumer suffix.
 if not (p/'Cargo.toml').exists():raise RuntimeError(str(p))
 manifest=(p/'Cargo.toml').read_text();root=Path(manifest.split('path = "',1)[1].split('"',1)[0]).parents[1]
 def guard():
  paths=[p/'Cargo.toml',p/'Cargo.lock',p/'src/main.rs',root/'Cargo.toml',root/'Cargo.lock',root/'crates/canvas/Cargo.toml']+list((root/'crates/canvas/src').rglob('*.rs'))
  return {str(f):hashlib.sha256(f.read_bytes()).hexdigest() for f in paths}
 before=guard();(base/(label+'-source-before.json')).write_text(json.dumps(before,indent=2)+'\n')
 env=dict(os.environ,CARGO_BUILD_JOBS='2',CARGO_TARGET_DIR=str(target))
 cmd=['cargo','build','--release','--offline','--locked','--manifest-path',str(p/'Cargo.toml'),'--message-format=json']+flags
 with (base/(label+'-build.jsonl')).open('w') as out,(base/(label+'-build.stderr')).open('w') as err:subprocess.run(cmd,env=env,stdout=out,stderr=err,check=True)
 assert before==guard(),'source changed while building '+label
 artifact=target/'release/gamut_consumer';frozen=Path('/tmp/gpui-gamut-'+label+'-frozen');frozen.write_bytes(artifact.read_bytes());frozen.chmod(0o755)
 bh=hashlib.sha256(frozen.read_bytes()).hexdigest();libraries=[]
 for line in (base/(label+'-build.jsonl')).read_text().splitlines():
  r=json.loads(line)
  if r.get('reason')=='compiler-artifact' and r['target']['name']=='gpui_canvas':
   libraries=[dict(path=f,sha256=hashlib.sha256(Path(f).read_bytes()).hexdigest(),bytes=Path(f).stat().st_size) for f in r['filenames'] if f.endswith('.rlib')]
 assert libraries,'no library artifact for '+label
 for count in [0,1000]:
  for round in range(3):
   assert before==guard();assert hashlib.sha256(frozen.read_bytes()).hexdigest()==bh
   (base/f'{label}-{count}-{round}.csv').write_bytes(subprocess.check_output([str(frozen),str(count)]))
   assert before==guard();assert hashlib.sha256(frozen.read_bytes()).hexdigest()==bh
 (base/(label+'-source-after.json')).write_text(json.dumps(guard(),indent=2)+'\n')
 (base/(label+'-pins.json')).write_text(json.dumps(dict(command=cmd,env={k:env[k] for k in ['CARGO_BUILD_JOBS','CARGO_TARGET_DIR']},executable=str(frozen),sha256=bh,libraries=libraries,timing_qualified=False),indent=2)+'\n')
 tree=['cargo','tree','--offline','--locked','--manifest-path',str(p/'Cargo.toml'),'-e','features','-i','gpui_canvas']+flags
 (base/(label+'-feature-tree.txt')).write_bytes(subprocess.check_output(tree,env=env))
 for kind,cmd in [('asm',['objdump','-d','-C']),('symbols',['nm','-S','--size-sort','-C']),('sections',['size','-A'])]:
  Path('/tmp/gpui-gamut-'+label+'.'+kind).write_bytes(subprocess.check_output(cmd+[str(frozen)]))
 print(label,bh,flush=True)
