# Gap Register — Structural & API Lacks vs Zed/GPUI, Slint, and Iced

This document is the single consolidated register of **structural and API gaps** the
reactivity plan (`07-the-ladder.md` and its supporting docs) still has, cross-referenced
against the real-world trackers we mined: 318 `zed-industries/zed` issues tagged
`area:gpui` or with "gpui" in title, plus open API/RFC issues from
[Slint](https://github.com/slint-ui/slint) and [Iced](https://github.com/iced-rs/iced).

Scope rule: a gap is listed here only if it is a **missing API surface or structural
decision**, not an internal defect. Pure implementation bugs (a panic, a wrong shader
transfer function, a leak, a bad default sampler) were dropped in the earlier pass and are
not reproduced here. Each gap is one paragraph: what is missing, which tracker issues demand
it, and where the plan currently stands. Items still open in their source trackers are marked
`(open)`.

The seams come from the plan's own boundaries: `07 §8` (windows/app shell), `07 §16`
(surfaces), `09-text` (the IFC seam), `runtime/color.md` (color), and the explicit walls in
`07 §18.7`, `09-text §9`, and `10-from-cx §7`.

---

## S1 — Window chrome & compositor effects

The plan's `WindowSpec` (`07 §8`) carries `.title/.size/.min_size/.centered/.pos/.titlebar/
.movable/.resizable` only, and `§16.1` defines element-level `.blur()/.backdrop_blur()/
.filter()/.backdrop()` — but there is no window-compositor contract. Each item below needs a
new `WindowSpec` field or a new backend capability, not a bugfix.

- **Window transparency / vibrancy / backdrop material.** GPUI asks for native transparency
  ([#5040](https://github.com/zed-industries/zed/issues/5040),
  [#7668](https://github.com/zed-industries/zed/issues/7668)), `NSVisualEffectView` vibrancy
  ([#7955](https://github.com/zed-industries/zed/issues/7955)), and Windows Mica
  ([#19405](https://github.com/zed-industries/zed/issues/19405)); X11 blur
  ([#14590](https://github.com/zed-industries/zed/issues/14590) `(open)`) is the same capability
  on another compositor. The plan's `.backdrop_blur()` is element-scoped and paint-only; it has no
  window-level transparency, vibrancy, or backdrop-material surface, and Slint's "always-on-top"
  ([#8143](https://github.com/slint-ui/slint/issues/8143) `(open)`) shows the adjacent chrome gap.
- **Window shadow policy.** Zed's transparent-window shadow inconsistency
  ([#21341](https://github.com/zed-industries/zed/issues/21341) `(open)`) is unanswered; the plan
  mentions only `text_shadow` and scroll-state shadows, never a per-window shadow policy.
- **Corner radius.** The "disable rounded corners" request
  ([#14110](https://github.com/zed-industries/zed/issues/14110) `(open)`) has no corresponding
  `WindowSpec` field.
- **Window control flags.** Minimize control
  ([#52067](https://github.com/zed-industries/zed/issues/52067)) and cross-platform dock menu
  ([#12068](https://github.com/zed-industries/zed/issues/12068)) are absent; Slint tracks the same
  family: min/max/restore button configuration
  ([#6669](https://github.com/slint-ui/slint/issues/6669) `(open)`), close-button placement
  ([#6310](https://github.com/slint-ui/slint/issues/6310) `(open)`), a custom titlebar/frame API
  ([#2521](https://github.com/slint-ui/slint/issues/2521) `(open)`), and mouse-passthrough windows
  ([#6021](https://github.com/slint-ui/slint/issues/6021) `(open)`). The plan's `.titlebar(Native|
  Hidden|Custom)` is a token, not a frame API.
- **Window focus lifecycle.** No callback for window focus gain/loss (Slint
  [#4460](https://github.com/slint-ui/slint/issues/4460) `(open)`), no cross-platform "focus a
  window" verb (Slint [#4382](https://github.com/slint-ui/slint/issues/4382) `(open)`); the plan
  has element focus (`§9`) but window-level activation is unmodeled.

---

## S2 — Backend & platform-target architecture

The plan deliberately *retains* the GPU renderer ("retain … renderer damage first") and never
specifies a fallback, a new backend, or a foreign-language interface.

- **Software / non-GPU rendering.** Framebuffer rendering
  ([#12332](https://github.com/zed-industries/zed/issues/12332)), CPU-only failsafe
  ([#13605](https://github.com/zed-industries/zed/issues/13605) `(open)`) all have no home; "software
  renderer" appears in the plan only as a pinned *test* oracle (`§16.5`). Slint's software renderer
  exists, but its MCU TrueType-in-memory ask
  ([#4250](https://github.com/slint-ui/slint/issues/4250) `(open)`) and Iced's X11-forwarding
  ([#458](https://github.com/iced-rs/iced/issues/458)) mark the same un-modeled software-backend tier.
- **Alternative GPU/vector backends.** Slint's Vello renderer RFC
  ([#11451](https://github.com/slint-ui/slint/issues/11451) `(open)`), Vulkano collaboration -- THIS IS INTERESTING JUST BECAUSE OF THE POINT MADE BY tronical ABOUT A BETTER WAY TO SCREENSHOT TEST, WE SHOULD SWITCH OUR SCREENSHOT TESTING FOR THIS
- **Device selection & recovery.** Integrated-GPU selection
  ([#18433](https://github.com/zed-industries/zed/issues/18433)) and graceful device-loss recovery
  ([#23288](https://github.com/zed-industries/zed/issues/23288) `(open)`) — the plan rebuilds
  pipelines from CPU descriptors (`§16.1`, gate L7) but has no re-present/fallback story.

---

## S3 — Font-rendering mode options

`09-text` defines layout and the IFC; `runtime/color.md §6` defines atlas *coverage* (A8 vs
subpixel LCD). Neither exposes a rendering-mode or sampling option below that seam.

- **Hinting & bi-level rendering.** Metrics hinting + bi-level (non-AA) text
  ([#55214](https://github.com/zed-industries/zed/issues/55214) `(open)`) is blocked upstream on
  Skrifa and has no API here. -- DOES PARLEY FIX THIS?
- **Glyph-atlas sampler filter.** Monochrome-atlas `nearest` vs bilinear
  ([#57777](https://github.com/zed-industries/zed/issues/57777) `(open)`) is a config option the
  plan does not expose.
- **Pixel snapping.** Slint carries an explicit pixel-snapping RFC
  ([#10962](https://github.com/slint-ui/slint/issues/10962) `(open)`), matching GPUI's
  blur-from-snapping ([#40641](https://github.com/zed-industries/zed/issues/40641)); the plan has
  no snapping surface. -- WOULD BE GREAT TO HAVE
- **Text metrics query.** Slint's "provide `Text`'s text metrics" RFC
  ([#6283](https://github.com/slint-ui/slint/issues/6283) `(open)`) and Iced's canvas text-size
  ([#478](https://github.com/iced-rs/iced/issues/478)) point at a general text-metrics API the plan
  only sketches for icon/cap-height alignment (`§19`), not as a public query.

---

## S4 — Desktop-integration APIs

- **External drag-and-drop / virtual files.** Standalone-GPUI OS drag-and-drop
  ([#52110](https://github.com/zed-industries/zed/issues/52110) `(open)`) and Explorer/ZIP virtual
  files ([#58403](https://github.com/zed-industries/zed/issues/58403)) — the plan *names*
  `impl DragExport` (`§9`) but never specifies the OS payload serialization.
- **Clipboard / selection.** Iced's multiple-clipboard / X11-primary-selection
  ([#904](https://github.com/iced-rs/iced/issues/904) `(open)`) matches GPUI's Wayland primary
  selection and `wl_data_source` work; the plan has no clipboard/selection protocol.
- **System menus, tray, file dialogs.** Iced's system menus
  ([#974](https://github.com/iced-rs/iced/issues/974) `(open)`), menu-bar plan
  ([#114](https://github.com/iced-rs/iced/issues/114)), tray icon
  ([#124](https://github.com/iced-rs/iced/issues/124) `(open)`), and file dialogs
  ([#1002](https://github.com/iced-rs/iced/issues/1002)); Slint's file dialogs
  ([#9781](https://github.com/slint-ui/slint/issues/9781) `(open)`). The plan has `menu_item()`
  elements but no tray, no OS menu bar, no native file-dialog surface. -- THIS NEEDS TO BE CLEAN AND ELEGANT AND CROSS PLATFORM
- **IME as a public API.** Slint's "Input Method support in the public Platform API"
  ([#3811](https://github.com/slint-ui/slint/issues/3811) `(open)`) — the plan routes around IME
  (`§9`, `08-history`) but does not re-specify the platform IME interface itself. -- READ THROUGH THIS 

---

## S5 — Framework architecture

- **Theme color coupling.** Theme-color coupling under semi-transparency
  ([#55972](https://github.com/zed-industries/zed/issues/55972) `(open)`) — `color.md` fixes alpha
  compositing but not the theme-authoring coupling; Slint's style-interface RFC
  ([#1870](https://github.com/slint-ui/slint/issues/1870) `(open)`) and "system themes"
  (Iced [#1022](https://github.com/iced-rs/iced/issues/1022) `(open)`) are the adjacent questions.
- **Event-loop ownership / interop.** Slint's `poll_events` cooperation RFC
  ([#2763](https://github.com/slint-ui/slint/issues/2763) `(open)`) and Iced's "less frameworky
  way to run" ([#313](https://github.com/iced-rs/iced/issues/313) `(open)`) — the plan makes
  `gpui::run` own the loop (`§8`) with no external-loop handoff, a gap `10-from-cx §7` does not
  close. -- READ THROUGH THIS

---

## S6 — Lifecycle & environment API guarantees

These are capability *lacks*, not crashes — the API contract simply doesn't guarantee them.

- **Per-output DPI / scale.** DPI update on monitor move
  ([#21851](https://github.com/zed-industries/zed/issues/21851) `(open)`); Slint's per-window scale
  factor ([#4418](https://github.com/slint-ui/slint/issues/4418) `(open)`) is the same model
  missing from `§8`.
- **Display enumeration timing.** `displays()` empty during startup, breaking layer-shell output
  selection ([#46378](https://github.com/zed-industries/zed/issues/46378) `(open)`) — the plan
  gives no startup-availability guarantee for display queries.

---

## New gaps surfaced only by Slint/Iced (keep in mind)

These did not appear in the Zed/GPUI tracker pass; they are gaps the plan *also* has, revealed by
reading the other frameworks' open issues.

- **Layout-level RTL mirroring.** Slint's right-to-left *layouts/alignments*
  ([#2294](https://github.com/slint-ui/slint/issues/2294) `(open)`) — the plan handles text bidi via
  Parley (`09-text`) but does not mirror flex/layout direction; this is a structural gap, not a
  text one.
- **Propagating/inherited properties.** Slint's "properties that propagate (enabled, visible,
  palette)" ([#2338](https://github.com/slint-ui/slint/issues/2338) `(open)`) — the plan has token
  cascade and `.open()` presence but no general downward-inherited property (e.g. a subtree-wide
  `disabled`).
- **Virtual keyboard.** Slint's built-in VirtualKeyboard
  ([#5128](https://github.com/slint-ui/slint/issues/5128) `(open)`) and Iced's virtual-keyboard
  example ([#896](https://github.com/iced-rs/iced/issues/896) `(open)`) — the plan's a11y/IME work
  does not include an in-process virtual keyboard surface.
- **Global/context state.** Slint's "replace global state with a context API"
  ([#4294](https://github.com/slint-ui/slint/issues/4294) `(open)`) and early global-singleton
  ([#6235](https://github.com/slint-ui/slint/issues/6235) `(open)`) mirror `10-from-cx`'s open
  "settings as a global" hard-port — the plan resolves `cx` but still carries this as an open gap. -- read through this, think we resolve
- **Cross-thread/worker spawn surface.** Slint's "spawn a future from a different thread"
  ([#2522](https://github.com/slint-ui/slint/issues/2522) `(open)`) — the plan has `Reader`/`.latest()`
  and `send` for the cross-thread edge (`§1`, `scheduler.md`), but the ergonomic worker-spawn story
  is not spelled out end to end.

---

## Corroborated-but-covered (for completeness)

The following Slint/Iced issues map to gaps the plan **already answers**, so they are not gaps
here: multi-window shared globals (Slint [#6877](https://github.com/slint-ui/slint/issues/6877))
→ `Entity` + pocket sharing; modal windows (Slint [#6607](https://github.com/slint-ui/slint/issues/6607),
Iced [#423](https://github.com/iced-rs/iced/issues/423)) → `Dialog`/overlay family `§9`; named
slots (Slint [#6258](https://github.com/slint-ui/slint/issues/6258)) → `pub Target` parts `§2`;
switch/match (Slint [#1307](https://github.com/slint-ui/slint/issues/1307)) → `.switch()` `§2`;
multi-handler callbacks (Slint [#2268](https://github.com/slint-ui/slint/issues/2268)) → `Emit<E>`
pub-sub `§3`; anchor placement outside layout (Slint [#183](https://github.com/slint-ui/slint/issues/183))
→ placement graph `§16.3`; spring animations (Slint [#609](https://github.com/slint-ui/slint/issues/609))
→ motion lanes `§7`; animated images (Slint [#2081](https://github.com/slint-ui/slint/issues/2081),
Iced [#1412](https://github.com/iced-rs/iced/issues/1412)) → `§16.2` media; accessibility
(Iced [#552](https://github.com/iced-rs/iced/issues/552), [#489](https://github.com/iced-rs/iced/issues/489))
→ `§16.5` + `06 §7`; custom shaders (Iced [#903](https://github.com/iced-rs/iced/issues/903)) →
`#[gpu_shader]` `§16.1`; infinite/virtual lists (Iced [#160](https://github.com/iced-rs/iced/issues/160))
→ `.on_reach` `§4`.
