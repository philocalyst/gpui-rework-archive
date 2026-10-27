from pathlib import Path
import shutil,subprocess,json,re,statistics,hashlib
base=Path('/home/user')
notes={
'sparse-batch':'''# Atomic sparse text batches

Rejected performance variant; the fixed 5% control gate fails. No adoption,
ZGX ranking or hardware claim. All work is local.

Two to four disjoint source-text changes now prepare one atomic sparse canonical
scene transaction after ordinary layout proves zero geometry writes. Canvas
validates all run slots/common state, duplicate addresses, raster leases, aggregate
resource uses and tile-reference limits before changing any command. The complete
batch then publishes in input order with one damage union and one ACK. Old text
and interaction geometry remain presented until that ACK. No application API
change or new unsafe; Canvas adds an optional low-level TextRunReplacement API.
Run-length, geometry, new-resource, unknown-source and owner-dependent cases keep
the full path. This is BBTree-style gather/validate/ordered commit, not a custom
async executor or a measured cache-hit improvement.

Four Canvas tests and three public GPUI tests cover exact fresh reconstruction,
transformed/fractional clips, collective final resource uses, late-member failure,
duplicates/foreign layout, two/four-field edits, intrinsic layout fallback and
failed newer preparation followed by an older eligible ACK. An internal assertion
confirms actual sparse-row preparation. The sequential-commit mutant fails the
public pixel assertion that a later rejected run must leave the first unchanged.
Default GPUI+Canvas tests/doctests: 975; X11 composition: 1048; strict Clippy and
six actual X11 scripts pass. These are composition checks, not native timing.

Preserved failures: first Clippy rejected an unused mut in a new test; full
all-target Clippy then found a pre-existing type-complexity warning in the old
text_cache_capacity example. The corrections only remove mut and add an example
type alias. No production change was made to select a passing test outcome.

Before paired timing, artifact hashes exposed Cargo convenience example paths
replaced by native test builds. The first 42 allocation probes/four preflights
used matching native-feature binaries; they are preserved in excluded directories.
The original full/artifact receipt was also taken after default tests had replaced
the build-only alias. artifact-pin repeats explicit build-only commands under full
source guards, captures dependency fingerprints, and binds direct build/out files.
The intended control hashes match the historical receipts exactly. All intended
allocation probes/preflights were run with matching default+simd artifacts before
any paired timing. See raw/artifact-pin/RECOVERY.json; no timing sample was discarded.

The complete trial has 210 fresh processes / 840000 enqueue, deliver, record and
ACK operations, five alternating pairs per 21 cells on CPU2, 200 warmups, 40×100
operations. Both variants retain zero owner reruns for every exact-source batch;
coarse controls perform 4000. All final source epochs/pixels match the independent
fresh-window oracle. Primary 1000-label two/four-field CPU ratios .06928/.12344
(14.4x/8.1x) pass. The 25-label two-field owner control is 1.05617 and fails.
The zero-label two-field exact case is also slower, ratio 1.07818. Keep both
losing regimes and all paired ranges; narrow regressions are not assigned a
hardware cause by these measurements.

Separate 42-process allocation probes: with 1000 static labels, two-field warm
requests 84→63 and requested bytes 341828→5688; four-field 120→114 and
343672→10628. One-field remains 33 requests/2602 B. Warm retained delta is zero
in every cell; all one-field/coarse warm allocation records match exactly.
Concrete Win wrappers remain 296 B typed / 256 B opaque. TextResources itself
is 176 B: the patch owner grows 8→16 B for a boxed slice, while DirtyText remains
24 B and each owned patch row is 40 B. Transient clones/plans are charged.

Shipping inventory: 36941 lines, +280 over the 36661-line base. Default measured
ELF: 10198560→10245928 B. Linked try_sparse_text grows 2078→5337 B per
specialization as the new batch body is inlined; the stack reservation grows
344→584 B, with six pushes in both. These are local prologue sizes, not a bound
on total call-stack use. Delivery routine sizes remain 5672/5650/5672 B. The
whole symbol tables/selected assembly are preserved. An outline-only follow-up
will test the enlarged routine; this is not an established explanation of the
control regression.

The native GPU adapter still rebuilds/uploads the complete packet for text; this
CPU experiment does not implement sparse GPU text-record or tile-index updates.
An AMD9950X KVM guest, shared host noise, unavailable perf counters, software
Vulkan and no render node limit the evidence. No builds/tests/allocator probes
or source edits ran during paired timing. Full source and ELF guards pass.
Cold owner-creation times and whole-process maximum RSS (including diagnostic
fresh-window pixels) are separate in raw/paired-cold-rss.json; they are not an
attribution of GPU/driver allocations. CPU/wall p50/p95/p99 remain in the raw
summaries and batches. No warm/cold/scanout endpoint mixing.
''',
'question-source-borrowed':'''# Borrowed source cohorts for Questions

Rejected performance variant: the zero-static-label, two-field dependent control
exceeds the fixed 5% limit. No adoption, hardware win or ZGX claim.

This separate formulation keeps the by-value trial's complete four-source
invalidation semantics but borrows that fixed array for one synchronous earlier-
first Question refresh. No source-set or mutable owner borrow enters a worker.
External tasks retain real wakeups, request versions, cancellation and physical
teardown credit. Application APIs and persistent window fields are unchanged;
there is no generic executor, result cache or automatic atomic multi-output
transition. Source-only declarations unrelated to every admitted field can remain
Ready; Reader-input families still resolve against the updated dependency graph.
Owner/opaque/overflow/terminal changes retain coarse refresh.

719 default GPUI tests/doctests, 792 X11 tests/doctests, strict Clippy, all four
changed-field positions, tuple/diamond/A-B-A/fallback cases and six actual X11
scripts pass. A separate dropped-first-member mutant fails because its dependent
worker never dispatches. The previous-value/physical-credit guarantees survive.
No new production unsafe code. Correctness does not imply automatic Solid-style
atomic publication of all reactive outputs.

The complete baseline trial contains 240 fresh processes / 960000 settled
operations: enqueue 1/2/4 updates, deliver/record/ACK Pending when needed, then
deliver/record/ACK the immediate completion to reach the same Ready endpoint.
The Ready-result read/clone is included in both timers. Final independent fresh-
window pixels and exact dispatch/accept counters pass in all cells. Five
alternating pairs, CPU2, 200 warmups, 40×100 operations per process. No builds,
tests, allocator probes or source edits run during timing; full guards pass.

Primary unrelated two/four-field 1000-label ratios .05313/.05741 (18.8x/17.4x)
pass. The zero-label two-field dependent median 1.07654 fails, with pair range
.9508–1.1731. The prior by-value trial's losing 25-label dependent and 1000-label
owner controls are .98019/.97210 in this new baseline comparison. Those outcomes
do not erase either trial's failures or establish causality for code-size changes.

Three additional alternating pairs compare borrowed against the old owned
candidate on four preregistered cells, separately from the five-pair verdict.
Median ratios: 25-label two-field dependent 1.00108; 1000-label owner .97194;
unrelated two-field .98759 and four-field .99809. Except the owner case, paired
ranges cross one. This offers little evidence of a general borrowing speedup.
All output/task checks and source guards pass in those 24 extra processes.

All 48 separate allocation probes already matched the intended default build
hashes before artifact recovery; none were repeated to select an outcome.
At 1000 labels, unrelated two-field requests 9334→86, bytes 5043910→342511;
four-field 9363→122, bytes 5045324→344481. Every warm retained delta is zero.
One-field/dependent/coarse allocation records and Win wrapper sizes match exactly:
520 B unrelated/owner, 600 B tuple, 480 B opaque. Change is 24 B and transient
SourceEdits 40 B. Borrowing adds no heap allocation or persistent field.

Shipping inventory: 36697 lines, +5 over the owned candidate, +36 over its
source-batch base. Measured ELF is 10370632 B, versus 10371032 B owned and
10360664 B original control. Four delivery routines are 7369 B each, versus
7429 owned and 6705 original. Three refresh routines remain 3153/3153/3159 B.
These are linked/code-layout observations, not measured hardware-cache hits.

Native tests replaced Cargo's convenience cost-example path. Before timing,
artifact-pin restored the explicit default+simd build and bound its direct hashed
build/out executable. Its ELF hash matches the original first/artifact receipt
exactly. All allocation/default/native feature scopes remain explicit.

This AMD9950X KVM guest has variable host load, no render node and no permitted
hardware perf counters. Software-X11 correctness and recorder timings do not
establish native presentation/scanout latency. Cold owner/task creation and
whole-process maximum RSS, including pixel-oracle work, are reported separately
in raw/paired-cold-rss.json and raw/mechanism-cold-rss.json. Full CPU/wall tails,
raw samples, source/compiler/feature receipts, failures and assembly are retained.
'''}
for trial in ['sparse-batch','question-source-borrowed']:
 ext=base/f'gpui-{trial}-evidence';wt=base/f'gpui-{trial}-lab';name='sparse-text-batch' if trial=='sparse-batch' else trial;dest=wt/'reactivity/evidence'/name;raw=dest/'raw';assert not raw.exists();shutil.copytree(ext,raw)
 if trial=='sparse-batch':
  shutil.copytree(base/'gpui-source-batch-evidence/artifact-pin',raw/'control-pin');cfg={'kind':'sparse','tests':{'full':975,'composed':1048},'clippy':['qualified','full-clippy','composed'],'clippy_failures':['first','full'],'negative_message':'later admission failure must roll back the entire batch','control_receipt':'control-pin/cost-artifact.json'}
  origin='1830d9d54fe73903ffd909e3e19aab8c25e9763d';negative='local/sparse-batch-negative'
 else:
  for phase in ['control-qualified','control-allocation']:
   shutil.copytree(base/'gpui-question-source-set-evidence'/phase,raw/phase)
  for f in ['artifact.json','source.txt','inputs.json','guard-after.json']:
   p=raw/'owned-reference';p.mkdir(exist_ok=True);shutil.copyfile(base/'gpui-question-source-set-evidence/qualified'/f,p/f)
  cfg={'kind':'question','tests':{'first':719,'composed':792},'clippy':['first','allocation-build','composed'],'clippy_failures':[],'negative_message':'changed member must dispatch its dependent: Empty','control_receipt':'control-qualified/artifact.json'}
  origin='6130ca4bb5d982be0505e90fe28a26e8c81874da';negative='local/question-borrowed-negative'
 head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt,text=True).strip();(raw/'change.patch').write_bytes(subprocess.check_output(['git','diff',origin,head,'--','reactivity/crates'],cwd=wt));(raw/'negative.patch').write_bytes(subprocess.check_output(['git','show','--format=fuller',negative,'--','reactivity/crates'],cwd=wt))
 for phase in ['paired']+(['mechanism'] if trial.startswith('question') else []):
  summary=json.loads((raw/phase/'summary.json').read_text());cold={}
  for row in summary['runs']:
   rep,case,n=row['repeat'],row['case'],row['variant'];stem=f'{rep}-{case}-{n}';log=(raw/phase/(stem+'.log')).read_text();ns=int(re.search(r'COLD,wall_ns=(\d+)',log).group(1));rss=int(re.search(r'Maximum resident set size \(kbytes\): (\d+)',(raw/phase/(stem+'.time')).read_text()).group(1));cold.setdefault(case,{}).setdefault(n,[]).append((ns,rss))
  output={case:{n:{label:{'median':statistics.median(v[i] for v in values),'range':[min(v[i] for v in values),max(v[i] for v in values)]} for i,label in enumerate(['cold_wall_ns','max_rss_kib'])} for n,values in variants.items()} for case,variants in cold.items()};(raw/(phase+'-cold-rss.json')).write_text(json.dumps(output,indent=2))
 s=json.loads((raw/'paired/summary.json').read_text());direct='unrelated' if cfg['kind']=='question' else 'exact';primary={};controls={};table=['\n| Static labels | Fields | Mode | CPU candidate/control | Pair range |','|---:|---:|---|---:|---:|']
 for case,v in s['ratios'].items():
  r,n,m=case.split('-');table.append(f"| {int(r)*25} | {n} | {m} | {v['median']:.5f} | {v['range'][0]:.4f}–{v['range'][1]:.4f} |")
  if r=='40' and n in ['2','4'] and m==direct:primary[case]=v['median']<=.8
  if n=='1' or m!=direct:controls[case]=v['median']<=1.05
 verdict={'primary':primary,'controls':controls,'numerical_pass':all(primary.values()) and all(controls.values())};(dest/'verdict.json').write_text(json.dumps(verdict,indent=2));(dest/'configuration.json').write_text(json.dumps(cfg,indent=2))
 (dest/'README.md').write_text(notes[trial]+'\n'.join(table)+f'\n\nBase {origin}; final source {head}. The actual measured commits, commands, compiler flags, feature/dependency fingerprints and immutable ELF hashes are in raw/artifact-pin and raw/paired/metadata.json. Run `python3 reactivity/evidence/{name}/verify.py` to independently reconstruct the verdict.\n')
 shutil.copyfile(base/'gpui-sparse-batch-evidence/verify_dossier.py',dest/'verify.py')
 manifest={str(p.relative_to(dest)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(dest.rglob('*')) if p.is_file() and p.name!='manifest.json'};(dest/'manifest.json').write_text(json.dumps(manifest,indent=2));print(trial,'packaged',len(manifest),'files',flush=True)
