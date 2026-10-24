# Packed tree links and typed child sizing

Qualified library source is `ce79d00fb004859994c8574254bbd091e964a2d4`, composed
against Main `f2874c35fc914e9002425112be5ebf8aa9717b16`. All 2,781 recorded
build and Hummingbird inputs match byte-for-byte. This follows the
[component boundary composition](../component-boundaries/README.md).

## Formulation

Ordinary nodes no longer pay for an absent click route. A safe `u64` packs three
bounded logical indices: parent, sibling ordinal and sparse handler slot, each
17 bits under the existing 100,000-node limit. Identity and component scope
retain their full domains; there is no pointer compression. On this x86_64 build,
`Node` and `Option<Node>` shrink from 40 to 24 bytes. A cold optional handler
owner adds eight bytes to the runtime; its allocation holds a 24-byte Vec header
and 16 bytes per actual route. Empty owners allocate neither. A warm nonempty
owner reuses the outer Box and exchanges the whole route vector, avoiding a
capacity ratchet. Existing lexical component-route adapters remain unchanged.

Typed `ChildSeq` families carry an advisory lower bound into the existing child
append operation. Tuple minima are const; options inspect presence; owned view
vectors expose their length; iterator lower bounds multiply the item minimum.
Saturating arithmetic cannot grant admission or semantic authority. A fresh child
vector reserves that bound exactly, without walking or rendering children twice.
Filtered iterators with a zero lower bound keep ordinary growth. This adds 38
shipping lines and no unsafe code, dependency, or element-header field.

Public component and property routes retain their admission and lifetime rules.
A temporarily taken property route keeps its membership bit; the closed exchange
restores the route before publication or focus dispatch. Scope-rejected routes
and replaced routes keep their prior destruction barriers. During unwinding,
newly built routes must drop before the remaining old cohort, in the same order
as the original node vectors. The first packed candidate violated that ordering;
the final source restores it and adds an ordinary public eight-event regression.

## Requested allocations and retained bytes

The isolated route payload change, for alignment at most eight, is
`8 - 16*N + (H > 0 ? 24 + 16*H : 0)` bytes, with exact-capacity node and handler
vectors. `N` is admitted nodes and `H` installed routes. A plain 4,097-node owner
retains 65,544 fewer bytes; one with 64 handlers retains 64,496 fewer. The true
one-node/one-handler and all-handler cases add 32 cold retained bytes and two
cold allocations; a warm nonempty exchange adds one allocation. Higher model
alignment can absorb header growth: measured alignment-64/256 cases differ.
These payload formulas are not whole-process memory measurements.

The public child declaration census compares source `0ba8a7b` with the final
source using separate frozen no-default-feature executables:

| Declaration | Before | After |
| --- | --- | --- |
| One child | 1 allocation, 704 requested bytes | 1 allocation, 176 bytes |
| Six-child tuple | 2 allocations, 2,112 bytes | 1 allocation, 1,056 bytes |
| 10,000 children, or 5,000 pairs | 13 allocations, 5,766,464 bytes | 1 allocation, 1,760,000 bytes |
| Chain of 4,096 | 4,096 allocations, 2,883,584 bytes | 4,096 allocations, 720,896 bytes |

All fourteen shapes have no measured allocation regression. The wide case's
retained capacity falls from 2,883,584 to 1,760,000 bytes, and peak from 4,325,376
to 1,760,000. Empty, borrowed-vector and unknown filtered-iterator cases retain
their documented behavior. See [the complete census](child-allocations.json).
A bounded mutant discards the lower bound: exactly one test enters and fails on
704 versus 176 requested bytes. The original 2,060 input hashes are restored.

The composed native-feature scene fixture compares against qualified source
`88e68054`. All **120 semantic JSON, hit and RGBA artifacts match exactly**.
Cold plain/wide/scroll 10,000-node descriptions remove 12 allocations and
4,166,632 requested bytes, retaining 159,992 fewer bytes; their measured peak
adds eight bytes. The 10,000-node list removes 3,679,640 cold requested bytes;
two warm list descriptions remove 7,359,296 requested bytes with unchanged
allocation count. [All eighteen cohorts](scene-allocations.json) retain peaks,
realized-node counts, executable identities and exact outputs.

Per-component lexical wrappers remain an unresolved cost: a depth-four,
10,000-handler fixture still builds 40,010 wrappers and requests 2,240,560 bytes.
The public child sizing removes geometric vector growth, not every child vector.

## Code, machine code and qualification

The seven-library inventory is **34,852 non-test, non-comment shipping lines**,
including 18 library build-script lines: **+155** over preceding Main. The
existing 50-line unsafe helper is charged once; this composition adds no unsafe
code or dependency. EcoVec still adds 2,315 separately charged dependency lines.
[Exact Syn/Tokei inventory](core-lines.json.gz).

Actual optimized headless SIMD Counter executables have identical stdout.
The final ELF grows by 928 bytes and `.text` by 1,440. The View body stays 1,049
bytes; `mount_lanes` changes 2,481 to 2,462, `present_walk` 23,172 to 23,204 and
`describe_inner` 33,920 to 34,507. From their actual prologues, the latter two
functions' own CFA costs change 4,032 to 4,016 and 2,352 to 2,432 bytes. These
are function-local costs, not maximum call-stack depth or timing results.
[Machine-code ledger](machine-code.json) and [large artifact hashes](external-artifacts.json).

- Final GPUI: **712 passed** across 70 frozen executables, 36 existing ignores.
- Strict all-target native/GPU Clippy and 28 GPUI doctests pass.
- No-default-feature lib/frontier/components: 194 passed, five existing ignores.
- Actual private-X11 GPU paint/inspector and AT-SPI clip/pointer/acknowledgement
  tests: two passed, including DPR 1.25 and negative screen origin.
- Hummingbird's standalone locked offline default suite: 70 passed across 18
  frozen executables, two existing ignores. Its lock remains `c6bef498a41a96ab23938f9025aa0ef0a63431b5`.
- Typed WGSL remains 18,995 bytes, SHA256
  `ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1`.
  All eight SPIR-V modules validate for Vulkan 1.0, and all generated shader bytes
  are verified inside the actual executed final native ELF.

Counts overlap; the broad count is GPUI only, not an added GPU-suite count.
Every gate records source, command, features, before/after guards and actual ELF
identity. Core gates check 2,060 inputs; Hummingbird checks 2,781. The isolated
route producer's broader suite and its allocation/slot/drop-order mutants are
preserved separately. This integration makes no hardware-GPU, startup, RSS,
click-latency, full-player, or whole-campaign performance claim.

Two optimized candidate captures were deliberately rejected before execution:
reused target artifacts were marked fresh despite changed source. The second
attempt's `cargo clean -p gpui` had omitted `--release` and removed no release
artifacts. The accepted third attempt cleans that profile explicitly and verifies
the GPUI library was rebuilt. Both rejected attempts remain in the archive.

[Qualification](qualification.json), [source hashes](qualified-inputs.json.gz),
[compact archive](qualification-logs.tar.gz), [member manifest](archive-manifest.json)
and [verified receipt](archive-receipt.json) preserve 905 evidence members, including
commands, failures, public outputs, shaders, mutants and focused disassembly.
Large executables/full disassemblies and the isolated producer capsule stay at
hash-identified external paths. No worktree was edited while its gates ran.
