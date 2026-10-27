from pathlib import Path
import shutil,subprocess,json,re,statistics,hashlib
base=Path('/home/user');ext=base/'gpui-sparse-outline-evidence';wt=base/'gpui-sparse-outline-lab';dest=wt/'reactivity/evidence/sparse-text-outline';raw=dest/'raw';assert not raw.exists()
for phase in ['full','composed']:
 assert json.loads((ext/phase/'guard-after.json').read_text())==[]
for phase in ['paired','mechanism','allocations']:
 assert not any(json.loads((ext/phase/'guard-after.json').read_text()).values())
assert json.loads((ext/'composed/guard-after-native.json').read_text())==[]
shutil.copytree(ext,raw)
shutil.copytree(base/'gpui-source-batch-evidence/artifact-pin',raw/'control-pin')
shutil.copytree(base/'gpui-sparse-batch-evidence/artifact-pin',raw/'inline-pin')
shutil.copytree(base/'gpui-sparse-batch-evidence/negative',raw/'negative')
(raw/'negative/INHERITED.json').write_text(json.dumps({'fresh_run':False,'source_dossier':'2d55c3dff194443742736f8171422dc11b59ed48','reason':'Annotation-only change; unchanged transactional certificate. This is the inherited sequential partial-commit counterexample, not a new execution.'},indent=2))
head=subprocess.check_output(['git','rev-parse','HEAD'],cwd=wt,text=True).strip();origin='2d55c3dff194443742736f8171422dc11b59ed48'
(raw/'change.patch').write_bytes(subprocess.check_output(['git','diff',origin,head,'--','reactivity/crates'],cwd=wt))
(raw/'negative.patch').write_bytes(subprocess.check_output(['git','show','--format=fuller','local/sparse-batch-negative','--','reactivity/crates'],cwd=wt))
for phase in ['paired','mechanism']:
 summary=json.loads((raw/phase/'summary.json').read_text());cold={}
 for row in summary['runs']:
  rep,case,n=row['repeat'],row['case'],row['variant'];stem=f'{rep}-{case}-{n}';log=(raw/phase/(stem+'.log')).read_text();ns=int(re.search(r'COLD,wall_ns=(\d+)',log).group(1));rss=int(re.search(r'Maximum resident set size \(kbytes\): (\d+)',(raw/phase/(stem+'.time')).read_text()).group(1));cold.setdefault(case,{}).setdefault(n,[]).append((ns,rss))
 output={case:{n:{label:{'median':statistics.median(v[i] for v in values),'range':[min(v[i] for v in values),max(v[i] for v in values)]} for i,label in enumerate(['cold_wall_ns','max_rss_kib'])} for n,values in variants.items()} for case,variants in cold.items()};(raw/(phase+'-cold-rss.json')).write_text(json.dumps(output,indent=2))
cfg={'kind':'sparse','tests':{'full':975,'composed':1048},'clippy':['full','composed'],'clippy_failures':[],'candidate_receipt':'full/cost-artifact.json','control_receipt':'control-pin/cost-artifact.json','negative_message':'later admission failure must roll back the entire batch','negative_inherited_from':origin,'mechanism_cases':[[1,2,'owner'],[40,1,'exact'],[40,2,'exact'],[40,4,'exact']]}
summary=json.loads((raw/'paired/summary.json').read_text());primary={};controls={}
for case,v in summary['ratios'].items():
 r,n,m=case.split('-')
 if r=='40' and n in ['2','4'] and m=='exact':primary[case]=v['median']<=.8
 if n=='1' or m!='exact':controls[case]=v['median']<=1.05
verdict={'primary':primary,'controls':controls,'numerical_pass':all(primary.values()) and all(controls.values())}
notes='''# Outlined sparse text-batch preparation

One production annotation, `#[inline(never)]` on `try_sparse_text_batch`, separates
batch preparation from the existing one-field routine. All transaction eligibility,
layout, resource lifetime, ordered commit and acknowledgement semantics remain as
in the rejected atomic batch base. No new API, storage, unsafe or scheduling.
The original failure remains recorded; this is a separately preregistered trial.

Default GPUI+Canvas tests/doctests (975), X11 composition (1048), strict Clippy
and six actual X11 scripts pass. The sequential partial-commit mutant receipt is
inherited from the base, explicitly not a fresh execution: this annotation adds
no semantic certificate. The base public tests still compare exact fresh pixels,
interaction geometry, failed newer candidates and older eligible acknowledgements.

Build-only default+simd executable identities were captured immediately, before
Cargo tests could replace convenience aliases. Measurements use stable build/out
paths. Full source/dependency guards and executable hashes pass. Five alternating
pairs per 21 cells, CPU2, 200 warmups and 40x100 complete enqueue/deliver/record/ACK
operations: 210 fresh processes, 840000 operations. Exact final pixels/epochs and
owner counters match in all processes. Separate three-pair mechanism comparison
against the inline batch uses four preregistered cells (24 processes, 96000 ops).
No compilers, tests, allocator probes or source edits ran alongside these timings.

The linked single-run routine is 2133 B, stack reservation 312 B; the inline base
was 5337/584 B and original source-batch control 2078/344 B. The separate batch
routine is 3181 B with 520 B stack reservation. These are local prologue numbers,
not total call-stack bounds. Final measured ELF is 10246136 B, +208 B over inline
and +47576 B over source-batch control. Inventory is 36942 shipping lines, +1 over
inline. Full symbol tables, targeted assembly and compiler receipts are retained.
This establishes code layout, not a hardware-cache explanation for timing changes.

Forty-two independent allocation probes retain zero warm bytes in all cells.
One-field/coarse requests and bytes match control. At 1000 static labels, exact
2-field requests/bytes are 63/5688 vs control 84/341828; 4-field 114/10628 vs
120/343672. One-field remains 33/2602. Window wrapper sizes remain 296 B typed,
256 B opaque; the base's TextResources/patch-owner growth remains fully charged.

Cold owner creation, whole-process max RSS including the independent pixel oracle,
and CPU/wall p50/p95/p99 are retained separately. The shared AMD9950X KVM host
has noise, unavailable performance counters and software Vulkan without a render
node. Native GPU text still rebuilds the full packet. No ZGX, scanout or physical
hardware victory, and no automatic adoption follows from this CPU qualification.
'''
notes+='\nFixed numerical gates: '+('pass' if verdict['numerical_pass'] else 'fail')+'. Failed controls: '+(', '.join(k for k,v in controls.items() if not v) or 'none')+'.\n'
for phase,title in [('paired','Original source-batch comparison'),('mechanism','Separate comparison against inline batch')]:
 s=json.loads((raw/phase/'summary.json').read_text());notes+='\n'+title+'\n\n| Static labels | Fields | Mode | CPU candidate/control | Pair range |\n|---:|---:|---|---:|---:|\n'
 for case,v in s['ratios'].items():
  r,n,m=case.split('-');notes+=f"| {int(r)*25} | {n} | {m} | {v['median']:.5f} | {v['range'][0]:.4f}–{v['range'][1]:.4f} |\n"
notes+=f'\nBase {origin}; measured source {head}. Run `python3 reactivity/evidence/sparse-text-outline/verify.py` to reconstruct all results and the fixed verdict.\n'
(dest/'README.md').write_text(notes);(dest/'configuration.json').write_text(json.dumps(cfg,indent=2));(dest/'verdict.json').write_text(json.dumps(verdict,indent=2));shutil.copyfile(ext/'verify_dossier.py',dest/'verify.py')
manifest={str(p.relative_to(dest)):hashlib.sha256(p.read_bytes()).hexdigest() for p in sorted(dest.rglob('*')) if p.is_file() and p.name!='manifest.json'};(dest/'manifest.json').write_text(json.dumps(manifest,indent=2));print('packaged',len(manifest),'files',verdict)
