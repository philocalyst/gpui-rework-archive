# Pseudo-mutation campaign

## Final Luna campaign after simplification

The final campaign ran against archived revision `a00a48972e`. All 14 distinct baseline commands passed before the mutations: **18 killed, 0 survived, 0 invalid, 0 timed out**. The [complete run](testing-mutations-run.md) records commands, times, and assertion failures. It extends the 15 rendering, capture, animation, and report mutations below with three checks of the final cleanup:

| Added mutant | Observed failure |
|---|---|
| Drop entity observation events | The stream returns `None` instead of the first notification |
| Ignore the selected scenario filter | An unrelated new scenario appears in a partial comparison |
| Compare widened values instead of persisted JSON | Unchanged fractional geometry incorrectly adds two scene changes |

Trials ran in a disposable source archive and restored each file in `finally`. This campaign reused the normal Cargo target cache; a concurrently generated report exposed that Cargo had replaced its executable with an underline mutant. The runner now defaults to its own persistent `target/pseudo-mutation` cache, isolating mutant executables from normal builds. Reports were regenerated from an unmutated build afterward. No working source was mutated, committed, or pushed by the runner.

Run the committed checks again with:

```sh
python3 scripts/testing/pseudo_mutation.py --timeout-seconds 300
```

The generated report records the tested source revision. Compilation failures, zero-test selections, and timeouts are inconclusive and never count as killed mutations.

## Earlier integrated campaign

The campaign used a disposable `git archive HEAD` checkout at source revision `1977b94c2f` (2026-10-06 19:11 UTC). Mutation configuration included the local test-runner additions for the new clipped-sprite, font gamma, and RGB/BGR laws. Trials ran sequentially; the runner restored each mutated file in `finally`, and never changed the user's working checkout. It made no commits or pushes.

The command ran against each exact unmutated focused test first. All 12 distinct baselines passed. Then each compiling source mutation caused its named focused test to fail by assertion: **15 killed, 0 survived, 0 invalid, 0 timed out**. A build or test-selection failure would be classified `invalid`, never as a killed mutant.

| Mutant | Focused Rust test | Result | Mutant time |
|---|---|---:|---:|
| `skip-underlines` | `wrapped_parley_text_keeps_colored_wavy_underlines_on_multiple_lines` | **killed** | 9.04 s |
| `source-over-alpha` | `overlapping_translucent_quads_obey_source_over_for_generated_alpha_pairs` | **killed** | 5.75 s |
| `ignore-glyph-transform` | `monochrome_glyph_samples_at_transformed_destination_coordinates` | **killed** | 5.75 s |
| `ignore-font-gamma` | `font_gamma_correction_preserves_neutral_and_corrects_half_coverage` | **killed** | 5.55 s |
| `ignore-subpixel-order` | `subpixel_order_reverses_red_and_blue_coverage_channels` | **killed** | 5.83 s |
| `drop-filter-opacity` | `nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target` | **killed** | 5.64 s |
| `inline-boundary-not-stacked` | `nested_isolated_filters_composite_once_and_inline_fallback_keeps_parent_target` | **killed** | 5.06 s |
| `path-half-open-edges` | `adjacent_path_triangles_assign_shared_edge_pixels_once` | **killed** | 4.80 s |
| `ignore-path-raster-clip` | `clipped_path_gradient_uses_the_clipped_paint_bounds` | **killed** | 4.69 s |
| `ignore-path-content-clip` | `path_composite_sprite_bounds_match_the_content_clip` | **killed** | 13.38 s |
| `freeze-animation-clock` | `fixed_animation_times_are_idempotent_and_cross_repeat_boundaries` | **killed** | 20.02 s |
| `disable-animation-repeat` | `fixed_animation_times_are_idempotent_and_cross_repeat_boundaries` | **killed** | 7.63 s |
| `linearize-animation-easing` | `fixed_animation_times_are_idempotent_and_cross_repeat_boundaries` | **killed** | 7.02 s |
| `accept-unsupported-capture-version` | `rejects_version_mutation_and_non_finite_filter_encoding` | **killed** | 29.39 s |
| `ignore-removed-checkpoints` | `report_comparison_reports_removed_checkpoints` | **killed** | 70.86 s |

The two clip mutants check different stages. `ignore-path-raster-clip` widens CPU raster paint bounds; the clipped sRGB gradient has a known pixel derived from the clipped paint width, so this catches a change even when the subsequent sprite composite clips. `ignore-path-content-clip` widens the composite sprite bounds and is tested directly against the path sprite plan bounds, independent of raster coverage. The new bounds law closes the original campaign's observation gap.

The runner invocation was:

```text
python3 scripts/testing/pseudo_mutation.py --repo <workspace> --timeout-seconds 300 --report docs/testing-mutations-followup.md
```

## Historical initial campaign

An earlier Luna pass used the runner at source revision `0103d685c6` (2026-10-06 18:43 UTC). It ran the source mutations in a disposable archive and passed all nine distinct focused baselines first.

| Initial mutant | Focused check | Result | Time |
|---|---|---:|---:|
| `skip-underlines` | colored multiline Parley underline pixels | **killed** | 8.63 s |
| `source-over-alpha` | generated source-over alpha property | **killed** | 4.74 s |
| `ignore-glyph-transform` | transformed monochrome glyph destination pixels | **killed** | 4.61 s |
| `drop-filter-opacity` | nested filter opacity and inline depth | **killed** | 6.86 s |
| `inline-boundary-not-stacked` | nested inline filter boundary stack law | **killed** | 5.20 s |
| `path-half-open-edges` | shared-edge path coverage | **killed** | 5.86 s |
| `ignore-path-content-clip` | path clip pixel bounds | **survived** | 8.06 s |
| `freeze-animation-clock` | fixed-time animation and repeat phase | **killed** | 11.35 s |
| `disable-animation-repeat` | repeat phase at 1250 ms | **killed** | 8.41 s |
| `linearize-animation-easing` | eased marker at 250 ms | **killed** | 5.21 s |
| `accept-unsupported-capture-version` | capture-version validation | **killed** | 27.19 s |
| `ignore-removed-checkpoints` | report checkpoint removal detection | **killed** | 37.20 s |

Initial result: **11 killed, 1 survived, 0 invalid, 0 timed out**. That survivor changed CPU path raster bounds from `path.clipped_bounds()` to `path.bounds`. The solid path remained visually unchanged because the composite stage still clipped it. This is why the later campaign added both the clipped-gradient paint-bounds law and a separate direct composite-sprite-bounds law. The two campaign results are preserved here rather than silently replacing the original survivor.
