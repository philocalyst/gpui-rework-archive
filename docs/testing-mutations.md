# Pseudo-mutation campaign

The Luna test pass ran source mutations sequentially in a disposable `git archive HEAD` checkout. Every source file was restored after its trial; the user's working checkout was never mutated by the runner. The runner made no commits or pushes.

## Initial campaign

Source revision: `0103d685c6` (2026-10-06). Each focused command passed once on unmodified source before its mutant ran. The campaign used analytic pixel expectations and state/report assertions, not hand-authored raster hash constants.

| Mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `skip-underlines` | colored multiline Parley underline pixels | **killed** | 8.63 s |
| `source-over-alpha` | generated source-over alpha property | **killed** | 4.74 s |
| `ignore-glyph-transform` | transformed monochrome glyph destination pixels | **killed** | 4.61 s |
| `drop-filter-opacity` | nested filter opacity and inline depth | **killed** | 6.86 s |
| `inline-boundary-not-stacked` | nested inline filter boundary stack law | **killed** | 5.20 s |
| `path-half-open-edges` | shared-edge path coverage | **killed** | 5.86 s |
| `ignore-path-content-clip` | path composite clip and alpha | **survived** | 8.06 s |
| `freeze-animation-clock` | fixed-time animation and repeat phase | **killed** | 11.35 s |
| `disable-animation-repeat` | repeat phase at 1250 ms | **killed** | 8.41 s |
| `linearize-animation-easing` | eased marker position at 250 ms | **killed** | 5.21 s |
| `accept-unsupported-capture-version` | capture-version validation | **killed** | 27.19 s |
| `ignore-removed-checkpoints` | report checkpoint removal detection | **killed** | 37.20 s |

Initial result: **11 killed, 1 survived, 0 invalid, 0 timed out**. The surviving mutation widened the CPU path raster pass from `path.clipped_bounds()` to `path.bounds`. The solid path still produced no observable change because the later sprite composite remained clipped. This showed the first test did not observe the changed *raster bounds*; it did not establish that path clipping was fully protected.

## Initial baseline commands

These nine distinct focused checks passed on the unmodified archived source:

| Focused check | Baseline |
|---|---:|
| multiline colored underline pixels | passed |
| generated source-over alpha | passed |
| transformed monochrome glyph | passed |
| nested isolated filter rendering | passed |
| shared path edge coverage | passed |
| clipped path compositing | passed |
| fixed animation times and repeat boundaries | passed |
| capture version and finite-filter validation | passed |
| removed checkpoint report comparison | passed |

## Clip follow-up

Two distinct clip stages are covered in follow-up checks:

- A clipped horizontal sRGB gradient asserts a known interior pixel derived from the clipped paint width. Widening the raster paint bounds changes that expected pixel even though the later sprite composite still clips.
- A direct plan-law test inspects `path_types::sprites` and asserts all four composite bounds equal the content clip. A separate mutation widens these bounds, so this check does not rely on the CPU raster pass producing pixels outside the clip.

The follow-up mutations, plus font gamma/order, fractional coverage, and maximum-radius blur checks, will be reported here after running against the integrated source revision. Until then, these additions are unverified mutation evidence.

## Result meanings and limits

`killed` means the focused test ran and failed by assertion. `survived` means it completed successfully despite the source change. `invalid` means compilation, setup, or test selection prevented behavioral evidence. `timeout` is inconclusive. Compile failures do not count as killed mutants.
