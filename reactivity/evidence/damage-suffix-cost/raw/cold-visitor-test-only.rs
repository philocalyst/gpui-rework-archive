#[cfg(test)]
#[allow(dead_code)]
pub(crate) fn visit_cold_stream_frames(
    mut visit: impl FnMut(&mut gpui::Win<Lab>, &mut gpui::Win<Lab>, bool, usize),
) {
    for owner_route in [false, true] {
        let work = Workload {
            text: String::with_capacity(8256),
            scroll_offset: 0.,
            frames: 0,
            mode: Mode::Stream,
            seconds: 1.,
        };
        let mut window = port_tests::window(&work);
        let (delivered, _received) = std::sync::mpsc::channel();
        let mut driver = Driver {
            work,
            received: 0,
            delivered,
        };
        visit(
            &mut window,
            &mut port_tests::window(&driver.work),
            owner_route,
            0,
        );
        for tick in 1..=24 {
            if owner_route {
                window.update(|model| driver.owner(model, false)).unwrap();
            } else {
                let mut value = String::new();
                driver.stream(&mut value, false);
                window.set(Lab::STREAM, value).unwrap();
            }
            visit(
                &mut window,
                &mut port_tests::window(&driver.work),
                owner_route,
                tick,
            );
        }
    }
}

