from pathlib import Path
import json,hashlib,subprocess,time,os
OUT=Path('/tmp/gpui-core-third-capture');OUT.mkdir(exist_ok=False)
PYTHON='/nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3'
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def guard_artifacts():
 for manifest in ['/tmp/gpui-raster-third-inputs.json','/tmp/gpui-hit-third-inputs.json']:
  for row in json.loads(Path(manifest).read_text()):
   if 'build_json' in row:assert sha(row['build_json'])==row['build_json_sha256']
   for path,checksum in row.get('root_library',{}).get('files',{}).items():assert sha(path)==checksum

def snapshot():
 processes=subprocess.check_output(['ps','-eo','pid,stat,pcpu,comm'],text=True)
 for line in processes.splitlines()[1:]:
  p=line.split()
  if len(p)==4 and not any(x in p[1] for x in 'TZ'):assert p[3] not in ['cargo','rustc','clippy-driver','rust-lld'],line
 return {'utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'affinity':sorted(os.sched_getaffinity(0)),'processes':processes,**{f'{k}_pressure':Path('/proc/pressure/'+k).read_text() for k in ['cpu','io','memory']}}
guard_artifacts();(OUT/'before.json').write_text(json.dumps(snapshot(),indent=2)+'\n')
subprocess.run([PYTHON,'/root/gpui-ce3/reactivity/benchmarks/bin-miss/run.py','/tmp/gpui-raster-third-inputs.json',str(OUT/'raster'),'--rounds','3'],check=True,timeout=120)
guard_artifacts();(OUT/'between.json').write_text(json.dumps(snapshot(),indent=2)+'\n')
subprocess.run([PYTHON,'/tmp/gpui-hit-third-capture.py'],check=True,timeout=120)
guard_artifacts();(OUT/'after.json').write_text(json.dumps(snapshot(),indent=2)+'\n')
print('PASS both campaigns;all frozen library/build/executable/source/fixture guards;no compiler process at snapshots')
