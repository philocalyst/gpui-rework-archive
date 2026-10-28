# One-word retained UTF-8 representation experiment

This isolated crate is not a GPUI dependency. Its public safe interface owns
immutable valid UTF-8. The experiment attempts to remove allocations and
refcount operations for nonempty strings up to one word minus one byte, without
growing retained text rows or their Option fields. Empty text keeps ArcStr's
existing immortal empty representation; longer strings keep ArcStr ownership.

The first development run passes three tests on Rust1.97.1: content/niche/move
and clone behavior, scoped thread transfer, and actual allocation requests.
This does not establish soundness or application savings. No timing has run.

Representation invariants:

* A zero low-three-bit tag is exactly one unchanged pointer returned by
  ArcStr::into_raw. ArcStr1.2.0 publicly guarantees at least eight-byte alignment
  on every platform. Each stored heap handle owns one strong lease. A cloned
  handle increments that count; Drop consumes exactly that handle's lease.
* A nonzero tag is the byte length of a nonempty inline UTF-8 string. The value
  is constructed with NonNull::without_provenance, never by exposing/recovering
  heap pointer provenance. Every byte of the word is initialized; tag and payload
  do not overlap. No operation dereferences the stored no-provenance address.
* Inline reads derive a new pointer from the address of the field inside &self,
  borrow its payload bytes, and bound the slice by the encoded length. Returning
  &str cannot outlive &self. Moving the owner while that borrow remains live is
  prevented by Rust. Equal byte content, rather than pointer identity, defines
  equality for both representations.
* A temporary ArcStr reconstructed for a heap borrow is wrapped in ManuallyDrop;
  it neither creates nor consumes a strong count. The returned text lives in the
  allocation owned by self, rather than in the temporary handle. The raw-pointer
  reborrow extends only that borrow to &self's lifetime. It exposes no owned
  ArcStr, raw pointer, mutable reference, or arbitrary-lifetime reference.
* NonNull preserves the guaranteed nullable-pointer niche. The type is immutable
  and has no mutable raw API; Send/Sync rely on immutable inline storage and the
  already Send/Sync ArcStr allocation, including its atomic clone/drop behavior.

Remaining proof and adoption gates:

1. Pointer-object byte representation and endian behavior require explicit
   scrutiny. Rust's pointer docs say most platforms represent addr() with the
   original pointer bytes; they do not promise this for arbitrary future pointer
   architectures. Inline encoding must be limited to targets with the required
   representation, with ArcStr fallback elsewhere, before production use.
2. Genuine pinned Miri with strict provenance and both borrowing models, testing
   x86_64, 32-bit i686 and big-endian s390x; boundary-length Unicode/NUL values,
   relocations, clone/drop in either order, and cross-thread leases. Miri is
   useful dynamic evidence, not a proof for every target or execution.
3. A deliberate broken lifecycle/encoding control must be caught, then restored.
4. Matched generated-code and complete application allocation measurements must
   charge helper crate, dependencies, source lines, branches, long-string paths,
   and the unchanged one-word retained row. Synthetic short-string gains alone
   cannot establish lower whole-player memory or latency.
5. The existing GPUI core forbids unsafe code. Any adoption needs a small audited
   helper boundary or an equally effective existing dependency; the main core
   policy is not changed by this experiment.

Qualification will freeze source before execution and preserve failed attempts.
Functional watchdogs, selected before captures:600s each standalone test/strict
gate;900s each Miri sysroot setup;600s each named Miri execution. Targets/build
directories are exclusive to this experiment. No timing gate is registered.

Primary references read on2026-10-23:

* [ArcStr1.2.0 raw ownership APIs](https://docs.rs/arcstr/1.2.0/arcstr/struct.ArcStr.html#method.into_raw),
  also read from the exact cached source used by Cargo.
* [Rust pointer provenance and pointer/integer distinction](https://doc.rust-lang.org/std/ptr/index.html#provenance).
* [NonNull strict-provenance constructor and Option layout](https://doc.rust-lang.org/std/ptr/struct.NonNull.html).
* [Pointer addr representation limits](https://doc.rust-lang.org/std/primitive.pointer.html#method.addr).
* [Miri supported targets and checking flags](https://github.com/rust-lang/miri).
