# GPUI visual scenario testing

GPUI visual tests render a view through the CPU renderer without opening a native window. A scenario has a fixed viewport and named checkpoints at deterministic simulated times. Captures include the final PNG and scene JSON, plus scene-build and CPU-render timings.

## Run locally

From any working directory, use the repository script with an absolute path:

```sh
/path/to/gpui-ce/scripts/gpui-test list
/path/to/gpui-ce/scripts/gpui-test run --output visual-report
/path/to/gpui-ce/scripts/gpui-test run --output visual-report --baseline visual-baseline
```

The output and baseline paths are relative to the caller's current directory unless an absolute path is supplied. The launchers load the repository's `.cargo/config.toml` even when called elsewhere. The report contains `manifest.json`, `report.md`, `metrics.svg`, `index.html`, and scenario checkpoint PNG/JSON files. A baseline report directory adds before and difference images. Checkpoint changes are advisory in CI; harness build and behavior failures remain hard failures.

Launch a native example from any directory with `scripts/gpui-example <example-name> [example args...]`. For example:

```sh
/path/to/gpui-ce/scripts/gpui-example hello_world
```

The launcher resolves the repository from its own location and passes any remaining arguments through to the example.

## CI and report hosting

GitHub Actions runs `cargo test -p gpui_ce_test --lib`, captures the PR base revision and current revision on the same Ubuntu runner, and always uploads the reports as the `visual-report` workflow artifact. A missing baseline (for example, when the base predates this harness) is reported as a warning; it does not turn a successful capture into a failure. Visual pixel changes remain advisory.

The standard-library report-adapter checks can be run locally with `python3 -m unittest discover -s scripts/testing -p 'test_*.py'`.

The separate `Publish visual report` workflow runs after capture on trusted default-branch code. It resolves the PR number and exact head SHA through the forge API and skips results after the PR head moves. It updates one marked PR comment with typed change categories, a hosted timing graph when Pages is enabled, timings, bitmap memory, and `n/a` GPU memory for the CPU backend. GitHub Enterprise Server uses the workflow-provided `GITHUB_API_URL` and `GITHUB_SERVER_URL`; the publisher falls back to github.com defaults for local use.

To additionally host static reports with GitHub Pages, create a dedicated branch containing only Pages output, configure Pages to serve that branch from its root, and set the repository Actions variables `GPUI_VISUAL_PAGES_BRANCH` and `GPUI_VISUAL_PAGES_URL`. The publisher uses the forge Git Data API to add `runs/<commit-sha>/` reports containing validated PNG/JSON assets and a generated, escaped, no-JavaScript viewer. It maintains `runs.json`, a root index linking all retained reports and the latest report per PR, and `pulls/<pr>/index.html` with that PR's history. It never publishes artifact-provided HTML. Leave both variables unset to use workflow artifacts only.

The GitLab template at [docs/ci/gitlab-visual-tests.yml](ci/gitlab-visual-tests.yml) runs the same harness and keeps PNG/JSON output as a downloadable job artifact. It excludes the source-generated HTML and SVG from GitLab's authenticated artifact browser. Sites that enable GitLab Pages can copy report output into a Pages job on trusted branch pipelines.

For a merge-request note, a separate trusted report job may run `scripts/testing/post_gitlab_comment.py` after fetching the capture artifact. It updates one bot-owned note and checks the current merge-request SHA before posting. Configure a protected `GITLAB_API_TOKEN`, `GPUI_GITLAB_BOT_USERNAME`, and `GPUI_VISUAL_REPORT_URL`; never expose the API token to the merge-request capture job or execute merge-request-controlled report code with that token.
