# GPUI AccessKit Unix lifecycle patch

Upstream: `accesskit_unix 0.24.0`, crates.io checksum
`202f24df034a7476d07b7f74284de84f6d62aabd858dbe7ee9cad3b7ad6f8f9d`;
AccessKit commit `ce8164ba92995cfa86005b6259115e08c8244253`, `adapters/unix`.
The registry source is copied with its source copyright notices; the two license
files are copied from that upstream commit's repository root. The package's
existing async-io executor and public API are retained. Workspace use remains
behind the existing Unix AccessKit dependency configuration.

The second precise seam is `accesskit_atspi_common 0.21.0`, checksum
`52c182f9c282ac9c5638d876d551d15e5f7d397ec263349a0c6a2b61595dd5e4`,
from the same VCS commit's `adapters/atspi-common`. Its notices/licenses are
preserved too. Both vendored packages are excluded workspace members and remain
behind the existing Unix backend configuration.

The owner monitor subscribes to the filtered `org.a11y.Bus` NameOwnerChanged
signal before querying the owner. It reconciles overlapping/queued notifications
with a fresh bus snapshot, and pins each property stream and GetAddress call to
that unique owner. It keeps listening when the service is initially absent, and
retires adapters on owner replacement even when both owners report enabled.
There is no monitor task/channel, per-node field, or per-event epoch.

Stage 2 retires the existing FIFO with one worker-only `Fence`: drop the old
Bus, deactivate every Active/Pending state under its existing mutex, append the
fence, then consume through it while processing Add/Remove and dropping obsolete
interface/cache/tree events. Only then may a replacement Bus activate adapters.
Synchronous callback sends and AdapterImpl destruction finish under those mutexes.
Remove explicitly retires its state before releasing the worker's Arc, so the
caller's delayed final Arc drop cannot enqueue behind the fence. Destroy keeps
upstream's no-deactivation-notification behavior.

The removed adapter is found by linear position, preserving existing vector
order. IDs are assigned before Add enqueue and concurrent callers can enqueue
out of ID order; upstream's binary search could otherwise miss a removal. This
is a separate control-lookup correction, with an independent regression.

The common AppContext has the same append-versus-binary-search mismatch, including
when Pending adapters complete initial trees in reverse order. Its private
`adapter_index` now returns `Option<usize>` from linear position; removal and
native parent/cache indices use that position. Appending and desktop-child order
are preserved. This adds no mutex, field, cache, tree, or allocation. Actual
Adapter/PlatformRoot tests show native parent/cache ordinals and removal for
IDs 9, 3, 7; registry common fails both the ordinal and removed-child assertions.

The monitor also handles a lost-and-reacquired unique owner (A/B/A) even if its
fresh snapshot is unchanged. Recoverable property/proxy failures retire the
status stream while keeping the name monitor alive for another owner. An invalid
status service is not polled for repair within that same owner.

Session-bus initial connection failure/disconnection recovery remains a separate,
open gate: the existing OnceLock worker still does not reconnect. Object-server
actions bypass the callback queue; fencing is not action revocation. An actual
PlatformNode test holds an action in flight, retires callbacks, and confirms that
the action can complete afterward. GPUI's activation/owner/Target authority
checks remain required. No concurrent blocked D-Bus-dispatch cancellation is
claimed.

The real provider regression uses the actual Unix Adapter and Consumer against
an isolated dbus-daemon and a minimal protocol service/registry. It reads the
native Accessible tree and invokes actual Action.DoAction. Its blocked-worker
schedule queues 1,024 obsolete node registrations/cache
additions before replacement, keeps the old unique owner alive, tests Pending
and transient Add/Remove, and proves every obsolete interface absent on the new
provider. It also checks a forced B/A/B owner cycle and failed Status/GetAll owner
followed by a healthy one. It forces reverse Pending completion, reactivates
those adapters, races four public Adapter creators, reactivates all four, and
checks exact native desktop children/GetIndexInParent after tagged removal and
destroy. The primary fixture asserts seven activations, six deactivations, and
seven real actions. Queue tests independently enforce empty old backlog,
Active/Pending update races, delayed Arc retirement, and controls after Fence.

The separate GPUI ignored test
`native::accessibility::linux_tests::native_atspi_late_service_owner_replacement_and_destroy`
uses actual NativeHost/NativeAdapter on X11 with a minimal private service/registry
fixture. It performs semantic rename, Unicode EditableText and acknowledged
Action/UI changes, disable/re-enable, live enabled-owner replacement with full
tree recovery, stale-owner suppression, and NativeAdapter destroy. The existing
real AT-SPI2 launcher/registry Todo proof also passes. These are not evidence of
screen-reader spoken output.

Run from `reactivity`; the excluded packages carry the workspace-pinned
standalone locks for reproducible provider tests:

```sh
CARGO_TARGET_DIR=/tmp/accesskit-lifecycle-target CARGO_BUILD_JOBS=2 \
  cargo test --offline --manifest-path vendor/accesskit_unix/Cargo.toml \
  -- --nocapture
CARGO_TARGET_DIR=/tmp/accesskit-lifecycle-target CARGO_BUILD_JOBS=2 \
  cargo test --offline --manifest-path vendor/accesskit_atspi_common/Cargo.toml
```

Source/design audits read before implementation:
`21b1eaf4e8` (`docs/accessibility-generation-channel-audit-luna.md` and its probe),
`4f38c939c6` (`docs/accessibility-native-activation-luna.md` and late-activation
monitor prototype). Production base: `859274504e`. This slice makes no timing,
RSS/PSS, startup-memory, or accessibility opt-out claim.

The default x86_64 layout is unchanged by Fence: Message72, AdapterState88,
Callback8 and AdapterEntry48 bytes (stage1/stage2 logs). There is no additional
channel, event epoch, node field or retained Consumer/tree cache. The monitor adds one
filtered D-Bus owner subscription and its zbus stream/proxy state; those global
allocations and cold owner-name copies are not claimed free or measured here.
A transition adds one existing-channel queue entry and O(backlog) drain work.

The source-isolated monitor-only blocked-backlog control passes its recorded
async-io schedule; it is deliberately retained as a non-discriminating control.
The queue tests supply the direct fence invariants. The isolated monitor-only
owner-cycle fixture fails waiting for activation 4, while the corrected source
passes. Control Cargo package IDs are distinct from the candidate: earlier
shared-ID controls reused an incompatible cached product and are retained only
as explicitly inadmissible logs. The first rapid-cycle test
failure was a fixture bug: zbus's convenience RequestName can return a cached
AlreadyOwner before NameLost is processed. The corrected fixture uses raw
DBus.RequestName and asserts the authoritative owner before releasing the gate.
The instrumented failure trace is retained under evidence/accesskit-lifecycle.

Separate stream-end follow-up: `next_status_change` clears the owning Option
when its property stream ends, so the existing false wake retires once and the
next poll parks. zbus5.19 only returns stream end when caching is disabled;
default cached peer/cache-task disappearance does not terminate PropertyStream.
The real uncached-proxy helper/no-spin/late-owner regression is deliberately
separate from the actual Adapter protocol and earlier NativeAdapter proof.
See `stream-parking-*` evidence; d5fc source pins and gates remain preserved.
