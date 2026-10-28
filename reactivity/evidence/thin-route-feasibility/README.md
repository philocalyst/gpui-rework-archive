# Standalone thin-owner feasibility, unadopted

These isolated programs test a language/layout hypothesis, not the shipping GPUI
route owner. original/ preserves the initial control verbatim. Root adversarial
review found that its constructor lacked T:'static and could erase a borrowed
lifetime; PhantomPinned also changed Unpin behavior. Corrected/ enforces the
lifetime, retains ordinary owner Unpin and tests aligned/panicking ZST drop and
captured unwind deallocation. The negative borrowed-route compilation fails as
intended. Exact compiler/linker commands, source/executable hashes, observed
results and scope limits are recorded in the reports.

Miri is unavailable, so these ordinary runs establish no soundness pass. Neither
program implements GPUI route variants, component forwarding or failed-source
quarantine. Shipping GPUI still forbids unsafe code. Any future implementation
needs explicit policy and ownership review, exact safety tests and measured
allocator/linked-dispatch controls. The separate route census prices actual
slot density and concrete payload shapes; neither a thinner mirror nor this
harness establishes a total-memory, latency, RSS or startup win.
