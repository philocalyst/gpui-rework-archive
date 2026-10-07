# GPUI visual scenario testing

GPUI visual tests render a view through the CPU renderer without opening a native window. A scenario has a fixed viewport and named checkpoints at deterministic simulated times. Captures include the final PNG and scene JSON, plus scene-build and CPU-render timings.

## Run locally

From any working directory, use the repository script with an absolute path:

```sh
/path/to/gpui-ce/scripts/gpui-test list
/path/to/gpui-ce/scripts/gpui-test run --output visual-report
/path/to/gpui-ce/scripts/gpui-test run --output visual-report --baseline visual-baseline
/path/to/gpui-ce/scripts/gpui-test bench --output visual-report --gpu
/path/to/gpui-ce/scripts/gpui-test platform --output platform-report
```

On Windows, use the PowerShell launchers `scripts\gpui-test.ps1` and `scripts\gpui-example.ps1` from PowerShell. For example, `& C:\path\gpui-ce\scripts\gpui-test.ps1 run --output visual-report`. The GitHub Windows contract job tests these entry points with a mocked `cargo.cmd`; a local machine without PowerShell cannot execute the `.ps1` launchers.

The output and baseline paths are relative to the caller's current directory unless an absolute path is supplied. The launchers load the repository's `.cargo/config.toml` even when called elsewhere. Reports contain `manifest.json`, `report.md`, `metrics.svg`, `index.html`, checkpoint PNGs, and `.scene.json.gz` captures. Readers transparently accept older uncompressed scene JSON; gzip changes neither snapshot values nor comparison status. Baselines add before and difference images. `--gpu` requests an optional native replay: its images and pixel differences are diagnostic, while CPU captures remain canonical. Native timing and memory fields state whether GPU timestamps or backend device-allocation measurements were available and identify their measurement scope. Invalid driver counters disable device timing with an explicit reason; native images, completed-frame wall timing, and memory measurements remain available. Clear-only frames have no device timing. `platform` writes OS-backed window lifecycle checks, including capability flags, event poll counts and elapsed times, and optional frame/resize results.

Capture the Cargo examples that use the shared example prelude in one build and serial run:

```sh
python3 scripts/testing/capture_examples.py --samples 20 --output example-captures
python3 scripts/testing/capture_examples.py --debug --samples 2 --output example-captures
scripts/gpui-test collect visual-captures/core visual-captures/examples/* platform-report --output visual-report --baseline visual-baseline --gpu
```

Discovery comes from Cargo metadata and the example source's `run_example` or `run_example_with_assets` call, so the batch has no separate example inventory. Reports are written beneath `<output>/<example-name>`; relative paths use the caller's working directory. `--baseline` forwards a matching `<baseline>/<example-name>` report to each example. Each example has a 60-second timeout by default; use `--timeout SECONDS` to change it. `collect` combines built-in and example report directories without rerendering CPU captures, retains their timing samples, and performs the final baseline comparison in one report.

Launch a native example from any directory with `scripts/gpui-example <example-name> [example args...]`. For example:

```sh
/path/to/gpui-ce/scripts/gpui-example hello_world
```

The launcher resolves the repository from its own location and passes any remaining arguments through to the example.

## CI and report hosting

GitHub Actions runs GPU-free renderer contracts and state regressions on Linux, macOS, and Windows. Separate required Mesa lavapipe checks verify analytic WGPU capture parity and native report replay. Its report job captures twenty frames per checkpoint with software Vulkan and requests native replay; if replay is unavailable, it regenerates a CPU-only report. The Linux, macOS, and Windows native-platform jobs publish OS-backed window lifecycle reports, with Linux running under Xvfb. GitLab's primary report job follows the same CPU-canonical, optional Mesa replay path; separate lavapipe and Linux Xvfb jobs exercise native rendering and platform checks. Both forge templates use `bench` for saved reports, producing timing percentiles without advancing animation time. Missing baselines are warnings, and reviewed gallery snapshot changes remain advisory; GPU-free contracts, WGPU parity/replay checks, and platform-job failures remain hard checks.

The standard-library report-adapter checks can be run locally with `python3 -m unittest discover -s scripts/testing -p 'test_*.py'`.

The separate `Publish visual report` workflow runs after capture on trusted default-branch code. The capture job checks out the PR head revision explicitly. The publisher resolves that revision through the forge API, rejects mismatched capture provenance, and skips results after the PR head moves. It updates one marked PR comment with typed CPU change categories, the timing graph when Pages is enabled, CPU bitmap storage, and optional native replay timing/memory provenance and diagnostic images. Changed CPU checkpoints get priority in the six-image preview; the hosted report retains every checkpoint. It also summarizes any platform-check artifact included in the report. GitHub Enterprise Server uses the workflow-provided `GITHUB_API_URL` and `GITHUB_SERVER_URL`; the publisher falls back to github.com defaults for local use.

To additionally host static reports with GitHub Pages, create a dedicated branch containing only Pages output, configure Pages to serve that branch from its root, and set the repository Actions variables `GPUI_VISUAL_PAGES_BRANCH` and `GPUI_VISUAL_PAGES_URL`. The publisher uses the forge Git Data API to add `runs/<commit-sha>/` reports containing validated PNG/JSON assets and a generated, escaped, no-JavaScript viewer. It maintains `runs.json`, a root index linking all retained reports and the latest report per PR, and `pulls/<pr>/index.html` with that PR's history. It never publishes artifact-provided HTML. Leave both variables unset to use workflow artifacts only.

The GitLab template at [docs/ci/gitlab-visual-tests.yml](ci/gitlab-visual-tests.yml) runs GPU-free renderer contracts and state regressions as hard checks, with reviewed gallery snapshots advisory. Its primary job installs Mesa software Vulkan and attempts native replay for the report, falling back to CPU-only output if replay fails. Separate jobs require lavapipe capture parity/native replay and run Linux window lifecycle checks under Xvfb. Merge requests compare against `CI_MERGE_REQUEST_DIFF_BASE_SHA` when that commit is present locally; set `GPUI_VISUAL_BASE_SHA` to choose another base. Missing commits, old harness revisions, and failed baseline captures produce warnings and still allow the current report to upload. Set `GIT_DEPTH: "0"` if your runner's shallow checkout does not include the desired base commit. The artifact retains PNG/JSON output and excludes generated HTML/SVG from GitLab's authenticated artifact browser. Sites that enable GitLab Pages can copy report output into a Pages job on trusted branch pipelines.

For a merge-request note, a separate trusted report job may run `scripts/testing/post_gitlab_comment.py` after fetching the capture artifact. It updates one bot-owned note and checks the current merge-request SHA before posting. Configure a protected `GITLAB_API_TOKEN`, `GPUI_GITLAB_BOT_USERNAME`, and `GPUI_VISUAL_REPORT_URL`; never expose the API token to the merge-request capture job or execute merge-request-controlled report code with that token.
