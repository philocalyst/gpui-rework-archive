# Inspect the linked consumer before claiming a codegen win

A rejected sample-constructor experiment illustrates the boundary. Standalone
`cargo rustc --lib -- --emit=asm` initially showed an OutputEncoder render-band
body reserving 140,216 stack bytes and copying an approximately 69 KiB initialized
temporary. Making the constructor const and using an inline const initializer
reduced that emitted body's reservation to 72,664 B. An `inline(always)` annotation
alone had not removed the apparent temporary.

The normal linked release example already had a 72,664 B reservation before
either change. Its optimizer had eliminated the temporary without the proposed
source annotation. The experimental linked executable reserved 72,680 B,
16 B more. Both prologues additionally push the same six saved registers.
These are one function/monomorphization's explicit stack reservations, not
complete thread stack usage, retained heap or window RSS.

| Linked artifact | SHA-256 | Explicit reservation |
| --- | --- | ---: |
| Original GlyphAxis `parallel` example | `82c181f621d86cffdcb1bed1d74133e9dd65e5cbcbd2b14d139257989c9274fe` | 72,664 B |
| Temporary const-constructor variant | `d083f454576106ea509f8e3492df4fc0fbc641cc35e21d48304cfe8abe0e1429` | 72,680 B |

The original artifact is the candidate independently pinned in the
[GlyphAxis controls](../crates/canvas/evidence/glyph-axis/README.md). The temporary
variant changed only `Samples::new` to const and its call to an inline const
initializer in the isolated axis worktree. Both changes were reverted. Debug
sample tests and the release parallel suite passed, but correctness did not
establish a useful optimization. No timing or memory saving is attributed to
this experiment.

[Original prologue](../evidence/codegen-samples/original.txt) and
[experimental prologue](../evidence/codegen-samples/const-initializer.txt) retain
the actual linked addresses/instructions. GNU objdump 2.46 was used against the
release executables, rather than inferring final behavior from the standalone
library assembly. For each later experiment, pin the source, executable and
actual caller/callee path; verify activation before timing. A Cargo `Fresh`
message or an existing root rlib filename does not establish which variant a
separate consumer linked.
