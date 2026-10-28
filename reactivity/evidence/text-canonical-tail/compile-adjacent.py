from pathlib import Path
import hashlib,json,subprocess,os
out=Path('/tmp/text-sol-evidence'); rust='/tmp/gpui-nightly-2026-10-23/bin/rustc'; probe=out/'adjacent-probe.rs'; results=[]
env=os.environ.copy(); env['PATH']='/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin:'+env['PATH']
for name,target,pin in [('candidate','/root/target-text-sol-nightly','a70abc536190566563399638362f8b314d52e3d4'),('control','/root/target-text-control-nightly','02b72aad0676c96d0d3cbf56e71278ff7ab503fb')]:
 base=Path(target)/'release'; canvas=next(base.rglob('libgpui_canvas*.rmeta')); counter=next(base.rglob('liballocation_counter*.rmeta')); binary=out/f'{name}-adjacent-probe'; paths=sorted({p.parent for p in base.rglob('*') if p.suffix in ('.rlib','.rmeta','.so')}); args=[rust,'--edition=2024','-C','opt-level=3','-C','symbol-mangling-version=v0','--crate-name','text_submission_probe',str(probe),'--extern',f'gpui_canvas={canvas}','--extern',f'gpui_canvas={canvas.with_suffix(".rlib")}','--extern',f'allocation_counter={counter}','--extern',f'allocation_counter={counter.with_suffix(".rlib")}','-o',str(binary)]
 for path in paths: args += ['-L',f'dependency={path}']
 result=subprocess.run(args,env=env,capture_output=True,text=True); (out/f'{name}-adjacent-compile.log').write_text(result.stdout+result.stderr); assert result.returncode==0, result.stderr
 binary.chmod(0o555); digest=lambda p:hashlib.sha256(p.read_bytes()).hexdigest(); before=digest(binary)
 with (out/f'{name}-adjacent-probe.log').open('w') as log: subprocess.run([str(binary)],stdout=log,check=True)
 assert before==digest(binary)
 results.append({'source':pin,'name':name,'probe_sha256':digest(probe),'binary_sha256':before,'canvas_rmeta_sha256':digest(canvas),'canvas_rlib_sha256':digest(canvas.with_suffix('.rlib')),'counter_rmeta_sha256':digest(counter),'counter_rlib_sha256':digest(counter.with_suffix('.rlib')),'compiler':subprocess.check_output([rust,'-Vv'],text=True),'compile_argv':args,'scope':'Allocation and capacity probes only; no elapsed-time inference.'})
(out/'adjacent-probe.json').write_text(json.dumps(results,indent=2)+'\n')
