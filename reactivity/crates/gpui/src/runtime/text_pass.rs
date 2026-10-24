//! Layout-pass handoff: exact borrowed text inputs pin immutable source leases.
//! Slots route work, while exact source bytes and font-size bits authorize reuse.
use super::*;
use gpui_canvas::PreparedText;

pub(super) struct TextPass<'font, 'text> {
    shaper: TextShaper<'font>,
    inputs: &'text [Option<SharedText>],
    prepared: HashMap<usize, PreparedText<'text>>,
    selected: TextSlot,
    live: usize,
    pub peak: usize,
}
impl<'font, 'text> TextPass<'font, 'text> {
    #[cfg(test)]
    pub fn new(shaper: TextShaper<'font>) -> Self {
        Self::with_inputs(shaper, &[])
    }
    pub fn with_inputs(shaper: TextShaper<'font>, inputs: &'text [Option<SharedText>]) -> Self {
        Self {
            shaper,
            inputs,
            prepared: HashMap::new(),
            selected: TextSlot(u32::MAX),
            live: 0,
            peak: 0,
        }
    }
    pub fn select(&mut self, slot: TextSlot) {
        self.selected = slot;
    }
    pub fn release(&mut self, slot: TextSlot) {
        if let Some(prepared) = self.prepared.remove(&(slot.0 as usize)) {
            self.live -= 1;
            self.shaper.recycle_prepared(prepared);
        }
    }
    pub fn paragraph_shapes(&self) -> u64 {
        self.shaper.paragraph_shapes()
    }
    fn prepare(&mut self, text: &str, size: f32) -> Result<bool, gpui_canvas::Error> {
        let index = self.selected.0 as usize;
        let Some(input) = self.inputs.get(index).and_then(Option::as_ref) else {
            return Ok(false);
        };
        // Identity routes the slot but is not value authority. Display/source
        // disagreement and changed font sizes cannot reuse another paragraph.
        if input.as_ref() != text {
            return Ok(false);
        }
        if self
            .prepared
            .get(&index)
            .is_none_or(|p| p.font_size().to_bits() != size.to_bits())
        {
            let prepared = self.shaper.prepare(input, size)?;
            if !self.prepared.contains_key(&index) {
                self.live += 1;
                self.peak = self.peak.max(self.live);
            }
            if let Some(old) = self.prepared.insert(index, prepared) {
                self.shaper.recycle_prepared(old);
            }
        }
        Ok(true)
    }
    pub fn measure(
        &mut self,
        text: &str,
        size: f32,
        width: Option<f32>,
    ) -> Result<TextMetrics, gpui_canvas::Error> {
        if self.prepare(text, size)? {
            self.shaper.measure_prepared(
                self.prepared.get_mut(&(self.selected.0 as usize)).unwrap(),
                width,
            )
        } else {
            self.shaper.measure(text, size, width)
        }
    }
    pub fn shape_interactive(
        &mut self,
        text: &str,
        size: f32,
        width: Option<f32>,
    ) -> Result<TextLayout, gpui_canvas::Error> {
        if self.prepare(text, size)? {
            let mut prepared = self.prepared.remove(&(self.selected.0 as usize)).unwrap();
            self.live -= 1;
            let result = self.shaper.shape_prepared(&mut prepared, width);
            self.shaper.recycle_prepared(prepared);
            result
        } else {
            self.shaper.shape_interactive(text, size, width)
        }
    }
}
