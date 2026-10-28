# Whole-pixel certified mask miss: rejected by early screen

This is the preregistered combined mask certificate/fetch-reuse/tile-selection/miss-reuse comparison against
the qualified suffix baseline. The earlier mask-address/four-cell native rejections
b8e6667b/58da795d remain unchanged. No application API, dependency, unsafe, new pipeline
or persistent cache additions. All64 fixed observations remain, with no retries
or threshold changes. Normal default ingress is exact for stream and owner for
idle/scroll/both; the summary route field denotes the requested knob.

| Mode | Paired median CPU ratio | Bootstrap95% | Gate | Verdict |
| --- | --- | --- | --- | --- |
| idle | 0.0 vs 0.0 observed cores; ratio undefined | — | no added CPU/updates | pass |
| scroll | 0.961561475 | [0.938169310, 1.011688005] | <= 1.05 | pass |
| stream | 0.896043156 | [0.873979826, 0.954716972] | <= 0.8 | fail |
| both | 0.915155878 | [0.892158435, 0.941034601] | <= 0.8 | fail |

CPU uses visible+1..6s process samples with>=4.8s coverage. Whole-run qualified
update counts do not prove identical work within that interval. Raw CPU/RSS,
cold visibility, every acknowledgement and all failures are retained. A failed
work/cadence cell suppresses the whole mode's ratio. Intervals describe uncertainty
and do not waive fixed point gates.

All execution gates: True. Failed work cells: [].

Baseline compiled 2684821f4519cab4fb14185be92edb2eb55bc84e; candidate compiled 423a0cd0bdb3fba9af3c91a300499296b17ff18f. Matched nightly2026-10-23,opt3,fatLTO,CGU1,debug0,stripnone,unwind,incrementalfalse. All34 workload tests and10 preflights pass; initial0/190 native images match exactly. Source/artifact/profile/driver/embeddedshader checks pass.

A separately sealed instrumented native audit verifies positive literal-tile selection, a nonzero first-packet planned miss population and exact initial images; its logs are not performance observations.

Early GPU admission seal e97729cbb03e71890f4f8efb97ce1920594284ca verifies353 tests,strict Clippy,336 independent exact frames and the bounded overbroad-miss proof-toggle mutant (3,718 differing bytes). This is not full native/minimal/default/offline qualification. Productionb817779c adds26 shipping lines over mask-tiles parent (+179 over suffix). Matched-profile native ELF bytes: baseline 22523464, candidate 22530144. GPU JIT register pressure is not measured.

The candidate is rejected; no cost-matrix admission. Preserve its exact correctness result separately from this performance failure.

Run `python3 verify_dossier.py` to independently rederive the fixed64 observations, work gates, CPU intervals/bootstrap and source/shader/executable receipts. This software-Vulkan result establishes no ZGX advantage, physical GPU performance, scanout latency or quality parity. All changes local; the overall goal remains open.
