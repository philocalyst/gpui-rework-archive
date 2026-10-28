# Count raw clusters before placing glyphs

Main commit `2fefe2d26692e7839231318a71dc4055a694f456` adopts the exact four-file
patch from `ff8fa35f19af553764f82a4af943c94b1235f5a4`, qualified over the preceding
coverage-certificate source. [Review and gates](review.json), [payload index](file-index.json)
and [original external artifacts](external-artifacts.json) retain the selected
result, its predecessors and failures.

Canvas must check the whole paragraph's output count before lowering. It now
sums existing line-scoped `Run` cluster lengths, bypassing positioned grouping,
atom advance calculation and per-glyph iteration for that check. Actual lowering
still uses ordinary positioned glyphs. Reserve policy, error precedence and the
whole-paragraph resource guard remain. The engine's sole cluster constructor
already stores `1` for an inline glyph, so its accessor becomes a const field
read. No owner field, allocation, unsafe code or count cache is added.

The first cached-count formulation added one transient `usize` per positioned
run. Its iterator gained 155 code bytes and a 32-byte static frame. The next
formulation removed the field but still grouped positioned runs. The selected
version also bypasses that grouping. An incorrect intermediate patch removed
the debug-assertion argument rather than the initializer field; both compiler
rejections remain archived and are not passing gates.

The selected source passes **73 unit tests / two ignored** in both ordinary and
no-default-feature builds, including scripts, wrapping, long combining sequences,
zero-glyph text and recovery after the resource limit. Strict all-target lint
passes using the tracked repository policy. Apple ARM and Windows MSVC library
source checks pass; they are not foreign native execution. Strict/default/oracle
guards cover 2,215 materialized inputs. Restoring the fault source caused sparse
checkout to remove only `clippy.toml`; fallback and foreign source checks guard
the remaining 2,214 unchanged inputs. Those latter checks are not lint claims;
Main retains the policy.

All **1,120 cases / 2,240 shaping, layout, selection and error records** match
the preceding 285,940,280-byte public oracle exactly. The full identical output
is already stored in the preceding [coverage dossier](../bundled-coverage/README.md);
the new original outputs and actual frozen executables are externally indexed.
Actual Canvas executables pass the independent positioned-output count test and
fail it when the accessor deliberately overcounts every run. Source and binary
hashes match before and after these focused executions; the clean selected
source is restored.

| Same-path/compiler/flags executable | Baseline → selected |
| --- | ---: |
| Whole `.text` | −1,392 B |
| Whole `.rodata` | −8 B |
| All allocated sections, including padding | −4 B |
| Count helper code | 1,118 → 444 B |
| Count helper maximum observed RSP CFA | 352 → 48 B |
| Shaping code | 13,544 → 13,312 B |
| Shaping maximum observed RSP CFA | 3,056 → 3,040 B |
| Core, excluding tests/comments/vendors | 31,321 → 31,318 lines |

Assembly uses a four-way unrolled scalar count loop. This is not a SIMD, speed,
RSS or dynamic stack-peak result. The full section, symbol, disassembly and
unwind records retain the padding and helper costs. This does not close the
separate hostile-font shaping scratch-budget gap.
