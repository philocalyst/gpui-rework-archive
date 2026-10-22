# Exact property/description change accounting

Immutable base: `f0bd5335ae`.
Failing public control: `8475528f55cd34ead451b6600bdf5b6294e01e15`.
Shipping fix: `c3f7207eb578a0789d794bf3f16d5204c9fd245c`.
Final public tests: `568f42bc7e87c8118491fca3f2c4dba7e1178168`.
Worktree: `/root/gpui-property-change-union`.
Separate target: `/tmp/gpui-property-change-union-target`.

An Apply route can change a property with a no-op model reply. Its coarse
reconciliation compares the already-mutated style with the resolved override,
so it previously overwrote the property setter's changed_nodes1 with0. The
control independently fails both Width Set and Inherit, after checking actual
resolved values, S+1, one source operation and one preparation. `control.json`
records the source, fingerprint and frozen expected-failing executable/hash;
`control.log` preserves both failures.

The fix changes no public API. The canonical Style/Geometry mutation returns
an explicit boolean; the common logical mutation returns the changed existing
NonZero node identity. The admitted turn carries that single optional identity
on the stack through the same source/description barrier. The existing node
reconciliation consumes a surviving identity into node_changed, counting overlap
once. The existing old-node retirement loop consumes it when counting removal.
An unconsumed identity counts once after both loops: a previous site may have
been consumed and then rejected because its component scope changed. That old
identity and its fresh replacement are distinct destinations. This is an exact
union with description changes, not addition or max of two diagnostic counters.

The retirement scan borrows the existing vector, preserving Handler drop order.
No retained fields, count vector, index, scratch allocation, interior mutability,
new callback or duplicate reconciliation algorithm was added. Ordinary describe
callers keep the wrapper's None default. The public direct property setter uses
the same marker when virtual-list realization requires description.

Both success and error ordering are unchanged. A failed describe or preparation
drops the turn-local marker. Checked-description failure revokes old logical
targets; repair deliberately remounts identities and prunes their contributions.
A failed preparation instead preserves the accepted logical contribution and old
P/C authority until repair/ACK. The marker never transfers a contribution to a
fresh target or changes geometry epoch ownership.

The final public cases cover:

- Set/Inherit with a no-op reply;
- target text overlap counted once and a changed peer counted separately;
- removal, kind replacement and consumed-but-rejected component scope;
- radius and general affine Set/Inherit;
- rejected, equal, empty and foreign proposals after preceding changed turns;
- failed preparation followed by ordinary logical repair;
- failed checked description, fresh identity repair and stale original target;
- direct public setter through virtual-list realization.

`initial-fix.log`, `expanded.log` and `public.log` are exploratory pre-freeze
runs, not final source qualifications. The first used an extra forwarding
wrapper; the later runs precede the one-word retirement-drop-order correction.
Only the final guarded logs qualify the final pin. No native/cross/linked-cost
claims are inferred from this bounded default campaign; root runs the combined
native/desktop campaign after integration.

The c3/568 candidate passed524 default cases (8 ignored), all-target default
Clippy with warnings denied and GPUI formatting. The whole chain checked the
exact568 tracked bytes before and after. `c3-qualified.json` records the frozen
11-case executable, fingerprint and pinned source hashes; `c3-final-*.log` are
the raw logs. This remains a qualified control if a later retirement-accounting
formulation supersedes it.

`core.json` and `core-baseline.json` measure30390→30423 shipping code lines:
+33, including all build scripts. The complete immutable inventory confirms
+36 first-party non-test physical lines, +420 test physical lines and no other
non-test source additions. Code and physical line measures are distinct. JSON,
Markdown and raw logs add no executable source. No shipping type declarations
or retained headers changed; no zero-cost claim is made for the additional
turn-local parameter/checks.
