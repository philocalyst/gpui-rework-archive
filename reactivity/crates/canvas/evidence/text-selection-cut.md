# Text query source cuts

Final source: `88ea40418a` plus test-placement-only `9e49540c47`, based on
`c36685f68a`. Baseline is `c36685f68a` with the identical measurement driver.
The initial eager control is separately reproducible at `796d754c0b`.

The canonical caret map already sorts source bytes. Selection now borrows only
the inclusive endpoint groups found by byte partition. Physical hit/motion
queries partition to the requested line's source start, then stop lazily when
interval start bytes exceed that line's source end. They retain the existing
source-affinity owner-line check: a soft wrap has two caret destinations at one
byte, while an atomic CRLF separator needs the next paragraph's boundary to
complete the preceding line's last interval. Empty lines keep their own stop.
This does not assume caret geometry is monotone in source order.

No header, column, retained index, cache, or allocation is added. The internal
structural gate compares cut interval ownership with the original complete-map
walk. Its 10,000-byte fixture has 9,999 complete intervals; target lines derive
at most eight, including the rejected sentinel interval needed to stop a lazy
walk. A requested two-interval source range derives exactly two. Real-font
integration gates independently cover bidi, wraps, CRLF, combining marks and
ligatures through the ordinary production APIs.

For S stops, K intervals on the target line, L lines and R runs, physical
queries now do O(log S + K log L) work, plus the existing hard-break run lookup
and a constant number of boundary intervals. The first source line skips its
lower partition. An N-interval selection does O(log S + N log L), plus selected
hard-break run lookup. The complete-map complexity is no longer paid for an
isolated query at the end of a large layout.

## Matched local measurements

`text-selection-cut.csv` contains seven alternating fresh-process pairs for
one and 1,800 mixed-script paragraphs. The latter is 27,000 UTF-8 bytes and
5,401 visual lines, shaped using the bundled actual fonts at 18 px and width
55. The same driver calls ordinary hit, motion and selection APIs. CPU 2 was
pinned; all team builds/tests were held during the 5.540-second final capture.
Toolchain: Rust 1.97.1, ordinary Cargo release profile on the local Ryzen 7
3700X host. Shaping precedes timing. The fixed case order can affect cache
warmth; this is a query experiment, not startup or whole-editor latency.

Median nanoseconds per query:

| Paragraphs | Query | Baseline | Candidate |
| ---: | --- | ---: | ---: |
| 1 | First-line hit | 22.05 | 26.46 |
| 1 | Last-line hit | 75.75 | 41.22 |
| 1 | Last-line motion | 119.02 | 83.65 |
| 1 | Local selection | 134.98 | 45.17 |
| 1 | Whole selection | 163.23 | 166.15 |
| 1,800 | First-line hit | 66.50 | 69.64 |
| 1,800 | Last-line hit | 702,405.93 | 124.70 |
| 1,800 | Last-line motion | 704,973.55 | 284.67 |
| 1,800 | Local selection | 749,437.35 | 136.47 |
| 1,800 | Whole selection | 791,545.00 | 790,832.75 |

The first-hit overhead is visible: approximately four nanoseconds on the tiny
case and three nanoseconds on the large case. Whole selection is effectively
unchanged; no whole-range speedup is claimed. The large local-query gain comes
from deleting unrelated work, not SIMD arithmetic or changed Unicode policy.

`text-selection-cut-identities.csv` pins the final distinct executables and
source bodies. The driver source hashes must match and executable/query source
hashes must differ. The capture script rechecks those identities before every
process and after all pairs, then requires equal per-pair query signatures.
Exact geometry correctness remains the independent integration tests' job;
the measurement signatures are additional control guards, not their substitute.

The eager-control CSV/identities/assembly are retained separately. Eagerly
partitioning both line bounds improved distant queries but made the first hit
about 2.3 times slower by doing unnecessary searches before its lazy early
return. The final line path keeps that early return. Selection retains an
endpoint-bounded slice and its original iterator, avoiding a redundant per-item
line cutoff.

The baseline, eager and final assembly extracts contain `position_at`, physical
motion, the driver's actual monomorphized selection callback, and the new stop
slice helper when present. They show scalar source-bound searches and bounded
iteration over the existing stop stride; no vectorization or machine-code-size
reduction is claimed. Extract with `objdump -Cd` from the pinned executables.

## Validation and source ledger

Final eight selection and fourteen Unicode release tests pass, including the
independent real-Parley/visual-cluster geometry gates. The structural work test
passes. Strict all-target Clippy with `--features parallel` passes. The default
full Canvas release suite passed (162 tests, three existing ignored); see the local final log
`/tmp/gpui-text-selection-cut-final-release.log`.

All changed non-test implementation source is counted, including executables
and the capture helper: production Rust +43/-14 (net +29); ordinary measurement
example +109; Python capture helper +40. Total non-test source +192/-14, net
+178. The structural unit-test block adds 87 lines. CSV, assembly and this
evidence document are separate generated/report artifacts.

Reproduce the final capture with the same driver installed in both trees:

```sh
cargo build --release -p gpui_canvas --example selection_queries
python3 crates/canvas/measure-selection-queries.py \
  --baseline-root /root/gpui-text-query-baseline \
  --candidate-root /root/gpui-text-selection-cut \
  --baseline-bin /root/gpui-text-query-baseline-target/release/examples/selection_queries \
  --candidate-bin /root/gpui-text-selection-cut-target/release/examples/selection_queries \
  --output-dir crates/canvas/evidence
```
