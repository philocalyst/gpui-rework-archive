# Integrated source delivery and representation admission

Main adopts `2b52030aed8344ed9c5f6dcf54b2ba19acf8ddf4`, composed on `37d0321fe2` from the independently qualified `22541342e3` producer. [Root adoption record](root-adoption.json) separates the composition checks from the [original producer dossier](producer-README.md). Its original source labels, failures, raw hashes and adverse costs are preserved.

Typed worker replies now enter registered source edits directly. Same-field batches patch once without describing the owner again; unrestricted callbacks keep the conservative barrier. One buffer owns queued and frozen messages, capacity bounds all accepted but undelivered payloads, and revocation precedes payload destruction. Callbacks and destructors execute outside the mutex.

`SourceValue` rejects canonical shared mutable representations, including the demonstrated `Arc<AtomicU64>` alias that changed a sibling source without invalidating its Question. Immutable standard/Triomphe Arc pointees and ArcStr remain admitted; general mutable resources use coarse owner updates. This structural admission does not prove projector purity or track external state. The implementation requires genuine `nightly-2026-10-23`, without bootstrap, for the private structural traits and public trait alias.

Root ran the exact composed source: **580 default tests**, **707 X11/GPU tests**, **28 documentation tests**, and strict default/native-GPU checks under the repository's actual `clippy.toml`. Counts retain their separate harness and ignored-test records. GPU execution uses llvmpipe; the producer's Apple/MSVC gates are cross-compilation checks. Root's post-run preserved ELFs are explicitly distinguished from the producer's before/after execution guards.

In the matched producer fixture, capacity-eight transport removes one allocation and lowers retained requested transport bytes **832→144**; whole bound-owner retained heap falls **6,396→5,708** bytes. Eight exact field edits use **3 allocations/136 requested bytes**, versus coarse delivery's **28/2,260**. These are allocation/work measurements, not RSS or latency results.

The costs remain part of the decision: ordinary delivery's own static frame grows **64 bytes**; typed versus coarse delivery adds **11,328 linked text bytes** and changes its own frame **520→1,416 bytes**. The six shipping libraries contain **31,232 non-test, non-comment source lines**, **245 more** than the preceding Main. The queue still uses a mutex and Arc; no lock-free claim follows. RuntimeCore restructuring and the separately rejected descending-CSR renderer are excluded.

[Producer file index](file-index.json), [Root file index](root-file-index.json), [source equivalence](root-raw/source-equivalence.json.gz), and [external artifacts](root-external-artifacts.json) retain the reviewable inputs. Larger raw payloads use deterministic gzip; binaries remain external rather than being added to library source.
