use ecow::EcoVec;
const MAX_GLYPHS: usize = 32768;
const MAX_TEXT: usize = 32768;
#[derive(Clone, Copy, Debug)]
struct PackedGlyph { meta: u32, x: f32, baseline: f32 }
mod glyph_buffer;
