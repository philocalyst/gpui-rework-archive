# Library acquisition and Files

The port can create a persistent writable library, configure folders, explicitly
index real WAV/FLAC/MP3 metadata, browse Files, and explicitly play the displayed
ordered file context through the existing queue/audio service. The routed SQL
browser remains available for Tracks, Albums, Artists and Playlists. This is a
qualified application slice with the gaps below, not complete Hummingbird parity.

```sh
cargo run --locked --features native -- --native --library /path/to/library.sqlite
```

`Database::open_library(path)` creates or reopens a port-owned database. Creation
runs the pinned migrations and publishes an ownership marker only after setup
succeeds. An occupied unmarked database is rejected. `--database` continues to
open an existing upstream database read-only; it does not migrate or seed it.
The two CLI database options are mutually exclusive.

In Files, enter a folder in Library root path, select Add library root, then
Index library roots. Adding a root, scanning, searching, navigating, retrying or
Prepare never starts playback. Open traverses the directory route. Play all
files and Play from use the displayed immutable recording order only after that
explicit action. Native production attaches its configured output provider; an
audio-enabled headless Library without one visibly rejects playback.

The path editor is an ordinary component source:

```rust,ignore
win.set(Library::ROOTS.source(&Roots::PATH), folder_string)?;
win.activate(win.button("Add library root"))?;
win.activate(win.button("Index library roots"))?;
```

The same `Library: View`, typed Sources/Question, worker result Inbox and public
Window/Win APIs serve production and tests. Files adds no worker, result queue,
query-completion playback effect or separate test dispatcher.

## Authority and persistence

The existing worker owns SQLite, directory queries and incremental discovery.
An active scan polls commands between filesystem/media units; idle work blocks
on the existing receiver. Cancellation does not preempt a blocking OS/media
call or the final SQL transaction. Scan staging is private TEMP data. A final
transaction applies rows, associations, removals and staging cleanup, commits,
then publishes the checked Version before completion. A failed transaction does
not publish. Cancellation/replacement resolves accepted pending work; a full
result lane closes the producer authority and produces visible terminal state.

Unchanged paths keep recording IDs and unchanged associations. Add-only changes
retain source generation; replacing metadata or removing recordings advances it.
Old named and listing preparation leases are rejected even when their completion
was buffered before indexing committed and its Version notification is still
queued. Source authority precedes audio authority. Explicit playback validates
and commits queue edits atomically under the existing Source→Audio protocol;
cloned newer Stop/Pause/Seek controls remain authoritative. No rollback is
claimed after an application panic.

Roots persist in SQLite. Overlapping roots retain membership while discovery
avoids duplicate traversal. Missing/unreadable subtrees protect committed rows
from pruning. Forget root keeps indexed recordings. Remove root + recordings
removes only eligible managed database records, respecting other roots; it never
deletes physical audio files. Symlink children are not followed. Unsupported or
malformed media produces visible failure counts without silently removing an
existing seen recording.

Files identity uses exact OsString child names and fresh worker-issued row
domains. Display text may be lossy; it is never an identity key. The listing
owns a canonical directory prefix and ordered child names, composing a full path
for explicit actions. Non-UTF8 names remain distinct and navigable through public
list actions; they are explicitly rejected for indexing into SQLite TEXT
locations. External filesystem/SQLite writers are outside the worker-controlled
Version publication contract. There is no watcher or atomic file-content lease.

Metadata inspection uses a scan-owned reusable Symphonia registry, borrowing
existing shared tag strings and binding cleaned text to SQLite. It creates no
PCM decoder or artwork pipeline. Selected title/sort/artist/album/number/duration
fields are supported; this is not the complete upstream provider/tag surface.

## Dependency boundary

Indexing requires format/metadata readers under the default feature set; audio
still adds PCM, DSP and ring/output dependencies. The direct metadata dependency
enables index-only ID3 without changing playback's registry. The port lockfile
keeps the same package/version set, replacing registry RIFF with its local copy.

`reactivity/vendor/symphonia-format-riff` retains the complete upstream 0.6.1
package, MPL-2.0 license and exact provenance in GPUI-PATCH.json. The two-line
WAVE patch seeds the existing MetadataLog from external metadata and returns
that same log after already-parsed INFO revisions. External metadata stays first.
No second RIFF parser or header walk is added to the application. PCM packet,
reader admission/options and other parser code remain unchanged. Tests cover
multiple INFO revisions, unknown chunks and malformed/truncated admission.
The correction also retains parsed INFO metadata for playback readers until
the format reader retires, where the buggy reader discarded it. That intended
metadata lifetime cost is not a zero-resource claim; the constructor/untagged
directory counters do not bound arbitrary tagged-media retention.

## Qualification and resource scope

The frozen production passed the whole native suite (135 passed, one existing
ignored), strict default/native checks, and the original default/collection plus
new Files actual Registry clients. The final test-only successor passed 63
default tests including distinct non-UTF8 names/actions; both strict checks passed
again. These are overlapping feature gates, not additive unique test totals.
The original default run completed unchanged after filesystem journal waits;
its saved kernel stacks and complete output remain in the qualification package.

The new native client uses public editable text and buttons, real persistent
SQLite, real indexing/library/audio owners, a bounded counting output provider,
pure Prepare/collision controls, Stop, terminal disconnection/error visibility
and normal WM close. Original watchdogs and clients remain intact. There is no
physical-device, latency or fresh foreign-platform app qualification claim.

The unchanged original constructor fixture measures calling-thread Rust
allocations only. Compared with Browser/OneEngine282, Files adds 3,779 retained
heap-plus-Win bytes cold and 3,419 warm, with 37 total and 17 retained requests.
Library's header grows 64 bytes and LibraryEvent grows 40 bytes. Header figures
overlap their owners; do not add them to heap/Win totals. Default dependency and
ordinary compile work are real feature costs, not a cold-build benchmark.

The prefix owner was also compared against the preserved absolute-path owner
using the same full real directory fixture, physical source/caller build path,
locked dependency versions and flags. Every raw sample and semantic snapshot is
preserved. At the directory sample it saves 514 allocation requests, 89,303
requested bytes since initial and 54,815 retained bytes, but retains one extra
allocation. FileListing grows from 40 to 64 bytes, including empty root answers;
peak allocation count also grows by one. Directory actions retain their shared
listing until sheet retirement. The recording fixture does not establish a
universal directory-only retirement bound. This is not a universal monotonic
resource win. Cumulative peaks are not isolated per-phase bounds; C/SQLite/OS,
device, allocator internals and RSS are outside these Rust counters.

Both matched normal linked callers have 2,656 fewer .text bytes; the port rlib
has 1,557 fewer .text bytes. GPUI/core/Canvas/state rlibs are byte-identical.
The diagnostic caller's .rodata grows 40 bytes, and two shared function CFA
observations each grow 16 bytes. Full section/alias/new-and-removed-symbol bills
remain explicit. CFA observations are not full call-stack bounds. No speed or
whole native binary reduction is inferred from these ordinary caller artifacts.

## Remaining application and audio gaps

Artwork processing/cache/display, general settings/output selection, media keys
and OS service integration, watchers/targeted discovery/storage events, rename
identity matching, full metadata/codec/provider coverage, playlist editing and
richer table/context interactions remain absent. Roots persistence is not a
complete settings implementation. File acquisition can retain work proportional
to roots, directory depth, staging data and listing size; no whole-player fixed
memory bound is claimed.

The prior DSP evidence remains adverse where recorded: four pathological old
processing comparisons are unresolved because their baseline panics; constructor
cohort 24 regressed by 1.429 with interval [1.427, 1.432]. Bounded FFT geometry
still rejects some valid rational rates, and equal delay does not imply equal
filter/output. These are detailed in AUDIO-BUDGET.md and PORT-REHEARSAL.md.
CPAL pause occurs before its callback ramp, so hardware fade-out is unproved.
Standalone natural EOF still retains a live output/token and owner polling;
backend drain/quiescence and the startup rendezvous are unchanged. Files and
text/resource results do not offset these limitations.
