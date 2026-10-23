# Producer lifetime and native owner rearm

The provisional terminal lane delivers owned data followed by one budgeted
`None` when its final producer disconnects. A full Library result lane can now
resolve an accepted intent as a visible failure rather than leave it Pending.
This adds no blocking send, finish ceremony, retry buffer, worker or queue.

`Win::with_inbox_status` and native `Window::with_inbox_status` retain statically
inferred callbacks. Both reject zero capacity. Ordinary `with_inbox` preserves
its message-only semantics. An existing receiver Option plus staging capacity
marks terminal admission/retirement; no lane flag or header was added.

On native builds, one Arc owns the sole SyncSender and inline notification;
the Inbox holds Weak. The sender field drops before notification, so final
notification observes actual channel disconnection. Only terminal bindings
request this final wake. Attaching after final producer drop explicitly wakes
the owner to drain existing data. NativeHost rearms once from Delivery.more,
including recoverable presentation failure; per-lane signal traversal is gone.
Actual Question completion/credit notifications retain Controller::signal.
Headless retains its direct SyncSender and no producer allocation.

The prerequisite retirement correction is the identical cherry-pick e62a4ae5ae
of cc74e92d7fb2ffd9eedb9b66813a79c2fcfc41b5. It is not a new transport win.
The first source was 24a1a036b7; shared binding plumbing and resource fixtures
were frozen at 07939f684084ce9c7e196edf45c6eeca790ceffc. Final source
2aec8e8f5b63ef603578ea17fa7522ac173a777e adds inferred StatusLane naming,
collapses guards for strict Clippy, and adds zero/closed native-builder tests.
Earlier frozen captures remain separate.

## Functional qualification

Final production x11/a11y: 207 private, 19 Question, 16 Remote tests pass;
27 actual-native tests remain ignored by the ordinary suite. Strict production
x11 all-target Clippy passes; the earlier three production and two fixture
style failures are preserved. Installed-source native/a11y Darwin ARM64 and
Windows MSVC checks pass. These are type checks, not foreign runtime results.

Four actual X11 tests pass from both the frozen minimal-native and final
production-x11 binaries. The new test covers five pre/postbinding, saturated
and quiescent scenarios, including final drop after a below-budget data batch,
all buffered data before one terminal, an extant clone, and recoverable failed
description before buffered repair. Existing bounded Remote, Question
credit/result, and future cancellation/result wakes pass without delivery
polling. Watchdogs only detect failure. Retirement then late WorkReady reuses
the prerequisite's actual lifecycle. Every child, private Xvfb and dbus process
exited. Source and binary before/after hashes match.

Public deterministic tests also cover FIFO/round-robin mixed lanes, Question
supersession and latest admission, zero budget, zero capacity, owner close,
exactly one None, and terminal callback panic quarantine. Existing per-message
allocation controls pass.

## Costs and limits

| Requested storage on this host | Control | Candidate |
|---|---:|---:|
| Headless Remote / Inbox / Lane | 16 / 56 / 72 B | same |
| Headless cold allocations / bytes | 3 / 832 | same |
| Native Remote / Inbox / Lane | 24 / 64 / 80 B | 8 / 64 / 80 B |
| Native cold allocations / bytes | 4 / 888 | 4 / 912 |

A single native endpoint pair therefore grows 8 B including its Remote header;
each further Remote clone saves 16 B. Binding and steady messages allocate zero
in the scoped controls. Native clone performs one Arc increment instead of two.
The ordinary native cold case is not a monotonic memory win. Shipping source
rises 30,599 to 30,708 non-test lines (+109), charged by Syn/Tokei.

The identical opt3/codegen-units1 caller probe uses dev-profile dependency
artifacts; it is not a whole release application or performance comparison.
Headless's entire caller object is byte-identical, including all six alias
groups (text 274,890 B, object 745,264 B). Native text rises 276,456 to 276,555 B
(+99); object rises 750,144 to 751,688 B. Native entry bytes are:

| Entry | Control | Candidate |
|---|---:|---:|
| clone | 81 | 12 |
| send | 2,153 | 2,168 |
| drop | 366 | 22 |
| ordinary delivery | 4,659 | 4,665 |

Entry shrinkage moves work out of line: candidate Producer drop_slow is 407 B,
Notification glue 140 B and OnceLock glue 115 B; control notification drop_slow
was 193 B. Candidate's external dev-profile Notification::drop adds 46 B;
Notification::signal remains 66 B. All matched function stack subtractions
remain unchanged; the added Producer drop has 16 B. Ordinary delivery/send
retain 152/72 B explicit stack subtraction. All aliases and changed functions
are recorded, including unfavorable entries. No target-CPU flags were used.
There is no timing, whole-player memory, universal adoption or full-port claim.

Raw caller objects/assembly and build metadata remain under
`/tmp/gpui-intent-transport-codegen`; copied native binaries remain under the
capture directories. The runner records three later probe builds; the initial
control-native probe was emitted separately with the same probe/optimization
arguments. The dependency-artifact mismatch from an early copied headless rlib
is retained in that directory and resolved by emitting each probe immediately
after its matching build. It was not a source fix or timing rerun.
