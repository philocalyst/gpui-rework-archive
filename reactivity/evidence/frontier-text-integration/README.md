# Retained text and preorder preparation composition

Qualified library source is `22dae0afcc65071909ddbfcce0d2d8bc00dcbfa1`.
`c6bef498a41a96ab23938f9025aa0ef0a63431b5` changes only Hummingbird's standalone
lockfile and passes its locked offline port suite. This composition builds on
Main `e93dcea272d5f124381b0c06c313ab726c7ae708`, including its analytic gradients,
nested transformed clipping, native accessibility geometry and exact clip damage.

Preparation retains inherited coordinate/clip state only along the active
ancestor branch. Leaves need no entry. Four initialized entries are inline;
deeper branches reserve the admitted maximum depth once and initialize visited
entries only. The clip frontier lives in a separate cold wrapper, keeping its
320-byte header out of the common presentation frame. Exact emission bits and
per-64-node rank replace the dense logical-to-presented mapping; final identity
checks and acknowledgement authority remain. No unsafe code or dependency is
added by these traversal changes.

Description follows the same preorder parent links to recover depth and the
preceding sibling ordinal, removing two more scratch vectors entirely. Bounded
child counts use u32. Each completed edge is unwound once; there is no new stack,
persistent field or node-indexed depth/ordinal history.

Text retains one packed glyph owner per multi-glyph scene run and a 14-byte raster
witness per admitted draw. Metadata-only source/bounds scans avoid reconstructing
glyph rectangles. The four-byte scale encoding multiplies only by exact normal
power-of-two reciprocals; arbitrary scales retain division. EcoVec 0.3.1 removes
the former outer owner allocation and first-party raw Vec ownership. Its heap
header, per-push Acquire check and per-run reference increment remain charged.
See the separate [text composition capsule](../text-composition/README.md).

## Actual allocation and code costs

The frontier/rank producer's 10,000-logical-node fixtures remove 560,000 requested
bytes per prepare for plain/wide trees, 1,040,000 for logical clipping, and 927,488
for lists/scroll. Their 120 semantic, hit, transform and RGBA artifacts match the
dense baseline exactly. Depth-32 and depth-129 cases each save 280 requested bytes.
The final common frame CFA is 4,080 bytes versus 3,808; the unconditional 4-KiB
probe store is removed, but stack reservation still grows 272 bytes. The clipped
wrapper reserves 336 bytes. Whole producer probe .text grows 2,224 bytes. These
are not speed or RSS results. [Producer report](frontier-producer.json).

The independently composed description change removes two allocations and
`16*N + 8` requested bytes per description: 24 bytes at one logical node and
160,008 at 10,000. Two list re-descriptions save four allocations and 320,016
requested bytes. Measured whole-region retained and peak bytes are unchanged;
later allocations still dominate that peak. All 120 public artifacts match in
distinct, rebuilt baseline/candidate ELFs. [Measured ledger](description-allocations.json).

Shipping code is **34,680 non-test, non-comment lines** across seven first-party
libraries and their library build scripts, versus Main's 34,466: +214. Text adds
64, frontier/rank/stack ownership 134, and the description cursor 16. EcoVec adds
2,315 separately counted dependency lines. Tests, comments, examples, evidence,
vendors and generated shaders are excluded. This is not a total-code reduction.
[Syn/Tokei inventory](core-lines.json.gz).

Canvas is 464 bytes versus 488; DisplayList 264 versus 288; matched native Runtime
1,816 versus 1,840. TextLayout is 56 versus 48, and TextSite 80 versus 72, so each
retained text slot grows eight bytes. Multi-glyph common records are 64 bytes.
The producer charges tiny/empty/all-clipped regressions alongside substantial
repeated/long-label scene savings. Warm scene admission stays allocation-free.
The thinner unique-to-shared owner remains a separate experiment.

## Qualification and limits

- Source `73fe8cf`: 1,026 passed, 40 ignored, 106 frozen executables with hashes
  before/after execution. Canvas/GPU source is unchanged in final `22dae`.
- Final `22dae`: 698 GPUI tests passed in 68 frozen executables, 36 ignored;
  strict all-target native/GPU Clippy passed; 33 doctests and 184 scalar tests
  passed. Counts overlap and are not summed into a unique-test claim.
- Actual private-X11 GPU paint, pointer/action/resize/inspector and AT-SPI rounded
  clipping/acknowledgement tests pass, including DPR 1.25 and negative screen
  origin. The two real native cases are additional to default ignored tests.
- Hummingbird `c6bef`: 70 passed, two ignored, 18 harnesses; all 2,777 tracked
  build/port inputs unchanged. This rerun uses default headless features, not a
  new CPAL/device or full-player qualification.
- All 48 density cohorts replay from the actual frozen Canvas ELF. The producer
  accounts for all 1,056 non-timing fields and four GPU packet/readback records.
- Generated WGSL remains 18,995 bytes, SHA256
  `ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1`.
  All eight SPIR-V modules validate; WGSL and every module are present byte-exact
  in the executed GPU/native ELFs, including the final native executable.

The maximum-depth sibling regression uses ordinary recording windows, updates
and queries. A one-ancestor unwind mutant fails with DepthLimit; a wrong-sibling
ordinal mutant fails stable target equality. Both really execute one test and
fail semantically. The latter ELF is preserved with a post-execution hash; the
former executable was replaced by the second compile, so its evidence is the
guarded source and actual failure output, not a separately frozen ELF.

Source/toolchain/input guards, commands, compiler JSON, executable identities,
logs, failures and shader artifacts are in [the compact archive](qualification-logs.tar.gz).
[Its receipt](archive-receipt.json) verifies every archived payload hash.
Executable payloads remain at the recorded external paths; they are not copied
into the repository. Exact source deltas are in [source-deltas.json](source-deltas.json).

The first offline build lacked an explicit spirv-val path and stopped before
tests; the corrected build records the validator setup. Initial Xvfb readiness
timed out before a native test; a 55-second launch deadline passes the identical
tests. The description probe's first log parser matched the wrong marker; its
baseline execution passed and was reused with hash revalidation. More seriously,
cross-worktree target reuse marked changed Rust source fresh and returned the
baseline ELF. That comparison is invalidated in its own receipt. Cleaning GPUI
produced a distinct ELF and the expected exact allocation delta. A separate
17→19→17 control with deliberately old mtimes verifies pinned Cargo content
freshness; build-script rerun-if-changed still needs separate care.

Software Vulkan and private X11 establish no hardware GPU, display latency,
startup or RSS improvement. Perceptual-gradient precision tiers and GPU clip
membership reuse are not adopted here. Rich spans/color fonts, complete IME,
arbitrary path/effect support, shared native devices and the remaining full
Hummingbird/Zed ports remain work in progress.
