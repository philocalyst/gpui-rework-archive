# Exact changed-glyph support, then sparse retained repair

Registered before implementation. Local baseline 957719565444c9900c6e6c20916a6fb88c933395
is the qualified but performance-failed local-publication trial. Its immutable
control 6895a10440 and dossier 9725cfa2679d remain unchanged. Image placement is
corrected in both. Scroll-copy is absent. Application calls remain unchanged.

Post-verdict work-counter diagnosis (existing-counters.json) finds 7.921545% more
composited pixels in every pair of both stream modes: Canvas sparse text currently
unions all old/new glyph bounds, whereas full-scene damage skips equal commands.
This is a work hypothesis, not proof of timing causation. Tightening a single
rectangle may still cover large gaps between changed glyphs.

Research anchors: BBTree 1b0201087102f81189da0c4cd5054a91c8d97d62 batch runtime overlaps
independent descents and invalidates speculative authority before ordered mutation;
https://github.com/XiangpengHao/bbtree. Solid ff4d3c4479163fbdd3327f5b22d0c3ea7bd1a2c5
separates dependency scheduling, held values and publication; its article
https://www.solidjs.com/blog/async-solid-fetch-high-block-low explains starting
independent work early and delaying the narrow dependent boundary. Ripple
fed124465d162ce17ce009936ef50061719d9882 reuses dependency links and skips unchanged
versions, with explicit live/version checks before effects. None establishes Rust
View purity or permits a no-op-waker runtime for arbitrary application tasks.
The transfer tested here is exact local invalidation surviving through submission,
not an assertion that B-tree operations and UI updates are identical.

Stage A, diagnostic/correctness only: compare equal painter-order glyph positions
using existing remapped immutable mask identity, exact local rectangle bits and
bounds. Common map/color/clip equality and resource lifetime guards stay unchanged.
Expose additive Canvas observation of differing old/new support after all fallible
admission, before commit. Existing try_patch_text stays source compatible. Keep
paint-slot support conservative. No hashing, tolerance, masked failures or new
unsafe code. Record exact changed support counts, union area, disjoint pixel union
and 16px tile union on the actual 80-update Workload, both stream modes and existing
scroll/mixed/fractional fallbacks. No timing selection at this stage. If actual
support remains broad, stop this mechanism and retain the result.

Stage B, only after Stage A demonstrates strict sparse work reduction: pass bounded
sparse repair through the native bridge and retained GPU. Canonical packet work may
remain complete initially. A certificate must name the exact predecessor token,
be discarded for coalescing, stale packets, failed preparation and resized images,
and preserve complete canonical scene, semantics and ACK order. Full render is the
fallback. Regions must be nonoverlapping so transparent contributions are not
reapplied. No swapchain preservation assumption. Keep representation/cold allocation
cost explicit and isolate sparse GPU submission from ordinary one-region code.
Freeze a concrete Stage B representation and cost protocol before implementing it.

Correctness gates: public Canvas exact changed bounds and full-pixel equality,
unchanged run, repeated edits, placement/transform/raster-scale changes, clip edges,
new resource rejection, last-use retirement, paint-slot patch after text edits and
failed-newer candidate/old ACK. A bounded omitted-support mutant must fail pixels.
Whole GPUI+Canvas default/X11 suites, strict Clippy, 10 port tests, 11 native scripts;
GPU support needs all supported target formats and stale-token/resize/failure tests.
Freeze each clean source before gates; preserve all-input guards, actual artifacts,
failed attempts and any changed acceptance protocol. Unique target, >=8GiB free.

Future cost acceptance remains >=20% complete stream AND owner-stream improvement
against the original control and <=1.05 on every existing ten-case control and
against the failed predecessor. Add small-text controls (0/25/1000 unrelated nodes,
one/two/four edits and owner routes) that defeated previous tile experiments. Their
concrete matrix/order must be committed before timing; do not pick only large wins.
Separate allocations and cold work; charge code/stack/headers/capacity/shader costs.
No measurement overlaps builds/tests/cleanup. No ZGX/hardware claim from llvmpipe.
