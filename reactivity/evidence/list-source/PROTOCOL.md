Controlled list offset prerequisite, registered before implementation.
Base41acc60740f4fef358ee4b8a8a1f0fa6caacc307. Unique local/list-source worktree
/home/user/gpui-list-source-lab and target /home/user/gpui-list-source-target.
Reference ZGX remains a3678578980ef239058c557338ef9c544d356b0c. No speed verdict
in this feature slice; native matching and architecture timings remain later.

Chosen additive API: uniform_list(...).scroll_offset(&Signal<f64>), registered
with existing Sources, like other borrowed operands. Resolve exact identity and
component-qualified field during borrowed description. Retain only FieldId,
not a source/model pointer. The source is authoritative absolute requested
position in controlled mode; viewport clamps it without mutating during shared
reads. Uncontrolled lists retain keyed-anchor behavior. Wheel/public scroll
writes the actual clamped offset through the registered exclusive source before
normal Question refresh/owner repair/publication. External offset edits must
invalidate list realization even for Sources::direct with no text/style sinks.

Use a closed source offset writer, separate from text parsing. Existing Field
and ComponentSchema routes validate projectors; Any downcast to Signal<f64> is
safe and exact. A validation-only phase checks write agreement without changing
Signal revision. No new unsafe, Rc/Cell/RefCell, root sharing or mutable read
projectors. This supersedes the earlier optional Handler-route proposal: borrowed
Signal discovery already supplies component/source identity and avoids storing
another model callback per list. Charge its extra cold vtable entries/code.

Place overscan/map/optional borrowed offset together in optional boxed ListOptions.
This avoids inflating every cold ElementExtra for each list feature, restoring
its prior56B maximum. Charge the extra allocation for customized lists and all
retained ListState/ViewportState/transient plan costs. No packing of f64 metrics.

Direct wheel/offset/index requests have known final geometry; gather source edits,
validate them before writes, then apply one coherent source operation and ordinary
publication. Nested viewports and shared source fields have ordered last-write
semantics. Key lookup outside retained rows still needs the borrowed ItemSource;
if it requires an initial description to resolve the key, keep it unpublished,
charge the extra description and then repair against committed source. Never
publish an intermediate old-model/new-offset combination. Errors after any applied
prefix follow existing owner fault/logical-revocation rules. All existing scroll
entry points must obey controlled writeback, including index/key/scroll-into-view.

Qualification: ordinary public tests for direct registered offset, no fanout,
contained source, unregistered/aliased/wrong-projector operands; NaN/Inf/large/
fractional/clamped requests; source->scroll->timer coherence, shared fields and
nested wheel, key/anchor distinction, old P and failed newer/older ACK, removal/
replacement and no stale binding mutation; complete pixels vs fresh windows.
Actual native wheel + ACK and accessibility checks, inherited native scripts,
full default/X11 GPUI+Canvas and strict Clippy. Fresh missing-offset-dependency
mutant must fail public state/image oracle. Freeze before builds; all-input guards,
pinned nightly2026-10-23/content fingerprints, preserve every failed attempt.
Inventory shipping code, dependency/vendor/shader changes, ELF/function/stack,
headers and representative complete allocation costs separately. Keep>=8GiB free.
Native lab integration will then use lazy keyed100K rows, overscan2 and real offset
round-trip. Matching wheel28, deferred controls, quality and profiles remain
separate named gates; no benchmark-specific native injection or reduced work.

Before full qualification, direct source routing uses a closed Owner fanout
marker installed after complete sink admission. All sinks for a controlled-offset
source already require owner realization; redundant sparse destinations are not
retained. This avoids scanning all lists on unrelated source updates. Wheel
control detection inspects only its ordered ancestor movement plan and allocates
no movement vector if no controlled list is affected. No global runtime flag.
