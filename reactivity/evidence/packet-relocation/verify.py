from pathlib import Path
import json,hashlib,subprocess,tempfile,shutil,collections
r=Path(__file__).parent
m=json.loads((r/'MANIFEST.json').read_text())
assert set(m)=={p.relative_to(r).as_posix() for p in r.rglob('*') if p.is_file() and p.name!='MANIFEST.json'}
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
for n,h in m.items():assert sha(r/n)==h,n
traces=[]
for lane,driver in [('first','gate-first.py'),('corrected','gate-corrected.py'),('complete','gate.py')]:
 p=r/'raw'/lane
 for gate in ['build','trace','clippy']:
  assert json.loads((p/(gate+'.status.json')).read_text())['exit']==(101 if lane=='first' and gate=='clippy' else 0)
 assert json.loads((p/'guard.json').read_text())==[]
 if lane!='first':assert json.loads((p/'overall.json').read_text())['decision']=='PASSED'
 a=json.loads((p/'artifact.json').read_text());elf=Path(a['preserved']).read_bytes();assert hashlib.sha256(elf).hexdigest()==a['sha256'];assert len(elf)==a['bytes'] and a['cargo_fresh'] is False
 shader=(p/'ui.wgsl').read_bytes()
 for q in json.loads((p/'shaders.json').read_text()).values():assert hashlib.sha256(shader).hexdigest()==q['sha256'] and elf[q['elf_offset']:q['elf_offset']+q['bytes']]==shader
 assert json.loads((p/'driver.json').read_text())['sha256']==sha(r/'raw'/driver)
 traces.append(json.loads((p/'trace/trace.json').read_text()))
assert traces[0]==traces[1]
for x,y in zip(traces[1],traces[2]):
 z=dict(y);z.pop('resources');assert x==z
assert len(traces[2])==15
assert (r/'source.txt').read_bytes()==(r/'raw/complete/source.txt').read_bytes()
inputs=json.loads((r/'raw/complete/inputs-before.json').read_text())
for p in (r/'frozen').rglob('*'):
 if p.is_file():assert sha(p)==inputs[p.relative_to(r/'frozen').as_posix()]
for lane in ['first','corrected']:
 assert (r/'raw'/lane/'ui.wgsl').read_bytes()==(r/'raw/complete/ui.wgsl').read_bytes()
with tempfile.TemporaryDirectory(prefix='gpui-packet-relocation-verify-') as t:
 t=Path(t)
 for script in ['analyze.py','domain_model.py']:
  shutil.copy2(r/'raw'/script,t/script)
  subprocess.run(['python3',str(t/script),str(r/'raw/complete/trace/trace.json')],check=True,stdout=subprocess.DEVNULL)
 for file in ['analysis.json','domain-model.json']:assert (t/file).read_bytes()==(r/'raw'/file).read_bytes()
analysis=json.loads((r/'raw/analysis.json').read_text());model=json.loads((r/'raw/domain-model.json').read_text())
assert model['roundtrip_frames']==15 and model['clip_parent_nonzero_cases']==0
mixed=next(x for x in analysis['transitions'] if (x['case'],x['operation'])==('mixed','insert'))
assert mixed['semantic']['paired_draws']==1 and mixed['semantic']['classes']=={'relocated reference':1}
root=mixed['semantic']['examples'][0];assert root['identity']==[1,0];assert len(root['changes'])==1
change=root['changes'][0];assert (change['old_word'],change['new_word'],change['old_lane'],change['old'],change['new'])==(3,3,1,48,54)
assert mixed['fixture_role_pairing']['classes']=={'relocated reference':7,'changed dependency':22}
keyed=next(x for x in analysis['transitions'] if (x['case'],x['operation'])==('keyed-256','insert'))
assert keyed['semantic']['classes']=={'changed dependency':14}
tiles=keyed['tile_referents'];assert sum(t['same_ordered_referents'] for t in tiles)==9
assert sum(t['same_ordered_referents'] and t['changed_addresses']>0 for t in tiles)==8
assert sum(t['changed_addresses'] for t in tiles if t['same_ordered_referents'])==143
relative=next(x for x in model['results'] if (x['case'],x['operation'])==('mixed','insert'))
assert (relative['raw_changed_matched_lanes'],relative['domain_changed_matched_lanes'],relative['stale_descriptor_wrong_lanes'])==(29,18,8)
for f in traces[2]:
 p=f['packet'];g=f['gpu'];assert g['upload_bytes']==len(p['records'])*16+len(p['ranges'])*8+len(p['references'])*4+len(p['corrections'])*32+48
 if f['case']=='mixed':
  initial=f['operation']=='initial';assert f['resources']['mask_upload_bytes']==(70 if initial else 0)
  assert f['resources']['atlas_bytes']==65536;assert f['image_stats']['uploaded_bytes']==(16 if initial else 0)
assert analysis['requirements']['mixed_cpu_gpu_parity'].startswith('FAILED')
print(f'verified {len(m)} files; 15 actual staging traces and exact reversible model; inherited mixed pixel gate remains FAILED; no adoption or timing claim')
