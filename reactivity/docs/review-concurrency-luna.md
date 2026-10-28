# Concurrency contract review

**Reviewed:** 2026-10-20. Compared `/root/gpui-ce3/reactivity/CONCURRENCY.md` and `CONTRACT.md` with the corrected `/root/designs/reactivity/rework/concurrency-research.md`.

No remaining memory-order, state-transition, lease-lifetime, or thread-affinity contradiction found in the canonical pair.

- Wake gate now requires every producer, including a coalesced producer, to execute a successful release/acquire RMW; UI acknowledges with an acquire-capable RMW before queue inspection. A failed Acquire-only CAS and a Release-only clear remain explicitly rejected. The research note explains the producer RMW chain and keeps ring publication/acquire as the slot-ownership protocol.
- Shutdown is terminal: the gate preserves `Closed`; producers do not post/reopen it, and shutdown joins producers before its final drain/return. The Boolean sketch in the first draft was replaced by the closed-safe state protocol.
- Scoped jobs borrow immutable input and write disjoint output; cross-turn work owns a frozen pack/result. The contract's successful source-operation commit and worker-result admission fit this boundary.
- Reliable input/completion/lease-return messages stay ordered and bounded; latest-wins is limited to a complete snapshot or cumulative damage state. This agrees with the contract's source order, result admission and coherent presentation epoch.
- Generations validate identity; they do not reclaim memory. The concurrency doc requires CPU borrowers, GPU fence and OS release to finish before page reuse, matching the contract's distinct CPU/GPU/OS release stage.
- Winit/UI remains the default owner; a separate presentation thread is backend-gated. This matches the contract's platform lifecycle and presentation obligations.

No canonical-file edit is required from this review. Loom should keep the three discovered negative cases as regression tests: Release-only acknowledgement, Acquire-only failed-CAS coalescing, and clear-after-drain.
