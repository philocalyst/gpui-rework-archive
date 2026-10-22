AccessKit Unix lifecycle correctness slice

Base859274504e. Stage1c20728a9f0 vendors Unix0.24 and fixes late Status
service/unique-owner monitoring. Stage2 fences callback retirement and corrects
actual window lookup in Unix and common0.21. source-pins.json hashes final source,
locks, notices and the admitted control fixtures. UpstreamVCS for both packages:
ce8164ba92995cfa86005b6259115e08c8244253. Research inputs:21b1eaf4e8,4f38c939c6.

Final passing gates:
- common-candidate-tests.log:7unit +2actual Adapter/PlatformRoot parent/cache
  ordinal/removal regressions. Actual appended IDs9,3,7 keep ordinals0,1,2;
  removing9 leaves3,7 and releases that native tree.
- stage2-provider-and-fence.log:13unit +1real Unix Adapter/Consumer/private-D-Bus
  protocol proof. Late initial-true, native tree/actions/update, disable/re-enable,
  direct true/true owner replacement with old unique owner alive,1,024 obsolete
  registrations/cache adds queued behind a blocked worker, Pending and transient
  Add/Remove, old-owner suppression, blocked B/A/B, failed Status owner recovery,
  reverse Pending completion, concurrent public Adapter creators, reactivation,
  exact desktop child/parent indices after tagged removal, complete destroy.
  Primary adapter asserts7activations/6deactivations/7actual actions.
- gpui-x11-consumer.log:132passed,20ignored, including100,000-node complete
  Consumer oracle and GPUI authority/activation tests.
- gpui-native-lifecycle.log:actual X11 NativeHost/NativeAdapter, late initial-true,
  semantic rename, Unicode EditableText, acknowledged Action/UI, disable/re-enable,
  live enabled-owner replacement/full-tree recovery, stale properties, destroy.
- gpui-native-real-atspi.log:existing actual AT-SPI2 2.60.6 launcher/registry Todo
  proof; gpui-native-no-session.log:existing no-session presentation proof.
- common-clippy.log, vendor-clippy.log, gpui-clippy.log:PASS(-Dwarnings).
  vendor-tokio-check.log:existing alternate backend compiles. Affected package
  format logs pass. No executor swap or accessibility opt-out.
- workspace-headless.log:626passed,0failed,11ignored in105groups/doctests. This
  profile did not compile Unix/common; their later private lookup change affects
  no headless code. Native/Consumer gates above use final common-source pins.

Admitted source-isolated controls:
- upstream-late-regression.log:registry Unix0.24 fails initial late-service Embed
  using the stage1 fixture from c20728a9f0; expected cargo exit101.
- monitor-only-cycle-isolated.log:stage1 source with distinct Cargo package name
  accesskit_unix_monitor_control fails at activation4 after forced B/A/B;
  monitor-cycle-control.fixture.rs and monitor-control.Cargo.{toml,lock} are saved.
- monitor-only-backlog-isolated.log:the same stage1 monitor-only source PASSES the
  saved monitor-backlog-control.fixture.rs schedule. This is NON-DISCRIMINATING
  for Fence. The isolated queue tests establish the direct fence invariants.
- common-order-upstream-regression.log:registry common0.21 fails native ordinal
  (Defunct) and removed-child assertions using the saved upstream fixture/manifest
  and lock. It is independent of the lifecycle monitor and memory measurements.

Inadmissible/history:
- inadmissible-shared-id-*.log:local source copies reused the candidate package
  ID/target, producing identical artifact names and an invalid cached-product
  control. They are retained for audit and excluded from correctness conclusions.
  Distinct package IDs in the admitted controls resolve this ambiguity.
- fixture-name-cache-failure.log:temporary owner diagnostics show the first
  rapid-cycle fixture stopped at A. zbus RequestName returned cached AlreadyOwner
  before NameLost ran. The corrected fixture uses raw DBus.RequestName and asserts
  authoritative owner B before releasing the worker. Production diagnostics removed.
- stage2-fence-unit.log/stage2-protocol.log/native-build.log are earlier checkpoint
  logs, not final coverage claims; final logs are identified above.
- workspace-fmt.log.gz:full fmt --all traverses200pre-existing unformatted files
  in vendor/cephal70 and vendor/winit130. Both trees are unchanged from859;
  workspace-fmt-preexisting.json pins representative bytes. Affected packages pass.

Structural boundary/open gates:
Default x86_64 sizes remain Message72/AdapterState88/Callback8/AdapterEntry48B.
Fence adds one original-channel entry per retirement and O(backlog) drain work.
No generation channel/word, per-node field, extra retained Consumer/tree cache,
mutex/header or executor was added. The owner subscription and its global zbus
state/cold name copies are not claimed free or measured. Common lookup is linear
in window count while preserving append/desktop order.

Object-server actions bypass the callback FIFO. The actual PlatformNode in-flight
unit test completes after retirement; this is not action cancellation or a proof
of concurrent blocked D-Bus dispatcher cancellation. GPUI authority checks remain.
SessionBus initial connection failure/disconnect/reconnect remains OPEN: the
OnceLock worker does not reconnect. Native no-session presentation does not prove
recovery. Apple/Windows compile gates belong to root integration; spoken AT output
was not tested. No timing/RSS/PSS/startup reduction claim is made in this slice.

Reproduce controls in temporary directories outside any workspace patch. The
monitor control sources come from git archive c20728a9f0, with only the saved
manifest's package-name change and chosen saved fixture. Keep its package ID
separate from the candidate. The common/upstream-Unix controls use registry-only
dependencies from their saved manifests/locks. Build jobs2, own CARGO_TARGET_DIR;
see toolchain.txt. Native gates used coordinated :94 and private D-Bus sessions.

Separate stream-end parking follow-up after d5fc64a872:
next_status_change now clears its owned Option on stream end. The first end
retires once through the existing false wake; later polls are Pending, leaving
the independent owner monitor live. In zbus5.19 PropertyStream::poll_next returns
None only when the proxy has CacheProperties::No. The default cached proxy keeps
Some cache permanently: peer/cache-task termination does not end this stream.
This is defensive stream-end handling, not an observed default owner-loss spin.

stream-parking-provider.log reruns the final Unix units and actual Adapter
protocol on the follow-up source. Its added helper test uses a real private
D-Bus connection and real CacheProperties::No StatusProxy, observes None, one
actual Pending-state retirement,16 Pending polls/no extra FIFO entries, then a
real late NameOwnerChanged and a new cached StatusProxy initial true. This test
proves the monitor/helper path, not a default cached stream ending on disconnect
or an additional NativeAdapter execution. stream-parking-clippy.log and
stream-parking-fmt.log cover final vendor source. stream-parking-units.log keeps
an initial compile-only fixture type mismatch, fixed before final gates.
source-pins.json preserves the d5fc source/gates; stream-parking-source-pins.json
pins the separate follow-up source. Earlier native/workspace gates remain d5fc
results and are not silently relabelled as a new full campaign.
