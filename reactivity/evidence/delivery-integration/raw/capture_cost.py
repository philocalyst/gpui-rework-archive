from pathlib import Path
import hashlib,json,os,shutil,subprocess,sys
out=Path('/tmp/gpui-delivery-integration-captures');label=sys.argv[1]
binutils=Path('/nix/store/ddk8rvjihg4vhh1k6x9rc65y1zb1kx34-binutils-2.46/bin')
rows=[]
for line in (out/(label+'-build.jsonl')).read_text().splitlines():
 try:r=json.loads(line)
 except ValueError:continue
 if r.get('reason')=='compiler-artifact' and r.get('target',{}).get('name') in ['gpui','ordinary_control','field_control']:
  rows.append(r)
for r in rows:
 if r.get('executable') or (r['target']['name']=='gpui' and '--library-fresh' not in sys.argv):assert not r['fresh'],r
result={'artifacts':rows,'binaries':[]}
fingerprints={}
for line in (out/(label+'-build.jsonl')).read_text().splitlines():
 try: artifact=json.loads(line)
 except ValueError: continue
 if artifact.get('reason')!='compiler-artifact':continue
 for filename in artifact.get('filenames',[]):
  folder=Path(filename).parent.parent/'fingerprint'
  if folder.is_dir():
   for f in folder.glob('*.json'):fingerprints[str(f)]=json.loads(f.read_text())
(out/(label+'-fingerprints.json')).write_text(json.dumps(fingerprints,indent=2)+'\n')
for r in rows:
 if not r.get('executable'):continue
 name=r['target']['name'];src=Path(r['executable']);dst=out/(label+'-'+name+'.elf');shutil.copyfile(src,dst);dst.chmod(0o755)
 sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
 before=sha(dst)
 with (out/(label+'-'+name+'.ledger')).open('w') as f:subprocess.run([str(dst)],stdout=f,stderr=subprocess.STDOUT,timeout=60,check=True)
 for tool,args,suffix in [('size',['-A'],'.sections'),('nm',['-S','-C','--size-sort'],'.symbols'),('objdump',['-d','-C'],'.asm')]:
  with (out/(label+'-'+name+suffix)).open('w') as f:subprocess.run([str(binutils/tool),*args,str(dst)],stdout=f,check=True)
 assert before==sha(dst)==sha(src)
 result['binaries'].append({'name':name,'source':str(src),'frozen':str(dst),'sha256':before,'size':dst.stat().st_size})
(out/(label+'-cost.json')).write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps(result['binaries']),flush=True)
