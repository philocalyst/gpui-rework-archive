# Source audit scope

Inspected baseline `773cd5d4543a130f071a830782b01bbae746c2d6`; production source is unchanged in this branch. All paths below are relative to `reactivity/`. `frozen/` preserves the named files at that baseline; `SOURCE_INPUTS.json` records SHA-256 and line count. Line numbers refer to that source. Tests listed here were read, **not newly executed**. No external research claims or new compiler/timing results are introduced.

| Boundary | Source / anchor | Observation used in the design |
| --- | --- | --- |
| Legacy View contract | `crates/gpui/src/lib.rs:80` | Borrowed description; no general purity/read-tracking contract |
| Source projection contract | `crates/gpui/src/source.rs:51` | Stable field projection, no external mutable selection; explicit semantic law |
| Exact source representation | `crates/gpui/src/source/value.rs:18` | Leaf excludes nested Signal/UnsafeCell through payload; explicitly does not prove closure purity |
| Component ownership/composition | `crates/gpui/src/component.rs:12`, `:78` | Live typed projection, child View, mapped handlers, component boundary; no retained model pointer |
| Existing parent dependency | `crates/gpui/src/source.rs:682`, `:804`, `:814` | Parent dependency OR child owner dependency; direct_component does not promise structural locality |
| Owned scalar recipes | `crates/gpui/src/style_port.rs:64`, `:71`, `:104` | Explicit determinism/no external mutable reads, 16-byte capture budget, no heap fallback |
| Mapped replay storage | `crates/gpui/src/runtime.rs:782`, `:904`, `:934`, `:977` | Owned records, output scratch, freeze/admit before sink mutation, destination ordering |
| Exact patch routing | `crates/gpui/src/runtime/turn.rs:312` | Logical validity, Questions, Owner fanout and source owner impact gate patching; lists may re-describe |
| Full description/error boundary | `crates/gpui/src/runtime/turn.rs:102` | Schema validation and describe_inner, caught errors/panics, logical authority handling |
| Closed setter lowering | `crates/gpui/src/style.rs:185` | Sealed FlexRecipe lowers supplied setters; not a retained component callback |
| Setter replacement semantics | `crates/gpui/src/element.rs:701`, `:737` | Explicit literal set unbinds old property binding; nonliteral operands choose typed binding/map paths |
| Child insertion | `crates/gpui/src/element.rs:626` | Ordinary ordered child collection; proposed child_local does not exist |
| Projection consumption | `crates/gpui/src/reader.rs:75`, `:199`, `:215`; `crates/gpui/src/element.rs:1013` | Borrowed callback consumed in full lowering; stable status/content position is not retained parent authority |
| Task inputs/version authority | `crates/gpui/src/reader/inputs.rs:22`; `crates/gpui/src/reader/question.rs:64`, `:538`, `:560` | Sealed declared inputs, borrowing/freezing, revision/ticket changes, stale/cancel policy; not visual purity proof |
| List snapshot boundary | `crates/gpui/src/list.rs:29` | Pure for one description, keys checked, no row/source reference retained |
| Nested boundary loss | `crates/gpui/src/element.rs:1122` | Admission validates chain then retains innermost scope, discarding route chain |
| Existing mapped behavior tests | `crates/gpui/tests/mapped_properties.rs:116`, `:155`, `:226`, `:384`, `:432` | Fixed destinations, failed output/older ack, rebound recipes, Questions forcing description, literal override removes map |
| Existing component tests | `crates/gpui/tests/components.rs:125` | Direct ports can omit Views; arbitrary contained methods use parent scheduling grain; repeated/nested caller code exists |
| Executed insufficiency witnesses | `crates/gpui/tests/component_description_contract.rs` and prior dossier | Equal setter, future decoration and repeated occurrences; evidence already sealed at 773cd5d |

No existing task input container is proposed to be repurposed wholesale as a new component runtime. The initial recipe uses only an optional registered Source value and a typed existing component route. Version stamps and closed operand ownership are reusable concepts; Questions scheduling/Reader stale-value semantics remain untouched. Local description admission still needs new explicit parent/occurrence authority.

The design's proposed API names, descriptor contents, eligibility rules and cost expressions are **inferences/proposals** from these boundaries. They are not existing functionality or measured improvements. The source freeze deliberately contains no experimental snapshot-derived patch constructor.
