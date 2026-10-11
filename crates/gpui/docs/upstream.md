# GPUI and GPUI Community Edition

GPUI Community Edition is a fork of the GPUI that lives in the
[Zed repository](https://github.com/zed-industries/zed). Zed's GPUI is developed
for Zed; GPUI-CE is developed for applications of every kind. It pulls in
upstream changes regularly, so most code and knowledge carry over in both
directions, but some names differ and GPUI-CE has features of its own.

## Porting code from Zed's GPUI

Most GPUI code compiles against GPUI-CE once the dependencies are renamed.

**Depend on the GPUI-CE packages.** The main crate is published as `gpui-ce`.
Rename it in `Cargo.toml`, so your `use gpui::...` lines keep working:

```toml
[dependencies]
gpui = { package = "gpui-ce", version = "0.2" }
gpui_platform = { package = "gpui_ce_platform", version = "0.1" }
```

The other GPUI crates are published as `gpui_ce_*`: `gpui_ce_platform`,
`gpui_ce_elements`, `gpui_ce_tokio` and so on. Rename them the same way.

**Start the app through `gpui_platform`.** `gpui_platform::application()`
creates an [`Application`] for whichever platform you build for, including the
web.

**Expect text to lay out slightly differently.** GPUI-CE lays out text with
[Parley](https://github.com/linebender/parley) on every platform, rather than
with each platform's text system. Line breaks and measurements are consistent
across platforms, but they can differ by a pixel or two from Zed's GPUI. Code
that hard-codes text sizes may need adjusting.

**Use the trait methods for notifying and emitting.** [`notify`](AppContext::notify)
and [`emit`](AppContext::emit) are methods of the [`AppContext`] trait, so any
context can call them. Import the prelude, `use gpui::prelude::*`, to bring the
trait into scope.

## What GPUI-CE adds

**The web.** GPUI-CE runs in browsers through WebAssembly, with WebGPU and a
WebGL2 fallback. See [Run on the web](crate::_documentation::guides::web).

**Text.** Parley-based layout everywhere, with bidirectional text and
right-to-left layout ([`Styled::rtl`]), letter spacing, text transforms, and
variable font widths ([`FontWidth`]).

**Editable text.** The `gpui_ce_elements` crate provides single- and multi-line
text fields, with selection, undo, the clipboard and input methods. See [Accept
text input](crate::_documentation::guides::text_input).

**Motion.** Animations with iterations and alternating passes, and transitions
of style properties such as a hover color ([`InteractiveElement::transitions`]).
See [Animate](crate::_documentation::guides::animation).

**Styling.** Smoothed ("squircle") corners ([`Styled::rounded_smoothing`]),
gradients on borders and shadows, and transparent or blurred window backgrounds
on each desktop platform.

**Input.** Touch gestures that arrive as ordinary clicks, scrolls and pinches,
and the character palette on Linux and Windows.

**Accessibility.** Performing assistive-technology actions and reading the
accessibility tree, for testing.

**Tooling.** Hot patching of render code into a running app (the `hot-patching`
feature; see [Reload code while the app runs](crate::_documentation::guides::hot_reload)),
a wgpu renderer for macOS (`macos-wgpu` on `gpui_platform`), and an API for
drawing into windows with your own wgpu code (`custom-gpu`).

**Applications.** Haptic feedback on macOS trackpads, the macOS activation
policy, hiding and showing windows at run time, and detecting a lost GPU device.

## Keeping up with upstream

GPUI-CE merges Zed's GPUI changes with the tooling in `scripts/sync-upstream`
in the repository, and keeps its crates at the same paths as upstream so that
changes apply cleanly. If you find an upstream fix missing, or want to contribute
a GPUI-CE feature back, open an issue on
[GitHub](https://github.com/gpui-ce/gpui-ce/issues).
