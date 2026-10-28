from pathlib import Path
import os,json,sys,hashlib,shutil
r=Path(__file__).parent;variant=sys.argv[1];assert variant in ['control','bounds','predecessor','omit']
if variant=='omit':
 target=Path('/home/user/gpui-region-omit-target');assert json.loads((r/'omit-instance/guard-after.json').read_text())==[];assert (r/'negative-receipt.json').is_file()
else:
 s=next(s for s in json.loads((r/'cost-control-sources.json').read_text()) if s['variant']==variant);target=Path(s['target']);gate=r/('cost-build-'+variant);assert json.loads((gate/'guard-after.json').read_text())==[]
 for name in ['build','test','gpu-test','port','clippy','gpu-clippy']:assert json.loads((gate/(name+'.status.json')).read_text())['exit']==0
out=r/('cache-cleanup-'+variant+'.json');assert not out.exists();rows=[]
for parent,ds,fs in os.walk(target):
 for name in fs:
  if name.endswith(('.rlib','.rmeta')):
   p=Path(parent)/name;rows.append({'path':str(p),'bytes':p.stat().st_size,'sha256':hashlib.file_digest(p.open('rb'),'sha256').hexdigest()})
out.write_text(json.dumps({'note':'Completed and reaped compile gates. Remove only regenerable library caches; preserve all executable/shader/evidence data.','files':rows},indent=2))
for row in rows:Path(row['path']).unlink()
print('removed',sum(row['bytes'] for row in rows),'free',shutil.disk_usage('/home/user').free,flush=True)
