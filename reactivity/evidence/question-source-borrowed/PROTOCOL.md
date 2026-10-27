# Borrow the exact source cohort for one synchronous Question refresh

Separate formulation of rejected local/question-source-set, complete dossier
394e246b9b3f1c4acb497205e8581045310a3e5d. Base 6130ca4bb5, with unchanged
production from 8679d1aaa0. That candidate's complete 240-process trial gained
18.0x/16.6x on unrelated two/four-field 1000-label updates, but dependent two-field
25-label and owner-dependent four-field 1000-label controls were +5.394%/+5.134%.
All samples and failures remain. This is not a retry of unchanged source.

Concrete representation change: Change::Sources carries a shared reference to
SourceEdits' bounded four-field array, rather than copying that array through the
static Question lane chain. Its lifetime ends with the synchronous owner refresh.
No source set can enter a worker or outlive that exclusively borrowed owner turn.
No root/window borrow crosses await; external tasks retain the existing owned
input, version, cancellation and physical teardown protocol. No application API
change, new persistent field, allocator, unsafe code or generic executor.

The by-value candidate grew each of four linked delivery routines 6705→7429 B.
The borrowed variant tests reducing that representation/ABI cost. This is a
code-generation hypothesis, not a proven explanation of the narrow losses or an
assumption that a pointer must be faster. Report linked routines/ELF, actual type
sizes, allocation/retention and complete-operation results separately.

Keep the identical question_source_cost and allocation examples. Compare against
the original unchanged control b0e8e37a2115adac044c618a5bb0b33e8e2fa833 (its exact
binary/receipt is retained in gpui-question-source-control-target). Use five new
alternating fresh-process pairs in all 24 preregistered cells, CPU2, 200 warmups,
40×100 settled enqueue/deliver/record/ACK operations. Primary unrelated 2/4-field
1000-label median ratios <=.8; all single/dependent/coarse controls <=1.05. Keep
all pairs/ranges/tails/cold/RSS and exact final pixel/model/Ready/task counters.
No compilers/tests/allocator probes or source mutations during measurement.

Additionally compare borrowed against the prior owned binary on the two losing
cells and the two primary cells, three alternating pairs using the same complete
fixture. Report this mechanistic comparison separately, without pooling it into
the five-pair baseline verdict. Stop or reject if semantic evidence or the fixed
numerical gates fail; do not cherry-pick samples. Shared guest noise and no
hardware cache counters remain limitations.

Re-run public source-set/diamond/A-B-A/fallback tests, full default GPUI suite,
strict Clippy, complete X11 GPUI feature suite/doctests and six actual native
scripts. A fresh dropped-member mutant must still fail on missing worker input.
Before each gate freeze source, unique target, all build-input hashes and linked
artifact identities. Source/fixture-only corrections preserve failed attempts.
No competitor/hardware verdict or implicit adoption from these recorder results.
