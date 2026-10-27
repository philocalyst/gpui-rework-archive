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
| `local/text-session-cache` / `/home/user/gpui-text-session-lab` | Owned font/planning scratch across passes | CPU-qualified at compatible `c7194c74e6`; complete dossier `bc964a0c0a`; unadopted pending broader gates, 3.3 MB retained long-paragraph scratch |
| `local/zgx-native-comparison` / `/home/user/gpui-native-comparison-lab` | Public native workload port + capacity stress | Diagnostic port `6d5e409d6b`; private X11 exercised, typography/control equivalence incomplete; no native ranking |

| `local/text-cache-bounded` / `/home/user/gpui-bounded-cache-lab` | Bound paragraph scratch | Memory gate passes at 45 KB; two CPU cells exceed 5%, unadopted; dossier `e6bda77dfc` |
| `local/gpu-draw-major` / `/home/user/gpui-draw-major-lab` | Load each draw once for sixteen samples | Rejected: exact pixels pass, text gains 7–9% miss 20%; complete `evidence/gpu-draw-major` dossier |
| `local/gpu-pixel-uniform` / `/home/user/gpui-pixel-uniform-lab` | Certify identical per-pixel coverage | Rejected: stripes 8.33x and text-stripes 30% faster but flat +16.6%; complete dossier `173e7c1a34`, 70 GPU tests and exact pixels |
| `local/text-cache-cold-trim` / `/home/user/gpui-cold-trim-lab` | BBTree-inspired cold path isolation | Complete dossier `6b03ad48ad`: 45 KB retention, median CPU gates pass but paired uncertainty remains; 1,045 composed tests and actual native Todo pass; unadopted |

| `local/tree-memory-lanes` / `/home/user/gpui-tree-lanes-lab` | Actual core parent walks: scalar/level/Future/prefetch/proof | Rejected: 2.48x deep level-loop gain, contiguous regression; complete six-way dossier, Miri and mutant |
| `local/tree-parent-columns` / `/home/user/gpui-tree-columns-lab` | Compact authoritative parent routing | Rejected: selective deep 4.11x but outlined scalar fallback 6.88x slower; complete six-way dossier and code-generation evidence |
| `local/tree-admitted-walk` / `/home/user/gpui-tree-admitted-lab` | Validate parent walk once per immutable borrow | Unadopted: deep 3.71x, longer shallow +9.86% and single-full +5.05%; complete dossier `ef335bb664`, 1,044 composed tests and native Todo pass |

| `local/delivery-sweep` / `/home/user/gpui-delivery-sweep-lab` | Structural admission of inbox/task work | Rejected: 64 ready +2.61%, budget-one +14.2%; 707 tests/exact outputs pass, assembly proves indexed control uses jump tables |

| `local/source-batch-publication` / `/home/user/gpui-source-batch-lab` | Preserve distinct typed text edits through one publication | Numerical gates pass: 25–27% less complete publication CPU at 1000 labels; 711 default / 1049 composed tests and six actual native scripts; complete dossier `1830d9d54f`, local application trial candidate, uncertainty/hardware limits remain |

| `local/question-source-set` / `/home/user/gpui-question-source-set-lab` | Preserve exact typed source sets through one Question graph refresh | Rejected performance variant: unrelated 1000-label 18.0x/16.6x gains, dependent25 +5.394% and owner1000 +5.134% fail controls; complete dossier `394e246b9b`, 718 default / 791 native GPUI tests and six actual native scripts |

| `local/question-source-borrowed` / `/home/user/gpui-question-source-borrowed-lab` | Borrow source authority for one synchronous graph refresh | Separate preregistered ABI/code-generation hypothesis; qualification started |
| `local/sparse-text-batch` / `/home/user/gpui-sparse-batch-lab` | Atomically prepare disjoint sparse command/geometry runs | Separate preregistered candidate `6a2cea6a5c`; collective resource-use and rollback gates started |

[BBTree transfer research](../bbtree-transfer/README.md) records the pinned
implementation, failed historical trials, applicability and next hypotheses.

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
