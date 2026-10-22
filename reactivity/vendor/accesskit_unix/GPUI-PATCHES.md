# GPUI AccessKit Unix lifecycle patch

Upstream: `accesskit_unix 0.24.0`, crates.io checksum
`202f24df034a7476d07b7f74284de84f6d62aabd858dbe7ee9cad3b7ad6f8f9d`;
AccessKit commit `ce8164ba92995cfa86005b6259115e08c8244253`, `adapters/unix`.
The registry source is copied with its source copyright notices; the two license
files are copied from that upstream commit's repository root. The package's
existing async-io executor and public API are retained. Workspace use remains
behind the existing Unix AccessKit dependency configuration.

The owner monitor subscribes to the filtered `org.a11y.Bus` NameOwnerChanged
signal before querying the owner. It reconciles overlapping/queued notifications
with a fresh bus snapshot, and pins each property stream and GetAddress call to
that unique owner. It keeps listening when the service is initially absent, and
retires adapters on owner replacement even when both owners report enabled.
There is no monitor task/channel, per-node field, or per-event epoch.

Stage 1 is not sufficient for production adoption of active replacement: queued
old callbacks must also be retired before constructing the next AT-SPI Bus.
Session-bus connection failure/disconnection recovery is a separate gate.
Object-server actions bypass the callback queue; monitor retirement is not action
revocation. GPUI's own activation/owner/Target authority checks remain required.

The real provider regression uses the actual Unix Adapter and Consumer against
an isolated dbus-daemon and a minimal protocol service/registry. It reads the
native Accessible tree and invokes actual Action.DoAction. It is not the GPUI
NativeAdapter/window test and is not evidence of screen-reader output.

Run from `reactivity`, with the workspace-pinned lock copied to the excluded
vendor package before the first test build:

```sh
CARGO_TARGET_DIR=/tmp/accesskit-lifecycle-target CARGO_BUILD_JOBS=2 \
  cargo test --offline --manifest-path vendor/accesskit_unix/Cargo.toml \
  --test service_lifecycle -- --nocapture
```

Source/design audits read before implementation:
`21b1eaf4e8` (`docs/accessibility-generation-channel-audit-luna.md` and its probe),
`4f38c939c6` (`docs/accessibility-native-activation-luna.md` and late-activation
monitor prototype). Production base: `859274504e`. This slice makes no timing,
RSS/PSS, startup-memory, or accessibility opt-out claim.
