# Fine grid native selection and planned-work audit

Production39efefe5; diagnostic7cc9497c only adds optional CPU logging. All8
processes finish normally,17 workload tests pass,1082 packets select8x8 literal
mask tiles. All lowered references remain within selected tiles. Both frozen
native images exactly equal the uninstrumented oracle. Generated/embedded
shader, executed ELF, source guards and independently reverified GPU admission
pass. The parent16x16 audit2520aeec is pinned and reverified before observations.

| Initial | Draws | Fine references | Fine sample work | Coarse sample work | Fine/coarse |
| --- | --- | --- | --- | --- | --- |
| 0 | 470 | 10066 | 10307584 | 18989056 | .542817084 |
| 190 | 1071 | 14840 | 15196160 | 27451392 | .553566100 |

First packet draw/mask/unit-axis/dimension counts equal the parent in all modes.
Initial0 has106275 misses/140672 lowered pixel references;initial190 has242499/
325184. Later packets are not enumerated. All packet sample sums match original
Stats. Total across1082 packets:5303229 mask references,4938895 lowered references,
2843666 selected tiles. Larger CSR/tile/CPU/upload costs remain charged.

Planned full-packet work only, not damage-cropped GPU loads, cache-hit rates or
performance. Static pre-observation verifier correction is preserved. This
admits the separate uninstrumented fixed64-process screen, not adoption.
