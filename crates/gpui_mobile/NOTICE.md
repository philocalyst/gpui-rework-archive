# Notices

The Android platform adaptation in this crate is based in part on
longbridge/gpui-mobile, pinned at commit
c24a1308e1dcb47ce94d9ef8d8d05ca4d77d2aa7 (2026-10-14), by Balamurali
Pandranki. That project offers GPL-3.0-or-later OR AGPL-3.0-or-later OR
Apache-2.0. This adaptation selects the Apache-2.0 option; its license text is
included as LICENSE-APACHE.

The adapted shared modules are momentum.rs, fling_guard.rs, frame_pacer.rs,
platform_view.rs, and target_platform.rs. Android files retain upstream and
third-party notices in their source headers. The Android accessibility adapter
and embedded DEX are derived from AccessKit Android 0.7.5; the JNI bindings use
jni-rs. The AccessKit and jni-rs source headers identify their Apache-2.0 or MIT
license choices. The crate selects Apache-2.0 for its adaptations.

The Android example host Activity is adapted from the pinned longbridge source.
Its package and Java sources are kept with the workspace example, not this
platform crate. The Android example bundles the unmodified Google Noto Color
Emoji font from googlefonts/noto-emoji commit
e20cbc2bbec1926686be9f9bee7d1d2cfa1fea0e, path
2D/fonts/NotoColorEmoji.ttf, SHA-256
15671215ab769fdc7162a045d56fd7d7e477c51b04e6b3c761d914d8fdd6cc44. The font
contains CBDT/CBLC tables and no COLR table, matching the Android bitmap-color
format used by the renderer. Copyright 2013 Google LLC. The complete SIL Open
Font License 1.1 from the same upstream commit accompanies the font as OFL.txt,
SHA-256 500bb1ccf43df7bbb522112f9133a52b16e1c35e809632f5d8609b179152de5b.
