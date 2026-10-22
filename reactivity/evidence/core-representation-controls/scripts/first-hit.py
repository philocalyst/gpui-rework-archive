from pathlib import Path
import hashlib,json,os,subprocess,time
INPUT=Path('/tmp/gpui-hit_cost-inputs.json');ITEMS=json.loads(INPUT.read_text());OUT=Path('/tmp/gpui-hit-first-capture');OUT.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def guard():
 for x in ITEMS:
  cmd=['git','-c','safe.directory='+x['worktree'],'-C',x['worktree']]
  assert subprocess.check_output(cmd+['rev-parse','HEAD']).decode().strip()==x['source']
  subprocess.run(cmd+['diff','--exit-code','HEAD','--','.'],check=True,capture_output=True)
  assert sha(x['binary'])==x['binary_sha256']
  assert sha(Path(x['worktree'])/'reactivity/crates/gpui/tests/hit_cost.rs')==x['fixture_sha256']
guard();os.sched_setaffinity(0,{min(os.sched_getaffinity(0))})
for x in ITEMS:
 env=dict(os.environ,GPUI_HIT_PREFLIGHT='1')
 p=subprocess.run([x['binary'],'--ignored','--exact','public_hit_probe','--nocapture','--test-threads=1'],env=env,capture_output=True,text=True,check=True)
 (OUT/(x['label']+'-preflight.log')).write_text(p.stdout+p.stderr)
 assert p.stdout.count('preflight,')==16
for kind in ['cpu','io','memory']:(OUT/('pressure-before-'+kind)).write_text(Path('/proc/pressure/'+kind).read_text())
(OUT/'before.json').write_text(json.dumps({'started_utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'affinity':sorted(os.sched_getaffinity(0)),'inputs_sha256':sha(INPUT)},indent=2)+'\n')
rows=[]
for repeat in range(3):
 for x in (ITEMS if repeat%2==0 else ITEMS[::-1]):
  guard();env=dict(os.environ);env.pop('GPUI_HIT_PREFLIGHT',None)
  cmd=[x['binary'],'--ignored','--exact','public_hit_probe','--nocapture','--test-threads=1']
  p=subprocess.run(cmd,env=env,capture_output=True,text=True,check=True,timeout=60)
  output=p.stdout+p.stderr;name=f"{repeat+1}-{x['label']}.log";(OUT/name).write_text(output)
  lines=[s for s in output.splitlines() if s.startswith(('query,','mount,'))]
  # The first query can follow libtest's unbuffered test-name prefix.
  lines=[s[s.index('query,'):] if 'query,' in s else s for s in output.splitlines() if 'query,' in s or s.startswith('mount,')]
  assert len(lines)==24,(name,len(lines))
  rows.append({'repeat':repeat+1,'label':x['label'],'log':name,'sha256':sha(OUT/name),'command':cmd})
guard()
for kind in ['cpu','io','memory']:(OUT/('pressure-after-'+kind)).write_text(Path('/proc/pressure/'+kind).read_text())
(OUT/'runs.json').write_text(json.dumps(rows,indent=2)+'\n')
(OUT/'after.json').write_text(json.dumps({'finished_utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'guards':'PASS','runs':len(rows),'phase_rows':144},indent=2)+'\n')
print('PASS six processes,144 phases,32 paired preflight cases,allsource/fixture/executableguards')
