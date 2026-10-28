# Release layout and accessor review

Builds completed with `cargo 1.97.1 (c980f4866 2026-06-30)` and
`rustc 1.97.1 (8bab26f4f 2026-07-14)`, LLVM 22.1.6, host
`x86_64-unknown-linux-gnu`, release profile, `x11-minimal`, separate empty
target directories. The command used `cargo test --no-run`; neither executable
has run the phase probe.

| Tree | Test executable SHA-256 | Bytes |
| --- | --- | ---: |
| Parent `f01947e…` | `c582e1faf306fa550f1e21bee1e71eadd7ae0aa74e7ed8f0face8b7d56cf0222` | 27,294,328 |
| Counted candidate | `4e7632ad0b6ac283ceeb375f74035d32c6040198d14ffe9768bc51dc79c3ccd8` | 27,199,632 |

The executable-size difference is not attributable to palette representation:
the candidate also carries its added unit tests, and these are test binaries.
No code-size claim follows from these sizes.

`assembly-parent-read.txt` and `assembly-candidate-read.txt` disassemble the
same `#[inline(never)] palette_read_probe` over `Styles::get`. The shared-lane
path loads the same one-byte style selector and then multiplies it by the
entry stride: parent `imul $0x58` (88-byte `Style`), candidate `imul $0x5c`
(92-byte `Style + u32`). Both then load the same style words at offsets
`0x10` and `0x18`. The candidate read path does not load the new count at
entry offset `0x58`; it adds no refcount or atomic operation to warm reads.
The dense path remains 88-byte stride. Because the palette is capped at 32
entries, the added retained payload is bounded to 128 bytes, though a single
palette lookup still uses the wider stride.

The candidate `Styles::set` disassembly contains plain `decl`/`cmp`/`mov`
operations at entry offset `0x58`; it contains no `lock` prefix, `xadd`, or
`cmpxchg`. This is consistent with the implementation's owner-exclusive
`&mut Styles` authority. It is not a lock-free or cross-thread counter.
`palette_set_probe` is a tail jump to `Styles::set` in both binaries.

The emitted getter loop is very large (1,068 disassembly lines) because the
compiler unrolls the constant 16-read-round call shape. The relevant repeated
selector/stride loads are visible near the start; do not interpret the whole
symbol's instruction count as accessor cost. The only current assembly
conclusion is that the shared candidate lookup has the same load sequence,
with stride constant 92 in place of 88, and does not read `users`. Runtime
phase measurements are still pending a quiet capture window.

Commands and hashes are in `README.md`, `run-paired.sh`, and
`raw/{parent,candidate}.binary.txt`. The full focused disassemblies are saved
beside this note. The probe intentionally uses `Win::recording` and
`x11-minimal`; this diagnoses retained-style work and is not a native-window,
active-accessibility, or end-to-end application benchmark.
