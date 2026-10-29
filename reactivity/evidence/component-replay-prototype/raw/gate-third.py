from pathlib import Path
import os,json,subprocess,hashlib,shutil,time
w=Path('/home/user/gpui-component-replay-lab');r=Path(__file__).parent/'third';r.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def save(n,v):(r/n).write_text(json.dumps(v,indent=2))
def guard():return {n:sha(w/n) for n in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if n and (w/n).is_file()}
assert not subprocess.check_output(['git','status','--porcelain'],cwd=w).strip();assert shutil.disk_usage(w).free>=2*1024**3
before=guard();save('inputs-before.json',before);save('driver.json',dict(path=__file__,sha256=sha(Path(__file__))));(r/'source.txt').write_bytes(subprocess.check_output(['git','rev-parse','HEAD'],cwd=w));(r/'toolchain.txt').write_bytes(subprocess.check_output(['rustc','+nightly-2026-10-23','-vV']))
env=dict(os.environ,CARGO_TARGET_DIR='/home/user/gpui-component-replay-target',CARGO_BUILD_JOBS='4',CARGO_INCREMENTAL='0',CARGO_PROFILE_RELEASE_DEBUG='0');save('environment.json',{k:env.get(k) for k in ['CARGO_TARGET_DIR','CARGO_BUILD_JOBS','CARGO_INCREMENTAL','CARGO_PROFILE_RELEASE_DEBUG','RUSTFLAGS']})
def run(name,args):
 start=time.time()
 with (r/(name+'.out')).open('wb') as out,(r/(name+'.err')).open('wb') as err:p=subprocess.run(args,cwd=w/'reactivity',env=env,stdout=out,stderr=err)
 save(name+'.status.json',dict(args=args,exit=p.returncode,elapsed_seconds=time.time()-start));print(name,p.returncode,flush=True);assert p.returncode==0,name
prefix=['cargo','+nightly-2026-10-23','-Z','checksum-freshness','--config','build.fingerprint="content"'];common=['--locked','--offline','--release','-p','gpui','--no-default-features','--features','component-replay-lab']
try:
 run('build',prefix+['test']+common+['--test','component_replay','--no-run','--message-format=json'])
 rows=[json.loads(s) for s in (r/'build.out').read_text().splitlines()];found=[x for x in rows if x.get('reason')=='compiler-artifact' and x.get('executable') and x['target']['name']=='component_replay'];assert len(found)==1 and not found[0]['fresh']
 p=Path(found[0]['executable']);h=sha(p);canonical=Path('/home/user/gpui-preserved-test-binaries')/h
 if not canonical.exists():shutil.copy2(p,canonical)
 assert sha(canonical)==h;save('artifact.json',dict(preserved=str(canonical),sha256=h,bytes=p.stat().st_size,cargo_fresh=False))
 env['GPUI_COMPONENT_REPLAY_OUTPUT']=str(r/'trace')
 run('tests',[str(canonical),'--ignored','--nocapture','--test-threads=1'])
 run('feature_off',prefix+['check','--locked','--offline','--release','-p','gpui','--no-default-features','--lib'])
 run('clippy',prefix+['clippy']+common+['--test','component_replay','--','-D','warnings'])
finally:
 after=guard();save('guard.json',[n for n in before.keys()|after.keys() if before.get(n)!=after.get(n)]);save('disk.json',dict(free=shutil.disk_usage(w).free));assert before==after
save('overall.json',dict(decision='PASSED bounded non-shipping local replay CPU qualification; no timing or GPU claim'))
