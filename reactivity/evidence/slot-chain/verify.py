from pathlib import Path
import json,hashlib
h=Path(__file__).resolve().parent
def read(p):return json.loads(p.read_text())
def sha(p):
 with p.open('rb') as f:return hashlib.file_digest(f,'sha256').hexdigest()
m=read(h/'MANIFEST.json')
for n,s in m.items():assert sha(h/n)==s,n
for cohort in ['first','borrow-revocation']:
 p=h/'raw'/cohort;assert read(p/'guard.json')==[]
 for stage in ['build','chain-unit','paint-storage','live','clippy']:assert read(p/(stage+'.status.json'))['exit']==0
 if cohort=='borrow-revocation':assert read(p/'borrow-failure.status.json')['exit']==0
 a=read(p/'artifact.json');assert not a['cargo_fresh'];assert sha(Path(a['preserved']))==a['sha256'];elf=Path(a['preserved']).read_bytes();shader=(p/'ui.wgsl').read_bytes()
 for s in read(p/'shaders.json').values():assert hashlib.sha256(shader).hexdigest()==s['sha256'] and elf[s['elf_offset']:s['elf_offset']+len(shader)]==shader
 frames=list((p/'live.pixels').glob('*-actual.rgba'));assert len(frames)==43
 for f in frames:
  assert f.stat().st_size==16384
  for k in ['cpu','fresh','full']:assert f.read_bytes()==f.with_name(f.name.replace('actual',k)).read_bytes()
 d=read(p/'live.json');assert len(d['rows'])==43
 for r in d['rows']:
  v=r['work']
  if r['case'] in ['one-slot','coalesced-chain','long-chain']:assert v['upload_bytes']==16 and v['validated_draws']==v['binning_tile_visits']==0
  if r['case']=='return-to-acknowledged-color':assert v['upload_bytes']==v['validated_draws']==0
 for name,key in [('foreign','authority_mutant_wrong_bytes'),('geometry','forged_chain_wrong_bytes')]:
  bad=(p/'live.negative'/f'{name}-actual.rgba').read_bytes();good=(p/'live.negative'/f'{name}-expected.rgba').read_bytes();assert sum(a!=b for a,b in zip(bad,good,strict=True))==d[key]==2048
 assert 'long_chain_allocations=0,long_chain_retained_bytes=0' in (p/'chain-unit.err').read_text()
 assert 'Transition=48' in (p/'paint-storage.err').read_text() and 'retained=6868,peak=6972' in (p/'paint-storage.err').read_text()
assert 'Transition=40' in (h/'raw/baseline-paint-storage.err').read_text() and 'retained=6860,peak=6964' in (h/'raw/baseline-paint-storage.err').read_text()
a=read(h/'raw/baseline-paint-storage.json');assert a['exit']==0 and sha(Path(a['artifact']['preserved']))==a['artifact']['sha256']
assert read(h/'raw/core-lines-candidate.json')['core_non_test_code_lines']==38077
assert (h/'raw/borrow-revocation/source.txt').read_text().strip()=='a10c29e6e0c62415609bf242e542f0778bceced7'
print(json.dumps(dict(files=len(m),final_four_oracle_frames=43,prior_frames_preserved=43,actual_pixel_mutants=2,chain_header_bytes=48,source_guards=True,verified=True)))
