# Restart the grapheme scan without retaining another certificate

Adopted source `ce75a3511be000c18a9b356a4be103585cdb5a21` copies the two
qualified source files from `fb8b775315642eef8c9415b5e35185248f19c27c`
byte for byte. All 2,075 guarded inputs match except the GPUI README, which
already contained Main's composition documentation. Main then rebuilt GPUI
and executed its own fresh library and public IME test ELFs: **209 passed,
0 failed, 5 ignored**. Strict Clippy passes for the library, public IME tests
and ordinary `ime_cursor_cost` example.

Cursor-only preedit previously sent the unchanged prefix through ICU again.
An ASCII prefix permits restarting at its final complete grapheme: ASCII
contains no earlier regional-indicator, Indic, Hangul or emoji context. Keep
CRLF together and the entire right suffix. Combining marks and joins across
both marked-text seams still use the ordinary ICU segmenter. This follows
the context requirements of [Unicode UAX #29, revision 47](https://www.unicode.org/reports/tr29/tr29-47.html#Grapheme_Cluster_Boundary_Rules).
Non-ASCII prefixes keep the full scan. The ASCII certificate itself still
scans prefix bytes; this removes their grapheme work, not every prefix read.

The cursor endpoints and marked range are translated once into suffix
coordinates. One shared geometry loop then translates its four final results
back. There is no second segmentation implementation, retained boundary map,
source flag, cache, new allocation, dependency or unsafe code. The actual
x86_64 release ELF contains vectorized standard slice ASCII checks. Other
architectures use the standard portable implementation; this slice has no
fresh macOS or Windows execution claim.

The existing full-string oracle covers 79,333 directed raw-byte cursor pairs.
A second independent oracle covers 43,008 valid UTF-8 directed pairs across
all 128 possible ASCII tail bytes, empty/combining/Indic/emoji/flag preedits,
and suffixes that join across the right seam. Hidden-caret checks are extra.
Both compare selections and marked decoration with complete-string ICU
boundaries, including exact downstream ties. Existing public cases retain
source/display/acknowledgement authority.

Bounded mutants of the final relative-coordinate formulation validate the
certificate. Removing the left grapheme fails a semantic geometry assertion
at `5b0cbbd6cb80acd41c78775d49175da19210d044`; truncating the suffix fails
the same oracle at `106d04892cb3ece325f4b70d0a6dd3dab53c5618`. Both actual
test executables exit 101 with one assertion failure. The initial left mutant
instead panicked at an empty-suffix bound; it and the failed helper receipt
remain archived, but do not count as a semantic certificate.

## Complete ordinary API calls on mothership

The unchanged public example constructs an ordinary writable text input,
acknowledges its display, starts a tiny combining-mark preedit near the end,
and repeatedly changes only its cursor. Source value/epoch, displayed bytes,
mark, selection focus and exactly one query target are checked after
timing. These are recording calls; rasterization and scanout are absent.

Six processes run in control/candidate/candidate/control/control/candidate
order, exclusively holding the host lock on CPU 0. Each process records nine
samples per case. The table compares the median of three process medians.
Short inputs use 2,000 calls per sample; others use 100. Both actual ELFs use
the same nightly toolchain, default SIMD profile, explicit glibc 2.44 loader
and library paths. Source archives, per-file hashes and actual executable
hashes are checked. All 24 model/display checks pass. Every owned child is
reaped, the exclusive lock is released, and 9,200,250,880 disk bytes remain.

| Case | Control ns/call | Candidate ns/call | Change |
| --- | ---: | ---: | ---: |
| 24-byte ASCII | 4,323 | 4,187 | −3.1% |
| 4 KiB ASCII | 345,962 | 311,059 | −10.1% |
| 32,767-byte ASCII | 2,533,439 | 2,218,598 | −12.4% |
| 32,767-byte Unicode prefix | 2,496,613 | 2,479,354 | −0.7% |

These are descriptive measurements from one CPU, not universal bounds or
click-to-pixel latency. Earlier formulations and raw samples remain archived.
In particular, the preceding byte-coordinate candidate measured a **0.335%
Unicode slowdown**. The final formulation avoids translating each yielded
boundary; its paired result is reported independently rather than replacing
that losing observation. No allocator or native GPU improvement is claimed.

## Costs and artifact identity

Seven library sources plus build scripts now contain **35,863** non-test,
non-comment lines, **+12** from 35,851; 18 are library build-script lines.
Examples, tests and this dossier are excluded. No lockfile or vendor changes.
The Linux example's `.text` grows 3,055,287 → 3,055,751 bytes (**+464**).
The kernel grows 543 → 1,063 machine-code bytes; the caller remains 5,213.
The kernel's own frame grows 232 → 248 bytes, including saved registers;
child frames and return addresses are separate. The whole ELF grows
9,822,440 → 9,833,312 bytes. No retained window or text header grows.

Control source is `6fa774ce9816ea83cf8acd4892e24a1ae84798ed`, actual ELF
SHA256 `fe0dfc485fb69c5a08d4a2de509f36299d10f81cfe2afdf371ab6e02726e2cee`.
Candidate ELF SHA256 is
`eca97d6e8e3754f08d6cb89eb79dd235156dfd6141c43a8fddda5f5700915f31`.
Their executable/source stage is 37,836,800 bytes, SHA256
`dc8fe841016a42fafc3df1011575970974f8f8d1312b13c11f6bfad1abddda25`.
It remains at `/tmp/gpui-ime-ascii-relative-mothership-stage-root.tar` and
the corresponding `ime-ascii-relative-root-fb8b775` evidence directory on
mothership. Actual test ELFs remain outside Cargo targets at the paths in
`result.json`. `logs.tar.gz` contains 408 rehashed metadata members, source
guards, commands, raw samples, disassembly, test output and failed attempts.

The predecessor's full Linux/Mac composition and native accessibility checks
remain separately pinned in [IME integration](../ime-integration/README.md).
This private optimization does not remove its native cancellation quarantine,
prove physical candidate engines, or qualify VoiceOver/Windows runtime behavior.
