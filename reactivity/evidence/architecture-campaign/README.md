# Local architecture campaign: active, no competitor victory

User scope: improve the clean-room GPUI architecture against ZGX with little or
no application API change. Keep every change local. Follow the repository's
isolated worktree, preregistration, freeze, oracle, mutant and evidence rules.

| Local branch / worktree | Experiment | Current disposition |
| --- | --- | --- |
| `local/architecture-performance` / `/home/user/gpui-architecture-local` | Retained GPU output | Unadopted; sparse software-Vulkan wins, flat/full-damage losses; exact pixels and actual private X11 exercised |
| `local/state-segments` / `/home/user/gpui-state-lab` | Full state-update control | Production baseline `75a9e2b06b`, identical model/font and independent final pixel oracle |
| `local/text-witness-replay` / `/home/user/gpui-text-witness-lab` | Replay admitted unchanged text witnesses | Rejected: 15% gain misses 20% target and 10K-label regression exceeds 5%; complete dossier at `reactivity/evidence/state-segments` |
| `local/sparse-text-publication` / `/home/user/gpui-sparse-text-lab` | Bounded text run + sparse C/P publication | Inconclusive: large wins but noisy zero-static cell; complete dossier at `reactivity/evidence/sparse-text`, commit `a91fd03b9b` |
| `local/text-session-cache` / `/home/user/gpui-text-session-lab` | Owned font/planning scratch across passes | Unadopted; first three-way campaign clears CPU gates, broader build caught an API borrow regression; fixed at `c7194c74e6`, 1044 tests pass, performance requalification pending |
| `local/zgx-native-comparison` / `/home/user/gpui-native-comparison-lab` | Public native workload port + capacity stress | Preregistered at `9386fc0fca`; port and output qualification in progress; no native performance result |

All later candidates start from the retained-output experiment, so their gains
are not independent adoption evidence for that earlier GPU change. Application
View/Signal/Source remain unchanged. The text cache adds lower-level APIs only;
its original scoped `shaper()` retains non-lexical borrow compatibility.

Unmodified ZGX is pinned at `a3678578980ef239058c557338ef9c544d356b0c`
in `/home/user/zgx-reference-local`. Its unchanged `RENDER=0` microbenchmark
performs layout/damage while GPUI's recorder additionally materializes canonical
glyph commands. Those endpoints and initial profiles differ: no speed ranking
may be derived from their numbers. Native equivalents must match typography,
content, overscan, controls, timing and acknowledged output before measurement.

This VM has no `/dev/dri`. Software Vulkan is llvmpipe, not a hardware GPU.
The documented `ssh mothership` does not resolve and no SSH keys are installed.
Hardware access has been requested from the user; meaningful implementation and
local qualification continue while it is pending. Two hardware classes and the
required platform/feature gates remain necessary for a competitor victory.

External raw staging directories are `/home/user/gpui-state-evidence`,
`/home/user/gpui-sparse-text-evidence`, `/home/user/gpui-text-session-evidence`
and `/home/user/gpui-native-evidence`. Completed experiments copy their raw data,
failures, source/compiler/binary receipts and independent verifier into their
own committed dossier. Pending staging data is not an acceptance verdict.
