# Live structural identity and dependency trace

The bounded paint campaign stays **NOT ADMITTED**, with single1024=1.103170. Its identical16B work counters do not explain the timing difference. This separate investigation changes no shipping behavior and measures no latency or competitor result. It traces ordinary structural source edits against the existing raw renderer at b2d48370d75482e300befd81d4f0bcbbedd560c7.

## Existing capabilities and the remaining connection

| Requirement | Current capability and limit |
|---|---|
| Contiguous storage | Existing 24B logical Node records in preorder Vec; presentation and Canvas/GPU packets are separate representations. Complete description reconstructs the logical vector. |
| Semantic identity | Existing monotone identities within the window namespace, surviving only the established reconciliation rules. Unkeyed shape changes remint a run; keyed row identity can survive admitted reordering. Not a new registry. |
| Identity lookup | Existing allocation-free arithmetic for a contiguous identity run, compact affine runs or sorted 12B entries otherwise; rebuilt on full description. |
| Subtree extent | Contiguous logical preorder permits a range once its endpoint is known; no retained semantic subtree→Canvas/GPU extent certificate exists. The trace computes ranges diagnostically. |
| Live structural journal | Missing. Current source owner dependency reruns description, reconciliation and index construction; topology changes rebuild layout arena. |
| Dependency closure | Current full layout/paint plus exact command comparison discovers support changes. A subtree range alone omits moved/overlapping siblings. No incremental closure journal implemented here. |
| Resource/publication closure | Existing staging and exact token/namespace authority remain; rectangle trace does not qualify indexed text/image lifetimes or arbitrary queued versions. |
| Integrated deep compression/shared memory | Missing. Existing packed links and identity runs are useful compression, but not a unified compressed display/update/GPU representation. Queue staging is not coherent shared memory. |

## Actual edit path and measured work

The public model uses `Sources::field(KEYS)` and `Win::set(KEYS, Vec<u64>)`. This is the declared owner dependency for ordinary structural reads. Source admission enters `after_admission_changed`, reruns `describe_inner`, reconciles parent/kind/scope/key identity, builds the new Node vector and IdentityIndex, then prepares layout and Canvas. The native render_packet validates the exact acknowledged damage predecessor, invokes the existing full raw preparation for these structural changes, submits, waits, and acknowledges the complete token. Diagnostics run after the update; their full snapshots are not a journal adapter.

Fixed edit: initial rows [1,2,3], insert [1,9,2,3], remove back to [1,2,3], reorder [3,1,2]. Keyed rows have an internal row wrapper plus content node. There are 4/32/256 unrelated right-column children. Source-update allocations include cloning the supplied Vec and the entire public set, including full rebuild work; snapshots, scene diagnostics, GPU submission and oracle readbacks are outside that allocation scope. Actual test-only counters count reconciliation, identity-index input, layout insertion and paint-loop visits, not every internal layout-engine/cache visit.

| Case | Edit | Old→new nodes | Survive / mint / retire | Relocated | Layout insertions | Paint visits | GPU staged B |
|---|---|---:|---:|---:|---:|---:|---:|
| unkeyed-4 | insert | 12→13 | 9 / 4 / 3 | 6 | 13 | 13 | 1336 |
| unkeyed-4 | remove | 13→12 | 9 / 3 / 4 | 6 | 12 | 12 | 1200 |
| unkeyed-4 | move | 12→12 | 12 / 0 / 0 | 0 | 0 | 12 | 1200 |
| unkeyed-32 | insert | 40→41 | 37 / 4 / 3 | 34 | 41 | 41 | 4404 |
| unkeyed-32 | remove | 41→40 | 37 / 3 / 4 | 34 | 40 | 40 | 4276 |
| unkeyed-32 | move | 40→40 | 40 / 0 / 0 | 0 | 0 | 40 | 4276 |
| unkeyed-256 | insert | 264→265 | 261 / 4 / 3 | 258 | 265 | 265 | 8016 |
| unkeyed-256 | remove | 265→264 | 261 / 3 / 4 | 258 | 264 | 264 | 7888 |
| unkeyed-256 | move | 264→264 | 264 / 0 / 0 | 0 | 0 | 264 | 7888 |
| keyed-4 | insert | 15→17 | 15 / 2 / 0 | 10 | 17 | 17 | 1312 |
| keyed-4 | remove | 17→15 | 15 / 0 / 2 | 10 | 15 | 15 | 1184 |
| keyed-4 | move | 15→15 | 15 / 0 / 0 | 6 | 15 | 15 | 1184 |
| keyed-32 | insert | 43→45 | 43 / 2 / 0 | 38 | 45 | 45 | 4380 |
| keyed-32 | remove | 45→43 | 43 / 0 / 2 | 38 | 43 | 43 | 4260 |
| keyed-32 | move | 43→43 | 43 / 0 / 0 | 6 | 43 | 43 | 4260 |
| keyed-256 | insert | 267→269 | 267 / 2 / 0 | 262 | 269 | 269 | 7992 |
| keyed-256 | remove | 269→267 | 267 / 0 / 2 | 262 | 267 | 267 | 7872 |
| keyed-256 | move | 267→267 | 267 / 0 / 0 | 6 | 267 | 267 | 7872 |

At unkeyed256 insertion, 261 identities survive, 4 are minted and 3 retire; 258 survivors relocate. The logical Node payload is reconstructed across 6,360B, with 265 index inputs/layout insertions/paint visits. The public set allocates 479,101B across 129 allocations (peak delta 182,344B; retained delta 17,057B). At keyed256 insertion, all 267 old identities survive, 2 new nodes appear and 262 survivors relocate; the reconstructed Node payload is 6,456B. The public set allocates 498,337B across 171 allocations (peak delta 183,344B; retained delta 17,834B). These are actual full-path costs, not proposed incremental costs. Both indices retain 48B of affine-run heap after insertion.

Keyed256 reorder moves six existing logical records and remints none, yet reconstructs 267 layout nodes. Unkeyed reorder keeps positional identities and changes values at those positions; it is not semantic movement of application item keys. It performs no layout insertion but still describes/reconciles/paints 264 nodes.

CPU logical work grows with unrelated content. GPU work does not necessarily track logical count: clipping suppresses most of the 256 right-column children. Both insertion cases validate 71 draws and retain 6,816B logical raw draw records; bin visits are 498 unkeyed / 486 keyed, with 8,016B/7,992B staged. Do not label GPU cost O(N logical nodes) from this fixture. All other work, allocations and known capacities are in raw/bound-failure/summary.json and trace/trace.json.

## Subtree extent is not dependency closure

The group begins at logical rank 2. Unkeyed insertion extends [2,6)→[2,7); keyed insertion extends [2,9)→[2,11). The following blue sibling retains identity but moves from approximately y20 to y28, outside the edited group. Its x8..32 extent overlaps the group x0..24. Full old/new damage reaches [0,7,33,37] unkeyed and[0,8,33,37] keyed.

A separate actual RetainedRenderer first renders the old scene, then consumes the new scene with deliberately restricted group-only damage [0,0,25,33]. All six insertion mutants yield **326 wrong pixel bytes** against the independent full result. The native/full path remains exact. This witnesses both nonlocal layout support and overlapping painter contributors; direct subtree addressing cannot authorize dropping them.

## Smallest next representation experiment

The next hypothesis is an ordered correspondence-run journal emitted during the existing live reconciliation loop, coupled to index-relative parent displacements for cold topology. Reuse existing semantic identities and their index; do not invent another identity namespace or per-object registry. A correspondence run says where identities came from, not that their style/layout/paint/resource bytes are unchanged. Exact predecessor, namespace and unchanged interpretation remain publication invariants.

A diagnostic executable probe on these actual traces motivates this choice:

| Insert case | Changed identity/kind/absolute-parent records | Changed relative-parent records | Ordered correspondence runs | Diagnostic old+new nodes read |
|---|---:|---:|---:|---:|
| unkeyed-4 | 8 | 6 | 3 | 25 |
| unkeyed-32 | 36 | 6 | 3 | 81 |
| unkeyed-256 | 260 | 6 | 3 | 529 |
| keyed-4 | 8 | 6 | 3 | 32 |
| keyed-32 | 36 | 6 | 3 | 88 |
| keyed-256 | 260 | 6 | 3 | 536 |

The original absolute parent ranks force changes throughout the shifted right subtree, although its semantic parents are unchanged. Relative displacements preserve internal links under whole-subtree relocation; the moved boundary still needs correction. In this probe, insertion changes six topology tuples across all sizes instead of 8/36/260, with three correspondence runs. This is exact identity/kind/parent replay only: it excludes ordinal/content/scope fields, layout, painter records and resources, and it explicitly reads the whole diagnostic input. It is neither a full lossless Node codec nor a production locality result.

The bounded next experiment should emit that correspondence inside reconciliation (no offline snapshot reconstruction), encode all required cold Node fields losslessly, compare absolute versus relative parents with the same raw tiny fallback, and charge run/directory bytes, structural boundary corrections, literal payloads and decode scratch. Preserve exact unkeyed reminting, keyed move/removal, multiple parent/order edits and adversarial fragmented runs. Test direct lookup separately from affected-extent enumeration. Keep description/reconciliation/layout costs visible until they are actually replaced. The unresolved choice is whether preserving ordered runs and relative links reduces total retained/rewrite cost enough to justify directory/decode machinery; current results do not answer it.

Only after that boundary is executable should a node-to-Canvas emission extent be carried to raw/retained GPU publication, with old/new support and resource leases. Layout currently assumes newly inserted arena IDs are sorted for measure routing; preserving layout nodes requires representing that mapping correctly, not silently retaining the assumption or introducing an uncharged inverse registry. No partial layout or compressed GPU renderer is adopted by this trace.

## Resources, authority and research transfer

Image declarations currently deduplicate exact ImageKey values in runtime/image.rs, rebuild the distinct logical resource vector and clone one immutable lease per distinct resource. Text presentation retains one face lease while the shaper/cache stays exclusively borrowed. CanvasScene stages a complete pending command sheet; commit_with_damage compares old/new contributions before replacing the old commands, and uncommitted staging preserves the predecessor. The renderer separately scans image/gradient tables and validates resource keys; submitted bind groups retain old buffer leases. These code paths must be represented in future resource closure, not inferred from rectangle cases without text/image payloads. This trace has zero image/mask/gradient payload entries, but does retain clip resources: one clip node for the unkeyed fixture, five for the three-row keyed fixture and six after insertion. Resource headers are128B; clip-node capacity is included in the reported scene lane bytes. Indexed text/image and overlapping resource-version safety remain open.

Every successful edit rejects acknowledgement of the prior token after the new candidate exists. A non-poisoning failed newer bound transform preserves the last complete scene/token in all six cases. This checks existing authority only, not arbitrary deferred/in-flight publication. The initial direct-source fixture and literal-NaN fixture failures are preserved: direct explicitly excludes structural reads; an invalid literal panics/poisons and cannot be used as an eligible-old-candidate test. Neither failure changed runtime semantics.

BBTree transfer: pinned reference 1b0201087102f81189da0c4cd5054a91c8d97d62, design/12-batch-api.md. Its batch plans retain locations only while ordered structural mutations preserve them, and invalidate affected plans on splits. That supports exact transition provenance, not an assumption of stable positional addresses. Its async lanes overlap independent dependent-load chains; they do not remove GPUI full description/layout work. Solid/Ripple stale-candidate/coherent-old-state ideas remain relevant to publication, but do not supply structural/resource closure by themselves.

## Validation and scope

Final measured-source commit 934c370c3da53cf78ba1d2cee667e2c3fdfebeb0. 30 exact four-way pixel comparisons, six actual GPU mutants, 18 stale acknowledgements rejected, six failed-newer candidates preserving prior pixels/token. Strict all-target Clippy, clean before/after source guards, fresh executed ELF and embedded generated shader identity pass. Test-only Work is 64B in the test runtime; no shipping API/representation changes. Conservative repository source inventory 38,047 lines versus 38,044 baseline includes three conditional instrumentation initialization lines; do not present that inventory as an expanded shipping-code diff. No timing, ZGX, coherent-shared-memory, deep-compression or constant-update claim. All work stays local.

Run `python3 reactivity/evidence/structural-journal-trace/verify.py` to verify the sealed evidence, pixel/mutant checks and exact topology probe. The raw directory preserves both rejected attempts, final source/toolchain/ELF/shader guards, allocation/work observations, diagnostic scripts and verified duplicate-capture/cache reclamation receipts. Canonical binaries remain in the content-addressed external store.

Evidence correction: provisional documentation commit bf7d9e7d838568c8afb4bdba432f002a35572796 was created after the first verifier failed because the shell sequence lacked fail-fast behavior. That verifier incorrectly equated resource_entries with image/mask/gradient entries and omitted clip nodes. The rejected verifier and error explanation are preserved. Correcting this accounting requires no runtime edit or test rerun; the final seal is conditional on the corrected verifier passing.
