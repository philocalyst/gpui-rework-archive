from pathlib import Path
import json,hashlib,re,subprocess
root=Path(__file__).resolve().parent;r=root/'raw'
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=read(root/'manifest.json');assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
sources={'gpu-initial':'ddf9f4b6c6adf625b2b839c9d4ffe52c4a01574c'};elfs=set()
for gate,source in sources.items():
 g=r/gate;assert (g/'source.txt').read_text().strip()==source and read(g/'guard-after.json')==[];assert read(g/'test.status.json')['exit']==(101 if gate=='negative-all' else 0)
 for a in read(g/'test-artifacts.json'):assert sha(Path(a['preserved']))==a['sha256'];elfs.add(a['sha256'])
 records=[]
 for line in (g/'test.out').read_text().splitlines():
  try:x=json.loads(line)
  except ValueError:continue
  if x.get('reason')=='compiler-artifact' and '/crates/gpu/' in x.get('manifest_path','') and x['target']['kind']==['lib']:records.append(x)
 assert records and any(not x['fresh'] for x in records),gate
s=(r/'gpu-initial/test.out').read_text();counts=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',s);assert [sum(int(x[i]) for x in counts) for i in range(3)]==[354,0,3];assert 'placement_tags_survive_inline_compact_and_banked_packets ... ok' in s and 'public_mask_lattice_readbacks_replay_clips_and_density_fallbacks ... ok' in s
assert read(r/'gpu-initial/clippy.status.json')['exit']==0
c=read(r/'gpu-initial/independent-pixels.json');assert c['frames']==c['exact_frames']==336 and c['mismatches']==0;assert {p.name for p in (r/'oracle-pixels').glob('*.rgba')}=={p['file'] for p in c['rows']}
for row in c['rows']:
 p=row['file'];b=(r/'oracle-pixels'/p).read_bytes();v=(r/'gpu-initial/pixels'/p).read_bytes();assert b==v and len(b)==row['bytes'];assert hashlib.sha256(b).hexdigest()==row['oracle_sha256']==row['parent_sha256']==row['candidate_sha256'];assert row['equal'] and row['differing_bytes']==0
assert 'public_sample_partitions_preserve_overlap_refinement_and_fallbacks ... ok' in s
receipt=read(r/'generated-shaders/receipt.json');sh=receipt['embedded'];data=Path(receipt['executed_render']['preserved']).read_bytes();assert hashlib.sha256(data[sh['offset']:sh['offset']+sh['bytes']]).hexdigest()==sh['sha256']==sha(r/'generated-shaders'/(sh['sha256']+'-ui.wgsl'));assert not receipt['executed_render']['cargo']['fresh']
for x in receipt['generated']:assert x['sha256']==sh['sha256'] and x['bytes']==sh['bytes']
w=Path('/home/user/gpui-mask-partitions-lab')
fixture='reactivity/crates/gpu/tests/support/mask_lattice.rs';assert subprocess.check_output(['git','show',sources['gpu-initial']+':'+fixture],cwd=w)==subprocess.check_output(['git','show','6faae98a:'+fixture],cwd=w);assert read(r/'shipping-lines-initial.json')['core_non_test_code_lines']==38283
print(json.dumps(dict(files=len(manifest),executable_identities=len(elfs),gpu_canvas_tests=354,ignored_tests=3,exact_frames=336,negative_control_pending=True,positive_correctness_passes=True,scope='Positive checks only; negative control and native/full qualification remain pending.')))
