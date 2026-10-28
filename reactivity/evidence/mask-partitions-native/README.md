# Certified sample partitions: rejected by early screen

This is the preregistered combined mask certificate/fetch-reuse/tile-selection/miss-reuse/partition comparison against
the qualified suffix baseline. The earlier mask-address/four-cell native rejections
b8e6667b/58da795d remain unchanged. No application API, dependency, unsafe, new pipeline
or persistent cache additions. All64 fixed observations remain, with no retries
or threshold changes. Normal default ingress is exact for stream and owner for
idle/scroll/both; the summary route field denotes the requested knob.

| Mode | Paired median CPU ratio | Bootstrap95% | Gate | Verdict |
| --- | --- | --- | --- | --- |
| idle | 0.0 vs 0.0 observed cores; ratio undefined | — | no added CPU/updates | pass |
| scroll | 0.877526746 | [0.836958307, 0.889408500] | <= 1.05 | pass |
| stream | 0.882167801 | [0.831852495, 0.935429339] | <= 0.8 | fail |
| both | suppressed | — | work/cadence | fail |

CPU uses visible+1..6s process samples with>=4.8s coverage. Whole-run qualified
update counts do not prove identical work within that interval. Raw CPU/RSS,
cold visibility, every acknowledgement and all failures are retained. A failed
work/cadence cell suppresses the whole mode's ratio. Intervals describe uncertainty
and do not waive fixed point gates.

All execution gates: True. Failed work cells: [{"mode": "both", "group": 0, "name": "baseline"}].

Baseline compiled 2684821f4519cab4fb14185be92edb2eb55bc84e; candidate compiled 0b60a96399b381c6fda0a4706b05e08f85dd9396. Matched nightly2026-10-23,opt3,fatLTO,CGU1,debug0,stripnone,unwind,incrementalfalse. All34 workload tests and10 preflights pass; initial0/190 native images match exactly. Source/artifact/profile/driver/embeddedshader checks pass.

An inherited sealed native audit verifies literal-tile selection for byte-identical host renderer and workload inputs. Its old shader and planned counts are not new partition execution counters or performance observations. New uninstrumented preflight images match exactly.

Early GPU admission seal a0086d6dd1ae8cd4e4869e88851885b03c73989b verifies354 tests,strict Clippy,336 independent exact frames and the bounded horizontal-cut proof-toggle mutant (3,855 differing bytes). This is not full native/minimal/default/offline qualification. Productionddf9f4b6 adds76 shipping lines over mask-miss parent (+255 over suffix). Matched-profile native ELF bytes: baseline 22523464, candidate 22532832. GPU JIT register pressure is not measured.

The candidate is rejected; no cost-matrix admission. Preserve its exact correctness result separately from this performance failure.

Run `python3 verify_dossier.py` to independently rederive the fixed64 observations, work gates, CPU intervals/bootstrap and source/shader/executable receipts. This software-Vulkan result establishes no ZGX advantage, physical GPU performance, scanout latency or quality parity. All changes local; the overall goal remains open.
