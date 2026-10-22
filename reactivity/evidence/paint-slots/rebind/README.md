# Rebind source banks before exact Canvas color updates

Source `570b4d9274` is a separate correctness fix after the frozen refinement
`7687b32246` and its evidence. The review finding was reproduced against that
unchanged release rlib before production edits: a black bound panel followed by
`update(|_| {})` and `set(COLOR, WHITE)` reported WHITE and advanced S, while
Canvas pixels remained black. The failure occurred for an automatic owner, an
acknowledged recording owner, and an initial full candidate still pending.
`before-public-repro.rs/.txt` preserve the exact preliminary public probe.

Every coarse description constructs a fresh source-color bank. Its `canvas`
slot references are empty; equal effective styles do not establish authority
over retained complete Canvas commands. The fix marks a newly installed bound
bank dirty, forcing complete command preparation before a subsequent slot edit.
It transfers no handles and assumes no accidental equality of source/Canvas
indices. If preparation fails, dirty remains set and the preceding complete
Canvas remains independent; a later edit must repair the full commands.

The cost is deliberate: even an equal coarse update on a source-colored owner
performs a full paint walk and candidate rebuild. There is no new header,
allocation structure, reference count, or API. This is not a claim that equal
coarse descriptions retain the old slot optimization. Exact source edits after
successful rebuilding keep the shared-slot path.

The public regression covers four states: headless acknowledged, recording
acknowledged, initial full C pending, and a later color C pending. It checks a
fresh independently mounted WHITE pixel oracle, logical property and epochs,
frozen P rows until acknowledgement, a new complete token, one coarse paint
walk, and zero paint walks for the following exact edit. The pre-fix regression
fails at the explicit coarse-walk requirement; the independent preliminary
probe additionally demonstrates the stale pixels in all three initial modes.

The targeted public run passes 18 tests (1 new four-mode case, 5 paint-patch,
3 source-color/mask, and 9 presentation cases). Strict X11/Wayland all-target
Clippy also passes. These profiles overlap and documentation tests were not
rerun for this fix. The global formatting probe reports two inherited files
(`paint_slot_storage.rs` and native `paint_tests.rs`) as well as the then-new
regression; only the new regression was formatted. Frozen measurement sources
and unrelated native code were preserved. No formatting gate is claimed.

No performance timing has run. In particular, the coarse rebuild penalty has
not been hidden behind the earlier refinement's allocation results. The actual native Todo/paint-bank gate also passes on a private Xvfb `:111`
(1 test, 155 filtered), including SDR/HDR fresh GPU pixel oracles and all native
renderer policies. That server was stopped after the run.
