from pathlib import Path
import json,hashlib,subprocess
r=Path(__file__).parent;o=r/'matrix-shaders';o.mkdir(exist_ok=False);a=json.loads((r/'matrix-artifacts.json').read_text());rows={}
for n,d in a.items():
 t=Path(d['worktree'].removesuffix('-lab')+'-target');files=list((t/'release/build/gpui_gpu').glob('*/out/ui.wgsl'));assert files
 values={hashlib.sha256(p.read_bytes()).hexdigest():p.read_bytes() for p in files};assert len(values)==1
 sha,data=next(iter(values.items()));elf=Path(d['preserved']).read_bytes();offset=elf.find(data);assert offset>=0,(n,'native binary lacks generated shader')
 g=Path(d['gate']);h=json.loads((g/'gpu-headers-artifacts.json').read_text());assert len(h)==1
 b=h[0]['preserved'];assert hashlib.sha256(Path(b).read_bytes()).hexdigest()==h[0]['sha256']
 names=subprocess.check_output([b,'--list'],text=True).splitlines();name=next(line.removesuffix(': test') for line in names if line.endswith('storage_records_match_shader_stride_and_offsets: test'))
 cmd=[b,name,'--exact','--nocapture'];p=subprocess.run(cmd,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True,timeout=60)
 (o/(n+'.out')).write_text(p.stdout);(o/(n+'.log')).write_text(p.stderr);(o/(n+'.status.json')).write_text(json.dumps(dict(command=cmd,exit=p.returncode)));assert p.returncode==0 and '1 passed; 0 failed' in p.stdout
 rows[n]={'wgsl_sha256':sha,'wgsl_bytes':len(data),'native_elf_sha256':d['sha256'],'native_elf_offset':offset,'generated_paths':[str(p) for p in files],'typed_shader_equality_artifact':h[0],'note':'normal native profile uses WGSL; offline-shader/SPIR-V feature is not selected'}
 print(n,'typed/generated equality and native-ELF shader bytes pass',flush=True)
assert len({v['wgsl_sha256'] for v in rows.values()})==1
(o/'receipt.json').write_text(json.dumps(rows,indent=2))
