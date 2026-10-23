# Audio quiet capture

This is incomplete qualification, not an adoption approval. After capture the
explicit 40974-frame long-tail regression was added through a test-only oracle
helper; production geometry and processing code remain exactly as captured.
`samples.csv` contains every measured duration, output-frame count and paired
ratio. This report contains every measured cohort's interval. Cohort definitions
and the classification rules are in `PREREG.md`; exact hashes are in
`FINGERPRINTS.txt`. Complete console logs and frozen source/binary remain at the
recorded session paths. A successor must preserve this evidence separately.

Frozen probe and production sources: `/tmp/gpui-hummingbird-audio-evidence/sol-freeze/sha256.txt`; probe/classification prereg: `/tmp/gpui-hummingbird-audio-probe/PREREG.md`. Capture began 2026-10-23 09:23:04 UTC; all capture children exited 09:25:23 UTC. No source changes or recompiles during capture. No native CPU flags. Full scope is pipeline processing, or pipeline construction+retirement; it excludes decoder, transport, CPAL/device, UI and OS.

Each row has 13 paired AB/BA samples. Paired median ratios and 95% percentile bootstrap intervals use 10,000 resamples with xorshift32 seed `0x183b294d + cohort + (constructor ? 1000 : 0)`. Every raw paired ratio is in `gpui-audio-sol-all-cohorts.csv`; every raw duration/frame count remains in the four capture logs. No incumbent median was slower, so the prespecified 31-pair repeat was not triggered. These intervals describe this capture, not a proof of universal speed.

Processing 15–17/22 remains unresolved: the untouched baseline fails its warmup in cohort15 with `Decode("resampler made no tail progress")`. No baseline repair or fixture change was made; the panic log is preserved. These cohorts have constructor results only and are not performance wins.

Changed-filter cohorts23–24 are separate. Their units/delay and submitted-frame counts differ. Cohort24 construction is slower: paired ratio1.429, interval[1.427,1.432]. Its faster processing does not offset this result or make it an incumbent win. A universal no-regression/adoption claim remains unsupported for changed geometry.

| Cohort | Kind | Median new/old time | Median paired ratio | 95% interval |
|---|---|---:|---:|---:|
| 0 | process+tail | 0.8698 | 0.8715 | [0.8678, 0.8721] |
| 1 | process+tail | 0.9066 | 0.9048 | [0.8970, 0.9097] |
| 2 | process+tail | 0.8360 | 0.8369 | [0.8351, 0.8412] |
| 3 | process+tail | 0.8784 | 0.8780 | [0.8766, 0.8796] |
| 4 | process+tail | 0.9015 | 0.8988 | [0.8919, 0.9048] |
| 5 | process+tail | 0.8334 | 0.8346 | [0.8249, 0.8366] |
| 6 | process+tail | 0.8376 | 0.8425 | [0.8353, 0.8438] |
| 7 | process+tail | 0.8983 | 0.8988 | [0.8807, 0.9014] |
| 8 | process+tail | 0.8171 | 0.8171 | [0.8073, 0.8184] |
| 9 | process+tail | 0.8854 | 0.8865 | [0.8792, 0.8886] |
| 10 | process+tail | 0.8977 | 0.8983 | [0.8905, 0.8999] |
| 11 | process+tail | 0.8284 | 0.8266 | [0.8244, 0.8284] |
| 12 | process+tail | 0.9057 | 0.9050 | [0.9032, 0.9066] |
| 13 | process+tail | 0.8755 | 0.8780 | [0.8687, 0.8821] |
| 14 | process+tail | 0.8160 | 0.8167 | [0.8117, 0.8192] |
| 18 | process+tail | 0.7940 | 0.7941 | [0.7897, 0.7979] |
| 19 | process+tail | 0.9320 | 0.9275 | [0.9230, 0.9332] |
| 20 | process+tail | 0.5587 | 0.5579 | [0.5560, 0.5603] |
| 21 | process+tail | 0.9027 | 0.9047 | [0.9007, 0.9066] |
| 23 (changed filter) | process+tail | 0.3346 | 0.3351 | [0.3342, 0.3357] |
| 24 (changed filter) | process+tail | 0.4498 | 0.4492 | [0.4468, 0.4508] |
| 0 | construct+retire | 0.9627 | 0.9625 | [0.9601, 0.9669] |
| 1 | construct+retire | 0.9506 | 0.9530 | [0.9476, 0.9557] |
| 2 | construct+retire | 0.9585 | 0.9601 | [0.9574, 0.9617] |
| 3 | construct+retire | 0.9615 | 0.9613 | [0.9575, 0.9649] |
| 4 | construct+retire | 0.9465 | 0.9458 | [0.9451, 0.9484] |
| 5 | construct+retire | 0.9589 | 0.9596 | [0.9548, 0.9607] |
| 6 | construct+retire | 0.9636 | 0.9642 | [0.9620, 0.9678] |
| 7 | construct+retire | 0.9586 | 0.9598 | [0.9498, 0.9615] |
| 8 | construct+retire | 0.9676 | 0.9685 | [0.9633, 0.9701] |
| 9 | construct+retire | 0.9792 | 0.9795 | [0.9748, 0.9813] |
| 10 | construct+retire | 0.7814 | 0.7811 | [0.7786, 0.7833] |
| 11 | construct+retire | 0.9781 | 0.9734 | [0.9713, 0.9769] |
| 12 | construct+retire | 0.7724 | 0.7720 | [0.7666, 0.7745] |
| 13 | construct+retire | 0.6200 | 0.6185 | [0.6160, 0.6225] |
| 14 | construct+retire | 0.7689 | 0.7699 | [0.7679, 0.7704] |
| 15 | construct+retire | 0.8835 | 0.8839 | [0.8741, 0.8889] |
| 16 | construct+retire | 0.8430 | 0.8432 | [0.8366, 0.8451] |
| 17 | construct+retire | 0.8850 | 0.8881 | [0.8846, 0.8896] |
| 18 | construct+retire | 0.5425 | 0.5425 | [0.5350, 0.5436] |
| 19 | construct+retire | 0.5675 | 0.5671 | [0.5668, 0.5732] |
| 20 | construct+retire | 0.5531 | 0.5536 | [0.5467, 0.5544] |
| 21 | construct+retire | 0.9460 | 0.9435 | [0.9411, 0.9499] |
| 22 | construct+retire | 0.8099 | 0.8432 | [0.8412, 0.8444] |
| 23 (changed filter) | construct+retire | 0.6297 | 0.6285 | [0.6270, 0.6313] |
| 24 (changed filter) | construct+retire | 1.4268 | 1.4286 | [1.4266, 1.4316] |

Raw logs: `/tmp/gpui-audio-sol-processing-capture.log`, `/tmp/gpui-audio-sol-processing-rest-incumbent.log`, `/tmp/gpui-audio-sol-processing-changed.log`, `/tmp/gpui-audio-sol-constructor-capture.log`.
