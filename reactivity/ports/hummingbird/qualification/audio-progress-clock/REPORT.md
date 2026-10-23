# Progress-driven public audio service

All 13 frozen release executions passed all six scheduled rate cohorts: 78
zero-missing-frame checks. The frozen control missed 5328 frames in the first
768000 -> 48000 cohort. This establishes the tested public service's ability to
maintain the specified consumption schedule; it is not hardware playback,
audible completion, an arbitrary UI-stall guarantee or a universal latency bound.

The sink alone is replaced. Real queue controls, Win/Inbox delivery, WAV decode,
media worker, pipeline, output permission and service owners run normally. Each
case prefills 100 ms, then consumes fixed 10 ms callback amounts at 25 absolute
deadlines. Cases are 768000 -> 48000, 768000 -> 96000, 384000 -> 48000,
48000 -> 44100, 44100 -> 48000 and 11025 -> 44100. Baseline stops at its first
failure; its later cohorts are unmeasured. No baseline retry or repair occurred.

The original service unconditionally parked 2 ms after every unit. A 256/16
unit at 768000 -> 48000 represents only one third of a millisecond. The candidate
continues while actual work advances, and parks when credit/media block it.
Close/latest intent and events are handled between bounded units. A consumed
reply, completed preparation, accepted PCM, source-offset advance, issued decode,
new tail PCM or terminal transition counts; retrying pending PCM does not.
The flag is ephemeral. No retained field, callback syscall, queue or worker was
added. Existing blocked polling and callback behavior are unchanged.

The faster loop exposed a one-frame seek trim error in an existing exact public
seek assertion. Converting packet timestamps through nanoseconds/f64 before
`ceil` could move an exact sample boundary past its integer. Targets now remain
integer milliseconds, and trimming uses the packet's exact rational time base
before the final ceiling. Real WAV/FLAC/MP3 repeated seek controls were expanded;
the original public seek assertion is unchanged and passes.

Untimed candidate qualification: 26 private and 17 public tests passed, with the
quiet-host deadline test ignored by default. The actual `Owner::cycle` virtual
schedule verifies that every true flag changes work, three blocked retries
remain false and unchanged, and independent Rubato delay/integer-frame counts
drain exactly. The public lifecycle sink accounts for every accepted frame
through pause, seek, tail drain and stop, including immediate stop permission.
The inherited callback/core zero-allocation and complete-pipeline allocation/
retirement controls remain passing. No whole-service RSS or hardware bound is
inferred from the pipeline ownership bill.

The exclusive scheduled window ran 2026-10-23 10:38:02 through 10:38:22 UTC.
Every test child exited 0; each test reports 1.53 seconds. `candidate.log`
preserves every result, and `baseline.log` preserves the expected failure.
Before/after source and binary hashes match. The clock test is byte-identical
between versions. Exact fingerprints are in `baseline.sha256` and
`candidate.sha256`; final verification is in `final-source-check.log`.
The approved wrapper was:

```
timeout --signal=TERM --kill-after=5s 90s /tmp/gpui-hummingbird-audio-evidence/sol-progress-freeze/capture.sh
```

The campaign status and final hash status were both 0. After DONE and the final
empty child-process guard, the outer login shell itself exited 127 because
`/etc/bash_logout` referenced unset `__ETC_BASHLOGOUT_SOURCED` under `set -u`.
This separate teardown result is preserved in `wrapper-exit.txt`; no capture
was retried. All frozen files remain under
`/tmp/gpui-hummingbird-audio-evidence/sol-progress-freeze` and individual run
logs under `/tmp/gpui-hummingbird-audio-evidence/sol-progress-capture`.

After capture, a separate test-only successor adds the exact changed
44100 -> 11025 300/75 unit to both independent unmodified Rubato oracle arrays.
The core checks every f64 sample, partial/zero tails, channel identity and zero
allocations/frees. The whole pipeline checks all four channel maps, packet
splits, source joins, 31-frame backpressure, delay and final frame count. Both
extended tests pass; their complete logs are retained here. Production code and
the clock test are unchanged after capture.

Remaining integration gaps: v2 pipeline timings are unrun, four v1 pathological
processing comparisons remain unresolved due to the original baseline tail
failure, exact-source native application clients remain pending, some valid
rational rate pairs are unsupported, CPAL hardware is unavailable, and the
UI-authorized EOF handoff cannot guarantee gapless playback during arbitrary
UI stalls. The prior pipeline-only wins are not end-to-end audio measurements.
