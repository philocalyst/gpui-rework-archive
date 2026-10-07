# Luna 07: text and asset documentation review

## Scope and source of truth

The GPUI code in this worktree is the specification. The Zed and Hummingbird checkouts below
were inspected only as examples of real use. They are pinned observations, not contracts for this
checkout. No executable code was changed.

The first-pass rustdoc additions are in:

- `crates/gpui/src/text_system.rs`
- `crates/gpui/src/assets.rs`
- `crates/gpui/src/asset_cache.rs`
- `crates/gpui/src/shared_uri.rs`
- `crates/gpui/src/http_client.rs`
- `crates/gpui/src/svg_renderer.rs`
- `crates/gpui_media/src/media.rs`

They explain the separate stages of font resolution, shaping/layout, text interaction, glyph
rasterization and atlas upload; distinguish byte, UTF-16, grapheme, and glyph coordinates; and
connect asset-key lookup, async loading, URI values, decoded image frames, SVG parsing, and native
media wrappers. They also state cache ownership, fallback/run behavior, font-unit conversion,
error handling, and the limits of synchronous and full-body interfaces.

## Local implementation files read

The source-backed review covered these files and their public declarations/implementations:

- `crates/gpui/src/text_system.rs`
- `crates/gpui/src/text_system/font_fallbacks.rs`
- `crates/gpui/src/text_system/font_features.rs`
- `crates/gpui/src/text_system/font_width.rs`
- `crates/gpui/src/text_system/line.rs`
- `crates/gpui/src/text_system/line_layout.rs`
- `crates/gpui/src/assets.rs`
- `crates/gpui/src/asset_cache.rs`
- `crates/gpui/src/shared_uri.rs`
- `crates/gpui/src/svg_renderer.rs`
- `crates/gpui/src/http_client.rs`
- `crates/gpui_media/src/media.rs`
- `crates/gpui_media/src/bindings.rs`
- `crates/gpui_media/src/bindings.h`
- `crates/gpui_media/build.rs`
- `crates/gpui_media/Cargo.toml`

Coverage means the public type, method, constant, alias, and field declarations in each listed
Rust source file were enumerated and read, along with the corresponding implementation blocks.
For `gpui_media`, this includes both public macOS modules and the raw opaque pointer aliases;
their generated Core Foundation ownership behavior was checked against the binding macros, C
header declarations, and crate build configuration. Private cache code was also read where needed
to verify frame reuse, asset loading, and native resource lifetime claims.

The documentation conventions and overall docs direction were checked in
`docs/documentation-authoring.md` and `docs/documentation-research.md`. I also read
`target/zed-documentation-reference/AGENTS.md` as part of reviewing the external reference tree;
it applies only inside that checkout and does not direct work in this workspace.

## Source-backed clarifications made

- The text guide now separates shared font/metric state (`TextSystem`), per-window layout reuse
  (`WindowTextSystem`), backend-owned visual layout (`LineLayout`), painting, and glyph
  rasterization. Shaping determines glyph runs and advances; rasterization returns pixels for
  those glyphs and does not perform line breaking.
- Text ranges and `TextRun::len` are UTF-8 byte counts and must be valid string boundaries. They
  do not count UTF-16 code units, graphemes, or glyphs. A caret cluster can span multiple Unicode
  scalars; affinity distinguishes visual placements at wraps and bidi boundaries. Text input
  protocols using UTF-16 need a conversion at that boundary.
- The font guide explains that fallback may split one requested run across resolved faces, and
  that face metrics are design units scaled by `font_size / units_per_em`. A face bounding box is
  not a shaped string's advance width.
- Layout cache guidance describes one shared `TextSystem`, one retained `WindowTextSystem` per
  window, current/previous frame reuse, paint-only restyling, and invalidation on font-generation
  changes, as implemented by `LineLayoutCache`.
- Asset docs distinguish synchronous exact-key `AssetRegistry::load` from typed async `Asset`
  loading. They document duplicate-key errors, absent entries, inline on-demand loader latency,
  and the error suppression/logging behavior in the `AssetSource` iterator adapters.
- URI and HTTP docs clarify that `SharedUri` preserves spelling and hashes the stored string;
  `HttpClient::get` returns a fully collected body, returns HTTP statuses as responses, and leaves
  transport policy to the concrete client. Its `'static` future cannot retain a borrow of the
  caller.
- Image and SVG docs distinguish encoded bytes from already-decoded `RenderImage` frames,
  document frame delays and process-local IDs, and describe parse-once/rasterize-many behavior,
  SVG sizing modes, BGRA output, and the 8192-pixel raster cap.
- `gpui_media` docs identify the macOS-only surface and clarify retained Core Foundation wrappers,
  borrowed slices/references, framework errors, and raw pointer safety obligations. Convenience
  methods whose implementations assert or panic are called out.

## Pinned ecosystem examples inspected

### Zed

Checkout: `target/zed-documentation-reference`, commit
`da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f` (2026-10-07).

- `crates/gpui/examples/text.rs`: loads embedded Lilex font bytes with `TextSystem::add_fonts`
  before constructing the typography specimen.
- `crates/gpui/examples/input.rs`: builds adjacent style runs from marked-text byte ranges,
  uses `display_text.len()` for coverage, calls `shape_line`, and gets a cursor x coordinate from
  the resulting line.
- `crates/gpui/examples/image_loading.rs`: defines a typed `Asset`, calls an image loader from
  its `load` implementation, awaits an owned future, and uses `window.use_asset` with loading and
  fallback UI. This is a concrete async ownership example.
- `crates/gpui/examples/svg/svg.rs`: supplies an `AssetSource` to `Application::with_assets` and
  uses the same SVG path at multiple colors.
- `crates/gpui/src/elements/svg.rs`: its `SvgAsset::load` reads bytes asynchronously and returns
  an `Arc<[u8]>`; this confirms the parse/rasterization boundary is downstream of asset loading.

### Hummingbird

Checkout: `target/hummingbird-documentation-reference`, commit
`2e1ee5f1c8d415ef7f835801fe368ab4106035b5` (2026-10-07). Its `Cargo.lock` pins
`gpui-unofficial` to `abb40052f0af5cc87e611365a72f4d31776a0cd3` and `gpui_platform` from Zed to
`cac9d17a6c1283759805fa968d5b111a6ba5f988`.

- `src/ui/assets.rs`: `HummingbirdAssetSource` dispatches the `bundled` URI scheme and delegates
  listing to bundled assets.
- `src/ui/assets/bundled.rs`: embeds fonts, icons, and images; maps stored URLs to bundle paths;
  emits `!bundled:` names from `list`.
- `src/ui/app.rs`: `find_fonts` lists `!bundled:fonts`, loads `.ttf`/`.otf` bytes, and registers
  them with `TextSystem::add_fonts`; application startup supplies that source with
  `Application::with_assets`.
- `src/ui/components/input.rs`: creates byte-length `TextRun`s and shapes the displayed input.
  The component separately imports `UTF16Selection`; it is an example of a protocol/index
  boundary outside this text-system API.
- `src/ui/components/table/cell_strip.rs`: calls `shape_text` with a one-row line clamp and
  reports errors from the fallible shaping path.
- `src/ui/components/managed_image.rs`: decodes image bytes in bounded blocking work, converts
  to `RenderImage`, and retains async retrieval/cancellation state. It demonstrates why
  decoding and image ownership belong beyond a URI string or registry lookup.

These projects use APIs from their pinned GPUI revisions. For example, their `shape_line` call
has an additional alignment argument that is absent from this worktree's current
`WindowTextSystem::shape_line` signature. Their examples validate the documented concepts, not
the exact API signature or behavior here.

## Remaining uncertainties and root follow-up

- The adjacent `elements/text.rs`, `elements/img.rs`, and `elements/svg.rs` APIs are intentionally
  outside this edit scope. A later editor should link the new text/asset concepts to their exact
  style, UTF-16 selection, image-source, and SVG-element entry points after reviewing those
  implementations.
- The primary surface could use an end-to-end example that converts the platform's UTF-16
  selection protocol to UTF-8 byte ranges and paints a `ShapedText`; this pass only adds a compact
  single-line text example in module docs.
- `AssetSource` adapters cannot propagate their source errors through their iterator outputs. The
  current docs describe this behavior; root may decide whether a future API should preserve these
  errors.
- No docs build was run as requested for this pass. The added rustdoc intra-links and examples
  should be checked by the documentation pipeline before merge.
