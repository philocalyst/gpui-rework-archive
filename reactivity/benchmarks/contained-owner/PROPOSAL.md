# Contained arbitrary property entry: bounded consumer and proposed seam

Immutable main baseline: e5f848ca14433905185956495bd5f9c6ef0d51df.
Existing-API consumer source: 58995b75eaab408f488141ef77ed2b0d9ad0abe0.
Worktree: /root/gpui-inspector-contained-owner. All text controls remain frozen.
This is an ownership/API spike, not a completed native Inspector entry feature.

## What compiles and executes now

`cargo run --offline --locked -p gpui --example contained_owner_spike` mounts an
ordinary `Win<Companion<Application, ValueEditor>>`. Two existing `Component`
declarations own the application and editor; their existing source schemas own
the width and UTF-8 draft bindings. The same ordinary text input selection and
typing APIs edit that draft. No fake input, owner pointer, field namespace,
interior-mutability cell, private source writer, or second runtime is involved.

The consumer parses arbitrary dimensions, scalar radius, four authored color
channels and all six affine components. Syntax parsing owns no property limits.
Existing Color constructors admit colors; the ordinary catalog setter owns
property validation, destination, exact equality, impact and contribution
presence. Source width changes remain masked by Set; Inherit reveals the latest
source width. The caller-supplied application method still handles its button.

The executable deliberately performs the property commit from its host after
ending the model borrow. There is no advertised Apply button, async completion
claim or native round-trip claim. `standalone_preview` type-checks an owned Future
declaration for the editor itself; it does not pretend to mount that declaration
inside Companion. No executor or fake synchronous polling adapter was invented.

## Exact current costs

Linux x86_64 default simd/dev, Rust1.97.1, explicit empty encoded rustflags:
Win8; Companion<Application,ValueEditor>104; application12; editor88;
Signal<String>32; PropertyValue28; Contribution<PropertyValue>28;
Component40; Source40. These are measurements, not ABI promises.

The unchanged core's existing ledger reports Node40, Runtime1824, Metadata264,
Inspector24, Handler16, El176, Style88, Presented80, Admission16,
InspectorAction/WindowAction4, PropertyInfo24, typed declaration56 and catalog
reference slots104. Plain owner21 allocations/5572 retained bytes; existing
28-node inspector356/82678; 100 unchanged inspector resizes allocate zero.
These allocation rows qualify the unchanged baseline, not the new Companion
mount; no new Companion allocation total is claimed.

The frozen consumer is196 physical Rust lines,186 code,5 comments,5 blanks.
Shipping library/build-script delta is exactly zero. It deliberately contains
the full source declarations, parser and executable assertions, rather than
reporting only its short mount call. The generic two-field Companion needs no
core algorithm or additional registry. Model/source/schema/handler allocation
costs still apply to its two ordinary component boundaries.

## Proposed route, before any core implementation

Keep the existing typed/ID property APIs. A tool request is only the owned tuple
`(Target, PropertyId, Contribution<PropertyValue>)`; it is not a new reflection
schema, callback setter or user-defined impact. A named convenience type may be
justified later, but is not necessary to prove this seam.

Compare these two concrete controls (line counts cover the handler methods and
builder, excluding common parser, model fields and Sources declaration):

```rust,ignore
// A: single method outcome, 7 nonblank lines.
fn apply(&mut self) -> Option<PropertyChange> {
    match self.contribution() {
        Ok(change) => { self.status = None; Some(change) }
        Err(error) => { self.status = Some(error.into()); None }
    }
}
button("Apply").on_click(Self::apply)
```

This handles syntax failures, but does not report *canonical* range/kind/target
errors. Exposing the existing canonical validator would allow prevalidation of
values without duplicating limits; it still cannot validate a foreign/stale
Target from a model method. Returning those errors through today's
`native::input_result` would terminate the window for Property errors. Ignoring
them would conceal failure. This is not an acceptable complete entry contract.

```rust,ignore
// B: read-only request plus ordinary result method, 7 nonblank lines.
fn proposal(&self) -> Option<PropertyChange> {
    self.contribution().ok()
}
fn applied_logically(&mut self, result: Result<(), &gpui::Error>) {
    self.status = result.err().map(ToString::to_string);
}
button("Apply").on_click(property_action(Self::proposal, Self::applied_logically))
```

The extra method gives a typed error destination without storing another Source
descriptor or a pending queue. Syntax errors remain visible from the draft's
parser in View; therefore this complete editor must register DRAFT with `field`,
not the spike's `direct` contract, if its View branches/formats parse errors.
Canonical errors go to `applied_logically`. Method items are zero-sized captures; a
pair does not increase Handler16 or El176. The existing ComponentRoute remains
the owner projection. Its exact additional boxed payload/allocation and linked
body cost require implementation measurement, not a zero-cost assertion.

A single-outcome alternative with an ordinary result Source can also express
errors, e.g. `.on_click(Self::apply).errors(Self::STATUS)`. It replaces the second
method with a source declaration/registration and a40B Source descriptor in the
opt-in action payload, plus its normal schema entry. It is reusable, but adds
state/schema work to save one short method. A generic framework error Reader or
per-handler retained status would be a larger feature. Neither is proposed here.

B is the initial correctness proposal, not a shipped API commitment. Normal
unit-returning handlers keep their current ordinary signatures. Only an opted-in
property action uses the new erased route operation/result pair. Do not implement
a general command queue, an unbounded list of effects or a public turn context.

## Borrow and transaction ordering

1. Admit the original event site against its current window/cohort. Validate
   the registered component projection and receiver type through existing
   Sources, then borrow the owner immutably to obtain the owned proposal.
2. End that borrow. Check the requested Target in current logical L, reserve the
   checked source sequence, and validate the ID/contribution using the same
   canonical property transaction. No mutation precedes rejected value/target
   admission. No external turn can intervene in this exclusive operation.
3. Apply an admitted contribution without presenting. The current private setter
   combines mutation and presentation; extract only its private mutation phase,
   shared with the public setter. Preserve list/source/color-bank barriers.
4. End the property borrow. Invoke the ordinary typed result method exclusively
   on the still-registered owner, with logical success or a borrowed error. A
   rejected property changes no contribution; writing the error caption is an
   ordinary model operation and may legitimately advance S.
5. Discover source changes, refresh questions, reconcile, and prepare at most one
   candidate through the existing admission path. A reply may alter model state,
   so it must precede this shared barrier. A callback panic follows the existing
   owner quarantine contract, not a rollback claim.

`applied_logically(Ok(()))` means the logical contribution was accepted. It must never be
labelled rendered/presented; P stays old until the normal exact candidate ACK.
Preparation failure retains accepted logical edits and result state; existing
native presentation-error handling reports it. Repair uses ordinary settle.
Operational exhaustion/poison/closed-owner errors are not editable-value errors.

This ordering intentionally differs from blindly calling today's whole setter
and then a second `update`. At the frozen pin the exact public setter order is:
`property_edit_target` checks live owner, resolves Target and checks S+1;
`set_property_value_at` validates Set, mutates the Style/Geometry contribution,
sets S and its source-operation counter, describes if Style+lists, then calls
`present`. Thus failure before contribution mutation is rejected admission,
while a describe/prepare failure after S changes retains accepted logical state.
Neither `Result<Commit,Error>` nor its error alone is a rollback guarantee.

The proposed reply reports only that logical mutation phase, before preparation.
It does not receive a fabricated Commit, prepared token or acknowledged epoch.
The runtime must call a distinct erased reply operation after releasing the
request/model borrow; it must not recursively activate the handler, call public
Win::update, or present between request and reply. The original event's exclusive
turn owns both operations. Precise source/target checks still apply to the reply
projection, and operational failure bypasses domain-error handling.

| Case | Required behavior |
|---|---|
| Invalid syntax | Draft remains editable; parser message; no property write. |
| NaN/domain/wrong kind | Canonical rejection; editable draft/result message; no fatal native error. |
| Foreign/stale property Target | Same canonical rejection/result message; no retarget or clamp. |
| Stale original button | Reject before request/reply, as ordinary event admission already does. |
| Window close/replacement | No callbacks into closed/other owner; native session/cohort gate remains authority. |
| Accepted logical write, failed preparation | New L/status with old P; no success-before-ACK claim. |
| Completion callback panic | Quarantine owner; no rollback or replay promise. |

## Contained ownership and Future scope

The explicit `Companion<A,T>` is a reusable existing-API composition. It leaves
plain Win<A> unchanged, but its root is honestly Companion, not A. Replacing
builtin `with_inspector()->Win<A>` with this owner would change root/source/lane
typing. Do not hide that behind Deref or claim a borrowed wrapper satisfies the
existing 'static Any/source contract. Nor should a separate nested Win be used:
that would introduce the second runtime explicitly prohibited here.

A transparent builtin adapter preserving the exact public root type requires a
separately reviewed generic owner projection or opt-in wrapper facade. Adding
Option<Box<Tool>> to every Runtime or an erased runtime vtable would impose plain
window costs. This spike chooses explicit composition and leaves that integration
decision visible; it does not implement a broad Runtime split.

Current Questions accepts Source<Root,T>; a Source<Editor,T> cannot be passed to
Questions<Companion<App,Editor>>. Registering another root descriptor for the
same Signal is rejected as an alias, so manufacturing qualified IDs is wrong.
The narrow candidate is a `Questions::component(COMPONENT, child_questions)`
adapter, using the existing registered ComponentEntry's child Sources and checked
source qualification. It borrows child input only while freezing, owns the child
question lane, and forwards exact source changes through that same qualification.
Reader keys/completion admission stay with the existing question machinery.
This should be compared with a scoped QuestionInputs adapter before choosing;
`contains` currently lacks registered Sources, so a superficial descriptor lift
cannot safely infer its assigned scope. No new node field is needed either way.

Future workers receive owned frozen draft values, never Target/Win/model borrows
as mutation authority. Results may preview text in Reader; Apply always uses the
current logical draft/target. Superseded results, close and owner replacement
retain existing request/owner revocation. No async path commits a style directly.

## Review boundary

No library API or native behavior has been patched. Before implementing B, agree
the error/result API and explicit owner shape, then measure one/two model clients,
all hot headers, ordinary owner allocation floor and actual Apply behavior.
The real Inspector still has honest step/cycle controls; arbitrary entry remains
required and unimplemented there. This proposal does not erase that requirement.
