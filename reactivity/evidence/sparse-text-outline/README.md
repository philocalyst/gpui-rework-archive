# Outlined sparse text-batch preparation

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

Fixed numerical gates: fail. Failed controls: 40-4-owner.

Original source-batch comparison

| Static labels | Fields | Mode | CPU candidate/control | Pair range |
|---:|---:|---|---:|---:|
| 0 | 1 | exact | 1.01486 | 0.9612–1.0407 |
| 0 | 2 | exact | 1.01961 | 1.0193–1.0331 |
| 0 | 4 | exact | 1.04493 | 1.0173–1.0895 |
| 0 | 1 | owner | 1.00083 | 0.9735–1.0235 |
| 0 | 2 | owner | 1.02729 | 0.9962–1.0350 |
| 0 | 4 | owner | 0.97252 | 0.9343–1.0250 |
| 25 | 1 | exact | 0.98008 | 0.9065–0.9809 |
| 25 | 2 | exact | 0.71626 | 0.6920–0.7549 |
| 25 | 4 | exact | 0.86711 | 0.8535–0.9081 |
| 25 | 1 | owner | 1.01288 | 0.9668–1.1208 |
| 25 | 2 | owner | 0.98439 | 0.9614–1.0062 |
| 25 | 4 | owner | 1.00509 | 0.9343–1.0552 |
| 1000 | 1 | exact | 1.03908 | 1.0080–1.0745 |
| 1000 | 2 | exact | 0.06599 | 0.0630–0.0673 |
| 1000 | 4 | exact | 0.12428 | 0.1175–0.1269 |
| 1000 | 1 | owner | 0.99691 | 0.9614–1.0357 |
| 1000 | 2 | owner | 1.00880 | 0.9456–1.1355 |
| 1000 | 4 | owner | 1.05021 | 0.9008–1.0580 |
| 0 | 4 | opaque | 1.02205 | 0.9843–1.0489 |
| 25 | 4 | opaque | 1.03856 | 0.9848–1.0584 |
| 1000 | 4 | opaque | 0.99770 | 0.9830–1.0299 |

Separate comparison against inline batch

| Static labels | Fields | Mode | CPU candidate/control | Pair range |
|---:|---:|---|---:|---:|
| 25 | 2 | owner | 1.04803 | 0.9248–1.0512 |
| 1000 | 1 | exact | 0.98045 | 0.9581–1.1073 |
| 1000 | 2 | exact | 0.98801 | 0.8856–1.0032 |
| 1000 | 4 | exact | 0.97327 | 0.8975–0.9984 |

Base 2d55c3dff194443742736f8171422dc11b59ed48; measured source a476ef4330c54a83112d5e78a027373dcbcb0e4a. Run `python3 reactivity/evidence/sparse-text-outline/verify.py` to reconstruct all results and the fixed verdict.
