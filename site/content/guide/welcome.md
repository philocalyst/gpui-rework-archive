+++
title = "Welcome to GPUI"
description = "Describe an interface in Rust. Follow it from state to elements to pixels."
weight = 0
[extra]
category = "GETTING STARTED"
legacy_source = "gpui-ce-docs/build/html/index.html"
+++

A GPU-accelerated GUI framework for Rust. Describe UI in code. GPUI turns it into pixels every frame.

It blends immediate and retained rendering, styles with a Tailwind-like API, and manages state through entities your views observe. Start with the counter tutorial. Reach for the element reference when you build.

## Learn in order

1. **Getting started** — install, mental model, first window, counter tutorial.
2. **Fundamentals** — application, windows, entities, models, globals.
3. **Rendering** — elements, views, layout, styling.
4. **Elements** — `div`, text, media, lists, overlays, text input.
5. **Interactivity** — events, focus, actions, gestures.
6. **Graphics** — text system, geometry, scene, animation.
7. **System** — async, assets, utilities, macros, testing.
8. **Platforms** — OS backends and the wgpu renderer.
9. **Guides** — cookbook, performance, migration FAQ.

## The 30-second taste

```rust
fn render(&mut self, _w: &mut Window, _cx: &mut Context<Self>) -> impl IntoElement {
    div().flex().gap_2().child("left").child("right")
}
```

State lives in entities. Views render entities into elements. Elements lay out and paint. That loop is the whole framework. The mental-model page draws it fully.

## Sources

- Framework root: `crates/gpui/src/gpui.rs`
- Crate manifest: `Cargo.toml`
- Project story: `README.md`