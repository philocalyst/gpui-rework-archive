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

The separate full-API Miri workbench remains owned by its development branch.
Only a verified integration with the required runtime changes should be imported;
merging its internal testing baseline is unnecessary for this documentation.

Verification evidence will be recorded in `documentation-verification.md` after
the final build and browser pass. A source digest and Git revision are written
into each artifact's `documentation-build.json`; local source listings show the
exact annotated program used to generate that artifact.
