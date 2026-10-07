+++
title = "Read the contracts"
description = "The API, the model behind it, and the examples that use it."
template = "section.html"
sort_by = "weight"
+++

Use the API reference for the exact signature, accepted inputs, ownership and
error behavior. The site references in this section explain how contracts fit
together: follow ownership for state lifetime, input for dispatch, rendering for
view-to-frame work, or scheduling for async lifetimes. Then open a walkthrough
to see the contract used in a complete program.

A local documentation build can include rustdoc for this exact checkout. The
[published reference](https://docs.rs/gpui-ce/0.2.2/gpui/) describes release
0.2.2; it can differ from the development source even when Cargo metadata still
declares that version. Check the [version notes](@/reference/versions.md) before
combining code and reference pages from different revisions.
