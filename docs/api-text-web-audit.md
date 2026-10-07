# Text, web, and editable text API audit

This documentation pass reviewed the public support crates that connect GPUI text APIs to browser
runtime behavior and editable controls. Changes are documentation-only.

## Files reviewed

Web platform: `crates/gpui_web/src/gpui_web.rs`, `dispatcher.rs`, `display.rs`, `events.rs`,
`http_client.rs`, `ime_mirror.rs`, `keyboard.rs`, `logging.rs`, `platform.rs`, and `window.rs`.
The docs now describe the one-canvas/one-window lifecycle, lazy graphics initialization, browser
fetch and policy boundaries, listener ownership, cooperative dispatch, CSS/display conversion, and
UTF-16 IME mirroring at the browser edge.

Parley backend: `crates/gpui_ce_parley/src/lib.rs`, `catalog.rs`, `store.rs`, `text_system.rs`,
`text_system/paragraphs.rs`, and the font fixture support files. The docs cover explicit system-font
policy, registration validation, font-generation cache invalidation, exact variation instances,
glyph buffer formats, fallback rasterization, and UTF-8 cluster/visual-order semantics.

Editable text: `crates/gpui_elements/src/editable_text.rs`, `actions.rs`, `caret.rs`, `element.rs`,
`history.rs`, `layout.rs`, `state.rs`, and `storage.rs`. The docs cover keyed state lifetime,
focus ownership, IME and UTF-16 conversion, UTF-8 byte ranges, custom storage versioning, patch
history grouping, redo invalidation, caret timers, and browser/native input boundaries.

## Review result

All public declarations in these files were inventoried and existing method-level contracts were
retained. Module orientations were expanded where they were absent or too terse. Remaining private
helpers and test-only fixture declarations are intentionally outside the public API; no executable
code or metadata was changed.
