# Remote first-use allocation

Source `4f9378d457a310517432aba95db3f4edbdf80408` replaces Remote's std mutex
with pinned parking_lot 0.12.5. Queue ownership, lock boundaries, bounded FIFO,
frozen delivery, revocation and callback/destructor placement are unchanged.
The private unwind marker preserves the previous public auto-traits. No unsafe
or queue algorithm is added. Hummingbird's standalone lock gains only the GPUI
dependency edge; no package versions change.

The adopted shipping inputs match the reviewed native source
`d483cd70a216cc576809a8be39228f59088175c7`. Their only build-input difference is
the previously qualified test-only native-mailbox Clippy correction. The
[machine-readable receipt](result.json) records every guard, artifact identity,
measurement boundary and separately charged cost.

Actual Mac native qualification passes **719 tests, zero failures, 12 ignored**
in all 70 freshly rebuilt GPUI test executables. Each Mach-O was frozen before
execution. The two unchanged first-lock allocation contracts fail with the
preserved std-mutex controls and pass with this change. Reader's first-poll
allocation contract also passes. This gate excludes doctests and ignored cases.

| Unbound, uncontended Darwin operation | std mutex | parking_lot |
| --- | ---: | ---: |
| Shared transport header | 112 B | 104 B |
| Capacity-eight cold allocation | 2 / 192 requested B | 2 / 184 requested B |
| First send | 1 / 64 B | 0 / 0 B |
| Untouched first stage | 1 / 64 B | 0 / 0 B |
| Untouched first close | 1 / 64 B | 0 / 0 B |

Capacities zero and one lose the same lazy first-lock allocation. Linux's
existing first-use count remains zero and its header size is unchanged.
Attached OS wake posting is a separate allocation boundary. Contended queue
behavior has no allocation or speed claim here.

Main passes **244 affected GPUI/Reader/transport cases**, strict all-target
GPUI and ownership-lab checks, and Hummingbird's locked offline default-target
check. All 2,783 build/port inputs match before and after each gate. The original
Remote candidate passed 677 full default tests and Windows default/native
metadata checks before the transparent Reader unwind correction. Those are
overlapping, separately pinned scopes; Windows runtime remains unqualified.

Core is **34,899 non-test, non-comment lines**, including 18 build-script lines:
three fewer than its parent. Native adds zero dependency packages. Default
adds five packages and **7,470 conservatively counted dependency source lines**,
charged separately from core. The matched native release empty example grows
80 file bytes and 64 text bytes. Optimized ARM public-operation probe text
shrinks 372 bytes; receiver drop's own stack frame grows 16 bytes. The earlier
Linux optimized driver linked over debug dependencies grows 67,897 text bytes;
that is not a release shipping-size comparison. No CPU improvement is claimed.

[logs.tar.gz](logs.tar.gz) contains 66 hash-verified members: raw Main gates,
the independently verified 382-member Mac log capsule, full native capsule
receipt, original source/dependency inventories and reproduction helpers.
Its SHA-256 is
`2b10bc6beaa4e1f970895fd23f5cc803aa25607de1c2cb722dc086596f318625`
(2,329,371 bytes). Five actual Main Linux executables remain frozen at the
paths in the receipt. The complete native source/log/artifact capsule remains
on Mac at
`/Users/mileswirht/gpui-reactivity-20261024-root/remote-d483cd70-sol/complete-capsule.tar.gz`:
677,114,639 bytes, SHA-256
`64ff130fd9354232574c5f1c51c98b684e01a184ef3c5fd100b1dfc60a9d1eb3`.
It includes all 76 actual test/release Mach-Os and probe objects, with all three
source variants. Registry source and toolchain bytes remain outside that
capsule; exact lock checksums and toolchain identity are recorded.

The failed thin-rlib assembly command and corrected full-rmeta attempt are both
retained. The initial Root setup used an unavailable bare Python command; its
lockfile edit was corrected before any qualification. This work establishes
first-use storage and functional behavior, not GPU performance, startup,
display latency, VoiceOver coverage or whole-player completeness.
