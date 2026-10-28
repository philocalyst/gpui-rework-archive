from pathlib import Path
import hashlib,json
r=Path(__file__).resolve().parent;raw=r/'raw'
m=json.loads((r/'manifest.json').read_text())
for p,h in m.items():assert hashlib.sha256((r/p).read_bytes()).hexdigest()==h,p
for k in ['build','test','clippy']:assert json.loads((raw/f'first/{k}.status.json').read_text())['exit']==0
assert '10 passed; 0 failed' in (raw/'first/test.out').read_text()
assert json.loads((raw/'first/guard-after.json').read_text())==[]
assert json.loads((raw/'native-first/guard-after.json').read_text())==[]
results=json.loads((raw/'native-first/results.json').read_text());assert len(results)==6
for row in results:
 assert row['exit']==0
 expected=2660.+(14.*row['ticks'] if row['mode'] in ['scroll','both'] else 0.)+(32. if row['wheel'] else 0.)
 assert row['final_workload_offset']==expected
 if row['mode']=='idle':assert row['ticks']==0 and row['acknowledgements']==1
 assert (raw/'native-first'/row['screenshot']).stat().st_size>0
scope=json.loads((raw/'scope.json').read_text());assert scope['shipping_code_delta']==0
assert scope['changed_crate_files']==['reactivity/crates/gpui/examples/zgx_native_lab.rs']
a=json.loads((raw/'example-preservation.json').read_text());assert hashlib.sha256(Path(a['preserved']).read_bytes()).hexdigest()==a['original']['sha256']
print(f'verified {len(m)} files; example correctness only, no performance verdict')
