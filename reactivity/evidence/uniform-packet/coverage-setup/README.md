# Whole visited-rectangle setup: qualified prototype, unadopted

Sealed source 6158d25e483dea439832399e768ff4fbe1202640 is on the isolated
gpu-whole-coverage-setup-sol branch at /tmp/gpui-coverage-setup-sol, based on
exact a81bc7536b002b1f81e1b36137c1c4de543e2204. Main, Root's a81 worktree,
and the frozen failed campaign are untouched. No new timing campaign ran.

The new stack-local interval filter certifies the exact union of tiles visited
by a solid draw. Its directed operations enclose every rounded node of the old
packed and canonical predicate, including its margin/guard tree. Success implies
every old per-tile predicate succeeds; ambiguity uses the unchanged fallback.
Setup is deferred to a second actual eligible tile request and cached once per
draw, including failure. There is no extra scan, retained field, heap owner,
dependency, resource map, record ABI, shader branch, or SIMD-specific policy.
This is the same kernel with default SIMD and no-SIMD Canvas configurations.

The old full_tile body and shader source are byte-identical (see
unchanged-authority.json). Constant/opaque state transitions, sign-safe opacity,
clear-based source-over, HDR zero normalization, logical reference caps,
forward/reverse visits, resource admission, and failed-prepare revocation remain.
The proof assumes strict Rust IEEE arithmetic, not externally changed DAZ/FTZ
hardware modes. A rejected bit-guard experiment was folded back to FP compares
by LLVM and cost more code, so its claimed strengthening was not retained.

Final release qualification: default and no-SIMD fallback each pass 16 library,
4 presentation, 53 readback and 1 compile-fail documentation test. Offline-shader
passes 17, 4, 54 and 1, including the independent SPIR-V validator/ABI gate.
Strict all-target Clippy passes in default and offline modes. Actual Apple
ARM64 and Windows MSVC all-feature library compile checks pass; foreign runtime
behavior was not executed. The five coverage unit cases include an exhaustive
dyadic geometry grid checked at all sixteen sample positions by an independent
integer oracle, 8,192 binary-boundary cases, boundary/clip/flip/shear/correction
comparisons against every old tile predicate, and separate/fused arithmetic
enclosures including min/max subnormals and overflow rejection.

One actual negative control falsely certified every solid draw. It reached and
failed the SDR partial-edge pixel assertion (exit 101), rather than a compile
error or an empty test selection. Exact source restoration made the same test
pass through SDR/HDR stages. The new public Canvas/Renderer functional process
then matched all 52 raw readbacks (35,651,584 bytes), every Stats/ImageStats row,
and adapter identity against the frozen a81 capture. Its two-frame calibration
clocks are retained but support no performance claim. Runtime is Mesa 26.1.4
llvmpipe software Vulkan; there is no hardware GPU, startup, RSS or scanout claim.

Measured source/static costs against a81 remain unfavorable and fully charged:

| Item | a81 | sealed source | Delta |
|---|---:|---:|---:|
| Non-test noncomment core lines | 30,796 | 30,948 | +152 |
| Linked groups .text | baseline in ledger | candidate in ledger | +4,176 bytes |
| Linked groups .rodata | baseline in ledger | candidate in ledger | 0 |
| Linked groups .data.rel.ro | baseline in ledger | candidate in ledger | +72 bytes |
| Render body / static frame | 9,261 / 1,448 | 9,261 / 1,448 | 0 / 0 |
| bin_draw body / static frame | 4,499 / 808 | 4,531 / 840 | +32 / +32 |
| New whole helper body / frame | absent | 1,462 / 248 | fully charged |
| New shared axis body / frame | absent | 1,662 / 344 | fully charged |

The new Interval leaf bodies and all aliases are in the full ledgers. Static
frames are not dynamic peaks or additive call chains. Both actual linked
libraries/examples are fresh:false, opt3, default SIMD+vulkan-tests, same physical
source path, root v0/tokio flags, emit-stack-sizes appended exactly once. The
unchanged a81 baseline capture was reused for the later guarded refinements;
that provenance is explicit. No giant baseline rebuild was relabeled as new.

Intermediate costs are retained: 0359 passed correctness but copied PreparedDraw
at setup, grew linked text +4,224 and bin_draw's frame +208. Borrowing the private
input removed that memcpy and 176 frame bytes. Rejected e7's bit guard grew
text +5,248 and the axis helper to 2,744 / 376 without establishing DAZ safety.
Sealed production is byte-identical to borrowed 779; it adds two test inputs.
The first test failure was an invalid expectation that old precision admission
accepts a 16,384x1,024 rectangle; the test now explicitly retains that rejection
and uses an admitted large rectangle. Buffered assembly headings were fixed by
flushing before objdump; original raw output and corrected full bodies remain.

cost-ledger.json, rounded-tree-proof.md, source snapshots, exact core inventories,
all raw logs/readbacks, negative/recovery logs, compiler fingerprints/commands,
all symbol/alias ledgers and whole caller/helper assembly are archived. ELF
binaries are excluded and preserved externally with exact size/hash records.
The archive manifest hashes every payload, and validation reopens every member.

legacy-abi-feasibility.md separates this coverage work from uniform-word residency.
Commit 277 already has the shared sample-row compositor and fused resource patch
walk on the shipping legacy compact/inline ABI. A separate port can keep those
deletions while discarding plane/codec/Changes complexity, at the explicit cost
of 16 extra bytes per shared common group and full warm packet uploads. No port,
record comparison optimization, Canvas witness or harness/API substitution was
added. No count or speed forecast is made for that unimplemented formulation.

The candidate remains unadopted. The prior 11-pair campaign remains failed and
unchanged; these correctness/static gates do not override its host regressions.
Any next timing run requires Root review and a separate preregistration.
