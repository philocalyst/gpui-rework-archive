<img src="assets/readme/banner.png" alt="GPUI Community Edition" width="100%">

# GPUI Community Edition

GPUI Community Edition is a Rust UI framework derived from [Zed’s GPUI](https://gpui.rs).
Views own state, return element trees, and paint through a GPU renderer.
The framework supplies layout, input dispatch, text shaping, and platform services;
your application supplies the controls and their behavior.

[Walkthroughs](https://gpui-ce.github.io/examples/) · [API reference](https://docs.rs/gpui-ce/) · [Discord](https://discord.gg/ENGHGjrYEn)

## Open a window

Clone this repository and follow the [platform setup](site/content/guides/setup.md).
The walkthroughs compile against the checkout, so their code and API agree:

```sh
cargo run --manifest-path site/examples/Cargo.toml --bin first-window
```

The [first window](site/examples/src/bin/first-window.rs) introduces a view and its render method.
The [counter](site/examples/src/bin/counter.rs) adds state and a click handler;
[keyboard actions](site/examples/src/bin/actions.rs) adds focus and key bindings.
Each program is also a step-by-step page with a browser preview and a complete Cargo download.

## Find an explanation

| You want to… | Start here |
| --- | --- |
| Understand ownership and updates | [Ownership and data flow](crates/gpui/src/_ownership_and_data_flow.rs) |
| Understand the frame pipeline | [Rendering](crates/gpui/docs/rendering.md) |
| Dispatch input and actions | [Input](crates/gpui/docs/input.md) |
| Keep async work from blocking a view | [Scheduling](crates/gpui/docs/scheduling.md) |
| Test behavior and rendered output | [Testing](docs/testing.md) and [test design](docs/testing-design.md) |
| Compare the learning examples | [Example catalogue](docs/examples.md) |
| Build or edit these docs | [Documentation authoring](docs/documentation-authoring.md) |

The [Zola site](site/) holds tasks and walkthroughs.
Long API explanations are included in rustdoc, where they stay beside the types and methods they explain.
API entries link back to the exact walkthrough steps that use them.

## Choose a revision

This fork and upstream GPUI share history, but their APIs can differ.
The current workspace declares core version `0.2.2`; a published crate with that version
can contain older code than this checkout.
Use [the checkout’s dependencies and API](site/content/reference/versions.md) together.
The [platform guide](site/content/guides/platforms.md) records browser and native restrictions.

See [CONTRIBUTING.md](CONTRIBUTING.md) for development and review.
The project follows the [Rust Foundation’s internal AI usage policy](https://rustfoundation.org/policy/internal-ai-usage-policy/).
Contributors remain responsible for understanding and verifying their changes.
