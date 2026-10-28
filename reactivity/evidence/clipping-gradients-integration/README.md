# Composed gradient materials and nested clipping

Shipping source: `948eff489aaa1f5d36a2514dc247884755b8e5c7`. This integrates selected gradient source `a2dd48e908d6bb5e999f5b613af3a82407353ee5` and clip source `b164198e02ca4172a8cd56308ad204d30f1da333` onto Main `8e07a95d78011a722be2d8f4e69d0d91c65976c4`, preserving the canonical text capacity fix and certified-solid packets. The producer reports remain historical, independently pinned records; their original “unadopted” wording describes those earlier handoffs.

Ordinary views can use `.bg(&gradient)`, `.rounded(radius).clip()`, and typed `BACKGROUND` / `CORNER_RADIUS` / `CLIP` properties. Linear, elliptical radial and conic gradients support multiple stops, duplicate hard edges, Pad/Repeat/Reflect and premultiplied extended-linear-sRGB interpolation. Nested rectangle and uniform rounded-rectangle clips share admitted affine geometry across CPU paint, GPU paint, acknowledged input and native accessibility. Coverage intersects the same sixteen sample sites; it never multiplies independently filtered clip alphas.

## Composition and corrected boundaries

- The canonical draw prefix ends at `draw_words_end`. Clip records follow, then the existing immutable image/gradient resource tails. Forward/reverse draw walks stop at the draw end; resource address preparation includes the entire clip prefix. Joint GPU fixtures move this boundary, reuse resource keys, compare exact constant-gradient coverage, and retain complex-chain declines in solid/tile certificates.
- The public gradient evaluator now checks normalized point and finite parameter domains. Repeating parameters admit at most 2^20 periods from the first stop. The renderer borrows an already admitted private evaluator, so no public validation is repeated per sample. The initial finite-output test passed while concealing a wrong phase; the stronger semantic control failed before the fix. Both attempts remain in the capsule.
- The composed public scene fixture preserves an eligible gradient lease, pixels and clip geometry after a newer logical failure. Action queries correctly remain stale while `visit` borrows the acknowledged sheet. The first fixture incorrectly requested an actionable query in that state; its failed run is preserved and the final fixture requires its hit assertions to execute.
- Clip-only preparation no longer reserves unused membership and published-index arrays: 5*N requested logical bytes are structurally removed. The remaining inherited-state columns still reserve 48*N bytes in that mode, plus coordinate spaces and other preparation storage. This is a deletion ledger, not a matched RSS or throughput result. The separate frontier spike is not adopted here.
- Damage equality now compares exact immutable clip content across scene owners, retaining the same-arena fast path. Rectangles, inverse coefficients, bounds, raster-proof words and radii compare bitwise along equal-depth parent chains. Handles retain their scene-specific authority. Identical rebuilt chains produce empty damage; a distant 4x4 paint change returns only its existing conservative 6x6 support; changing a middle ancestor changes pixels and damages the affected support. Cross-arena comparison is allocation-free O(depth) per compared clipped command, with depth capped at 64; no memoization is claimed.

## Executed qualification

| Exact source and scope | Result |
| --- | --- |
| Composed `d3e6885c6bab6a07fafcd3f4faae7cbb3023e0c7`, 102 frozen Canvas/GPUI/GPU ELFs | 997 passed, 39 explicitly ignored |
| Same source, strict native/GPU all-target Clippy | passed |
| Same source, doctests including borrow failures | 32 passed |
| Same source, scalar gradient evaluator | 7 passed |
| Same source, scalar clip/gradient coverage integration | 9 passed |
| `5be9000ae52f9a26e7dd5c2fdd41cf47834688b7`, actual private-X11 GPU/paint/inspector bridge and AT-SPI clipping wire | 2 passed |
| Final `948eff489aaa1f5d36a2514dc247884755b8e5c7`, focused clip/damage tests | 14 passed |
| Final source, scalar clip/damage tests | 14 passed |
| Final source, strict native/GPU all-target Clippy | passed |

The broad run includes all 70 GPU cases (11 unit, 4 presentation, 55 render) and 240 GPUI library cases, with its 31 other native cases ignored. Counts overlap; the header probes repeat selected tests. The final delta from d3 changes only clip content comparison and its public damage fixture. It adds no shader, packet, native-provider or public API change. The native wire executable predates the action-query fixture correction, which changed only that integration test.

Every gate hashes 2,049 tracked scoped inputs before/after and requires a clean pinned worktree. The exact nightly is 2026-10-23, rustc `7189d39d9`, LLVM 23. Cargo features, commands, full logs, failed attempts and executable identities are in `qualification-logs.tar.gz` and `delta-qualification.tar.gz`. Source mutation during qualification is prohibited. `qualification-members.json` lists the compact archive's payload hashes. Frozen ELFs remain outside Git at the paths in their binary records.
`main-adoption.json` proves that the fast-forward changed only the intentional
GPUI README within that scoped closure; production source/configuration bytes
match the qualified pin exactly.

`shader-artifacts/result.json` verifies the actual 18,995-byte WGSL (SHA256 `ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1`) and all four vertex/fragment SPIR-V recipe pairs inside both frozen GPU and native library-test ELFs. SPIR-V validation passes; the executed storage-layout test independently compares included WGSL with fresh typed Rust generation. GPU execution uses Mesa 26.1.4 llvmpipe; Xvfb and software Vulkan establish neither hardware GPU speed nor scanout latency.

The initial clip-damage invocation selected zero tests because an exact filter was abbreviated. It is explicitly insufficient. The corrected exact invocation failed on the original pointer comparison. The first implementation run passed the unchanged-chain assertion, then exposed the fixture's missing conservative one-pixel support guard. Corrected support expectations pass, including actual changed-ancestor pixel repair. No failed control is promoted to a successful qualification.

## Exact costs and remaining work

The final seven-library Syn/Tokei inventory is **34,466 non-test, non-comment shipping lines**, including the inline-call helper once and GPU build script. Main's prior source was 32,372: this feature composition adds 2,094 lines. Exact clip damage comparison adds 26 of these. The changed vendor scope in the clip producer adds 118 shipping lines in three AccessKit files; those files are byte-identical here. No prediction of the complete 1.0 size is implied.

Actual composed frozen header/allocation probes, rather than adding standalone spike estimates, report:

| Value | Composed bytes / requests |
| --- | ---: |
| Canvas / CanvasScene / DisplayList | 488 / 496 / 288 |
| Canvas resource envelope / clip arena / clip node | 96 / 32 / 104 |
| First clip, four-node initial capacity | 3 allocations, 544 requested bytes |
| Further warmed draws sharing that clip | 0 allocations |
| GeometryStyle / ExtraParts / ElementExtra / El | 8 / 216 / 56 / 176 |
| Node / Presented / Style / sparse geometry record | 40 / 64 / 88 / 16 |
| PreparedDraw / borrowed CPU command | 184 / 168, transient |
| GPUI SceneResources / Backgrounds | 32 / 72 |
| Runtime<()> with accessibility / Metadata | 1840 / 264 |

The default producer's 1824-byte Runtime omits the existing accessibility fields; it is a different feature profile. Gradient and clip cold resource pointers both contribute to the 96-byte Canvas envelope, so the standalone clip producer's 536-byte first allocation becomes 544 bytes in this composition. ExtraParts is 216 here versus 208 in the clip-only report. The 200-byte two-stop gradient remains one allocation. Allocator metadata, capacity slack, resource maps, backend memory and RSS are additional costs. Producer native code/frame and ordinary-override costs remain charged in their reports; no matched final composed executable-size, startup or latency win is asserted.

Perceptual interpolation, richer hue/stop editing, missing components, CSS fixup/hints, focal radial geometry, gradient text/borders, independent paint transforms and durable resource replay remain separate work. Clipping currently excludes paths, independent corner radii and arbitrary Boolean masks. There is no analytic-AA or higher-quality text-raster claim here. Safe compact text ownership/metadata, exact compiled raster scales, the O(depth) frontier and the single-history SDR GPU experiment remain separately pinned until integrated and qualified. Native macOS/Windows providers share the patched AccessKit consumer by resolved source, but their OS runtime coverage remains outstanding.
