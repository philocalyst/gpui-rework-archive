from pathlib import Path
import hashlib,json,subprocess,os,time,tempfile
out=Path('/tmp/gpui-wgsl-captures');meta=json.loads((out/'frozen-controls.json').read_text())
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def guard():
 for p,h in meta['sources'].items():assert sha(p)==h,p
 for entry in meta['frozen'].values():
  assert sha(entry['executable'])==entry['executable_sha256']
  assert sha(entry['library'])==entry['library_sha256']
def context():return {'time_ns':time.time_ns(),'processes':subprocess.check_output(['ps','-eo','pid,ppid,pcpu,etime,args'],text=True),'cpu_pressure':Path('/proc/pressure/cpu').read_text(),'io_pressure':Path('/proc/pressure/io').read_text()}
guard();before=context();affinity=os.sched_getaffinity(0);cpu=2 if 2 in affinity else min(affinity);rows=[];started=time.monotonic_ns()
with tempfile.TemporaryDirectory(prefix='gpui-wgsl-runtime-')as taskdir:
 env=os.environ.copy();env['XDG_RUNTIME_DIR']=taskdir
 for pair in range(7):
  order=['baseline','artifact']if pair%2==0 else ['artifact','baseline']
  for variant in order:
   guard();cmd=[meta['frozen'][variant]['executable']]
   p=subprocess.run(cmd,env=env,capture_output=True,text=True,timeout=30,preexec_fn=lambda:os.sched_setaffinity(0,{cpu}))
   (out/f'pair-{pair}-{variant}.stdout').write_text(p.stdout);(out/f'pair-{pair}-{variant}.stderr').write_text(p.stderr)
   assert p.returncode==0,(variant,p.stderr);assert 'llvmpipe'in p.stderr,p.stderr
   lines=p.stdout.splitlines();assert len(lines)==4
   rows.append({'pair':pair,'variant':variant,'command':cmd,'exit':p.returncode,'stdout':p.stdout,'stderr':p.stderr});guard()
after=context();result={'cpu':cpu,'original_affinity':sorted(affinity),'elapsed_ns':time.monotonic_ns()-started,'before':before,'after':after,'rows':rows,'limits':'Current-thread Rust allocation count. Renderer::new excludes instance/adapter/device initialization. Single pinned CPU, llvmpipe Vulkan. No end-to-end GPU startup, native UI, hardware, or cross-platform claim.'}
(out/'paired-renderer.json').write_text(json.dumps(result,indent=2)+'\n');print('END',len(rows),'processes',result['elapsed_ns']/1e9,'seconds',flush=True)
