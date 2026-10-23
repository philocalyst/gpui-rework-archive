# Combined sibling and indirect-validation source

Exact source `89aeabd53942c3a4643bcb6fd978e6a24703f6d2` combines the flat
sibling reconciliation buffer and lazy portable Core indirect validation with
the previously integrated property, text, presentation, inspector and accessibility
paths. Every sibling source/test blob equals producer `eb2a286f95`; every adopted
Core/provenance blob equals producer `30ea379b24`.

All 656 GPUI/GPU tests and doctests pass across 61 result groups, with 30 ignored.
Features are desktop, X11, Wayland, parallel Canvas, Cephal verify-cache, optional
offline shader artifacts and Vulkan render tests. SPIR-V validation uses the real
validator path recorded in metadata. Vulkan tests require an adapter and use
llvmpipe here. Strict all-target GPUI/GPU Clippy and formatting pass. All 2,033
shipping/configuration/port input hashes remain unchanged; the separately frozen
GPUI unit executable also retains its exact hash.

This is combined functional qualification. The producer [sibling controls](../sibling-reconciliation/README.md)
and [lazy Core controls](../lazy-indirect/README.md) retain their own allocation,
code and timing scopes. This run measures no native Window/Registry behavior,
startup, RSS, hardware GPU performance, native HDR or foreign-OS runtime. Earlier
native and foreign-compile results stay pinned to their original sources. The
Hummingbird queue, pointer successor, smaller root scratch and route columns are
not part of this source.

The first attempt reached a 1,200-second compile/link deadline before tests ran.
Its unchanged-source proof, compiler log and traceback are retained under
compile-timeout. The successful retry uses the same source/configuration/features
and existing completed build artifacts, without changing test selection. An
initial retry launch ran before its generator finished and could not open the
runner; that stderr is retained too. It executed no code or tests.

Raw logs/JSON are deterministically compressed. runner.py records exact commands;
metadata includes Rust/Cargo versions, configuration hash, enabled features and
the frozen artifact hash. SHA256.json covers every archive file except itself.
