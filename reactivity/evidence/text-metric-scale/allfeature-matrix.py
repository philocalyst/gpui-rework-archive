import pathlib,subprocess,json,hashlib,sys
rows=[]
for p in sorted(pathlib.Path('/tmp/gpui-metric-allfeature-artifacts').glob('*/*')):
 result=subprocess.run([str(p),'--test-threads=1','--nocapture'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 print(result.stdout.decode(),flush=True);rows.append({'binary':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'exit':result.returncode})
 pathlib.Path('/tmp/gpui-metric-allfeature-artifacts.json').write_text(json.dumps(rows,indent=2)+'\n')
 if result.returncode:sys.exit(result.returncode)
