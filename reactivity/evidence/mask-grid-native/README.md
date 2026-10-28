# Budget-preserving fine mask grid: rejected by early screen

This is the preregistered combined mask certificate/fetch-reuse/tile-selection/miss-reuse/fine-grid comparison against
the qualified suffix baseline. The earlier mask-address/four-cell native rejections
b8e6667b/58da795d remain unchanged. No application API, dependency, unsafe, new pipeline
or persistent cache additions. All64 fixed observations remain, with no retries
or threshold changes. Normal default ingress is exact for stream and owner for
idle/scroll/both; the summary route field denotes the requested knob.

| Mode | Paired median CPU ratio | Bootstrap95% | Gate | Verdict |
| --- | --- | --- | --- | --- |
| idle | 0.0 vs 0.0 observed cores; ratio undefined | — | no added CPU/updates | pass |
| scroll | 0.875697727 | [0.847234207, 0.927114238] | <= 1.05 | pass |
| stream | 0.865797657 | [0.800268375, 0.920098988] | <= 0.8 | fail |
| both | 0.870368870 | [0.742981928, 0.943701227] | <= 0.8 | fail |

CPU uses visible+1..6s process samples with>=4.8s coverage. Whole-run qualified
update counts do not prove identical work within that interval. Raw CPU/RSS,
cold visibility, every acknowledgement and all failures are retained. A failed
work/cadence cell suppresses the whole mode's ratio. Intervals describe uncertainty
and do not waive fixed point gates.

All execution gates: True. Failed work cells: [].

Baseline compiled 2684821f4519cab4fb14185be92edb2eb55bc84e; candidate compiled e117ad4b5997186aa066ce636fd1f72eccc2ba2b. Matched nightly2026-10-23,opt3,fatLTO,CGU1,debug0,stripnone,unwind,incrementalfalse. All34 workload tests and10 preflights pass; initial0/190 native images match exactly. Source/artifact/profile/driver/embeddedshader checks pass.

A separately sealed instrumented native audit verifies positive literal-tile selection, actual8x8 selection and lower first-packet planned sample work and exact initial images; its logs are not performance observations.

Early GPU admission seal dbc8777eb0f70a6c3fbcc543b95ad2a364a20aba verifies356 tests,strict Clippy,336 independent exact frames and the bounded coarse-address mutant (336 independently mismatched frames; internal tests pass). This is not full native/minimal/default/offline qualification. Production39efefe5 adds55 shipping lines over mask-miss parent (+234 over suffix). Matched-profile native ELF bytes: baseline 22523464, candidate 22532464. GPU JIT register pressure is not measured.

The candidate is rejected; no cost-matrix admission. Preserve its exact correctness result separately from this performance failure.

Run `python3 verify_dossier.py` to independently rederive the fixed64 observations, work gates, CPU intervals/bootstrap and source/shader/executable receipts. This software-Vulkan result establishes no ZGX advantage, physical GPU performance, scanout latency or quality parity. All changes local; the overall goal remains open.
