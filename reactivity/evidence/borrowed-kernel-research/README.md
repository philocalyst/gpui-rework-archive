# Borrowed frame kernels and coverage research

These are Luna research artifacts and standalone Rust constructibility probes,
not GPUI runtime changes or performance results. Root preserves their exact bytes
and external ELF hash. The third pass corrects the earlier overly strong
owned/static Frozen requirement: job/output-slot lifetimes end at join while
output data can retain frame borrows. The probe rejects sharing an entire
non-Sync model, selected non-Sync data and aliased mutable output slots.
Its std::thread::scope harness is not a proposed per-frame thread scheduler.

Actual GPUI still has one serial root owner. El routes, Parley/Fontique shaping,
Cephal mutation and dispatch authority remain owner-bound. Source paths and the
isolated typed inbox path do not establish render dependency isolation. A
parent may still inspect child state in ordinary Rust; component boundaries
alone cannot justify skipped parent recomputation. The proposed tracked regions,
worker pool and borrowed kernel integration are unimplemented.

The coverage follow-on describes a per-operation directed-interval alternative
to its first gamma-bound sketch. A separate Sol implementation owns the rigorous
predicate implication, negative controls and actual readbacks. Canvas revision
witnesses concern the public renderer; native GPUI already has token-based redraw.
The fixed failed GPU campaign remains separately archived and unadopted.
