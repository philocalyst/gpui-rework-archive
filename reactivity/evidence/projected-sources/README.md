# Typed component source paths

Final source/tests/example: `df66f5985d47c1436b0f6a2f3747ae5f9b0ae667`, based on `f102ef111c7214c7ace900f76a74c9d3e7ca14e2`. Producer `/tmp/gpui-projected-source-sol`; external controls/captures `/tmp/gpui-projected-source-captures`; nonshipping control tree `/tmp/gpui-projected-source-control-sol`. This slice is isolated and not integrated by its producer.

`Component::source` composes the child library's existing Source through registered component scopes. The same sealed SourcePath works with ordinary `Win::read`, `Win::set`, source-bound actions and Question inputs. A parent does not duplicate child Signals, field IDs or projector wrappers. Each View still registers its schema once. `component_sources` is an ordinary public Window example with two copies of the same nested counter library, a projected parent action and a Question derived only from the left counter.

The path retains declaration references and its child declaration/path. It retains no model address, resolved field cache, revision identity, window handle or owner. Transient read/set paths may borrow local declarations; retained action/Question paths require static declarations. A whole static path can be borrowed with `&const { Page::LEFT.source(Pane::COUNTER.source(&Counter::COUNT)) }`. Existing Source/Question constructors and ordinary invoke ABI remain intact; FieldAction's new fourth type parameter defaults to Source.

Paths name the current registered field, not a historical child instance. Read returns the canonical logical value, including a committed value whose new presentation failed. Model replacement remains subject to the existing Source stable-projector/direct-registration contract. This is not keyed row authority, automatic dependency discovery or subowner reconciliation. Sources' per-field Boxes and repeated child schema trees remain allocated.

The separately frozen, unmerged SourceTween still accepts root Source declarations. This foundation supplies shared path operations for a later controller successor; that successor must compare resolved scoped current/goal fields rather than local IDs and qualify its own native/retarget behavior. This patch does not claim completed nested animation support.

## Ownership, source and support bill

Seven library files change, physical +277/−53 including comments and one adjusted preexisting unit assertion. The qualified Syn/Tokei counter reports **30696→30878 (+182)** noncomment, nontest first-party library/build lines. Public tests are417 lines; native example125 lines plus four manifest lines. No dependency, lockfile, vendor, unsafe or platform application glue changes.

Ordinary Win remains8B, Option<Win>16B, and Source40B. Borrowing a leaf declaration gives a16B one-hop path and24B two-hop path. The three-hop Question fixture owns a32B path or borrows it with8B. There is no new Win/Runtime/Sources field. Question version packs for ordinary Sources are unchanged; projected inputs carry the qualified FieldId and Revision. Reference delegation preserves the underlying pack, Reader handling and pair reflection.

Matched whole-owner controls use the same physical source/target path, compiler, config, flags, features and fixture. Each switch explicitly cleans the release gpui package. Library and executable artifacts are checked fresh:false; fingerprints include v0, tokio_unstable and emit-stack-sizes. Every before/after source guard matches. Nonshipping fixtures and compiler stack metadata are separate from shipping.

| Control | Owned input/plan/Win | Borrowed input/plan/Win | Constructor allocations/requested/retained/peak |
|---|---:|---:|---:|
| Root Source Question | 40/312/312B | 8/280/280B | Both443 /156197 /27572 /76580B |
| Three-hop, repeated child schemas | 32/320/320B | 8/296/296B | Both428 /143674 /20812 /69786B |

Root fixture update ledgers are identical:2279 allocations,858588B requested,1888B net live,56178B peak. Nested fixture update ledgers are identical:614,248290B requested,2327B net live,54134B peak. These are matched observations within each fixture, not comparisons between the different fixtures. Borrowed plans save inline controller storage; they do **not** save heap bytes in these owners. No field/row memory, RSS or process peak claim follows.

The root fixture deliberately exercises conservative numeric-text snapshots: six coarse owner operations. The nested Question fixture also charges two coarse operations because changed Question status triggers existing conservative owner description even without a displayed Reader. The public no-Question Page test separately proves two exact nested edits with zero owner reruns/descriptions. SourcePath does not eliminate the Question status invalidation policy.

## Matched code and individual stack frames

Root ordinary Source/Question versus f102: linked text −64B, rodata −8B, data.rel.ro unchanged. Action/query/hit/pointer/drain/open/main wrapper code and frames are identical. Source-set wrapper remains233B/frame216. Win::set becomes1380B/frame248 from1745B/frame280, but now calls an extracted Path::resolve304B/frame88. That new validation call/depth is explicitly charged; a smaller caller frame does not prove unchanged aggregate stack or speed. The later after_source_changed216B callee is unchanged. Full assembly and call edges are retained.

Opting into the borrowed root input further changes text −160B/rodata −8B/data.rel.ro unchanged. Main frame1112→1048B; open1080→984B. Nested borrowed versus owned changes text −160B/rodata −32B/**data.rel.ro +64B**, charging static declaration storage too. These are compiler-specific linked sections and static frames, not timings, total stack high-water or latency claims. No inlining attributes were added to production.

## Exact qualification

On final df66: default all-target **546passed/10ignored across72harnesses**; X11 native library **216passed/28ignored**; all12 public projected-source cases; X11 all-target Clippy-Dwarnings; changed-file rustfmt check; installed-source AppleARM64 and MSVC native library checks. Generic RUSTFLAGS/CARGO_ENCODED_RUSTFLAGS are unset. Apple uses root v0/tokio flags; MSVC uses actual windows_slim_errors/+crt-static target flags. Cross checks are compilation, not foreign runtime claims. Earlier fc08 full/default/native results remain separately pinned; library/example source did not change during final gates.

Public tests cover repeated identical child schemas, wrong component and leaf read/write projectors, registration before Question workers, scoped filtering/reflection, old completion cancellation and held credit, borrowed pairs, close rejection, and failed committed text retaining the exact prior complete C token/old P followed by repair. All test receives use a fixed3s watchdog with phase labels; there are no unbounded joins.

The frozen ordinary `component_sources` executable SHA256 is `56e7576e8b71e617f7b4da977285e140ddd6f1223413a49fc7cdeeb66d2330e5`. A real private X11/AT-SPI Registry client invokes original role43 child-left, child-right and projected-parent providers. Left/right/derived finish3/1/6; the right edit leaves the derived left result unchanged. Original actionable provider IDs remain stable and the original child provider is invoked again after updates. Actual WM_DELETE_WINDOW exits0. The guarded replay verifies identical source manifests before/after. There is no private NativeHost seeding or owner-side mutation driving this example. Native hosts/displays are stopped.

Preserved negatives: an initial Question test incorrectly waited while holding completion credit; its fixed watchdog test now explicitly releases/drains that credit. Initial private-version access and reference-size assertion were fixture mistakes. First strict lint found two test-only needless-borrow/size-of-ref warnings; a named borrowed binding and removing the redundant reference-size assertion fixed them without library changes. Real-client failures were successful void replies parsed as JSON and busctl interpreting the negative GetText endpoint as an option; failed clients/logs/trees remain archived, with unchanged90s watchdog and app binary. The first nested owner fixture incorrectly expected exact/no-owner work despite Question status changes; failed owned/borrowed binaries and sources are preserved, and only that nonshipping oracle was corrected to charge coarse2/owner2.

`shipping.patch`, `tests.patch` and `example.patch` are independent path subsets from f102 to final df66; no standalone Cargo override is needed. `authority.md`, `summary.json`, compact frame records, actual source/config guards, fingerprints, commands, fixtures and failures are archived. Large frozen ELF/full ELF inventories remain external with hashes in the capture manifest. No native timing or performance adoption is claimed.
