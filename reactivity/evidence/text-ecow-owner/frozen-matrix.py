import pathlib,subprocess,json,hashlib,sys
rows=[]
for variant,folder in [('canvas','/tmp/gpui-ecow-final-artifacts'),('gpu','/tmp/gpui-ecow-gpu-artifacts'),('runtime','/tmp/gpui-ecow-runtime-artifacts')]:
 for p in sorted(pathlib.Path(folder).iterdir()):
  if not p.is_file(): continue
  result=subprocess.run([str(p),'--test-threads=1','--nocapture'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
  print(result.stdout.decode(),flush=True); rows.append({'variant':variant,'binary':str(p),'sha256':hashlib.sha256(p.read_bytes()).hexdigest(),'exit':result.returncode})
  pathlib.Path('/tmp/gpui-ecow-frozen-matrix-artifacts.json').write_text(json.dumps(rows,indent=2)+'\n')
  if result.returncode: sys.exit(result.returncode)
