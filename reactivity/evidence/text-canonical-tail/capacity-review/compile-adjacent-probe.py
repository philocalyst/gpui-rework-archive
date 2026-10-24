from pathlib import Path
import hashlib,json,os,subprocess
root=Path('/tmp/gpui-text-capacity-final-release-build')
out=Path('/tmp/gpui-text-capacity-final-probe');out.mkdir(exist_ok=False)
rows=[json.loads(s) for s in (root/'stdout.log').read_text().splitlines()]
assert json.loads((root/'result.json').read_text())['exit']==0
libraries={}
for name in ['gpui_canvas','allocation_counter']:
 matches=[r for r in rows if r.get('reason')=='compiler-artifact' and r['target']['name']==name and 'lib' in r['target']['kind'] and not r['profile']['test']]
 assert len(matches)==1,(name,len(matches))
 paths=[Path(p) for p in matches[0]['filenames']]
 libraries[name]={suffix:next(p for p in paths if p.suffix==suffix) for suffix in ['.rlib','.rmeta']}
probe=Path('/tmp/text-sol-evidence/adjacent-probe.rs')
compiler='/tmp/gpui-nightly-2026-10-23/bin/rustc'
args=[compiler,'--edition=2024','-C','opt-level=3','-C','symbol-mangling-version=v0','--crate-name','text_submission_probe',str(probe),'-o',str(out/'probe')]
for name,files in libraries.items():
 for p in files.values():args+=['--extern',f'{name}={p}']
paths=sorted({Path(p).parent for row in rows if row.get('reason')=='compiler-artifact' for p in row['filenames'] if Path(p).suffix in ('.rlib','.rmeta','.so')})
for path in paths:args+=['-L',f'dependency={path}']
with (out/'compile.log').open('w') as log:subprocess.run(args,stdout=log,stderr=log,check=True)
binary=out/'probe';binary.chmod(0o555)
sha=lambda p:hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
before=sha(binary)
with (out/'stdout.log').open('w') as log:subprocess.run([str(binary)],stdout=log,stderr=subprocess.STDOUT,check=True,timeout=120)
assert sha(binary)==before
result={'source':'71ed91f0ae42eeaa1d845c7e26d17be8b83e1c7b','probe_source':str(probe),'probe_source_sha256':sha(probe),'binary_sha256':before,'compiler':subprocess.check_output([compiler,'-Vv'],text=True),'compile_argv':args,'libraries':{name:{suffix:{'path':str(p),'sha256':sha(p)} for suffix,p in files.items()} for name,files in libraries.items()},'scope':'Identical public-API release allocation/capacity probe used by both original controls; no timing, peak-live or RSS claim.'}
(out/'identity.json').write_text(json.dumps(result,indent=2)+'\n')
print((out/'stdout.log').read_text(),flush=True)
