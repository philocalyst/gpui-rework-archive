# Integrated native accessibility lifecycle

Reviewed source chain `c20728a9f0`, `d5fc64a872`, `9c447ad078`, integrated on
`c36685f68a` with the source-owned color bank and text-selection geometry.
Existing evidence in the parent directory retains its original source pins,
including excluded shared-target controls and the nondiscriminating backlog
schedule. This directory records checks on the actual combined source.

The Unix adapter observes the exact unique status owner, subscribes before its
initial snapshot, retires old producers under their existing mutexes, and drains
old FIFO payloads through one worker fence. Control Add/Remove messages preserve
their order. Stream termination retires once and then parks. Adapter lookup
preserves activation/desktop append order even when concurrent creation or
pending activation reorders numerical IDs; no sorted-ID premise remains.

Actual integration gates pass: fourteen Unix units and one real Adapter/D-Bus
protocol test, two common adapter-order tests, twenty-six GPUI accessibility
projection/authority tests (five manual/host cases ignored), strict accessible
GPUI all-target Clippy, and the actual native late-service/replacement/destroy
test. The latter uses a private session bus and owned Xvfb `:120`, verifies
EditableText/actions and the replacement provider tree, ignores stale old-owner
properties, and observes native destruction removing its window. The display
was stopped after the test. These are protocol/ownership gates, not spoken
screen-reader or physical display tests.

No extra generation queue, per-node epoch, tree cache, state mutex or adapter
header is introduced by the patches. The cold owner subscription and zbus state
are separately real costs; no RSS, startup or latency win is claimed. Initial
session-bus failure/disconnection recovery remains open in the inherited
OnceLock worker. Object-server actions bypass the callback FIFO and still
require the GPUI owner's current target validation.

Both dependencies are complete vendored archives with original licensing,
package/VCS checksums, standalone locks and documented local patches. Their
source counts remain charged to vendor. The original `Cargo.toml.orig` trailing
blank line is preserved rather than changing that archive artifact for a
whitespace-only diff check. Apple/Windows compile checks belong to the later
combined platform gate and are not inferred from these Linux runs.
