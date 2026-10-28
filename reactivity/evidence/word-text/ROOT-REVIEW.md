# One-word short-text experiment, unadopted

Frozen source 3d6bbcde4b67b9e99fe35b23db3bf216a79835f8 stores nonempty
short UTF-8 inside a one-word handle and keeps ArcStr for longer strings and
its immortal empty value. The constructor fixture removes short allocations
while retaining the existing long allocation formula and one-word Option
niche. Three normal tests and genuine-nightly strict checks pass.

All six Miri runs pass with strict provenance and symbolic alignment: x86_64,
32-bit i686 and big-endian s390x, each under Stacked and Tree Borrows. Each
run executes two ownership/content/thread tests; the allocation-counter test
is explicitly excluded under Miri. Separate frozen negative sources fail for
their intended reasons: missing a heap clone lease produces a use-after-free;
dereferencing the inline encoded address produces a no-provenance reference.
The working source remains unchanged. Raw commands, complete diagnostics,
source guards, exact negative patches and tool hashes are retained.

This is not yet a portable production representation. Independent Luna review
identifies a missing guarantee that a pointer object's bytes reproduce its
encoded integer on every target. It needs an audited target gate/fallback or
a different representation. It also misses ArcStr's heap clone-equality
shortcut. Neither blocker is waived because the modeled targets pass Miri.

The cited review compares cold-string 0.5.0's similar one-word owner, varint
lengths and smaller long header. Those are source-derived hypotheses, not
measured whole-application gains; that library uses a similar pointer-byte
technique. In the actual browser constructor, SharedText accounts for only
28 retained requests, while text planning dominates transient requests. No
runtime speed, application memory reduction or RSS result follows here.

The official Miri component archive is SHA-verified; its two executables keep
byte-identical text sections after Nix interpreter/RPATH adaptation. Two local
tool setup errors precede execution and remain in support logs. Compiler,
Miri binaries and distribution archives stay external. This experiment adds
no dependency or unsafe code to the shipping library.
