"""Sealed evidence verifier. No network, compiler, or candidate checkout needed."""
from pathlib import Path
import json,hashlib,subprocess,sys,tempfile
here=Path(__file__).resolve().parent

def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
def read(p):return json.loads(p.read_text())
manifest=read(here/'MANIFEST.json')
for name,expected in manifest.items():assert sha(here/name)==expected,name
raw=here/'raw';good=raw/'combined-set-error'
for capture in raw.glob('combined-*'):
 assert read(capture/'guard.json')==[]
 if (capture/'artifacts.json').exists():
  for name,item in read(capture/'artifacts.json').items():
   elf=Path(item['preserved']);assert sha(elf)==item['sha256'];assert elf.stat().st_size==item['bytes']
  shader=(capture/'frozen-attempt/radix.wgsl').read_bytes();meta=read(capture/'shader.json');assert hashlib.sha256(shader).hexdigest()==meta['sha256']
  elf=Path(read(capture/'artifacts.json')['radix_gpu']['preserved']).read_bytes();assert elf[meta['elf_offset']:meta['elf_offset']+len(shader)]==shader
assert (good/'source.txt').read_text().strip().startswith('e254d42901')
assert read(raw/'combined-initial/gpu-resource-overlap-compressed-m0.status.json')['exit']==101
assert 'left: (0, 96)' in (raw/'combined-initial/gpu-resource-overlap-compressed-m0.err').read_text()
assert read(raw/'combined-linear/public.status.json')['exit']==101
assert read(raw/'combined-failed-newer/build.status.json')['exit']==101
assert read(good/'clippy.status.json')['exit']==0
for name in ['radix.py','radix_jobs.py','radix_checks.py','radix_public.rs','radix_gpu.rs','radix.wgsl']:
 assert (here/'frozen'/name).read_bytes()==(good/'frozen-attempt'/name).read_bytes()
artifacts=[]
for line in (good/'build.out').read_text().splitlines():
 item=json.loads(line)
 if item.get('reason')=='compiler-artifact' and item['target']['name'] in ['radix_gpu','radix_public']:artifacts.append(item)
assert len(artifacts)==2
assert {a['target']['name']:a['fresh'] for a in artifacts}=={'radix_public':False,'radix_gpu':True}
with tempfile.TemporaryDirectory(prefix='display-radix-verify-') as directory:
 dest=Path(directory)/'checks'
 subprocess.run([sys.executable,str(here/'frozen/radix_checks.py'),str(dest)],check=True,stdout=subprocess.DEVNULL)
 assert read(dest/'checks.json')==read(good/'checks/checks.json')
 replay=subprocess.check_output([sys.executable,str(here/'verify_capture.py'),str(good)],text=True)
 assert json.loads(replay)==read(raw/'verification.out')
print(json.dumps(dict(files=len(manifest),source=(good/'source.txt').read_text().strip(),cpu_checks=3906,exact_gpu_frames=241,gpu_mutants=5,independent_simulated_frames=296,verified=True)))
