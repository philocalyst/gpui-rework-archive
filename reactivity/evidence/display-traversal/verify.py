from pathlib import Path
import json,hashlib,subprocess,sys
h=Path(__file__).resolve().parent
for n,s in json.loads((h/'MANIFEST.json').read_text()).items():
 with (h/n).open('rb') as f:assert hashlib.file_digest(f,'sha256').hexdigest()==s,n
r=h/'raw/gpu-first';a=json.loads((r/'artifacts.json').read_text());m=json.loads((r/'shader.json').read_text());b=(h/'frozen/src/traversal.wgsl').read_bytes();elf=Path(a['traversal_gpu']['preserved']).read_bytes()
assert hashlib.sha256(b).hexdigest()==m['sha256'] and elf[m['elf_offset']:m['elf_offset']+len(b)]==b
assert json.loads((r/'clippy.status.json').read_text())['exit']==0
subprocess.run([sys.executable,str(h/'raw/verify_capture.py'),str(r)],check=True)
print('Manifest and frozen shader verified')
