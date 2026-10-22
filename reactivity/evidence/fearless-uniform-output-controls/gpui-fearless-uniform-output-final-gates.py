from pathlib import Path
import subprocess,os,json,hashlib
root='/root/gpui-fearless-abi';out=Path('/tmp/gpui-fearless-evidence');env=os.environ.copy();env['CARGO_BUILD_JOBS']='2'
commands=[]
for scalar in [False,True]:
 e=env.copy();e['CARGO_TARGET_DIR']='/tmp/gpui-fearless-abi-target'
 args=['cargo','clippy','--offline','--locked','--manifest-path',root+'/reactivity/Cargo.toml','-p','gpui_canvas','--all-targets','--all-features' if not scalar else '--no-default-features','--','-D','warnings']
 commands.append(('uniform-output-'+('scalar-' if scalar else '')+'clippy',args,e))
for target in ['aarch64-apple-darwin','x86_64-pc-windows-msvc']:
 for scalar in [False,True]:
  e=env.copy();e['CARGO_TARGET_DIR']='/tmp/gpui-fearless-pipeline-target';e['RUSTC_BOOTSTRAP']='1'
  args=['cargo','check','--offline','--locked','--manifest-path',root+'/reactivity/Cargo.toml','-p','gpui_canvas','--all-targets','--target',target,'-Zbuild-std=std,panic_abort']
  if scalar:args+=['--no-default-features']
  commands.append(('uniform-output-'+target+('-scalar' if scalar else '')+'-check',args,e))
for name,args,e in commands:
 with (out/(name+'.log')).open('w') as log:
  result=subprocess.run(args,env=e,stdout=log,stderr=subprocess.STDOUT)
 print(json.dumps({'gate':name,'exit':result.returncode}),flush=True)
 if result.returncode:raise SystemExit(result.returncode)
consumer='/tmp/gpui-fearless-uniform-output-consumer/Cargo.toml'
for policy in ['simd','scalar']:
 target=Path('/tmp/gpui-fearless-uniform-output-consumer-'+policy+'-target');target.mkdir(exist_ok=True)
 if not (target/'release').exists():subprocess.run(['cp','-a','--reflink=auto','/tmp/gpui-fearless-uniform-output-bench-target/release',str(target/'release')],check=True)
 e=env.copy();e['CARGO_TARGET_DIR']=str(target)
 args=['cargo','build','--offline','--locked','--manifest-path',consumer,'--release','--message-format=json']
 if policy=='scalar':args+=['--no-default-features']
 with (out/('uniform-output-consumer-'+policy+'-build.jsonl')).open('w') as log, (out/('uniform-output-consumer-'+policy+'-build.stderr')).open('w') as err:
  subprocess.run(args,env=e,stdout=log,stderr=err,check=True)
 exe=target/'release/canvas-pipeline-proof';copied=out/('uniform-output-'+policy+'-normal-consumer');copied.write_bytes(exe.read_bytes());copied.chmod(0o755)
 (out/('uniform-output-'+policy+'-normal-allocation.txt')).write_text(subprocess.check_output([str(exe)],text=True))
 for command,suffix in [(['size','-A'],'sections'),(['nm','-SC'],'symbols'),(['objdump','-Cd'],'assembly')]:
  with (out/('uniform-output-'+policy+'-normal-'+suffix+'.txt')).open('w') as log:subprocess.run(command+[str(exe)],stdout=log,check=True)
 print(json.dumps({'consumer':policy,'sha256':hashlib.sha256(exe.read_bytes()).hexdigest()}),flush=True)
