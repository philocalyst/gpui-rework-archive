# Exact stage-interface proof refinement

Final source: `db73d4f1cca7f173f98ab835176de2908c464156`. This follows the
completed `bea848dbe4` qualification frozen in evidence commit `0a85e6aa8c`.
It changes only host proof code; runtime code, vendor API, profile revision,
dependencies and unsafe sites remain unchanged.

The original generation-only stage check accepted any type at fragment location
zero. Shared `reflect` now checks exact entry arguments/results on the source
and every independently reparsed artifact: vertex input Uint32 VertexIndex,
position Float32x4, fragment position Float32x4 and location-zero Float32x4
result. No dual-source or per-primitive output is admitted.

The SPIR-V writer's FORCE_POINT_SIZE produces an exact two-member vertex result
struct (Position Float32x4 at offset 0, PointSize Float32 at offset 16, span 32),
whereas the source returns Position directly. Both representations are checked;
no arbitrary aggregate is flattened into an accepted interface. Naga normalizes
WGSL's default fragment-output interpolation to Perspective/Center and drops
these semantically irrelevant output qualifiers on SPIR-V reparse. The initial
overstrict equality failure is preserved against source `c3b5b68953`, followed
by the final correction in `db73d4f1cc`.

The new test constructs **valid Naga modules** with vec4u and vec2f fragment
outputs, validates each successfully, then requires the exact interface proof
to reject them. Four host-proof tests now pass, alongside the original changed
binding, writable storage and altered descriptor-set cases. Strict all-target
GPU Clippy and all 46 Vulkan cases/10 GPU units/4 presentation tests pass again.
Commands use an explicit `--jobs 2` as well as CARGO_BUILD_JOBS=2.

`identities.json` verifies every byte of all eight SPIR-V files, generated Rust,
WGSL and manifest against the prior frozen artifacts. The linked first fixture
also remains identical: 7,038,680 bytes, SHA256
`d1e9016b51f8657201dd972868befc658c005c919e5b998d0c3f7d07bb6a7032`.
Thus the allocation/driver lifetime controls remain the exact same executable;
they are not relabelled as freshly measured after this proof-only change.
Apple/MSVC and X11 gates retain their earlier source pins, rather than claiming
new platform executions. No additional hardware/performance qualification exists.

The stronger proof adds **33 non-test/comment-free host code lines**. GPU/src
plus build.rs rises 2,972→3,005; compared with the original 2,421 this is +584,
plus the unchanged 65 vendor lines: **649 authored shipping-code lines total**.
The host helper itself is 487 counted lines. Tests/evidence and the unchanged
4,369-line generated Rust word/layout data remain separate charges.

No dependency or host unit graph changes. The build executable grows
12,010,056→12,012,584 bytes (+2,528). Only that file changes in the full host
ancestor ledger: 301,794,619→301,797,147 logical bytes; default remains 252,618,670.
The optional net host-cache increase is therefore 49,178,477 bytes. The preserved
old build executable remains a separate audit control, not a current consumer
requirement. No new runtime allocation or retained-field cost is introduced.

`capture.py` reuses the source/host ledger functions with separate destination
and source refs. It consumes the new compiler-artifact JSONL, checks actual
current file hashes and compares every artifact and executable against the old
immutable receipts. It does not overwrite the original bea measurements/costs.
Use the original frozen source/cache when reproducing the earlier snapshot;
mutable Cargo build filenames can be overwritten by a later source build.
