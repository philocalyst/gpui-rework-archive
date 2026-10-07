# Contributing

Start with [platform setup](SETUP.md).
Report a reproducible problem in [an issue](https://github.com/gpui-ce/gpui-ce/issues),
or discuss a larger API change there before implementing it.
The [Discord](https://discord.gg/ENGHGjrYEn) is available for questions.

## Code and behavior

Keep a change focused on one problem.
Explain its trigger, the resulting behavior, and the checks that exercise it.
For a public API change, document ownership, failure cases, and platform restrictions
beside the declaration, then update the walkthroughs that use it.

Run formatting and the tests relevant to your change:

```sh
cargo fmt --all -- --check
cargo test -p gpui-ce --doc
```

The [testing guide](docs/testing.md) distinguishes behavior assertions from scene and image comparisons.
A changed visual baseline needs an explanation of the intended output;
a snapshot update alone does not establish that the behavior is correct.

## Documentation

Walkthroughs are executable Rust with a small comment format.
Edit their [canonical programs](site/examples/src/bin/), then regenerate pages,
source downloads, and API backlinks:

```sh
python3 scripts/docs/generate.py
python3 scripts/docs/sync_links.py
python3 site/scripts/build.py --with-api
```

The build needs [Zola 0.23.4](https://www.getzola.org/documentation/getting-started/installation/),
[Trunk](https://trunkrs.dev/), and the `wasm32-unknown-unknown` Rust target.
Read [the authoring contract](docs/documentation-authoring.md) before adding a step or an API target.
Check the finished page as a reader: follow its links, run its program,
copy its source, and try its keyboard controls.

## Reviews

Use direct prose and concrete examples.
Prefer a link to an existing explanation over a second explanation that can drift.
A reviewer should be able to establish a claim from the implementation or a cited source.
Record any check that could not run and the reason.
