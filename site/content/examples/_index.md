+++
title = "Learn by doing"
description = "Build a window, a counter, and the pieces that make an interface work."
template = "section.html"
sort_by = "weight"
+++

Start with the first window, then the counter. The remaining walkthroughs are
independent: each has its own complete program and names the API contracts it uses.

The browser previews run GPUI compiled to WebAssembly. The Rust in the page is
extracted from the same canonical source used for the native download. A
compiled preview and an editable Miri session are different execution paths;
follow the editing guide for the current availability and limits of each.
Download and run the native example when you need to check OS windowing or
platform services.

[Prepare the native platform](@/guides/setup.md) before running an example locally.
