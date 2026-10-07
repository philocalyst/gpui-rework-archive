# API services documentation audit

This pass covers the service and platform support APIs assigned to the documentation refactor.
The edits are documentation-only; no executable code, feature flags, or dependency manifests were
changed.

## Covered

The inventory reviewed in this pass contains 435 public declaration lines across the assigned
files: 167 in `platform.rs`, 90 in `text_system.rs`, 67 in `text_system/line_layout.rs`, 19 in
`assets.rs`, 16 in `queue.rs`, 13 in `text_system/line.rs`, 11 in `util.rs`, 10 in
`text_system/font_width.rs`, 10 in `svg_renderer.rs`, 8 in `http_client.rs`, 5 in
`platform/windows_screen_capture.rs`, 5 in `platform/diagnostics.rs`, 4 in `asset_cache.rs`, 4 in
`text_system/font_features.rs`, 3 in `text_system/font_fallbacks.rs`, and one each in
`shared_uri.rs` and `platform/screen_capture.rs`. The count includes re-exports and cfg-gated
interfaces and is a review inventory rather than a rustdoc item count.

- `assets.rs`: asset source and registry ownership, on-demand loading, duplicate paths, decoded
  image frames, byte order, and missing-frame behavior.
- `asset_cache.rs`, `shared_uri.rs`, `http_client.rs`: asynchronous asset contracts, URI intent,
  hash scope, HTTP policy boundaries, and built-in denial clients.
- `svg_renderer.rs`: parse/rasterize lifecycle, font resolution, scaling, and BGRA output.
- `util.rs`, `queue.rs`: timeout cancellation semantics, timer ownership, priority selection,
  blocking versus spinning receives, and disconnect errors.
- `platform.rs` and platform support modules: backend capability scope, compositor detection,
  native capture, menu descriptions, diagnostics reports, and Windows frame lifetime.
- `text_system.rs` and text support modules: byte-offset and cluster terminology, font cache
  invalidation, fallback ordering, OpenType feature tags, and shaping ownership.
- `_accessibility.rs`: corrected the stale reference to an `a11y` module; the guide is the module
  itself and links to the current public element and window APIs.

## Residual gaps

The inventory is complete for the assigned files. Some cfg-gated backend hooks intentionally retain
short contracts because their behavior is a no-op on unsupported platforms; their default return
values and capability boundaries are now stated where they are public. Rustdoc and doctest runs
remain the authoritative check for intra-doc links and cfg-specific examples.

No build or docs.rs deployment was run, per task scope. The changed comments should be checked by
the repository's normal rustdoc and link validation once the surrounding branch work lands.
