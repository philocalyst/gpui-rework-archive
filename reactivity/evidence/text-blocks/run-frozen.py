import sys,pathlib,subprocess,json,hashlib,time
folder=pathlib.Path(sys.argv[1]); out=pathlib.Path(sys.argv[2]); out.mkdir(parents=True,exist_ok=True)
rows=[]
for binary in sorted(folder.iterdir()):
 if not binary.is_file() or binary.name=='text_run_probe': continue
 start=time.monotonic(); p=subprocess.run([str(binary),'--test-threads=1','--nocapture'],stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
 (out/(binary.name+'.log')).write_bytes(p.stdout)
 rows.append({'binary':str(binary),'sha256':hashlib.sha256(binary.read_bytes()).hexdigest(),'exit':p.returncode,'seconds':time.monotonic()-start})
 print(binary.name,p.returncode,flush=True)
(out/'result.json').write_text(json.dumps(rows,indent=2)+'\n')
sys.exit(any(x['exit']!=0 for x in rows))
