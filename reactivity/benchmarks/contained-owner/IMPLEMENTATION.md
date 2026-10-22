# Contained arbitrary property entry: implementation and controls

Baseline shipping source: `58995b75eaab408f488141ef77ed2b0d9ad0abe0`
(unchanged core from main `e5f848ca14433905185956495bd5f9c6ef0d51df`).
Chosen formulation source: `f8467390d50e5feb32407753170b6f763b4c872c`.
Final shipping source: `c3248fd11c138124e221af9487030b849445eca1`.
Final test source: `d8b26c1179296009b637cdb8adc1d25285d2751b` (only wraps
the new public regression call; all `gpui/src` bytes equal shipping source).
Worktree: `/root/gpui-contained-property-exchange`; independent build target:
`/tmp/gpui-contained-property-exchange-target`.
Two-slot control: `5ffbe09e18bddaaa36c9cd3eeda4ffa0170d74d6`.
Initial two-slot control `9ec0bf4346f2d6a76c3f52ad357965a0af4547a6` and its
earlier actual native gate remain separate; they are not final-winner evidence.
The later public no-op counter control is
`6da5c93b9c3bea34fcd39827e8e920348c9b1c8c`: after a nonzero edit it reported
changed_nodes2 for an empty request while S, reply status and paint stayed idle.
Its expected failing log and executable hash are retained. Final source adds
one reset in that empty-request branch; the targeted ordinary regression passes.
Earlier controls predate that correction and are not claimed to cover it.

## Final qualification

`qualification/campaign-before.json` and `campaign-after.json` are equal:
153 source/manifest hashes, clean tracked bytes at the final test pin, and
`gpui/src` equal to the shipping pin. Each final replay checked that pin before
and after its command. `source-artifacts-final.json` records frozen executable
hashes, Cargo fingerprints, feature sets and host/cross flag distinctions.

The final source passed default tests (489 including 28 doctests, 8 ignored),
full desktop/X11/Wayland/parallel all-target tests (514, 28 ignored), default and
full-feature all-target Clippy with warnings denied, and GPUI package formatting.
Apple aarch64 and Windows x86_64 MSVC all-target desktop/parallel build-std
checks passed; these are compile proofs, not foreign native runtime claims.
The real X11 native Apply/recovery/stale-target case passed on shipping c324;
its frozen binary and actual run log are retained independently. The final test
pin changes no native code. Raw failures and earlier source-qualified controls
remain alongside these final logs; they are not relabelled as final gates.

The shipping source counter is 29,536 code lines (29,523 source plus 13 build),
against 29,367 at the unchanged-core baseline: +169. The two reusable support
files add 198 non-test code lines and the original consumer spike adds 186:
553 authored shipping/example lines together. This excludes evidence tooling
and generated assembly; the separate all-source ledger charges those too.

## Ordinary API and ownership

```rust,ignore
fn proposal(&self) -> Option<PropertyChange> {
    self.contribution().ok()
}
fn applied_logically(&mut self, result: Result<(), &gpui::Error>) {
    self.status = match result {
        Ok(()) => "Logical contribution accepted".into(),
        Err(error) => format!("Rejected: {error}"),
    };
}
button("Apply").on_click(property_action(Self::proposal, Self::applied_logically))
```

`PropertyChange` is `(Target, PropertyId, Contribution<PropertyValue>)`,
interpreted against current L. It is not a presentation or revision lease.
The existing catalog owns validation, authoring equality, defaults, impact and
Style/Geometry destination. The existing public setter and this route share
one private logical mutation phase. No callback setter or second schema exists.

`examples/support/value_entry.rs` is the reusable tool component;
`property_workbench.rs` composes it with a library-owned button whose typed width
source and caller-supplied behavior remain ordinary APIs. The explicit root is
`Companion`, not an erased application root. Registered `Component` projectors
lift its handlers and source bindings. The tool registers its draft with `field`,
because its View parses/formats syntax errors. No direct-source alias is forged.
The public test and actual native fixture use the same support implementation.

The parser accepts arbitrary dimensions/scalars, all six affine components and
four color channels in the selected author's color space. It owns no duplicate
property range table. Unsupported kinds stay explicit. This is not an arbitrary
text-entry retrofit of the builtin inspector.

## Exact error and borrow ordering

1. Original event admission validates its live owner, retained route and checked
   contained projection. A stale original event invokes neither callback.
2. A shared model borrow produces an owned proposal, then ends. `None` invokes
   no reply and performs no source/property operation. Independent focus changes
   may still require the ordinary caret publication.
3. Resolve the proposed current-L Target and validate/mutate through the same
   canonical property phase as the public setter. Foreign/stale proposed Targets
   and Property errors go to the result method. They change no contribution.
4. Commit the checked S sequence before the ordinary mutable result callback.
   Rejection may still change the tool's status and therefore is a source turn.
   Both callbacks have ended before the one existing refresh/reconcile/prepare
   barrier. There is no nested Win::update, recursive activation or pending queue.
5. Restore the temporarily owned Handler before reconciliation, quarantine or
   drop. Request/reply panic quarantines the owner. A reply projector BindError
   after S commits also quarantines, returns that precise Binding error for the
   failed turn, and makes later authority Poisoned. A pre-admission BindError
   does not imply that an edit committed. The public malformed-projector test
   deliberately changes a safe projector between shared and exclusive use.
6. The existing next phase refreshes Future lanes. A refresh error after the
   source turn retains model/contribution state but revokes logical validity,
   selection and focus according to the existing barrier. A panic quarantines.
   Preparation failure likewise does not roll back an accepted contribution or
   the reply's model changes. Old P remains diagnostic/presented authority until
   an ordinary repaired candidate is acknowledged.

`applied_logically(Ok(()))` means logical acceptance only. Neither callback sees
a fabricated Commit or successful presentation. Errors before mutation (for
example sequence exhaustion) are operational failures rather than draft errors.
The singular-transform regression proves accepted L plus failed preparation,
old P, and ordinary position-free repair. Panic tests prove capture/route drop
ordering. Recoverable validation errors keep the draft and the route editable.

## Closed one-slot formulation

Ordinary `Route::invoke` keeps its original signature. Only an admitted Property
route calls the specialized `property(PropertyPhase)` slot. Its private closed
phase borrows either shared receiver plus stack output, or exclusive receiver
plus borrowed result. Neither phase nor output is retained. The component
adapter forwards this checked borrow to the same child; no model pointer is
stored. This replaces two specialized vtable slots with one, not a general
effect hierarchy.

Linux x86_64 default-feature measurements (not ABI promises): Handler16,
Admission16, El176, Node40, Runtime1824, Metadata264, Inspector24, Presented80,
PropertyInfo24, PropertyValue28, Contribution28, typed declaration56 and catalog
reference slots104, all unchanged. `PropertyChange`/Option48 and PropertyPhase32
are transient. Method-item property captures are zero-sized.

The unchanged blank-owner floor is21 allocations/5572 retained bytes; existing
inspector356/82678;100 warm unchanged resizes allocate zero. Actual opt-in
Companion136 and ValueEntry104 are model-owned. Fresh contained mount:546
allocations/177310 requested/30882 retained bytes. Its100 unchanged resizes
allocate zero. Width Apply costs378 allocations/159595 requested/+5421 retained
bytes in this fixture, through the coarse ordinary refresh. These are not plain
window costs, and no sparse Apply optimization is claimed.

## Complete ordinary release controls

`release-controls/artifacts.json` records exact source/client hashes, distinct
targets, ELF hashes, fingerprints, selected complete bodies and actual vtables.
The capture helper now requires those three exact source pins before any output;
it intentionally refuses the later test-ledger HEAD rather than retagging an
older binary. Reproduction must use the pinned source checkouts and builds.
`--final` captures baseline versus the final no-op-corrected source separately;
it does not overwrite or retag the earlier representation comparison.
All six ordinary binaries were copied and hash-checked under
`/tmp/gpui-contained-entry-release-final-controls` before later builds.
`release-controls/opt-in` additionally retains the matched public7-case source,
PropertyRoute bodies and frozen binaries for both representations. The opt-in
exchange dispatcher is249B for Apply and192B for Inherit, versus127+91B and
103+91B separate request/reply bodies: this small opt-in loss stays charged.
Initial9ec assembly/binaries are separately retained in `release-controls-9ec`.

No timings were run. Same Rust1.97.1/LLVM22.1.6, default+simd, release, empty
encoded Rust flags, two jobs and byte-identical ordinary clients:

| Client | Baseline text / rodata / data.rel.ro | Two slots | One exchange |
|---|---:|---:|---:|
| One model | 4069463 / 6570032 / 189776 | 4071543 / 6570408 / 189976 | 4071623 / 6570248 / 189912 |
| Two models | 4214935 / 6570888 / 190344 | 4218631 / 6571232 / 190560 | 4218727 / 6571080 / 190488 |

Normal method-route tables are48→64→56B (one per distinct route/model here).
Exchange adds80/96B text versus two slots, saves160/152B rodata and64/72B
data.rel.ro, net144/128B across these sections. Ordinary admission/invoke/owner
scope body sizes remain80/76/18B for the first model. Win.click1063B and
activate_focused781B stay unchanged; activate_with_editing967→1024B is a real
new admission branch. Its entry stack remains120B plus six register pushes;
click184B and focused72B plus six pushes also stay unchanged. The outlined
property helper is1782B per model with328B local stack plus six pushes, linked
even in these ordinary clients and fully charged. The public setter's3665B body
becomes370B wrapper+3332B shared mutation; moved work is not counted as removed.

The final no-op correction is captured independently in
`final-release-controls/artifacts.json`. It adds10 bytes to that helper
(1792B) while preserving328B local stack, all ordinary-path body/stack sizes,
normal56B route tables and the exact aggregate section totals above. Instruction
bytes absorbed by alignment are still charged, not called free.

Both formulations have identical ordinary allocation rows: one-model fresh
mount305 allocations/128258 requested/12770 retained; warmed click13/1740/0.
The two-model executable also records its actual distinct-model rows. Its first
mount can be304/128194/12706 because process-local setup is shared; do not mix
that row with the one-model executable. No zero-cost claim follows from equal
retained headers. PIE table inspection decodes x86_64 RELA into a private byte
copy before pointer lookup; the first rejected raw-pointer attempt is preserved.
Fresh-process sequential replays (`--test-threads=1`) additionally match all four
controls with explicitly required1/2 parsed rows. Their two-model rows are
305/128258/12770 and315/134376/15670 for mount count/requested/retained; both
warmed clicks are13/1740/0. Earlier parallel logs retain their actual setup
attribution. The first empty extraction was rejected and archived separately;
an empty-row equality is not evidence.

## Public/native scope still open

The native fixture selects a mounted Target through ordinary public Win APIs,
then types through native key input and clicks Apply through native pointer
events. It proves canonical rejection, editable syntax errors, recovery, stale
proposed-target feedback, exact ACK and actual server pixels. It does not prove
that public `Window::document` can seed a mounted Target, or implement a complete
builtin native picker/value editor. Press may prepare caret blur; this fixture
waits for that ACK before Release. Immediate Release while C is pending remains
strictly rejected by the current P barrier; no pointer lifecycle fix is claimed.

The next read-only design comparison is an opt-in typed admitted Target argument
versus transfer of an already-owned public Win into the native owner slot. A
Target argument solves capture, not live canonical-property read from a model
whose source value may be masked by Set. Win transfer must preserve lanes/close
authority and force new native C/P even at unchanged size/scale; headless ACK is
not a native server presentation. No such implementation is included here.

The original typed Future declaration spike remains type-checked but is not
claimed mounted through Companion. Existing static root/source lifetime and
completion barriers remain the only implementation.
