# Adversarial review and disposition

Sol agents implemented isolated ownership, tree/layout, template, algebra,
coverage and API spikes. Luna agents audited primary library/academic/platform
sources. The integrating agent read the final public types/diffs and tested the
combined workspace. Reviews are preserved as dated reports; some describe bugs
in an earlier snapshot. This table is the current disposition, not a claim that
every future integration gate is implemented.

| Finding | Disposition | Evidence or required next gate |
| --- | --- | --- |
| Tiny damage vanishes when f32 endpoints add | Code fixed with widened endpoint arithmetic | Boundary/sub-ULP damage regressions |
| Transform chain underflows before later recovery | Wide reproducible oracle mapping; uncertainty conservative | Tiny-scale recovery and overflow tests |
| Hit candidate repeats every ancestor clip | Single traversal clips once and prunes subtree | 20k-depth linear visit regression |
| Failed layout exposes partial public geometry | Poison blocks compute **and reads** | Measurement panic public test |
| Four-byte inline Signal magically enqueues | Explicit changed-owner descriptor scan versus exact typed operation | CONTRACT/REACTIVITY; permanent view-source binding remains integration gate |
| `DerefMut` returns a drop guard | Mark before actual `&mut T` | Compiled Signal primitive and overflow tests |
| Context-free view silently borrows a frame arena | Owned description/borrowed operands; only internal lowering generative | API lab passing and intended-diagnostic fixtures |
| Arbitrary handler/source rollback versus derived failure | Versioned source-commit/outcome semantics | CONTRACT v2; typed batches only where staged semantics exist |
| Foreign Cephal inverse journal | Private memo workspace plus immutable published answer | Cold-layout oracle and poisoning implemented; shared sheets still integration gate |
| Request accepted then candidate fails | Accept once into committed retained inbox | Runtime integration test required; primitive acceptance alone is insufficient |
| TypedField can forge get/set/impact | Utility remains untrusted; library schema owns validation/impact | Component/inspector schema integration gate |
| Public Target tied to changing preorder number | Sparse addressed-site identity; revision-local NodeAddress | Surviving-sibling remap/replacement tests required |
| Equal-default overlay loses explicit style Set | Separate Inherit/Set contribution presence | Theme/reset adversaries required; scalar lab scoped to unlayered defaults |
| Shared layout omits absolute snap phase | Share unrounded answers; instance final mapping/snap | Fractional-origin paint/hit/a11y test required |
| Alpha patch leaves hidden background pruned | Opacity-keyed worklists disposable; canonical commands retained | Opaque/translucent/zero-visible cold-scene oracle required |
| f64 CPU proof certifies different f32 GPU geometry | Backend-specific numeric/error envelope | Actual shader/AA/color profile tests required |
| Hover geometry moves itself into a cycle | Authority/re-hit cap and pure-style versus handler fault policy | Stationary pointer and animated-boundary gates |
| LCD mask violates scalar filter pushdown | Component operator proof or retain filter/grayscale | RGB-swap/red-mask counterexample gate |
| Arbitrary affine regrouping changes coordinates on query | Reject unrestricted f64 link-cut for geometry truth | Executable cancellation characterization; exact translation proof/tests |
| Wake clear-before-drain alone seems sufficient | Successful producer/coalesced AcqRel RMW, acquiring acknowledgement | Corrected host; positive Loom models and four bad-protocol witnesses |
| Generation mistaken for memory reclamation | Move-only page ownership and actual CPU/GPU/OS leases | CPU transfer/drop tests; real fence/import/shutdown integration gate |
| Fault read-set update loses recovery | Atomic staged prior-success union attempted noncyclic recovery reads | Graph cycle/mode/panic/retirement oracle required |

Primary reports:

- [Initial Sol primitive review](docs/review-sol.md), before the numerical/hit fixes.
- [Luna contract review](docs/review-design-luna.md), before CONTRACT revision 2.
- [Sol ownership/weak-memory review](docs/review-design-sol.md).
- [Luna concurrency adjudication](docs/review-concurrency-luna.md).
- [Sol seven-finding final review](docs/review-final-sol.md).
- [Luna bounded closure](docs/review-close-luna.md).

The last two reviews report no remaining architectural contradiction after the
amendments. They explicitly require the first integrated production slice,
backend numerical profile, fault-recovery edge oracle and source-binding proof
before implementation/performance acceptance. [STATUS.md](STATUS.md) and
[TESTING.md](TESTING.md) keep that boundary visible.
