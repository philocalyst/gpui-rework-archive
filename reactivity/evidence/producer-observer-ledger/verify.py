from pathlib import Path
import json,hashlib
r=Path(__file__).parent;sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
m=json.loads((r/'MANIFEST.json').read_text());assert set(m)=={p.relative_to(r).as_posix() for p in r.rglob('*') if p.is_file() and p.name!='MANIFEST.json'}
for n,h in m.items():assert sha(r/n)==h,n
for n,h in json.loads((r/'raw/source-inputs.json').read_text()).items():assert sha(r/'frozen'/n)==h,n
example=json.loads((r/'raw/observer-example.json').read_text());p=r/'raw/parent-trace.json';assert sha(p)==example['sha256']
a=json.loads(p.read_text());f=next(f for c in a if c['case']==example['case'] for f in c['frames'] if f['operation']==example['operation']);q=f['producer']
assert example['cold']==q['cold_correspondence'] and example['extents']==q['ordered_cold_extents'] and example['source_allocation']==f['source_allocation']
semantic=q['semantic_emission'];assert example['emission']=={k:v for k,v in semantic.items() if k not in ['current','previous']}
assert example['emission_current_work']==semantic['current']['work']
known=example['cold']['combined_store_run_trial_retained_bytes']+sum(x['current_and_history_plus_state_bytes'] for x in example['extents']['alternatives'])+semantic['store_header_bytes']+semantic['retained_heap_bytes'];assert known==example['known_observer_retained_bytes']==117977
rows=[]
for l in (r/'raw/timed-build.out').read_text().splitlines():
 d=json.loads(l)
 if d.get('reason')=='compiler-artifact' and d['target']['name'] in ['gpui','gpui_canvas','gpui_gpu','gpui_reactivity_core','gpui_reactivity_state','gpui_reactivity_host','gpui_inline_call']:rows.append({k:d[k] for k in ['package_id','target','profile','features','fresh']})
assert rows==json.loads((r/'raw/timed-cargo-profiles.json').read_text())
assert next(x for x in rows if x['target']['name']=='gpui')['profile']['test']
for name,feature in [('gpui_canvas','emission-trace'),('gpui_gpu','packet-trace')]:
 x=next(x for x in rows if x['target']['name']==name);assert not x['profile']['test'] and feature in x['features']
print(f'verified {len(m)} source/evidence files; source ledger only, no new build/test/timing or overhead subtraction')
