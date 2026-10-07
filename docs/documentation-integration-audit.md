# Documentation integration

The documentation branch starts from `codex/example-cleanup` at
`593f99f88aa5b17aea0f2f2a0076b747b4f76340`, whose base is main at
`b5aceefaf96af3946ff26a603e5f4110d4bdf4ca`. It includes the finished native
example reorganization and focused lesson tests. The internal testing and
portable capture branches are excluded.

The walkthrough package is a workspace member. Its programs are ordinary Cargo
examples, compiled natively and together as the browser entry point. Each page,
source listing, download, API index, and reciprocal API link comes from its
annotated Rust source and `site/examples.toml`.

The Zola site is a new implementation. The previous site branch supplied only
old route names for redirects; its prose, design, and built programs were not
imported. Local builds with `--with-api` include rustdoc from the same checkout.
Published docs.rs is a separate release artifact: source-level Markdown includes
supply its example backlinks, since a static site cannot rewrite docs.rs's HTML.
The HTML postprocessor decorates local or self-hosted rustdoc copies.

The Miri prerequisite snapshot `58c30b2452963fcec0c32296af37c793cb847806`
is based directly on that clean example branch. It adds the real-GPUI headless
execution and portable scene facilities required by the workbench, the existing
Codepen editor/transport, and vendored Miri. It excludes the internal `gpui_test`
crate, CPU renderer changes, testing example merge, and testing branch history.
Conflicts were resolved by keeping the rewritten API prose and the runtime's
required serialization and scene changes.

Every walkthrough defines one component constructor. The generated workbench
source removes its native entry and platform launcher; Miri executes the same
constructor against the real `gpui` crate. The browser mounts the existing
Codepen component and imports its GPUI scene through the ordinary renderer.
The local documentation server proxies render and explicit cancellation on the
same origin. It has no source-to-WASM edit endpoint.

Native editing uses `gpui-ce/cli` at the reference commit recorded in the research
notes. Its `gpui watch --example` path selects the same ordinary Cargo example.

Verification evidence will be recorded in `documentation-verification.md` after
the final build and browser pass. A source digest and Git revision are written
into each artifact's `documentation-build.json`; local source listings show the
exact annotated program used to generate that artifact.
