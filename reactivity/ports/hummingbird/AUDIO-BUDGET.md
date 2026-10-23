# Exact-unit audio ownership

This candidate is not ready for universal adoption. Quiet capture found a
changed-filter construction regression and four processing comparisons blocked
by the untouched baseline's tail failure. Functional and memory controls pass;
the incomplete performance result must remain separate.

The pipeline borrows its own accumulated planar input for a destructive RealFFT
transform and writes straight into its interleaved pending PCM. One spectrum,
one shared forward/inverse scratch area, one inverse-output workspace and
per-channel overlap remain. The Rubato packet FIFO, adapter dispatch/copies,
channel mask, second spectrum and application output planars are removed.
Equal-rate playback writes mapped samples directly from the decoder block into
pending PCM, with no input or output planar staging.

`fft.rs` specializes only Rubato 5.0.1's exact-unit f64 core and default BH2
filter. `AUDIO-FFT-UPSTREAM.json` records source hashes, the adaptation and its
complete MIT notice. RealFFT retains its ordinary portable runtime planner;
there are no new CPU-target flags. Rubato and audioadapter are test dependencies.

The decoder retains reusable 20 ms packets. The processor retains the prior
7-smooth FFT units, otherwise replacing packet-rounding primes with a bounded
binary multiplier: 11025 → 44100 uses 256/1024 instead of 221/884. The latter
changes that newly admitted filter; it is not a claim of identical old filter
output or improved quality. Both exact units must be 7-smooth, at most 16384
frames and at most 100 ms. Reduced 147:10240 covers ordinary rate families
through 768 kHz. Other prime factors remain explicitly unsupported before any
FFT allocation. Equal-rate playback needs no FFT admission.

For input unit `N`, output unit `M`, channels `C <= 2`, shared scratch length
`S = max(forward_scratch, inverse_scratch)` in complex f64 values, and retained
FFT plan bytes `P`, the live resampling buffers request:

```
P + 8 * (2*N*C + 2*M + 2*M*C)
  + 16 * ((N+1) + (max(N,M)+1) + S)
  + 2*C * size_of::<Vec<f64>>()
  + timing_capacity * size_of::<Span>()
```

This charges padded input, shared inverse output, pending PCM and overlap, the
filter/spectrum/scratch, both planar owner arrays, and all timing storage.
Pipeline and Vec headers held inline are part of their containing service
owner. The equal-rate case requests `8*packet_frames*C` plus timing storage.
No decoder, codec, file mapping, transport, service thread, CPAL/backend, allocator
retention or OS stack bytes are included by this pipeline formula.

Timing initially reserves eight spans. Its admitted length is `4*N+4` (packet
frames for equal-rate playback); VecDeque's allocation can round to the next
power of two. Source accumulation and FFT delay are bounded by those units;
output backpressure prevents a second pending unit being fed. One-frame source
boundaries can grow timing storage on the control owner. At growth, both old and
new storage can briefly coexist: charge at most `1.5 * next_power_of_two(4*N+4)`
spans during this transition, not just the final live span capacity. Explicit
play/seek replaces the old pipeline on the control owner. Natural compatible
joins keep filter history; incompatible changes finish the prior tail first.

For unchanged FFT geometry, compare the prior fixed-input owner with packet
size `K` and output maximum `Q >= M`. Padded input removes at least
`8*(2*C*K + (2-C)*N)` requested bytes; output staging removes `24*C*Q` bytes;
merged spectra remove `16*(min(N,M)+1)` bytes; shared scratch removes the smaller
scratch allocation. The same plans/filter/overlap remain, with fewer owner
arrays and no mask. This algebra covers all prior admitted ratio families,
including units larger than a decoder packet. Constructor cache peaks are
separately measured. Changed packet-rounding geometry needs actual comparisons.

Tests compare all 17×17 ordinary rate pairs and both pathological 81920/78750
directions, mono and stereo: 582 complete-pipeline constructor cases, including
retirement balance. Each requires retained and peak requested bytes to be no
greater than the faithful prior fixed-input pipeline's heap owners. The
pathological stereo forward case falls from 1,846,466 to 1,289,856 requested
bytes; ordinary 44100 → 48000 stereo retains 50,504 bytes. These are local
allocator requests, not resident-set measurements or universal process bounds.

The 800 smooth marginal constructor cases compare the actual new core with
Rubato and retire both completely. They cover every admitted smooth length on
each side; they are not an exhaustive arbitrary pair campaign or a proof of a
fixed 16 MiB whole-player ceiling. `P` and architecture-specific planner peaks
remain explicit rather than silently excluded from a claimed byte limit.

Independent, unmodified Rubato tests compare every f64 sample bit-for-bit across
impulses, distinct channels, nonperiodic input, partial units and zero tail
units. The complete pipeline comparison additionally covers mapped channels,
decoder packet splits, natural source boundaries, partial acceptance/backpressure
and an integer final-frame oracle. Every exact-unit processing call records
zero allocations and zero frees. Separate one-frame boundary campaigns charge
timing growth and prove whole-pipeline retirement balance. Public real
WAV/FLAC/MP3, seek, failure, pause/stop and callback controls remain required.

This candidate has passed functional and allocation controls, the default
regression suite, and ordinary release assembly inspection. The unit kernel
inlines into Pipeline::process; RealFFT plans retain their dispatch boundary.
Cold reserve/error branches remain visible, so allocation counters independently
check the admitted successful path. Quiet capture used 13 alternating paired
samples per cohort. All 19 completed matched processing comparisons and all 23
matched construction comparisons had paired 95% bootstrap intervals below 1.
The four pathological processing comparisons remain unresolved: the untouched
fixed-input baseline aborts when its first zero-padded decoder packet emits no
FFT unit. The explicit 40974-frame regression checks the exact-unit successor's
entire output against independent Rubato, including all 3937 delayed frames.

Changed-filter 44100 → 11025 uses 512/128 rather than 296/74 units (delay 64
rather than 37). Its constructor took 1.429 times the baseline's duration,
paired 95% interval [1.427, 1.432]. Faster processing does not offset that
regression or establish an incumbent win. The corresponding 11025 → 44100 case
is also reported separately because its filter/delay changed. Every raw pair
and interval is retained in the qualification evidence; no slower cohort is
hidden in an aggregate. A smaller smooth multiplier is a separate successor,
requiring fresh source, functional checks, preregistration and timing.

Exact-source native regression checks remain pending. The host has no working
CPAL hardware device; there is no hardware playback or complete-player
memory/performance claim.
