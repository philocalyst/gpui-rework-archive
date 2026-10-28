from pathlib import Path
import json,hashlib,re,subprocess
root=Path(__file__).resolve().parent;r=root/'raw'
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=read(root/'manifest.json');assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
sources={'gpu-unsigned':'39efefe58d08646a8976171770c369c28e91e10d','negative-coarse':'d992ae45a940edbe9fa847449314e65747e6c6c7'};elfs=set()
for gate,source in sources.items():
 g=r/gate;assert (g/'source.txt').read_text().strip()==source and read(g/'guard-after.json')==[];assert read(g/'test.status.json')['exit']==0
 for a in read(g/'test-artifacts.json'):assert sha(Path(a['preserved']))==a['sha256'];elfs.add(a['sha256'])
 records=[]
 for line in (g/'test.out').read_text().splitlines():
  try:x=json.loads(line)
  except ValueError:continue
  if x.get('reason')=='compiler-artifact' and '/crates/gpu/' in x.get('manifest_path','') and x['target']['kind']==['lib']:records.append(x)
 assert records and any(not x['fresh'] for x in records),gate
s=(r/'gpu-unsigned/test.out').read_text();counts=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',s);assert [sum(int(x[i]) for x in counts) for i in range(3)]==[356,0,3];assert 'placement_tags_survive_inline_compact_and_banked_packets ... ok' in s and 'public_mask_lattice_readbacks_replay_clips_and_density_fallbacks ... ok' in s
assert read(r/'gpu-unsigned/clippy.status.json')['exit']==0
c=read(r/'gpu-unsigned/independent-pixels.json');assert c['frames']==c['exact_frames']==336 and c['mismatches']==0;assert {p.name for p in (r/'oracle-pixels').glob('*.rgba')}=={p['file'] for p in c['rows']}
for row in c['rows']:
 p=row['file'];b=(r/'oracle-pixels'/p).read_bytes();v=(r/'gpu-unsigned/pixels'/p).read_bytes();assert b==v and len(b)==row['bytes'];assert hashlib.sha256(b).hexdigest()==row['oracle_sha256']==row['parent_sha256']==row['candidate_sha256'];assert row['equal'] and row['differing_bytes']==0
negative=read(r/'negative-coarse/independent-pixels.json');assert negative['frames']==negative['mismatches']==336 and negative['exact_frames']==0
for row in negative['rows']:
 original=(r/'oracle-pixels'/row['file']).read_bytes();actual=(r/'negative-coarse/pixels'/row['file']).read_bytes();bad=[i for i,(x,y) in enumerate(zip(original,actual)) if x!=y]
 assert len(original)==len(actual)==row['bytes'] and len(bad)==row['differing_bytes']>0
 assert (bad[0],original[bad[0]],actual[bad[0]])==(row['first_difference'],row['first_expected'],row['first_actual'])
 assert hashlib.sha256(actual).hexdigest()==row['candidate_sha256'] and hashlib.sha256(original).hexdigest()==row['oracle_sha256']==row['parent_sha256']
assert '1 passed; 0 failed' in (r/'negative-coarse/test.out').read_text() and 'AssertionError' in (r/'negative-coarse.log').read_text()
initial=r/'gpu-initial';assert (initial/'source.txt').read_text().strip()=='02d46fee9533d1b8c8b551337d3ccec5b84c0a0b';assert read(initial/'test.status.json')['exit']==101 and read(initial/'guard-after.json')==[] and read(initial/'test-artifacts.json')==[];assert 'Operation Divide' in (initial/'test.log').read_text()
for name in ['fine_grid_budget_boundary_and_partial_bins','mask_grid_selection_preserves_coarse_budget_fallback','alternating_mask_and_solid_grids_preserve_exact_packet_replay']:assert name+' ... ok' in s
receipt=read(r/'generated-shaders/receipt.json');sh=receipt['embedded'];data=Path(receipt['executed_render']['preserved']).read_bytes();assert hashlib.sha256(data[sh['offset']:sh['offset']+sh['bytes']]).hexdigest()==sh['sha256']==sha(r/'generated-shaders'/(sh['sha256']+'-ui.wgsl'));assert not receipt['executed_render']['cargo']['fresh']
for x in receipt['generated']:assert x['sha256']==sh['sha256'] and x['bytes']==sh['bytes']
w=Path('/home/user/gpui-mask-grid-lab');file='reactivity/crates/gpu/src/shader.rs';good=subprocess.check_output(['git','show',sources['gpu-unsigned']+':'+file],cwd=w).decode();mutant=subprocess.check_output(['git','show',sources['negative-coarse']+':'+file],cwd=w).decode();assert good.replace('if (globals.viewport.w & 16) != 0 {','if false {')==mutant
fixture='reactivity/crates/gpu/tests/support/mask_lattice.rs';assert subprocess.check_output(['git','show',sources['gpu-unsigned']+':'+fixture],cwd=w)==subprocess.check_output(['git','show','6faae98a:'+fixture],cwd=w);assert read(r/'shipping-lines-candidate.json')['core_non_test_code_lines']==38262
print(json.dumps(dict(files=len(manifest),executable_identities=len(elfs),gpu_canvas_tests=356,ignored_tests=3,exact_frames=336,mutant_mismatched_frames=336,admission_correctness_passes=True,scope='Early grid admission only; actual native selection/full configurations/offline/performance remain pending.')))
