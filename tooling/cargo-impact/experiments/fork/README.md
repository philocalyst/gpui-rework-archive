# Fork-contained Actions experiment

This experiment is restricted to `philocalyst/gpui-ce`. Both workflows check the
repository identity; the comment workflow accepts only the repository owner's
`/cargo-impact check` command. All checkouts use that repository explicitly.
No reviewers, assignees, user mentions, tags, releases, or registry publication
are part of the experiment. Discovery is disabled in the generated configuration
and on the command line. Consumers are committed fixtures in this fork.

The selected library is the actual `gpui_ce_refineable` crate. Preparation copies
that crate and its sibling derive crate from the pinned base/candidate checkouts
into a minimal workspace. This keeps GPUI's unrelated platform dependency graph
out of the experiment while testing its real Rust code, renamed library target,
procedural macro, semver gate, and downstream diagnostics.

| Draft PR | Change to the real crate | Expected result |
| --- | --- | --- |
| [Additive API: PR 1](https://github.com/philocalyst/gpui-ce/pull/1) | Add a public experiment marker function | Gate closes; no consumer builds; exit 0 |
| [Used API becomes private: PR 2](https://github.com/philocalyst/gpui-ce/pull/2) | Make `Cascade::reserve` crate-private | Gate opens; reserve-user gets E0624; base-user succeeds; exit 1 |
| [Unused API becomes private: PR 3](https://github.com/philocalyst/gpui-ce/pull/3) | Make `Cascade::set` crate-private | Gate opens; both consumers succeed; exit 0 |

The PR workflow also supports manual dispatch. Dispatch forces consumer builds
against the selected branch to exercise Docker without requiring an API change.
`missing_target=true` assigns only reserve-user an unavailable embedded target;
its failure should be classified as an environment error, not a regression.
Dispatch again with `false` to verify recovery with the corrected recipe.

The scanner binary cache includes its toolchain, source, lockfile, embedded
templates, and license. Build-result caches use separate PR/dispatch namespaces. The API token
is supplied only to the authorization and reporting jobs. The build job uses
Docker and supplies no GitHub token to the scanner or its Cargo commands.

For comment-event testing, the workflow must be present on the fork's default
branch. The planned test branch is `codex/impact-fork-base`; changing the fork's
default branch temporarily makes this test possible without changing `main`'s
Git history. The default must be restored to `main` after the runs finish. The
inherited prerelease workflow is main-specific and must never be dispatched or
allowed to publish as part of this experiment. The test base excludes itself
from the broad inherited PR CI to avoid unrelated platform builds.

The user authorized public draft PRs and Actions runs confined to this personal
fork. Draft PRs, workflow logs, artifacts, and bot reports are publicly viewable.
The first hosted run caught Cargo rejecting an inline-table `--config` value for
rustdoc. Rustdoc's bootstrap flag now uses Docker's environment option instead;
both failures and successful scans preserve their reports as artifacts.

## Local results

The same fixtures were exercised locally with the explicit trusted-host opt-in:
the unchanged library closes the gate; private `reserve` produces E0624 at
reserve-user's source span while base-user succeeds; private `set` opens the
gate but both consumers compile. The missing target produces E0463 and a
harness-failure classification, and removing that recipe override recovers.
Reports are retained in the ignored repository-local `.cargo-impact/` directory.
The hosted runs below exercise Docker, reactions, permission checks, and report
comments with the same fixtures.

## Hosted results

The final backend revision `de63401796` passed **128 tests**, clippy, formatting,
a fresh generated standalone installation, and the explicit real-Docker test.
The Docker test also performs clean replay, repeats replay in the same work
area while preserving sibling targets, and refuses a tampered candidate graph
while retaining the completed baseline. The
[Linux verification log](https://github.com/philocalyst/gpui-ce/actions/runs/37585635812/job/112674985486)
records the full checks. A Linux-only executable fixture race found in an earlier
run was corrected by interpreting a non-executable script through `/bin/sh`.

| Hosted experiment | Observed evidence |
| --- | --- |
| [Additive API](https://github.com/philocalyst/gpui-ce/actions/runs/37585635698) | Gate closed, no consumer builds, exit 0, verified bundle |
| [Used API](https://github.com/philocalyst/gpui-ce/actions/runs/37585635812) | Successful baseline, candidate E0624 at `src/lib.rs:10:25`, compatible base-user, expected exit 1; fresh pinned replay reproduced the regression |
| [Unused API](https://github.com/philocalyst/gpui-ce/actions/runs/37585635410) | Gate opened, two compatible consumers, exit 0; fresh pinned replay stayed compatible |
| [Missing target](https://github.com/philocalyst/gpui-ce/actions/runs/37585691298) | E0463 retained as `baseline` / `environment` harness failure, healthy consumer continued, exit 2; healthy consumer replayed successfully |
| [Corrected recipe](https://github.com/philocalyst/gpui-ce/actions/runs/37586083794) | Two compatible consumers after removing the target override; fresh replay succeeded; all verification checks passed |

The used-API scan took 45.2 seconds with two consumers and 530.2 MiB of managed
work; the same test in the bot used 270.0 MiB. These are fixture observations,
not performance guarantees or total Docker-disk measurements. Its immutable
report generation contains 13 artifacts totaling 113,142 bytes, including the
phase lockfiles. The original and fresh replay retain matching engine, source,
recipe, graph, lock, compiler and immutable image proof. The image's pullable
repository digest is retained separately from the platform image ID.

[The bot run](https://github.com/philocalyst/gpui-ce/actions/runs/37585932905)
checked the owner's current permission, reacted with eyes, and published
[a highlighted diagnostic report](https://github.com/philocalyst/gpui-ce/pull/2#issuecomment-6032934407)
with the tested head and direct artifact link despite the expected regression
exit 1. Rerunning the reporter preserved the same marked comment ID instead of
creating another report. `main` remained at `b5aceefaf96af3946ff26a603e5f4110d4bdf4ca`
and the fork's default branch was restored to `main` after authorization.

Comment events have a read-only cache token. Authorization therefore installs
the trusted scanner and transfers it as a same-run artifact to uncredentialed
build workers and the reporter. The generic default-branch push job warms scanner
installation; dependency build caches use a separate restore tier from final
binaries and downstream build work.

Browser checks verified Unicode-safe highlighting, error filtering/search,
consumer anchors, copying issue/replay instructions and downloading the exact
resolved lockfile. Source links pin the full consumer commit and nested manifest
path. JSON retains duplicate Cargo targets and complete diagnostic trees; concise
views reduce repeated symptoms. Original, replay and harness-failure SARIF pass
the official schema and URI validation. Report retention was exercised against
real generations and preserved the current publication.

These are controlled synthetic consumers of the real crate, confined to the
personal fork. They prove these execution and reporting paths, not discovery
completeness or compatibility across GPUI's ecosystem. See
[the production gaps](../../docs/adversarial-review.md).

```sh
python3 tooling/cargo-impact/experiments/fork/prepare.py \
  --baseline . --candidate . --output .cargo-impact/fork-local-inputs --local
cargo run --manifest-path tooling/cargo-impact/Cargo.toml -- check \
  --baseline .cargo-impact/fork-local-inputs/baseline \
  --candidate .cargo-impact/fork-local-inputs/candidate \
  --config .cargo-impact/fork-local-inputs/impact.toml \
  --work-dir .cargo-impact/fork-local-work \
  --report-dir .cargo-impact/fork-local-report --no-discovery --allow-local
```
