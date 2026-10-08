use refineable::{IsEmpty, Refineable};

#[derive(Clone, Refineable)]
struct Empty {}

#[test]
fn empty_named_struct_has_an_empty_refinement() {
    assert!(EmptyRefinement::default().is_empty());
}
