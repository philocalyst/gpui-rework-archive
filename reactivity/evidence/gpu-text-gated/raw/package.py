from pathlib import Path
import shutil,subprocess,json,hashlib,statistics
ext=Path(__file__).resolve().parent;wt=Path('/home/user/gpui-gpu-text-gated-lab');dest=wt/'reactivity/evidence/gpu-text-gated';raw=dest/'raw';assert not raw.exists();shutil.copytree(ext,raw);shutil.copyfile(ext/'verify_dossier.py',dest/'verify.py');(raw/'shader').mkdir()
for phase in ['control','ungated-control','candidate']:
 for x in json.loads((raw/phase/'shader-identities.json').read_text()):
  data=Path(x['path']).read_bytes();assert hashlib.sha256(data).hexdigest()==x['sha256'];(raw/'shader'/x['sha256']).write_bytes(data)
head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt,text=True).strip();assert head=='a3ac8c5b3475b347e264929f749b71bf81b4cf5f'
(raw/'change.patch').write_bytes(subprocess.check_output(['git','diff','3dd29a0ebdea85ed7b4076ab51069865293e8737',head,'--','reactivity/crates'],cwd=wt));(raw/'negative.patch').write_bytes(subprocess.check_output(['git','show','--format=fuller','9032bc6e89f4fb8d4341670591371cc63a5fb952','--','reactivity/crates'],cwd=wt))
sums={p:json.loads((raw/p/'summary.json').read_text()) for p in ['paired','mechanism']};ratios=sums['paired']['ratios'];mechanism=sums['mechanism']['ratios'];primary={k:v['median']<=.8 for k,v in ratios.items() if k in ['1000-1-stream','1000-2-exact','1000-4-exact']};controls={k:v['median']<=1.05 for k,v in ratios.items() if k.endswith('full') or k.split('-')[1]=='1' and k.endswith('exact')};mg={k:v['median']<=(1.05 if k.endswith('stream') else 1.0) for k,v in mechanism.items() if k.endswith('stream') or k in ['0-1-exact','25-1-exact']};verdict={'primary':primary,'controls':controls,'mechanism':mg,'numerical_pass':all(primary.values()) and all(controls.values()) and all(mg.values())};(dest/'verdict.json').write_text(json.dumps(verdict,indent=2))
aggregates={}
for phase,s in sums.items():
 aggregates[phase]={}
 for case in s['ratios']:
  aggregates[phase][case]={}
  for n in ['control','candidate']:
   recs=[r for r in s['runs'] if r['case']==case and r['variant']==n];aggregates[phase][case][n]={k:{'median':statistics.median(x[k] for x in recs),'range':[min(x[k] for x in recs),max(x[k] for x in recs)]} for k in ['cold_wall_ns','max_rss_kib']}
(raw/'cold-rss-summary.json').write_text(json.dumps(aggregates,indent=2))
a=json.loads((raw/'allocations/summary.json').read_text());repairs={r['case']:{k:{'median':statistics.median(x[k] for x in r['repairs']),'range':[min(x[k] for x in r['repairs']),max(x[k] for x in r['repairs'])]} for k in ['damage_pixels','composited_pixels','copied_pixels']} for r in a['runs'] if r['repairs']};(raw/'repair-summary.json').write_text(json.dumps(repairs,indent=2))
notes='''# Size-gated outlined tile refinement — rejected mechanism qualification

The main full-preparation comparison passes every fixed primary/control median:
1000-label two/four fields .602142/.681601; stream0/25/1000 .218615/.212364/.203996
(about4.6–4.9x faster). All short one-field and full-rebuild control medians are
within1.05. This does not complete the trial: the separately preregistered
ungated-baseline comparison fails25-label single exact1.081491 (limit1.0),
25-label stream1.069717 and1000-label stream1.063233 (limit1.05).
Keep the overall failed verdict. Do not change4096, drop runs, attribute these
failures to noise without evidence, or claim general adoption/ZGX superiority.

The gate admits dirty-tile refinement only for Some nonempty bounding damage
with area>=4096 pixels (sixteen16x16 tiles). Below that, use the existing
packet-only submit. The comparison is a separate outlined read-only pass after
CSR reconstruction; common-word changes are computed there, using a four-entry
stack array under the unchanged1..4-edits admission bound. For each tile, compare
old/new ordered references and every referenced changed glyph/common word.
A changed common marks its entire run. Equal compact words alone do not establish
equal membership. Old and new references both matter; unchanged uniform-solid
tiles skip directly. Disjoint dirty row spans intersect caller-certified damage;
more than256 spans falls back to the original bounding damage. None remains full
repaint, empty damage copies only. All validation precedes queue writes.

The threshold is a work-amortization choice, not a correctness certificate.
The ordinary bounding-damage path remains valid whenever refinement is skipped.
The same shader, sample arithmetic, painter order, opaque cutoffs, atlas leases,
scene tokens, atomic late rejection and older-ACK authority remain. No new API,
dependency, header, unsafe or task executor. Complete CSR reconstruction still
runs; an additional pass runs for large damage. This is not O(changed) overall
and no hardware-cache behavior was measured.

Correctness:79 GPU tests/doctests and strict Clippy,975 default GPUI+Canvas,
1048 X11-composed tests/doctests and strict Clippy, six actual private-X11
scripts. Exact public tests include4095/4096 area selection, unchanged records,
one changed glyph, movement across old/new tiles and opaque overlaps, fractional
and near-edge geometry, SDR/HDR, empty/full/clipped damage, span-limit fallback,
and identical shader words with distinct conservative memberships. Every image
matches an independent full render. The fresh omitted-old-membership mutant
9032bc6e89 fails the moved-glyph image test. All source guards and test gates
passed on the first frozen candidatea3ac8c5b34; no production/test edits occurred
between build, native qualification, allocator build, timing and probes.

Measurement:21 primary cells,five alternating pairs,210 fresh processes,10
warmups and60 measured updates per process (12600 measured). Separate mechanism
trial:seven cells,three alternating pairs,42 processes (2520 updates). Same
960x720 fixture, shared ZGX735-character payload, DejaVu font, compiler/features,
affinity2–5 and llvmpipe4. Canonical scene/delta construction plus GPU preparation,
submission and queue completion are timed; shaping is outside. host_ns is wall
time through submit, not thread CPU time. Full source/immutable ELF guards,
initial/final exact fresh and cross-variant images, final scene receipts and
shader identities pass. No owned compilers/tests/probes/source edits during
both timing phases. Preserve all p50/p95/p99 samples and pair ranges below;
there is substantial variability. Cold object/adapter creation and whole-process
RSS include the independent image oracle; they are not cold OS-cache startup.

The mechanism medians are .960722 for0-label single,1.081491 for25-label single,
1.007742 for25-label two and .987756 for1000-label four. Stream medians are
1.004244/1.069717/1.063233. Thus the isolated comparison does not establish that
this refactor preserves the ungated speed, despite the main baseline gates
passing. Its new pass changes code layout and memory access order, but this
trial does not identify the cause of each timing difference.

42 separate allocation probes each take60 warm samples and verify exact fresh
GPU images. Caller-thread Rust allocations only; foreign driver/worker costs
are excluded. Small updates return to packet-only allocation counts/bytes:
0-label single85/34359 versus ungated87/34871;1000-label two97/80185 versus100/81593;
four118/84317 versus123/87645. Full baseline two/four were122/17225 and132/19329.
Stream remains115/209739, same as ungated, versus full131/50121. More transient
bytes remains a charged loss. All candidate sparse retained deltas are zero;
full paths in both variants retain queue-allocation cycles (e.g.[-912,304] B).
All nine full controls match warm allocator distributions apart from separately
reported text-map capacity. The original extra24-B RetainedRenderer header,
16-KiB1000-label map and16-B native TextResources field remain; this refactor
adds no retained fields or persistent buffers.

Actual compositing counters confirm the policy. Single/two/four canonical
regions416/1456/3536 pixels are now composited in full. Stream median66627 becomes
9808 pixels, as in the ungated trial. Every submission still copies691200 pixels.
These diagnostics are separate from performance and cannot explain all latency
variation. Threshold correctness is covered, but performance of arbitrary dense
long-text changes and all intermediate damage shapes is not established.

Code:37485 shipping lines (+24 over ungated); ELF14735568 B (+2376), SHA256
5fb76301dbb70f7caf1f04fcd134e2cf425310a9a70d71784f55fa984d9164e6.
Patch body8637 B versus8898, local stack reservation888 B unchanged. New
repair_regions1778 B/local reservation216 B; wrapper455/104 and
submit_regions801/1368 remain. Outlining is not a total-code or total-stack
reduction. Prologue reservations exclude pushed registers/callees/driver stacks.
Full symbols and targeted assembly are retained. Generated WGSL is unchanged,
SHA256 ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1,
verified embedded in the actual timed ELFs. Dependencies remain unchanged;
allocation-counter0.8.1 is diagnostic-only.

Base3dd29a0ebdea85ed7b4076ab51069865293e8737; protocol
cca90b4f89323413bd9bfe0608b80db45391d5aa; all candidate gates/measurements
and allocation sourcea3ac8c5b3475b347e264929f749b71bf81b4cf5f.
Full control64523d173a and ungated controlef71ae3001 use immutable earlier
executables with explicitly inherited build/test receipts and fresh timings.
The current evidence is independently reconstructed by
`python3 reactivity/evidence/gpu-text-gated/verify.py`.
Completed older test ELFs were losslessly archived with hashes/recovery paths;
measured example ELFs remain at their original paths. Compiler-cache cleanup
receipts preserve tracked sources and evidence. No timing overlapped cleanup.

The AMD9950X KVM guest has no physical render node; Vulkan is llvmpipe and X11
is private. No scanout or physical-GPU result follows. Equivalent native ports,
matched distribution profiles and two hardware classes remain mandatory. All
work is local and unadopted. Next work should address native workload parity,
including its currently coarse inbox publication, rather than retrospectively
retuning this fixed threshold to pass the same matrix.
'''
for phase,title in [('paired','Full-preparation baseline'),('mechanism','Ungated tile baseline')]:
 notes+='\n## '+title+'\n\n| Labels | Fields | Mode | Paired completion ratio | Pair range |\n|---:|---:|---|---:|---:|\n'
 for case,v in sums[phase]['ratios'].items():
  labels,fields,mode=case.split('-');notes+=f"| {labels} | {fields} | {mode} | {v['median']:.6f} | {v['range'][0]:.4f}–{v['range'][1]:.4f} |\n"
(dest/'README.md').write_text(notes)
manifest={str(p.relative_to(dest)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(dest.rglob('*')) if p.is_file() and p.name!='manifest.json'};(dest/'manifest.json').write_text(json.dumps(manifest,indent=2));print('packaged',len(manifest),'files',verdict)
