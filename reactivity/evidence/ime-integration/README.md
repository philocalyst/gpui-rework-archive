# Scoped composition and immutable display text

Adopted source `373c9c6ba2665bcc452a92af835a4089b7b7e135` has the identical Git
tree as qualified Root review `63059517488141c35811f0bc197b4cd36c9ae6e1`.
It composes the IME implementation with the adopted Reader, Remote and GPU
oracle. This is a partial native IME implementation. Requested turnover can
quarantine a backend until Disabled or window close when it never acknowledges
cancellation, including ordinary Latin-source changes. Physical AppKit candidate
engines, VoiceOver and Windows runtime behavior remain unqualified.

An ordinary `ImeSession` binds to the focused field and exact source epoch.
Preedit prepares immutable display text without changing the canonical Source.
Commit writes through the ordinary text codec once; cancellation restores the
original replacement selection. A revoked stream cannot acquire a replacement
field. Queries, serialization, selection geometry, caret placement and AccessKit
read acknowledged display bytes and marks; semantic editing rechecks current
Source authority. Older eligible candidates and the previous presentation retain
their own text leases through acknowledgement and failure.

Changed previews copy three valid UTF-8 fragments directly into their final
ArcStr lease. A checked-length constructor uses safe exact slice initialization
inside one documented unsafe ArcStr call. The mutable scratch String and one
full-display copy are removed. The exact production constructor passed Miri and
matches the separately qualified b156 source byte for byte. This still performs
one display allocation and copy. It is not zero-copy editing. Preview shrinks
120 to 96 bytes; first preedit saves one allocation and N+24 requested bytes.
Cursor geometry uses one ICU iterator with downstream ties and complete seam
context; no retained ASCII certificate or boundary cache is added.

Root executed 71 fresh Linux test ELFs: **673 passed, 0 failed, 10 ignored**.
All 28 documentation tests, strict GPUI/Canvas/GPU all-feature/all-target checks
and Hummingbird's independent locked/offline all-target check passed. Linux
build guards cover 2,073 files, or 2,794 with the standalone port. The adopted
tree is byte-identical to the qualified review, rather than an unchecked rebase.

The actual native Mac suite executed 71 freshly frozen Mach-Os: **744 passed,
0 failed, 12 ignored**, plus 28 documentation tests. Strict native all-target
GPUI/Canvas/GPU Clippy passed after supplying exact locked cache artifacts.
Root independently reconstructed counts from raw output, matched all 2,075 Mac
inputs against its local closure, and verified all 485 archived metadata files.
The initial clean-helper failure and both offline-cache failures remain failed
in their receipts. The original batch's aggregate failure flag is preserved;
the corrected required gates passed. All three historical Reader/Remote Darwin
allocation failures pass in this composition without changing their assertions.

The original direct-lease slice separately includes genuine X11 pixels and
AT-SPI CJK/emoji display authority checks, the exact 79,333-case geometry
certificate, constructor Miri and two falsified optimization mutants. Its
matched ordinary API CPU experiment measured 2.810 to 2.224 ms per cursor update
at 32 KiB on mothership. That is the original slice's recording workload, not
Mac timing, display latency or a new composed performance measurement. The
archived original report retains its historical baseline failures and limits.

Seven shipping libraries plus build scripts contain **35,851** non-test,
non-comment code lines: **+952** from 34,899. The two-line difference from the
original IME delta comes from merging identical adjacent native conditions.
No dependency, lockfile or vendored source changes are introduced. This source
growth is charged explicitly; it is not a final size or feature-equivalence claim.

`result.json` records commands, source identity, executable catalogs, costs and
limits. `logs.tar.gz` contains Root receipts, per-file source guards, Linux
execution logs, Mac deduplicated raw metadata and the original slice report.
The 71 actual Linux ELFs remain at their recorded frozen local paths; the 71
actual Mac Mach-Os remain outside the shared Cargo target at their recorded Mac
paths. The 357,556,662-byte original optimization capsule and 11,420,436-byte
Mac handoff remain external with exact SHA256 identities. No Cargo target
cache is substituted for the executed artifacts.
