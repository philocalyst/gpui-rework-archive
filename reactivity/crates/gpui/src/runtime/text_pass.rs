//! Layout-pass handoff: exact borrowed text inputs pin immutable source leases.
//! Slots route work, while exact source bytes and font-size bits authorize reuse.
use super::*;
use gpui_canvas::PreparedText;
use std::collections::HashMap;

const HANDOFFS: usize = 8;
const HANDOFF_TEXT: usize = 256;
const HANDOFF_INPUT: usize = 2048;
const HANDOFF_GLYPHS: usize = 2048;

pub(super) struct TextPass<'font, 'text> {
    shaper: TextShaper<'font>,
    inputs: &'text [Option<SharedText>],
    prepared: HashMap<usize, PreparedText<'text>>,
    selected: TextSlot,
    pub peak: usize,
    capacity_peak: usize,
    minimums: Vec<Option<Minimum>>,
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
            peak: 0,
            capacity_peak: 0,
            minimums: Vec::new(),
        }
    }
    pub fn paragraph_shapes(&self) -> u64 {
        self.shaper.paragraph_shapes()
    }
    fn observe(&mut self) {
        self.peak = self.peak.max(self.prepared.len());
        let mut pending = [[0; 3]; 14];
        for p in self.prepared.values() {
            for (out, row) in pending.iter_mut().zip(p.diagnostic_storage()) {
                for i in 0..3 {
                    out[i] += row[i];
                }
            }
        }
        let (pool, ordinary, pool_len, pool_headers) = self.shaper.diagnostic_storage();
        let bytes = pending.iter().chain(&pool).map(|r| r[2]).sum::<usize>();
        if bytes > self.capacity_peak {
            self.capacity_peak = bytes;
            eprintln!(
                "HANDOFF_CAPACITY bytes={bytes} pending={} peak={} pool_len={pool_len} pool_headers={pool_headers} pending_rows={pending:?} pool_rows={pool:?} ordinary_rows={ordinary:?} input_headers={} fact_headers={} prepared_header={} map_capacity={} pass_header={} input_present={}",
                self.prepared.len(),
                self.peak,
                self.inputs.len() * core::mem::size_of::<Option<SharedText>>(),
                self.minimums.capacity() * core::mem::size_of::<Option<Minimum>>(),
                core::mem::size_of::<PreparedText<'_>>(),
                self.prepared.capacity(),
                core::mem::size_of::<Self>(),
                self.inputs.iter().filter(|input| input.is_some()).count()
            );
        }
    }
    pub fn select(&mut self, slot: TextSlot) {
        self.selected = slot;
    }
    pub fn release(&mut self, slot: TextSlot) {
        if let Some(prepared) = self.prepared.remove(&(slot.0 as usize)) {
            self.shaper.recycle_prepared(prepared);
        }
        self.observe();
    }
    fn input(&self, text: &str) -> Option<&'text str> {
        let input = self.inputs.get(self.selected.0 as usize)?.as_ref()?;
        // A slot routes work; only exact Display/Source bytes authorize reuse.
        (input.as_ref() == text).then_some(input.as_ref())
    }
    fn can_capture(&self, text: &str) -> bool {
        // These are conservative input/glyph budgets, not exact heap-byte
        // accounting. The complete ordinary path handles every rejected input.
        self.prepared.len() < HANDOFFS
            && text.len() <= HANDOFF_TEXT
            && !text
                .chars()
                .any(|c| matches!(c, '\r' | '\n' | '\u{85}' | '\u{2029}'))
            && self
                .prepared
                .values()
                .map(|p| p.text().len())
                .sum::<usize>()
                + text.len()
                <= HANDOFF_INPUT
            && self.pending_glyphs() < HANDOFF_GLYPHS
    }
    fn pending_glyphs(&self) -> usize {
        self.prepared
            .values()
            .map(PreparedText::shaped_glyph_count)
            .sum()
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
        if capture && !self.can_capture(input) {
            eprintln!(
                "HANDOFF_FALLBACK pending={} source_bytes={}",
                self.prepared.len(),
                input.len()
            );
        }
        let metrics = if let Some(prepared) = self.prepared.get_mut(&index)
            && prepared.font_size().to_bits() == size.to_bits()
        {
            self.shaper.measure_prepared(prepared, width)?
        } else if capture && self.can_capture(input) {
            let (prepared, metrics) = self.shaper.prepare(input, size, width)?;
            if self.pending_glyphs() + prepared.shaped_glyph_count() <= HANDOFF_GLYPHS
                && let Some(old) = self.prepared.insert(index, prepared)
            {
                self.shaper.recycle_prepared(old);
            }
            // An oversized completed paragraph drops here instead of entering
            // the pending bank or spare pool. It only loses future reuse.
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
        self.observe();
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
            let result = if prepared.font_size().to_bits() == size.to_bits() {
                self.shaper.shape_prepared(&mut prepared, width)
            } else {
                self.shaper.shape_interactive(text, size, width)
            };
            self.shaper.recycle_prepared(prepared);
            self.observe();
            result
        } else {
            self.shaper.shape_interactive(text, size, width)
        }
    }
}
