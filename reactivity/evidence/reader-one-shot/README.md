# Reader one-shot ownership and admission

Adopted shipping source is `c210a5e8342cb38940c697e65aa209c1d9f56edf`.
`7410240e39d6130a4447ba3445f50c17cfb59298` changes only the native ownership
test's Clippy style. The public Reader/Questions API and standalone state
RequestGate, RequestStamp and OwnerScope APIs remain unchanged.

One allocation holds the response payload and context. A non-cloneable Owner
governs reuse through exclusive methods; its one consuming Producer ends the
cell borrow before Release publication. The owner acquires publication before
taking the payload. Close publishes rejection before context cleanup and uses
`Arc::into_inner` for unique reclamation. Old notification calls may outlive
retirement and reuse, so reference count alone is not an admission token.

The producer already binds its message to an exact lane. A private checked
nonzero ticket replaces Reader's additional stamp, gate and plan scope. The
matching current token is consumed before resolution or admission; retiring
an old result preserves a newer queued token. Binding errors remain observable
even on stale responses. Explicit Retired state keeps exhaustion permanent.
Result destruction stays outside transport mutation and owner cleanup.

The three unsafe operations stay in the private mailbox module. Its slot has
a transparent unwind-safety marker: no user callback or payload destructor runs
inside a slot borrow, and terminal/closed state precedes context callbacks.
Context's own auto-trait requirements remain visible. The public certificate
uses a Send-but-not-Sync Cell payload. A compiled diagnostic caught the lost
unwind traits before that correction; its metadata source pin was not separately
certified, and it is preserved as a diagnostic rather than a qualified baseline.

## Measured costs

The comparison below starts at the typed-mailbox predecessor `0176e16f`.
It does not mix default and native layouts.

| 64-bit measurement | Before | Adopted |
| --- | ---: | ---: |
| Default u64 cold question | 2 allocations / 112 requested B | 1 / 48 B |
| Default one-source plan | 328 B | 224 B |
| Completion | 40 B | 16 B |
| Empty-future wrapper | 56 B | 32 B |
| Native Darwin controller | 96 B | 72 B |
| Native Darwin cold question | 2 allocations / 152 requested B | 1 / 88 B |
| Native first future poll | 0 allocations | 0 allocations |

The original mutex-based Darwin first-poll allocation regression is fixed.
Two separate Remote lazy-lock allocation failures remain outside this adoption.
Shipping source is **34,902 lines**, including 18 build-script lines: +50 over
the prior checkout, excluding tests, comments, examples, tools and vendors.
There are no dependency changes.

Actual ARM64 release assembly of the ticket predecessor reduces the completion
function's local frame from 112 to 80 bytes, passes its small message in registers
and removes stamp copying/refcount cleanup. Arc reference-count operations and
the notification call remain. The paired public owner-turn fixture has five
counterbalanced process pairs, each with seven rounds of 200 turns per kind.
Median question and unchanged-control ratios are 1.0072 and 1.0079. This provides
no distinct CPU improvement. It measures neither pixels, startup, scanout nor
other frameworks. These timings precede the transparent unwind-marker correction.

## Verification and limits

| Exact source/scope | Result |
| --- | --- |
| Ticket predecessor `bcbee2b1`, full default | 675 passed / 10 ignored; 72 result groups; strict all-target Clippy passed |
| Adopted `c210a5e8`, fresh affected GPUI executables | 204 passed / 5 ignored; actual library and question-test executables frozen and hashed |
| `7410240e`, current production module with Loom adapter | 11 passed / 0 ignored |
| `7410240e`, native Arc integration executable | 6 passed / 0 ignored |
| `7410240e`, exact live-source native test under Miri | 6 Stacked Borrows + 6 Tree Borrows passed, strict provenance |
| `7410240e`, GPUI and ownership-lab all-target strict Clippy | Passed |
| Adopted `c210a5e8`, actual Darwin native scope | 17 Reader + 21 public question tests passed; first-poll allocation case replayed successfully |

Current gates match all 2,062 build-input hashes before/after. Actual Cargo JSON
shows the changed GPUI library rebuilt; executable hashes match before/after
execution. The earlier full default suite was not rerun after the unwind marker;
the affected GPUI suite, formal/native proofs and strict checks qualify that
correction. Counts overlap and must not be added as independent coverage.

Loom imports the production module with tracked cell borrows and only uses its
safe roles. Its Arc adapter emulates `into_inner` with `try_unwrap`, so it does
not establish std Arc's destructor-thread guarantee. Miri checks actual std Arc
reclamation and aliasing; it does not prove weak-memory behavior. Both models
are required. Two compiled causal mutants fail at their intended assertions:
diagnostic ticket equality revives rejected work, and missing Retired checks
reopen an exhausted lane. An initial strict-check failure in the added proof
notifier is retained beside the corrected passing gate.

[Result and identities](result.json) include complete scope qualifiers and the
verified [raw log capsule](logs.tar.gz), with 143 hashed members. Four current
Linux executables and the actual Darwin MachOs remain at their recorded external
paths; they are not copied into this documentation archive. Some earlier
Cargo-only gate executables were not separately frozen; their commands, source
guards and logs remain available.

The native counterpart lives in
[`native_question_mailbox.rs`](../../crates/ownership-lab/tests/native_question_mailbox.rs).
It imports the live production module, avoiding an independently maintained copy:

```sh
cargo test -p gpui_reactivity_ownership_lab --features loom --test question_mailbox
cargo test -p gpui_reactivity_ownership_lab --test native_question_mailbox
cargo +nightly miri test -p gpui_reactivity_ownership_lab --test native_question_mailbox
```

Run Miri with strict provenance under each supported borrowing model. This
dossier makes no hardware graphics, physical IME, VoiceOver, Windows runtime,
whole-window memory or framework-performance claim.
