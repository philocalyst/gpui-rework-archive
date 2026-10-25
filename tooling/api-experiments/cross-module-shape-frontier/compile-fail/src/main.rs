use cross_module_shape_frontier::reflection::Type;

struct NotDescribed;

fn main() {
    // The probe fallback supports schema discovery, while Type::of remains constrained to
    // explicitly described Rust types.
    let _ = Type::of::<NotDescribed>();
}
