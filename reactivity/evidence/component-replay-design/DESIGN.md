# Concrete comparison and proposed admission boundary

This is a source-grounded design, not an executed model. Names in the API sketch are provisional. The 773cd5d counterexamples are existing execution evidence; all proposed behaviors below are obligations for a later implementation.

## 1. What already works, and where it stops

`Sources::direct` and `SignalMap` already support a small replay contract. A source map is total, deterministic and read-only over its input plus immutable parameters; I/O and external mutable reads are forbidden by an explicit semantic law. The mapper is owned, Copy/static and size-bounded, but those Rust types alone do not prove the law. `MappedFanout` retains recipes and destinations; `freeze` evaluates and validates every output before mutating any sink. Existing source/owner routing decides whether that authority applies. A changed Questions result, invalid logical state, owner dependency or list realization can require description instead.

For a fixed two-rectangle child, a mapped width can express 24→40 without rerunning `View`. It cannot express the actual witness's one→two-child structural change. Leaving that grow input declared `field` requires full-root description. Changing it to `direct` while retaining the structural read violates the existing contract. An explicit caller `.w(24)` remains an overriding write, even when initially equal; a source map cannot infer a missing caller override. Multiple fixed destinations are already supported, but are not semantic subtree occurrences. Invalid mapped output revokes logical authority while preserving the older complete scene under existing acknowledgement rules. These are source/test observations, not a new test run.

`FlexRecipe` is a sealed lowering of typed flow setters into ordinary property ports. Its optional setters retain whether an operand was supplied, rather than guessing from equal resulting styles. It does not retain a structural recipe. This is the useful precedent for caller write intent.

Questions have sealed Source/Reader/pair input families, exact revisions/tickets, owned frozen work and stale-completion control. Those facts authorize task input/result handling. `Reader::project` is different: its `Fn(&T) -> El` descriptor is consumed during ordinary description, may have short-lived captures, and has no documented general purity/parent independence law. Its stable ready-content position preserves an existing status behavior; it is not a retained visual occurrence certificate. Owning that closure or moving the boundary below the status wrapper would still require a new contract. The proposal does not modify Questions, Pending/Fault behavior or async scheduling.

`ItemSource` promises a coherent pure snapshot only for the current description and retains neither source nor row references. Its ListId/key domain is real identity authority for lists, not a general caller replay program. No existing mechanism inspected here closes structural replay authority without an additive contract.

## 2. Smallest useful opt-in: one component, one caller recipe

Proposed initial shape, **pseudocode; no such API exists yet**:

```rust
// Existing CHILD projection and Child::GROW source stay unchanged.
const LOCAL: LocalComponent<Parent, Child> = LocalComponent::new(
    Parent::CHILD,
    RootRecipe::width(WidthInput::literal(24.0)),
);

impl View for Parent {
    fn sources() -> Sources<Self> {
        Sources::new().local_component(LOCAL)
    }
    fn view(&self) -> El<'_> {
        row(())
            .child_local(LOCAL, self)
            .child(div().w(8).h(24).bg(Color::BLUE))
    }
}

// The ordinary application update is unchanged:
win.set(Parent::CHILD.source(&Child::GROW), true)?;
```

`local_component` registers the existing contained component, its caller recipe and the semantic law below. It replaces that occurrence's component registration; it must not duplicate the same component under a new identity registry. `child_local` inserts a private description descriptor at the current ordered child position. It does not expose an `El` for arbitrary post-child decoration. The parent returned by the method remains an ordinary `El`; its setters affect the parent. No additional visual wrapper node is introduced. During full root description, the descriptor runs the existing typed child projection and handler mapping, applies the recipe to the child's root, and lowers at that same position. Local replay must use that identical composition.

This adds a small descriptor type, registration entry and child insertion method, rather than redefining `View`. It is more application work than a hidden optimization: replace the registration and the one child call; move its supported caller width setter into the descriptor. No child model, source-update syntax, state ownership or renderer API changes are proposed. Applications unwilling to accept the contract keep existing code and behavior.

The first closed recipe is intentionally only a root-width override: absent, literal exact value, or one declared parent `Source<Option<f64>>`. `None` means no caller write, and `Some(width)` means Set(width); this is a closed optional setter, not arbitrary branching. It stores **Set(width)** intent, including Set(24) when the child already has 24, and uses the existing width conversion/admission rules. Both full and local paths apply it after the child description. It must perform the same binding replacement as today's setter; retaining an overridden child width port would be incorrect. No arbitrary callback, root replacement, appended caller children, event/semantic decoration, general conditional program or opaque `Flex` capture is admitted initially. Other cases stay legacy. The child may change its own descendant rectangles; the caller may not supply hidden descendants.

The descriptor is owned/static typed metadata, not a stored borrowed `El`, child pointer or captured parent reference. `child_local` may borrow the current parent only until lowering ends. A Source operand stores its validated typed route, never a pointer to a particular model allocation. Existing component projection agreement and namespace rules still apply. Root kind change, unsupported payload or remint of the admitted root falls back; descendant identity changes use existing rules.

## 3. The indispensable semantic law

For an admitted owner state, let the complete ordered description be

`D(P) = F(P_rest)[ R(inputs, View(child(P))) ]`.

`F` is the rest of the parent's **description**, with exactly one child hole. It is not a cached layout or paint result. `R` is the declared caller recipe. Registration promises that, for an exact edit of an admitted child field with all other inputs unchanged:

1. The hole, its parent/order, the recipe and the rest of the ordered description remain the same. No parent/ancestor or sibling description reads that child state outside the hole, including through aliases or hidden ambient state.
2. The child description is a deterministic read-only computation of its current contained model and admitted immutable inputs. It performs no externally observable work whose omission/repetition changes application behavior. Diagnostics do not grant authority.
3. Every mutable external input influencing the child, caller recipe, placement or surrounding description is an ordinary declared owner input changed through the owner. Other model changes, opaque methods, recipe replacement, resource/Reader status changes and unknown input effects require a full owner turn. Mutable globals, time, random numbers and undeclared service reads do not meet this law.

With these premises, replacing only the hole with `R(inputs, View(child_after))` is description-equivalent to full root execution. This is the minimal substitution argument. An unchanged old `El`, static function pointer, component scope or current style equality establishes none of premise 1. The recipe closes the caller operation; the parent law closes the skipped computation. Both are needed.

This is an explicit safe API semantic contract, analogous to Source/map contracts, **not Rust-enforced purity, an unsafe memory-safety promise, or a proof that arbitrary applications obey it**. A caller that opts in while reading an undeclared atomic can violate it invisibly. The engine cannot promise to detect that read or automatically fall back. If mechanically enforced independence is required instead, a restricted/generated parent description language would be necessary; that larger redesign is outside this proposal. Legacy behavior is the supported choice for such parents.

## 4. External inputs and the same witness

For the external-decoration case, declare a normal parent optional-width Source (for example `CAP: Source<Parent, Option<f64>>`) and use `RootRecipe::width(WidthInput::optional_source(Parent::CAP))`. Register CAP as `field`, not `direct`, in this initial design. Initially CAP=None, preserving the original absence of an override even if the child grows before the external event. An external event must explicitly publish CAP=Some(16) through the owner. That update executes full root description, installs the new caller recipe input stamp and keeps following-sibling layout correct. A subsequent Child::GROW edit replays the child with width16 under that stamp. Declared-input changes are not admitted locally in the initial design, even if a later extension could do so safely.

This migration changes the application's input reporting obligation. It does not pretend to preserve a hidden atomic read that is sampled only when arbitrary parent code happens to run. Keeping that atomic behavior means keeping legacy full-root description. A Boolean compact-mode map could be added later, but is unnecessary: one explicit optional width input preserves both no-write and Set(16) cases without a general recipe language. Replacing the initial no-write with Set(24) would change the original semantics when the child grows before that event, and is not an equivalent migration.

| Case | Existing mechanisms / legacy full root | Proposed single-region behavior |
| --- | --- | --- |
| Child grow changes width24→40 and one→two rectangles | Child `field` runs parent; direct/mapped ports alone cannot change topology | Exact child route runs child once; caller Set(24) is reapplied; new descendants reconciled; parent description omitted only under law |
| Equal caller `.w(24)` | Full root reapplies setter; omission produced 1,152 wrong bytes | Width write lives in closed recipe even when initially equal; output must match full path |
| External decoration16 | Full root reads the atomic; omission produced 1,536 wrong bytes | Atomic version is not admitted; explicit CAP None→Some(16) takes full path, later child edit can qualify; None continues to mean no override |
| Occurrence identity | Component scope does not imply one appearance | Record one existing semantic root + parent/order + namespace and description generation; require exactly one occurrence |
| Repeated/nested appearance | Full root already supports them | No local admission; full root emits all occurrences with unchanged semantics |
| Changed recipe/context, child root replacement or unsupported composition | Full root determines new identity/remint and output | Revoke certificate; full path may establish a fresh one after complete successful admission |
| Invalid width/newer failed preparation | Existing error/older-scene rules | No stale certificate revival; preserve existing committed-error and older Canvas eligibility semantics |
| Hidden input under falsely declared contract | Legacy has no extra guarantee | Contract violation, not detectable general fallback; never claim observation-based safety |

## 5. Runtime facts and failure protocol that would be required

Initial admission is one direct contained component occurrence, directly inserted below the owner root; no repeated/nested component routes, list realization, Reader projection or reader-state transition. The first executable candidate should use the already exercised plain rectangle child with no text/image/gradient or handler payloads inside the region. This is a qualification boundary, not a claim those formats can never be supported. Ordinary outside content continues through full dependency processing. Unexpected content during replay must reject local publication and use the existing full path; this detection is different from detecting untracked Rust reads.

Construction must enumerate occurrence events during full lowering, rejecting multiple occurrences even when both use the same source scope, including a legacy occurrence of that same registered component. A future repeat introduced through a child-dependent parent branch is forbidden by the law, not detectable without executing that parent. Repeats introduced by an ordinary owner change execute full root and withdraw admission. Nested boundary chains cannot be recovered from today's retained innermost `component_scope`; decline them before that information is discarded.

A sufficient pending certificate contains references to existing authority plus new replay facts:

- The existing component schema route, owner/root namespace and semantic component-root identity; parent identity and ordinal context qualified by the predecessor generation.
- Recipe identity/revision and declared input revisions; the exact logical/completed predecessor epochs and source transition. Initially decline dirty/incomplete, coalesced, changed-Reader and nonexact owner turns.
- One old subtree extent derived during real lowering/reconciliation, qualified by that generation. A stored rank is never treated as an identity after unrelated structural edits.
- Pending new range/correspondence facts and owned lowered payloads while reconciliation validates. No permanent duplicate description or copied model is justified by this design.

The last complete description installs occurrence/certificate facts only at the applicable successful preparation boundary. A local turn validates the old authority before using its extent, performs the existing typed source edit, borrows the child during that exclusive turn, lowers child+recipe, then runs identity reconciliation with the real parent context. All retained fanout/handler/style/resource ranks displaced by splicing need repair or reconstruction. Calling an old rank a stable address does not repair them.

The source edit may already be committed when description or preparation fails. Keep existing `SetError::Committed` behavior, revoke local logical authority and recover through the full path; do not pretend to roll the model back. Invalid values/panics are errors under existing rules, not a reason to repeatedly invoke a failing callback. Unsupported but otherwise valid local output may use full root fallback. A failed newer candidate, poison, changed namespace, absent/reminted root, changed recipe/input, replaced owner, or unknown predecessor invalidates admission. An older complete Canvas may remain eligible for acknowledgement; that acknowledgement never reauthorizes the failed local predecessor. No GPU lease or buffer-content version is supplied by this CPU certificate.

## 6. Architectural payoff and costs still owed

The useful output is a qualified structural origin:

`(existing owner/root namespace, exact predecessor, component identity,
  caller recipe/input version, old extent, new lowered extent, correspondence)`.

This can later feed the existing live identity match/remint rules and a subtree journal. It is not a new public semantic identity, and description equivalence grants no layout/paint/resource reuse. The following sibling can move outside the described subtree; identical cold bytes can still produce changed pixels. Keep whole layout/paint and the independent full renderer. A subtree-only damage path remains falsified by the earlier 326-byte witness.

If N is the full tree size, k the child description size, d the explicit recipe input count (initially at most one), and h its ancestor depth, local replay may avoid calling arbitrary parent/sibling descriptions. That does **not** make the whole operation O(k): existing source/schema validation can be global, contiguous splice and positional metadata repairs can be O(N), ancestor/count maintenance O(h), reconciliation indices/layout/paint global, and rendered overlap legitimately large. The current `describe_with_changed` builds whole-tree columns. A partial lowering/reconciliation interface is still required; this design does not supply it or bypass it with diagnostic snapshot reconstruction.

Charge, rather than hide, all new descriptor/registration allocations, occurrence scans and map capacity, recipe/stamp/certificate state, old/new payload coexistence, retained references, failed-candidate scratch, range/identity/fanout repair and global downstream work. Byte sizes, allocation counts and timing are unknown until implemented. A fixed-size descriptor does not establish constant publication work. In a first implementation, one region record attached to the existing component registration is preferable to a new identity registry; every pointer/index and padding byte would still be counted. No eager full-tree mirror is proposed.

The design choice for discussion is precise: retain automatic full-root behavior for all legacy views, and optionally add an explicit single-region semantic contract with a closed width recipe and an opaque insertion point. Existing closed ports remain preferable for fixed outputs. This could establish a genuine structural description origin for the user's connected tree/journal architecture; it does not choose compressed extents or GPU representation and does not repair the inherited cross-backend failure. No implementation or timing campaign begins with this document.
