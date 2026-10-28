# Raw control provenance

- `baseline/headers.log`, `baseline/schema.log`:9604f10c3f instrumentation, production8ea, default(simd). No saved old default-unit executable digest exists; do not associate a candidate digest with these logs.
- `baseline/clients-build.log`, sections/symbols/binary digests:ba48a22b90, release default, unchanged client/library workload.
- `facade/` sections/symbols/binary digests, facade headers/Clippy/lines and external-facade: e51355fef4 facade shipping source. Initial build-time logs include different dependency-cache states and do not establish a speed comparison.
- `panel-public-frozen.log`, `panel-headers-frozen.log`, `panel-lines.json`, `external-panel.log`:07a0698759 initial panel.
- `final-*`:579e956f30 final source. Exact lock/manifest/toolchain/source blobs, client source guards, native executable SHA256 and commands are provided alongside the logs. Candidate final values take precedence over earlier snapshots.
- `property-first`, `external-first`, `panel-first`, `panel-rejection`, `panel-public-first`, `panel-public-second`, `panel-public-all`, initial `panel-clippy`, and `native-first` are archived development diagnostics. Some predate a frozen commit; they are not pinned benchmark or final validation claims. In particular, the initial public-query failure is retained rather than recategorized as a candidate pass. The final commit and fresh gates are the reproducible authority.

Complete symbol files are gzip-compressed without a timestamp. Large linked binaries remain in `/tmp/gpui-typed-catalog-evidence/{baseline,facade,final}/binaries` with SHA256 records; they are not checked into Git. All recorded source/client hashes are exact Git object or SHA256 values, not only branch labels.
