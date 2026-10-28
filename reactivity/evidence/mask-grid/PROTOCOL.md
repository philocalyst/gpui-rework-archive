# Mask-scene spatial grid: preregistration

Mask-miss productionb817779c has exact GPU admissione97729cb and native support
audit2520aeec, but screen c8a65525 rejects stream .896043156 and mixed .915155878
versus .8. All64 work/cadence gates pass; no retry. About88% first-packet lowered
mask pixel references miss their glyph. This distinct combined trial tests
rejecting spatially irrelevant references before shader traversal.

Use8x8 bins only for scenes containing a mask, and only if the unpruned8x8
reference budget fits existing MAX_REFERENCES (4Mi). Otherwise retain16x16.
Preflight over existing group bounds; invalid/empty/out-of-viewport bounds choose
coarse and retain existing later validation. No workload-size tuning. Non-mask
scenes keep16x16. The fine grid has no more than four times the coarse references;
coarse fallback preserves all previously admitted scenes at the same reference
cap. Stats retain their meanings but actual tile/reference counts can change.
No changed scene limits, new storage fields, pipeline, dependency, unsafe or
application API. Set unused bit16 in existing global mode word to communicate
8x8 selection. Pass selected edge to private bin/count/coverage/visit functions;
replay retains existing global buffer. All16 pixel samples and mask-miss blend
arithmetic remain unchanged. Charge grid-selection pass, larger ranges/cursors,
CSR/upstream CPU work, upload, capacity, shader dispatch and code generation.

Before timing: full fresh GPU/canvas tests and strict Clippy; all336 unchanged
public mask-lattice images must equal pre-change oracle6faae98a. Only private
packet-index assertions and explicit public Stats expectations may adapt to
8x8 when a mask exists; no pixel fixture, tolerance or workload change. Add
focused grid-selection tests including mask/no-mask, budget boundary/fallback,
partial tiles and alternating fine/coarse replay. Bounded mutant ignores the
fine-grid flag in the shader while host publishes8x8; exact public output must
fail. Preserve all attempts and independent generated/embedded shader receipts.

Actual native audit: unchanged shader/workload,8 fixed3s processes initial0/190
x idle/scroll/stream/both,exact idle images. Report actual grid edge and decoded
planned sample sums. Every native packet must select8x8 and literal mask tiles.
First-packet planned work must be strictly less than the matching16x16 audit
2520aeec, with all frame/work semantics retained. Counts are diagnostic only.

Then fixed native64-process screen seed20261119: same qualified suffixbaseline
compiled2684821f,opt3/fatLTO/CGU1,nightly2026-10-23,X11:94,llvmpipe4,pinned font,
960x720,initial0,trace,8s,8 AB/BA pairs peridle/scroll/stream/both. Exact ingress
onlystream,owner otherwise.17 workload tests each and10 preflights. CPU interval
visible+1..6s with>=4.8s coverage. Active464–488updates,<=2 early ACK gaps>25ms,
zero later;idle0. Any failed work cell suppresses its mode. Pairedmedian ratios
<=.8 stream/mixed,<=1.05scroll;idleobservedCPU<=baseline,nozero ratio.10000 paired
bootstrap/type7,seed reset per mode. No retries/subsets/threshold changes.
Freeze clean source/scripts before observation; no builds/tests/edits/analysis
or cleanup during timing. Minimum8GiB free. All local.

A screen pass admits full configurations/native/offline and28-case4160-process
complete-cost matrix seed20261120,then new matched ZGX. No adoption without
all cost/allocation/correctness gates. Physical GPU,two hardwareclasses,scanout
and quality gates remain required; no hardwarecache-hit or async-runtime claim.
