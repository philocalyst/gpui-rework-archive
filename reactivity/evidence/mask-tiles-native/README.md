# Certified mask tile traversal: rejected by early screen

This is the preregistered combined mask certificate/fetch-reuse/tile-selection comparison against
the qualified suffix baseline. The earlier mask-address/four-cell native rejections
b8e6667b/58da795d remain unchanged. No application API, dependency, unsafe, new pipeline
or persistent cache additions. All64 fixed observations remain, with no retries
or threshold changes. Normal default ingress is exact for stream and owner for
idle/scroll/both; the summary route field denotes the requested knob.

| Mode | Paired median CPU ratio | Bootstrap95% | Gate | Verdict |
| --- | --- | --- | --- | --- |
| idle | 0.0 vs 0.0 observed cores; ratio undefined | — | no added CPU/updates | pass |
| scroll | suppressed | — | work/cadence | fail |
| stream | 0.923431477 | [0.843563731, 0.951912205] | <= 0.8 | fail |
| both | suppressed | — | work/cadence | fail |

CPU uses visible+1..6s process samples with>=4.8s coverage. Whole-run qualified
update counts do not prove identical work within that interval. Raw CPU/RSS,
cold visibility, every acknowledgement and all failures are retained. A failed
work/cadence cell suppresses the whole mode's ratio. Intervals describe uncertainty
and do not waive fixed point gates.

All execution gates: True. Failed work cells: [{"mode": "scroll", "group": 4, "name": "baseline"}, {"mode": "scroll", "group": 0, "name": "baseline"}, {"mode": "both", "group": 1, "name": "baseline"}, {"mode": "scroll", "group": 6, "name": "baseline"}, {"mode": "both", "group": 0, "name": "baseline"}].

Baseline compiled 2684821f4519cab4fb14185be92edb2eb55bc84e; candidate compiled f21f5dab4247fc98860a10a655ba625a4790a681. Matched nightly2026-10-23,opt3,fatLTO,CGU1,debug0,stripnone,unwind,incrementalfalse. All34 workload tests and10 preflights pass; initial0/190 native images match exactly. Source/artifact/profile/driver/embeddedshader checks pass.

A separately sealed instrumented native audit verifies positive literal-tile selection and exact initial images; its logs are not performance observations.

Early GPU admission seal 6d4d44a31de30c418167a97cf977e5634d453a8f verifies353 tests,strict Clippy,336 independent exact frames and the bounded wrong-row proof-toggle mutant (1,836 differing bytes). This is not full native/minimal/default/offline qualification. Productiond63782dd adds18 shipping lines over four-cell parent (+153 over suffix). Matched-profile native ELF bytes: baseline 22523464, candidate 22529376. GPU JIT register pressure is not measured.

The candidate is rejected; no cost-matrix admission. Preserve its exact correctness result separately from this performance failure.

Run `python3 verify_dossier.py` to independently rederive the fixed64 observations, work gates, CPU intervals/bootstrap and source/shader/executable receipts. This software-Vulkan result establishes no ZGX advantage, physical GPU performance, scanout latency or quality parity. All changes local; the overall goal remains open.
