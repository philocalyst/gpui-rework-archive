# Owned source paint slots and exact CPU spaces

This implementation replaces per-destination color publication with one owned
author-color relationship per qualified source. It also factors exact CPU
inverse bases and clips into canonical-scene columns. It does not complete a
GPU space-bank design or establish a frame-time improvement.

## Ownership and publication

The model retains its ordinary `Signal<Color>` fields and the existing typed
source schema. A cold style bank stores the frozen author color, its converted
working color, and the effective/declared source relationships. Different
qualified `FieldId`s remain different relationships even when their values are
equal. Registered foreground/background uses no longer retain one fanout
destination for every node.

The canonical complete Canvas scene owns its own working colors and exact
geometry. Neither a model reference nor a `Signal` borrow enters that scene.
Changing a source writes one logical color entry and, when eligible, one
canonical paint slot. It does not rewrite every retained style, inspector lower
base, command color, or positional edit record. Style reflection reconstructs
the current author value from the owner bank. Inspector access refreshes only
the addressed lower base. An equal `Set` still changes the relationship and
forces a complete rebind before later source changes; `Inherit` restores the
latest declared source.

The existing complete-C/source-epoch check remains the admission barrier. The
fast path requires the immediately preceding complete scene, unchanged alpha,
and an installed source relationship. A skipped or failed newer preparation
does not authorize writes into an older scene. A logical source that emitted
no command needs no canonical paint slot. Empty geometry and clipped-out glyphs
therefore do not exhaust the paint-bank resource limit.

Successful slot publication preserves pending full candidate rows and unions
their damage. Without pending full rows it uses the existing checked Keep-P
form. No-op updates extend the complete scene's epoch coverage without changing
its token. The observer's previous complete-scene stamp remains the authority;
late activation cannot infer a complete delta from matching row counts.

## Canvas representation and APIs

`PaintColor::new(Color)` performs the existing validated author-to-working
conversion. `Canvas::paint_slot` allocates a distinct positional relationship.
`fill_rect_slot`, `fill_rounded_rect_slot`, and `draw_text_scaled_slot` reference
that owned row. The deferred `*_shared` forms initialize a caller's temporary
slot cache only after a command is admitted. That cache must be cleared on
scene replacement; no cache borrow is retained by Canvas.

`prepare_slots(&[SlotEdit])` validates the entire strictly ordered list before
returning an exclusive commit guard. It rejects missing/nonshared positions and
alpha changes. Dropping the guard changes nothing; committing performs only
validated writes. `PaintSlot` is a position in the current scene, not a semantic
or generation capability. Scene replacement can reuse positions. GPUI pairs
them with its exact scene token.

Legacy positional `PaintEdit` remains a literal setter: even an equal write
detaches that command group from later shared-slot changes. Admission reserves
any necessary literal row before the infallible commit. Equal detachment can
have zero changed pixel support while still changing that relationship.

CPU `StoredCommon` retains the original two inverse-translation `f64`s and
references an exact four-coefficient inverse basis plus clip. Reassembly copies
the six original fields; it does not reassociate the inverse or narrow it.
Identity plus the original viewport is implicit. Scope equality compares every
stored float bit, including signed zero. Discovery checks the last scope, then
the first 32 exact scopes, then appends. Long adjacent late cohorts reuse one
row. Alternating scopes outside that prefix can still append one row per draw;
this bounded discovery policy is a documented losing case.

Shared paints retain a conservative support union. Their private support packs
two material facts into spare coordinate bits; all four coordinates are masked
before damage geometry is exposed or combined. The public `DamageRegion`
representation and 16,384-pixel extent limit remain unchanged. Same-alpha edits
keep raster membership/cut eligibility; complete scene replacement invalidates
it. CPU bins and pixel work are not removed by sharing a paint slot.

## GPU packet path

Banked packets put a compact paint prefix into the existing word vector. It
contains a header, two proof bits per row, and one 16-byte working color per row.
The prefix ends at the last shared row; intervening literal rows remain so the
public row index is a direct checked address. Such literal rows duplicate color
storage already present in ordinary packet records and are an explicit cost.
Packets without shared paints retain the original prefix-free format and
ordinary draw loader. Discovering the last shared row currently scans retained
paint rows during full preparation, including a complete scan of an all-literal
bank. That additional scan is not claimed removed by the prefix-free layout.

The existing color/correction lane identifies a shared bank row without
growing draw records. Image material keeps its existing radius/color-word
interpretation. The banked shader path loads each command and its working color
outside the 16-sample loop, keeps the original painter order for every sample,
and uses the existing anchor/delta reduction order. Its 16 local accumulators
can increase register or private-memory pressure. Upload counters do not prove
a GPU latency improvement.

`Renderer::prepare_slots` validates all positions, proof classes, alpha, and the
target under an exclusive borrow. Rejection preserves the old packet. Commit
revokes replay before the first queue write, writes one 16-byte word per changed
slot, submits a complete clear/draw to the new target, then restores eligibility.
Opaque rectangle proof classes conservatively reject negative zero and
negative subnormal replacement components where the existing proof cannot be
reused. Full rendering is the fallback.

Native surfaces use ordinary `Renderer`, removing the opt-in positional
`PaintRenderer` map. A slot update additionally requires the exact private prior
packet token, including its window namespace. One owned last transition is
retained only by native owners with source-color banks. Multiple unsubmitted
transitions, alpha changes, renderer loss, mode changes, or proof rejection cause
a full render of the latest complete scene. This is not an accumulated-delta
protocol. Every newly acquired target is fully drawn; submission is not a
presentation acknowledgement.

## Costs and limits

No dependency, per-command reference count, global table, mutable shared owner,
or new ordinary Runtime/Node/Presented field is introduced. Cold discovery does
allocate transient typed maps, and source-colored owners allocate the style
bank and its concrete columns. Default source-free owners retain the previous
style representation.

The CPU representation is deliberately not a universal memory win. Before Vec
capacity, a unique nondefault inline draw uses 56 bytes plus a 48-byte scope and
24-byte paint row: 128 bytes versus the previous 108 bytes. Implicit defaults,
reused scopes, grouped placements, and shared sources change that tradeoff.
Small-owner headers, retained capacities, and construction peaks must be charged
alongside the eliminated per-destination vectors and command payloads.

Canonical GPU geometry is still encoded through the original exact inverse
records. Sharing those GPU spaces is a separate remaining implementation step.
The tests establish the listed CPU/native/Vulkan executions, not universal
cross-device raw-float equality or measured performance.
