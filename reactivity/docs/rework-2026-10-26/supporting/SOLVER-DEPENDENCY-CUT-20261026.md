# Solver-owned value propagation, not an eager Layout SCC

Source-only review; no compiler, solver execution or performance qualification.
Source root: invalidation-lane/canonical-change-source/reactivity.

## Immediate finding

Cephal already owns dynamic parent/child question dependencies and value-change stopping. `vendor/cephal/src/schedule/mod.rs:165–239,274–310,331–351` replays a dirty node's cached LayoutInput questions, compares old/new LayoutOutput, and propagates None / Overflow / Full. The new GPUI graph's parent Layout↔child Layout SCC eagerly dirties the entire connected tree before that machinery can stop. A smaller first cut should preserve the real solver authority rather than precompute an approximate second CSS dependency graph.

## Actual inputs and answer distinctions

- `tree/input.rs:80–100`: question includes run mode (size-only vs final layout), sizing mode, requested axis, assigned known border-box dimensions and definiteness, percentage parent basis, available space, margin-collapse flags, formatting context key.
- `tree/input.rs:145–183`: size answer strips overflow and out-of-flow flags. Parent-observable final answer includes size, baselines, margin-collapse sets, through-collapse flag, OOF bits. Overflow propagates only on visible axes when child is neither scroll container nor contained. **Fixed size alone does not imply no parent read**: baseline and overflow can still change.
- `schedule/mod.rs:331–351`: exact unchanged answer stops. Same nonoverflow answer with changed visible overflow becomes Overflow; clipped/nonpropagating overflow can be invisible to parent while stored layout is still patched.
- `schedule/mod.rs:215–227,243–270,354–395`: overflow-only parent work gathers contributions/OOF rather than rerunning full parent in-flow algorithm. Changed OOF boxes notify actual containing block, not necessarily tree parent.
- `schedule/mod.rs:274–310`: missing/evicted cached answers, newly observed axes, unstored speculative questions, shared block context/margin questions conservatively propagate Full. Preserve these falsifiers.

## Parent/child distinctions actually supported today

1. **Intrinsic child answer→parent**: scheduler replay, not unconditional graph closure. If a measured text's answers retain size/baseline/overflow, parent is not scheduled.
2. **Assigned parent constraint→child**: the parent algorithm asks actual ChildRequests; cache answers are keyed by LayoutInput. No need to pre-mark every descendant to force a query that the algorithm already issues.
3. **Child STYLE→parent**: preserve core adapter guard. `crates/core/src/layout.rs:289–305` marks changed child plus immediate parent because flex basis/order/etc are read directly outside child's cached I/O. Do not delete this edge based on unchanged child size.
4. **Cheap unmeasured empty leaf→parent**: preserve `mark_dirty:332–341`; cheap leaves have no vendor cache and must redirect invalidation to parent.
5. **Placement vs measurement**: `compute/flex/final_pass.rs:16–33` asks final child layout with assigned target size, then places it using running offsets, margins/insets, and line offsets. Sibling main-size/order changes can necessarily reposition later siblings even if their measured size is unchanged.
6. **Overflow/scroll extent**: `compute/common/overflow.rs:12–45` contributes translated border box or visible overflow according to actual child overflow/containment and parent scroll origin. A fixed-size Scroll box may stop parent extent propagation but its own scrollable extent still needs update; do not conflate those answers.
7. **Fixed single-line stretch**: `compute/flex/cross.rs:25–37` explicitly states a fixed line cross size makes stretched child measured cross size unread/unasked. This is a real omitted read, not a CSS guess. Baseline computation/final pass may still read other child outputs.
8. **GPUI policy subset**: runtime.rs `layout_style` uses Flex, literal optional sizes, zero flex_shrink, configured direction/align/justify/wrap; list/scroll adapters introduce absolute row positioning and viewport flex behavior. Treat generic core Grid/Block/OOF separately; no blanket fixed-size cut.

## Bounded next implementation cut

**A. Restore direct-owner scheduling first.** Stop eager cross-site Layout/Measure/TextLayout closure from pre-dirtying all ancestors/descendants. Keep actual changed-site seeds, local source→Shape→TextLayout→Measure facts, direct List Height/Box→Realize facts, and separate parent Placement/Clip dependencies. Call existing LayoutTree set_style/mark_dirty on direct changed owners; preserve immediate parent/cheap leaf safeguards and topology edit parent guards. Existing full present remains; do not claim sparse raster.

**B. Feed actual execution results back into shared change algebra.** Add optional bounded dirty-result sink in core adapter where `set_unrounded_layout` already compares old/new (layout.rs:784–794). Emit typed changed assigned size / local location / scroll extent / baseline facts only on actual difference. If sink capacity fails, full conservative reason; do not fail already-mutated layout or roll back old P/C. For full question-answer dependencies, instrument solver's `answer_changed` rather than infer from final Layout alone (size-only cache answers may differ independently).

**C. Keep a provisional distinction explicit.** Before complete solver read instrumentation, logical closed receipt can represent direct input seeds plus a conservative 'solver-derived layout complete' boundary, not assert every affected owner was known before solving. Missing complete derived receipt must force full canonical snapshot/diff, not make slot-only publication eligible. Existing full immutable presentation can resolve output changed groups, but that is not proof of fine-grained solver selectivity.

No second persistent topology, per-node LayoutOutput mirror, or unconditional extra full scan is needed. Existing cache question records and old/new write values are the evidence. Sink may borrow vectors until successful C; failed newer retains old C/ACK while working solver state follows existing poisoned/repair rules.

## Cold-oracle and work gates

Use actual LayoutStats computed_answers/cached_answers/measure_calls/changed_layout_writes, not GPUI layout_runs alone. Compare all cold layout fields, not just size: local location, content/scroll extents, borders/padding, baselines where exposed; then public rows/full pixels/targets/P-C/ACK.

- Deep unrelated sibling branches: fixed-box text content changes with equal old/new size/baselines; direct leaf recomputes but unchanged ancestors stop. Vary unaffected subtree size to expose eager SCC regression.
- Necessary propagation: auto-size child text grows; parent auto-size and following sibling position must change exactly cold.
- Fixed-size container with overflow-only content change: own scroll extent updates; nonpropagating scroll boundary stops ancestors; visible overflow control propagates gather.
- Baseline control: fixed size + baseline-aligned row, changed baseline must NOT be skipped.
- Stretch/no-wrap fixed cross axis vs wrap/auto cross axis; only actual unasked cross measurement may disappear.
- Cheap empty leaf style change must still affect parent/siblings.
- Parent style reads (direction/wrap/align/gap/child size) and reparent/reorder/insertion/removal must retain existing EditPlan/inverse witnesses and cold output.
- Cache eviction/unstored question, requested viewport/scale change, hidden subtree, OOF containing block, generation rollover retain conservative fallback.
- Failed newer solve/paint + old eligible C ACK + later valid repair remains mandatory; no mutated working layout is presented as completed-image authority.
