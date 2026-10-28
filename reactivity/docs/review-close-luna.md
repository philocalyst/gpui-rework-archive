# Bounded consistency disposition

Reviewed the current REACTIVITY.md, MEMORY.md, CONTRACT.md, CONCURRENCY.md, FORMULATIONS.md, and DESIGN.md against the adjudication in CONTRACT revision 2 and the seven-finding closure in review-final-sol.md. Scope is a final bounded consistency check, not another broad design survey.

## Disposition

No remaining cross-layer **design blocker** found. CONTRACT v2 is visibly the authority for its amendments, and DESIGN/REACTIVITY/CONCURRENCY/FORMULATIONS generally use matching source, outcome, presentation, and release rules. Sol's seven counterexamples are reflected in the current text: addressed-site identity, alpha-dependent occlusion, per-instance final snapping, backend-specific certificates, explicit style contribution presence, hover cycle handling, and LCD/component-mask limits.

The remaining work is a set of concrete implementation-admission gates. The clean-room rewrite should not claim end-to-end correctness or the associated performance until these pass.

## Implementation gates still open

### 1. Prove that ordinary bound controls resolve a stable typed source

CONTRACT.md lines 41–54 and REACTIVITY.md lines 16–35 establish the safe mechanism: retain an owner-relative typed projector or stable source capability; resolve a borrowed field while its owner is borrowed; store owner incarnation and field/site identity, never the field address. The owner-scan fallback is explicit and is not misrepresented as exact.

However, the executable API lab proves public El construction and lowering only. Its README explicitly says it installs no permanent signal wire and retains no source pointer. The six compile-fail cases do not exercise text_input(&self.q) or prove a registered projector resolves that borrowed &Signal to the right field. The control-sink examples are therefore still an architectural proposal, not a verified ergonomic path.

Before advertising exact direct-control updates, add one compiling integration fixture covering: a typed field projector and stable source key; &Signal passed through the public view builder; resolution during the owner borrow; instance and owner-generation binding; two distinct same-typed fields; ambiguous/custom projector fallback; field movement/remount; owner retirement; and delivery after the borrow ends. Also show the no-derive manual form beside the generated form.

Until this exists, phrase exact source discovery as the typed-operation fast path; report arbitrary view-bound controls using the conservative registered-descriptor scan or owner-grain fallback.

This is an integration gate, not a contradiction in CONTRACT: both exact typed operations and the conservative fallback are allowed. It does bound what can currently be claimed.

### 2. Fault recovery has the right policy, but must be implemented as one atomic dependency transition

REACTIVITY.md lines 81–114 is substantially more precise than the earlier proposal: evaluate against admitted immutable inputs, collect attempted reads even on fault, replace successful edge sets atomically, retain noncyclic recovery dependencies/provenance on fault, and ensure a relevant structural/producer change can retry the fault boundary. CONTRACT.md lines 79–115 makes L(S) versioned and prohibits presenting stale Ready as current. These do not contradict the two-epoch protocol.

The current wording implies a safe edge rule: only a successful evaluation replaces the prior successful set; a failed evaluation retains that set and subscribes to newly observed noncyclic recovery reads, while excluding rejected cycle edges from Ready propagation. Preserve that union explicitly in the implementation: stage attempted reads and publish edge changes atomically under the graph owner; never mutate live reverse edges during evaluation. This is a testable implementation gate rather than a remaining policy contradiction.

Make cycle recovery observable in a fixture: branch A reads B, B dynamically reads A only under a mode source, the cycle faults, changing the mode removes the edge and both nodes recover; separately test a failed branch that reads a source then panics, abandoned prior dependencies, equality panic, producer replacement, and source retirement. Verify that no stale value is reported Ready, no valid recovery edge is lost, and obsolete queued work is generation-rejected. The current graph evidence section (REACTIVITY.md lines 199–208) already calls for cycles/recovery and branch replacement; this note clarifies their edge-retention oracle.

This is a bounded implementation question, not evidence that the logical Fault model is inconsistent. CONTRACT specifies current outcomes and recovery authority; the edge-install transaction must realize it.

### 3. Keep measurements scoped to what they actually measure

The memory claims are appropriately qualified. MEMORY.md calls itself an experiment/accounting policy, explicitly rejects a measured near-zero native-window claim, counts four ledgers and leases, and requires real-process, multiwindow, teardown, and high-water evidence. DESIGN labels its 0.625 bytes/node topology payload, eight-byte Signal<bool/u32>, and Cephal record sizes as local measurements with excluded costs. FORMULATIONS says the template lab covers scalar data and not a complete rendered widget. API-lab counts construction/temporary allocations and explicitly makes no zero-allocation or sparse-update claim. No unsupported total-memory claim remains in these six documents.

Retain the caveats in any executive summary. In particular, do not turn “no per-node subscription allocation” or “no world matrix for most nodes” into a whole-widget or whole-window memory figure; include source descriptor indexes, instance/site directories, retained layouts, scene/upload pages, image buffers, worker capacity, and OS/GPU leases in an actual total. Existing MEMORY gates cover this.

One minor documentation defect remains: DESIGN.md and FORMULATIONS.md link to a STATUS.md that is not present in /root/gpui-ce3/reactivity/. Remove those links or add the intended status page. It does not block design acceptance.

## NanoUI baseline status

The former open question in research-core.md about which JustRach NanoUI version to inspect is answered. The user identified JustRach as the NanoUI author; this audit selected the pinned dfa7f7ab4e890f643703f4ffe4d834ff10defd4f snapshot (package 0.4.0) as its comparison baseline. There is no user choice pending. Keep the separate MyGo comparison target distinct: the dated NanoUI note identifies a83f75f, while its helper clones moving main; a reproduction must use the dated pinned revision or state the newly selected revision explicitly.

## Final gate order

1. Compile and test typed source binding end to end; preserve owner-scan fallback claims until it passes.
2. Implement atomic staged dependency-edge replacement and the Fault recovery fixtures above.
3. Run the already-listed adversarial identity, graphics, concurrency, and memory gates from review-final-sol.md and the six design documents.
4. Remove or add the missing STATUS page and keep measured evidence labeled by scope.

With these acceptance gates explicit, I find no remaining design-level contradiction that warrants reopening CONTRACT v2. The system is ready for an implementation slice, not yet for a claim of end-to-end runtime parity or performance.
