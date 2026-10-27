# Sparse text publication: local experiment, unadopted

Production candidate `d5848eb970`, full-recording control `75a9e2b06b`.
Preregistered at `97d8e632ad`; five interleaved process pairs per size.
The common base includes the separately unadopted retained-output experiment.
No original application API changes; additive Canvas run-slot functions only.

The candidate preserves ordinary layout computation. A single direct text edit
can replace its existing canonical run only if layout wrote no changed geometry,
the acknowledged scene is current, no candidate is outstanding, and every
admitted raster already has a live scene lease. Run length, common clip/color/
transform and painter-order addresses must match. Removing a resource's last use
falls back, preventing a growing historical resource dictionary. Pending text
and interaction geometry are patched into P only at its eligible ACK; failed
newer work does not destroy that eligible candidate. All other cases use the
complete walker. Accessibility projection is independently invalidated.

| Static labels | Median paired CPU ratio, candidate / full | Pair range |
| ---: | ---: | ---: |
| 0 | 1.013800 | 0.850498–1.156617 |
| 25 | 0.722583 | 0.562250–0.770963 |
| 100 | 0.444281 | 0.404693–0.479632 |
| 1000 | 0.063455 | 0.058296–0.074842 |
| 10000 | 0.007718 | 0.006711–0.008742 |

**Inconclusive admission:** the 1000-label target passes comfortably, but the
smallest no-regression cell is noisy. Do not call this experiment adopted.
These are complete source-to-canonical-recording-plus-ACK operations, not native
presentation or a ZGX ranking. Five sizes × five pairs × two variants × 2000
operations = 100000 measured updates; every 10-operation batch is preserved.
Cold construction, teardown, wall quantiles and process max RSS are retained in
raw CSV/log/time files, including losing cells. Profile: pinned nightly
2026-10-23, default release, same shared DejaVu Sans file. No CPU instruction
claim (perf unavailable). No hardware GPU or two-hardware-class evidence.

Full GPUI + Canvas: 958 passed, 13 ignored, 110 result groups. Native-feature
GPUI: 779 passed, 38 ignored, 74 groups. Strict release Clippy with X11 and all
targets passes. This is native-feature testing, not actual window execution.
The bounded mutant omits the layout-write certificate and fails exact pixels
when auto-width text moves its following sibling. Public tests cover Unicode,
length/resource fallbacks, unacknowledged/coalesced updates, failed newer work,
and preservation of the previous semantic sheet. A private assertion checks
that the sparse path actually ran; equivalent pixels alone had initially hidden
a whitespace-resource eligibility bug. Keep that diagnostic and failed attempt.

Shipping first-party core: 36488 lines versus 36191 (+297). No dependency or
vendor changes. Resource leases add a u32 use count (16-byte lease entries versus
8), runtime text state retains one optional patch box and marker, and each patch
allocates bounded temporary glyph/mask data. Exact owner allocation evidence is
in the subsequent text-session campaign; this dossier does not claim memory,
stack or binary-size improvement. Native/platform and full cost gates remain.

`raw/qualified/inputs.json` predates the whitespace correction; the final matching
receipt is `raw/whitespace-fix/inputs.json`, verified in `raw/guard-final.json`.
Source and mutant patches, full unsuccessful attempts, compiler records and
line inventory are retained. Run `python3 verify.py` here to independently
recompute every quantile and paired ratio and validate payload hashes.
