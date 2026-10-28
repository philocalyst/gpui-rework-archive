from pathlib import Path
import json,hashlib,re
h=Path(__file__).resolve().parent
def read(p):return json.loads(p.read_text())
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
m=read(h/'MANIFEST.json')
for n,s in m.items():assert sha(h/n)==s,n
r=h/'raw';g=r/'diagnostic-corrected'
for n in ['first','token-diagnostics','diagnostic-corrected']:assert read(r/n/'guard.json')==[]
for n in ['first','token-diagnostics']:assert read(r/n/'build.status.json')['exit']==101
for n in ['build','live','clippy']:assert read(g/(n+'.status.json'))['exit']==0
assert (g/'source.txt').read_text().strip()=='64862c8fc8fa665fb85d398f3ea15b7d363ca621'
a=read(g/'artifact.json');assert not a['cargo_fresh'];assert sha(Path(a['preserved']))==a['sha256'];elf=Path(a['preserved']).read_bytes();shader=(g/'ui.wgsl').read_bytes()
for s in read(g/'shaders.json').values():assert hashlib.sha256(shader).hexdigest()==s['sha256'] and elf[s['elf_offset']:s['elf_offset']+len(shader)]==shader
p=g/'live.pixels';files=list(p.glob('*-actual.rgba'));assert len(files)==38
for f in files:
 assert f.stat().st_size==16384
 for k in ['cpu','fresh','full']:assert f.read_bytes()==f.with_name(f.name.replace('actual',k)).read_bytes()
d=read(g/'live.json');assert len(d['rows'])==38 and d['authority_mutant_wrong_bytes']==2048
for r in d['rows']:
 if r['case']=='one-slot':
  v=r['work'];assert v['upload_bytes']==16 and v['validated_draws']==v['binning_tile_visits']==0
  assert v['source_counters']['source_reads']==1
 if r['case']=='coalesced-full':assert r['work']['validated_draws']==r['n']
 if r['case']=='failed-newer-replay':assert r['work']['composited_pixels']==0
row=next(r for r in d['rows'] if r.get('n')==1024 and r['case']=='coalesced-full');assert row['work']['upload_bytes']==114960 and row['work']['binning_tile_visits']==8220
def body(s,n):
 a=s.index('{',s.index('fn '+n+'('));i=a+1;depth=1
 while depth:
  depth+=(s[i]=='{')-(s[i]=='}');i+=1
 return s[a+1:i-1]
old=body((h/'frozen/original-native.rs').read_text(),'render_damaged').replace('self.packet_token.take()','packet_token.take()').replace('self.packet_token','*packet_token').replace('self.renderer','renderer')
new=body((h/'frozen/native.rs').read_text(),'render_packet');assert re.sub(r'\s','',old)==re.sub(r'\s','',new)
assert read(h/'raw/core-lines-1.json')['core_non_test_code_lines']-read(h/'raw/core-lines-0.json')['core_non_test_code_lines']==16
print(json.dumps(dict(files=len(m),exact_four_oracle_frames=38,actual_mutant_wrong_pixel_bytes=2048,body_equivalence=True,source_shader_guards=True,verified=True)))
