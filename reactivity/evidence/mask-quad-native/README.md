# Four-cell mask reuse: rejected by early screen

This is the preregistered combined certificate/fetch-reuse comparison against
the qualified suffix baseline. The earlier mask-address-only native rejection
b8e6667b remains unchanged. No application API, dependency, unsafe, new pipeline
or persistent cache additions. All64 fixed observations remain, with no retries
or threshold changes. Normal default ingress is exact for stream and owner for
idle/scroll/both; the summary route field denotes the requested knob.

| Mode | Paired median CPU ratio | Bootstrap95% | Gate | Verdict |
| --- | --- | --- | --- | --- |
| idle | 0.0 vs 0.0 observed cores; ratio undefined | — | no added CPU/updates | pass |
| scroll | 1.020634540 | [0.976890572, 1.089197761] | <= 1.05 | pass |
| stream | 0.955163432 | [0.909938804, 0.987780127] | <= 0.8 | fail |
| both | suppressed | — | work/cadence | fail |

CPU uses visible+1..6s process samples with>=4.8s coverage. Whole-run qualified
update counts do not prove identical work within that interval. Raw CPU/RSS,
cold visibility, every acknowledgement and all failures are retained. A failed
work/cadence cell suppresses the whole mode's ratio. Intervals describe uncertainty
and do not waive fixed point gates.

All execution gates: True. Failed work cells: [{"mode": "both", "group": 2, "name": "candidate"}].

Baseline compiled 2684821f4519cab4fb14185be92edb2eb55bc84e; candidate compiled fdff0f361c60af149a2b81509548f987490fbf1d. Matched nightly2026-10-23,opt3,fatLTO,CGU1,debug0,stripnone,unwind,incrementalfalse. All34 workload tests and10 preflights pass; initial0/190 native images match exactly. Source/artifact/profile/driver/embeddedshader checks pass.

Early GPU admission seal e00f436fbfef57bdc0379df6e46c6888d7855097 verifies353 tests,strict Clippy,336 independent exact frames and96 mismatched frames from the bounded wrong-row mutant. This is not full native/minimal/default/offline qualification. Production7565d788 adds74 shipping lines over mask-address parent (+135 over suffix). Matched-profile native ELF bytes: baseline 22523464, candidate 22528168. GPU JIT register pressure is not measured.

The candidate is rejected; no cost-matrix admission. Preserve its exact correctness result separately from this performance failure.

Run `python3 verify_dossier.py` to independently rederive the fixed64 observations, work gates, CPU intervals/bootstrap and source/shader/executable receipts. This software-Vulkan result establishes no ZGX advantage, physical GPU performance, scanout latency or quality parity. All changes local; the overall goal remains open.
