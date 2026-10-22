# First raster-cache candidate: rejected as a standalone change

This is the unchanged first paired campaign, not the final adopted result.
Parent `b1fc101435` and candidate `3724ece72f` ran in six alternating fresh
processes on 2026-10-22, 00:48:25–00:48:27 UTC. Source, fixture and frozen
binary guards passed; all six image digests agreed in each process. No run was
excluded. The raw process/pressure records and every result remain here.

Same-tile repair fell from 44.514 to 3.090 µs, but alternating distant repair
rose from 44.453 to 90.955 µs (+104.6%). The standalone candidate was rejected.
First blank CPU output was 3.652 versus 3.664 µs; first 4,096-panel output was
2.812 versus 2.811 ms. Those close cold results are not startup improvements.
The extra first-raster 80-byte owner allocation and net 16-byte active-header
increase are charged explicitly; recording-only Canvas saves 64 bytes.

The [subsequent five-way controls](../../../benchmarks/bin-miss/README.md)
identify the emitted command-copy/helper-call cost, remove full-command
reconstruction from membership construction, and reuse any containing cache.
Their final implementation, integrated at `de18f040c9`, fixes the regression.
These are separate captures; do not pool their samples or rewrite this first one.

`initial-unused-mut-clippy.txt` preserves the first lint failure; `clippy.txt`
preserves its correction. No production unsafe code or GPU/native performance
claim is introduced by this experiment. Build records identify actual frozen
executables; test results are overlapping checks rather than additive counts.
