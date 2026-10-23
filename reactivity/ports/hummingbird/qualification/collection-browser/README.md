# Collection browser qualification

Production is frozen at ae18a3740471a0c7b1f8261713c7bcd8d94d6019; corrected
external client pin00ac22ef331fbae52a3526f968ad5fe6b008fd55 changes one fixture
label only. The same frozen native ELF is used by both captures. No Main writes
or adoption. The independent9f→00ac source/test/example/client patch is
source-and-tests-corrected-client.patch, SHA256
8fb0f02108209a1b6c1bb72253918b002def24a609479917a656e7763d70dfe4.

**Functional PASS; startup constructor resource REGRESSION with the added UI.**
The measured calling-thread heap plus Win grows20,605B cold/20,925B warm, with
530/531 additional requested allocations. Constructor-probe/README.md contains
the full positive and negative bill, actual headers and scope exclusions. These
costs are not offset by old DSP kernel results. Whole-player performance and
maximum memory remain unmeasured; no universal non-regression claim.

All54 default,125 CPAL and125 native tests pass (one scheduled clock test ignored
in audio modes). Strict all-target default/native Clippy, explicit port-only
rustfmt check, native example build and public headless SQL CLI exit0. Native
compile/check logs show actual incremental dependency work, not cold benchmarks.
Core and vendor are byte-identical across1984 files to the browser base; package
manifests and lockfile are unchanged. Source count6571 (+938 application), actual
shipping core30987 unchanged. Test/doc/fixture copies are excluded from that core
and application count. Browser design, public API, SQL sharing, authority,
fixtures and remaining upstream gaps are described in BROWSER-DESIGN.md.

The actual Registry corrected capture passes39 action/command observations:
import, Albums/detail/Back, Artists/detail, playlist and Unicode filter,
unmatched public Prepared collision, pure Prepare with no output, explicit
Play-from context, real audio owner with zero-credit backpressure then exactly64
accepted PCM frames, queue3, Stop gate revocation, final worker disconnect and
visible failure, normal WM_DELETE_WINDOW and all children exited. All536 tracked
source guards and the frozen ELF hash match before/after. Original provider,
150s client/180s outer/5s kill grace are unchanged. No hardware/timing claim.

The first native run correctly reached Artists, then its external client asked
for `Open Alpha` while the real fixture is `Alpha Artist`. It exhausted the
original150s watchdog, exit1, and cleaned up all children with matching guards.
That complete failed run and ae18 client are retained separately; the correction
uses `Open Alpha Artist` and the exact same production binary. This is a client
name error, not a failed product-authority assertion or a hidden native retry.

Original730 context source-replacement capture demonstrates actual queue stamp
1→2 after worker replacement acknowledgement but before Replaced notification.
The new exact9f full-Version source capability fixes that class. Its original
source/log are retained. Audit found the early manual frozen ELF copy selected
0fc84 while the log named9e2ac911: that unmatched copy is explicitly UNQUALIFIED,
not silently used as evidence. A separate new unchanged730 functional replay
fails101 at the same source assertion and freezes the actual log-named3a665471
ELF; source, command, hashes and complete source snapshot are retained. This is
not a repaired/rerun performance reference. Final context tests include the same
source schedule plus import, route/filter/sort/refresh, selection and clone
controls; the source assertion is not weakened.

Other development errors are retained as such: initial SQL conversion compile
errors; zero-height empty collection list; test transcript syntax; fixture album
uniqueness; moved lookahead in a harness; the harness initially forbidding a
legitimate second output open on cloned Seek; and two harnesses using visible
button labels instead of semantic names. The original functional product source
failure is not conflated with those setup mistakes. An accidental `cargo fmt
--all` also reformatted221 vendor files in this isolated tree. After all readers
exited, its formatting-only patch was preserved and every non-port path restored;
1984 file hashes and all final gates use original core/vendor bytes. Subsequent
formatting is explicit port files with skip_children, never mutating --all.

The historical adverse audio evidence remains intact in PORT-REHEARSAL.md and
its existing qualification directories: four unresolved pathological processing
comparisons, constructor cohort24 ratio1.429 [1.427,1.432], untimed v2 geometry,
changed filters and bounded rate admission. CPAL pause-before-fade, EOF live
output/2ms polling, genuine backend drain/token retirement and startup rendezvous
are unchanged gaps. Files/scanning/artwork/settings/platform media, advanced
sorts/playlist editing, scroll restoration and full upstream parity remain absent.
