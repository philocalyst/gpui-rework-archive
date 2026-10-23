use gpui_reactivity_core::layout::{
    AvailableSpace, LayoutTree, MeasureInput, MeasureOutput, Size, Style,
};
use gpui_reactivity_core::{NodeId, NodeKind};

fn fallback(_: MeasureInput) -> MeasureOutput {
    panic!("borrowed service required")
}
fn content(known: Size<Option<f32>>, available: AvailableSpace) -> MeasureOutput {
    let width = known.width.unwrap_or(match available {
        AvailableSpace::MaxContent => 91.,
        AvailableSpace::MinContent => 7.,
        AvailableSpace::Definite(width) => width.min(91.),
    });
    MeasureOutput::from_size(Size {
        width,
        height: known.height.unwrap_or((91. / width.max(1.)).ceil() * 20.),
    })
}
fn fixture() -> (LayoutTree, NodeId, Vec<NodeId>) {
    let mut tree = LayoutTree::new();
    let root = tree
        .insert(None, NodeKind::Element, Style::DEFAULT)
        .unwrap();
    let leaves = (0..19)
        .map(|_| {
            let leaf = tree
                .insert(Some(root), NodeKind::Element, Style::DEFAULT)
                .unwrap();
            tree.set_measure(leaf, Some(fallback)).unwrap();
            leaf
        })
        .collect();
    (tree, root, leaves)
}
#[inline(never)]
fn full(tree: &mut LayoutTree, root: NodeId, available: Size<AvailableSpace>) {
    tree.compute_with(root, available, &mut |_, input| {
        // This service genuinely observes height, so the ordinary API is required.
        let mut output = content(input.known_dimensions, input.available_space.width);
        if let AvailableSpace::Definite(height) = input.available_space.height {
            output.size.height = output.size.height.min(height);
        }
        output
    })
    .unwrap();
}
#[inline(never)]
fn width(tree: &mut LayoutTree, root: NodeId, available: Size<AvailableSpace>) {
    #[cfg(candidate)]
    tree.compute_with_width_measure(root, available, &mut |_, input| {
        content(input.known_dimensions, input.available_width)
    })
    .unwrap();
    #[cfg(not(candidate))]
    tree.compute_with(root, available, &mut |_, input| {
        content(input.known_dimensions, input.available_space.width)
    })
    .unwrap();
}
fn main() {
    let (mut both, both_root, both_leaves) = fixture();
    let (mut narrow, narrow_root, narrow_leaves) = fixture();
    for size in [400., 240., 500., 180.] {
        let available = std::hint::black_box(Size {
            width: AvailableSpace::Definite(size),
            height: AvailableSpace::Definite(size / 2.),
        });
        full(&mut both, both_root, available);
        width(&mut narrow, narrow_root, available);
        println!("{size}");
        for (tree, leaves) in [(&both, &both_leaves), (&narrow, &narrow_leaves)] {
            println!(
                "{:?}",
                leaves
                    .iter()
                    .map(|&id| {
                        let l = tree.layout(id).unwrap();
                        [l.location.x, l.location.y, l.size.width, l.size.height].map(f32::to_bits)
                    })
                    .collect::<Vec<_>>()
            );
        }
    }
}
