"""Match actual Cargo graphs/artifacts; charge host closure and linked fixture bytes."""
from pathlib import Path
import hashlib,json,shlex,subprocess
ROOT=Path(__file__).resolve().parents[4];WORK=ROOT/'reactivity';OUT=WORK/'evidence/static-shader';CHECKS=OUT/'checks';TARGET=Path('/tmp/gpui-static-shader-sol-target')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def digest(p):return {'bytes':p.stat().st_size,'sha256':sha(p)}
snapshot=json.loads((CHECKS/'source.json').read_text())
def guard():assert {p:sha(ROOT/p) for p in snapshot['files']}==snapshot['files']
guard();rows={}
for label,features in [('default','counts'),('optional','counts,offline-shader')]:
 guard();command=['cargo','build','--offline','--locked','--release','--manifest-path','benchmarks/gpu-owner/Cargo.toml','--bin','first','--features',features,'--unit-graph','-Zunstable-options']
 shell='source /tmp/gpui-native-env.sh\nexport CARGO_BUILD_JOBS=2 CARGO_TARGET_DIR='+str(TARGET)+' RUSTC_BOOTSTRAP=1 GPUI_SPIRV_VAL=/nix/store/z5hs3p3inrq3w8cv71jycz7l4y3ny5xk-spirv-tools-1.4.363.0/bin/spirv-val\nexec '+shlex.join(command)
 graphpath=CHECKS/(label+'-unit-graph.json');logpath=CHECKS/(label+'-unit-graph.log')
 with graphpath.open('w') as out,logpath.open('w') as err:r=subprocess.run(['bash','-c',shell],stdout=out,stderr=err,cwd=WORK)
 assert r.returncode==0;guard()
 graph=json.loads(graphpath.read_text());units=graph['units']
 messages=[json.loads(s) for s in (CHECKS/('owners-'+label+'-build.jsonl')).read_text().splitlines() if s.startswith('{')]
 roots=[i for i,u in enumerate(units) if u['mode']=='build' and set(u['target']['kind'])&{'custom-build','proc-macro'}]
 host=set()
 def walk(index):
  if index in host:return
  host.add(index)
  for dep in units[index]['dependencies']:walk(dep['index'])
 for index in roots:walk(index)
 files={};used=[]
 for index in sorted(host):
  unit=units[index]
  if unit['mode']!='build':continue
  matches=[m for m in messages if m.get('reason')=='compiler-artifact' and m['package_id']==unit['pkg_id'] and m['target']['name']==unit['target']['name'] and m['target']['kind']==unit['target']['kind'] and m['features']==unit['features'] and m['profile']['opt_level']==unit['profile']['opt_level']]
  assert len(matches)==1,(unit,len(matches))
  for name in matches[0]['filenames']:
   path=Path(name);files[str(path.relative_to(TARGET))]=digest(path)
  used.append({'package':unit['pkg_id'],'target':unit['target']['name'],'features':unit['features'],'files':matches[0]['filenames']})
 artifact_feature_units=[u for u in units if any('/vendor/'+name+'#' in u['pkg_id'] for name in ['wgpu','wgpu-core','wgpu-hal'])]
 assert all(('shader-artifacts' in u['features'])==(label=='optional') for u in artifact_feature_units)
 host_naga=[u['features'] for i,u in enumerate(units) if i in host and '#naga@' in u['pkg_id'] and 'lib' in u['target']['kind']]
 assert all(('spv-in' in features)==(label=='optional') for features in host_naga)
 assert any('#sha2@' in u['pkg_id'] for i,u in enumerate(units) if i in host)==(label=='optional')
 rows[label]={'command':command,'graph_sha256':sha(graphpath),'host_units':used,'host_files':files,'host_logical_file_bytes':sum(v['bytes'] for v in files.values()),'host_naga_features':host_naga,'static_feature_enabled':label=='optional'}
old,new=rows['default']['host_files'],rows['optional']['host_files']
report={'source':snapshot['source'],'profiles':rows,'net_optional_host_bytes':rows['optional']['host_logical_file_bytes']-rows['default']['host_logical_file_bytes'],'added_or_replaced_host_files':{p:v for p,v in new.items() if p not in old},'superseded_host_files':{p:v for p,v in old.items() if p not in new},'note':'Logical files in complete host build-executable/proc-macro ancestor closure, including rlib/rmeta. Not disk blocks, loaded RSS, compile speed, target closure or all historical cache entries. Both configurations can coexist and retain superseded files. Default already compiles WGSL validation/output through wgsl-rs. Static source lifetime does not remove this host compiler cost.'}
report['binaries']={}
for label in ['default','optional']:
 info=json.loads((CHECKS/('owners-'+label+'-executables.json')).read_text())
 for name in ['first','driver-retained']:
  path=Path(info[name]['copy']);assert sha(path)==info[name]['sha256'];report['binaries'][label+'/'+name]=digest(path)
for name in ['first-artifact-counts','first-default-counts','driver-retained-artifact','driver-retained-default']:
 path=Path('/tmp/gpui-offline-shader-controls/bea848dbe4')/name;report['binaries']['prior-bea/'+name]=digest(path)
report['linked_first_counts_on_delta_optional_minus_default']=report['binaries']['optional/first']['bytes']-report['binaries']['default/first']['bytes']
report['linked_first_counts_on_delta_static_minus_prior_raw']=report['binaries']['optional/first']['bytes']-report['binaries']['prior-bea/first-artifact-counts']['bytes']
(OUT/'build-costs.json').write_text(json.dumps(report,indent=2)+'\n');guard()
print(json.dumps({'net_host_bytes':report['net_optional_host_bytes'],'linked_optional_first_delta':report['linked_first_counts_on_delta_optional_minus_default']}))
