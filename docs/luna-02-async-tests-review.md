# Luna 02: async and test documentation review

First-pass review of the async and testing surfaces on GPUI checkout
`ea37e981f3e3e8ca97bbaca48813e1b2f57abd04`. The local implementation is the
source of truth; the pinned upstream clones were used only as real-consumer
examples.

## Changes in this pass

- Reworked [`scheduling.md`](../crates/gpui/docs/scheduling.md) into use-case
  guidance for foreground, background, idle, scoped, dedicated, and Tokio work.
  It now shows a foreground task returning through a weak entity handle and
  explains app/window teardown, `Task` await/drop/detach behavior, scoped
  borrowing, target differences, and when test scheduling stops matching
  production timing.
- Reworked [`testing.md`](../crates/gpui/docs/testing.md) to distinguish
  `TestApp`, `TestAppContext`, `HeadlessAppContext`, and the macOS visual test
  context. It now explains observer effect timing, explicit clock advancement,
  seed-based schedule variation, frame control, text shaping, and platform
  behavior that simulated tests cannot establish. It also gives benchmark
  selection guidance for synchronous work, task completion, per-iteration
  setup, and renderer measurements.
- Corrected [`BackgroundExecutor::run_until_parked`](../crates/gpui/src/executor.rs:238).
  Its old comment said it advanced the clock to the next timer; the implementation
  calls `TestScheduler::run`, which drains current work and leaves future timers
  pending.
- Clarified timer draining and app-handle behavior on
  [`TestAppContext`](../crates/gpui/src/app/test_context.rs:490),
  [`VisualTestContext`](../crates/gpui/src/app/test_context.rs:794),
  [`HeadlessAppContext`](../crates/gpui/src/app/headless_app_context.rs:164),
  and [`VisualTestAppContext`](../crates/gpui/src/app/visual_test_context.rs:152).
- Clarified [`Task`](../crates/gpui_scheduler/src/executor.rs:401) detach and
  cancellation semantics, and documented the `gpui_tokio` runtime ownership,
  join errors, and task-drop behavior in
  [`gpui_tokio.rs`](../crates/gpui_tokio/src/gpui_tokio.rs:1). The old crate
  summary incorrectly said the adapter did not create a runtime even though
  `init` creates and stores one.
- Corrected the test-clock contract after tracing
  [`TestScheduler::advance_clock`](../crates/gpui_scheduler/src/test_scheduler.rs:488):
  it polls queued work while crossing due timers, then leaves the clock at the
  requested destination. `run` only drains current work, while
  `run_with_clock_advancement` advances through future timers until quiescence.
  The executor, test app, headless and visual contexts, scheduler comments, and
  testing guide now describe these distinct operations accurately.
- Clarified benchmark reports and the differences among `bench_iter`,
  `bench_task`, `bench_batched_task`, and `bench_renderer` in
  [`bench_context.rs`](../crates/gpui/src/app/bench_context.rs:634). Reports
  include Criterion warmup/calibration samples; frame-budget overruns are a
  synthetic foreground-work estimate without vsync.
- Reviewed all public queue operations against their implementation in
  [`queue.rs`](../crates/gpui/src/queue.rs:144), including disconnection after
  queued items drain, blocking versus nonblocking iteration, priority weights,
  and the busy-spin cost of `spin_send`/`spin_try_pop`.
- Removed duplicate executor and scheduler summaries and clarified task
  readiness, output, cancellation and detach semantics in
  [`gpui_scheduler/src/executor.rs`](../crates/gpui_scheduler/src/executor.rs:399)
  and weighted priority semantics in
  [`scheduler.rs`](../crates/gpui_scheduler/src/scheduler.rs:37). Added
  field-level descriptions for `TestSchedulerConfig` and documented that
  `has_pending_tasks` includes future timers.
- Clarified action-profiler retention and running-action behavior in
  [`actions.rs`](../crates/gpui/src/profiler/actions.rs:11), and filled gaps in
  hidden task-profiler collector and timing helper docs in
  [`profiler.rs`](../crates/gpui/src/profiler.rs:92). Reviewed the frame
  profiler, hang detector, and foreground journal docs against their
  implementations; the existing debug overlay documentation from the root
  agent was preserved.
- Added source-level docs for the platform scheduler constructor/executor and
  the clock trait. Existing test harness and threaded dispatcher descriptions
  were checked against source behavior, including what simulated scheduling
  cannot establish. Added method-level docs for `TestDispatcher` controls and
  clarified that `Entity::next_notification` advances the test clock and may
  have work ready before its returned future is first polled.

## References and concrete consumers

Jiff's [official crate documentation](https://docs.rs/jiff/latest/jiff/) opens
with a complete, practical example and then organizes common work as a linked
cookbook. I used that pattern as a bar for concrete use cases and intra-API
navigation rather than treating one paragraph as sufficient method
documentation.

The Zed reference clone is pinned at
`da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f`. In
[`crates/acp_thread/src/acp_thread.rs`](https://github.com/zed-industries/zed/blob/da0a7a78cf296a6d8a75894f46b71a8e7f19cb2f/crates/acp_thread/src/acp_thread.rs#L4978-L5005),
Zed awaits a background timer, weakly updates an entity, and exits if the
entity was released. Its tests at lines 7545–7547 advance the test clock
explicitly and then drain ready work. These usages support the lifecycle and
clock examples in the guides.

The Hummingbird reference clone is pinned at
`2e1ee5f1c8d415ef7f835801fe368ab4106035b5`. In
[`src/library/playlist.rs`](https://github.com/hummingbirdapp/hummingbird/blob/2e1ee5f1c8d415ef7f835801fe368ab4106035b5/src/library/playlist.rs#L162-L251),
Hummingbird performs async Tokio work, returns to GPUI to update a tracker, and
detaches the owning GPUI task. Its [`src/settings.rs`](https://github.com/hummingbirdapp/hummingbird/blob/2e1ee5f1c8d415ef7f835801fe368ab4106035b5/src/settings.rs#L174-L206)
uses the same GPUI/Tokio boundary. These are useful consumers for the executor
choice and detached-lifetime discussion.

## Read-file inventory and coverage

I read these assigned files directly against implementation. “Complete” here
means public behavior and current docs were checked for this pass; it does not
mean every internal field is a supported public API. API docs received edits
where they were weak or contradictory; otherwise the existing descriptions
were retained when accurate.

Complete source/doc pass:

- `crates/gpui/src/executor.rs`
- `crates/gpui/src/platform_scheduler.rs`
- `crates/gpui/src/app/async_context.rs`
- `crates/gpui/src/app/test_context.rs`
- `crates/gpui/src/app/test_app.rs`
- `crates/gpui/src/app/bench_context.rs`
- `crates/gpui/src/app/headless_app_context.rs`
- `crates/gpui/src/app/visual_test_context.rs`
- `crates/gpui/src/test.rs`
- `crates/gpui/src/platform/test.rs` and `crates/gpui/src/platform/test/{dispatcher,platform,window,display}.rs`
- `crates/gpui/src/platform/visual_test.rs`
- `crates/gpui/src/platform/threaded_dispatcher.rs`
- `crates/gpui/src/platform/diagnostics.rs`
- `crates/gpui/src/profiler.rs`
- `crates/gpui/src/profiler/actions.rs`
- `crates/gpui/src/debug_overlay.rs` (the existing root edits were preserved)
- `crates/gpui/src/queue.rs`
- `crates/gpui_scheduler/src/{scheduler,executor,test_scheduler,clock}.rs`
- `crates/gpui_tokio/src/gpui_tokio.rs`
- `crates/gpui/docs/scheduling.md` and `crates/gpui/docs/testing.md`

The requested `crates/gpui/src/test/**` directory is absent in this checkout;
test helpers live in `crates/gpui/src/test.rs` and the app/platform test
modules listed above. Benchmark public methods and task/frame/action profiler
entry points were inspected individually.

Partial implementation review:

- `crates/gpui/src/profiler/journal.rs`: read the event model, snapshot
  calculations, collector, and interval sealer docs and implementation. The
  middle section wiring the global journal into foreground callbacks was not
  read line by line.
- `crates/gpui/src/profiler/hang.rs`: checked detector construction, event
  polling, serialized data shape, and active-window/detection logic. The entire
  contributor-conversion implementation was not audited line by line.

## Remaining review gaps

The source-derived documentation pass is complete for the assigned surfaces
except for the partial reviews above. No tests or builds were run because this
is documentation-only work. Rustdoc compilation and link validation remain
unverified, and root will independently reread and revise the prose before
integration.
