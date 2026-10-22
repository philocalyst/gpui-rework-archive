# Hummingbird data and Library port

This application experiment ports a real Hummingbird data seam into the ordinary
GPUI native/headless owner: SQLite query → Nucleo search → keyed virtual rows →
SQLite-validated playback request. It is a foundation for growing the player
port, not a full player. Audio output, scanner/watcher, full navigation/table
controls, queue, artwork, settings and platform media integration remain absent.

Run from this standalone workspace:

```sh
cargo run --locked -- --headless
cargo run --locked --features native -- --native
cargo run --locked --features native -- --native --database /path/to/library.db
cargo test --locked --all-targets
cargo clippy --locked --all-targets --features native -- -D warnings
```

Native currently selects GPUI's reference CPU renderer and Linux X11/AT-SPI
feature. It renders through the same `Library: View`, `ItemSource`, typed
`Questions`, source fields and Inbox receiver as the headless transcript. There
is no second UI renderer, entity compatibility layer or test dispatcher.

The default in-memory database applies all 39 real pinned migrations before
inserting Hummingbird's original three-track/artist/album/liked fixture, plus six
explicit edge-case rows. `--database` opens an existing library **read-only**;
it does not run migrations or seed it. Query compatibility is with the pin below,
not a promise to migrate arbitrary future databases. Play resolves the actual
track ID, album ID and stored path through `for_playback`; it displays a typed,
sequenced request and does not start an audio device.

## Source, SQL and matching

Upstream is [Hummingbird e15e8ba0ef6ff5445294030d373e3c8ccc7d780c](https://github.com/hummingbird-player/hummingbird/commit/e15e8ba0ef6ff5445294030d373e3c8ccc7d780c).
`LICENSE.upstream` retains Apache-2.0. `UPSTREAM.json` records every copied
migration and relevant original Rust file's SHA-256. Migration files and the
uncompiled `upstream/track_query.rs` reference retain their original bytes.

Compiled `query.rs`/`query_helpers.rs` adapt the practical `TrackQuery` subset:
search/ID/playback projections; ID/path/location/album/artist/liked/standalone
filters; original ordering, joins and tie-break clauses. SQLx transport,
`DBString`/GPUI shared strings and unrelated entity/display/lyrics projections
are removed. A small statement accumulator only stores original SQL fragments
and separately bound SQLite values. This is an adapted module, not a claim that
the full upstream query module is compiled unchanged.

`for_search` only projects `id,title,artist_names,album_id`; it is not a text
predicate. `search.rs` follows upstream `search/model.rs`'s track corpus
`title + " " + nullable_artists.unwrap_or_default()` and the real Nucleo matcher
used by `components/palette/finder.rs`: `Config::DEFAULT`, smart case and smart
normalization. This sortable Library keeps SQL order among matching tracks.
The original command palette instead ranks/caps its mixed album/artist/track
results; that palette UI, ranking policy and other categories are not ported.

Two observed upstream quirks are explicit compatibility fixtures:

- A library title-desc query keeps its primary title key ascending, while
  reversing its location tie-breaker. Liked/standalone title ordering follows a
  different upstream branch. The UI exposes title ascending, artist ascending
  and longest-first, rather than relabelling that behavior as ordinary reverse.
- Nucleo matcher0.3.1's case-sensitive ASCII prefix path compares the whole
  haystack: `^Other` does not match `Other Track `, while `^other` does. The port
  preserves this actual dependency behavior and does not patch the matcher.

## Ownership and bounded delivery

The model holds source inputs, a domain selection/revision and inert Readers.
One named app worker exclusively owns SQLite and Nucleo scratch. A four-command
bounded channel carries typed search/play work and source operations; an
eight-message GPUI Inbox carries committed import/replacement revisions.
`Questions` freeze owned query/sort/version inputs and keep one physical
completion per question. `Completion::run_cancellable` checks obsolete work;
search also checks before SQLite, between fetched rows, between matching
candidates and before publishing. SQLite's internal sort/step is not preempted.
The UI never waits for database/matcher work or joins the worker in a callback.
Matching borrows SQLite's current UTF-8 row values and reuses the worker's corpus
scratch; only accepted rows allocate owned title/artist strings. Every row still
validates its projected types and UTF-8 before filtering. No borrowed SQLite
value escapes a statement step, and SQL order remains the result order.

Search, playback and database mutation commands share that one sequenced channel.
After an SQLite import commits, the worker advances its authoritative database
revision before publishing the Inbox event. Every search compares its complete
frozen revision/generation with that worker version **before** SQL execution;
an old model revision returns `OutdatedSource`, even if its cancellation hint
is still current. An explicit public-owner test holds the real Inbox unbound,
commits an import, proves an old-revision search cannot become Ready, then binds
the Inbox and recovers to revision1/ID5000. Core completion admission is still
the final authority; cancellation hints do not grant publication permission.
That revision covers mutations/replacements owned by this service. External
writes to a read-only opened library are not wired to scanner/watch notices in
this slice; each SQLite statement supplies its own consistent read snapshot.

Each result page owns actual queried row metadata. It is not a fabricated ID
catalogue or an eagerly materialized tree of UI elements. The fixed160-pixel
viewport realizes five32-pixel rows; all result metadata is still materialized
off-thread, as this is not a streaming-query/large-index memory claim. Indexed
lookup within the small page is linear; the separate existing250k fabricated
catalogue remains a distinct framework scale test.

IDs are original signed SQLite IDs, mapped bijectively to `ItemKey` bits. Sort,
filter and prepend preserve the data identity. A replacement database changes
the list's key domain through a source generation; old retained rows cannot
silently play the same numeric ID from a different source. Pending/fault views
keep previous good rows labelled with their original query and show status
chrome. Playback projection is a read-only validation of the selected intent;
query retry/coalescing must not be treated as a new audio side effect.

Fixture import performs a real SQLite insert before sending the Inbox event.
Unavailable/full update delivery closes the worker rather than silently losing
future source notifications. Public service `checkpoint()` returns a receiver
for explicit callers outside UI turns; the headless executable uses it to order
real work without sleeps or a private UI pump. `finish()` stops/revokes service
handles and joins outside the UI; dropping the native/headless window revokes
its pending completion authorities.

## What the executable checks

The headless command runs the actual `Win` transcript and asserts:

- Original three-track fixture joins and nine-row SQL ordering; nullable artist,
  Unicode, tied titles/durations and non-contiguous IDs are real database rows.
- ID44's play action follows it through SQL resort and insertion of ID5000,
  and the stored playback path remains `/music/44.flac`.
- A finished `Alpha` search is left queued, then superseded by a public input
  edit to `cafe`; only current IDs13/11/21 are admitted and stale results are
  counted. A filtered-out action target is rejected.
- Replacing the source with a real empty read-only SQLite file produces the
  actual `no such table: track` failure. Previous rows stay honestly labelled;
  old-source actions cannot play in the replacement. Restoring a valid source
  recovers, with a different target domain.

The query/search tests additionally assert exact pinned order/tie/artist join
behavior, real Unicode/smart matching, cancellation in SQL retrieval and matcher
work, and source byte limits. Shutdown is exercised through the public owner.

`native-transcript.py` is an external client of an ordinary launched Window.
Run it inside a fresh `dbus-run-session`, supplying explicit Xvfb, xdotool and
AT-SPI launcher paths. It owns its display/processes, uses only memory-backed
private-session accessibility settings, and cleans up its children. It checks
initial rows, actual AT-SPI Play, stable native row action after SQL resort,
real X11 keyboard search, Unicode EditableText and SQLite-backed ID44 play.
Assertions read acknowledged accessible labels and submitted-frame epochs, not
direct native handlers. Its polling/deadline belong only to that external
discovery client and are not performance measurements or production timers.

## Dependency scope

The app is an independent workspace. It adds no dependencies to the UI core.
Primary crates.io metadata in `dependency-latest-2026-10-22.json` records latest
stable Rusqlite0.40.2 and Nucleo matcher0.3.1 with archive checksums. Rusqlite's
default cache/Wasm features are disabled; its bundled SQLite is selected.
Nucleo's Unicode features remain enabled. Its registry matcher is MPL-2.0 and
Rusqlite is MIT; neither dependency is vendored or modified. SQLx/Tokio and the
full upstream i18n/media/entity dependency graph are not imported. The path
patches preserve GPUI's existing local text/window/platform repairs.

The uncompiled upstream query reference and migration bytes are provenance
inputs, distinct from compiled port code and from the shipping UI core.

Source commits and final evidence captures are separate; historical controls
keep their actual old pins rather than being relabelled as final integration.
