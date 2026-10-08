+++
aliases = ["guide/system/macros/", "system/macros.html"]
title = "Write a walkthrough"
description = "Explain a real program, then generate its page and reciprocal API links."
weight = 10
+++

Write the program first. Each step should change something the reader can
observe, explain why that code belongs there, and point to the contract behind it.
The canonical source lives under `site/examples/examples`.

## Write Markdown beside the code

A heading begins a step. Line comments explain it; the first Rust line
starts the displayed code. The next heading begins another step:

```rust
// ## Own the count {#state}
// An [`Entity`] handle keeps the count alive. Cloning the handle shares the
// value; it does not copy the field.

let count = cx.new(|_| 0_u32);
```

There are no code or end markers. Keep an explicit anchor such as `{#state}`
when a published link should survive a heading change. Rustdoc-style API links
resolve to exact reference pages and generate links back to this step.

Add the program to `site/examples.toml`. That manifest names the title, source,
preview, run command, and exact API targets. The generator rejects empty or
duplicate anchors, empty steps, and unknown API names. It generates the
page, clean source, Cargo download, and API-to-step index.

```sh
python3 scripts/docs/generate.py
python3 scripts/docs/sync_links.py
python3 site/scripts/build.py --with-api
```

## Share the constructor

Define `component(window, cx)` to create the example's root entity. The native
entry point calls `support::run(component)`. Use the actual GPUI entities,
listeners, tasks, and elements in the walkthrough source; do not substitute
mock APIs to make an example easier to display. The generator owns the published
walkthrough and source downloads, so regenerate them after changing comments or code.

Before accepting a walkthrough, run its Cargo example and check the browser
editor. Its compiler and Miri run in browser Workers. Function-body edits can
keep the running state; changes to a type or closure capture can restart the
component. Try the edits the walkthrough recommends, including any expected
compiler error and the correction that follows it.

## Keep explanations at the right depth

The first paragraph names what the reader will do. A walkthrough supplies the
setup and a visible result. A task guide assumes the setup and addresses a
problem. An API entry defines behavior, errors, panics, lifetimes, and alternatives.
An explanation connects those contracts and the choices behind them.

Conceptual guides are also chapters in the [GPUI Book](https://gpui-ce.github.io/book/). The book and
rustdoc read the same sources; testing, accessibility, drawing, and assets use
those sources on this site too. Revise the canonical chapter when a contract changes, then
rebuild all three surfaces.

Use meaningful links where a term becomes useful. Add a note for context, a tip
for a shortcut, and a warning for a specific consequence. A warning should say
what triggers the problem and what the reader can do about it.

## Read against the implementation

Read each sentence against the implementation. Remove claims that merely sound
plausible, repeated signatures, decorative importance, and unsupported performance
promises. Compile the examples, follow the links, use the keyboard controls,
and make the edits the page suggests. Revise any sentence whose claim or
instructions fail that check.

The [reference survey](@/about/references.md) records the systems that informed
this framework. The authoring contract and parser tests live in the repository's
`docs/documentation-authoring.md` and `scripts/docs`.
