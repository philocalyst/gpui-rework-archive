# Certified region batching: fixed cost gate

Frozen after candidate correctness and before any cost observations. This refines,
without relaxing, protocol74df3dee3d25a1b4298b98825a6a161811c5203a. Implementation
and executed candidate binaries are at1f16b73c56f10044a4186c90fb69ffe3d4047ac6 in
`/home/user/gpui-region-batch-lab`; that source stays frozen. This research dossier
holds the separate cost preregistration so documentation does not perturb its
compiled-source guards.

Candidate qualification:76 default GPU tests,78 offline-shader tests,1094 composed
GPUI/Canvas tests,327 minimal-native library tests,17 native port tests in each
profile,11 actual native and4 minimal-native scripts; all applicable strict Clippy
gates pass. Default nonnative production/old window-sequence mutant are inherited
with exact source equality. Fresh omitted-instance mutante19fec3f0269 fails the
67x53 GPU pixel oracle: first pixel44,9,78,255 versus244,242,250,255. No performance
or hardware conclusion follows. Preserve all earlier compile/fixture failures.

The new fixture preserves the ordinary maximum-axis geometry precision rejection.
At16384 it checks same-scene clear packet/addressing, which alone cannot falsify
missing coverage. Actual changed edge/hole pixels are compared at67x53,257x1,
1x257,8191x1,1x8191 across three formats,64 instances and overflow. Canonical
fragment WGSL remains ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1.
The separate vertex WGSL is6af2f8ac8608e407756c3d4afd2bfe736f58886bc193be00fecbf8c0577afc0c.

Four controls, with unique targets and identical current deferred-control example,
scroll_bench/text_cost fixtures, manifests, lockfile and compiler configuration:
corrected original20919cb160f6, bounds-onlyd67a538b9502, failed static sparse
c965a893364b, and candidate1f16b73c56f1. The first three are rebuilt for this
repository-default release profile. Old fat-LTO or old-app executables are not
substituted. Inherit only unchanged prior whole-core gates by explicit source
comparison; rerun current unit/port/GPU/Clippy gates and all per-regime witnesses.

COST.json fixes28 regimes and all thresholds. PROCESS_ORDER.json fixes2688 fresh
processes:24 balanced groups per regime, all24 four-way orders, shuffled by seed
20261103. Each process executes16 warmups and64 measured updates. Before timing,
run three correctness processes per variant/regime (336) and one separate
allocation process (112), each16 warmups plus4 updates. Verify full GPU oracle
pixels, small-case independent CPU oracle, exact source/model/owner-run work,
retained-image/copy counters and identical final hashes/epochs across controls.

Primary estimator: median of24 paired process-p50 ratios, type7 quantiles;
10000 paired bootstrap draws with seed20261103. Both stream and stream-owner must
be<=0.8 against original AND static sparse, and<=1.05 against bounds. Every other
case must be<=1.05 against every control. Preserve all pairs and failed gates;
no post-measurement threshold/region-count tuning, selective reruns or promotion
of a successful subset. Report cold setup/first regional use, all warmup/raw/tail
observations, allocations, retained capacities, whole executable and selected
caller code/stack separately. A local stack reservation is not a call-chain bound.

Candidate shipping lines37613 (+241 versus static sparse), no vendor/dependency
change; Backing120B (+8), cold RegionBatch40B plus1024B GPU instance buffer;
Renderer888B, RetainedRenderer920B, Runtime1824B unchanged. Pipeline/driver and
queue-upload allocations, CPU scratch and first-use compilation are not free.
Full scene packet preparation and full image copy remain charged.

Same pinned nightly2026-10-23, locked/offline release, private X11:94 and llvmpipe
LP_NUM_THREADS=4;8GiB minimum free. No compilation, other tests, allocation probes,
source changes, analysis or cache cleanup during timed jobs. Freeze source, actual
ELFs, typed/generated/embedded shaders and environment guards first. Endpoint is
owner operation through native bridge GPU completion/ACK, not active-host dispatch,
WSI or scanout. Only a complete passing gate permits the separately specified
matched-profile native comparison. Hardware/quality/manual input equivalence and
two hardware classes remain required for the overall ZGX goal. All work stays local.
