# Frozen A cost comparison implementation

Follow the timing gate preregistered at32878eff7a835238e60a8af44ffb51af90f4fc5f
in display-hot/PROTOCOL.md. Correctness-qualified A isd40381fa539f2b58b400785b386fe8477bba0954;
frozen A model/shader5d4a977f0e51a8350d7e333da2ee98f5464b022c, radix control
bb21d11455b6a03d134f99377c5a16b983fac27f. No alteration to A or traversal here.

Before timings, explicitly select tiny fallback by the already recorded storage
comparison:1/9 nodes use raw pages with direct roots;32/256/1024 use compression.
Both primary control and A use that same choice. A separate serial uncompressed
control is recorded at every size. No threshold selection after timing.

Six rounds, primary order control/hot/hot/control/control/hot first (ABBAAB).
Within each round, sizes1/9/32/256/1024 and scenes sparse/overlap are fixed; the
raw control follows the primary pair. Each case is a fresh owner + resident GPU
worker process with64 warmups and512 samples. No concurrent build/test/analysis
or cleanup. Expected public fixture pixels/preflight readback are outside timed
intervals; actual GPU completion remains inside every sample. Stop round-trip
only after the owner consumes completion and releases semantic/fenced leases.

Initial prototype endpoint starts from already admitted draw records. Cold
construction includes representation construction, worker process/device/pipeline,
initial upload/render/completion. Public View description, Source dispatch and
initial adapter extraction are not timed. Steady-state endpoint starts at an
already registered binding patch and includes preparation, packing, JSON/pipe,
worker staging/encode/submit/completion, reply and owner acknowledgement. Report
that endpoint verbatim, never as GPUI application or display latency. Worker and
owner phase clocks are attribution within that measured interval, not additive
substitute endpoints. Record persistent arena capacity (including reserve), hot
capacity, pixel/argument/authority buffers, CPU model object graph and metadata.
Driver allocations and whole app memory remain unattributed; do not imply total
system allocation accounting. Dense-key48B/key loss comes from qualified A.

Timing gate unchanged: median per-round p95 hot/control<=0.95 on both256/1024
sparse cases; no>1.05 p95 regression for tiny1/9/32 with the selected fallback or
1024 overlap. Keep every sample/process including failures; no case retuning,
trimming, workload reduction, concurrent helpers or post-result fallback changes.
A failure is a cost rejection under this endpoint. B remains a separate next
branch with original record encoding; do not combine yet.
