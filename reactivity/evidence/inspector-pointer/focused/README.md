# Inspector own-focus release: focused review handoff

Source `a2e03de3a0fd831f5c9e8404d6d8ebc1815465b8` is isolated in
`/tmp/gpui-inspector-pointer-sol`, based on shipping
`6021d0009db4069e5c7f96400890baa75630f047`. It is not adopted. `source.patch`
contains the complete six-file delta. Five production files and the existing
public pointer-focus test file change; no manifest, dependency, unsafe code,
public type, retained field or callback ABI is added.

## Ownership and admission

A private borrowed HitSheet couples one sheet's rows, GeometryView, dimensions
and frozen viewport presence. Its foremost-shape traversal shares the existing
rounded/transform/ancestor-clip predicate and nonhittable-run skips. Ordinary
routing then bubbles through that same sheet's parent links and existing live
logical handlers. Inspector picking retains its app-scope rejection and selects
the foremost shape even without a handler.

Release still tries strict current P first. The pending-focus fallback retains
6021's exact source epoch, completion, token sequence, viewport/DPI, validity
and window-target checks. For the built-in inspector it additionally requires
one P hit and one full C hit to resolve to the pressed target, with the point
inside each sheet's own window extent. The P hit is returned for activation,
so P is not traversed twice. C must have non-KEEP rows and its own frozen
metadata; an existing geometry owner must have its own candidate stream. No
candidate column falls back to P. An absent geometry owner means inline bases
and no radius payload, not a borrowed P recipe.

Focus publication refreshes captions and shell layout but does not replace
routes, selected property or picking mode. Intervening inspector actions advance
S and revoke the proof. The exclusive turn admits the same live target before
its normal callback. That callback can then change captions/layout as any
ordinary activation does; this proof makes no claim about future geometry.
Public/native semantics and geometry remain P until ACK.

## Strict picking counterexample and oracle

Strict picking's old extent policy is preserved. Clipped f32 widths can have
an outward f64 endpoint: the actual published test row has x bits 1036831948,
width bits 1144256922 and endpoint 720.000024408102. At x=720 its original
exact shape and viewport ancestors still hit. The old direct picking loop
selects that row, whereas ordinary hit's explicit window check rejects it.
The new pending-C fallback rejects that outside point without changing strict
picking. `oracle.log` preserves the concrete output.

The frozen old direct-loop oracle reads the supplied sheet's actual shape and
clip predicate, without the new window check or compressed skip. It matches
the shared traversal for P and C across fractional list scrolling, omitted
ancestors and outside points. Skip equivalence follows the existing producer:
each emitted row encodes !hittable and the immediately preceding emitted row;
an eligible row resets the run, independently from the packed parent index.

## Focused results and costs

All 43 selected default cases pass: 3 private input tests, 4 private inspector
and oracle tests, and 36 public cases (15 inspector, 9 pointer, 12 pointer-focus).
Base6021 had 9 pointer plus 9 pointer-focus cases, 18 combined. This candidate
replaces the prior inspector ACK-limit expectation and adds three public cases.
The C-only table exercises changed dimensions, translation, bounds, same-index
general bases, rounded radius, ancestor clips, absent columns, KEEP, omitted
rows and foreground panel blocking. A moved caption outside its own panel clip
correctly does not block activation. Public cases include caption epoch9→10,
old-P checked/text preservation, panel actions, picking scopes, stale source,
failed C, resize/DPI ABA and loss.

The source ledger grows 30,554→30,615 (+61 shipping code lines); added test code
is 515 lines, separately charged. HitSheet and Option<HitSheet> measure 56 bytes
on the borrow stack. The old and new result carriers both measure 56 bytes.
Session and optional session remain 32 bytes, and the measured model Runtime
remains 1,864 bytes. These are specific default layouts, not retained header
growth, native/cross layouts or summed stack peaks.

Initial public fixture failures (visual label lookup after catalog refresh,
and a strict query during pending C) are retained. The initial moved-caption
negative expected blocking but correctly failed because its own viewport clipped
it; it is now an explicit positive case, with real foreground-panel overlap
as the negative. Initial logs are draft diagnostics, not retagged final gates.
Final v3 logs correspond to the unchanged bytes committed as a2e03.

Normal-path optimized codegen, actual native clients, strict and foreign checks
are intentionally pending the next review phase. No cold control build or
performance timing was started; no such qualification is claimed. Commands,
profile flags, source hashes and source/test costs are recorded alongside logs.
