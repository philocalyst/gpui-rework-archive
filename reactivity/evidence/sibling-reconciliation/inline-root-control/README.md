# Unadopted empty/root sibling control

Shipping control `926105a025dcae6b543bef9d56ee958f8504e244` is based on
`89aeabd53942c3a4643bcb6fd978e6a24703f6d2`. It uses an Empty/Root/Indexed enum
to avoid scratch allocation for the empty helper and the one-node public owner.
The helper remains 24 bytes. The exact standalone source patch and public fixture
are included; no dependency or retained field changes.

The actual tiny owner with three updates falls from 30 allocation requests / 2820
requested bytes to 27 / 2772; peak remains 832 bytes and retained bytes are
unchanged. Every larger owner row is identical. Private map/allocator tests,
the public owner check, default all-target strict checks and formatting pass.
These scoped checks are not a broad native/foreign qualification.

Seven alternating process pairs per cohort, pinned to CPU0 with the other
workers held, retain all 56 samples. Median paired time changes are -3.41% tiny,
+0.34% flat1K, +0.83% nested1K and +0.31% flat16K. The runner prints a different
statistic, the ratio of cohort medians: -2.81%, -0.01%, +0.83% and +0.82%.
Both statistics and every paired delta are retained. Source and executable guards,
semantic assertions and process audits pass. Unrelated host activity remains
uncontrolled. No frame, startup, RSS or universal speed improvement is claimed.
The existing CSR producer is the baseline, not the older ordered-map baseline.

The source adds 11 core code lines, excluding tests/comments/blanks. Whole linked
.text grows 176 bytes, .rodata 16, .data.rel.ro 24 and .eh_frame 36. Selected
actual disassembly and section ledgers are preserved; no dynamic stack-peak
claim follows. The tiny allocation win does not justify silently adopting the
measured larger-owner losses. Main keeps the existing CSR implementation.
