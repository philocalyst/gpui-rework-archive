+++
aliases = ["guide/system/macros/", "system/macros.html"]
title = "Write a walkthrough"
description = "Explain a real program, then generate its page and reciprocal API links."
weight = 10
+++

Write the program first. Each step should change something the reader can
observe, explain why that code belongs there, and point to the contract behind it.
The canonical source lives under `site/examples/src/bin`.

## Four comment markers

A step has an ID, a title, prose, optional API names, and code. The prose is
ordinary Markdown in line comments. The code remains ordinary Rust:

```rust
// docs:step state | Store the value
// The view owns this count. Rendering reads it; a click will change it.
// docs:api gpui::Entity
// docs:code
struct Counter { count: u32 }
// docs:end
```

Add the program to `site/examples.toml`. That manifest names the title, source,
preview, run command, and exact API targets. The generator rejects missing or
duplicate step IDs, malformed ranges, and unknown API names. It generates the
page, clean source, Cargo download, and API-to-step index.

```sh
python3 scripts/docs/generate.py
python3 scripts/docs/sync_links.py
python3 site/scripts/build.py --with-api
```

## Keep explanations at the right depth

The first paragraph names what the reader will do. A walkthrough supplies the
setup and a visible result. A task guide assumes the setup and addresses a
problem. An API entry defines behavior, errors, panics, lifetimes, and alternatives.
An explanation connects those contracts and the choices behind them.

Use meaningful links where a term becomes useful. Add a note for context, a tip
for a shortcut, and a warning for a specific consequence. A warning should say
what triggers the problem and what the reader can do about it.

## Edit before accepting a score

Read each sentence against the implementation. Remove claims that merely sound
plausible, repeated signatures, decorative importance, and unsupported performance
promises. Checkers can flag passages for another read; their output belongs
beside the compilation, link, accessibility, and usability evidence.

The [reference survey](@/about/references.md) records the systems that informed
this framework. The authoring contract and parser tests live in the repository's
`docs/documentation-authoring.md` and `scripts/docs`.
