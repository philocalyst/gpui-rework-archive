+++
title = "Change a public contract"
description = "Update the reference, walkthrough, and verification together."
weight = 30
+++

Change the Rust documentation beside the item whose behavior changed. Include
its observable behavior, relevant failure or panic conditions, and a link to
another operation when it is the better choice for a different input.

If a walkthrough uses the item, update its canonical Rust source. Regenerate
the page and backlinks; do not edit the generated page by hand. If behavior
changes across platforms, verify the affected targets or state which checks
could not run.

## Verify a documentation change

```sh
python3 -m unittest discover -s scripts/docs
python3 scripts/docs/generate.py --check
python3 scripts/docs/sync_links.py --check
cargo test -p gpui-ce --doc
python3 site/scripts/build.py --with-api
```

Browser checks must use the generated publication: navigation, copy and
download, focus and keyboard behavior, narrow screens, and no-JavaScript
reading. Read the finished page as a user before accepting the source diff.

A new walkthrough is incomplete if its code cannot run, its source omits setup,
or its API link lands on a nearby but different operation. An API entry is
incomplete if its wording hides a behavior the caller must handle.
