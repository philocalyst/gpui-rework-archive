# Check the workload before later actions can hide a mistake

Source `ec6babe88c511efb9ba44406f19dc9d53c376d14` has the identical whole
Git tree as qualified `69aca81557374bb25142ab2f73a01b7e9358a545`.
Only the ordinary `todo_recording_cost` example changes. Shipping libraries,
dependencies and native acceptance gates are unchanged; core remains 35,863
non-test, non-comment lines including 18 library build-script lines.

The previous fixture checked its complete canonical model after all eight
operations. A later All action can conceal incorrect Active and Done states;
a final model alone is insufficient evidence for the intermediate workload.
The revised fixture keeps a separate explicit expected model and compares
ordinary `source_json` after mount, typing and each of seven actions. Every
row's ID, title and completion flag, filter, draft, next ID and deleted payload
must match. It reads no private application fields and introduces no second
application runtime or test-only state API.

The actual optimized default-SIMD ELF passes all **45 full-model checkpoints**:
nine at each of 0, 1, 2, 1,000 and 10,000 seeded rows. Strict Clippy passes.
Each gate preserves before/after hashes for its own 2,075 inputs. The release
library and example were rebuilt after correct-profile GPUI cleanup; the
executed ELF is frozen outside Cargo, 10,239,184 bytes, SHA256
`15c3ad8892cdde73f10943529500f6ffbbaf27e90983c72359a09d2e5c98d76b`.
Its exact size is also recorded in `result.json`'s executable catalog.

## An actual false pass and its rejection

A bounded application mutant always stores `Filter::All`, while preserving
the original requested action names and callbacks. With two seeded rows:

| Oracle | Source | Actual exit | Observation |
| --- | --- | ---: | --- |
| Previous final-only fixture | `7b479bcb8713830ab234394b0702cf55685cf6f7` | 0 | All seven callbacks occur and the final full model passes despite ignored filters. |
| Revised per-phase fixture | `d586f55877789ed311de465eb963371e190d0f92` | 101 | A semantic full-model assertion rejects Active: actual All, expected Active. |

The new failure is not a missing-button error, panic from an invalid slice,
or a skipped callback. Both actual executables and their output are retained.
The restored research tree `87395d77e100e2c1091f6f62a7ec47e6b6a5b386`
matches the qualified normal tree byte for byte. This demonstrates one
specific detection improvement; it does not establish complete bug coverage.

Expected-row construction follows measured mount and initial acknowledgement.
Canonical checks stay outside each edit/ACK timer and allocation-counter scope.
They nevertheless add process work, memory and cache effects. This is a new
fixture revision: earlier [recording measurements](../todo-recording/README.md)
keep their original source and ELF identities. New performance comparisons
must run both variants with the same revised fixture. No new CPU, RSS,
native rendering, display smoothness or peer-framework win is claimed here.

Native ordered callbacks, drawable revision, exact final model, presentation
and latency gates remain separately required. This headless oracle does not
add per-phase canonical-model checks to the native five-framework harness.

`logs.tar.gz` contains 91 rehashed metadata members: commands, source guards,
strict output, all five ordinary runs, both bounded controls, their exact
example/application source, and actual executable hashes. The three executed
ELFs remain under `/tmp/gpui-todo-phase-*-executable-root/` outside Cargo.
Their exact paths, byte sizes and SHA256 identities are in `result.json`.
