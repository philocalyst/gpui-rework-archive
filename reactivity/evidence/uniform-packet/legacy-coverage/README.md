# Legacy packet constant coverage: qualified implementation, unadopted

Source is 299c6aca30c1245c15c2da6a5ccabb41dd435d17 in the isolated tree
/tmp/gpui-legacy-coverage-sol, based exactly on legacy control
277473219bcf4add23d36126e70be1d72ceec1f6. Production GPU shipping remains
7a5e1619a27010ec63f6c27506a6d1fcd113f67c. No timing campaign was run or
performance/RSS win established. Root review and preregistration are required
before a new timed campaign or integration.

The legacy five-word common / six-word inline packet, Globals, paint/color bank,
correction indices, full ordinary warm uploads, preparation admission/revocation
and fused reverse resource patch are retained. There are no uniform planes,
17-bit codec, Changes/envelopes, resident word comparisons or new retained
fields. Only renderer.rs, shader.rs and the new coverage.rs change production.
The exact borrowed 6158 interval kernel is reused, SHA-256
7e80c771b75e61e6c1d31bd3f63ff67f49c4fa1f9ae60f8e47479bfe92c0487f.
The shader keeps the shared four-sample compositor and adds minimal legacy
paint loading for certified constant/opaque-prefix ranges. Ordered source-over,
clear recurrence, negative-zero normalization, sampled-tile non-restoration and
later opaque resets remain explicit. See port-audit.md and source-audit.json.

Functional gates passed:

- Default and no-default/SIMD-fallback release: 14 library, 4 presentation,
  50 render and 1 doc test each.
- Offline shader release: 15 library, 4 presentation, 51 render, 1 doc. Real
  SPIR-V validator /tmp/gpui-qualified-spirv-root/bin/spirv-val was supplied.
- Strict all-target default and offline shader clippy, -D warnings.
- Apple ARM64 and Windows MSVC all-feature library checks, with build-std.
  These are compilation checks, not runtime/linker qualification on hardware.
- Exact original public fixture SHA
  8773146b44150adb0150323d51f241c946fb5cda26328f004562dcd9dee39cc0:
  52/52 frozen a81 readbacks, 35,651,584 bytes, and adapter identity exact.
  Scalar/SIMD, independent integer sample oracle, exhaustive geometry and
  rounded-predicate implication/adversarial checks are in the library tests.
- Fresh legacy277 and candidate named test captures: all 578 historical
  readbacks / 13,912,048 bytes exact by test name, within-test ordinal,
  dimensions and format. No global index matching across changed suites.
  Candidate captures contain 652 readbacks: the matched 578 plus 74 from
  the three new coverage tests (56 constant, 2 opaque-prefix, 16 whole-bounds).
  New tests assert their paired sampled/optimized pixels internally. The 578
  matched controls are newly captured from exact277, with provenance and
  source guards; they are not relabelled prior unlabelled global-index files.
- A false whole certificate failed actual SDR stage1 pixels, exit101; exact
  source restoration recovered. A legacy paint loader ignoring the inline
  bank flag failed actual banked frame0 pixels, exit101; restoration recovered.
  The borrowed highest correction probe passed with 65,536 draws and 65,537
  correction records. These temporary observers/faults are nonshipping and
  their exact sources, failed logs and actual binary hashes are retained.

Package formatting passes. An initial package check found one trailing blank
line, corrected before sealing. Workspace-wide formatting still reports the
unchanged vendored/unrelated formatting already present in this old base;
its full 1.8MB output and exit1 are retained. No unrelated formatting changed.

Actual linked costs use the same physical source path, lock, features, root
v0/tokio flags, opt3 and emit-stack-sizes exactly once. All three library and
groups artifacts are fresh:false; actual binaries remain externally preserved.
All GPU symbol aliases and whole-caller/helper disassembly are retained.

| Cost | Shipping7a5e | Legacy277 | Candidate |
|---|---:|---:|---:|
| Core non-test/comment LOC | 30,692 | 30,625 | 30,834 |
| Linked .text | 6,403,991 | 6,403,783 | 6,409,367 |
| Linked .rodata | 7,012,024 | 7,010,232 | 7,011,384 |
| Linked .data.rel.ro | 336,384 | 336,384 | 336,480 |
| Render body / static frame | 9,493 / 1,416 | 9,296 / 1,432 | 9,520 / 1,448 |
| bin_draw body / static frame | 4,184 / 824 | 4,184 / 824 | 4,531 / 840 |

New whole certificate is 1,462 code bytes / 248 static frame; axis is
1,662 / 344. Interval add/scale/checked/subtract are respectively
366/453/187/382 code bytes, each frame0. These compiler frames are not
additive peak stack or measured RSS. Core delta is +209 against277 and +142
against shipping, using the same counter/helper/tokei. All unfavorable growth
is charged. The complete unique-name and unpaired/ambiguous alias ledger is
in codegen/summary.json; cost-ledger.json summarizes it.

There are zero new proof heap allocations or retained fields. In every public
capture the candidate has exactly shipping's observed record/upload bytes,
GPU capacities, CPU index capacities, logical references, opaque cutoffs,
validation counts and visit counts. Capacity sums exclude allocator overhead
and are not RSS. Compared with the uniform ABI the common record costs +16B
per shared group. For 1000 groups in runs32k this is +16,000 record/capacity
bytes; observed GPU power-of-two capacities happen to be equal in that case.
Full warm uploads are charged: runs32k 1,108,272 bytes and singleton32k
3,076,272, versus uniform a81's 4,176 for both. See payload-ledger.json for all
52 cold/warm/moving/SDR/HDR cells, including image/mask/resource diagnostics.
These bytes/work counts are not elapsed-time measurements.

Structurally, the area-scaled corner proof can be avoided after one initial
eligible tile proof plus one cached whole-bounds certificate per draw. All
required forward/reverse tile visits and CSR copies remain. The 32k warm loop
uses the original streaming writers; it performs no seven-word resident
comparison and does not skip public validation. The unresolved adoption
question is whether saved proof/geometry/decode work outweighs setup/branch,
extra linked code, legacy common bytes and full upload costs in strict matched
host+total gates. This implementation supplies no answer from calibration.

Old campaign and6158 archives were rehashed unchanged. All old sources, raw
failed-campaign frames/readbacks and binaries remain untouched. Current
archive excludes ELF payloads and records their external hashes/paths. It
includes full GPU source/config snapshots for shipping,277,candidate, fixture,
all raw new captures, source guards, fingerprints, build/test/fault logs,
assembly, costs and observer sources. The archive verification reopens every
member and checks exact size/hash. Its manifest and archive hash are external.

The sealed commit is based on277 rather than current main. For review against
shipping use source-snapshots/shipping-to-candidate.patch, which includes the
already-qualified277 four-sample/fused-walk changes plus this port, restricted
to the GPU crate. Do not cherry-pick unrelated historical commits.
