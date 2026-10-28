# Component boundary storage and identity qualification

Executed library source is `88e68054ba637e1a840d1311b56bfa53fa74544f`, based on the
qualified [text and preorder composition](../frontier-text-integration/README.md).
The final handoff corrects two full-line comments; all other 2,776 guarded build
and Hummingbird inputs match the executed source byte-for-byte.
[The equivalence receipt](production-equivalence.json) records both comments and hashes.

A component's projection-check route is needed only during admission. Once every
boundary on a visual root validates, the existing sparse boundary allocation
stores its innermost scope instead of the checked route. Its remaining boundary
chain drops iteratively. On the measured x86_64 build, the state enum stays 16
bytes, the boundary 24 bytes and its optional owner eight bytes; ordinary element
and retained-node headers do not grow. Validation still precedes retained-node migration. No dependency or
unsafe code is added.

This removes `component_scopes: Vec<u32>` entirely. Only actual boundary nodes
retain a scope for identity qualification. If their scope changes, their identity
is reminted. Unkeyed, keyed-list and keyed-row descendant matching includes the
parent identity, so descendants cannot cross that changed root. Copying the
ancestor's scope into every ordinary node is unnecessary.

This identity guard is not a lexical handler-dispatch context. Existing typed
handler adapters remain: a child attached after `Component::view` can have a
different model owner from its visual parent. The sparse-handler and lexical
routing investigations are separate, unadopted work.

## Measured costs

The same public fixture runs in distinct frozen baseline and candidate ELFs.
All **120 semantic JSON, hit and RGBA artifacts match exactly**. Every cold
description removes one allocation and `4*N` requested bytes: four at one node,
128 at 32, and 40,000 at 10,000. Two list re-descriptions remove two allocations
and 80,000 requested bytes in the 10,000-node case. Published visible rows can be
fewer than the admitted list description; the ledger charges the actual latter.

Whole-region retained and peak bytes are unchanged except the three-node list's
warm peak, which drops 12 bytes. These are requested-allocation results, not RSS
or speed measurements. See [all cohorts](allocations.json).

The seven-library inventory is **34,697 shipping code lines**, including library
build scripts, excluding tests, comments and blanks: **+17** over the previous
Main composition. Existing EcoVec dependency costs remain unchanged.
[Syn/Tokei inventory](core-lines.json.gz).

## Qualification

- `88e680`: 700 passed across 68 frozen GPUI executables, 36 existing ignores;
  strict all-target native/GPU Clippy, 28 GPUI doctests and 190 scalar tests pass.
- Actual private-X11 GPU paint, pointer/actions/resize/inspector and AT-SPI
  rounded-clip/acknowledgement tests pass, including DPR 1.25 and negative origin.
- Hummingbird's standalone locked offline default-feature suite passes 70 tests
  in 18 frozen executables, two existing ignores. This adds no audio-device or
  full-player qualification.
- Generated WGSL and all eight SPIR-V modules match the final
  executed native ELF; the modules validate for Vulkan 1.0. WGSL remains 18,995
  bytes with SHA256 `ea6e71d3da2bdb23d4971a14f0f55db389dbb45f9b2e9c05c85d4dc6363eb4d1`.
- Each build/execution gate rechecks 2,056 tracked build inputs; Hummingbird gates
  recheck 2,777. Compilers and tests finish before any worktree mutation. Changed
  first-party packages are cleaned before cross-source target reuse.

Counts overlap. The predecessor `82be9d7` separately passes 699 tests, strict
checks, 28 doctests and 189 scalar tests before the boundary-only refinement.
Its frozen evidence remains in the archive.

The new shared-root test changes the inner component owner while retaining its
outer component and visual shape. A deliberate mutant
`c9617ea5c103a56fcce0c310a0392e749b1ae834` keeps the outer scope instead. Exactly
one test enters and fails: an old target incorrectly returns a committed action
instead of `StaleTarget`. Source guards and ELF hashes match before/after, the
mutant ELF is retained externally, and the qualified source is restored with all
2,056 hashes verified. A separate public case checks unchanged-owner identity,
unkeyed/keyed descendant retirement and checked-failure recovery.

[Qualification summary](qualification.json), [compact archive](qualification-logs.tar.gz)
and [verified receipt](archive-receipt.json) preserve commands, guards, Cargo JSON,
logs, executable identities, public outputs and shader artifacts. Frozen ELF
payloads remain at their recorded external paths; they are not repository data.
The early layout probe's missing-`cc` setup failure and corrected explicit
linker attempt are retained. No startup, display-latency or hardware-GPU win is
claimed. Software Vulkan establishes functional behavior here.
