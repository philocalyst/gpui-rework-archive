# Initial caret-pair control: retained, superseded experiment

This is an isolated experiment, not an integrated library change. The first
formulation removed duplicate affinity work but still copied large cluster
values. Its measured long-text benefit did not excuse those copies or its
short-paragraph regression; the next candidate is being reformulated around
borrowed clusters and cached visual edges. No result here qualifies that next
candidate.

## Frozen sources and measurement

`pair/metadata.json` records exact Cargo artifacts, profiles, executable hashes
and source guards. The matched baseline is
`879476dd0bf391e8482dddea61271bb775b4f639`; the candidate is
`d74fc223e799956c1e21997dd7eec88abe8aff39`. Their shipping library differences
were already present at `1a1206f1c5ebe9162830c16049dd27b1fba31074`.
The fixture, manifests and lockfile match between measured variants.

The driver ran seven alternating pairs on CPU 0, with 14 cohorts and 28 matched
allocation rows including preflight. Source and executable guards passed before
and after each pair. No live Cargo/rustc/Clippy process overlapped the campaign;
finished zombie processes were excluded from that check. Other host activity
was not controlled. Raw samples and checksums are in `pair/runs.json` and
`pair/summary.json`; the guard, iteration and process checks are in `pair/run.py`.

| Text | Cold scoped planner | Reused planner |
|---|---:|---:|
| Tiny, 5 bytes | +0.21% | +1.90% |
| Label, 18 bytes | −4.18% | −14.80% |
| Latin, 30,800 bytes | −20.38% | −20.14% |
| RTL, 27,000 bytes | −8.67% | −9.32% |
| Mixed direction, 25,200 bytes | −12.32% | −10.20% |
| Short paragraphs, 10,800 bytes | +2.82% | +1.50% |
| One grapheme, 24,001 bytes | +0.07% | +0.81% |

Values compare medians; negative means less elapsed time. Both variants prime
the process font registry before measurement. “Cold” creates a new scoped
planner; it is not cold process startup. Timing includes previous-output drop.
These are shape/interactive-caret measurements, not window latency, click
latency, RSS, GPU performance, or a competitor comparison. Allocation counts,
requested/retained/peak bytes and output checksums match in every cohort. This
candidate did not reduce heap allocation or retained bytes.

## Correctness and costs

The parallel Canvas suite passed 193 cases/docs with four ignored cases, and
all-target strict Clippy passed. `canvas-full.log.gz`, `strict.log.gz` and the
first oracle log preserve their original source qualifications. The independent
real-font oracle compared unindexed cursor geometry bit for bit at every source
byte, including UTF-8 interiors, wrap/bidi boundaries and extreme widths, and
compared packed caret streams. It accepted 80,352 positions, rejected 40,032
snapped positions and observed 10,032 distinct affinity pairs.

The temporary, call-local probe ran against `1a1206f1…` plus
`probe/probe.patch`: 8,640 endpoints, 32,768 shared LTR edges, 20,224 shared RTL
edges and 18,720 fallback positions. The same oracle passed. The probe was then
removed and every touched source file matched its recorded baseline hash.
Instrumentation is not shipping source and does not qualify timing or allocation.

`core-lines.json` charges 30,005 non-test/comment/blank core lines, two fewer
than the 30,007-line baseline. Vendored Parley is accounted separately: the
changed geometry file grows from 78 to 131 code lines (+53), measured with
tokei 15.0.0. Test helpers, fixture and patch-ledger prose are excluded from the
core figure, rather than hidden as a shipping-code reduction.

The linked assembly audit found a 1,144-byte helper frame, visible 136-byte
staging copies and an additional small-text array-map closure. Linked `.text`
grew 1,872 bytes and the executable grew 2,224 bytes. Individual frames are not
summed into a peak-stack claim. `assembly/report.md` and the disassembly excerpts
preserve those findings and exact executable hashes. `no-cluster-proposal.md`
records the stronger cached-edge proof driving the next experiment; it is a
proposal, not measured performance.

## Preserved failed admission and archive format

`admission-reject/` retains the earlier partial run whose 33,000-byte Latin
fixture exceeded the existing 32,768-byte resource limit. Only the fixture was
corrected to 30,800 bytes; production limits were unchanged. Its partial results
are not substituted for the complete campaign above.

`source.patch.gz` captures the complete initial source/test/fixture patch.
Large text files are losslessly gzip-compressed. Executables are omitted; their
hashes, sizes and Cargo artifact records remain in metadata. Original assembly
manifests name original uncompressed paths. The root `SHA256.json` hashes the
actual archived files, including compressed copies and this README.
