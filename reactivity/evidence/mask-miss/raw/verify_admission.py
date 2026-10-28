from pathlib import Path
import json,hashlib,re,subprocess
root=Path(__file__).resolve().parent;r=root/'raw'
def read(p):return json.loads(p.read_text())
def sha(p):return hashlib.file_digest(p.open('rb'),'sha256').hexdigest()
manifest=read(root/'manifest.json');assert set(manifest)=={str(p.relative_to(root)) for p in root.rglob('*') if p.is_file() and p.name!='manifest.json'}
for p,h in manifest.items():assert sha(root/p)==h,p
sources={'gpu-initial':'b817779c5609a038edd8f7d22f46863416c9e17e','negative-all':'6afe48ddddf5ddb406d43671a3037335072f2978'};elfs=set()
for gate,source in sources.items():
 g=r/gate;assert (g/'source.txt').read_text().strip()==source and read(g/'guard-after.json')==[];assert read(g/'test.status.json')['exit']==(101 if gate=='negative-all' else 0)
 for a in read(g/'test-artifacts.json'):assert sha(Path(a['preserved']))==a['sha256'];elfs.add(a['sha256'])
 records=[]
 for line in (g/'test.out').read_text().splitlines():
  try:x=json.loads(line)
  except ValueError:continue
  if x.get('reason')=='compiler-artifact' and '/crates/gpu/' in x.get('manifest_path','') and x['target']['kind']==['lib']:records.append(x)
 assert records and any(not x['fresh'] for x in records),gate
s=(r/'gpu-initial/test.out').read_text();counts=re.findall(r'test result: ok\. (\d+) passed; (\d+) failed; (\d+) ignored',s);assert [sum(int(x[i]) for x in counts) for i in range(3)]==[353,0,3];assert 'placement_tags_survive_inline_compact_and_banked_packets ... ok' in s and 'public_mask_lattice_readbacks_replay_clips_and_density_fallbacks ... ok' in s
assert read(r/'gpu-initial/clippy.status.json')['exit']==0
c=read(r/'gpu-initial/independent-pixels.json');assert c['frames']==c['exact_frames']==336 and c['mismatches']==0;assert {p.name for p in (r/'oracle-pixels').glob('*.rgba')}=={p['file'] for p in c['rows']}
for row in c['rows']:
 p=row['file'];b=(r/'oracle-pixels'/p).read_bytes();v=(r/'gpu-initial/pixels'/p).read_bytes();assert b==v and len(b)==row['bytes'];assert hashlib.sha256(b).hexdigest()==row['oracle_sha256']==row['parent_sha256']==row['candidate_sha256'];assert row['equal'] and row['differing_bytes']==0
witness=read(r/'negative-all/witness.json');log=(r/'negative-all/test.log').read_text()+'\n'+(r/'negative-all/test.out').read_text();assert '0 passed; 1 failed' in log;left=re.findall(r'^\s*left: (\[.*\])$',log,re.M);right=re.findall(r'^\s*right: (\[.*\])$',log,re.M);assert len(left)==len(right)==1;actual=bytes(json.loads(left[0]));expected=bytes(json.loads(right[0]));assert actual==(r/'negative-all/proof-enabled-mutant.rgba').read_bytes();assert expected==(r/'negative-all/proof-disabled-reference.rgba').read_bytes()==(r/'oracle-pixels'/witness['oracle_file']).read_bytes();bad=[i for i,(x,y) in enumerate(zip(actual,expected)) if x!=y];assert len(actual)==len(expected)==witness['bytes']==35840 and len(bad)==witness['differing_bytes']>0
assert (bad[0],expected[bad[0]],actual[bad[0]])==(witness['first_difference'],witness['expected'],witness['actual']);assert hashlib.sha256(actual).hexdigest()==witness['actual_sha256'] and hashlib.sha256(expected).hexdigest()==witness['expected_sha256']
receipt=read(r/'generated-shaders/receipt.json');sh=receipt['embedded'];data=Path(receipt['executed_render']['preserved']).read_bytes();assert hashlib.sha256(data[sh['offset']:sh['offset']+sh['bytes']]).hexdigest()==sh['sha256']==sha(r/'generated-shaders'/(sh['sha256']+'-ui.wgsl'));assert not receipt['executed_render']['cargo']['fresh']
for x in receipt['generated']:assert x['sha256']==sh['sha256'] and x['bytes']==sh['bytes']
w=Path('/home/user/gpui-mask-miss-lab');file='reactivity/crates/gpu/src/shader.rs';good=subprocess.check_output(['git','show',sources['gpu-initial']+':'+file],cwd=w).decode();mutant=subprocess.check_output(['git','show',sources['negative-all']+':'+file],cwd=w).decode();assert good.replace('let missed = lowered && mask_pixel_misses(draw, position);','let missed = lowered;')==mutant
fixture='reactivity/crates/gpu/tests/support/mask_lattice.rs';assert subprocess.check_output(['git','show',sources['gpu-initial']+':'+fixture],cwd=w)==subprocess.check_output(['git','show','6faae98a:'+fixture],cwd=w);assert read(r/'shipping-lines-candidate.json')['core_non_test_code_lines']==38207
print(json.dumps(dict(files=len(manifest),executable_identities=len(elfs),gpu_canvas_tests=353,ignored_tests=3,exact_frames=336,mutant_differing_bytes=len(bad),admission_correctness_passes=True,scope='Early tile-shader admission only; actual native selection/full configurations/offline/performance remain pending.')))
