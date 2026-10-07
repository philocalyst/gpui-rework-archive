+++
title = "Learn by doing"
description = "Build a window, a counter, and the pieces that make an interface work."
template = "section.html"
sort_by = "weight"
+++

Start with the first window, then the counter. The remaining walkthroughs are
independent: each has its own complete program and names the API contracts it uses.

The browser previews run GPUI compiled to WebAssembly. The Rust in the page is
extracted from the same source that builds the preview. Use the native download
when the behavior depends on windowing or platform services.

[Prepare the native platform](@/guides/setup.md) before running an example locally.
