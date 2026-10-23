from pathlib import Path
import json,re,hashlib
p=Path('/tmp/gpui-delivery-integration-captures');result={}
for f in sorted(p.glob('*.exit')):
 name=f.stem;r={'exit':int(f.read_text()),'source':None};command=p/(name+'-command.json')
 if command.exists():
  v=json.loads(command.read_text());r['source']=v.get('source') if isinstance(v,dict) else None
 before=p/(name+'-before.json');after=p/(name+'-after.json')
 if before.exists() and after.exists():r['source_guard']=json.loads(before.read_text())==json.loads(after.read_text());r['guard_inputs']=len(json.loads(before.read_text()))
 output=p/(name+'.jsonl')
 if output.exists():
  rows=re.findall(r'test result: (\w+)\. (\d+) passed; (\d+) failed; (\d+) ignored',output.read_text())
  if rows:r.update(test_harnesses=len(rows),passed=sum(int(x[1]) for x in rows),failed=sum(int(x[2]) for x in rows),ignored=sum(int(x[3]) for x in rows))
 result[name]=r
(p/'gate-summary.json').write_text(json.dumps(result,indent=2)+'\n')
a=json.loads((p/'cost-a2-build-before.json').read_text());b=json.loads((p/'cost-b-build-before.json').read_text());c=json.loads((p/'cost-c-build-before.json').read_text())
proof={'same_root_config_lock_manifests':all(a[k]==b[k]==c[k] for k in a if k.endswith('.toml') or k.endswith('Cargo.lock')),'ordinary_fixture_unchanged':a['reactivity/crates/gpui/examples/ordinary_control.rs']==b['reactivity/crates/gpui/examples/ordinary_control.rs']==c['reactivity/crates/gpui/examples/ordinary_control.rs'],'coarse_fixture_unchanged':a['reactivity/crates/gpui/examples/field_control.rs']==b['reactivity/crates/gpui/examples/field_control.rs'],'typed_changes_field_fixture_only':[k for k in b if b[k]!=c[k]],'controls':{}}
for label in ['cost-a2','cost-b','cost-c']:
 command=json.loads((p/(label+'-build-command.json')).read_text());cost=json.loads((p/(label+'-cost.json')).read_text());fps=json.loads((p/(label+'-fingerprints.json')).read_text())
 gpui=[v for k,v in fps.items() if k.endswith('/lib-gpui.json')]
 assert len(gpui)==1
 proof['controls'][label]={'source':command['source'],'compiler':command['compiler'],'environment':command['environment'],'cwd':command['cwd'],'gpui_fingerprint':gpui[0],'fresh':{r['target']['name']:r['fresh'] for r in cost['artifacts']},'binaries':cost['binaries']}
assert proof['same_root_config_lock_manifests'] and proof['ordinary_fixture_unchanged'] and proof['coarse_fixture_unchanged']
assert proof['typed_changes_field_fixture_only']==['reactivity/crates/gpui/examples/field_control.rs']
for field in ['rustc','features','profile','rustflags','config','compile_kind','deps']:
 values=[proof['controls'][l]['gpui_fingerprint'][field] for l in proof['controls']];assert values[0]==values[1]==values[2],field
(p/'matching-proof.json').write_text(json.dumps(proof,indent=2)+'\n')
print('all matched source/config/compiler/profile/dependency fingerprints hold')
