# Supporting API documentation audit

This pass covers the public Rust surface outside `crates/gpui`: the GPUI procedural macros,
`Refineable`, the shared utility crate, and the platform utility crate. Documentation was checked
against implementation behavior, including ownership, platform gates, quoting, process lifetime,
path normalization, cascade precedence, and panic/error boundaries. No executable code or public
signature was changed.

## Inventory

The inventory counts source-level `pub` declarations (including reexports and `pub(crate)` helpers
where they are visible in source; public fields are described with their enclosing type). Macro
expansions are counted separately where they create user-facing APIs.

| Area | Source declarations reviewed | Documentation treatment |
| --- | ---: | --- |
| `crates/gpui_macros` | 56 | Added crate contract; reviewed derive, attribute, registration, style-generation, test, benchmark, property-test, and inspector-reflection macro behavior. Existing detailed usage docs retained and generated-style semantics cross-checked. |
| `crates/gpui_derive_refineable` | 3 | Added input-shape, generated-type, attribute, and compile-error contract. |
| `crates/gpui_refineable` | 9 | Reviewed `Refineable`, `IsEmpty`, `Cascade`, and `CascadeSlot`; added explicit empty-slot and handle docs. |
| `crates/gpui_ce_util` (`gpui_util`) | 22 | Added crate and `ArcCow` ownership contracts; reviewed platform command, result/logging, future, timeout, and arithmetic helpers. |
| `crates/gpui_zed_util` (`util`) | 253 | Added module contracts for paths, shells, commands, markdown, redaction, path lists, size/time formatting, and utility grouping; strengthened shell-builder and command method docs. Existing source-aware docs for archive, schema, disambiguation, and process safety retained. |

Total: **343 source declarations**, plus generated APIs from the macro crates. The public macro
surface is documented at its entry points; generated implementations inherit the documented GPUI
trait contracts and the field attributes named in each derive's rustdoc.

## Contract coverage

- `Refineable` distinguishes an unset refinement from an explicit default and applies later cascade
  slots over earlier ones.
- `ArcCow` preserves borrowed lifetimes and uses shared `Arc` storage for owned conversions.
- Shell helpers classify syntax before quoting; command builders configure streams and environment
  before the fallible spawn/output/status operation.
- Process wrappers document process-tree cleanup and platform-specific behavior.
- Path helpers distinguish lexical normalization from filesystem access and keep remote path style
  separate from local platform syntax.
- Formatters state their units and precision, while redaction documents its suffix-based policy.
- Utility methods state their boundary behavior: UTF-8 truncation never splits a code point, path
  wrappers distinguish checked and unchecked construction, shell quoting reports unsupported input,
  and JSON merge helpers spell out replacement versus union semantics.
- The `Refineable` derive's generated refinement type documents presence checks separately from
  semantic emptiness, while macro entry points explain marked-field and compile-time failure
  contracts that users otherwise discover only from compiler output.

No intentionally deferred public API documentation gaps remain in these crates. Longer examples
belong in the site tutorials; the API pages now state the invariants needed to use each helper
safely and to interpret failures.
