# Thin route-handle feasibility correction

This is a separate corrected control, not a replacement or retagging of the earlier feasibility report. The original 196-line source remains unchanged at SHA-256 `0606a7cacefcc51b8a5c3c86fa823a41114de476d88e0f721a820b26ecd9bc38`; its report remains unchanged at SHA-256 `f334a0d4309c48d6c314cf56aad4c8bfe055f45bcd731ec675e21e65c14026d8`. The earlier harness omitted a `'static` bound on its generic constructor and carried `PhantomPinned`, so it could erase a borrowed route lifetime and changed `Unpin` behavior. Those are feasibility-harness defects; no shipping code is involved.

The corrected standalone harness is [`/tmp/thin-route-harness-corrected.rs`](/tmp/thin-route-harness-corrected.rs), 245 lines, SHA-256 `f86d02e2f792ae2791d985bc084bf618392736490982b4b9d1b07acca35a7cf3`. It has `T: 'static` on both the associated-table blanket implementation and `Handler::new`, and removes `PhantomPinned`; `assert_unpin::<Handler>()` now compiles. The earlier object-safe `Route` trait remains separate from the helper trait carrying the associated-const table.

I compiled and executed this isolated harness with Rust 1.97.1, edition 2024, opt-level 0, and the pinned Clang linker. It printed:

```text
PASS handler=8 option=8 header_capture=16 header_aligned=128 zst_alloc_delta=0 aligned_zst_drop=1 zst_panic_drop=1 capture_alloc_delta=1
```

In addition to the old control, the corrected harness exercises an align-128 zero-sized route with a destructor, verifies its call/drop references are aligned, checks zero allocations and exactly one drop, and catches a panicking ZST destructor while verifying it runs once. The existing captured destructor-panic check still observes exactly one `Header<T>` deallocation. A separate compile-fail pass with `--cfg negative_lifetime` was rejected with E0521 because the borrowed data would need to outlive `'static`, confirming that the corrected constructor does not erase that lifetime.

Executable SHA-256 is `90ed687ee577a75f54332df015d17790e06cd2eb5f698e3ee91dacd3143baf91`. The exact compile command was:

```sh
/nix/store/lynmg3kdpdz41r84nafwzi2n5nss50pq-rust-1.97.1-with-components-2026-07-16/bin/rustc \
  --edition=2024 -C opt-level=0 \
  -C linker=/nix/store/m59w5gavjx8db0ay3m1yzbw02l54109b-clang-wrapper-21.1.8/bin/cc \
  /tmp/thin-route-harness-corrected.rs -o /tmp/thin-route-harness-corrected
ulimit -c 0
/tmp/thin-route-harness-corrected
```

The negative lifetime control uses the same command with `--cfg negative_lifetime` and a distinct output path. It fails compilation as intended. `miri` and `cargo-miri` are absent from the pinned Rust toolchain; no component or toolchain was installed. This ordinary compiler/run control is not a Miri or strict-provenance soundness pass.

The exact GPUI source baseline inspected for this slice is commit `c717df64a9b492b445fa97647deb880fb21b9ef6` in `/root/gpui-ce3`. Both `reactivity/crates/gpui/src/lib.rs:7` and `reactivity/crates/canvas/src/lib.rs:2` contain `#![forbid(unsafe_code)]`. The feasibility prototype needs raw-pointer/vtable-table unsafe code, so shipping it inside those crates would require an explicit local policy change or a safe external abstraction; this test is not grounds to bypass either crate's policy.

What this establishes is limited to stable-language shape and ordinary control-flow feasibility for the isolated generic table/tagged-handle sketch: pointer-sized `Handler` and `Option<Handler>`, no ZST allocation, correct tested `repr(C)` allocation/drop layout, and the corrected lifetime/`Unpin` behavior. It does not establish Miri soundness, GPUI route integration, no-alias guarantees under all callbacks, behavior under all allocator/platform combinations, release dispatch cost, or a retained-memory win after captured-route headers.
