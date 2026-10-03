# Scene recording and finish measurements

This report measures the `Scene` CPU workload for the baseline, native-composition candidate, and measured retained-rendering V3 checkpoint. It covers synthetic 10,000-item Scenes through recording, `finish`, and replay APIs. It does not measure a native compositor, GPU execution, or end-to-end application rendering, and it makes no native-compositor performance claim. These numbers identify the exact V3 binary below; they are not final whole-pipeline measurements for later retained-tree layout changes.

`PaintOperation` occupies 24 bytes in both candidates versus 248 bytes at baseline. This is a record-size measurement only; it does not imply the same percentage reduction in total Scene or process memory.

## Method

The portable ignored fixture is [scene_workload.rs](../crates/gpui/src/scene_workload.rs), SHA-256 `bb0ce493ba82440a66c4c5e94f97cd0bd94dc54a4b1f928a0f7d04757158ee30`. It builds 10,000-item workloads. Times below are total microseconds for the stated loops, not per-item or per-frame times.

- **Finish-only:** each case builds and finishes its Scene before timing, then runs 500 iterations that mutate public lane keys, call `finish`, and black-box render commands. This measures repeated finish with direct public-lane edits. It does **not** resume recording through Scene APIs, so it does not exercise recording-reopen materialization.
- **Record + finish:** after warming Scene capacities, each case runs 50 frames of `clear`, recording 10,000 quads or sprites, and `finish`. Cases are sorted quads, reverse-order quads, and reversed sprite tile IDs.
- **Replay:** a finished reversed-quad Scene is replayed into a cleared destination 50 times; this timed loop does not call `finish`.

Five rounds were run in interleaved baseline, retained, native order. No GPUI build was running during timing. The host was an Apple M3 Pro with 36 GiB RAM on macOS 15.7.4 (Darwin 24.6.0), using Rust/Cargo 1.98.1 and `CARGO_PROFILE_TEST_OPT_LEVEL=3`. These are short single-host microbenchmarks; normal host scheduling/background load produced visible run-to-run variance. Medians are descriptive of these runs, not guaranteed application speedups.

The fixture is invoked from each optimized test binary as `scene_workload::scene_record_replay_microbench --ignored --nocapture`. Its source is identical across variants. The persisted five-round log for the final run is `/tmp/gpui-ce-scene-v3-final-raw.log` on the measurement host; all raw values are reproduced below.

## Median results

Times are total microseconds per loop. Deltas compare each candidate median with the baseline median; negative is faster and positive is slower.

| Workload | Baseline | Retained V3 | Native | Retained vs baseline | Native vs baseline |
|---|---:|---:|---:|---:|---:|
| Finish: sorted quads | 9,643 | 8,842 | 9,216 | -8.3% | -4.4% |
| Finish: strict reverse quads | 45,286 | 39,184 | 41,443 | -13.5% | -8.5% |
| Finish: reverse equal-key runs | 701,665 | 81,956 | 84,071 | -88.3% | -88.0% |
| Finish: one adjacent swap | 19,034 | 13,195 | 13,789 | -30.7% | -27.6% |
| Finish: mostly sorted quads | 116,570 | 88,274 | 87,913 | -24.3% | -24.6% |
| Finish: random quads | 646,866 | 167,366 | 165,290 | -74.1% | -74.4% |
| Finish: reversed sprite tile IDs | 23,517 | 24,484 | 24,091 | +4.1% | +2.4% |
| Record + finish: sorted quads | 166,882 | 161,786 | 169,626 | -3.1% | +1.6% |
| Record + finish: reverse quads | 171,067 | 161,257 | 166,067 | -5.7% | -2.9% |
| Record + finish: reversed sprite IDs | 160,717 | 158,813 | 158,212 | -1.2% | -1.6% |
| Replay: reverse quads | 179,461 | 193,567 | 170,883 | +7.9% | -4.8% |

The final candidates substantially reduce finish time in equal-run, one-swap, mostly-sorted, and random quad cases. Reversed sprite-ID finish remains slower by 4.1% retained and 2.4% native in these medians. Retained replay is 7.9% slower by median, while native replay is 4.8% faster; replay samples varied considerably, so these small-to-moderate differences need workload-level follow-up before being generalized. Native sorted record+finish is 1.6% slower by median. The record+finish rows otherwise improve modestly.

## Raw finish-only runs

Total microseconds for 500 × 10,000 items:

```csv
round,variant,sorted_quads,reverse_quads,reverse_equal_runs,one_swap,mostly_sorted,random_quads,reverse_sprite_ids
1,B,9695,45946,673600,19334,120432,646314,23389
1,R,13599,45020,80836,12877,88274,163636,24110
1,P,8501,39416,82305,13599,87536,161987,23484
2,B,9643,50045,716460,18600,116570,657816,23517
2,R,8817,38873,81100,13930,95766,182938,24484
2,P,9628,41443,81836,12955,86143,161706,23501
3,B,9555,45286,707296,19034,122346,651475,23743
3,R,8842,39184,82105,13002,86132,167624,25103
3,P,9297,42932,86677,13789,93404,190432,27385
4,B,10024,44495,701665,18629,113995,646866,24232
4,R,9077,41441,81956,13238,88445,167366,25284
4,P,9014,41932,85555,14360,89362,165290,24091
5,B,9306,40323,662273,19122,116455,643217,23434
5,R,8396,38825,82368,13195,87929,164970,24236
5,P,9216,41422,84071,13894,87913,166878,24653
```

## Raw record + finish and replay runs

Record + finish totals are microseconds for 50 × 10,000 items. Replay totals are microseconds for 50 × 10,000 replayed quads.

```csv
round,variant,record_sorted_quads,record_reverse_quads,record_reverse_sprite_ids,replay_reverse_quads
1,B,177010,175075,160717,194744
1,R,157271,160526,155493,162272
1,P,169626,167741,158212,170883
2,B,166882,171067,162953,179461
2,R,162419,161098,159029,193567
2,P,159629,159902,155452,164672
3,B,162599,165526,159558,168635
3,R,167205,162351,158813,229037
3,P,177879,204178,183579,208960
4,B,179264,198179,171053,190020
4,R,160467,161257,161031,227716
4,P,172190,166067,157986,169239
5,B,162678,168850,159412,165583
5,R,161786,161716,156011,168026
5,P,168983,159884,158318,172267
```

## Provenance

The baseline is pristine source commit `c6b17e616a35271183ab49f0da1890ee81953a99`. The native candidate is based at `d90cfa778e2dd022b7ec7d4b610728a9486f3ef1`; retained V3 is based at `c808b9b179bd947ef567016333b875cb1bcec0eb`. Candidate binaries were built with the optimized test profile and ran the same fixture.

| Variant | Test binary SHA-256 | `scene.rs` SHA-256 | Other measured fixture/source identity |
|---|---|---|---|
| Baseline | `beca85f06017fc8b111f0b975d65d7141e3a085aae45cce9de586a4897b434aa` | Baseline commit above | Shared fixture SHA-256 `bb0ce493ba82440a66c4c5e94f97cd0bd94dc54a4b1f928a0f7d04757158ee30` |
| Retained V3 | `3b8d026979eb1f7940c8fa531c0833f00a07bb8fd8f5441f58c105a8272484d3` | `cc7fbc5309d18c22d57d77940883e0aaf7359ae506590818d431815b75bd5928` | `taffy.rs` SHA-256 `b4f7de6bd4d96ed0a73b7c708cccb080fa1edf3e8d94ef47823ca5226f85cc1d`; `window.rs` SHA-256 `be6eba4e65d68d92418855985faf7c4e3a1d9de67e99d5a960d591a7244f160c`; shared fixture SHA above |
| Native | `97863e5de2ea1c5bcf413e6dbfd279dc8c69d19b885da33b7f8ef7802ce02ab8` | `0964d7b039e65828335f445c1172551b189783d607a4d70147ca2049dc4df952` | Shared fixture SHA above |

The retained V3 binary includes the retained-tree geometry changes present in the source files identified above; its Scene implementation and workload fixture are identified independently by their hashes. Later retained-tree layout changes are outside this measurement. Read these numbers as measurements of this particular Scene fixture and exact binaries, not as an end-to-end comparison of the native and retained renderers.
