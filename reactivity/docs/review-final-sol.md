# Independent final design review — Sol

Reviewed 2026-10-20: `/root/gpui-ce3/reactivity/{DESIGN,CONTRACT,CONCURRENCY,GRAPHICS,FORMULATIONS,PLAN}.md`. Code and main documents were read only. CONTRACT revision 2 is the controlling amendment; obsolete PLAN draft rollback language is intentionally excluded. The parent was editing these documents during review, so findings below distinguish corrected text from remaining admission decisions.

## Result

The architecture has a coherent reduction: immutable shared structure and local geometry, explicit dynamic regions, sparse typed contributions, disposable revision-keyed indexes, one mutable source owner, and leased immutable presentation. The mathematical candidates generally state the restrictions their proofs need. None of these documents or supporting experiments proves a complete GUI, area antialiasing, GPU equivalence, or competitor performance superiority, and the current text correctly avoids those claims.

I found seven correctness gaps. All seven now have precise document corrections, checked against the counterexamples below. There is no remaining design blocker from this review. There is a justification for making these counterexamples mandatory integration gates: they cross exactly the boundaries where individually valid reductions can compose incorrectly. This is design acceptance, not implementation acceptance.

## Additional findings closed in the final adjudication

### P1: geometry-changing hover needs an explicit authority and cycle policy

CONTRACT originally permitted an active state overlay above instance style without selecting the semantics when that overlay changes layout, transforms, or hit eligibility. A generic causal-wave budget attributes a loop; it does not decide which hit snapshot authorizes hover or what presentation should survive it.

Counterexample: the pointer is stationary at x=5; a box occupies [0,10]. Hover translates the box by +20, or shrinks its width to 1. The next hit says not hovered, removing the style and returning the box beneath the pointer. Re-hit sets hover again. Recomputing hover after every publication can alternate indefinitely without another physical input.

The corrected CONTRACT now supplies the required decision:

- Hover derives from an admitted pointer sample and authoritative presentation hit snapshot; post-publication re-hit is bounded.
- A repeated pure-style target/geometry configuration diagnoses and suppresses that contribution's geometry-changing part for the pointer turn, recomputes from the noncyclic base, retains valid paint and schedules no idle re-hit loop. New physical input or independent geometry change starts a new admitted evaluation.
- Committed arbitrary application hover handlers instead follow the causal-budget/fault policy and cannot be rolled back as a style.
- A paint/composition fast lane must prove hit invariance. Stationary-pointer move, resize, removal, transform and animated-boundary cases are explicit tests.

Disposition: closed at the design level. This is a deterministic feedback policy, with a clear distinction between disposable pure style and committed application mutation. Integration must preserve that distinction when emitting enter/leave operations and attributing faults.

### P2: LCD/component coverage is outside the scalar filter-pushdown proof

FORMULATIONS proves alpha-preserving matrix pushdown for premultiplied RGBA source-over with scalar transmittance. GRAPHICS also permits capability-dependent LCD text. The generic “incompatible blend” restriction is sensible, but this specific incompatibility must be an admission gate rather than something implementers infer.

Let M swap red and green, and let the component coverage operator be C=diag(1,0,0). For red paint:

```text
M(C red) = green
C(M red) = black
```

A post-coverage group color matrix therefore cannot in general move into paint before an LCD mask. Component-dependent destination transmittance likewise is not the scalar `(p,t)` source-over action.

GRAPHICS now distinguishes scalar summaries from component compositing in packet typing. FORMULATIONS explicitly admits component masks only with a commuting-operator proof; otherwise it retains the post-coverage filter or chooses grayscale, and includes this counterexample in backend tests. Disposition: closed at the design level. This is a boundary of the proof, not a counterexample to the scalar proof itself.

## Findings corrected during this pass

### P1: public target identity could not be a template preorder address

An insertion inside sibling A changes sibling B's preorder number even when B's complete parent/child-ordinal/kind path survives. Rejecting B solely on template revision revokes a surviving identity; accepting the old number can address another node. Unkeyed insertion of same-kind children also cannot silently preserve identities by the new ordinal.

DESIGN “Identity exists at crossings” and CONTRACT “Typed schemas, override order and admission” now select sparse addressed-site slots with generations. Internal NodeAddress is revision-local. Reconciliation remaps surviving addressed sites, while an affected unkeyed run/suffix is revoked under the explicit sequence edit contract; List slots preserve reorder identity. Inspector traversal does not mint permanent sites until retention is needed.

Required implementation gate: retain a target, focus/capture and queued worker operation to B, insert inside A, and prove B survives while a replaced site cannot be rebound by ordinal reuse. Include failed reconciliation, instance retirement and stale site generations. The template lab's append-only identity is correctly identified as a narrower experiment.

### P1: reusable coverage did not imply reusable occlusion cuts

An opaque red foreground over blue can suppress the background in a disposable worklist. Changing its alpha to 0.5 must produce `(0.5,0,0.5,1)`, not `(0.5,0,0,0.5)` from a permanently discarded background.

GRAPHICS now keys bins/predecessor cuts/effect summaries on resolved alpha, group opacity, clip coverage, material opacity and sampling footprint. The canonical scene retains suppressed commands. RGBA/opacity property impact includes occlusion dependencies; an RGB-only or runtime alpha-equality cutoff can avoid unnecessary invalidation. A zero-opacity-to-visible transition has the symmetric admission requirement.

Required implementation gate: opaque→translucent→opaque and invisible→visible changes across clips, group opacity, texture-alpha residency changes and backdrop barriers; compare incremental reconstruction with a cold full scene.

### P1: shared unrounded layout does not imply shared snapped geometry

Rounding each absolute endpoint of a width-0.6 box gives width 1 at origin 0 and width 0 at origin 0.6. A key containing local constraints, device scale and rounding policy alone cannot share both final snapped answers.

DESIGN now explicitly shares unrounded local solutions, applies final snapping after instance/device placement, and includes placement phase if snapped answers are cached. Paint, hit and accessibility consume the same final policy.

Required implementation gate: equal local solutions at fractional origins, scale changes, negative coordinates and parent placement changes. Compare baseline, cluster/caret bounds and accessibility as well as outer rectangles. The current unrounded Cephal adapter is honestly scoped.

### P1: a CPU certificate does not certify a narrowed backend shape

The executable coverage experiment certifies its own admitted f64 domain. It does not certify an f32/FMA/UNORM backend by sharing a transform revision.

A concrete parameter narrowing case, checked locally:

```text
r = sqrt(2) + 2^-30  = 1.4142135633044177
f32(r)              = 1.4142135381698608
f32(f32(r)*f32(r))  = 1.9999998807907104 < 2
```

The CPU real circle strictly contains every corner of [-1,1]^2. The circle represented by the narrowed radius excludes those corners; an f32 shader's precise test/order can introduce a different additional decision. A CPU interior proof cannot authorize every such backend implementation.

GRAPHICS now makes certificates backend-numeric objects keyed by parameter encoding, mapping, precision/FMA, coverage rule and scale. Parameter/matrix quantization, arithmetic, AA and sampling/filter footprints must have outward envelopes, or certification must run over the backend's admitted representation. Otherwise it refines.

Required implementation gate: near-boundary quantization plus nonuniform/sheared maps, threshold ties, underflow policy, FMA alternatives and final AA footprints. A same-revision check is necessary but insufficient. No blanket “GPU equivalent” claim should precede this gate.

### P1: equality-to-default compaction cannot erase a style contribution

For library padding 4 and theme 8, instance Set(4) must remain 4. Clearing the equal-default value would incorrectly reveal 8. An explicit instance Set(8) also must remain 8 when the theme later changes to 10, even though its initial resolved value equaled the theme.

DESIGN and CONTRACT now retain `Inherit | Set(T)` independently of value equality. Reset removes the named layer contribution. Destination equality can skip a patch while preserving contribution presence and provenance. The template scalar experiment's equal-default elision is explicitly an unlayered fixed-default specialization.

Required implementation gate: all precedence layers, Set(default), Set(currently_resolved), lower-layer changes, Reset and constraint failure. Test transform composition and additive/composed fields separately from replacement fields. Dense/sparse promotion must preserve presence and origins as well as final values.

## Mathematical and systems checks that held

- The canonical support identity `h(AK+t,u)=h(K,A^T u)+u·t` is valid for singular A and avoids repeated world-AABB inflation. Finite angular sampling is correctly not called exact arbitrary-direction support. Outward bounds and effect/AA inflation remain obligations.
- The exact bounded i128 translation specialization avoids the discovered f64 reassociation failure. The general affine path retains reproducible composition order. Subtracting the large viewport origin before narrowing is necessary, not a generic cure for prior floating-point cancellation.
- The interval SDF classifier is a valid conservative method over its admitted representation. Boundary refinement, point-versus-area coverage, singular/ill-conditioned fallback and sampled-field epsilon are explicitly separated. Its measured boundary-dense loss is reported.
- Scalar premultiplied source-over is an affine ordered action in real arithmetic. Group opacity is correctly not distributed over overlapping children, and real associativity is not used to promise finite-format bit identity.
- Alpha-preserving linear matrix pushdown is valid under the stated scalar-coverage, linear-format restrictions. External background remains outside the group transform. Clamp, quantization, nonlinear transfer, backdrop dependence and incompatible composition invalidate the rewrite.
- Gaussian variance fusion and the rectangle CDF formula describe ideal continuous convolution. The documents correctly reject bit identity with arbitrary truncated kernels, specify the discarded-mass bound, include approximation/arithmetic/sampling error and require downstream error propagation. The formulas do not establish a final area-AA quality contract.
- Convex support containment can eliminate a hard clip; soft ramps, AA inset, effects and uncertain support are retained. Old/new damage plus backward dependencies correctly accounts for removal, filters and backdrop reads.
- Private memo state and immutable publication remove foreign-workspace rollback without claiming rollback of arbitrary source mutation. The revision-complete cache closure and poison policy are necessary and stated.
- Identity generations, source versions and actual CPU/GPU/OS leases are correctly separate. A removed instance revokes future authority; an already submitted leased resource must still retire under the lease protocol. The resource-residency wording should always be read that way.
- Bounded queues, result inbox admission, skipped-snapshot damage accumulation, ready-hint/wake ordering and shutdown have explicit protocols and independent model/oracle gates. Queue wait freedom is not inflated into a whole-frame claim.

## End-to-end acceptance decisions

The backend seam is now an explicit part of the design. The promised O(changed descriptors) transform/paint update only survives when the backend retains geometry, groups, surfaces or stable slots. A flattening backend still pays its primitive traversal and upload. Native composition likewise requires negotiated clip, filter, z-order, transaction and buffer-release support. These are appropriately measured capabilities rather than assumed consequences of the data structure.

Before adoption, pin one baseline numerical/quality profile and run the counterexamples above against it. Its encoding, composition order, alpha/color range, snapping, AA/reference tolerance and fallback must be versioned inputs to applicable caches/certificates. This is an integration choice still to execute, not evidence that the current scalar labs already satisfy it.

Keep the winning and losing regions visible: static template sharing versus high-density overlays/unique shapes; analytic certificates versus tiny boundary-dense controls; local/group updates versus a backend that repacks; shared unrounded solutions versus unique measurements and phase-dependent output; demand-start services versus cold first-frame cost. No reduction here is universal, and the documents now mostly preserve that distinction.

The review requests no additional broad framework feature implementation. All seven reported decisions are now covered. The next work is to make these specific fixtures part of the first end-to-end integration slice, pin its numerical profile and evaluate the retained backend capabilities. There are no remaining blockers to accepting this design as a proposed architecture with explicitly unproven integration gates.
