# Ordinary retained scroll validation

Final source pin: `4340e9961d`. Base:
`dcdadf4d527cb669c13d9e99271bb1f956f95a1f`. Worktree:
`/root/gpui-production-scroll`, branch `production/scroll-viewports`.

This adds a production `.scroll(Axis)` path for ordinary component trees, not
an eager substitute for virtualizing a 250K-row list. The public API, admission
limits and lifetime rules are in [SCROLL.md](../../SCROLL.md). There are no
latency/speedup, RSS, zero-copy or compositor-memory claims in this evidence.

## Storage and requested allocation

Measured with the pinned Rust 1.97.1 x86_64-unknown-linux-gnu toolchain, debug
profile, `allocation-counter` 0.8.1. All counts cover the current thread; fixture
owners survive the measurement closure, so retained and peak bytes are meaningful
requested-allocation counts. They are not allocator usable sizes or process RSS.

| Rust layout | Baseline | Final |
|---|---:|---:|
| Node | 40 | 40 |
| Presented | 80 | 80 |
| Prepared | 40 | 40 |
| Runtime header (headless feature profile) | 2,384 | 2,384 |
| El / DraftNode | 176 / 152 | 176 / 152 |
| ElementExtra / frozen Sheet header | 56 / 96 | 56 / 96 |
| ListState | 112 | 112 |
| cold map key | 8 (ListId) | 16 (typed List/Scroll key) |
| cold map value | 112 (ListState) | 112 (typed List/Scroll state) |
| frozen list entry | 24 | 40 |
| frozen ordinary scroll entry | absent | 64 |
| viewport-column header | 24 (Vec) | 24 (closed Box-slice enum) |

The final column has Empty, list-only, scroll-only and mixed forms. A mixed
window additionally owns one 48 B box of two slice headers. The cohort-relative
P index fits existing row padding. Indexed lookup checks both the array bound
and exact identity before borrowing the same P node's dimensions. It adds no
per-node data or identity map. The 96 B `ViewportInfo` printed by the ledger is
a transient reconstructed value, not the frozen entry stride.

| Recording fixture | Baseline requests / total / retained / peak B | Final requests / total / retained / peak B |
|---|---|---|
| no viewport: one empty Div, 80×80 | 34 / 6,824 / 5,580 / 5,740 | 34 / 6,824 / 5,580 / 5,740 |
| first empty virtual list, 40×40 in 80×80 | 49 / 9,893 / 7,268 / 7,769 | 47 / 9,693 / 7,372 / 7,569 |
| ordinary scroll pane with two 80×80 Div children | API absent | 60 / 14,935 / 10,980 / 11,363 |

The identical first-list fixture retains **104 B more**. Its frozen row accounts
for 16 B of that difference; the remaining 88 B is consistent with the larger
key in the first BTree leaf, not a separately measured allocator histogram.
The ordinary scroll fixture has three nodes, so its difference from the empty
one-node fixture is not a per-pane storage delta.

The plan-only unit test executes both borrowed wheel passes with **zero
allocation requests**. In the small ordinary-scroll recording fixture, each
whole warm `scroll_by → prepare → exact acknowledgement` uses **7 requests,
583 total/peak B and zero net retained growth**. Ordinary scrolling is therefore
not called allocation-free. Preparation still builds its P/scratch columns;
geometry uses a temporary pair of typed vectors and then freezes those same
allocations as the admitted P column. Culling can shrink them. Pending C and old
P own separate existing cohorts, and metadata-only replacement can transiently
hold both old and replacement columns. Application/font/adapter/pixel storage
is outside these individual fixture deltas.

The baseline production source is the exact base pin. Its appended measurement
fixture is retained as [baseline-probe.patch](baseline-probe.patch), with full
modified runtime.rs SHA-256
`92112d817492bcbe3f1413933267107ae52b3b02cf6fd3f4ed47307da6f11700`.
See `baseline-ledger.txt` and `final-ledger.txt`. The baseline and candidate
briefly shared a target directory during exploration; a stale Core rlib was
caught by a missing `CoordinateSpace::translated` compile error, before any
adoption run. Candidate first-party crates were cleaned and rebuilt, and all
final gates use candidate source. No timing rows were collected or accepted
from that stale artifact.

`large-column-exploratory.txt` records the rejected 104 B-per-entry union design;
`compact-ledger-exploratory.txt` records its first compact refinement. Those are
uncommitted intermediate working-source observations, not reproducible commit
comparisons or adoption gates. The final pinned ledger supersedes them.

## Behavioral and native proof

The public suite covers two axes, negative transformed overflow, axis changes,
source shrink/resize clamp, viewport transform rejection and old-P recovery,
pending exact-token publication, stable offscreen ordinary capabilities,
foreign/invalid input, topmost-overlay routing, depth-32 residual routing,
DPI/reflection displacement, no-View ordinary property/resize/scroll, scoped
metadata-only dimension reconstruction, mixed virtual-list consumption,
retirement/non-revival of hidden virtual rows, retained-vs-cold parent flow,
Tab reveal versus logical explicit Focus, virtual focus revocation at completed-C
authority and again at P publication, and nearest oversized nested reveal.
Raster membership is compared byte-for-byte against independently constructed
ordinary Div scenes over 108 sign/size/scale/translation fixtures plus the
collapsed-forward-axis edge case. A separate large-coordinate fixture composes
two non-exact child scales/reflections and ~500K translations, checks wide range
endpoints independently, and admits a declared 0.125 px bound for the narrowed P
map/conservative full bounds. That fixture does not prove universal f64↔f32
identity. The frozen-index corruption test rejects both
wrong-identity and out-of-bounds indexes.

Actual native proof uses a private Xvfb `:105`, a real X11 Softbuffer surface,
explicit ReferenceCpu and the public Panes example model. It waits for actual
native acknowledgement, injects real host CursorMoved plus line/pixel X/Y wheel
callbacks, routes an offscreen retained control through the semantic reveal
port, clicks it with press/release, resizes, suspends/resumes, and compares
**every fetched server pixel** to independently rendered current owner commands
at every acknowledged checkpoint. It verifies no Wgpu initialization/upgrade,
unchanged source epoch for scroll, stable ordinary targets and the actual model
mutation from activation. This proves the native adapter path; it does not
claim OS-compositor memory reduction or other-platform execution.

Two AccessKit Consumer/native-ingress tests verify frozen range metadata,
full offscreen bounds, separate Focus/ScrollIntoView, Scroll/SetScrollOffset
through the owner path, pending-P coherence, physical offset conversion under
DPI 2 and reflection, sorted reflected min/max, cardinal direction flips, and
NaN rejection before enqueue. A third independent-full Consumer transition
oracle checks retired virtual focus while old P geometry is still acknowledged,
then after publication and after the same row key returns with a fresh identity. The native bridge's scroll basis uses the existing
frozen column index, not a P scan or new map. The source contract is pinned
AccessKit 0.25.1: node bounds without transforms use window-physical coordinates,
and SetScrollOffset uses the target node's coordinate space. Native exports
therefore scale displacement by signed a/d; translation cancels.

No real D-Bus scroll action or Windows/macOS scroll execution is claimed by this
slice. The existing native AccessKit backend remains enabled in ordinary Linux
profiles, and the previous whole-framework AT-SPI proof is unchanged. End-to-end
AT-specific scrolling on each OS remains a separate integration proof.

Final gates: **85** headless unit tests, **19** existing virtual-list public
tests, **27** new ordinary-scroll public tests, **113** accessible native/library
tests, **13** Core spatial tests, the ignored real X11 script, and strict
X11+Wayland all-test/example Clippy all pass. Final text logs are adjacent (terminal-only empty lines at EOF removed;
original raw files remain at the `/tmp/gpui-scroll-frozen-*` paths). The
known upstream Parley deprecated-API warning remains dependency output; no new
first-party warning is suppressed. The broad all-headless integration build was
stopped during peer filesystem-pressure scheduling; it is not counted as a
passed gate. The focused final suites above are complete.

## Costs and limits retained

- Ordinary viewport preparation performs an additional O(N) transformed-overflow
  walk using existing paint scratch. Nested apertures stop hidden-content
  propagation. It does not transform-relayout or call View.
- Any actual virtual list in the window forces one description pass during
  scrolling, including ordinary-ancestor scrolling, to preserve bounded row
  capability retirement. This conservative mixed-window cost is explicit.
- Fully clipped ordinary descendants remain in P for semantics/reveal/focus.
  Their storage is retained; they are not virtualized. Painting and pointer
  authority remain clipped. Uniform-list unrealized rows retain their separate
  bounded lifecycle.
- Viewport world maps must be diagonal; reflections/DPI and arbitrary child
  transforms are supported. Rotated/sheared viewport maps fail before C commit.
  Range/input caps and the existing renderer's geometry caps remain documented.
- Raster clips target the existing 4×4 sample profile; continuous pointer and
  accessibility geometry use original transforms/aperture ancestry instead.
- No drag arbitration, touch inertia, elastic overscroll, or new selection/IME
  implementation is included.

## Reproduction

From the worktree root, set the Rust toolchain PATH (as recorded in the raw
logs) and `CARGO_TARGET_DIR=/tmp/gpui-scroll-target`; use the same feature profile
for layout comparisons. Final source commands:

```sh
cargo test --manifest-path reactivity/Cargo.toml -p gpui --lib --test scroll --test lists --offline
cargo test --manifest-path reactivity/Cargo.toml -p gpui --lib viewport_storage_and_allocation_ledger --offline -- --ignored --nocapture
cargo test --manifest-path reactivity/Cargo.toml -p gpui --features x11 --lib --offline
DISPLAY=:105 cargo test --manifest-path reactivity/Cargo.toml -p gpui --features x11 --lib native_ordinary_scroll_wheel_reveal_pointer_resize_resume --offline -- --ignored --nocapture
cargo clippy --manifest-path reactivity/Cargo.toml -p gpui --tests --examples --features x11,wayland --offline -- -D warnings
cargo test --manifest-path reactivity/Cargo.toml -p gpui_reactivity_core --test spatial --offline
```

The X11 command requires an available real X server (the evidence used Xvfb
1024×768×24), Linux dynamic-loader paths supplied by `/tmp/gpui-native-env.sh`,
and an accessible X11 socket. The test is explicitly ignored otherwise; it does
not silently skip a missing display. The native fixture has one 30-second
failure deadline and no production polling/redraw timer.
