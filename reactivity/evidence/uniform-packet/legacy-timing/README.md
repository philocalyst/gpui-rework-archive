# Frozen legacy299c versus shipping campaign: regression gate failed

Candidate GPU and all non-GPU inputs are 299c6aca30c1245c15c2da6a5ccabb41dd435d17.
Comparator GPU is shipping 7a5e1619a27010ec63f6c27506a6d1fcd113f67c.
Both actual fresh:false opt3/default SIMD+vulkan-tests timing binaries were built
at /tmp/gpui-legacy-timing-sol with the same qualified Rust/Cargo 1.97.1, locked
dependencies and root v0/tokio flags; no emit-stack-sizes flag was used. No
production renderer or ordinary public fixture path changed for observation.
The immutable protocol, runner/analyzer/build source, exact GPU snapshots,
1,380 frozen compiler-input source files, complete 7,548-file tracked manifest,
root config/lock, compiler executable hashes and Cargo fingerprints remain.

Correctness PASS; independent speed PASS; independent regression FAIL.
The candidate remains unadopted. There were 46 regression-rule failures.
Only 2/26 host cells and 22/26 total cells pass all corresponding regression
rules. Speed passing does not change any failed cell or adoption eligibility.

Root quiet GO was recorded 2026-10-23T18:32:51.713610Z. Actual campaign start:
2026-10-23T18:32:52.068260Z; end 2026-10-23T18:36:19.761599Z; elapsed 207.673867s.
All 22 fixed fresh-process legs/11 AB-BA pairs completed, exits 0, without
retries, omissions, deadline expiration, changed guards or recorded quiet
breaches. All 11 paired readback sets are exact, including HDR bits and motion
parities. Every leg has 26 cells, 3 warmups and 9 sampled frames: 6,864 raw frames,
5,148 sampled frames and 2,288 raw GPU readbacks. Calibration separately retains
52 exact readbacks per binary/35,651,584 bytes, matching the prior frozen
reference; calibration clocks are unqualified.

Equal-cell paired-geometric-mean median candidate/shipping ratios:

| Metric | Median paired ratio | Faster process pairs |
|---|---:|---:|
| Host render/submit wall |0.9366274241452061|10/11|
| Complete frame wall |0.4417257136541153|11/11|
| Device-poll synchronization wall |0.4373844601789711|11/11|

Seven fixed families satisfy the total speed condition. runs32k and
singletons32k do not. Full aggregate/per-cell/raw diagnostics remain in
measure/analysis.json. measure/per-cell-report.md and per-cell-gate-ledger.csv
list every exact cell gate. Total regression failures are flat SDR/motion,
runs32k SDR/static, and singleton32k SDR/static and motion. All other total
cells pass; host passes only layers8 SDR/static and runs32k SDR/motion.

Worst host maximum-frame ratio: 1.8032928942807627, rounded SDR/motion pair 2;
candidate frame 5=131,103ns versus shipping maximum frame 8=72,702ns.
Worst total maximum-frame ratio: 2.5778517992682795, flat SDR/motion pair 3;
candidate frame 5=1,652,287ns versus shipping maximum frame 8=640,955ns.
These rows were retained and failed their fixed gates. No outlier trimming,
noise exception, retry or relaxed allowance was applied. Full source rows and
all frame-tail failures are in measure/worst-frame-rows.json.

Execution is Ryzen 3700X/powersave, Mesa 26.1.4 llvmpipe CPU Vulkan, without a
render node. Poll is synchronization wall time, not GPU timestamp execution.
No hardware GPU, startup, scanout, foreign-runtime or RSS claim follows.
Normal services and an existing unrelated package-store ticker remained, as
Root explicitly acknowledged at GO; this was not an isolated machine. Saved
snapshots cover before/during/after execution. Root held other team builds,
tests/native/archive workloads, then released quiet after completion. All
owned campaign/native/shell children exited and were reaped.

All numeric correctness/regression/max-frame/speed gates and the byte-identical
analyzer remain the frozen v3 controls. All 8 deterministic positive/fault
controls passed before timing. Every source/compiler/binary/frozen guard passed
after execution; postrun-guards.json records it. Strict host IEEE implication
to the inherited CPU tile predicate is the proof scope; it is not a universal
WGSL IEEE or altered DAZ/FTZ proof. Actual output correctness is limited to
qualified adapters/readbacks and the inherited predicate's separate envelope.

Static and payload costs remain fully charged: +142 core non-test/comment LOC,
+5,376 linked text bytes versus shipping; +209 lines/+5,584 text versus legacy 277.
Render body/frame 9,520/1,448 versus shipping 9,493/1,416 and 277 9,296/1,432;
bin_draw 4,531/840 versus 4,184/824 in both controls. New whole proof 1,462/frame 248,
axis 1,662/frame 344 and all helper/caller code are charged. Static metadata frames
are not dynamic peak stack. There are no added proof heap allocations or retained
fields, but legacy common records retain +16 bytes/group versus the rejected
uniform ABI and full ordinary warm uploads. runs32k warm upload 1,108,272 bytes,
singleton32k 3,076,272, versus uniform a81's 4,176 in both fixed cells. Observed
capacity sums exclude allocator overhead and do not measure RSS. Complete costs,
all actual linked assembly/fingerprints and exact core inventories are included
under static-cost with their original source/config/ELF provenance. They were
not rebuilt or relabelled as timing results.

All earlier archives and 6158/299c sources/captures remain intact. The campaign
archive hashes every payload, excludes actual ELF bytes, and records exact
external binary paths/sizes/hashes including compiler executables. Verification
reopens every tar member, checks size/hash, and explicitly counts all 22 legs,
6,864 CSV rows and 2,288 raw measured readbacks. The independent Root copy can
verify the external archive hash, extract capture-manifest.json and recheck
every listed member. Raw failures and passing speed evidence stay together;
this sealed campaign does not authorize adoption or a timed retry.
