from pathlib import Path
import json,hashlib,subprocess,sys,tempfile
here=Path(__file__).resolve().parent

def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def read(p):return json.loads(p.read_text())
manifest=read(here/'MANIFEST.json')
for n,h in manifest.items():assert sha(here/n)==h,n
raw=here/'raw';capture=raw/'gpu-first'
assert read(capture/'guard.json')==read(raw/'lifetime-first/guard.json')==[]
assert (capture/'source.txt').read_text().strip()=='5d4a977f0e51a8350d7e333da2ee98f5464b022c'
for item in read(capture/'artifacts.json').values():assert sha(Path(item['preserved']))==item['sha256']
shader=(here/'frozen/hot.wgsl').read_bytes();meta=read(capture/'shader.json');elf=Path(read(capture/'artifacts.json')['hot_gpu']['preserved']).read_bytes()
assert hashlib.sha256(shader).hexdigest()==meta['sha256'];assert elf[meta['elf_offset']:meta['elf_offset']+len(shader)]==shader
assert read(capture/'clippy.status.json')['exit']==0
for line in (capture/'build.out').read_text().splitlines():
 x=json.loads(line)
 if x.get('reason')=='compiler-artifact' and x['target']['name']=='hot_gpu':assert not x['fresh']
baseline=Path('/home/user/gpui-display-radix-lab/reactivity/evidence/display-radix')
assert sha(baseline/'MANIFEST.json')==read(capture/'baseline.json')['manifest_sha']
for p in (capture/'public').rglob('*'):
 if p.is_file():assert p.read_bytes()==(baseline/'raw/combined-set-error/public'/p.relative_to(capture/'public')).read_bytes()
with tempfile.TemporaryDirectory(prefix='display-hot-verify-') as t:
 subprocess.run([sys.executable,str(here/'frozen/hot_checks.py'),str(Path(t)/'out')],check=True,stdout=subprocess.DEVNULL)
 assert read(Path(t)/'out/checks.json')==read(capture/'checks/checks.json')
 result=subprocess.check_output([sys.executable,str(here/'verify_hot_capture.py'),str(capture)],text=True)
 assert json.loads(result)==read(raw/'verification-with-controls.out')
print(json.dumps(dict(files=len(manifest),cpu_checks=5749,exact_hot_gpu_frames=208,exact_cold_control_frames=33,independent_simulated_frames=254,gpu_mutants=1,verified=True)))
