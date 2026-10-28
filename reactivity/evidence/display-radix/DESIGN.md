# COW directory model under implementation

Node/resource directories each have32 root words and32 entries per leaf. A leaf
entry is `(payload byte offset, count/length)`, so fixed path copies are128 root
bytes and256 leaf bytes per changed group. Only delta keys are examined. Nodes
and resources have separate directories; an ordinary paint delta examines zero
resource entries. A frame root is64 bytes and retains the directory roots.
Every immutable graph edge owns a counted reference in the fence heap.

The admitted domain is1024 pages of32 records. These bounds are explicit, not a
claim of arbitrary-size constant work. A tiny raw root can point straight at one
page and omit the node directory; conversion visits current pages and charges
that work. Resource paths remain explicit. CPU current maps mutate in place;
no publication takes a whole-map snapshot. Retiring a replaced root may visit
its fixed fanout and changed paths; all reference operations count.

The current implementation is not yet tested. The combined renderer/public
size sweep, stale authority buffer, resource/pixel oracles and mutants are still
being implemented. Prior57ccf254 and36f700a734 results remain unchanged.

One follow-up risk is already visible in the design: page compression amplifies
a four-byte hot paint edit into a page rewrite plus path copies. Existing GPUI
finish_color_slot already records a precise shared paint-slot transition. A
future separate comparison should preserve a small versioned hot-parameter
column beside compressed cold records, instead of assuming every hot field
belongs inside the compressed page. No benefit or implementation is claimed yet.

Initial combined gate implements point sizes1/9/32/256/1024, twelve ordinary
public paint edits each, real8x8 image replacement behind an overlapping rect,
rectangular viewport clipping, and root-addressed captured glyph byte audits.
Public geometry is admitted once; image replacement uses a separate restricted
resource/support adapter. The renderer does not support general glyph blending,
filters, transformed clipping, alpha, or noninteger edges. The97-node move is a
model structural case with the independent full painter, not a generic public
structural journal. Candidate rejected-request handling in this cohort is the
publication model's no-change path; actual GPUI failed preparation remains open.

A shared8-byte authority buffer is staged before current submissions. Deferred
older work still audits its old immutable bytes but skips image mutation. This
is one ordered queue with overlapping lifetimes, not concurrent hardware queues.
GPU audit outputs/list arguments and full oracles are diagnostic cost categories;
production publication/root paths never enumerate those lists. Pixel scanning
still visits every live record for each damaged pixel and is charged O(N*area).
