# Cross-module shape frontier

Standalone experiment for stable Rust autoref dispatch at concrete field sites. Run
`./check.sh` from any directory. The crate path-imports the production reflection value runtime;
it does not build or edit GPUI production code.

The probe uses `ShapeProbe for &Probe<T>` when `T: Describe` and a fallback implementation for
`&&Probe<T>`. Concrete call sites discover described types in another module and distinguish
same-named types by their actual Rust type identity. Generic call sites with `T: Describe` choose
the preferred implementation, while unbounded `T: 'static` falls back to `Type::opaque`. The
compile-fail check confirms that the probe does not relax the public `Type::of` bound.

`Vec` and `Option` still require explicit wrapper factories, but their item-shape function pointer
can invoke the concrete probe lazily. Recursive structs should likewise retain lazy child factories:
asking for a child type while building its parent would re-enter `Type::of` before the parent
schema reaches the cache. Opaque fallback remains available for child types without `Describe`.

The limitation is syntactic context: autoref selection happens where the generated expression is
typed. A helper like `fn shape_of<T: 'static>()` resolves its body once for generic `T` and therefore
always selects fallback, even if a later monomorphization uses a described type. Generated code must
emit the probe expression at each concrete field type site; a generic field only sees the bounds
available on its containing impl. No unsafe code is needed.
