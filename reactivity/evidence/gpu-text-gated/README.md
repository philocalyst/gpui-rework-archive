# Size-gated outlined tile refinement — rejected mechanism qualification

The main full-preparation comparison passes every fixed primary/control median:
1000-label two/four fields .602142/.681601; stream0/25/1000 .218615/.212364/.203996
(about4.6–4.9x faster). All short one-field and full-rebuild control medians are
within1.05. This does not complete the trial: the separately preregistered
ungated-baseline comparison fails25-label single exact1.081491 (limit1.0),
25-label stream1.069717 and1000-label stream1.063233 (limit1.05).
Keep the overall failed verdict. Do not change4096, drop runs, attribute these
failures to noise without evidence, or claim general adoption/ZGX superiority.

The gate admits dirty-tile refinement only for Some nonempty bounding damage
with area>=4096 pixels (sixteen16x16 tiles). Below that, use the existing
packet-only submit. The comparison is a separate outlined read-only pass after
CSR reconstruction; common-word changes are computed there, using a four-entry
stack array under the unchanged1..4-edits admission bound. For each tile, compare
old/new ordered references and every referenced changed glyph/common word.
A changed common marks its entire run. Equal compact words alone do not establish
equal membership. Old and new references both matter; unchanged uniform-solid
tiles skip directly. Disjoint dirty row spans intersect caller-certified damage;
more than256 spans falls back to the original bounding damage. None remains full
repaint, empty damage copies only. All validation precedes queue writes.

The threshold is a work-amortization choice, not a correctness certificate.
The ordinary bounding-damage path remains valid whenever refinement is skipped.
The same shader, sample arithmetic, painter order, opaque cutoffs, atlas leases,
scene tokens, atomic late rejection and older-ACK authority remain. No new API,
dependency, header, unsafe or task executor. Complete CSR reconstruction still
runs; an additional pass runs for large damage. This is not O(changed) overall
and no hardware-cache behavior was measured.

Correctness:79 GPU tests/doctests and strict Clippy,975 default GPUI+Canvas,
1048 X11-composed tests/doctests and strict Clippy, six actual private-X11
scripts. Exact public tests include4095/4096 area selection, unchanged records,
one changed glyph, movement across old/new tiles and opaque overlaps, fractional
and near-edge geometry, SDR/HDR, empty/full/clipped damage, span-limit fallback,
and identical shader words with distinct conservative memberships. Every image
matches an independent full render. The fresh omitted-old-membership mutant
9032bc6e89 fails the moved-glyph image test. All source guards and test gates
passed on the first frozen candidatea3ac8c5b34; no production/test edits occurred
between build, native qualification, allocator build, timing and probes.

Measurement:21 primary cells,five alternating pairs,210 fresh processes,10
warmups and60 measured updates per process (12600 measured). Separate mechanism
trial:seven cells,three alternating pairs,42 processes (2520 updates). Same
960x720 fixture, shared ZGX735-character payload, DejaVu font, compiler/features,
affinity2–5 and llvmpipe4. Canonical scene/delta construction plus GPU preparation,
submission and queue completion are timed; shaping is outside. host_ns is wall
time through submit, not thread CPU time. Full source/immutable ELF guards,
initial/final exact fresh and cross-variant images, final scene receipts and
shader identities pass. No owned compilers/tests/probes/source edits during
both timing phases. Preserve all p50/p95/p99 samples and pair ranges below;
there is substantial variability. Cold object/adapter creation and whole-process
RSS include the independent image oracle; they are not cold OS-cache startup.

The mechanism medians are .960722 for0-label single,1.081491 for25-label single,
1.007742 for25-label two and .987756 for1000-label four. Stream medians are
1.004244/1.069717/1.063233. Thus the isolated comparison does not establish that
this refactor preserves the ungated speed, despite the main baseline gates
passing. Its new pass changes code layout and memory access order, but this
trial does not identify the cause of each timing difference.

42 separate allocation probes each take60 warm samples and verify exact fresh
GPU images. Caller-thread Rust allocations only; foreign driver/worker costs
are excluded. Small updates return to packet-only allocation counts/bytes:
0-label single85/34359 versus ungated87/34871;1000-label two97/80185 versus100/81593;
four118/84317 versus123/87645. Full baseline two/four were122/17225 and132/19329.
Stream remains115/209739, same as ungated, versus full131/50121. More transient
bytes remains a charged loss. All candidate sparse retained deltas are zero;
full paths in both variants retain queue-allocation cycles (e.g.[-912,304] B).
All nine full controls match warm allocator distributions apart from separately
reported text-map capacity. The original extra24-B RetainedRenderer header,
16-KiB1000-label map and16-B native TextResources field remain; this refactor
adds no retained fields or persistent buffers.

Actual compositing counters confirm the policy. Single/two/four canonical
regions416/1456/3536 pixels are now composited in full. Stream median66627 becomes
9808 pixels, as in the ungated trial. Every submission still copies691200 pixels.
These diagnostics are separate from performance and cannot explain all latency
variation. Threshold correctness is covered, but performance of arbitrary dense
long-text changes and all intermediate damage shapes is not established.

Code:37485 shipping lines (+24 over ungated); ELF14735568 B (+2376), SHA256
5fb76301dbb70f7caf1f04fcd134e2cf425310a9a70d71784f55fa984d9164e6.
Patch body8637 B versus8898, local stack reservation888 B unchanged. New
repair_regions1778 B/local reservation216 B; wrapper455/104 and
submit_regions801/1368 remain. Outlining is not a total-code or total-stack
reduction. Prologue reservations exclude pushed registers/callees/driver stacks.
Full symbols and targeted assembly are retained. Generated WGSL is unchanged,
SHA256 ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1,
verified embedded in the actual timed ELFs. Dependencies remain unchanged;
allocation-counter0.8.1 is diagnostic-only.

Base3dd29a0ebdea85ed7b4076ab51069865293e8737; protocol
cca90b4f89323413bd9bfe0608b80db45391d5aa; all candidate gates/measurements
and allocation sourcea3ac8c5b3475b347e264929f749b71bf81b4cf5f.
Full control64523d173a and ungated controlef71ae3001 use immutable earlier
executables with explicitly inherited build/test receipts and fresh timings.
The current evidence is independently reconstructed by
`python3 reactivity/evidence/gpu-text-gated/verify.py`.
Completed older test ELFs were losslessly archived with hashes/recovery paths;
measured example ELFs remain at their original paths. Compiler-cache cleanup
receipts preserve tracked sources and evidence. No timing overlapped cleanup.

The AMD9950X KVM guest has no physical render node; Vulkan is llvmpipe and X11
is private. No scanout or physical-GPU result follows. Equivalent native ports,
matched distribution profiles and two hardware classes remain mandatory. All
work is local and unadopted. Next work should address native workload parity,
including its currently coarse inbox publication, rather than retrospectively
retuning this fixed threshold to pass the same matrix.

## Full-preparation baseline

| Labels | Fields | Mode | Paired completion ratio | Pair range |
|---:|---:|---|---:|---:|
| 0 | 1 | exact | 1.016771 | 0.8686–1.2332 |
| 0 | 2 | exact | 1.009790 | 0.7751–1.1450 |
| 0 | 4 | exact | 0.929707 | 0.8970–1.1739 |
| 0 | 1 | full | 0.918374 | 0.8012–1.0350 |
| 0 | 2 | full | 0.990848 | 0.8591–1.0521 |
| 0 | 4 | full | 1.015695 | 0.8091–1.1508 |
| 25 | 1 | exact | 0.910495 | 0.8730–1.1840 |
| 25 | 2 | exact | 0.978813 | 0.8922–1.0187 |
| 25 | 4 | exact | 0.933544 | 0.9049–1.0675 |
| 25 | 1 | full | 0.975429 | 0.9197–1.0241 |
| 25 | 2 | full | 1.001932 | 0.9914–1.0369 |
| 25 | 4 | full | 0.996170 | 0.8729–1.0625 |
| 1000 | 1 | exact | 0.733416 | 0.5930–0.7634 |
| 1000 | 2 | exact | 0.602142 | 0.5189–0.7533 |
| 1000 | 4 | exact | 0.681601 | 0.5507–0.7012 |
| 1000 | 1 | full | 0.986755 | 0.9758–1.0489 |
| 1000 | 2 | full | 1.010882 | 0.9488–1.0675 |
| 1000 | 4 | full | 1.006075 | 0.9703–1.0441 |
| 0 | 1 | stream | 0.218615 | 0.1991–0.2244 |
| 25 | 1 | stream | 0.212364 | 0.2070–0.2241 |
| 1000 | 1 | stream | 0.203996 | 0.1926–0.2172 |

## Ungated tile baseline

| Labels | Fields | Mode | Paired completion ratio | Pair range |
|---:|---:|---|---:|---:|
| 0 | 1 | exact | 0.960722 | 0.9522–1.1454 |
| 25 | 1 | exact | 1.081491 | 0.9485–1.1537 |
| 25 | 2 | exact | 1.007742 | 1.0042–1.0284 |
| 1000 | 4 | exact | 0.987756 | 0.8928–1.0039 |
| 0 | 1 | stream | 1.004244 | 0.9363–1.1305 |
| 25 | 1 | stream | 1.069717 | 0.9318–1.1298 |
| 1000 | 1 | stream | 1.063233 | 0.9333–1.0769 |
