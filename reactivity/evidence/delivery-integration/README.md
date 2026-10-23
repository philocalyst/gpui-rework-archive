# Composed delivery kernel: frozen, unadopted e31 control

Production source: `e31ffdbc15c8e786e822715c7c0d00d95629f97c`; base `d86ca9895dceebeafd8d527cd1d5b7810ea6d2f5`. No main adoption is authorized by these results.

**Blocking authority defect discovered independently after qualification:** Root's public `source_alias_contract.rs` overlay `cb83d485451e2cbd69da95b68f58409a4dee5abf` over this exact source registers two `Signal<Arc<AtomicU64>>` values sharing their pointee. A typed A edit changes canonical B but leaves B's Question ready with the prior capture; identical coarse mutation refreshes it. The genuine-nightly run has one typed failure and one coarse pass. The original source, executable and raw result are in `/tmp/gpui-source-alias-root-evidence/initial`. SourceValue here excludes nested Signal but admits shared interior mutation. Existing passing tests do not establish authority for that case. Root owns a separate stronger-admission successor; none of this dossier qualifies that successor.

## Actual implementation boundary

The composite includes the reviewed nested SourcePath-aware `with_inbox_for` binding and single-buffer bounded transport. Ordinary `with_inbox` retains its closure inference. Registered/scoped field validation precedes mutation; same-field accepted prefixes retain exact source authority, mixed/ordinary lanes become coarse. Accepted prefix refresh precedes a later binding failure; rejected-before-callback input does not revoke editing/focus. Sealed `FIELD_EDITS` makes impossible exact identities statically absent in ordinary lanes, including nested Question wrappers.

One `VecDeque<T>` is shared through `Arc<Mutex<State<T>>>`. The unique Inbox owns a frozen prefix count, not a second payload buffer. Capacity now means all accepted-undelivered payloads, including frozen leftovers; old accidental allowance up to 2C is intentionally removed. Logical capacity bounds ZSTs; C=0 rejects. Checked rejection consumes only its failing item; continuation preserves FIFO. Callback-generated sends remain deferred. Explicit producer count handles concurrent final drops. Revocation detaches payload ownership after closing all nested lanes and Question gates before any user destructor may unwind.

This is a locking control: successful send/stage/pop takes three mutex acquisitions end to end, two on the owner side plus probes. Clone/drop locks and performs Arc ownership RMWs. A preempted mutex holder can delay a peer. No lock-free, latency, RSS or timing claim. Inbox becomes Sync for Send payloads but exposes no shared receive API. There are no new dependencies or unsafe blocks.

## Compiler and source provenance

Official pinned nightly2026-10-23: rustc1.101.0-nightly7189d39d9 / LLVM23.1.4. `/tmp/gpui-native-env.sh` then `/tmp/gpui-nightly-env.sh`; bootstrap and generic Rust flag overrides unset. Actual root config remains present; Linux v0/tokio_unstable and Windows target flags are recorded by commands/fingerprints. Root's official archive and Nix ELF adaptation dossier verifies unchanged compiler `.text`. The auto_traits/negative_impls/trait_alias prerequisite requires nightly; no stable qualification is claimed for GPUI. The lower-level Atomic try_update rename is stable since1.95, separately verified upstream by Root.

Each guarded functional invocation records clean HEAD, 1148 in-tree input hashes before/after, actual command/environment/compiler and exit. Separate no-run/build and execution gates avoid hiding compile timeouts in test results. Registry dependencies remain lock-pinned; release cost captures additionally preserve actual Cargo fingerprints. Every preserved completed guard matches. No source was edited during a labelled gate.

Compatibility changes are independently charged: nine fetch_update→try_update API renames; 45 constant chunk walks become typed array chunks with the same discarded remainder; array references compare explicitly; test polling uses a local pinned future. Native WGPU Send proof needs native-only recursion_limit256 under this compiler; no lint suppression or manual Send. The shared shader Boolean return is simplified without changing floating expression order, but generated WGSL is **not byte-identical**:15180→15139B. Both generated sources, diff, actual offline artifacts and readbacks are recorded.

## Functional results on exact e31

| Gate | Result |
|---|---:|
| GPUI default |577 passed,10 ignored,62 harnesses|
| GPUI native X11 |642 passed,35 ignored,62 harnesses|
| SourceValue downstream contracts |9 expected type failures +1 positive|
| strict all-targets default +native X11 |both pass|
| AppleARM64/MSVC library source checks |both pass, installed official std|
| Representative Hummingbird default |50 passed,14 harnesses|
| Canvas +default Vulkan GPU |240 passed,3 ignored,30 harnesses;46 Vulkan render|
| Offline GPU |10 library +4 presentation +47 Vulkan|
| Actual native transport |3 entrypoints,8 internal cohorts, unchanged watchdogs|
| Actual Registry failed-new-L/old-P/repair |pass, normal owned service cleanup|
| Rustfmt changed49 Rust files |pass|

Native transport checks exercise exact field patches without owner description, bounded wake continuation, prebound/saturated/quiescent final-producer status. The actual Registry action proves a failed new logical description preserves the old acknowledged provider and a public action repairs it. These gates remain distinct from the independently failing shared mutable alias case.

Preserved first failures: d86 original modern Clippy chunks lint (Root archive), two array-reference compile mismatches, GPU needless_bool lint, native Send proof-depth/CPU cfg Boolean lint, test unnecessary_box_pin lint. Each has its actual source pin and unchanged guard in the gate summary. Fixes were frozen under new source commits, never retagged.

## Whole-source bill

Actual Tokei15 +syn inventory core counter: main602a=30,987; compatibility-only75de7f=30,984; e31=31,228. Thus **+241 core lines vs main /+244 vs compiler-compatible control**, excluding comments/tests. This is an ownership/behavior experiment, not a source-line reduction. Existing boxed Source schemas are unchanged; no per-field or per-row memory saving is claimed. SourceSchema6788, triomphe substitution and atomic/borrowed transport research are not included.

## Matched cost control

All three controls use `/tmp/gpui-delivery-cost-sol`, the same genuine compiler/config/flags/lock/release profile and dependency fingerprints. Compatibility source75de7f plus corrected common fixtures is22cd93e21d; e31 kernel with byte-identical fixtures isb886ed5c3c; typed-only fixture successor is64443ce307. `matching-proof.json` checks exact equality. GPUI was cleaned with explicit `--release` before A and B; actual library and examples are `fresh:false`. C reuses the same library (`fresh:true`) and rebuilds its changed field example (`fresh:false`). First observer typo E0614 is preserved under2fcca1 before the common fixture correction; it changed no production source.

These are **default-feature/headless linked controls**, not native release stack/latency measurements. Native functional/cross results above have their own exact artifacts. Baseline, composite-coarse and composite-typed executables are frozen externally with byte hashes; all disassemblies, symbols, selected callers/callees, fingerprints and ledgers are retained. The nonshipping observer wrappers use identical no-inline boundaries for measurement; production gained no inline annotations.

| Common ordinary boundary | Compatibility A | Composite B |
|---|---:|---:|
| Remote /Inbox inline bytes |16 /56|8 /24|
| Bound Win /empty Win inline bytes |80 /8|48 /8|
| Plain owner constructor requested /retained /peak B |6792 /5564 /5732|6792 /5564 /5732|
| Plain update allocations /requested /peak B |10 /940 /832|10 /940 /832|
| C8 bound owner allocations /requested /retained /peak B |36 /7624 /6396 /6564|35 /6936 /5708 /5876|
| C8 delivery allocations /requested /peak B |10 /940 /832|10 /940 /832|
| Whole linked .text B |3,675,847|3,670,007|
| Whole linked .rodata B |6,511,552|6,511,304|
| Whole linked .data.rel.ro B |153,376|153,232|

C8 bound-owner heap reduces688B with one fewer allocation; its inline Win reduces32B and separately held Remote reduces8B. These are separately accounted, not double-counted as heap savings. C0 cold transport has one allocation136→80B; C1 has3→2 allocations664→88B; C8 has3→2 allocations832→144B; C64 has3→2 allocations2176→592B. Send/clone/idle produce zero allocations in both controls. The queue payload buffer is released earlier by explicit close in B; old A can retain standard channel/storage with the surviving sender. No RSS or total process memory claim.

| Function boundary | Code A→B B | Own static stack A→B B |
|---|---:|---:|
| Win.update ordinary specialization |748→748|168→168|
| Ordinary observer update wrapper |108→108|120→120|
| Win.deliver_ready u64/function-pointer |2993→2919|456→520 (**+64**)|
| Delivery observer wrapper |216→197|264→264|
| Remote.bounded |265→300|104→40|
| Clone/drop observer wrapper |81→77|24→24|
| Send observer wrapper |60→15|8→8|
| Lane.stage |184→238|40→40|
| Lane.close |89→554|24→56|

The ordinary delivery frame regression is real and charged. B's Lane.apply is now a separate1032B/frame120 function; A's simple apply is folded into its caller and invokes standard receiver helpers. B's Remote.try_send is373B/frame56; Clone245B/frame40; Drop173B/frame40. The smaller send/clone wrappers do not imply smaller end-to-end work: mutex acquisition/release and Arc operations remain in callees. A retains array/list/zero standard-channel send/receive helpers; their full code and frames are included. Bounded branch/locking/retirement work is not inferred faster from text deletion. Stack reports exclude return addresses and callees; do not sum this table as a measured aggregate peak.

| Actual component-affine consumer | A coarse | B coarse | C typed |
|---|---:|---:|---:|
| Remote +bound Win inline B |88|48|56|
| Constructor allocations /requested /retained /peak B |58 /9719 /7891 /8051|57 /8903 /7075 /7235|57 /8903 /7075 /7235|
| Per8 edits allocations /requested /peak B |28 /2260 /1596|28 /2260 /1596|3 /136 /136|
| Per8 edits owner descriptions |1|1|0|
| Per8 edits layout /measure /copied text |0 /0 /0|0 /0 /0|0 /0 /0|
| Whole linked .text B |3,697,959|3,691,383|3,702,711|
| Whole linked .rodata B |6,512,512|6,512,216|6,512,800|
| Whole linked .data.rel.ro B |154,760|154,640|155,192|
| deliver_ready code /own frame B |2933 /424|2919 /520|10213 /1416|
| Observer deliver code /own frame B |305 /280|305 /280|282 /280|
| Bind code /own frame B |269 /152|217 /136|224 /136|

All three8-edit batches send without allocation and end with identical canonical Source/property transforms. Typed delivery avoids root view/descriptions, preserving exact leaf work, but retains an8B static path in Win and links11,328 more text bytes than composite coarse (4,752 more than compatibility coarse). Its specialized delivery frame grows896B versus B coarse. Existing dynamic Source schema routing and specialized owner admission remain significant code/stack costs; no schema-box removal or broad animation/row optimization is claimed. These are deterministic work and allocation facts, **not a speed result**, and the alias admission blocker prevents recommending this source as a correct general exact-edit kernel.

## Reproduction and artifact scope

`gate.py` preserves labelled functional commands and input guards; `cost_gate.py`, `capture_cost.py`, `analyze_cost.py`, `frames.py` and `summarize.py` preserve matched build, allocation, binary, code and frame extraction. The frame walker follows actual intra-function CFG and records unknown stack instructions; every reported boundary has none. Raw disassembly remains the independent authority. `frames-summary.txt` is a compact index, not a replacement for call graphs. `matching-proof.json` checks compiler/profile/feature/config/rustflags/dependency equality and fixture differences. Exact source patches and before/after input maps accompany all gates. No benchmark clock or quiet-window timing campaign ran.

The previous1.97 one-buffer dossier581640 and its−9184text/+80delivery-frame findings remain historical; they are not transferred to this new compiler/composition. The current matched findings above are independently measured.

The sealed `raw/` files larger than24KB use deterministic gzip; `file-index.json` records original and compressed SHA256. `external-artifacts.json` identifies full frozen ELFs/raw disassemblies left outside Git. Complete selected GPUI/channel function bodies are archived as `.selected.asm.gz`; the external full disassembly also includes all linked allocator/platform/font/helper bodies. `main-to-e31.patch` is a52-file source/docs/toolchain delta (1838 inserted/253 removed raw lines); test/support lines are charged separately from the machine core counter. Three nonshipping fixture variants total180 raw Rust lines; observer/parser scripts remain under `raw/`. No benchmark or production profiling hooks are added.
