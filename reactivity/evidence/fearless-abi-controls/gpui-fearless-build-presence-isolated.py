from pathlib import Path
import subprocess,os,json,hashlib,shutil
base=Path('/tmp/gpui-fearless-evidence');base.mkdir(exist_ok=True)
variants=[('presence','/tmp/gpui-fearless-presence-source','e19f0a1049',True),('presence-scalar','/tmp/gpui-fearless-presence-source','e19f0a1049',False)]
records=json.loads((base/"isolated-build-ledger.json").read_text())
for name,source,commit,simd in variants:
 target=Path('/tmp/gpui-fearless-'+name+'-bench-target');target.mkdir(exist_ok=True)
 if not (target/'release').exists():subprocess.run(['cp','-a','--reflink=auto','/tmp/gpui-fearless-pipeline-target/release',str(target/'release')],check=True)
 env=os.environ.copy();env['CARGO_TARGET_DIR']=str(target);env['CARGO_BUILD_JOBS']='2'
 manifest=source+'/reactivity/Cargo.toml'
 with (base/(name+'-isolated-clean.log')).open('w') as log:subprocess.run(['cargo','clean','--manifest-path',manifest,'-p','gpui_canvas','--release'],env=env,stdout=log,stderr=subprocess.STDOUT,check=True)
 args=['cargo','build','--offline','--locked','--manifest-path',manifest,'-p','gpui_canvas','--release','--example','cpu','--example','image_axis','--message-format=json']
 if not simd:args+=['--no-default-features']
 log=base/(name+'-isolated-build.jsonl');err=base/(name+'-isolated-build.stderr')
 with log.open('w') as stream,err.open('w') as errors:subprocess.run(args,env=env,stdout=stream,stderr=errors,check=True)
 messages=[json.loads(l) for l in log.read_text().splitlines()]
 artifacts=[m for m in messages if m.get('reason')=='compiler-artifact' and m.get('target',{}).get('name') in ['gpui_canvas','cpu','image_axis']]
 assert len(artifacts)==3,(name,[(m['target']['name'],m['fresh']) for m in artifacts])
 assert all(not a['fresh'] for a in artifacts),(name,artifacts)
 files={};
 for a in artifacts:
  for filename in a['filenames']:
   if filename.endswith('.rlib') or a.get('executable')==filename:
    files[filename]=hashlib.sha256(Path(filename).read_bytes()).hexdigest()
 source_files={}
 for filename in ['src/canvas.rs','src/canvas/samples.rs','src/canvas/image_axis.rs','examples/cpu.rs','examples/image_axis.rs','Cargo.toml']:
  p=Path(source)/'reactivity/crates/canvas'/filename
  source_files[str(p)]=hashlib.sha256(p.read_bytes()).hexdigest()
 expected=subprocess.check_output(['git','-c','safe.directory='+source,'-C',source,'rev-parse',commit],text=True).strip()
 assert subprocess.check_output(['git','-c','safe.directory='+source,'-C',source,'rev-parse','HEAD'],text=True).strip()==expected
 row=dict(name=name,source=source,source_commit=expected,simd=simd,target=str(target),command=args,artifact_files=files,source_files=source_files,build_json_sha256=hashlib.sha256(log.read_bytes()).hexdigest())
 records.append(row);(base/'isolated-build-ledger.json').write_text(json.dumps(records,indent=2)+'\n')
 print(json.dumps(dict(built=name,source_commit=expected,files=files)),flush=True)
