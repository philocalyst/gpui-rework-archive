# Stage B: bounded conservative regions and exact predecessor authority

Registered after Stage A, before this implementation. Stage A source 5c7bf163d78461ad096448cecfeadfa2ff9d4576
passes two public Canvas regressions, six public GPUI publication regressions,
actual 80-update admission in each streaming mode, and strict X11 all-target Clippy.
Raw diagnosis: 34–38 old/new rectangles, median bounding area 99495, exact support
2891 and tile support 11520 pixels. No timing conclusion; Stage A unit diagnostics
allocate test-only support vectors and must not enter a timing binary unchanged.

Use conservative rectangle merging, avoiding a canvas-sized tile allocation.
An additive Canvas DamageRegions value starts as one inline DamageRegion, with no
allocation. On a disjoint second region, allocate capacity for 64 regions. Merge
intersecting/touching regions into their bounding rectangle, restarting the scan
because a merge can intersect an earlier region. Kept rectangles remain pairwise
separated. At 64 disjoint regions collapse to one bounding rectangle and stay in
that state for this update. The bound limits command count and work per observation;
it is fixed before measurements, not a threshold selected from timings. Merges
may conservatively include gaps; measure their actual area. No requirement that
this representation equal the exact mathematical union. Empty observations stay
empty. Public construction cannot manufacture overlapping entries or unchecked
coordinates. CPU-only text patch uses no region builder.

Native-only cold TextPatch holds the regions and exact from/to PresentationTokens.
No retained field on Runtime, Canvas, GpuSurface or Renderer. SceneDamage may gain
one borrowed pointer; charge its common-stack/header cost explicitly. Expose the
repair only while its to token is the complete scene token. Full candidate creation
retires it, coalesced paint changes fail to-token matching, ACK drops the text patch.
The native bridge also requires the actual packet's predecessor token and coherent
epoch. A base source epoch alone never grants reuse. Older eligible C after a
failed newer preparation must remain valid. Ordinary fallback remains complete.

GPU retained output uses a mutually exclusive Full/Region/Regions descriptor rather
than simultaneous optional fields. Keep the existing ordinary submission path and
outline multi-region submission. Sparse submission loads the backing, sets each
nonoverlapping scissor and draws the complete canonical packet, then copies the
complete backing to the fresh target in one command buffer. All packet preparation
remains complete; no persistent second scene, resource map or packet patch is added.
One region uses the ordinary path. Invalid/resize/lost-image state forces full repair.
All entry points validate targets/coordinates and revoke authority before mutations.
Stats report the sum of actual scissor areas, full presentation copies and unchanged
image storage. No shaders, dependencies, unsafe code or application API changes.

Before timing: supported-format full-pixel GPU oracle, overlapping/adjacent region
insertion and collapse/empty controls, CPU repair after repeated text edits, new
resources/common-state rejection, paint-slot support after edits, active-editor and
rounded-clip fallbacks, coalescing/stale tokens/resize/failure/old eligible ACK.
Bounded omitted-region and wrong-predecessor mutants must fail complete pixels.
Repeat full default/X11 GPUI+Canvas, GPU, strict Clippy, port and 11 native gates.
Repeat actual workload final independent full GPU oracle and diagnose admissions.

The Stage A test-only raw support storage is replaced by the production certificate;
remove the expensive diagnostic enumeration from any timing filter. Record separate
invoking-thread allocations, cold setup, requested/retained capacity, common headers,
shipping code, standalone native ELF and relevant caller/callee stacks. Freeze the
small-text control matrix and randomized process order before any timing. Preserve
all previous failures and do not use diagnostic times for acceptance. The primary
20% stream/owner improvement and all-control 1.05 limits in PROTOCOL.md remain fixed.
