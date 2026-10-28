# Sol adversarial review of the integrated reactivity foundation

Reviewed 2026-10-20 against `/root/gpui-ce3/reactivity` during integration at
`d2dbef870f` plus the integrating agent's concurrent edits. This is a review of
prototype code and the proposed final API, not a claim that a GUI or reactive
runtime exists. I authored the initial state primitive spike; its APIs receive
the same adversarial scrutiny here.

The foundation is small and readable, but the source carrier and publication
protocol are still architecture choices, not consequences of the current types.
One confirmed numerical bug remains at the last test run: finite descendant
geometry disappears after intermediate transform underflow. Two damage bugs and
one closed-loop wake bug found during this review were fixed by the integrator
and independently rechecked below.

## Evidence and reproducibility

The standalone harness at `/tmp/reactivity-review-sol/Cargo.toml` compiles the
actual integrated core library and runs the actual public core/state test files.
It creates its own lockfile; it does not modify the parent workspace or its lock.
The toolchain is the supplied Rust 1.97.1 store path. Results:

- Existing tests: 9 spatial, 3 tree-oracle, 13 state protocol tests pass.
- `/tmp/reactivity-review-sol/tests/adversarial.rs`: six review tests; the first
  run exposed two damage failures, then the transform-underflow test exposed a
  third failure. After the integrator's damage fix, five pass and transform
  underflow still fails. Two passing tests demonstrate unwanted API behavior,
  rather than asserting that behavior is correct.
- `/tmp/reactivity-host-review-sol/Cargo.toml` compiles the actual default host
  library and actual host tests. All 3 integrated tests plus the review's bounded
  drain/rearm test pass. Native window creation/rendering was not run.

The harnesses are temporary evidence, not shipping regression coverage. Promote
the relevant counterexamples into the owning crate's production API tests.

## P0: finite geometry can silently become empty after composition

[Affine::compose](</root/gpui-ce3/reactivity/crates/core/src/geometry.rs:121>)
computes products in f64 but casts each composed coefficient back to f32.
[SpatialTree::refresh_subtree](</root/gpui-ce3/reactivity/crates/core/src/spatial.rs:204>)
reuses that rounded intermediate world matrix. A nonsingular chain can therefore
become singular, and later transforms cannot recover the information.

Minimal public construction: three nested nodes have x scales `1e-30`, `1e-30`,
and `1e30`; the leaf's local rectangle is `(0, 0, 1e30, 1)`. All declarations pass
validation. The mathematical leaf support is approximately one square pixel.
The intermediate scale rounds to zero, so inserting the leaf produces **zero
damage** and no hit at `(0.5, 0.5)`. This is not merely a conservative oversized
bound or an unrepresentable inverse; the implementation loses visible content.
The test `representable_leaf_support_cannot_vanish_after_intermediate_transform_underflow`
currently fails in the review harness.

Keep wider accumulated coordinates, or carry an explicit numerical-uncertainty
state through composition. If the accepted numeric domain cannot be represented,
reject it before publishing, or retain a diagnosed conservative representation;
do not classify representational underflow as truly empty geometry. Wider f64
alone also needs a stated finite domain and exhaustion/uncertainty handling for
arbitrarily deep chains. Add underflow, overflow followed by compensating scale,
and cancellation chains to the independent oracle.

## P0 before slice 4: four-byte inline state cannot discover its runtime queue

[Signal::deref_mut](</root/gpui-ce3/reactivity/crates/state/src/signal.rs:80>)
correctly increments a local revision before returning `&mut T`. It has no owner,
slot, runtime reference, queue, or effect callback. The
[spurious mutation test](</root/gpui-ce3/reactivity/crates/state/tests/protocol.rs:70>)
explicitly polls the revision itself. It proves mutation marking and destination
comparison, not sparse delivery.

The original [four-byte representation](</root/designs/reactivity/final/08-runtime.md:151>)
stores a slot instead. A slot still cannot locate a per-window dirty queue without
a carrier. Replacing a local revision with a slot does not solve that problem.
Neither representation can send a notification merely because `DerefMut` ran,
unless it has a lifetime-safe route to the queue, generated instrumentation, an
explicit phase token, ambient lookup, or a later scan. Moving the owner forbids
using a retained raw address to its inline field as a shortcut.

The integrator added an honest
[owner-level scanning floor](</root/gpui-ce3/reactivity/PLAN.md:187>): after a known
owner handler, scan its wired field descriptors. This is implementable and should
remain the first path. State its cost as O(wired fields in changed owners), then
measure whether another carrier earns its bytes and complexity. The original
O(publications) arbitrary-dereference claim remains unmet. Benchmark changed
owners with thousands of wired fields and one modified field; do not benchmark
only one-field counters.

Automatic tracked `Deref` has the corresponding read-side problem: `&Signal<T>`
does not name the active computation. A macro can rewrite known expressions, but
cannot rewrite arbitrary opaque library bodies. Conservative owner re-description
must preserve correctness for those calls. A per-signal read bit alone cannot
identify which observer read it.

## P0 before API stabilization: constructor projections have no source carrier

The [model's constructor example](</root/designs/reactivity/final/00-model.md:82>)
creates a local inline `query`, calls `query.map_async(...)`, and moves both the
query and resulting reader into the owner. An ordinary inherent method on the
standalone signal cannot know the future owner's typed field path. A borrowed
projection would prevent moving the signal; a captured raw address would become
invalid; copying its value would produce a snapshot, not a live source.

Pick one explicit mechanism before promising that example: defer a typed recipe
until post-mount field registration, construct through an owner-bound typed field
projection, or move source storage to stable owned allocation and price that
change. A macro-free application must exercise the chosen mechanism. Do not hide
the same missing lookup behind `reader()` or `map()`.

The [small Copy Reader](</root/designs/reactivity/final/05-async.md:23>) is a key,
not a borrow into storage. Its `map`/`project` operations can be deferred recipes
resolved at an explicit lowering seam. The
[Settled Deref claim](</root/designs/reactivity/final/05-async.md:136>) needs an
additional lifetime/storage proof: a fallback guarantees some value exists, but
does not establish where a valid `&T` to the latest graph output comes from.
An owned snapshot or scoped resolved guard can implement Deref; a bare inert
runtime key cannot independently do so without a carrier and borrow protocol.
Readiness and reference validity are separate obligations.

## P1: request acceptance is not atomic with logical publication

[RequestGate::accept](</root/gpui-ce3/reactivity/crates/state/src/request.rs:183>)
immediately consumes its pending ticket.
[TwoEpoch::commit_logical](</root/gpui-ce3/reactivity/crates/state/src/publication.rs:61>)
is independently fallible. This public sequence succeeds in the review test:

```rust
gate.accept(&stamp).unwrap();
assert!(epochs.commit_logical(|_| Err::<Model, _>("budget"), |_| Ok(())).is_err());
assert_eq!(gate.accept(&stamp), Err(AdmissionError::Stale));
```

The old logical state survives while the accepted answer cannot be readmitted.
Likewise, issuing a superseding ticket while building an abandoned candidate
would invalidate the old candidate's still-valid work. The state primitive's
docs correctly forbid issuing before the containing logical draft is admitted,
but that restriction is not a complete atomic pending/request publication API.

Keep completion payloads and admission acknowledgements in the logical draft.
Use a nonconsuming validation followed by infallible finalized admission at the
serialized commit boundary, or commit an owned completion inbox and retry from
that inbox. Test failed build, failed validation, owner revocation, and retries
between each step. Do not claim unified failure atomicity because the two
primitives pass separate tests. Input-version and policy validation also remain
the future graph's responsibility; current stamps do not perform them.

## P1: TypedField is an accessor bundle, not trusted reflection enforcement

[TypedField::new/get_mut](</root/gpui-ce3/reactivity/crates/state/src/field.rs:14>)
accept arbitrary read and write functions plus arbitrary metadata. This compiles
and runs through the public API:

```rust
let field = TypedField::new("a", |m: &Model| &m.a,
    |m: &mut Model| &mut m.b, "no impact");
*field.get_mut(&mut model) = 42; // reads a, writes b
```

The application can also bypass validation, write an invalid range, and declare
an insufficient impact. There is no permissions layer, override provenance,
reset policy, or source-to-phase enforcement. This is acceptable for a safe
projection utility, but does not satisfy the
[reflection acceptance gate](</root/gpui-ce3/reactivity/EXPERIMENTS.md:29>) or the
[trusted property schema plan](</root/gpui-ce3/reactivity/PLAN.md:167>).

Keep this primitive explicitly untrusted. Give framework-owned properties a
separate validated setter/schema path whose impact is selected by the library,
not supplied by the inspector. An exposed unrestricted `&mut T` cannot enforce
those setters. Arbitrary user-model projections should fall back to conservative
owner work unless their trusted schema supplies a stronger contract.

## P1: distinguish callback transport from a complete host/input policy

The adapter currently forwards every method in the vendored
[ApplicationHandler trait](</root/gpui-ce3/reactivity/vendor/winit/src/application.rs:8>).
[WindowEvent and DeviceEvent](</root/gpui-ce3/reactivity/crates/host/src/native.rs:20>)
are borrowed intact, so I found no present lossy normalization of keyboard text,
physical keys, IME ranges, wheel precision, synthetic flags, file paths, or
scale-factor writer data. `InnerSizeWriter` needs `&mut self`, but it is Clone;
the host can clone the handle and call it synchronously inside the callback.
That claim is source inspection, not a native platform test.

Preserve this direct pass-through while the portable event policy is designed.
It does not yet prove IME state transitions, capture cancellation, focus loss,
accessibility routing, or platform surface release ordering. In particular,
lossless event data and correct ordered interpretation are different gates.
No headless application turn engine exists yet.

The original wake implementation retained `pending = true` after a failed
`send_event`, so the next `signal` incorrectly reported success. The integrator
replaced this with a terminal CLOSED state in
[WakeGate::signal](</root/gpui-ce3/reactivity/crates/host/src/lib.rs:27>), and the
[closed-gate test](</root/gpui-ce3/reactivity/crates/host/tests/dispatch.rs:38>) now
passes independently.

Acknowledging **before** draining is the right producer/consumer ordering,
provided the synchronized queue supplies its own visibility. A bounded drain
must rearm if it yields with queued work left: acknowledge, drain one of two
messages, then return with no other producer is a stranded-message schedule.
The review's public WakeGate test demonstrates the required explicit self-rearm.
Document this invariant and add a queue-level trace test. Concurrent signal
counting alone does not prove wake/drain liveness. Spurious empty callbacks are
acceptable; missing work is not.

The initial PLAN routed all input against the old displayed epoch. That
contradicted [the final key/focus rule](</root/designs/reactivity/final/08-runtime.md:78>).
The integrator corrected [the plan](</root/gpui-ce3/reactivity/PLAN.md:201>): keys
use the latest logical focus, while coordinate input waits for coherent
presentation. This correction still needs an executable event-N focus/key-N+1
failure/recovery test once an application loop exists.

## P1 memory: sparse geometry still retains a deep traversal stack

Measured x86-64 type sizes through public APIs:

| Type | Bytes |
| --- | ---: |
| `Signal<bool>` | 8 |
| `Signal<f64>` | 16 |
| `Handoff<u8>` empty header | 40 |
| `OwnerScope` | 16 |
| `RequestStamp` | 32 |
| `RequestGate` | 56 |
| `Tree` header | 56 |
| `NodeId` | 16 |
| Spatial geometry record | 88 |

Allocator overhead and Arc control blocks are additional. These are instantiated
sizes, not universal ABI promises. The checked four-byte revision is honest; the
original claim of four extra total bytes for every signal type is not.

For a 30,000-node spatial chain with one declared geometry record,
`allocated_bytes()` rose from 1,048,584 to 2,359,656 after refreshing the root.
It stayed 2,359,656 after removing the whole tree. The
[scratch path](</root/gpui-ce3/reactivity/crates/core/src/spatial.rs:219>) retains
approximately 40 bytes per depth entry at Vec high water, despite geometry-free
wrappers. This cost exceeds the geometry payload by orders of magnitude in that
case. The accounting includes it, which is good; sparse geometry is not itself
proof of low retained memory.

Price a path representation that stores less per wrapper, or a traversal that
reuses cached geometry ancestry. At minimum expose a scratch/reclamation budget
and release policy rather than retaining arbitrarily deep history. Compare a
wide root and a deep chain with equal live geometry. No unsafe pointer scheme is
required to identify this cost.

The Handoff default of 64 bounds occurrences, not bytes; payloads may own arbitrary
buffers. It is not yet a byte-budgeted remote ingress. Its unconsumed report is
opt-in; no turn-end runtime currently guarantees that the report is consumed.

## P2: function identity needs a concrete representation, not a phrase

The correction [in PLAN](</root/gpui-ce3/reactivity/PLAN.md:66>) rejects raw
function addresses as durable identity. Good, but "typed method/receiver
metadata" needs an actual representation: receiver type alone cannot distinguish
two methods with the same signature. Coercing both fn items to the same fn-pointer
type loses their distinct item types. Pointer comparison is still not a remedy;
optimization may merge equivalent code or duplicate one function across units.

For process-local dispatch, retaining the callable at a structurally identified
mount site may remove the need for function equality entirely. For remappable
commands, use the declared command ID. If preserving generic fn-item type identity
is chosen, compile examples before writing another route abstraction: method
receiver inference and noncapturing closure coercion must both work through that
same public API. Nothing in current crates proves this route surface yet.

## What should survive, and what should wait

Keep the flat safe topology, namespace/generation validation, explicit bounded
FIFO ownership, conservative mutation stamps, and immutable candidate test model.
The topology's independent randomized adjacency oracle and nonrecursive deep
removal tests are useful evidence. Keep the raw host boundary narrow.

Before another optimization tier, build one owner-dispatched counter using the
explicit wired-field scan, then a settings screen with validated inspector
overrides and a failing presentation step. It should expose the source carrier,
request acknowledgement, focus/key ordering, and memory bill in one production
path. Do not implement a second callback, reflection, or identity system merely
to make isolated spikes appear integrated.

The numerical damage fixes now pass the review counterexamples:
`Rect(64,0,1e-6,1)` produces damage, and
`Rect(63.999996,0,4e-6,1)` covers both tiles. The integrator moved endpoint arithmetic
to f64 in [Damage::add](</root/gpui-ce3/reactivity/crates/core/src/damage.rs:44>).
`Rect::contains/intersection` still use f32 endpoint arithmetic, so callers must
not infer a globally consistent high-precision rectangle algebra from that local
damage fix. The transform-chain failure above remains open at this review's last
test run.
