//! Layout-pass handoff: exact borrowed text inputs pin immutable source leases.
//! Slots route work, while exact source bytes and font-size bits authorize reuse.
use super::*;
use gpui_canvas::PreparedText;
use std::collections::HashMap;

pub(super) struct TextPass<'font, 'text> {
    shaper: TextShaper<'font>,
    inputs: &'text [Option<SharedText>],
    prepared: HashMap<usize, PreparedText<'text>>,
    selected: TextSlot,
    minimums: Vec<Option<Minimum>>,
    live: usize,
    pub peak: usize,
}
// Frozen input leases and the fixed pass font qualify these numerical facts.
// No strings, font leases, glyphs, or paragraph buffers enter this column.
struct Minimum {
    size: std::num::NonZeroU32,
    metrics: TextMetrics,
}
impl<'font, 'text> TextPass<'font, 'text> {
    pub fn new(shaper: TextShaper<'font>) -> Self {
        Self::with_inputs(shaper, &[])
    }
    pub fn with_inputs(shaper: TextShaper<'font>, inputs: &'text [Option<SharedText>]) -> Self {
        Self {
            shaper,
            inputs,
            prepared: HashMap::new(),
            selected: TextSlot(u32::MAX),
            minimums: Vec::new(),
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
    fn input(&self, text: &str) -> Option<&'text str> {
        let input = self.inputs.get(self.selected.0 as usize)?.as_ref()?;
        // A slot routes work; only exact Display/Source bytes authorize reuse.
        (input.as_ref() == text).then_some(input.as_ref())
    }
    pub fn measure(
        &mut self,
        text: &str,
        size: f32,
        width: Option<f32>,
        capture: bool,
    ) -> Result<TextMetrics, gpui_canvas::Error> {
        let index = self.selected.0 as usize;
        let Some(input) = self.input(text) else {
            return self.shaper.measure(text, size, width);
        };
        let minimum = width.map(f32::to_bits) == Some(f32::MIN_POSITIVE.to_bits());
        if minimum
            && let Some(fact) = self.minimums.get(index).and_then(Option::as_ref)
            && fact.size.get() == size.to_bits()
        {
            return Ok(fact.metrics);
        }
        let metrics = if let Some(prepared) = self.prepared.get_mut(&index)
            && prepared.font_size().to_bits() == size.to_bits()
        {
            self.shaper.measure_prepared(prepared, width)?
        } else if capture {
            let (prepared, metrics) = self.shaper.prepare(input, size, width)?;
            if let Some(old) = self.prepared.insert(index, prepared) {
                self.shaper.recycle_prepared(old);
            } else {
                self.live += 1;
                self.peak = self.peak.max(self.live);
            }
            metrics
        } else {
            self.shaper.measure(text, size, width)?
        };
        if minimum {
            if self.minimums.is_empty() {
                self.minimums.resize_with(self.inputs.len(), || None);
            }
            self.minimums[index] = Some(Minimum {
                size: std::num::NonZeroU32::new(size.to_bits())
                    .expect("admitted positive font size"),
                metrics,
            });
        }
        Ok(metrics)
    }
    pub fn shape_interactive(
        &mut self,
        text: &str,
        size: f32,
        width: Option<f32>,
    ) -> Result<TextLayout, gpui_canvas::Error> {
        let index = self.selected.0 as usize;
        if self.input(text).is_some()
            && let Some(mut prepared) = self.prepared.remove(&index)
        {
            self.live -= 1;
            let result = if prepared.font_size().to_bits() == size.to_bits() {
                self.shaper.shape_prepared(&mut prepared, width)
            } else {
                self.shaper.shape_interactive(text, size, width)
            };
            self.shaper.recycle_prepared(prepared);
            result
        } else {
            self.shaper.shape_interactive(text, size, width)
        }
    }
}
