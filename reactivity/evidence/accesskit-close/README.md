# Close-time accessibility cleanup

Closing one native window while another survives now retires every exposed
node's AT-SPI object interfaces and client-cache entries. The previous Drop
removed the desktop child and AppContext entry, so Cache.GetItems correctly
shrunk from five items to three, but both closed object paths still advertised
AT-SPI interfaces. The original public Adapter executable actually fails the
unchanged eight-second interface-removal bound. It stops before the signal
assertion; missing signals are source-proven, not a separately executed negative.

The fix reuses the existing Defunct → CacheRemoved → unregister sequence for
normal removal and current-tree postorder cleanup. It includes the root for
every role, preserves exactly one unconditional desktop ChildRemoved, and ends
the tree read guard before AppContext removal. Hidden descendants stay omitted;
flattened and selected nodes, changed trees, and non-Window roots are tested.
It adds no node ledger, adapter field, cache or synchronization primitive.
PlatformNode already holds a Weak context: this fixes stale object-server and
client-cache state, not a demonstrated strong consumer-tree leak.

[Exact source equivalence](source-equivalence.json) connects sealed Sol
`b5360a6b7ad6fa3032370c9ca4cbfa2331a095d2` to Root composition
`34e9290b7ecaf882b069a048bae4a7160c66d489` over Main's text/navigation/GPU source.
[Functional results](functional-results.json) distinguish their scopes:

- Producer: common 11 unit and two adapter-order tests; Unix default 14 units
  plus the real private-D-Bus public Adapter protocol; Tokio six units plus that
  same protocol. Both closed paths lose interfaces, actual RemoveAccessible
  signals arrive in child/root order, and a surviving window's action works.
  Both valid runtime selections and common all-features strict checks pass.
- Root: 55 GPUI accessibility tests pass. Eight native-environment cases remain
  ignored in that ordinary run; two are then explicitly executed and pass on
  private X11/session buses: late-service/owner replacement/destruction and
  checkbox actions/state/events. Strict native all-target checks pass. All
  12,000 tracked-source guards match before and after each Root gate.

The original interface failure, earlier test-helper Tokio lint failure and
invalid dual-runtime all-features rejection are preserved. The helper now uses
the same non-Tokio test predicate as both its callers; no production helper,
lint exemption or test skip was introduced.

[The vendor inventory](vendor-lines.json) strips tests, comments and blanks:
**+10 production vendor lines**, with zero changes in the six core libraries,
whose independently counted total remains **31,813**. The full three-file patch
is +266/-13 physical lines, including tests/blanks. For N exposed nodes including
the root, close adds **3N terminal callbacks/messages**, plus the existing root
notification. Recursive traversal uses the current tree; no extra retained
storage is claimed. Retired service generations still do this work before the
existing fence discards their obsolete messages. No timing, startup, RSS or
whole-application performance claim follows.

[The reopened qualification archive](qualification.tar.gz) preserves producer
source controls, actual executables, Root's frozen native executable, raw logs,
source guards and drivers. [Its ledger](archive-members.json) verifies all 105
members and the complete archive. Native UIA/VoiceOver runtime coverage,
relationships, virtual-item realization, IME and session-bus reconnect remain
separate open work.
