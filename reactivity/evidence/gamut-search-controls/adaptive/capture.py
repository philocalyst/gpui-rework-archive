from pathlib import Path
import os,json,subprocess,hashlib
out=Path('/tmp/gpui-gamut-adaptive-capture');out.mkdir(exist_ok=True)
specs=[('adaptive-parity','/tmp/gpui-gamut-adaptive-parity-new','/tmp/gpui-gamut-adaptive-consumer-target',[]),('adaptive-fallback-parity','/tmp/gpui-gamut-adaptive-parity-new','/tmp/gpui-gamut-adaptive-consumer-fallback-target',['--no-default-features']),('adaptive-common','/tmp/gpui-gamut-adaptive-common-consumer','/tmp/gpui-gamut-adaptive-consumer-target',['--features','primitive']),('adaptive-fallback-common','/tmp/gpui-gamut-adaptive-common-consumer','/tmp/gpui-gamut-adaptive-consumer-fallback-target',['--no-default-features','--features','primitive'])]
for label,project,target,flags in specs:
 p=Path(project);manifest=(p/'Cargo.toml').read_text();root=Path(manifest.split('path = "',1)[1].split('"',1)[0]).parents[1]
 def guard():
  files=[p/'Cargo.toml',p/'Cargo.lock',p/'src/main.rs',root/'Cargo.lock',root/'Cargo.toml',root/'crates/canvas/Cargo.toml',Path('/root/gpui-designer-gamut/reactivity/crates/canvas/tests/fixtures/gamut_limits.csv')]+list((root/'crates/canvas/src').rglob('*.rs'))
  return {str(f):hashlib.sha256(f.read_bytes()).hexdigest() for f in files}
 before=guard();(out/(label+'-source-before.json')).write_text(json.dumps(before,indent=2)+'\n');env=dict(os.environ,CARGO_TARGET_DIR=target,CARGO_BUILD_JOBS='2');cmd=['cargo','build','--release','--offline','--locked','--manifest-path',str(p/'Cargo.toml'),'--message-format=json']+flags
 with (out/(label+'-build.jsonl')).open('w') as stdout,(out/(label+'-build.stderr')).open('w') as stderr:subprocess.run(cmd,env=env,stdout=stdout,stderr=stderr,check=True)
 assert before==guard();binary=Path('/tmp/gpui-gamut-adaptive-'+label+'-frozen');binary.write_bytes((Path(target)/'release/gamut_consumer').read_bytes());binary.chmod(0o755);bh=hashlib.sha256(binary.read_bytes()).hexdigest()
 (out/(label+'.csv')).write_bytes(subprocess.check_output([str(binary)]))
 assert before==guard();assert hashlib.sha256(binary.read_bytes()).hexdigest()==bh
 libraries=[]
 for line in (out/(label+'-build.jsonl')).read_text().splitlines():
  row=json.loads(line)
  if row.get('reason')=='compiler-artifact' and row['target']['name']=='gpui_canvas':libraries=[dict(path=f,sha256=hashlib.sha256(Path(f).read_bytes()).hexdigest(),bytes=Path(f).stat().st_size) for f in row['filenames'] if f.endswith('.rlib')]
 (out/(label+'-pins.json')).write_text(json.dumps(dict(command=cmd,executable=str(binary),sha256=bh,libraries=libraries,timing_qualified=False),indent=2)+'\n');(out/(label+'-source-after.json')).write_text(json.dumps(guard(),indent=2)+'\n')
 for suffix,tool in [('asm',['objdump','-d','-C']),('symbols',['nm','-S','--size-sort','-C']),('sections',['size','-A'])]:
  with (out/(label+'.'+suffix)).open('wb') as stdout:subprocess.run(tool+[str(binary)],stdout=stdout,check=True)
 print(label,bh,flush=True)
