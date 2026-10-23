# Root review of the fixed legacy-packet comparison

The frozen 11-pair comparison completes all 22 fresh processes and 6,864 warmup/measured frames. Root independently reopens and hashes all 5,528 archive payloads and fourteen external ELF artifacts, parses/counts every measured frame CSV, and matches all 1,144 paired raw images byte-for-byte by size/hash. No source implementation is adopted.

Correctness and aggregate speed pass; independent per-cell regression fails. The median paired aggregate host ratio is 0.9366274241, total render/poll wall ratio 0.4417257137 and poll-wall ratio 0.4373844602. Host gates pass only 2/26 cells and total gates 22/26; there are 46 regression-rule failures. The worst host maximum-frame ratio is 1.8032928943 for rounded SDR motion, and worst total maximum-frame ratio is 2.5778517993 for flat SDR motion. The complete failed-cell and frame-row tables are copied beside this review. Aggregate gains do not override those failures.

The run lasts 207.673867 seconds, with unchanged preregistered workload, analyzer, thresholds and watchdogs. No retries or dropped cells occurred. Source/compiler/binary/quiet guards pass; ordinary system services and the existing package-store ticker remain visible in process snapshots. This is llvmpipe software Vulkan, not isolated-machine or hardware GPU evidence. Poll wall time is not a GPU timestamp; no startup or RSS result follows.

Static growth and full legacy uploads remain charged in the preceding legacy-coverage dossier. The earlier uniform-packet failed comparison remains separate and unchanged. This source is a useful work-elimination experiment with failed adoption gates, not a new shipping renderer.

The original gzip is stored in ordered parts smaller than 64 MiB. Reconstruct with `cat captures.tar.gz.part-* > /tmp/gpui-legacy-timing-frozen-campaign.tar.gz`; its SHA256 is recorded in root-verification.json. The producer README and all raw failed evidence remain byte-exact.
