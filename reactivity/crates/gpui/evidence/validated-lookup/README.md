# Reusing one validated logical index: held

The isolated source `b25b45f2c11db024083749d0dcdd8080333a7b10`
returns a target's identity and logical index together, then reuses the index
inside the same exclusive operation. It retains the production BTree and every
namespace, quarantine and realized-row admission check. No index survives a
reconciliation or becomes a public capability. The original control is
`b15133e90de3925fcb4aeaa4ffb18d413a3bf0f7`; both contain the same measurement
fixture. Production source has not adopted this change.

This is the narrow attribution control for the map-free index experiments. It
separates removing repeated lookups from changing the lookup data structure.
The source commit records passing complete GPUI and strict native Clippy gates;
this evidence cut adds no new implementation or native runtime coverage.

## Capture admission

`admission.json` preserves both complete campaigns. The first
`serial-20261021` is excluded before inspecting its metrics: a peer immediately
paused a just-started build, but overlap at the first launch cannot be ruled
out. It must not be pooled with the accepted run.

The complete replacement `serial-quiet-20261021` ran after all heavy peer jobs
were explicitly held. It contains seven alternating-order fixture pairs
(1,260 rows) and five pairs of three application processes, each with three
internal batches (750 rows). Processes are pinned to CPU 2. The capture takes
21.27 seconds. No faster subset or alternate successful capture was selected.

`capture.py` checks the exact source HEAD, tracked-tree cleanliness, fixture SHA
and frozen executable SHA before each launch. `frozen.json` records toolchain,
Cargo.lock and executable paths/hashes. This runner does not reject untracked
inputs; its only new files are this evidence directory, outside Cargo source
targets. Later three-way controls in `evidence/option-lookup` use the stricter
untracked-input guard. The distinction is preserved rather than retroactively
claiming the stronger protocol here.

Each summary reports the median of per-round candidate/baseline changes and
the minimum/maximum round ratio. Application rounds first take their three
internal-batch medians. Small fixture mounts are noisy. These are owner-operation
CPU controls, not native startup, click-to-pixel, GPU or scanout measurements.

## Result and decision

At 4,096 nodes, focus-first improves 33.99%, 36.16% and 50.90% for contiguous,
gapped and permuted identities. Focus-last improves 45.37% and 46.17% for the
first two patterns. Property-first improves 6.34%, 4.30% and 14.21%. Those are
useful local gains, but application operations expose a repeated cost:

| Application control | Median paired change | All round ratios |
| --- | ---: | ---: |
| First two-style override | +4.15% | +3.61% to +5.14% |
| Warm two-style override | +5.36% | +4.28% to +5.50% |
| Warm zero-style override | +1.82% | -0.48% to +2.02% |
| Zero-style equal refresh | -2.75% | -3.03% to -1.72% |
| Library scroll | -0.96% | -2.22% to -0.21% |

Every fixture and all 25 application cells remain in the reports, including
losses and near-zero changes. No cause is assigned to the override regression;
removing BTree searches alone does not prove an application speedup.

Allocation counts, requested bytes, retained bytes and peaks remain equal
between variants for every matching fixture cell and round. Focus/property
operations allocate nothing. There is no owner, node or presented-sheet layout
saving. The production Runtime remains 2,384 bytes, Node 40 and Presented 80.

Hold the source. The later optional-index ABI experiment also failed the wider
application controls; it is not a repair adopted on top of this cut. Reproduction
requires detached worktrees at the exact frozen source pins and SHA-matching
executables. Do not weaken the HEAD guard or overwrite the accepted output
directory after committing this evidence.
