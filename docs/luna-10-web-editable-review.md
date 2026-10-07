# Luna 10: web and editable text review

This review covers the assigned documentation surface: `gpui_ce_web`, `gpui_ce_parley`, and
`gpui_ce_elements::editable_text`. It records source facts and the reference implementations read
so later editorial changes can stay grounded in this checkout.

## Read inventory

### Public declaration and contract pass: complete

The exported declarations and public fields/methods in the assigned crates were enumerated and
checked against their implementation entry points. The documentation pass covers callable
contracts, including units, defaults, replacement/error behavior, mutation and ownership rules,
and links to connected APIs. The audited public surface is:

- `gpui_web`: `WebDispatcher` and `new`; `WebDisplay` and `new`; `WebBackendPreference`;
  `FetchHttpClient`, `new`, and `Default`; `WebKeyboardLayout`; `init_logging`; `WebPlatform`,
  `new`, `new_with_backend`, `fetch_http_client`, and its `gpui::Platform` implementation;
  `WebWindowError` variants; `WebWindow` and its `gpui::PlatformWindow` implementation.
- `gpui_ce_parley`: `SystemFonts`; `FontDataBlob`; `BitmapFallbackGlyphRasterizer`,
  `ColorGlyphKind`, `FontSynthesis`, `FontVariation`, `GlyphRasterizer`, `RasterFace`, and
  `SwashGlyphRasterizer`; `ParleyTextSystem` constructors, configuration methods, and its
  `gpui::PlatformTextSystem` implementation.
- `gpui_elements::editable_text`: the `actions` module, its generated action types,
  `DEFAULT_INPUT_CONTEXT`, `default_bindings`, and `EditableTextActionHandler`; re-exported caret,
  element, state, and storage declarations including `Caret`, `CaretNotify`, the three constructors,
  `EditableTextElement`, `TextHighlights`, `EditableTextState`, `TextChanged`, `TextLimitExceeded`,
  `UnicodeTextStorage`, `TextBoundary`, and `StringStorage`. Private-module history types are
  audited where public state exposes history access, but are not independently importable API.

The declaration scan covered `gpui_web/src`, `gpui_ce_parley/src`, and
`gpui_elements/src/editable_text.rs` plus its private-module implementation files. Crate-root and
module re-exports were checked to distinguish reachable API from `pub` items inside private
modules.

### Implementation reads: complete for listed contracts; partial for internal algorithms

- `gpui_web/src/gpui_web.rs`, `platform.rs`, `window.rs`, `dispatcher.rs`, `display.rs`,
  `http_client.rs`, `keyboard.rs`, and `logging.rs` were read through public declarations and
  relevant implementations. `events.rs` was read around listener registration, keyboard/input,
  paste, composition, and selection-change handlers; `ime_mirror.rs` was read around construction,
  bounded mirror updates, scheduling, and synchronization. Pointer/scroll listener internals and
  all browser helper code were not fully audited.
- The `hello_web` example startup and font-registration path was read. The documentation example
  shows the actual `Application::run` launch timing and window construction APIs.
- `gpui_elements/src/editable_text.rs`, `editable_text/{element,state,storage,actions,caret,
  history}.rs`, and `examples/editable_text.rs` were read around every public declaration and its
  relevant mutation, selection, key-action, storage, IME, and history paths. State, element, and
  action rendering/paint internals were not audited line by line; `layout.rs` was checked to
  identify non-exported implementation state.
- `gpui_ce_parley/src/lib.rs`, `catalog.rs`, the public rasterizer/face sections of `store.rs`, and
  public constructors, caches, `PlatformTextSystem` methods, and paragraph layout paths in
  `text_system.rs` and `text_system/paragraphs.rs` were read. Font parser internals, private
  helpers, test fixtures, and the full layout/rasterizer implementation were not audited line by
  line.

- Earlier broad file list (the following entries are expanded with exact depth and coverage above):
  `crates/gpui_web/src/gpui_web.rs`, `platform.rs`, `window.rs`, `dispatcher.rs`, `display.rs`,
  `http_client.rs`, `keyboard.rs`, `logging.rs`, `events.rs`, and `ime_mirror.rs`; also the
  `hello_web` example's startup and font-registration path. Public exports and the corresponding
  platform trait implementations were checked against their actual constructors and browser
  behavior.
- `crates/gpui_elements/src/editable_text.rs`, `editable_text/{element,state,storage,actions,caret,
  history,layout}.rs`, and `examples/editable_text.rs`. Public constructors, builder methods,
  state methods, storage contracts, key actions, and caret hooks were compared with mutation,
  selection, IME, and layout paths.
- `crates/gpui_ce_parley/src/lib.rs`, `catalog.rs`, `store.rs`, `text_system.rs`, and
  `text_system/paragraphs.rs`. The public exports, font registration and resolution, cache
  invalidation, layout/selection conversion, and glyph rasterization paths were inspected.
- Pinned Zed reference checkout `target/zed-documentation-reference` at
  `da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f`; inspected
  `crates/gpui/src/input.rs`, the input/IME protocol in `crates/gpui/src/platform.rs`, and the GPUI
  input example. Zed defines `EntityInputHandler` as the application-facing editor/field protocol;
  its platform protocol describes ranges in UTF-16 code units and delegates through
  `ElementInputHandler`/`Window::handle_input`.
- Pinned Hummingbird reference checkout `target/hummingbird-documentation-reference` at
  `2e1ee5f1c8d415ef7f835801fe368ab4106035b5`; inspected
  `src/ui/components/input.rs`, `textbox.rs`, and `palette.rs`. Hummingbird's `TextInput` is a
  handwritten control adapted from Zed's input example. It is reused by a textbox and a command
  palette, which subscribes to its `String` changes and forwards enriched Next/Previous/Accept
  actions to its finder. This demonstrates integration patterns; it is not this repository's
  `EditableTextElement` implementation.

## Factual corrections and implementation locations

- Web runtime services are a single document canvas and one normal GPUI window. The window is not
  reopenable after close; popup, floating, and dialog kinds are unsupported. Graphics initialization
  runs asynchronously in `WebPlatform::run`; open the first window from its launch callback. See
  `gpui_web.rs`, `platform.rs::WebPlatform::run/open_window`, and `window.rs::WebWindow::new`.
- WebGPU is the automatic preference, with WebGL2 fallback. A fixed backend preference opts out of
  the fallback. `WebDispatcher`'s thread flag is only permission to use workers: the multithreaded
  feature, shared WebAssembly memory, and `Atomics.waitAsync` must all be available. See
  `platform.rs::initialize_graphics` and `dispatcher.rs::WebDispatcher::new`.
- Browser Fetch is subject to browser CORS/origin/redirect rules and returns status codes as normal
  `HttpResponse` values; the response body is buffered before `get` resolves. Async clipboard reads
  may be unavailable or denied. Browser `paste` events use synchronous `ClipboardEvent` text; image
  files require asynchronous reads. See `http_client.rs`, `platform.rs` clipboard methods, and
  `events.rs::register_paste`.
- The hidden browser `<textarea>` is an IME conduit, not the document. It mirrors a bounded window
  of real document text around the selection in UTF-16 units. Writes are coalesced after the event
  gesture because changing value or selection restarts the browser IME connection. Imported IME
  edits are diffed against the mirror and applied relative to the current selection; the saved
  mirror offset is only a hint, not an edit coordinate. See `ime_mirror.rs::ImeMirror`,
  `ImeMirror::schedule_sync`, its private `sync`, and `events.rs::register_input` and
  `register_selection_change`.
- Editable state, storage replacement, selections, history patches, and highlight ranges use UTF-8
  byte offsets. The web input boundary converts browser UTF-16 code units to/from those offsets.
  `StringStorage::len_utf16` counts UTF-16 code units; it is not equivalent to byte length, scalar
  count, or grapheme count. See `editable_text/storage.rs`, `state.rs`'s `EntityInputHandler`
  implementation, and `element.rs::highlighted_runs`.
- `text_input` disables multiline keyboard behavior and its input path removes CR and LF from paste
  and IME insertion. Programmatic `emplace` does not call that sanitizer. Tab inserts a tab by
  default; focus traversal, PageUp/PageDown, masking, and screen-reader text support are not
  implemented here. See `state.rs::validate_incoming_text`, `actions.rs`, and module docs.
- `TextChanged` is emitted after mutation, including committed edits and state replacement; it
  cannot reject or sanitize input. Oversize edits use `TextLimitExceeded` and preserve the existing
  text and selection. `with_max_bytes` counts UTF-8 bytes. See `state.rs::emplace`,
  `validate_incoming_text`, and input/IME replacement methods.
- Undo history is per editable field. It stores patches and the prior selection, groups compatible
  contiguous edits within 300 ms by default, clears redo when it pushes a distinct new entry, and
  retains at most 1000 undo entries. It deliberately does not record edits while IME composition
  is active. See
  `history.rs` and `state.rs::record_history`.
- Parley resolves font family/weight/style/width, shapes text and returns visual layout; the
  `GlyphRasterizer` only supplies pixels for the exact selected face and variation instance. `Skip`
  starts with an empty catalog; registered blobs are validated as a complete set before insertion.
  Font registration increments the generation and clears paragraph caches. See `catalog.rs`,
  `text_system.rs::ParleyTextSystem` and its `PlatformTextSystem` implementation, and `store.rs`.
- Cache distinctions matter to integrators: shaping keys include font generation, text, shaping
  runs, inline boxes/styles, and line metrics; paragraph result cache also keys width and wrapping
  options. Paint-only color changes can reuse shaped layout, while newly registered fonts invalidate
  cached paragraphs. See `text_system.rs` cache types and paragraph layout construction.
- Visual navigation must use shaped layout when it is current. A cluster can cover multiple scalars;
  bidirectional visual order can differ from logical UTF-8 order. Storage's fallback `Word` movement
  uses `unicode_word_indices`; layout-aware word/line movement uses Parley. See
  `storage.rs::offset_from_caret`, `text_system.rs::ParleyLayout` and `paragraphs.rs`.
- The default Swash rasterizer advertises COLRv0, CBDT, and sbix color glyph support. It does not
  advertise COLRv1 or SVG glyph artwork. `BitmapFallbackGlyphRasterizer` routes CBDT-only faces to
  Swash and leaves other faces on the native rasterizer. See `store.rs::SwashGlyphRasterizer` and
  `BitmapFallbackGlyphRasterizer`.

## Reference comparison and limits

Zed's public input protocol is the architectural source for GPUI input handlers: it separates the
application's text model from the platform's UTF-16 selection/composition protocol. This checkout's
web implementation adds a browser-owned mirror and deferred resynchronization so IMEs retain their
own buffer state. Hummingbird shows one useful composition pattern: reuse a small input entity in a
textbox and palette, listen for committed text changes, and forward navigation/accept actions to the
surrounding component. The local editable-text API packages that behavior as a stateful element and
adds configurable storage, selection geometry, highlights, byte limits, and undo history.

These reference usages should guide examples and links, not be described as APIs this crate exports.
The assigned web internals (`WebEventListeners`, `ImeMirror`, event helpers) are private, and the
public browser contract is expressed through `WebPlatform`, `WebWindow`, `WebDispatcher`,
`FetchHttpClient`, and GPUI platform traits. Parley exposes `PlatformTextSystem` methods through the
trait rather than adding parallel inherent methods for every trait operation.

Remaining uncertainty: browser clipboard permissions and virtual keyboard behavior vary by browser
and secure-context policy. Documentation should state the adapter's behavior and browser policy
boundary, not promise uniform permission outcomes. Parley family fallback still depends on the
catalog containing a matching face; configured fallback names do not load font files.
