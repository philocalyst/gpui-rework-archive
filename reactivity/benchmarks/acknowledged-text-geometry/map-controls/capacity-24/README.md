# Capacity-only 24-byte caret-stop control

Source ca1b0b6f42c69eee6ec951d224a8b7aeeffdf897 starts from the separately
qualified consuming-break source/test pin 09680e2a313dbf6ecb25e92c8243cd7c2bb75ba3.
The sole production change calls shrink_to_fit on the completed caret Vec,
after all paragraphs and before immutable Arc publication. Stop fields, geometry
queries, source/affinity authority, admissions and runtime headers are unchanged.
No exact-capacity guarantee is added to a public API: these are the measured
allocator/Vec results. This isolates growth slack from field compression.

| ASCII 32 KiB, 33,513 stops | Growable 24 B | Trimmed 24 B |
|---|---:|---:|
| Stop capacity | 65,536 | 33,513 |
| Total geometry capacity bytes | 1,622,016 | 853,464 |
| Scoped retained bytes | 2,146,440 | 1,377,888 |
| Scoped allocations | 259 | 260 |
| Scoped requested bytes | 8,054,712 | 8,859,024 |
| Scoped peak live bytes | 7,001,412 | 7,001,412 |
| First-C owner retained bytes | 2,262,476 | 1,493,924 |
| Old-P/new-C additional retained bytes | 1,651,944 | 885,192 |
| Old-P/old-C/failed-L additional retained bytes | 1,655,160 | 883,872 |

The 768,552 B scoped retention reduction costs one additional reallocation and
804,312 requested bytes. It does not reduce the existing peak producer storage.
The old-C ACK still allocates zero and releases its exact frozen map epoch;
its release changes from 1,655,232 to 886,680 B. One-long-grapheme geometry
capacity drops 288→240 B; empty/short/wrapped results and every rejected/valid
source stage are present in raw logs, rather than extrapolated from ASCII.

This is a memory formulation control. Existing ordinary Canvas scoped/GPUI
epoch fixtures pass, with exact source/critical-file hashes and separately
frozen executable SHA-256 at /tmp/gpui-text-map-controls/capacity-24. The default
simd test profile is used; no full-suite/native/foreign-runtime or speedup claim
is attached. The next 12 B representation is a distinct source/target/control,
with a direct producer rectangle-bit oracle first pinned on this 24 B form.
The parent-owned intrinsic Min/Max map-suppression formulation is not included.
