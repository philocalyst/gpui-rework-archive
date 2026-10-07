# Supporting API documentation audit

This pass covers the public supporting crates around `gpui`. It records the
documentation work completed while the larger site and example integration are
being developed. The source remains the authority for platform-specific details;
this audit intentionally does not claim that generated docs or the Zola site are
complete yet.

## Reviewed

The review covered `gpui_elements`, `gpui_render`, `gpui_test`, `gpui_platform`,
`gpui_web`, `gpui_wgpu`, `gpui_scheduler`, `gpui_derive_refineable`, `gpui_macros`,
`gpui_shared_string`, `gpui_refineable`, `gpui_collections`, `gpui_sum_tree`,
`gpui_path`, `gpui_tokio`, `gpui_ce_util`, `gpui_zed_util`, `gpui_ce_parley`, and
the native support crates `gpui_linux`, `gpui_windows`, `gpui_macos`, and
`gpui_apple`. Public items were checked against their implementations for ownership,
validation, fallibility, platform gating, and relationships to `gpui`.

The core `gpui` crate, examples, tests, binaries, and the future codepen integration
crate were outside this work area. Their documentation is being coordinated by the
other branch owners.

## Changed in this pass

* Added crate-level orientation to rendering, platform selection, browser, WGPU,
  scheduling, refinement, collections, path, Tokio, shared-string, sum-tree, and
  native platform roots.
* Documented the scheduler's priority, spawn metadata, clock/session/timer roles,
  including the deterministic `TestClock` semantics.
* Documented blur radius conversion, sample limits, axes, clip modes, and the
  zero/non-finite behavior of `BlurKernel::for_radius`.
* Clarified the ownership boundary between WGPU contexts and render targets and
  between platform constructors and backend implementation crates.
* Kept the existing `gpui_test` scenario and report documentation after reviewing
  its validation errors, monotonic checkpoint requirement, and headless dispatch
  behavior. Its newly added public interfaces are already substantially documented.
* Added behavioral method documentation for `gpui_path` normalization and path ownership,
  `gpui_collections::VecMap` entry lifetimes, `gpui_sum_tree::Cursor` seek/position semantics,
  and scheduler executor/test control APIs.

## Files changed

* `crates/gpui_render/src/gpui_render.rs`
* `crates/gpui_render/src/blur.rs`
* `crates/gpui_platform/src/gpui_platform.rs`
* `crates/gpui_web/src/gpui_web.rs`
* `crates/gpui_wgpu/src/gpui_wgpu.rs`
* `crates/gpui_scheduler/src/scheduler.rs`
* `crates/gpui_scheduler/src/clock.rs`
* `crates/gpui_refineable/src/refineable.rs`
* `crates/gpui_collections/src/collections.rs`
* `crates/gpui_sum_tree/src/sum_tree.rs`
* `crates/gpui_path/src/path.rs`
* `crates/gpui_tokio/src/gpui_tokio.rs`
* `crates/gpui_shared_string/gpui_shared_string.rs`
* `crates/gpui_linux/src/gpui_linux.rs`
* `crates/gpui_windows/src/gpui_windows.rs`
* `crates/gpui_macos/src/gpui_macos.rs`
* `crates/gpui_apple/src/gpui_apple.rs`
* `crates/gpui_path/src/path.rs`
* `crates/gpui_path/src/rel_path.rs`
* `crates/gpui_path/src/abs_path.rs`
* `crates/gpui_collections/src/vecmap.rs`
* `crates/gpui_sum_tree/src/cursor.rs`
* `crates/gpui_scheduler/src/executor.rs`
* `crates/gpui_scheduler/src/test_scheduler.rs`
* `crates/gpui_scheduler/src/scheduler.rs`

## Remaining gaps

The platform implementation modules contain many low-level public types that are
only meaningful under their target OS. They need a target-aware rustdoc pass with
links to the platform guides, especially for Wayland/X11, Win32/DirectX, AppKit,
Metal, and browser event lifetimes. The WGPU context and renderer methods also need
their error and device-loss paths expanded once the native renderer integration
branch settles.

The proc-macro crates need examples showing the generated trait surface rather than
repeating macro names in prose. `gpui_ce_util`, `gpui_zed_util`, `gpui_ce_parley`,
the collection tree-map APIs, and platform FFI surfaces still need a
method-by-method review for panic conditions and cross-links. The Zola guides,
docs.rs post-processor, and executable example pages remain to be integrated by the
main documentation branch.

## Coverage inventory

The following counts are a mechanical inventory of `pub` declarations in source,
with a nearby `///` comment counted as documented. It is useful for finding the
remaining work, but it is not a quality score: shader ABI structs and platform FFI
exports account for many declarations that are not application-facing, while a
single type-level comment can still need richer method-level examples.

| crate | documented / public declarations |
| --- | ---: |
| `gpui_elements` | 71 / 74 |
| `gpui_render` | 276 / 713 |
| `gpui_test` | 215 / 228 |
| `gpui_platform` | 9 / 9 |
| `gpui_web` | 13 / 17 |
| `gpui_wgpu` | 100 / 120 |
| `gpui_scheduler` | 59 / 91 |
| `gpui_macros` | 29 / 51 |
| `gpui_derive_refineable` | 2 / 3 |
| `gpui_shared_string` | 4 / 4 |
| `gpui_refineable` | 7 / 8 |
| `gpui_collections` | 2 / 27 |
| `gpui_sum_tree` | 44 / 108 |
| `gpui_path` | 26 / 80 |
| `gpui_tokio` | 4 / 6 |
| `gpui_ce_util` | 13 / 21 |
| `gpui_zed_util` | 99 / 246 |
| `gpui_ce_parley` | 32 / 40 |
| `gpui_linux` | 22 / 187 |
| `gpui_windows` | 6 / 57 |
| `gpui_macos` | 18 / 125 |
| `gpui_apple` | 7 / 22 |

The low ratios in `gpui_render` are predominantly generated shader ABI fields and
functions, and those in the native crates are target-gated FFI implementation
surfaces. They remain inventory items rather than being presented as complete
client documentation. The next focused pass should raise coverage for the
application-facing WGPU methods, proc-macro entry points, collection and sum-tree
cursors, Parley constructors, and platform lifecycle errors before claiming full
API coverage.

No executable code, signatures, manifests, examples, tests, or binary artifacts
were changed here.
