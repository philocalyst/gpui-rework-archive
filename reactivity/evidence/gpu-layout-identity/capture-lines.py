"""Syn test spans + Tokei 15; count core and authored vendor delta separately."""
import hashlib, importlib.util, json, subprocess, tempfile
from pathlib import Path
OUT=Path(__file__).resolve().parent
REPO=OUT.parents[2]
HELPER=Path('/tmp/gpui-inventory-sol-target/release/inventory-rust')
TOKEI='/nix/store/4m90mv0fyihsdrnidw8gkgmx6zvd5vqm-tokei-15.0.0/bin/tokei'
spec=importlib.util.spec_from_file_location('inventory',REPO/'reactivity/tools/inventory.py')
inv=importlib.util.module_from_spec(spec);spec.loader.exec_module(inv)
def git(*args):return subprocess.check_output(['git','-C',REPO,*args])
rows={}
for label,ref in [('numeric','f0d8d8f218'),('lease','15c30db1a9')]:
 rows[label]={'source':git('rev-parse',ref).decode().strip()}
 for scope,base in [('gpu','reactivity/crates/gpu/src'),('vendor_patch_file','reactivity/vendor/wgpu/src/backend/wgpu_core.rs')]:
  paths=git('ls-tree','-r','--name-only',ref,'--',base).decode().splitlines()
  sources=[(p,git('show',f'{ref}:{p}'),'Rust') for p in paths if p.endswith('.rs')]
  analyses=inv.rust_analysis(sources,HELPER)
  physical=excluded=0
  with tempfile.TemporaryDirectory(prefix='gpu-layout-lines-') as temp:
   for p,content,_ in sources:
    lines=content.decode().splitlines(keepends=True);physical+=len(lines);omit=set()
    for start,col,end,endcol in analyses[p].get('test_ranges',[]):
     for n in range(start,end+1):
      line=lines[n-1];prefix=line[:col] if n==start else '';suffix=line[endcol:] if n==end else ''
      if not prefix.strip() and not suffix.strip():omit.add(n)
    assert len(omit)==inv.excluded_test_lines(content,analyses[p]);excluded+=len(omit)
    dest=Path(temp)/p;dest.parent.mkdir(parents=True,exist_ok=True)
    dest.write_text(''.join('\n' if n in omit else l for n,l in enumerate(lines,1)))
   result=json.loads(subprocess.check_output([TOKEI,'--output','json',temp],text=True))
  rows[label][scope]={'physical':physical,'test_lines':excluded,'non_test_physical':physical-excluded,'code':result['Rust']['code']}
rows['delta']={scope:{k:rows['lease'][scope][k]-rows['numeric'][scope][k] for k in ['physical','test_lines','non_test_physical','code']} for scope in ['gpu','vendor_patch_file']}
rows['delta']['summed_code']=sum(rows['delta'][s]['code'] for s in ['gpu','vendor_patch_file'])
rows['tools']={'helper_sha256':hashlib.sha256(HELPER.read_bytes()).hexdigest(),'python_sha256':hashlib.sha256((REPO/'reactivity/tools/inventory.py').read_bytes()).hexdigest(),'tokei':TOKEI,'version':subprocess.check_output([TOKEI,'--version'],text=True).strip()}
(OUT/'source-lines.json').write_text(json.dumps(rows,indent=2)+'\n')
