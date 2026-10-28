# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/). This project somewhat adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html), aside from the major version being 0.

## [Unreleased]

### Highlights

(only filled out when preparing the release)

### Breaking changes

### Additions

### Removals

### Fixes

### Security Changes

### Deprecations

### Contributors

Thanks to the people who made this release happen!

## [0.3.0] - 2026-10-19

### Highlights

Retained view rendering, parley as the default text layout system, iOS and Android backends, and the first crates.io releases of the renderer, parley, and platform leaf crates.

### Breaking changes

- Views keep their output between frames. A view renders again only when it's notified, an entity or global it read changes, or it's drawn somewhere new, so state changed without `notify` is no longer picked up by an unrelated redraw

### Additions

- Changelog established
- Default text layout system switched to [parley](https://github.com/linebender/parley) [#267](https://github.com/gpui-ce/gpui-ce/pull/267)
- `PaintQuad::new` and property-building functions [#338](https://github.com/gpui-ce/gpui-ce/pull/338)
- Retained view rendering: entities placed as children skip `render`, layout and paint while nothing they read changed, and `Entity::cached` gives a view a fixed root style
- iOS backend (`gpui_ios`) and Android backend (`gpui_mobile`), with an example app in `examples/mobile`
- GPUI changes from Zed up to Zed commit `56934ec056`
- `gpui_ce_render`, `gpui_ce_parley`, `gpui_ce_apple`, `gpui_ce_ios`, and `gpui_ce_mobile` now publish to crates.io
- `wgsl-rs` is consumed from crates.io (`0.1.0-beta.1`) instead of a pinned git revision

### Removals

### Fixes

- Text selection is not cleared when editable-text loses focus [#250](https://github.com/gpui-ce/gpui-ce/issues/250)

### Security Changes

### Deprecations

- `quad`, `fill`, & `outline` [#338](https://github.com/gpui-ce/gpui-ce/pull/338)

### Contributors

Thanks to the people who made this release happen!

- Cameron Campbell (@cameronpcampbell)

## [0.2.2] - 2026-08-28

Existed before changelog
