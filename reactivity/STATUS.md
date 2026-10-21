# Implementation and evidence

The clean-room workspace now includes a connected application implementation.
Start at [crates/gpui/README.md](crates/gpui/README.md), rather than treating the
initial design-only snapshot below as its current executable scope.

| Integrated boundary | Executable behavior | Remaining limit |
| --- | --- | --- |
| `gpui` | Borrowed `View`, inline `Signal`, typed owner-relative sources/actions, exact text fanout, public input/serialization, generational Targets | One serial root owner; conservative ordinary-Rust re-description; no integrated complete async graph |
| properties/inspector | Typed sealed selectors, common reflection catalog, sparse Set/Inherit overrides, transformed hit/paint through one geometry kernel | Full native inspector UI, theme cascade and keyed collection policies remain |
| layout/text | Borrowed content measurement with Cephal, real Rustybuzz shaping, logical layout and physical-density glyph masks | Existing script/text-editing limits; no complete selection/IME/fallback stack |
| `gpui_canvas` | Real ordered linear-light composition, 4×4 correlated samples, conservative tile proofs, one optional CPU image, safe external native BGRX output, optional disjoint parallel bands | Retained command representation is still being reduced; no complete effect/path library |
| `gpui_gpu` | Actual `wgsl-rs` shader, ordered tile compositor, lazy R8 glyph atlas, inverse/clip boundary corrections, SDR and linear HDR target output | Spatial admission is bounded, not universal CPU byte parity; native HDR negotiation and remaining primitives are gates |
| native application | Real vendored-Winit windows with GPU or direct software presentation, keyboard/pointer adapter, resizing/DPI, source/prepared/presented separation, surface-loss input revocation | Software-first background GPU upgrade is being integrated; multiwindow/shared-device/native guest composition remain |
| application ports | Counter and tutorial Todo add/complete/filter/delete/undo, persistence; the exact same Todo model runs in native and headless tests | The tutorial's full selection/IME, appearance animation and timeout effects are not claimed ported |

Current gates include 252 passing workspace/all-feature cases (including six
Loom cases), four portable GPU checks and nine actual Vulkan readback cases.
The separately enabled native X11 test has run both GPU and direct-software
frontends: ordinary keyboard/pointer routes, recoverable shaping failure,
resize, inspector transform, actual X11 pixel readback, suspend/recreate and
target survival. The GPU suite runs on Mesa 26.1.4 llvmpipe here, which proves
execution and output, not discrete-GPU performance or other-platform behavior.
These results precede the ongoing startup/font changes; those must pass their
own integration gates before replacing this evidence.

Already-built release native measurements on Xvfb/Linux/NixOS show the driver
floor matters far more than scene bytes: forcing software rendering reduces
blank-window PSS from about 106 MiB with llvmpipe Vulkan to roughly 7 MiB, with
one thread. The initial Todo software window is roughly 22 MiB PSS, exposing a
large text floor. CPU ticks remain unchanged at one/three/five-second samples.
See [native memory data](crates/gpui/evidence-native-memory-cpu.csv) and
[the sampling tool](tools/native_memory.py). First-present timing is measured
separately; no sub-50 ms or monitor-scanout claim follows from these samples.

No legacy implementation has been deleted under a false feature-equivalence
claim. The old source is still the behavior/plumbing reference; legacy device
error generation, swapchain-image release before reconfigure, resource lease
and whole-scene atlas lifetime rules inform the new integration. The following
original design evidence remains useful history, not the current production
coverage table.

## Initial design-only snapshot

Snapshot: 2026-10-20, branch `codex/reactivity-cleanroom` in `/root/gpui-ce3`.
The complete design is indexed by [README.md](README.md). Its versioned contract
has received independent Sol and Luna adversarial review. The executable work is
a standalone workspace of correctness oracles and competing experiments. A full
application/renderer replacement remains the implementation roadmap.

## What is implemented

| Crate/boundary | Executable scope | Limit |
| --- | --- | --- |
| core | Safe mutable generational topology, sparse geometry, wide transform oracle, linear/pruned hit traversal and bounded tile damage | Per-node mutable oracle; no shared-template production tree or rendering |
| core `layout` | Optional Cephal over that same topology; interned styles, lazy caches, serial unrounded output, retained/cold checks, panic poisoning | Private mutable correctness adapter; no shared layout sheet/cache integration |
| state | Inline checked Signal, bounded owned Handoff, owner/request authority, owned candidate TwoEpoch, typed projector utility | No complete reactive graph, source carrier, typed schema enforcement or turn engine |
| host | Optional native Winit callback boundary, redraw coalescing, terminal closed wake gate with acquiring RMW chain | Compiled X11/Wayland; native display/IME/lifecycle behavior requires hardware testing |
| api-lab | Concrete borrowed El, constructor children/branches, owned retention, internal generative lowering and diagnostic compile failures | Rebuild/allocation/drop costs explicit; no permanent source wiring or keyed identity |
| template-lab | Shared immutable succinct topology, typed sparse/dense scalar overlays and dynamic instance runs | Append-only lab identities; fixed-default scalar semantics; stable addressed sites/layered style remain gates |
| algebra-lab | Safe rooted link-cut comparison; exact i64/i128 subpixel translation specialization and viewport-relative narrowing | Affine regrouping rejected; sparse-space experiment, no layout/damage/backend integration |
| coverage-lab | Interval/Lipschitz tile certificates, ordered opaque pruning, scalar point-compositing oracle | Boxes/circles within admitted domain; point samples, no area-AA/font/GPU proof |
| ownership-lab | Scoped borrowed pages, moved preallocated SPSC pages, full/closed/drop semantics, allocation evidence and weak-memory models | CPU completion only; no persistent pool, actual GPU fence or native wake integration |

Pinned complete Winit 0.30.13 and Cephal 0.1.1 archives, licenses, source commits
and archive hashes are recorded in [vendor/PROVENANCE.md](vendor/PROVENANCE.md).
Their source is unchanged. Native hosting and Cephal layout are optional; default
core/state have zero third-party dependencies. The legacy workspace excludes the
new workspace/vendor roots and retains its original behavior.

First-party libraries forbid unsafe. The allocation measurement example has
isolated unsafe forwarding to System; it is instrumentation, with no Miri claim.
No custom unsafe ownership/reclamation scheme was admitted to production.

## Verification on the combined checkout

[checks.json](evidence/checks.json) records exact commands, exit status and elapsed
time; neighboring text files contain complete output:

Stored text logs normalize trailing whitespace. `python3 tools/verify.py` from
this workspace recreates the combined gates and evidence (Cargo/Rust on PATH).

- Debug and release workspace tests with optional Cephal layout: **90 passing
  cases each**, including the consumer compile-failure harness and doctests.
  That harness checks six programs for the intended compiler diagnostics.
- Strict Clippy across first-party workspace/all targets with layout: passes.
- Optimized Loom protocol suite: **6 passing tests**. Two check the corrected
  finite protocols; four prove counterexamples in deliberately broken variants.
- X11+Wayland native-host compile check and retained-layout example: pass.
- First-party formatting and whitespace checks: pass at final integration.

Environment: AMD Ryzen 7 3700X, x86_64 Linux/NixOS, Rust/Cargo 1.97.1, LLVM 22.1.6.
No attached display/GPU benchmark, platform visual validation, Miri or second
hardware class is claimed. Native compilation is narrower evidence than a
working interactive host. [environment.json](evidence/environment.json) records
the reproducible toolchain/OS context without credentials.

## Useful measured frontiers

These are local microbenchmarks with complete methods/caveats in each crate.
They guide selection and carry no whole-application comparison claim.

| Experiment | Useful case | Recorded losing case |
| --- | --- | --- |
| Shared scalar templates | 10k instances × 1,024 nodes: 244,952 B known retained payload versus 41,200,736 B eager scalar fields/shared topology | Fully customized 1,024-node case uses about 6.1% more than eager fields; lookup slower; small templates lose sooner |
| Exact translation paths | Warm 100k-deep root edit + one query about 88 ns; 64 B per sparse space record | Balanced all-50k queries about 4.45 ms versus 0.481 ms eager; cold/deep and memory costs still count |
| Coverage/worklist proof | 64 opaque overlaps, 256²: complete scalar plan+point-render 11.22 ms → 0.489 ms; bins 16,384 → 256 | 4×4 boundary-dense case 2.76 us → 10.90 us; plan adds memory |
| Borrowed phase | 262,144 primitives: serial 1.370 ms → scoped-four 0.397 ms | 1,024 primitives: serial 5.20 us versus scoped-four 81.9 us; fresh threads allocate every phase |
| Page transfer | 100k warm same-thread roundtrips allocate zero; 8,192-byte payload stays at same address | Setup seven allocations/9,312 requested bytes; cross-thread run about 603 ns includes startup/polling, no OS/GPU latency |

Figures include each lab's declared capacities and comparators, with exclusions
for allocator/driver/system costs explicitly stated there. The template figure
is a scalar structural case, not a rendered widget bill. The coverage baseline
uses implicit containment rather than unnecessary distance square roots.

The historical DS lab was also rerun locally; raw output is
[nodes2-x86_64.txt](evidence/nodes2-x86_64.txt). Its embedded verdict prose describes
older M3 observations and is not authoritative for this run. For example, the
local 0.1%-dirty marking-plus-visit cost already exceeds a simple dense sweep in
that synthetic case. Include discovery/marking when choosing a crossover.

## Review changed the design and code

The original primitive review found sub-ULP missing damage, premature f32 transform
underflow, quadratic hit clip checks, request-admission retry loss, unsound carrier
assumptions and reflection overclaims. Code fixes preserve tiny damage/wide
composition, prune clips once and reject poisoned layout reads. Contract revision
2 resolves carrier, source commit, result retention and property trust boundaries.

Loom then found release-only acknowledgement, acquire-only failed coalescing,
clear-after-drain and hint-after-wake losses. The host's producer performs a
successful AcqRel RMW even when coalesced; its acknowledgement acquires that
chain before queue inspection. The broken forms remain counterexample tests.

The final cross-layer review closed seven additional gaps: stable targets across
template address changes; opacity-dependent background resurrection; per-instance
snapping; backend-specific numerical certificates; explicit Set versus Inherit;
hover geometry feedback; and LCD/filter noncommutation. See
[review-final-sol.md](docs/review-final-sol.md) and
[review-close-luna.md](docs/review-close-luna.md), with earlier reports preserved
as dated evidence. [REVIEW.md](REVIEW.md) records dispositions and remaining gates.

## Implementation comes next in explicit slices

The first production slice connects one owner-dispatched counter/settings screen,
typed operations and source binding, template sites, immutable presentation sheet,
inspector edits and public demo input in one engine. It must retain an accepted
worker result across candidate failure and pass focus/key/IME revocation tests.
The next slice shares unrounded Cephal solutions and local hit indexes, then
retains primitive/group/paint slots through a selected backend numerical profile.
The full dependency order and deletion gates are in [PLAN.md](PLAN.md).

Permanent source binding, atomic fault-recovery edge swaps, recycling stable
instance/sites, layout solution sharing, a complete text/IME/a11y stack, native
guest/webview composition, area-AA/effect rendering and real presentation fences
are still implementation gates. Analytic shadows/filter fusion and other
derivations in FORMULATIONS are proposals with reference tests specified.

## Line count is accounted for, not claimed as a win

[baseline.json](evidence/baseline.json) pins the original 260,010 physical Rust
lines and branch deltas. [line-counts.json](evidence/line-counts.json) counts each
new crate's src/tests/examples and both vendor trees, including comments/blanks
and embedded tests. Vendor Rust alone is 74,569 lines. The original implementation
still exists; coexistence makes the checkout larger. A scope-equivalent major
deletion or competitor memory/frame-time win has not been demonstrated.

The 8k/20k/35k first-party design budgets are review triggers for the eventual
feature-complete replacement. Dependencies, code generation, tests and platform
glue remain visible in the total. PanGui's subsystem rewrite is an example of
shared formulation reducing code, not evidence that this whole framework has
already met its budget.
