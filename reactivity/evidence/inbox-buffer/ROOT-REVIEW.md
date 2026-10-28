# Historical one-buffer slice: independently checked, unadopted

Root verified review commit 581640fee40ee6b16cc296548f666de8a9750443 and
reopened all 128 manifest payloads, all 9 external binary/disassembly files,
17 matching guard pairs and the complete recorded test totals. Both source
and test patches match their exact Git comparisons. Copies were hashed again.
The producer README and manifests are preserved without modification.

This safe representation removes the separate staging payload buffer. One
preallocated shared VecDeque owns accepted values; the unique Inbox stores
only a frozen-prefix count and terminal state. Capacity includes the frozen
backlog. The owner pops before calling user code, and all lanes revoke before
accepted retired payloads are dropped. It retains blocking mutex operations;
neither lock-free progress nor lower latency follows from the storage change.

The matched Rust 1.97 default C=8 fixture requests 832→144 bytes, 3→2
allocations; whole-owner retained requests fall 6396→5708 bytes. The final
linked text falls 9,184 bytes after a static lane capability avoids hiding
ordinary coarse identity across an outlined call. The rejected initial
formulation grew linked text by 4,144 bytes and its delivery frame by 912;
that adverse control remains intact. The final delivery callee still grows
37 bytes and its fixed frame 80 bytes; core grows 12 lines relative to f9.

Default tests pass 573 across 61 harnesses (10 ignored); native-feature tests
pass 638 across 61 harnesses (35 ignored). Strict checks, Apple/Windows
compilation and the recorded three actual native entrypoints pass. The first
native replay fails at Xvfb readiness before a GPUI executable runs; its
separate successful replay retains the original watchdogs. Native debug
memory uses the separately guarded f9 binary and is not a matched native
release code comparison. Cross checks use explicitly scoped build-std
bootstrap; host checks do not.

These measurements compare the one-buffer slice with typed-delivery f9,
not current Main and not the composed genuine-nightly kernel. That combined
source is being qualified separately, including ordinary and typed callers.
No production source or compiler selection is adopted with this archive.
