from pathlib import Path
import json,hashlib,subprocess,shutil
r=Path(__file__).resolve().parent;w=Path('/home/user/gpui-native-list-parity-lab');d=w/'reactivity/evidence/native-list-parity';raw=d/'raw';assert not raw.exists();raw.mkdir()
for p in r.iterdir():
 if p.name=='__pycache__':continue
 if p.is_dir():shutil.copytree(p,raw/p.name)
 else:shutil.copy2(p,raw/p.name)
(raw/'change.patch').write_bytes(subprocess.check_output(['git','diff','93f63b4a03','HEAD','--','reactivity/crates'],cwd=w))
changed=subprocess.check_output(['git','diff','--name-only','93f63b4a03','HEAD','--','reactivity/crates'],cwd=w).decode().splitlines();assert changed==['reactivity/crates/gpui/examples/zgx_native_lab.rs']
(raw/'scope.json').write_text(json.dumps({'base':'93f63b4a03f7d428911330a3b71c04b0f4396dfa','source':subprocess.check_output(['git','rev-parse','HEAD'],cwd=w).decode().strip(),'changed_crate_files':changed,'shipping_code_delta':0},indent=2))
(d/'README.md').write_text('''# Native keyed-list workload port

The comparison example now uses public uniform_list with a lazy100K item source,
stable index keys, row height28, overscan2 and registered Signal<f64> scroll offset.
Before each owner tick, Driver reads that source into the unchanged reference
Workload, then publishes the next position for Scroll/Both. Wheel and programmatic
scroll therefore survive the next timer tick. Stream-only exact ingress remains.
String generation and publication stay on the UI thread; producer sends only ticks.

Base93f63b4a03; protocol18a82e047a; example52b02729a7; final sourcece00e554f2 adds
final workload-offset diagnostics. Only the example changed: no shipping library,
dependency, vendor, shader or shared reference Workload edits. The source-controlled
list core is qualified separately. All changes remain local; no performance claim.

Ten example tests and strict Clippy pass. The previous positional view is retained
as an independent pixel oracle. Complete pixels match at0,14,16.5,2660 and2799600;
public realized ranges match Workload.row_range and never exceed19. All modes
match reference text and offset progression. Wheel16.5 and programmatic index scroll
feed subsequent UI ticks, keep overlapping target identity and match fresh pixels.
Exact stream delivery still reports one exact update and zero owner reruns.

Six actual X11/software-Vulkan runs pass: exact/owner stream, scroll, both, idle,
and both plus real X11 wheel input. All finish, acknowledge coherent frames, close
and join the producer without presentation errors. Idle emits one initial ACK.
Final workload offset equals2660 +14 per admitted scroll tick +32 for the injected
wheel. Screenshots and exact artifact/input guards are retained. These runs overlap
another isolated compilation; their tick counts are correctness bookkeeping only,
not frame-rate, throughput or latency measurements. Native retained rows are not
measured: the misleading former mounted_rows=range.len log is removed, and public
headless realization is the stated evidence. No hidden model mutation counter is
used to impersonate native row lifetimes.

Reference input correction: the protocol's inherited wheel28 note was wrong.
Pinned ZGX a3678578980e uses40 logical pixels by default on Linux, desktop-setting
adjustments, and scroll resampling enabled by default.28 is row height. GPUI's
existing native conversion remains32. Matching interactive input trajectories,
deferred controls, release profiles, text edge quality and two physical hardware
classes remain gates. Fixed14px timer arithmetic and the16.5px input test are exactly
representable in f32/f64; arbitrary fractional precision equivalence is not claimed.

Shipping code delta0. Example ELF26305568->26306600 (+1032B); list planner2189B with
local stack reservation280, row-style284B, present-walk25808B with4096+216 prologue
reservations are unchanged. This is not a whole-stack or allocation measurement.
Exact artifact SHA8276886e00455a69769067e96d0ff28d5410d8eef83feb9927172608cec4e1ef
is separately preserved. No new complete memory or timing campaign was run.

Run python3 verify.py for source scope, raw file digests, tests, native results,
input guards and preserved executable identity. This is workload preparation for
architecture experiments, not adoption evidence or a ZGX victory.
''')
(d/'verify.py').write_text('''from pathlib import Path
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
''')
manifest={str(p.relative_to(d)):hashlib.sha256(p.read_bytes()).hexdigest() for p in d.rglob('*') if p.is_file() and p.name!='manifest.json'};(d/'manifest.json').write_text(json.dumps(manifest,indent=2))
