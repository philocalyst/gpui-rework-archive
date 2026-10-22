# Checked Part borrowing control

Source `6654378606c052bb39c9338e85441e98b5b86835` changes only query.rs:
visitor-local Part index becomes usize, Win.visit iterates the actual borrowed
Context slice length, and small target() exposes its body with inline. It keeps
checked indexing, ordinary API/behavior and measured 16 B Part; this is not an
ABI guarantee. No unsafe, row mirror, sidecar sorting, or retained field is added.
The official shipping core is 29,110 code lines including 13 build lines (+1).

The matched release baseline is final A shipping source86dd plus evidence-only
8ba; it is not a retag of the earlier eace artifact. Both clean worktrees use
the same external 32-row client, package versions, x11/defaultsimd features,
toolchain and release profile (debug1, otherwise defaults). Digests, raw
manifests/locks, build logs and complete selected bodies are included. The
immutable binaries remain at /tmp/gpui-ack-query-comparison/{a,usize}/client.
Both produce checksum96262292106. No timing was taken.

| Complete body | A bytes | usize control bytes |
|---|---:|---:|
| Public visitor wrapper | 171 | 337 |
| Public visitor inner helper | 322 | inlined into wrapper |
| Part.target | 84 | inlined into consumers |
| Sites.target(identity) | 38 | 38 |
| Native project visitor | 1,104 | 1,066 |
| Native Cohort.append | 7,125 | 7,173 |
| Native projected_node | 2,670 | 2,745 |
| Native project | 1,264 | 1,264 |

The ordinary visitor's former per-row and Part.target row checks disappear.
The remaining loop call resolves to Sites.target(identity), which takes no row
index and contains no row bounds check. The native projected_node still checks
an arbitrary borrowed Part once at entry; this is not an all-native zero-check
claim. Inlining grows some native bodies; none are omitted from the comparison.
Whole linked text is 21,730,081→21,729,037 B. Body/layout differences do not prove
a runtime speedup. No hidden moved helper is counted as a size reduction.

Default-feature qualification passes130 library cases/5ignored, 32 ordinary
query/semantic/metadata/serialization/text-geometry cases, and strict all-target
Clippy. The first command misspelled the `queries` target; its Cargo rejection
log is preserved and is not a gate. Header probes show Part16, Node40,
Presented80, TextSite80, Prepared40, Runtime1824, Metadata264 and Handler16.
All allocations and P/C/failed-L epoch ledgers remain the A values.

The final A full-feature/native/foreign-compile campaign remains separately
qualified. This control compiled real native projection into the release client
but does not claim a new native protocol/foreign runtime run. Root integration
can qualify its combined source independently. Raw client manifests are flattened
originals: reconstruct src/main.rs from adjacent client.rs in scratch space and
provide the exact pinned worktree paths before reproducing.
