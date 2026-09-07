+++
title = "Inside the pavilion."
description = "The type, the sea, and the machinery behind the GPUI field guide."
weight = 0
[extra]
category = "ABOUT THE PROJECT"
playground = false
+++

This is a working field guide for GPUI Community Edition, dressed as an exhibition. The conceit comes from the imaginary world's fairs of [Lost World's Fairs](https://lostworldsfairs.com/): posters for places that never existed, set with conviction. Ours is a pavilion at the bottom of the sea.

## The swell as structure

Every edge between paper and water is a wave. Sheets of paper are masked with a repeating swell at their top and bottom, code blocks rise out of the dark with the same profile, tickets are notched and scalloped with radial masks, and the nav links bob at different phases of a sine. The background is one WebGL draw call whose clock and swell profile come from a small Rust module; the hero sheet's edge samples that same function so paper and water move together. Page transitions are cross-document view transitions in which the new page surfaces through a rising wave mask.

Other techniques on show: `mix-blend-mode: multiply` for the off-register overprint in the headline, `text-decoration-style: wavy` as the universal link underline, `::details-content` transitions in the chapter rail, `initial-letter` drop caps, `animation-timeline: view()` entrances, and `@property`-registered custom properties so the tide inside a ticket can be animated by the browser.

## The type

**Pilowlava**, by Anton Moglia and Jérémy Landes for Studio Triple, sets the wordmark and the headlines. It is named after pillow lava, the forms molten rock takes when it cools under water, which was too good to pass up. **Basteleur**, by Keussel, carries chapter titles and section heads with a tarot-card seriousness. **Newsreader**, by Production Type, is the reading face; its optical-size axis keeps long chapters comfortable. **Monaspace Krypton** labels the exhibits and **Monaspace Neon** sets code and the editor, both from GitHub Next. All five are self-hosted under the SIL Open Font License, subset to the Latin ranges the guide uses.

Colour is specified in OKLCH: an abyss blue, bone paper, coral, gold, and lagoon.

## The exhibits

Each exhibit is a complete GPUI program compiled to WebAssembly with the framework's own web backend, drawing through WebGPU or WebGL 2. The editor is a `<textarea>` over a highlighted mirror, the arrangement David Bushell arrived at in his [text editor notes](https://dbushell.com/2026/09/01/text-editor/): the textarea keeps selection, input methods and accessibility, and the mirror carries colour and diagnostics.

Live editing recompiles the real thing. A small compiler daemon (`site/scripts/live-compiler.mjs`) accepts the edited program, runs `cargo build` for `wasm32-unknown-unknown` and `wasm-bindgen`, and serves the fresh bundle; the page swaps the exhibit's frame to it. An incremental build takes a few seconds. Errors come back as rustc diagnostics with line numbers, which the editor underlines in a wave.

## The publication

[Zola](https://www.getzola.org/) builds the Markdown, navigation and tables of contents, resolves internal links, and highlights code at build time with Giallo. The editor's highlighter emits the same token classes so both share one stylesheet. Reading and navigation work without JavaScript; the committed exhibit still renders, and its source is readable as a static code block.

The earlier documentation lives in `gpui-ce-docs`. Its 38 chapters and 141 code blocks were recovered into Markdown with a migration manifest that the build verifies on every run.

## Open by default

The framework is [Apache-2.0](https://github.com/gpui-ce/gpui-ce/blob/main/LICENSE.md). Font licences ship beside the font files. There are no analytics, third-party embeds, or runtime CDN dependencies.
