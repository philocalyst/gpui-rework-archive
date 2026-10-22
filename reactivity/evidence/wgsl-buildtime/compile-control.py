from pathlib import Path
import subprocess,hashlib,json,time,shutil
root=Path('/root/gpui-wgsl-buildtime');out=Path('/tmp/gpui-wgsl-captures');files=['reactivity/crates/gpu/Cargo.toml','reactivity/crates/gpu/src/renderer.rs'];build=root/'reactivity/crates/gpu/build.rs';candidate={f:(root/f).read_bytes()for f in files};candidate_build=build.read_bytes();original={f:subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),'show',f'8a157b3b47:{f}'])for f in files};results=[]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def source_guard():return {f:sha(root/f)for f in files}|{'build.rs':sha(build)if build.exists()else None,'shader.rs':sha(root/'reactivity/crates/gpu/src/shader.rs')}
def context():return {'time_ns':time.time_ns(),'cpu_pressure':Path('/proc/pressure/cpu').read_text(),'io_pressure':Path('/proc/pressure/io').read_text(),'processes':subprocess.check_output(['ps','-eo','pid,ppid,pcpu,etime,args'],text=True)}
(out/'compile-context-before.json').write_text(json.dumps(context(),indent=2)+'\n')
def run(variant):
 target='/tmp/gpui-wgsl-'+variant+'-target';env=__import__('os').environ.copy();env['CARGO_TARGET_DIR']=target;env['CARGO_BUILD_JOBS']='2'
 clean=['cargo','clean','--offline','--release','--manifest-path','/tmp/gpui-wgsl-control/Cargo.toml','-p','gpui_gpu']
 with(out/(variant+'-clean.log')).open('w')as log:subprocess.run(clean,cwd=root,env=env,stdout=log,stderr=subprocess.STDOUT,check=True)
 before=source_guard();cmd=['cargo','build','--offline','--release','--manifest-path','/tmp/gpui-wgsl-control/Cargo.toml','--bin','ordinary','--timings','--message-format=json'];start=time.monotonic_ns()
 with(out/(variant+'-rebuild.jsonl')).open('w')as stdout,(out/(variant+'-rebuild.stderr')).open('w')as stderr:p=subprocess.run(cmd,cwd=root,env=env,stdout=stdout,stderr=stderr)
 elapsed=time.monotonic_ns()-start;assert p.returncode==0;assert before==source_guard()
 shutil.copy(Path(target)/'cargo-timings/cargo-timing.html',out/(variant+'-compile-timing.html'))
 results.append({'variant':variant,'command':cmd,'clean_command':clean,'source_before_and_after':before,'exit':p.returncode,'wall_ns':elapsed,'ordinary_sha256':sha(Path(target)/'release/ordinary')})
try:
 for f,data in original.items():(root/f).write_bytes(data)
 build.unlink();run('baseline')
 for f,data in candidate.items():(root/f).write_bytes(data)
 build.write_bytes(candidate_build);run('artifact')
finally:
 for f,data in candidate.items():(root/f).write_bytes(data)
 build.write_bytes(candidate_build)
assert not subprocess.check_output(['git','-c',f'safe.directory={root}','-C',str(root),'status','--porcelain','--untracked-files=no'],text=True)
(out/'compile-context-after.json').write_text(json.dumps(context(),indent=2)+'\n')
(out/'compile-control-results.json').write_text(json.dumps(results,indent=2)+'\n');print(json.dumps(results,indent=2))
