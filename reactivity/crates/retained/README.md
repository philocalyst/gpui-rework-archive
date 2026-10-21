# Exact cold tile checkpoints

`gpui_retained` is a dependency-free byte codec for cold RGBA8 checkpoints. It
does not compress the renderer's hot contiguous output, reduce upload bytes, or
interpret color profiles. A caller-supplied 16-byte format identity must cover
channel order, alpha convention, and color encoding. Equal byte values under
different identities are incompatible. Fully transparent hidden RGB survives.

Each 16×16 tile, including packed partial edges, selects the smallest applicable
record: Raw, Solid, or up-to-16-color PaletteRuns. Raw wins ties. An in-memory
`Delta<'base>` may instead copy the same-position tile after **complete byte
comparison** with its borrowed `Independent` base. No hashes decide equality;
no Delta can be a base. The borrow keeps the exact immutable base alive, and the
storage ledger charges all its bytes. The crate exposes no external copy-record
parser or serialized delta: claimed IDs/digests would not prove base identity.

```rust
use gpui_retained::{FormatIdentity, Independent, Limits, Surface};
let surface = Surface {
    width: 16, height: 16, format: FormatIdentity(*b"my-rgba8-format1"),
};
let limits = Limits { max_pixels: 1024, max_encoded_bytes: 8192 };
let rgba = vec![0; 16 * 16 * 4];
let base = Independent::encode(surface, &rgba, limits)?;
let parsed = Independent::parse(base.as_bytes().into(), limits)?;
let delta = base.delta(surface, &rgba, limits)?;
let mut tile = [0; 1024];
delta.decode_tile(0, &mut tile)?;
assert_eq!(tile.as_slice(), rgba);
# Ok::<(), gpui_retained::Error>(())
```

Release the original raw image if storage savings are the objective. A retained
raw render surface plus a checkpoint costs both. `storage()` includes requested
stream allocation, header, directory, records, object headers, and a Delta's
complete base. It excludes allocator bookkeeping/rounding and other CPU/GPU
surfaces. There are no per-tile allocations. Encoding performs two passes through
one shared record selector: the first counts exact chosen sizes and checks the
encoded-byte budget before allocating; the second writes the exactly reserved
output. Immutable inputs and an immutable direct base make selection identical
across passes. There is one output allocation, no raw-sized temporary heap
reservation, and no final resize. Decoding and parsing an already-owned stream
allocate nothing. Bounded tile/palette scratch remains on the stack.

`Limits` bounds source pixels and the new stream's encoded bytes. The format
additionally caps raw and encoded bounds below 4 GiB. Limits apply per stream;
Delta storage reports its base separately. Admission checks all dimensions,
arithmetic, offsets, tags, palette indexes, run lengths, and exact output sizes.
A valid checkpoint's private immutable bytes make later random tile reads
infallible after index/output-length checks. Failed decode admission leaves the
caller output unchanged. Parsing does not allocate from an attacker-declared
length. It validates the allocation the caller already owns.

The version-one independent stream is eight magic bytes `GPUTILE1`, little-endian
u32 width/height, 16 format-identity bytes, u32 tile count, and `tile_count + 1`
absolute u32 offsets. Records contain tag 0 + raw bytes, tag 1 + four solid bytes,
or tag 2 + u8 palette size + RGBA palette + `(u8 length_minus_one, u8 index)` run
pairs. Tile lengths come from the surface dimensions. Internal-only tag 3 has no
payload and means direct same-position base copy. Independent parsing rejects
tag 3 and all unknown tags. No Rust struct memory is serialized.

XOR, packed palette bits, moved-tile search, entropy coding, GPU compression, and
QOI are intentionally absent from this first implementation. They should earn
their code/branch cost against measured raw and current-mode baselines.

## Evidence

`tests/checkpoint.rs` compares reversed random-access decoding against raw pixels
over edge dimensions, solid/palette/gradient/noise classes, hidden transparent
RGB, immutable bases, mismatched identities, exact allocation peaks, budget
rejection before any allocation, malformed
offsets/runs/headers, every truncation of a palette checkpoint, and 10,000
deterministic mutated streams. Six tests pass in debug and release; strict
Clippy passes. The only dev dependency is `allocation-counter` 0.8.1, which
instruments the test/example allocator; runtime dependencies remain empty.

Reproduce in a workspace containing this crate:

```sh
cargo test -p gpui_retained
cargo clippy -p gpui_retained --all-targets -- -D warnings
cargo run -p gpui_retained --release --example checkpoint_bench
```

One shared cloud AMD Ryzen 7 3700X run with Rust 1.97.1, release defaults, 256×256 RGBA8,
256 tiles, 100 iterations, gives the following illustrative microbenchmark.
It measures CPU checkpoint work and random tile reads, not presentation latency.
The complete per-field measurements are in `evidence/checkpoint-bench.csv`.

| Corpus | Raw bytes | Independent resident bytes | Delta + full base bytes | Encode ns/tile | Decode ns/tile |
|---|---:|---:|---:|---:|---:|
| Flat | 262,144 | 2,360 | 3,717 | 315.9 | 21.2 |
| Two-color panels | 262,144 | 17,976 | 19,391 | 1,250.9 | 92.9 |
| Gradient | 262,144 | 263,480 | 265,848 | 274.5 | 17.3 |
| Noise | 262,144 | 263,480 | 265,848 | 272.7 | 17.2 |

The delta changes one pixel. Its comparison point is two independent raw
checkpoints (524,288 bytes), not one raw image. Independent gradient/noise expand
because the raw fallback still pays the tile directory and record tags. Raw
clone cost was 19–29 ns/tile and raw tile reads about 18 ns/tile. Encoding buys
cold retained bytes for compressible data at a CPU cost; this run provides no
general speedup claim and no evidence about real text/photo/HDR corpora.

The previous single-pass experiment reserved the raw fallback bound and shrank
the finished stream. The default now prioritizes exact heap use and admission
before allocation. Both runs used the same fixtures/compiler/shared CPU; timings
are illustrative sequential runs, not controlled paired latency measurements.
The old complete measurements remain in `evidence/checkpoint-bench-single-pass.csv`.

| Corpus | Old encode ns/tile | Two-pass encode ns/tile | Old encoder peak bytes | Two-pass encoder peak bytes |
|---|---:|---:|---:|---:|
| Flat | 154.7 | 315.9 | 265,808 | 2,344 |
| Two-color panels | 686.9 | 1,250.9 | 281,424 | 17,960 |
| Gradient | 177.1 | 274.5 | 263,464 | 263,464 |
| Noise | 172.4 | 272.7 | 263,464 | 263,464 |

The new peaks equal the encoded stream length. Resident object headers are
additional and included in the first table. Input pixels and an existing base
were allocated before encoder measurement and remain separately charged. Delta
encoding also visits its immutable base twice; for these fixtures it changed
from about 88–155 to 191–333 ns/tile. The compressed byte format and final
checkpoint sizes are unchanged.
