# Canonical visual-line navigation and selection reuse

Main adopts the eight paths of producer
`1b261aec0553a2a54f502321e62b86ffe29fa63e` over Main `7e7e9548c2`.
[Root's source comparison](source-equivalence.json) proves all 343 crate Rust
files/manifests match the producer in the combined Hummingbird checkout
`962b1b78f9f2b0b2547ff99db53bfab7c103fab0`; application paths remain the separately
qualified Browser/Files/fresh-schema source.

Up/Down, their Shift variants, and physical visual-line Home/End use the same
canonical line/caret map as hit testing. Affinity retains ownership at wraps;
preferred local x survives short lines and Shift→ordinary movement. Explicit
selection, including an unchanged selection, pointer/horizontal motion, edits
and source rebinding reset preferred x. Vertical movement starts at focus on all
platforms; native macOS range-origin policy remains adapter work. The public key
API and native Winit dispatcher share publication/stale-geometry barriers.

Navigation borrows the existing geometry without a new index or allocation.
For same-source selection changes, the exact identity/field/source-lease proof
allows updating the existing cold logical owner in place. This skips the owned
text lease clone and old-owner drop. Source switches still acquire their proper
lease; static empty leases already skip atomics independently of this change.

## Qualification

The [producer report](qualification.json) records:

- 30 public selection/geometry/compound cases; 11 Canvas selection cases,
  including zero-allocation queries over wraps, bidi, CRLF and empty lines.
- Native-feature library: 220 passed, 30 ignored; ordinary release selection:
  20 passed. These feature totals overlap.
- One explicitly executed real X11 dispatcher test with an acknowledged surface
  at every Up/Down/Shift/Home/End stage; private Xvfb and D-Bus children reaped.
- Strict all-target checks for GPUI/Canvas/GPU with x11, wayland, parallel and
  vulkan-tests; touched-file formatting.
- An actual production-kernel fault reverses Down: ordinary `Win::key` returns
  byte 8 instead of 12 and the executed case fails exit 101. Exact restoration
  and the unchanged candidate executable pass all 20 selection cases.

Root separately builds and runs the frozen public selection executable (20
passed) and passes strict native all-target Hummingbird checking on the composed
source. Before/after tracked-source and executable hashes match. Producer and
Root gates retain their original source pins; this is source equivalence, not
relabelling every old execution as Main.

The [verified archive](qualification.tar.gz) includes raw commands, source/ELF
guards, test output, assembly and actual layout bills. Its member hashes are in
[archive-members.json](archive-members.json); executable bytes remain external
with original identities. The initial broad build cancellation, new native-test
scheduling failure and typed-test compile failure remain explicitly recorded.
They are not passed runs. The fault setup's wrong-manifest error is also retained
and excluded from the actual production-fault proof.

## Cost

Syn inventory/Tokei counts core 31,616→31,745 non-test, non-comment lines, +129.
LogicalSelection and its Option grow 40→48 bytes; the single cold Editing owner
grows 88→96. Runtime, Metadata, Node and TextSite sizes are unchanged.

Matched ordinary release `Win<Page>::key` grows 3,399→3,532 code bytes, with its
376-byte explicit frame unchanged. The new line helper is 838 code bytes with
a 168-byte entry frame. These are function observations, not whole-app or full
call-chain bounds. A separate debug warm-reuse control shrinks `set_selection`
1,785→1,615 code bytes and its frame 552→424; its successful branch skips the
owned lease increment/decrement. No timing, allocator usable-size, RSS or native
foreign-platform execution claim follows from these bills.

Clipboard, IME/preedit, autoscroll, native macOS range-origin policy and complete
editor/browser parity remain. Linux X11 execution does not establish UIA or
VoiceOver runtime coverage.
