# Route density control, not a shipping thin owner

The exact c717 source probe counts live optional handler slots and recursively
visits concrete route payloads. It compiles candidate layout mirrors: Node 40→32,
Handler 16→8, El 176→168 and Draft 152→144 on this x86_64 build. Candidate rows are
layout mirrors, not an implemented runtime. Ordinary method items already have
zero-size captures and allocate no Box payload. Captured usize routes grow their
modeled request 8→16 bytes; component wrapper shrinkage offsets its new header.
Workspace has 32 nodes, 7 click slots and 14 nested route objects. Its route payload
request model grows 616→656 bytes. No global allocation interception or allocator
usable-size measurement was performed, and these figures are not total-memory,
RSS, dispatch or startup results. The extra probe vtable method invalidates its
binary for dispatch/code-size comparison.

report.md retains the frozen research report unchanged, including its original
temporary source links. probe.patch plus the untracked example sources reconstruct
the instrumentation over c717. Exact full modified sources are preserved; large
ones are gzip-compressed. original-files.json records their original hashes.
Published/draft/old overlap and live El counts are recorded separately; they are
not added into a fictional peak. The library alternatives and ownership/arena
tradeoffs retain primary source links in the report.

The shipping GPUI crate still forbids unsafe code. Any custom thin-owner proposal
needs an explicit, narrowly justified policy change or a safe abstraction; no
such change is made by this census. The earlier standalone feasibility harness
is not shipping code or a soundness proof; root review identified missing
constructor lifetime and auto-trait parity checks for its successor. Miri was
unavailable. Keep these constraints alongside any future prototype's byte wins.
