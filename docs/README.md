# GPUI-CE documentation

The maintained documentation is the [Zola site](../site/), published at
<https://gpui-ce.github.io/>. It separates the two jobs that used to be mixed
in the Typst shell: the site walks through complete programs, while docs.rs
explains the contracts of the library types and links back to those examples.

Start with the [first window](../site/content/examples/first-window.md), then
follow the [counter](../site/content/examples/counter.md) for state and
updates. The [guides index](../site/content/guides/_index.md) collects setup,
testing, async work, focus, text, and platform notes. Example source lives in
[`site/examples/src/bin`](../site/examples/src/bin/), and the annotation rules
are in [documentation authoring](documentation-authoring.md).

Repository workflow documents remain here:

- [visual scenario testing](testing.md)
- [testing design](testing-design.md)
- [mutation evidence](testing-mutations.md)
- [performance profiles](testing-performance.md)
- [releasing](releasing.md)
- [hot patching](hot-patching.md)

The old Typst pages and their sidebar/template files were a presentation shell,
not a second technical source. Their useful hot-patching instructions now live
in [hot-patching.md](hot-patching.md); the Zola content and crate rustdoc are
the sources to update when behavior changes.
