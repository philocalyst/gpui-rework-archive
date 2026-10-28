# Controlled two-state checkbox

Shipping source is frozen at `ddb0649e94e46a61690a9f1863558d776c7bcf31`.
Qualification tree `a2fc724bd49c025a85d0d21a8cc90854d0d9cc2c` adds only an explicit
`let _ = black_box(control)` discard in the allocation test; all library and
example source remains byte-for-byte the shipping pin. This slice is based on
`f9feff848210e37b87caf8e6729476335e457af3` in an isolated worktree;
shader/text integration and the main checkout are independent.

`checkbox(label, checked).on_click(Model::toggle)` is an ordinary `El` leaf.
The model owns the boolean, the existing typed route performs activation, and
`Part::checked()` borrows the acknowledged presentation. The constructor assigns
`Role::CheckBox` and the native projection assigns AccessKit `CheckBox` plus
`Toggled::False/True` without an application role/state annotation. The visual
label uses ordinary layout and style; no native widget or check-mark painter is
introduced. The inspector example shows one control with visible state/detail
feedback and a normal model method.

The private `NodeKind::CheckBox(bool)` uses the existing enum carrier; Content
explicitly encodes both values using four low bits in its existing u32. There is
no state sidecar, additional node field, action bit, generic AccessKit setter or
application/platform binding. Mount matching normalizes the checkbox's bool
out of the site kind; the next Content and Presented still retain the exact
value. State-only changes mark the candidate dirty without changing identity or
requiring new layout. Existing sparse native comparison sees the kind change.
Real role/site replacement and existing shape/source quarantine policies still
revoke authority.

Pointer release, focused Space, focused Enter and native assistive Click invoke
the same installed route. Enter deliberately retains the framework's current
non-input activation policy. A callback which leaves the model boolean unchanged
does not manufacture a checked transition. A checkbox without a route exposes
its label and checked state, advertises no Activate/Focus/Blur and is skipped by
Tab. This represents neither disabled nor read-only semantics. Provide a
nonempty label or explicit name; the constructor accepts empty text without
inventing a name from the state. Mixed state, radio groups and native switch
roles are outside this bounded control.

Public `Role` is an exhaustive enum: adding `CheckBox` requires downstream
exhaustive matches to add a case. This is an explicit API compatibility change
in the current unpublished 0.1 crate. Semantic JSON adds `checked` only for this
role, through the existing borrowed serializer/schema; unrelated roles retain
their existing fields. Input string values and selection remain independent.

The control is still a text leaf. Arbitrary application child trees are rejected
by the existing child admission assertion. Native projection preserves its
label and synthetic Label/TextRun document through the existing text cohort;
those synthetic children do not gain a click action. State bytes are read from
P during unacknowledged or failed candidates, and the source-qualified typed
route still owns mutation. No unsafe code is introduced.

## Qualification and cost

The complete default GPUI campaign passes 487 tests in 49 harness groups,
including nine ordinary checkbox API tests, with eight existing ignored tests.
The native X11 library campaign passes 188 tests with 25 ignored. The inspector
example model ledger passes separately. Strict native all-target Clippy passes
with `-D warnings`. Apple/MSVC all-target desktop+parallel compilation uses the
real AccessKit platform adapters and Rust build-std; raw logs record each result.

The Consumer oracle compares the sparse checked transition with a fresh full
tree in both directions, including every node payload, parent/child ID and
focus. A focus-only update sends no replacement nodes. Failed C leaves the old
projection unchanged. Ordinary tests additionally cover no-op callbacks,
press/release exactly once, Space/Enter, Tab/reverse-Tab, independent component
receivers, same-target/focus retention over four ACK cycles, removed/replaced/
foreign targets, failed L quarantine, and ACK of a coherent older candidate
after a newer failed C. Header and Content tests exercise all admitted text
indices and image resources with both sampling modes. Arbitrary checkbox
children fail the existing leaf assertion.

The final copied native test executable is SHA-256
`e5f0a964a1e62529b0efbc3d498133047077bff92269761061d636a2c7e25095`.
Its source is the exact frozen library/native-test source at ddb0649; the a2fc724
integration-test-only fix changes none of its inputs. An actual X11 host using
ReferenceCpu presentation and the real AccessKit Unix provider passed the
private D-Bus client scenario: protocol CheckBox role 7, initial unchecked,
DoAction(0), checked=true plus StateChanged:checked=1, DoAction(0), checked=false
plus StateChanged:checked=0. Both actions called the typed method exactly once.
The private status/registry transport fixture comes from the existing lifecycle
proof. It supplies service discovery, while provider/action/state/event methods,
model and native presentations remain real. Xvfb :157 was retired afterward.

No timing, startup, RSS, throughput, screen-reader speech or native Apple/Windows
execution claim is made. Standard harness/build durations remain in raw logs
and are not used as performance evidence. The initially assumed two-byte
NodeKind assertion failed: this pinned compiler actually keeps the bool-bearing
enum at one byte. That raw failure is retained. An inactive test ingress also
rejected a queued Click until the fixture invoked the ordinary activation
callback; that setup was corrected before freeze. The first strict gate found
the must-use test warning fixed by a2fc724; its raw failure log is retained.

All 29 measured size/alignment records match baseline f9feff with the archived
**test-only** ledger patch, using the same `--features x11 --lib` profile and
Rust 1.97.1 on x86_64 Linux. This is an observed target/compiler layout, not a
Rust ABI promise. Content remains 4B, Node/Option<Node> 40B, Presented 80B,
Prepared 40B, El/Option<El> 176B, Draft/Option<Draft> 152B, NodeKind/Option<NodeKind> 1B,
Role/Option<Role> 1B, Part 16B and Actions 1B. Ordinal keys remain 24B and keyed
row/list keys 32B. Test-enabled native records remain AccessKit Node 128B,
Command 32B, Queued 48B, State/Option<State> 56B, Bridge 208B and Cohort 64B. Native
record sizes carrying test counters are explicitly labeled in raw records.
Equal Vec<Presented> capacity 100,000 therefore has the same 8,000,000B payload;
this says nothing about total process memory. The inspector's ordinary model
adds a bool and grows from 4B to 8B (alignment 4), separately from framework nodes.
A literal checkbox with a zero-capture method route performs zero constructor
allocations in the public allocation-counter test.

One control's Rust AccessKit projection fixture is explicitly charged below.
The sparse oracle asks for complete text children (`new_ids=None`), so its
allocation count includes a repeated TextRun. Production Bridge uses its
source-qualified cohort delta/new-ID range, which can omit unchanged TextRuns.
These are fixture requested-byte costs, not platform allocator retention or a
measured delta against another control:

| Projection | Output native nodes | Allocations | Requested bytes | Held result bytes | Peak bytes |
| --- | ---: | ---: | ---: | ---: | ---: |
| Complete oracle | 4 | 23 | 2,241 | 1,817 | 1,936 |
| Sparse oracle with text children | 3 | 17 | 1,802 | 1,474 | 1,602 |

The build-script-aware Syn/Tokei shipping counter gives 29,366→29,404 for the six
first-party libraries: **+38 non-test shipping code lines**, with the existing 13
build-script lines unchanged. The ordinary inspector example is separately
62→86 shipping lines (**+24**). All 12 changed Rust files together add 903 code
lines, of which **841 are tests, fixtures and ledgers**. No vendor, dependency,
source-generator or manifest/lock changes are required. Data/archive files and
existing shared counting tools are outside that shipping count and are pinned.
The extra raw bill was captured at ddb0649; a2fc724 replaces one existing code
line and leaves every count unchanged. The official full shipping counter was
repeated on a2fc724.

To integrate, review/cherry-pick ddb0649 then a2fc724 and this evidence commit
onto the f9feff ancestor (resolve any later independent text work normally).
There is no extra standalone patch or lockfile requirement. Main and the frozen
shader worktree/archive were not edited by this slice.

Reproduce with `/tmp/gpui-native-env.sh`, `CARGO_BUILD_JOBS=2`, an isolated
`CARGO_TARGET_DIR`, and the commands archived in raw metadata. The actual native
ignored test requires a private X11 display and `dbus-run-session` initially
lacking org.a11y.Bus. Apple/MSVC gates compile and do not execute their native
accessibility stacks.
