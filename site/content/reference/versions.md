+++
aliases = ["guide/guides/migration-faq/", "guide/releases/", "guide/welcome/", "guide/why-community-edition/", "guides/migration-faq.html"]
title = "Versions and limitations"
description = "Keep published API contracts distinct from the current development checkout."
weight = 50
+++

These pages and previews are built from a development checkout. The workspace's
core crate declares version `0.2.2`; that declaration alone does not make its
current source identical to the crate already published under that version.

## Choose the source you are building

Use the local API included by `site/scripts/build.py --with-api` for this exact
checkout. Published docs.rs pages describe their named release. When publishing
new crate versions, regenerate the walkthrough API map and links for that release.

Do not mix a current example with an older dependency and repair the resulting
errors by guessing at method names. Either use the checkout's path dependencies,
as the downloads do, or select examples and references from your dependency's release.

## Practical limits

The browser backend currently supports one window per document. Native services
retain their platform-specific availability. Hot patching is experimental
and native-debug-only. The separate Miri workbench is under development; these
walkthroughs currently execute compiled GPUI WebAssembly.

GPUI draws its own controls rather than using a native widget for each element.
Applications must supply the interaction and accessibility behavior their
controls require. The [accessibility reference](https://docs.rs/gpui-ce/0.2.2/gpui/_accessibility/index.html)
describes the framework integration.

GPUI Community Edition and upstream GPUI share history but can diverge. Treat
cross-fork recipes as source to adapt, and keep their version and fork names visible.
