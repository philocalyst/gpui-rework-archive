# Real audio vertical slice

`native` attaches the production audio service to Library's ordinary QueueScreen
and typed Inbox. `audio` enables real WAV/PCM, FLAC and MP3 decoding with a
replaceable output-device seam; `cpal-output` adds CPAL. The default headless
transcript keeps its existing queue-only contract. Run the opt-in device probe:

```sh
cargo run --locked --features cpal-output --example audio_output -- /path/to/music.flac
cargo test --locked --features cpal-output --lib --test audio
```

The decoder worker exclusively owns File, Symphonia format reader and codec.
Three reusable 20 ms planar f64 blocks cross its bounded one-operation channel.
The audio control owner holds FFT/remainder/tail staging, stream and the producer
of a 100 ms f64 SPSC ring. CPAL's data callback consumes complete frames, converts
sample type, applies the gain ramp and writes silence on underrun. It performs
no allocation, reclamation, locks or I/O. CPAL's separate owned-error callback
has a four-error retirement ring; overflow reclaims the exceptional owned error
and sets a fault flag. It cannot promise universally allocation-free backend
errors or teardown. Formatting ordinary retired errors happens on the control
owner. No owned error is deliberately leaked.

The UI publishes one complete latest intent. Plans lease immutable current and
lookahead TrackRefs, with no second queue snapshot. Equal occurrence stamps
refresh the plan. Seek changes a checked operation token within that occurrence;
stop immediately revokes output permission. The control owner adopts intent
before polling replies. Stale decoder replies and stale UI events cannot change
its current token. A cancelled OS/codec operation is not preempted: after 100 ms,
one replacement decoder may be created while at most one retired worker remains.
Closing the service never joins an unfinished codec call from a UI turn.
Construction starts a control thread and one decoder thread even with no Plan;
decoder-on-first-use is a separate follow-up. With no output, media work or
pending delivery, the control owner parks without a periodic timer. Paused
output faults and Full-Inbox delivery retain bounded polling. Remote has no
receiver-close/credit wake; an otherwise idle service notices receiver closure
on its next attempted delivery, while explicit service close always wakes it.
The timing queue initially reserves eight merged spans and can grow on the
control owner up to the checked input-chunk boundary bound. A fractional source
start that rounds to zero output frames is carried to the next accepted frame.

SourceEof follows all decoded source frames entering pipeline staging. It does
not mean output drain. The UI authorizes the next plan from its latest queue;
natural compatible transitions retain the prior PCM and FFT history, while
explicit play/seek/stop replace the stream and flush the application queue.
Source failures retain and finish preceding valid resampler/PCM tails while the
UI remains Failed. Output failures close their stream on the control owner;
paused streams are also polled for faults. Explicit Play can start a new output
after failure; there is no automatic recovery loop.
SourceEof → UI → next-plan delivery can stall, so this protocol cannot promise
gapless playback under an arbitrary UI stall. Started and Position describe
frames accepted into the application output queue. Drained additionally requires
final resampler tail, staging and that queue to be empty; it excludes OS/device
latency and audible completion. The final stream remains running silence to
avoid truncating a hardware buffer based on an application-only drain signal.

This first slice supports mono/stereo sources and output, with rates up to
768 kHz within the bounded FFT plan described in AUDIO-BUDGET.md; some valid
rational rate pairs remain unsupported. It rejects mid-stream format changes.
It reopens the current path
before an accurate seek, so seek can fail after a file is removed and performs
extra I/O. Device absence/loss produces a typed failure; automatic device
selection/recovery, media keys, volume/replaygain, loops, crossfade, other codecs,
multichannel mapping and idle stream suspension remain follow-ups. Pausing
preserves application PCM; CPAL backend pause latency and existing hardware
buffers are not sample-accurate seek/pause guarantees.
Explicit seek/replace tears down and reopens the stream to flush its plain PCM
ring. A ready feed may wait until the next control cycle to be submitted; active
cycles continue while replies, preparation, PCM acceptance, input or tails make
real progress, checking latest intent and close between bounded units. Blocked
output/media retain timed parking. Stream-preserving generation descriptors
remain a follow-up. Device configuration
uses the default mono/stereo format, or the first admitted mono/stereo range at
its maximum rate; source-aware selection needs backend/mixer policy work.

Qualification uses actual decoding, pipeline, service, Inbox, Win and public
controls. The test sink replaces only OutputProvider. Pinned upstream silent
WAV/FLAC/MP3 fixtures are explicit corner controls. A generated pinned nonzero
stereo corpus checks every WAV/FLAC sample, MP3 error/channel identity and partial
tail. Further controls cover latest equal-stamp lookahead, queued EOF, nonzero
pause/seek/stop, short and high-rate resampling. Callback allocation tests invoke
the exact production callback render method, with allocation-counter recording
both allocations and frees. These tests establish no hardware playback or
hardware performance result. A separate frozen public-service clock gate passes
13 repetitions of six rate pairs at fixed 10 ms consumption deadlines after
100 ms prebuffering, with zero missing frames. Its control's unconditional
2 ms park misses 5328 frames at 768000 -> 48000. See
`qualification/audio-progress-clock` for scope, exact hashes and every capture.
The local real CPAL probe reports an unavailable ALSA device.
Before integration, run the complete existing default/no-audio/headless tests
and ordinary native Registry/X11 immediate-click/inspector clients on this exact
application source. Native auto-attachment adds asynchronous Opening/Failed
updates that can reflow controls. Preserve the original `/music/*.flac` catalog
fixtures and clients; their missing files and this host's absent ALSA device are
failure-path controls, not successful playback or hardware evidence.

UPSTREAM.json records the original algorithm/fixture hashes at the existing
Hummingbird pin. `tools/audio-fixtures.py` generates the separate stereo corpus;
FFmpeg is a fixture-generation tool and is not an application dependency.
