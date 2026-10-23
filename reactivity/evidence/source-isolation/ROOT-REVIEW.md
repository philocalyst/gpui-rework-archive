# Exact-source mutable-alias failure and admission repair, unadopted

Root reproduced a real stale-capture failure on composed source
`e31ffdbc15c8e786e822715c7c0d00d95629f97c`, with the public adversarial tests
frozen at `cb83d485451e2cbd69da95b68f58409a4dee5abf`. Two separately declared
Signals shared one `Arc<AtomicU64>`. A typed edit of the left source changed the
right source's canonical value to one, while its Question stayed Ready with the
accepted zero capture and the visible text remained zero. The same edit through
the coarse owner ingress refreshed correctly. The run has one pass and one
failure; its complete diagnostics and frozen executable identity are preserved.

This is a representation-admission defect, not an unsafe-code defect. Excluding
nested Signals alone does not exclude shared mutable canonical data. The isolated
repair at `ff44c087e36eba331e0bc408a98bcab8e3837467` also excludes UnsafeCell
from exact-source representations. Standard and Triomphe Arc leases inspect the
pointee rather than reference-count metadata. Immutable sharing and copy-on-write
remain admitted; atomics, locks and cells cannot grant this exact-edit capability.
Coarse models still support those resources. This boundary does not prove closure
purity or track external state, reference-count observations or arbitrary effects.

The first repair gate passes 156 tests across two harnesses, with five ignored.
Root independently reopens all 1,994 guarded inputs in each lane. All 25 public
downstream contracts pass using the actual full Cargo metadata and genuine
nightly without bootstrap. They retain the original ten contracts, reject ten
additional mutable/nested representations, admit four immutable representations,
and reject the complete original failing public test at Source::new with E0277.
All 186 Cargo-reported dependency artifacts match before and after compilation.
The runtime positives exercise copy-on-write peer isolation, Triomphe text and
ordinary coarse shared-resource edits.

Triomphe 0.1.17 moves from a test-only dependency into the production dependency
set. Its version and lockfile were already present; that does not make the new
production edge free. Full default/native, strict, foreign-target, Hummingbird
and matched code/allocation qualification remain separate successor work.
Main's compiler and runtime are unchanged by this evidence commit.

Two harness errors are retained. The original functional summary parser counted
only `ok` rows and incorrectly summarized the negative as zero passes/failures;
the raw FAILED row and independent one-pass/one-failure summary remain. The
corrected helper handles both row kinds. The initial downstream checker wrongly
required diagnostics to spell the private UnsafeCell reason; rustc reports the
public SourceValue bound instead. Its sixteen-pass/nine-failure report remains.
The corrected checker requires only the intended error code and the exact public
constructor bound for the added cases. Both helper versions and complete runs
are archived. No product source or expected error code changed between them.

The deterministic archive contains 191 individually reopened payloads. The
160,342,240-byte failing executable remains external with its SHA-256 identity;
it was independently rehashed. There is no timing, RSS, full-suite or production
adoption claim.
