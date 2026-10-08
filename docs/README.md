# GPUI-CE documentation

The maintained documentation has three entry points: the
[Zola walkthrough site](../site/), the [API reference](https://docs.rs/gpui-ce/),
and the [GPUI Book](../book/). Walkthroughs explain complete programs. The API
reference states each operation's contract. The book publishes the reference's
conceptual chapters from the same source.

Start with the [first window](../site/content/examples/first-window.md), then
follow the [counter](../site/content/examples/counter.md) for state and
updates. The [guides index](../site/content/guides/_index.md) collects setup,
testing, async work, focus, text, and platform notes. Example source lives in
[`site/examples/examples`](../site/examples/examples/), and the annotation rules
are in [documentation authoring](documentation-authoring.md).

Repository workflow documents remain here:

- [examples](examples.md)
- [releasing](releasing.md)
- [hot patching](hot-patching.md)

Edit walkthrough comments in their canonical Rust programs. Edit shared
conceptual chapters in `crates/gpui/docs` and ownership in
`crates/gpui/src/_ownership_and_data_flow.rs`. The authoring guide explains the
generator, link checks, and local API/site/book build.
