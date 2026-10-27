#[cfg(test)]
#[allow(dead_code)]
pub(crate) struct CostFixture {
    pub(crate) owner: gpui::Win<Lab>,
    driver: Driver,
    received: std::sync::mpsc::Receiver<()>,
}
#[cfg(test)]
#[allow(dead_code)]
impl CostFixture {
    pub(crate) fn new(case: &str) -> Self {
        let mode = match case {
            "scroll" | "fractional" => Mode::Scroll,
            "both" => Mode::Both,
            "stream" | "stream-owner" | "exposure" => Mode::Stream,
            _ => panic!("unknown complete workload case: {case}"),
        };
        let work = port_tests::seeded(mode);
        let owner = port_tests::window(&work);
        let (delivered, received) = std::sync::mpsc::channel();
        Self { owner, driver: Driver { work, received: 0, delivered }, received }
    }
    pub(crate) fn advance(&mut self, case: &str) {
        if case == "exposure" { return; }
        if case == "stream" {
            let mut value = String::new();
            self.driver.stream(&mut value, false);
            self.owner.set(Lab::STREAM, value).unwrap();
        } else {
            self.owner.update(|model| {
                self.driver.owner(model, false);
                if case == "fractional" { *model.scroll_offset += 0.5; }
            }).unwrap();
        }
        self.received.try_recv().unwrap();
    }
}
