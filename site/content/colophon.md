+++
title = "Inside the transmission."
description = "The signal, the type, and the machinery behind the GPUI field guide."
weight = 0
[extra]
category = "ABOUT THE PROJECT"
playground = false
+++

This is a working field guide for GPUI Community Edition. Its visual language borrows from phosphor terminals, instrument panels, halftone printing, and optimistic exhibitions of unfamiliar machinery.

## A compact sort of spectacle

The compact structure takes a cue from [East River Source Control](https://ersc.io/). The layered typography and exhibition spirit are inspired by [Lost World’s Fairs](https://lostworldsfairs.com/), particularly the very different worlds of El Dorado, Atlantis, and the Moon. The drawing, layout, and typography here are an original composition.

Doto builds the opening word from discrete pixels. Barlow Condensed supplies the dense, physical letterforms beside it. IBM Plex Mono carries labels, commands, and the working details. All fonts are self-hosted with their SIL Open Font License files.

Graphite surfaces, acid green signals, and violet annotations are specified in OKLCH. Scan texture, registration marks, and ruled bands make the page feel like one compact piece of equipment. Layouts resize through flexible bases, wrapping, `min()`, `max()`, `clamp()`, and intrinsic grids. No CSS media queries are used.

## A static publication with moving parts

[Zola](https://www.getzola.org/) publishes the Markdown, builds the navigation and table of contents, resolves internal links, and highlights code at build time. Reading and navigation work without JavaScript.

The examples are native custom elements. Small JavaScript modules connect browser events to compiled Rust/WebAssembly exports. The inline browser studies use semantic HTML to make their controls accessible; their captions distinguish them from the GPUI GPU renderer. Source panels show the corresponding GPUI pattern and the actual WASM implementation.

The full-screen interference field is one native WebGL draw call: warped bands, halftone dots, scan texture, and a phase supplied by the same Rust/WASM module. It responds to pointer hover and keyboard focus on **Get started**. Motion pauses when the tab is hidden; reduced-motion preferences start it still. The footer has a motion control, and an etched CSS background remains when WebGL or WASM is unavailable.

Syntax highlighting is the one deliberate exception to the preference for classless, span-free markup: Zola generates token spans and classes so source remains readable without a client-side highlighter. Its token colors use the same OKLCH palette as the page.

## The source material

The earlier documentation work lives in `gpui-ce-docs`. The complete recoverable publication was in `build/html`: 38 chapters and a home page. Those chapters and their 141 code blocks were recovered into Markdown, with original navigation categories and a migration manifest. The old Typst welcome, sidebar, and disclosure patterns now have Zola equivalents.

The editorial guide also adapts the repository README and release notes. The recovered technical chapters retain their source references; APIs can evolve, so check the revision used by your application.

## Open by default

The framework’s license is [Apache–2.0](https://github.com/gpui-ce/gpui-ce/blob/main/LICENSE.md). Font licenses are distributed with the font files. There are no analytics, third-party embeds, or runtime CDN dependencies on this site.
