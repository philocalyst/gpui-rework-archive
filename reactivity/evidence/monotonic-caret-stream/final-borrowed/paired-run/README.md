# One final paired capture — not adopted

The single granted campaign compares indexed baseline
**1d5bc3061cce3beb3c4857102ed651da501b5cfd** against final borrowed stream
**81bd9e53b7a18161903dad3816d494ed1afdfce3**. These are the actual build pins;
the baseline is not relabelled as current main. The adjacent final archive
contains the complete source/support patches and the81-file/83-artifact proof
that the baseline's compiled production text inputs were unchanged in main89ae.

Root granted the text phase after all three other agents ACKed idle and a process
audit was empty at2026-10-23 00:12:50 UTC. This one invocation began00:13:02 and
ended00:13:29 UTC, exit0,26.546162885031663 driver seconds. A44-second process
cap bounded the command. It was not retried. There are224 raw process records:
28 separate allocator observations and196 timed observations,14 cold/warm
cohorts ×7 alternating pairs ×2 variants. Every observation and stderr/status
is retained, including every slower sample. The child was pinned to CPU0.

The frozen runner is span/run_variants.py from support98b68895c9, SHA-256
`bf6762663c55fe242030292323190fae5d18c86f20a509242f135b4ca8e51bec`.
Metadata SHA-256 is
`e6bc0efa1d2fae23d93fd0569d342519e07ca5f14807d4882abba419e84add0a`.
Baseline binary SHA is
`c790f7fc3ee947a0697fb98c98b1e675ade7edd25827d8e038c8d005ab6d0f20`;
final binary SHA is
`d8d8141d5b46a7c16f2e177ed3ead2e60599be6ce7f9956f1b43f4143b432f98`.
Binary/source guards421 per variant passed before the campaign, after every
pair and after the campaign; a later post-hold check also passed. All checksums
matched. Allocation rows intentionally differ and were captured independently,
not subjected to the old allocation-equality assertion. No source, executable
or runner was edited during the capture.

Final relative to baseline median ns/round (negative means faster):

| Cohort | Cold | Warm |
| --- | ---: | ---: |
| tiny | -0.38% | -2.41% |
| label | -3.82% | -0.84% |
| Latin | -0.41% | -3.23% |
| RTL | **+4.10%** | **+3.06%** |
| mixed | **+0.72%** | **+1.31%** |
| paragraph chunks | -1.68% | -1.75% |
| one long grapheme | **+4.22%** | -1.40% |

The strong transient-memory cut therefore does not establish a blanket speed
win. RTL remains slower in both scopes; mixed is slightly slower, and the
one-grapheme cold loss is preserved. No statistical significance or population
claim follows from seven local pairs. Tiny/one-grapheme use the retained direct
Canvas branch, but differing linked code and host variation still prevent
assuming their measured changes must be zero. The previous16B stream's much
larger losses remain independently archived, not replaced by this run.

Each process primes fonts before measured shaping. Cold means a fresh scoped
Planner per round; warm reuses it. The elapsed work includes dropping the prior
result. Process launch, source guards and font priming are outside each reported
inner duration. CPU affinity and coordinated idle processes reduce interference;
unrelated host activity remains uncontrolled. This is default SIMD release
shaping, not a native frame, UI event, startup, RSS or cross-platform latency
measurement. Full allocator requested/retained/peak rows accompany each cohort.
No production adoption is made by this archive.

Exact launch (paths are local; source/metadata/binaries are frozen above):

```sh
timeout 44s /nix/store/9r02ykx9y35lf4gk6gc30gnag1y8ncp7-python3-3.13.15/bin/python3 \
  /root/gpui-monotonic-caret-borrowed/reactivity/evidence/monotonic-caret-span/run_variants.py \
  --metadata /tmp/gpui-monotonic-final-pair-metadata.json \
  --output /tmp/gpui-monotonic-final-pair
```

The outer shell separately wrote UTC start/end and the actual exit status;
stdout/stderr are included. The runner's complete source is already in the
adjacent support.patch.gz (73 non-test code lines), with no duplicate runner
implementation in this archive. JSON files are gzip-compressed without changing
their original bytes. No new shipping or test source was changed for this run.
