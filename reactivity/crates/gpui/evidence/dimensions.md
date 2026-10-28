# Packed optional dimensions: held out of production

The experiment packs the two private `Option<f32>` dimensions into one `f32`
each, with one canonical NaN for Auto. Public `WIDTH`/`HEIGHT` selectors remain
`Option<f32>`. Every ingress already validates finite nonnegative values;
the private constructor preserves finite bits, including signed zero, subnormals
and `f32::MAX`. No unsafe code, table, allocation or external API change is needed.
On this 64-bit target Style becomes 80 B instead of 88, Node 120 instead of 128,
and El 168 instead of 176. Production retains the original representations.

Luna independently audited every write, erased and typed validation, overrides,
list-row height admission, Copy/Clone and the absence of serde construction.
The patch adds domain, equality, public builder and inspector rejection tests;
the full GPUI suite passes. This establishes representation correctness, not
that it is the best production choice.

Three equality implementations were measured separately:

1. Decode and compare `Option<f32>`.
2. Eager float equality or both-unordered predicates.
3. Compare sign-cleared bits. On this admitted domain, only zero can have a
   negative sign and Auto has one canonical NaN, so this exactly preserves
   `Option<f32>` equality. The sign bit remains stored and observable on reads.

The first implementation caused `layout_changed` to be outlined on this x86-64
build. The latter two restored inlining, but did not remove the larger observed
phase differences. An assembly observation is not a causal proof for those
differences.

## Measurement

Baseline source is `067eebce12`; each candidate is the corresponding complete
[patch](dimensions/mask.patch). Sources, binary hashes, CPU affinity and raw
samples are in [dimensions/](dimensions/). Rust 1.97.1 release builds used the
unchanged `color_cost`, `text_lane_measure` and `retained_list` examples. Eleven
fresh-process pairs per case alternated AB/BA and case order on one pinned CPU.
Other agents held heavy builds and measurements during capture. The text and
list fixtures run their existing independent output checks before timing.

Final sign-mask candidate, medians (time percentages are the median paired
percentage, not the ratio of marginal medians):

| Case | Baseline | Candidate | Paired change |
| --- | ---: | ---: | ---: |
| 10,001-node textless retained bytes | 4,840,452 | 4,760,444 | −80,008 B |
| Same mount, µs | 7,825.220 | 7,664.437 | −2.39% |
| Sparse-text equal description, µs | 5,040.735 | 5,424.205 | +7.96% |
| Textless failure repair, µs | 8,876.094 | 10,378.729 | +16.26% |
| 10K unique-color mount, µs | 9,948.829 | 9,495.869 | −4.40% |
| Virtual 250K scroll, µs | 268.716 | 269.086 | −0.38% |

Allocation counts are unchanged. The 10K repeated-color fixture saves 80,008 B
from 10,074,196 retained B, only 0.79% of that whole owner; the textless fixture
saves 1.65%. This is not a blank-window RSS, PSS or startup result.

Whole text-trace paired medians also differ from individual phases: textless
−6.51%, sparse recording +1.79%, sparse CPU −0.37%. Allocation history can affect
later operations; subsequent independent lookup-table removal also changed some
of these phases despite leaving node sizes unchanged. These captures establish
the observed costs, not an isolated explanation in terms of stride, branches or
allocator bins. Fixed allocator-policy controls and isolated phase profiling
remain possible follow-ups. No statistical significance or portable latency
claim is made from these eleven pairs.

The small retained saving and unresolved costs are insufficient to replace the
current representation now. Keep the full evidence and rejected patches so a
future layout or allocation change can reassess this without repeating the
domain audit or concealing the losing cases.
