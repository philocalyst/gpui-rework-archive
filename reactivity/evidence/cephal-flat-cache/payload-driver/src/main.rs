use cephal::{AvailableSpace, Line, NodeCache, Size};
use cephal::tree::{LayoutInput, LayoutOutput, RequestedAxis, RunMode, SizingMode};
fn main() {
    let mut cache = NodeCache::new();
    println!("LayoutTree={},NodeCache={},empty_heap={}", size_of::<gpui_reactivity_core::layout::LayoutTree>(), size_of::<NodeCache>(), cache.allocated_bytes());
    for width in 0..4 {
        let query = LayoutInput {
            run_mode: RunMode::ComputeSize,
            sizing_mode: SizingMode::InherentSize,
            axis: RequestedAxis::Both,
            known_dimensions: Size { width: Some(width as f32), height: None },
            known_dimensions_are_definite: Size::TRUE,
            parent_size: Size { width: Some(100.0), height: None },
            available_space: Size { width: AvailableSpace::Definite(40.0), height: AvailableSpace::MaxContent },
            vertical_margins_are_collapsible: Line::FALSE,
            context_key: 0,
        };
        cache.store(&query, LayoutOutput::HIDDEN, 1);
        println!("stores={},heap={}", width + 1, cache.allocated_bytes());
    }
    cache.clear();
    println!("clear_heap={}", cache.allocated_bytes());
}
