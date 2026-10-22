# GPU state identity: retained layout control

This bounded control replaces the numeric context certificate with a clone of
an already owned bind-group-layout handle. It adds no public WGPU API. The
existing numeric owner and its 8-byte process static remain frozen in
`evidence/gpu-shared-owner` at a30a175fb6 (source 1b200d66cf); this directory does
not retag that evidence. No CPU-time or complete process/GPU-memory claim.

## Pins and decision

- Numeric source: f0d8d8f2188413531541feddafcfeaad757937ec, a fixture-only child
  of 1b200d66cfc28a76e4c61b3d154a26055ae908a0. The added public lifetime fixture
  has 37 physical Rust lines and changes no shipping source.
- Lease source: 15c30db1a91c343f69cd0642b36095807d3e16cb.
- Original extraction/source evidence: 7f83fbc110, f8e90a1b10, 8cdeee1abe,
  72b8c1c3ce, 1b200d66cf, a30a175fb6, preserved in the previous worktree.
- `unbuilt-special-method-control.patch.gz` is a discarded, unqualified alternative
  with an explicit public handle-identity method. It was saved before replacing
  it with the smaller private equality-key fix; no result is attributed to it.

The lease is simpler authority/lifetime bookkeeping: no generator, exhaustion
path or additional context identifier. It saves 8 bytes per context and removes
8 bytes of process static. It is not a broad memory improvement: after a context
is dropped ahead of its states, it retains an extra native layout and measured
1,924 Rust-requested bytes across 10 allocations until the last state drops.
Normal live-context allocations/request counts are unchanged. Keep that tradeoff
explicit when choosing the implementation.

## Identity and lifecycle

Core layout Eq/Ord/Hash previously used a backend-local ID alone. Two independent
actual Vulkan Instances in the new regression both produced BindGroupLayoutId
(1,1). The new private key is `(existing ContextWgpuCore, registered layout ID)`;
ContextWgpuCore already compares/orders/hashes its retained Global Arc address.
No other WGPU handle's equality changes. WebGPU and Custom implementations remain
unchanged, and this introduces no new backend dispatch, trait or unsafe pointer.

The public layout clone shares the Core handle Arc. Final CoreBindGroupLayout
Drop alone calls `Global::bind_group_layout_drop`, which removes that registry
entry; `Registry::remove` frees its ID after removing storage, and reuse increments
the epoch. A clone therefore keeps both Global address and registered ID alive.
The Core backend's existing Arc equality fast path first compares the same retained
handle pointers; correct state/context calls stop there without a refcount update.

Every context must continue to create its own inferred layout. A future explicit
layout must likewise be fresh per context, even on the same device, and must never
be shared across formats/contexts. No context constructor accepts an external
layout. Tests reject same-device/same-format, same-device/different-format, and
foreign-device contexts before frame/slot mutation. State replacement and context
first drop preserve the original authority; another context never adopts it.

On native Core, one state construction performs one Arc clone and state drop one
release, versus a numeric copy previously. The public clone/nonfinal-drop fixture
records zero Rust allocations for each, not zero CPU cost. No clone occurs per
draw. Other backend header/refcount costs are not measured here. Actual device
loss remains the documented live-context precondition from the numeric control;
the destroyed-device state probe still exhibits inherited WGPU validation behavior,
not a blanket recoverable-Err guarantee.

## Matched measurements

Fresh-process runs use the unchanged full public fixture, same actual device,
1/2/8 complete windows, equal scene/font inputs and Vec reservation order. All
pixel hashes agree across owned/shared/numeric/lease. See `summary-table.md` and
raw records. Current-thread Rust request/net/peak accounting includes all owner
headers, window vectors, contexts, state buffers, warmed packet, images, atlas,
textures and views. Inputs/Instance/Adapter are excluded equally. Driver/C heap,
background allocations, GPU memory, full stack and RSS are not measured. Counts
feature is a separate build; its native object counters are not combined with the
default allocator capture. The inherited negative texture counter is not a total
residency measurement.

Native headers: Renderer 896→888, Context 56→48, State 840→840, layout certificate
8 bytes replaces the 8-byte numeric state slot, SlotGuard 48→48. Shared owner
80→72. The actual ordinary native ledger reports Renderer888, boxed Candidate1000
(previous1008), Message24 and Upgrade40 unchanged; no extra candidate allocation. Owned per-window vector entries save 8 bytes each. The standalone one-window
owner saves 8 bytes plus the separate 8-byte static, not an allocation or request.
Against the original pre-extraction 872-byte Renderer, the 888-byte owner still
costs 16 bytes more; this is not a first-window win from resource sharing.

Context-first drop uses an otherwise empty state and a matching explicit device
observer in both designs. Numeric context drop releases 364,648 bytes/905 net
allocations; lease releases 362,724/895. The difference releases on state drop
(1,557/34 versus 3,481/44). Both release native render pipeline 1→0, shader modules
3→2 and pipeline layouts 3→2; only the retained BGL differs (numeric 7→6, lease
7→7 until state drop). Final native counts then match. Thus the layout does not
keep the native render pipeline or shader alive; the extra retained CPU metadata
is still charged in full. Both drop phases make inherited teardown requests,
recorded rather than hidden in a header estimate.

Release ASM: render 9,317→9,346 bytes (+29), redraw 314→334 (+20); render stack
reservation remains 0x568. Owned forwarders still inline. The new identity check
has no atomic operation: a pointer comparison fast path precedes context+ID
fallback. The packet-release `lock decq` already present after that check remains
in both controls. Full entries and lifetime-main assembly are losslessly gzipped.
No speed improvement is inferred.

## Source cost and qualification

Syn test spans plus Tokei15 exclude known tests, comments and blank lines:
GPU shipping Rust 2,427→2,408 (−19); authored WGPU change +5 code lines, +7 physical
lines; combined shipping delta −14 code lines. WGPU is charged separately, with no
archive relocation credited as a reduction. Against the original pre-extraction
2,284 GPU lines, the final GPU subtotal remains +124 plus this +5 vendor delta,
not a claim that the whole shared-owner feature removes source. The adapted public
Vulkan regression file has 45 inserted and 1 removed physical line (net +44);
the fixture-only source adds 37.
Provenance and published archive checksums remain unmodified; GPUI-PATCHES.md
records the authored equality change. `source-lines.json` pins tools and scopes.

Passed: 44 actual Vulkan tests, 8 GPU units, 4 presentation tests, strict GPU and
fixture all-target Clippy. Apple/MSVC all-target desktop+parallel checks and the
ordinary native candidate header ledger are recorded in the qualification JSON.
No new public API, native admission policy, surface ownership or device-loss
callback ownership changes. Previous real native gates are preserved historical
controls; this slice does not retag them as new executions.

## Reproduce

Use a separate worktree for each source pin and target; preserve the numeric
binaries before changing source. Source `/tmp/gpui-native-env.sh`, keep
CARGO_BUILD_JOBS=2 and use the supplied native Vulkan loader/llvmpipe configuration.
From the repository root:

```sh
CARGO_TARGET_DIR=/tmp/identity-default cargo build --release --offline --locked \
  --manifest-path reactivity/benchmarks/gpu-owner/Cargo.toml --bins
# Fresh process for every case, n=1,2,8:
/tmp/identity-default/release/owned same-device "$n"
/tmp/identity-default/release/shared "$n"
/tmp/identity-default/release/layout-lifetime
/tmp/identity-default/release/lost-state
CARGO_TARGET_DIR=/tmp/identity-counts cargo build --release --offline --locked \
  --manifest-path reactivity/benchmarks/gpu-owner/Cargo.toml --bin layout-lifetime --features counts
/tmp/identity-counts/release/layout-lifetime
CARGO_TARGET_DIR=/tmp/identity-default cargo test --release --offline --locked \
  --manifest-path reactivity/Cargo.toml -p gpui_gpu --all-targets --features vulkan-tests -- --nocapture
CARGO_TARGET_DIR=/tmp/identity-default cargo clippy --release --offline --locked \
  --manifest-path reactivity/Cargo.toml -p gpui_gpu --all-targets --features vulkan-tests -- -D warnings
```

The Python scripts reproduce raw summaries, assembly and source accounting using
preserved binaries/tool paths. Source/binary/tool hashes and exact qualification
commands are beside them. The rejected-package-spelling log is an invocation
error retained as such, not a source failure or successful test run.
