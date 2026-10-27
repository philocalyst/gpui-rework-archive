from pathlib import Path
import shutil,subprocess,json,hashlib,gzip,re
ext=Path(__file__).resolve().parent;wt=Path('/home/user/gpui-gpu-text-packet-lab');dest=wt/'reactivity/evidence/gpu-text-packet';raw=dest/'raw';assert not raw.exists()
shutil.copytree(ext,raw);shutil.copyfile(ext/'verify_dossier.py',dest/'verify.py');(raw/'shader').mkdir()
for phase in ['control','qualified']:
 for item in json.loads((raw/phase/'shader-identities.json').read_text()):
  p=Path(item['path']);assert hashlib.sha256(p.read_bytes()).hexdigest()==item['sha256'];shutil.copyfile(p,raw/'shader'/item['sha256'])
head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt,text=True).strip();base='5b670209df18941f8604bea2ee2d2bfe3597da78'
(raw/'change.patch').write_bytes(subprocess.check_output(['git','diff',base,head,'--','reactivity/crates','reactivity/Cargo.lock'],cwd=wt))
(raw/'negative.patch').write_bytes(subprocess.check_output(['git','show','--format=fuller','cca9f74c6db60fd4f71fdb63e10d804aa7620915','--','reactivity/crates'],cwd=wt))
stack={}
for name in ['control','candidate']:
 asm=gzip.decompress((raw/f'machine/{name}-assembly.txt.gz').read_bytes()).decode();items=[]
 for sym in json.loads((raw/'machine/summary.json').read_text())[name]['symbols']:
  pos=asm.find(f'{sym["address"]:016x} <');part=asm[pos:asm.find('\n\n',pos)];m=re.search(r'sub\s+\$0x([0-9a-f]+),%rsp',part[:2400])
  items.append({**sym,'local_prologue_reservation':int(m[1],16) if m else None})
 stack[name]=items
(raw/'machine/stack-reservations.json').write_text(json.dumps(stack,indent=2))
s=json.loads((raw/'paired/summary.json').read_text());ratios=s['ratios'];primary={k:v['median']<=.8 for k,v in ratios.items() if k in ['1000-2-exact','1000-4-exact']};controls={k:v['median']<=1.05 for k,v in ratios.items() if k.split('-')[1]=='1' or k.endswith('full')};verdict={'primary':primary,'controls':controls,'numerical_pass':all(primary.values()) and all(controls.values())};(dest/'verdict.json').write_text(json.dumps(verdict,indent=2))
notes='''# Retained GPU text-packet transactions — rejected performance qualification

The fixed gate fails: tiny full rebuilds with two and four fields have paired
completion ratios 1.080780 and 1.076605 against the full-preparation control.
All five two-field pairs exceed 1.05. The large two/four-field primary cases pass
at .690910/.547986, but these wins do not override the failed controls. Stream
completion improves only about 2–4%. No adoption, physical-GPU, scanout or ZGX
victory is claimed. The rejected CPU outline base remains separately rejected.

The implementation gathers and validates one to four same-length masked text
runs, then commits their compact GPU words and painter-ordered tile memberships.
Existing opaque cutoffs, resources, corrections, unchanged words and retained
pixels survive. Native publication requires the exact preceding scene token;
coalescing, unavailable masks and admission failures use full preparation.
Every rejection precedes mutation. Application View/Signal/Source APIs are
unchanged; low-level Canvas positional accessors and renderer patch APIs are
additive. Positions are valid only under the caller's matching scene authority.
No shader change, unsafe code, new worker or async executor is introduced.

The surviving CSR is still scanned and copied globally, and rebuilt index/range
arrays are uploaded when changed. The run map captures static masked groups too.
This is not O(changed) whole-frame work. BBTree's read/gather then ordered-write
structure motivates the transaction, without asserting its runtime or cache-hit
benefits transfer to this renderer. Solid's old-visible/new-candidate separation
is preserved through GPUI's existing presentation authority; this trial adds no
atomic multi-output task transition.

Correctness: 73 control and 75 corrected candidate GPU tests/doctests; 975 default
GPUI+Canvas and 1048 X11-composed tests/doctests; strict Clippy for these scopes;
six actual private-X11 scripts. The native Todo GPU script also exercises text
packet transitions, unchanged P before ACK, coalescing, failed newer CJK output,
older eligible C/ACK, missing-mask fallback, exposure and replay. Public GPU tests
compare exact fresh images across moved tile memberships, overlapping painter
order/opaque cutoffs, fractional transforms and SDR/HDR; late-member rejection
preserves the previous packet. An independently frozen missing-membership mutant
fails the exact image test with `new tile membership / painter order`.

First candidate a3495f600d failed two new tests with ChangedCommon. The correction
recomputes two derived error-bound lanes for the whole run and continues to match
other common words exactly. This was corrected and frozen before any timing;
failed outputs and input guards remain in raw/candidate. Shader code and exact
image oracles were not weakened. Native integration followed the measured GPU
build; its GPU/Canvas/core/fixture sources were verified byte-identical to that
build. Allocation diagnostics were added later without production changes; their
build and strict Clippy are separate gates, not repeated full-native tests.

Measurement: 21 cells, five alternating pairs, 210 fresh processes, 10 warmups
and 60 measured updates each (12600 measured, 2100 warmup). Canonical delta/scene
construction, GPU preparation/submission and queue completion are included.
Shaping is outside timing. `host_ns` is wall time through submission, not thread
CPU time; `complete_ns` includes the queue wait. Exact fresh initial/final images
and final scene receipts match across variants. This is a GPU diagnostic, not a
complete native input-to-display endpoint. CPU affinity 2–5, llvmpipe four threads,
960x720, the same DejaVu font and shared ZGX stream workload. No concurrent owned
builds/tests/probes/source edits during timings. All raw percentile samples,
cold first-operation times and whole-process RSS (including oracle) are retained.

At 1000 labels, separate medians of process p50 values are 2113.49→1460.23 us for
two fields and 2430.68→1352.22 us for four. Host submission wall medians fall
655.60→64.23 and 732.45→62.95 us; uploads 308436→416 and 308948→832 B. Stream
completion is 19308.85→19139.19 us, host 945.38→346.91 us, uploads333148→19312 B.
These ratios of separate medians differ from the paired ratios used for gates.
Tiny full two/four host medians also increase; this trial does not establish why.

Memory: 42 separate allocation processes, each with 60 warm samples and exact
fresh GPU images. Counts cover caller-thread Rust allocations only, excluding
foreign driver/worker allocations. Candidate sparse retained deltas are zero;
full-render samples in both variants include queue-allocation cycles (e.g.
[-912,304] B), so not every sample has zero retention. All nine full controls
match warm requests/requested/peak/retained-delta distributions. Run-map capacity
is additional. At 1000 labels, sparse two-field requests/requested bytes change
122/17225→97/80185, four-field132/19329→118/84317, stream131/50121→107/202059.
Fewer requests but more transient bytes is a real loss, charged to full CSR
scratch. Two/four/stream map capacity is16048/16080/16032 B; tiny single64 B.
RetainedRenderer header920→944 B, Renderer888, Stats200, Canvas464 unchanged.
Native TextResources176→192 B; default remains176 B. Explicit GPU/atlas/buffer
bytes per sample are in CSV; whole-process RSS is not allocator-only accounting.

Code: 37367 shipping first-party lines, +425 over the outline base. Generated
WGSL is unchanged, SHA256 ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1,
verified embedded in both timed executables. Measured ELF14695000→14729360 B
(+34360). Full retained render2117→2228 B; its local stack reservation664 B
unchanged. Retained-specialized preparation11655→11329 B, local reservation
1496→1448 B. New patch body8062 B/reservation856 B, wrapper439/88 B, and a new
sorting network3051/200 B plus helpers. These prologue reservations exclude
pushes, callees and driver stacks; they are not total stack bounds. Full symbol
and targeted assembly records are retained. Production dependencies unchanged;
allocation-counter0.8.1 is a diagnostic-only dev dependency already locked.

Provenance: base5b670209df18941f8604bea2ee2d2bfe3597da78;
protocol0deed98cc8701e84edf0ec14ab283733dd479e61;
shared control fixture64523d173a5bd33b3b55041334219b4e058edae8;
measured GPU candidate11ad2fff8f5efa9fe79ad82376e69133326c2531;
native integration4ee1af8db219b95c69bf3fc2eb14a18913cb9071;
allocation control83743fe1e9aa6d91860089b528fbe60c4bdd2844 and
candidate2b801e02f9fd311ac9a28f51dd80a11daa80f2ed;
negativecca9f74c6db60fd4f71fdb63e10d804aa7620915.
The planning note raw/native-integration-notes.txt predates the completed native
integration. All build/input/feature/compiler/executable receipts are preserved.
Use `python3 reactivity/evidence/gpu-text-packet/verify.py` to reconstruct the
fixed failed verdict, percentiles, allocations, image equality and artifact hashes.

The host is an AMD9950X KVM guest with no render node and unavailable performance
counters. Private X11 establishes execution, not scanout. Equal native workloads,
matched release profiles and two physical hardware classes remain required.

| Static labels | Fields | Mode | Paired completion ratio | Pair range |
|---:|---:|---|---:|---:|
'''
for case,v in ratios.items():
 r,n,m=case.split('-');notes+=f"| {r} | {n} | {m} | {v['median']:.6f} | {v['range'][0]:.4f}–{v['range'][1]:.4f} |\n"
(dest/'README.md').write_text(notes)
manifest={str(p.relative_to(dest)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(dest.rglob('*')) if p.is_file() and p.name!='manifest.json'};(dest/'manifest.json').write_text(json.dumps(manifest,indent=2));print('packaged',len(manifest),'files')
