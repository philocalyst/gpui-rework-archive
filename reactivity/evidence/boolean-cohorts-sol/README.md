# Reusable components, Length and compound boolean binding review

The frozen shipping source is `3fc07815a0ce389db54e492dd1d889c6fca10699`, with sole direct parent `957cf9d0865e9fd30a7e3d4ba4dea2e8aa97221c`. Worktree `/root/gpui-boolean-cohort-sol-20261024` is independent of Main. This commit composes the actual component library, typed Length and typed bindings; it preserves Root's Reader, Remote, portable GPU oracle and Hummingbird changes. The later IME source is deliberately absent and requires an explicit integration review. This is a partial port, not all reference component families.

`local-raw-receipts.tar.gz` contains raw commands, compiler diagnostics, test output, probes, costs, scripts, source guards and actual native captures, including intermediate failures. The adjacent SHA-256 file seals it. `actual-frozen-executables.json` records external executable paths, hashes and source identities. These are actual build artifacts, not later rebuild substitutions. The final 92 default test/example executables and native application are frozen outside targets; earlier qualified baseline and mutant artifacts remain separate.

## Public consumer surface

```rust
Checkbox::new("Carve pumpkins", &model.checked, theme)
    .toggle(CHECKED) // owner-relative Source<Model, bool>
    .on_change(app_handler) // replaces that behavior, invoked exactly once
    .disabled(explicitly_erased_bool_input)
    .parts(|parts| parts.indicator(|indicator| indicator.rounded(3.0)))
    .build();

Input::new(&model.title, "Invitation title", theme)
    .invalid((&model.title, |s: &String| s.trim().is_empty()))
    .disabled(&model.locked)
    .build();

let binding = BoolBinding::new((&model.count, |n: &usize| *n >= 8));
let state = binding.state();
let content = div()
    .disabled(state)
    .bg(state.select(theme.surface(), theme.danger()));
binding.attach(content);
```

The BoolBinding spelling above is an explicit sharing cohort. A single bounded pure predicate supplies semantic and palette destinations once per admitted source change. BoolState is a private-identity Copy token; it neither owns state nor permits forging an owner. Literal predicates need no nonce, nested aliases retain one owner, orphan consumed states reject admission, unused groups disappear before recipe capture/poll. SourceMapper capture bounds still apply. Component bool methods accept the same `impl IntoProp<bool>` boundary as primitive builders, including intentional `PropInput<bool>` erasure. Arbitrary caller Rust branches remain snapshots and require ordinary `.field`/`.component` dependencies; this API makes no automatic cross-sink CSE promise.

The public interface is typed and macro free. Internally bounded type-erased inline calls and `Any` downcasts remain at the existing recipe boundary. Explicit cohorts retain group/member vectors, an extended fanout owner and description-time records. The mixed ordinary/cohort representation uses a cold box; there are no new per-member boxes in the compound path. This is neither universally static dispatch nor allocation free.

## Semantic behavior and barriers

Input invalid state now projects `Part::invalid`, serialized state, acknowledged AccessKit Invalid and real AT-SPI InvalidEntry. It is not merely a red border. Invalid does not itself disable text editing and does not inherit. Disabled does inherit and rejects live logical action/focus/edit authority even while older acknowledged pixels and semantics remain visible. Checkbox children provide actual typed named parts while the checkbox alone retains its role and accessible name. Focus indication is an acknowledged, clipped/transformed underline; rounded focus outlines remain graphics work.

Boolean recipes are captured/admitted before destination writes. Tests exercise exactly-once predicate invocation, mapper failure/capture rejection, explicit Set(default), Inherit following the latest lower source, palette masking, source/member retirement, captured owner identity, old P/new C, acknowledged invalid freezing and failure presentation. Palette switches reuse literal codes rather than retaining historical colors; a test goes beyond the ordinary 32-value search prefix for 100 updates. A disjoint candidate source change and older P do not confer new action authority.

Length is explicit Auto, Points and Percent, with 100 meaning 100 percent. Nonfinite and negative inputs reject before layout. Auto differs from Inherit, author values preserve exact bits, typed source/inspector/property contracts share admission. Style and El headers remain 88 and 176 bytes.

## Qualification

The final local guard is `fd743fe62ee4629e47d64df224abd59a9a87d8b29bddd2cd3b5096ba0d5ffbe0` over 2,087 materialized build inputs. It is identical before/after final default, native and documentation gates. Mac staging additionally hashes the two root workspace files directly from the same source commit: 2,089 total. Root Cargo files are not materialized for the local standalone-workspace build, so this is an explicit guard difference, not a claim that local guards covered absent files. Fifty protected Root Reader/Remote/GPU/proof/Hummingbird files match the parent exactly; both lockfile dependency edges remain intact.

- Final full default GPUI/component gate: **735 passed, zero failed, ten ignored**, including 38 documentation cases. Public Reader unwind, first-poll and control-trait tests run in this gate.
- Strict GPUI/component all-target default and X11 native clippy: pass with warnings denied.
- Hummingbird's own locked/offline all-target check: pass. Canonical std Arc ownership-lab native question mailbox: six pass. This is not a fresh Miri/Loom result.
- Actual X11 GPUI native unit executable: **259 passed, zero failed, 32 ignored**. Shipping source matches final source; the last final commit only scopes a test fixture for strict lint.
- Explicit ignored real AT-SPI invalid state/event fixture: pass over isolated D-Bus, including EditableText GetState and `StateChanged:invalid-entry` transitions in both directions.
- Explicit ignored native contained inspector entry fixture: pass using real selection, draft, rejection, recovery, Apply, acknowledged pixels and stale target feedback.
- Native Halloween application: actual pointer and keyboard interaction through S9/P9 and resize to 960 by 700; five actual Xvfb screenshots retained. These are software X11 captures, not physical Mac capture.
- Exact Darwin qualification: **767 native passed, zero failed, twelve ignored**, plus **38 docs passed**. All 75 actual test Mach-Os, the native Halloween application build and strict native all-target checks passed. All 2,089 source hashes and 76 external binary hashes match; the job exited and the exclusive host lock is released. See darwin/summary.json and its sealed raw archive. No physical Mac capture or UI permission request was performed.

The once-evaluation mutant `e5f3a4c31cee934f2b05b849859e1b511ab8e87c` adds a second ordinary recipe call. Its freshly built actual executable fails the ordinary external component test with nine predicate calls versus six, exit 101. Guard `646b738baa7c7b66abf3e48229c6bf7c0cff2e0b20c6b61e3a9aba142be8ad05` matches before/build/after execution. The executable is 30,365,440 bytes, SHA-256 `63f8023ff498903e4ffca0153cb0f06b3f4e70506941a6a7547ed889107afe8b`.

Intermediate receipts retain the privacy compile failure, P-size probe rejection, missing literal-bank legacy regressions, wrong test query/retired-identity assertions, child iterator fixture error, closed-domain test update and final strict test scope correction. These are resolved failures, not removed evidence. One early failed executable was overwritten before it could be frozen; its logs and source guards survive. Do not infer that every historical failed executable was retained.

## Measured costs

Shipping non-test/non-comment code: **36,538 lines in seven existing core libraries**, **606 in the reusable component library**; vendor AT-SPI adaptation adds three production lines separately. The component crate depends only on GPUI. Parent's parking_lot dependency edge is preserved, not introduced by this feature. Full per-file inventory and exclusions are in inventory.json.

| fixture | allocations | requested bytes | retained bytes |
|---|---:|---:|---:|
| snapshot description | 13 | 2,000 | 2,000 |
| direct description | 37 | 4,408 | 3,624 |
| snapshot mount | 420 | 164,778 | 28,716 |
| direct mount | 470 | 170,762 | 29,348 |
| 100 snapshot updates | 5,750 | 1,821,800 | 0 |
| 100 direct updates | 1,950 | 338,800 | 0 |

Against the prior qualified binding candidate, direct mount uses six fewer allocations and 648 fewer retained bytes, while requested bytes increase by 1,624. Direct description uses seven fewer allocations but 136 more retained and 800 more requested bytes. Direct-vs-snapshot mount retention is now +632 bytes, formerly +1,280. The 100 direct writes produce zero owner reruns/descriptions, 100 source reads and 400 destination comparisons; snapshot produces 100 owner reruns/descriptions. Initial/final rasters are exactly equal (281,600 bytes each).

The actual party description is 58 allocations, 7,808 requested/7,448 retained bytes; party window is 1,008 allocations, 321,955 requested/91,586 retained. Prior candidate was 60/7,616/7,440 and 1,017/323,151/92,382 respectively. A stock Button focus appearance is a real allocation of 56 bytes.

Actual headers: Node24, El176, Style88, P64, DraftNode152, Extra56, ControlAppearance24. PropInput<bool/color>48, MapDraft80, ordinary MapBinding48, PendingRecipe24, DeferredRecipe16. Boolean fanout80, recipe32, retained member16; pending record56, group draft80, member draft56. BoolBinding56, BoolState16, BoolColors80. PropertyValue28 aligned4. **Explicit ColorInput grows from48 to80**; this temporary/public erased-enum cost is charged, not hidden. Public layout probes and LLVM IR are retained.

Actual unoptimized native application ELF: **71,245,208 bytes**, `.text` **25,854,823 bytes**, SHA-256 `5c841e1753f571ab30e7ad60cd61985927d63165d4b5c0ebc22ffa253276d1c8`. Against the prior 7a native application, full ELF is 24,264 bytes smaller while `.text` is 71,360 larger. No optimized speed, hardware GPU or universal code-size win is claimed. Generic symbol matches are diagnostic, not a sum of distinct code.

## Remaining scope and successor feasibility

Reference inventory remains partial (81 source modules: 67 unported, seven partial, with the baseline inventory defining the remaining categories). The actual reusable control foundations and task application are present; there is no claim to port all 75-plus component families. Rounded focus outlines, full relative uniform-list viewport support and arbitrary component/theme reflection remain gaps. The typed property catalog is still closed; this feature does not add an arbitrary reflection registry.

A later simplification can exploit the existing generic IntoColor entry points: sealed concrete operands may lower directly into El's cold destination records before becoming the largest ColorInput enum. The existing IntoProp<Color> fast path already demonstrates that hook. Shared BoolState plus two colors need not carry a redundant full PropInput in every temporary; intentional explicit ColorInput erasure can remain available. This is feasibility only: compare public ergonomics, standalone selected-color capture bounds, retained ownership, mixed bindings and actual monomorphization before claiming a win. No NaN tagging, unsafe union, side registry or mid-qualification rewrite is proposed. The current source remains frozen.
