# Scroll output layout and outlined submission: failed gate

Local, unadopted experiment. Frozen candidate 0ac7b8914b1c7b837f8d65a9be3d20ccb52cbff6;
protocol 3e0695d720a433927b990b0fa7d68ab0d3c9d9fc. Original control 6269bdfafc,
failed scroll-copy predecessor 8eebb25bd8. No application API change.

All comparisons against the original control pass the fixed point thresholds.
However tiny-list candidate/predecessor is 1.108649280, above the fixed 1.05 limit;
95% paired bootstrap interval [0.968239,1.243926]. This fails the experiment.
The wide interval does not establish a precise causal slowdown and does not reverse
the registered verdict. No threshold adjustment, selective adoption or ZGX claim.

450 fresh timing processes, 90 qualification processes and 30 allocation processes
pass final independent full GPU pixels, cross-variant hashes/epochs and intended
work counters. Timing overlapped no owned builds, tests, allocation probes or
cleanup. Fixed seed 20261028; 15 groups/case, three variants in cyclic permutation;
16 warmup and 64 measured updates. Estimator is median of paired process medians;
intervals use 10000 paired bootstrap resamples. Raw p50/p95/p99, mount, first frame,
first update, work and allocation records are retained.

| Case | Candidate/control | 95% interval | Candidate/predecessor | 95% interval | Gate |
|---|---:|---|---:|---|---|
|scroll|0.084791941|[0.081140, 0.092193]|1.029786873|[1.000103, 1.064298]|pass|
|both|0.443562072|[0.440108, 0.449755]|1.000346572|[0.988553, 1.006379]|pass|
|stream|0.996951904|[0.985720, 1.004287]|0.998442705|[0.985042, 1.006630]|pass|
|stream-owner|0.998767977|[0.977031, 1.006031]|1.001603949|[0.997920, 1.005330]|pass|
|fractional|0.995204236|[0.988618, 1.001127]|1.000803788|[0.993754, 1.010583]|pass|
|flat-tiny|0.865272963|[0.848474, 0.984846]|0.998826968|[0.949927, 1.020713]|pass|
|flat-full|1.003070521|[0.992612, 1.071625]|1.028910676|[1.004191, 1.093789]|pass|
|list-tiny|0.495919972|[0.478726, 0.575915]|1.108649280|[0.968239, 1.243926]|**FAIL**|
|list-flat|0.102938200|[0.093934, 0.107117]|0.939607482|[0.909919, 1.051005]|pass|
|exposure|0.982880237|[0.857357, 1.017078]|0.991288553|[0.898858, 1.026082]|pass|

Complete measured work is public model update, owner/scene preparation, native GPU
packet bridge, explicit GPU completion and ACK on a ready device. OS dispatch,
producer transport, WSI, device initialization and scanout remain outside the gate.
Software Vulkan in this VM establishes neither hardware performance nor cache hits.
The later qualified image-placement correction is absent from all three variants;
these ten workloads contain no images. Composition and requalification are required
before any adoption, independently of this failed performance result.

Correctness: 995 default GPUI/Canvas tests (13 ignored), 1080 X11 tests (45 ignored),
74 GPU tests, strict all-target Clippy, 10 standalone native workload-port tests and
11 actual native scripts pass. Fresh mutant d5a18723d1 changes retained repair Load
to Clear and fails complete pixels. Original contribution/token mutants remain in
predecessor dossier 8041b7a7fe. Every all-input guard is clean. Executed artifacts
are preserved by content hash; verify.py checks the receipts and recorded verdict.

Output uses a closed Full/Region/Scroll descriptor. Output 48→40 bytes and SlotGuard
88→80 restore the original footprint. Scroll submission is outlined. Backing stays
192 bytes (original 112); retained scratch and exact token/contribution proof are
unchanged. submit is 695 bytes / 1344 explicit local stack bytes versus predecessor
1176/1344 and original 636/1344; new submit_scroll adds 945/1320. Retained render is
2300/792 versus 2235/792 and original 2117/664. Main presentation remains 26776 bytes,
4096+248 local stack versus original 25808 and 4096+216. These are prologue local
allocations, not complete call-stack bounds. Whole native example grows
26329184→26329864 bytes (original 26306600). Shipping first-party code is 37473 lines,
+39 over predecessor and +511 over original. No vendor/dependency/shader changes.

Warm allocation and explicit image/copy costs equal the failed predecessor. Admitted
960×720 scroll retains 4185280 GPU image bytes versus original 2764800 and copies
1401440 pixels versus 691200. Ordinary cases keep original image/copy costs.
Allocation observations cover the invoking thread; they are not total process or
physical driver memory. See allocation-summary.json for all cases and raw logs for
cold SETUP_ALLOC records. No total code, memory or stack reduction is claimed.

The next experiment must remain isolated with its own preregistered hypotheses,
correctness witnesses and complete cost controls. The campaign goal remains open.
