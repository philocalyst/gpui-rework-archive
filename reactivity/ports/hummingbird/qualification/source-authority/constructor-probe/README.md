# Actual constructor bill

The exact same public constructor probe as sealed914 runs four cohorts (cold0,
warm1–3). Identical probe source is guarded in manifest.json. Current exits0.
Every cohort adds one spawn allocation/current/peak request and64 spawn bytes
(total/current/peak). Connected is identical. Mounted request counts match and
all three mounted byte counters fall8. Library560→552, Questions600→592 and
Win664→656; these overlapping inline views must not be summed three times.
Event96/Selection32/SourceError64/AudioError32 are unchanged.

Thus each cohort adds one requested allocation and56 total requested bytes
across the measured constructor phases. Retained calling-thread heap plus the
final Win inline header grows48 bytes: cold100600→100648, warm96280→96328.
Phase peaks are reported separately, not summed into an invented simultaneous
peak: spawn+64, connected0, mounted−8 bytes. The new Producer requests56 bytes;
the observed spawn bill includes another8 bytes beyond that allocation. No
hidden whole-owner memory improvement is claimed. The primitive authority
callback itself requests zero allocations in its separate unit control.

The probe opens no AudioService or output. It excludes allocations on the
worker thread, SQLite C, OS/device, RSS and actual audio pipeline retention.
No timing is measured. The actual incremental standalone debug compile reports
2m15s in its log; this path-dependent build is not a cold-build benchmark.
