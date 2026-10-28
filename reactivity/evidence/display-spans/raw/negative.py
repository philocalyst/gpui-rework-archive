from pathlib import Path
import copy,hashlib,json,subprocess,shutil,time
r=Path(__file__).parent;w=Path('/home/user/gpui-display-spans-lab');positive=r/'structural-oracle';root=r/'gpu-mutants';root.mkdir(exist_ok=False)
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def guard():return {n:sha(w/n) for n in subprocess.check_output(['git','ls-files','-z'],cwd=w).decode().split('\0') if n and (w/n).is_file()}
base=json.loads((positive/'model/jobs.json').read_text());art=json.loads((positive/'artifacts.json').read_text());exe=Path(art['consume']['preserved']);assert sha(exe)==art['consume']['sha256']
(root/'source.txt').write_bytes((positive/'source.txt').read_bytes());before=guard();(root/'inputs-before.json').write_text(json.dumps(before,indent=2));reports=[]
for name,series_name,count in [('span','public-packed',1),('old-damage','32-repeated-packed',3),('stale','public-packed',6),('codec-width','public-packed',1)]:
 d=root/name;d.mkdir();series=copy.deepcopy(next(s for s in base if s['name']==series_name));series['jobs']=series['jobs'][:count];job=series['jobs'][-1];old=copy.deepcopy(job)
 if name=='span':job['descriptor'][2]-=1
 elif name=='old-damage':job['descriptor'][8]=2
 elif name=='stale':job['descriptor'][6]=job['descriptor'][5]
 else:
  page=job['writes'][0]['words'];assert page[0]==1 and page[2]>0;page[2]-=1
 assert job!=old
 for j in series['jobs']:shutil.copy2(positive/'model'/j['pixels'],d/j['pixels'])
 p=d/'jobs.json';p.write_text(json.dumps([series],separators=(',',':')))
 (d/'mutation.json').write_text(json.dumps(dict(positive_series=series_name,frames=count,original_last_job=old,changed_last_job=job),indent=2))
 env=dict(__import__('os').environ,VK_ICD_FILENAMES='/usr/share/vulkan/icd.d/lvp_icd.json',LP_NUM_THREADS='4',XDG_RUNTIME_DIR='/home/user/gpui-xdg')
 start=time.time()
 with (d/'run.out').open('wb') as out,(d/'run.err').open('wb') as err:proc=subprocess.run([str(exe),str(p)],stdout=out,stderr=err,env=env)
 stem=series_name+'-'+job['name'];actual=(d/'gpu-readback'/f'{stem}.rgba').read_bytes();expected=(d/job['pixels']).read_bytes()
 words=(d/'gpu-readback'/f'{stem}.words').read_bytes();canonical=__import__('struct').pack('<'+'I'*len(job['canonical']),*job['canonical'])
 report=dict(name=name,exit=proc.returncode,elapsed_seconds=time.time()-start,job_sha256=sha(p),pixel_diff_bytes=sum(a!=b for a,b in zip(actual,expected,strict=True)),canonical_diff_bytes=sum(a!=b for a,b in zip(words,canonical,strict=True)),executable_sha256=sha(exe))
 assert proc.returncode==101 and (report['pixel_diff_bytes'] or report['canonical_diff_bytes']),report
 (d/'status.json').write_text(json.dumps(report,indent=2));reports.append(report);print(report,flush=True)
after=guard();(root/'guard.json').write_text(json.dumps([p for p in before.keys()|after.keys() if before.get(p)!=after.get(p)]));assert before==after
(root/'summary.json').write_text(json.dumps(reports,indent=2))
