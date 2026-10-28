# Thin Route handle: isolated feasibility control

The design report remains frozen at SHA-256 `50e9ebf6f161b5183bf4e3e07f7cc5fbb0c70ecea7bd7768198736a0cd03f70b`. Its source baseline is GPUI commit `1d5bc3061cce3beb3c4857102ed651da501b5cfd`; I verified the object in `/root/gpui-ce3` with `git rev-parse` and read source with `git show <commit>:reactivity/...`. The checked worktree is currently at `c717df64a9b492b445fa97647deb880fb21b9ef6`, so I did not treat live files as that baseline. The status command also reported untracked `reactivity/docs/thin-route-handle-luna.md`; I did not change it.

I compiled and ran the standalone 196-line harness at [`/tmp/thin-route-harness.rs`](/tmp/thin-route-harness.rs). It is a feasibility test, not GPUI code. Source SHA-256: `0606a7cacefcc51b8a5c3c86fa823a41114de476d88e0f721a820b26ecd9bc38`; executable SHA-256: `a92472aeff2c44b5eae37cf8024c79a28e99185961a9078402a8aad03b2b7d00`. The exact command was:

```sh
/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/bin/rustc \
  --edition=2024 -C opt-level=0 \
  -C linker=/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/cc \
  /tmp/thin-route-harness.rs -o /tmp/thin-route-harness
ulimit -c 0
/tmp/thin-route-harness
```

It printed `PASS handler=8 option=8 header_capture=16 header_aligned=128 zst_alloc_delta=0 capture_alloc_delta=1`. The harness checks generic associated-const promotion for an operation table on a *separate blanket helper trait*, keeps `Route` usable as `dyn Route`, tags/un-tags a `NonNull` with `map_addr`, and checks move/drop. It observed no allocation for a ZST route and exactly one ZST destructor call; one requested allocation/free for an 8-byte captured payload; a 64-aligned route had a 128-byte `Header<T>` with the value at offset 64; and a captured destructor panic still freed its exact header allocation once during unwind. The object-safe trait is type-checked through a `&dyn Route` parameter. This demonstrates that the proposed shape is expressible on the installed stable compiler. It does not establish soundness, especially under all strict-provenance/Miri checks.

Installed compiler was `rustc 1.97.1 (8bab26f4f 2026-07-14)`, Cargo 1.97.1. Neither `miri` nor `cargo-miri` is on PATH or in that toolchain. I did not install a component/toolchain. The existing report's Miri gate therefore remains unrun; ordinary execution is not a substitute.

The route census was not built. A safe census needs an isolated exact-pin source copy, a temporary object-safe default `Route::probe` exposing concrete type name/size/alignment, and an internal snapshot over published `Runtime.nodes` reporting `None`/`Some`, ZST/captured and component wrapper counts. Sample draft `El` and `DraftNode` owners separately from published nodes because the vectors can overlap during reconciliation. The present root worktree is a different commit, and a temporary GPUI/app probe would compile modified GPUI against path-vended dependencies; reusing or mutating the shared `reactivity/target` without a separate check could race existing work. Parent's lower-cost condition was “if feasible,” so no such build or allocation-count claim is made here. `contained_owner_spike` is the first public fixture; `Workspace` is the next mix. The headless Hummingbird transcript can follow only if those counts leave an unresolved captured-route question.

This control does not cover GPUI's concrete route variants, `ComponentRoute` forwarding, failed mount/reconciliation, route movement/replacement, cross-thread traits, nor release dispatch code. The byte ledger and lifecycle gates in the frozen report still govern any implementation decision.
