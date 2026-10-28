# Exact suffix native cadence screen — frozen continuation

This executes the32-process native screen already preregistered at
0a7f3b822b09744e7e45a1ac9961d8aaa183a416. The complete correctness qualification
of production df8ca59f69813e7dd05711fead98ed4278f1688d is sealed at
380db598cdbed2dd81c5a41745473c40a876f148:349 GPU/Canvas,1108 full native,329 minimal,
1015 default,79 offline tests; strict Clippy,17 workload tests in both native
configurations,15 actual X11 scripts,100 fresh growing-text frames and a pixel
omission mutant. No timing or performance acceptance there.

Unique branch local/damage-suffix-native, worktree
/home/user/gpui-damage-suffix-native-lab, fresh native-profile target
/home/user/gpui-damage-suffix-native-target, external evidence
/home/user/gpui-damage-suffix-native-evidence. Production/example/shader source
is exactly df8ca59f; this checkpoint adds protocol documentation only.
Baseline is the exact preserved native-workspace candidate ELF from03ca419868b0,
with native dossier344c7f8ddd55326dca2c88322f67530914c97733. Source guards validate
all first-party/vendor/build inputs; duplicate inherited documentation removed
from its checkout is byte-preserved in the verified source archive and Git.
Reuse original profile/build/test/shader receipts, not cached target paths.

Candidate builds with the exact baseline native profile: nightly-2026-10-23,
opt3/fat LTO/CGU1/debug0/no stripping/unwind/incremental false, RUSTFLAGS
-C symbol-mangling-version=v0 --cfg tokio_unstable, locked/offline/checksum freshness.
Run17 workload example tests in this profile; preserve fresh Cargo objects,
actual ELF hashes, source guards and canonical generated/embedded shader bytes.
No implementation, application, cadence, buffer policy or shader edit. Prefer
12GiB before large builds; when unavailable after verified cleanup, admit this
known ~1.1GiB native-only profile build with an explicit8GiB hard reserve and
continuous stop monitor. Record actual starting/minimum free space.

Before timing, both variants get initial190 idle image capture plus3s stream
runs through each ingress route. Require exact equal frozen images, font hashes,
960x720 geometry, normal exit and no workload/presentation error. These are
untimed qualification, not repeatable tuning runs. Source/API equivalence retains
existing UI-owned producer and optional owner callback unchanged.

PROCESS_ORDER.json is the original fixed seed20261109 balanced AB/BA schedule:
eight pairs through exact ingress and eight through owner ingress,32 fresh
processes,8s each, initial0, GPUI_LAB_TRACE=1 in both. Every candidate must admit
464–488 updates and have<=2 ACK gaps>25ms with ending time<1s from first
presentation. Both bounds are unchanged. Preserve all32 observations and every
failure, without retry or selected subset. Baseline failures remain diagnostics.
Record process CPU/RSS every20ms with descriptive visible+1..6 interval>=4.8s;
whole-run counts do not establish equal work in that interval. No CPU superiority
ratio or ZGX victory is inferred from this startup screen. Full ACK source/
presentation epochs, repeated callbacks and all command/status logs are retained.

Same X11 :94, software Vulkan, LP_NUM_THREADS=4, scale1, existing font and960x720.
Freeze source/artifacts/order/runner/analyzer/independent verifier before timing;
no build/test/edit/analysis/cleanup overlaps observation. Finish the schedule and
reap every process. Failure rejects this candidate before the warm matrix. Success
admits the separate4160-process28-case <=1.05 regression gate already specified,
then the unchanged ZGX native and physical-hardware/quality requirements. This
trial cannot itself complete the user's overall goal. Everything stays local.
