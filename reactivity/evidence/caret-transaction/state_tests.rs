// Appended as a test-only child of editing::geometry in the private overlay.
#[cfg(test)]
mod transaction_state_tests {
    use super::*;
    use core::mem::size_of;

    #[test]
    fn actual_headers_and_scratch_capacities() {
        std::eprintln!("LOCAL RunSlot={} Entry={} OptionEntry={} VecRunSlot={} VecF32={} OptionUsize={} Restart={}", size_of::<RunSlot>(), size_of::<Entry>(), size_of::<Option<Entry>>(), size_of::<Vec<RunSlot>>(), size_of::<Vec<f32>>(), size_of::<Option<usize>>(), size_of::<CursorGeometryRestart>());
        for (name, source, width, requests) in [
            ("empty", alloc::string::String::new(), None, vec![0]),
            ("tiny", "Count".into(), None, vec![0, 5]),
            ("ltr32k", "a".repeat(32 * 1024), None, vec![0, 32 * 1024]),
            ("rtl", "אבגדה".repeat(900), None, vec![0, 100]),
            ("mixed", "abc אבג 123 xyz ".repeat(900), Some(400.), vec![0, 100]),
        ] {
            let layout = crate::tests::transaction_tests::layout(&source, width);
            let mut inline = [RunSlot { item: u32::MAX, origin: 0. }];
            let mut spill = Vec::new();
            let mut rtl = Vec::new();
            let result = visit_source_pairs::<true, _, core::convert::Infallible>(&layout, requests.into_iter(), 1., &mut |_, _| ControlFlow::Continue(()), &mut inline, &mut spill, &mut rtl);
            assert!(matches!(result, Ok(ControlFlow::Continue(()))));
            std::eprintln!("CAPACITY case={name} spill={} rtl={} requested_payload={}", spill.capacity(), rtl.capacity(), spill.capacity() * size_of::<RunSlot>() + rtl.capacity() * size_of::<f32>());
        }
    }
}
