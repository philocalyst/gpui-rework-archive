# Intrinsic caption width: isolated source and exact qualification

Shipping draft **dbe8a82755db81fc6853ecf1642c6c5eb44d760d**, base
**3ca3a86e07163ffeb3504ad43f683f57c91b46f0**; final test source
**704e56266eef2a3bb52defd3888349f20de40901**. Worktree is
/tmp/gpui-intrinsic-width-sol. This patch remains **unintegrated**. Main and
the Todo comparison retain their separately qualified explicit-width control.
No native, cross, allocation, throughput or timing claim is made here.

## Numerical cause and correction

At font16, Add's natural content width is29.904001235961914
(0x41ef3b65), height21.792, one line. Actual Cephal flex measurement first
requests MaxContent. Adding20 padding rounds its auto border width to
49.90399932861328 (0x42479db2). The next finite MeasureInput contains
29.90399932861328 (0x41ef3b64): one content ULP short. Parley's strict fit
comparison correctly wraps the word, resulting in63.584 total height.
Grouped and sequential p10 inverses both lose that ULP. Asymmetric insets
also reveal a separate measure/final subtraction-association difference.
The full traces record actual layout fields and measurement input bits;
clipped/outward public bounds are not substituted for the local width.

The vendor-owned fix constructs an auto measured outer width with ordinary
addition, advancing exactly one representable step only when subtracting its
canonical inset would return less than the measured content. For admitted
nonnegative operands and finite sum, undershooting the representable content
proves that the sum rounded below its exact value; the next representable
outer width encloses that sum. Its canonical inverse cannot round below the
representable measured content. No epsilon or global layout rounding is used.
Known/style width takes precedence lazily; existing min/max clamping still
applies afterward. At MAX, an undershooting sum advances to infinity because
no finite outer enclosure exists; an explicit finite maximum still wins.
Negative/nonfinite operands retain ordinary prior arithmetic.

One private inset constructor fixes the exact association of padding+border,
then right/bottom scroll gutter. Both leaf measurement and final content
width use that constructor and the same axis sum. Height rounding is not
changed. No header, cache, ownership mode, public API, dependency or unsafe
code is added. The two vendor files add15 noncomment code lines by qualified
Tokei15 (439→454),33 inserted/12 deleted physical lines. The six-library
Syn/Tokei count stays30,692; vendor authored delta is charged separately.

## Exact results and limits

The final source passes three private real-core tests: eight asymmetric
padding/border/gutter combinations, strict explicit/max/flex constraints,
and unrepresentable outer width with/without a finite maximum. The ignored
exact-bit diagnostic was run separately and passed. Three public tests pass:
the unmodified pinned main examples/support/todos.rs at360px,81 combinations
of Unicode/fractional fonts/padding/DPI, and strict next_down/exact/next_up
explicit widths against the Canvas shaper oracle. Add becomes49.904003 wide,
41.792 high, one line; its new outer bits are0x42479db3.

Existing functional replay passes27 GPUI cases (new3, text_geometry4,
text_selection14, text_selection_compound6),24 Canvas Unicode/render cases,
and six core library unit cases with the layout feature. That last check is
not the full core layout integration suite. Strict all-target Clippy passes
for GPUI/core/Canvas with warnings denied. These are57 functional cases plus
the three private cases, not60 newly written tests. Broader native/cross/full
integration closure and final review remain pending; no old gate is retagged.

Each run records source/config/vendor/manifest/lock before/after guards and
actual compiler/Cargo artifacts/fingerprints. Initial changed artifacts are
fresh:false; unchanged same-source replay artifacts record their actual
freshness. Actual Linux flags are root v0/tokio_unstable, generic flag vars
unset, jobs1, target/tmp/gpui-intrinsic-width-target. Concurrent unrelated
builds ran, so harness elapsed values carry no performance meaning.

## Preserved failures and provenance

The initial public comparison and fractional tests fail with two-line Add;
the subsequent direct unmodified main-example regression also fails before
the fix. The reconstructed comparison source was copied after the benchmark
added its common.w(56) workaround, then only that builder call was removed;
its provenance is explicit. Final shipping tests include the unmodified main
example directly, and remove the redundant reconstructed test/import.

Initial private diagnostic accidentally used Cephal's default Block display,
stretching the leaf. Its trace is retained but not attributed to the flex
failure. The first runner looked up an integration fingerprint using the
executable prefix instead of package prefix; its continuation revalidated
the same source and fresh:false artifact. A later tight fixture used
Dimension rather than LengthPercentageAuto for max_size and failed to compile;
that log is retained. Corrections are test/runner-only; the production dbe
source did not change during successful qualification.

## Replay material

shipping.patch is the complete two-file vendor source diff; test-support.patch
is the final test/module diff. line-bill contains exact old/new vendor inputs
and qualified counter output. Each run directory preserves its original
runner, compressed logs, artifact metadata and source guards. files.json gives
the uncompressed original path/size/SHA-256. Frozen executable bytes remain
at the /tmp paths and hashes in metadata; they are not committed as binaries.

The original runs are /tmp/gpui-intrinsic-width-{diagnostic,flex-diagnostic,
draft-dbe,tight,tight-fixed,qualification}. The last two hold the final private
and existing-functional/strict logs respectively. All owned sessions exited
naturally before the Todo quiet hold; no build/test/counter remains active.
