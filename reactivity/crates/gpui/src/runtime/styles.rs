//! Current-owner resolved styles. A sheet never borrows this mutable lane.
use super::Style;

const PALETTE_LIMIT: usize = 32;
const SMALL_OWNER: usize = 8;
const _: () = assert!(PALETTE_LIMIT <= u8::MAX as usize);

#[derive(Default)]
pub(super) enum Styles {
    #[default]
    Default,
    Dense(Vec<Style>),
    Shared {
        palette: Box<[Style]>,
        indices: Box<[u8]>,
    },
}

impl Styles {
    #[inline]
    pub(super) fn get(&self, index: usize) -> &Style {
        match self {
            Self::Default => &Style::DEFAULT,
            Self::Dense(values) => &values[index],
            Self::Shared { palette, indices } => &palette[usize::from(indices[index])],
        }
    }

    // Inspector contributions are independent mutations. Densify once rather
    // than keep dead palette entries or a second mutable interning protocol.
    pub(super) fn set(&mut self, index: usize, value: Style, count: usize) {
        if !matches!(self, Self::Dense(_)) {
            *self = Self::Dense((0..count).map(|index| *self.get(index)).collect());
        }
        let Self::Dense(values) = self else {
            unreachable!()
        };
        values[index] = value;
    }
}

enum Building {
    Default,
    Dense(Vec<Style>),
    Shared {
        palette: Vec<Style>,
        indices: Vec<u8>,
    },
}

pub(super) struct Builder {
    count: usize,
    total: usize,
    mode: Building,
}

impl Builder {
    pub(super) fn new(total: usize) -> Self {
        Self {
            count: 0,
            total,
            mode: Building::Default,
        }
    }

    pub(super) fn push(&mut self, style: &Style) {
        if matches!(self.mode, Building::Default) && !exact_eq(style, &Style::DEFAULT) {
            self.mode = if self.total <= SMALL_OWNER {
                let mut values = Vec::with_capacity(self.total);
                values.resize(self.count, Style::default());
                Building::Dense(values)
            } else {
                let mut palette = Vec::with_capacity(PALETTE_LIMIT);
                let mut indices = Vec::with_capacity(self.total);
                if self.count != 0 {
                    palette.push(Style::default());
                    indices.resize(self.count, 0);
                }
                Building::Shared { palette, indices }
            };
        }
        match &mut self.mode {
            Building::Default => {}
            Building::Dense(values) => values.push(*style),
            Building::Shared { palette, indices } => {
                if let Some(index) = palette.iter().position(|value| exact_eq(value, style)) {
                    indices.push(index as u8);
                } else if palette.len() < PALETTE_LIMIT {
                    indices.push(palette.len() as u8);
                    palette.push(*style);
                } else {
                    let mut values = dense(palette, indices, self.total);
                    values.push(*style);
                    self.mode = Building::Dense(values);
                }
            }
        }
        self.count += 1;
    }

    pub(super) fn finish(self) -> Styles {
        debug_assert_eq!(self.count, self.total);
        match self.mode {
            Building::Default => Styles::Default,
            Building::Dense(values) => Styles::Dense(values),
            Building::Shared { palette, indices } => {
                // Require a material saving; nearly unique small trees use a
                // direct lane, with no selector load during layout or paint.
                let shared = palette.len() * size_of::<Style>() + indices.len();
                if shared * 4 >= self.total * size_of::<Style>() * 3 {
                    Styles::Dense(dense(&palette, &indices, self.total))
                } else {
                    Styles::Shared {
                        palette: palette.into_boxed_slice(),
                        indices: indices.into_boxed_slice(),
                    }
                }
            }
        }
    }
}

fn dense(palette: &[Style], indices: &[u8], capacity: usize) -> Vec<Style> {
    let mut values = Vec::with_capacity(capacity);
    values.extend(indices.iter().map(|&index| palette[usize::from(index)]));
    values
}

// Numerical equality intentionally treats signed zero as equal. Interning has
// the stronger obligation to retain the exact authored channels and profile.
#[inline]
fn exact_eq(a: &Style, b: &Style) -> bool {
    a.width.map(f32::to_bits) == b.width.map(f32::to_bits)
        && a.height.map(f32::to_bits) == b.height.map(f32::to_bits)
        && a.gap.to_bits() == b.gap.to_bits()
        && a.padding.to_bits() == b.padding.to_bits()
        && a.font_size.to_bits() == b.font_size.to_bits()
        && a.flow == b.flow
        && a.transform.a.to_bits() == b.transform.a.to_bits()
        && a.transform.b.to_bits() == b.transform.b.to_bits()
        && a.transform.c.to_bits() == b.transform.c.to_bits()
        && a.transform.d.to_bits() == b.transform.d.to_bits()
        && a.transform.tx.to_bits() == b.transform.tx.to_bits()
        && a.transform.ty.to_bits() == b.transform.ty.to_bits()
        && a.fg.space() == b.fg.space()
        && a.fg.channels().map(f32::to_bits) == b.fg.channels().map(f32::to_bits)
        && a.bg.space() == b.bg.space()
        && a.bg.channels().map(f32::to_bits) == b.bg.channels().map(f32::to_bits)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{Color, Flow};

    fn build(values: impl IntoIterator<Item = Style>, count: usize) -> Styles {
        let mut builder = Builder::new(count);
        for value in values {
            builder.push(&value);
        }
        builder.finish()
    }

    fn numbered(index: usize) -> Style {
        Style {
            width: Some(index as f32),
            ..Style::default()
        }
    }

    #[test]
    fn storage_modes_and_overflow_preserve_every_admitted_style() {
        assert!(matches!(build([], 0), Styles::Default));
        assert!(matches!(
            build([Style::default(); 512], 512),
            Styles::Default
        ));
        assert!(matches!(build((0..3).map(numbered), 3), Styles::Dense(_)));
        assert!(matches!(
            build((0..512).map(|i| numbered(i % 8)), 512),
            Styles::Shared { .. }
        ));
        for count in [9, 32, 33, 100, super::super::MAX_NODES] {
            let lane = build((0..count).map(numbered), count);
            assert!(matches!(lane, Styles::Dense(_)));
            for index in 0..count {
                assert!(exact_eq(lane.get(index), &numbered(index)));
            }
        }
    }

    #[test]
    fn shared_values_preserve_author_channels_profiles_and_signed_zero() {
        let mut values = vec![Style::default(); 8];
        values[1].gap = -0.0;
        values[2].width = Some(0.0);
        values[3].transform.b = -0.0;
        values[4].fg = Color::linear_srgb(-0.0, 0.0, 0.0, 1.0).unwrap();
        values[5].fg = Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap();
        values[6].fg = Color::display_p3(0.0, 0.0, 0.0, 1.0).unwrap();
        values[7].bg = Color::linear_display_p3(-0.5, 2.0, 0.25, 0.5).unwrap();
        let lane = build((0..512).map(|i| values[i % values.len()]), 512);
        let Styles::Shared { palette, indices } = &lane else {
            panic!("expected shared styles")
        };
        assert_eq!(palette.len(), values.len());
        assert_eq!(indices.len(), 512);
        for index in 0..512 {
            assert!(exact_eq(lane.get(index), &values[index % values.len()]));
        }
    }

    #[test]
    fn inspector_edits_densify_once_and_do_not_mutate_shared_peers() {
        for mut lane in [
            build([Style::default(); 128], 128),
            build((0..128).map(|i| numbered(i % 2)), 128),
        ] {
            let old = *lane.get(17);
            lane.set(16, numbered(99), 128);
            assert!(exact_eq(lane.get(17), &old));
            let Styles::Dense(values) = &lane else {
                unreachable!()
            };
            let pointer = values.as_ptr();
            lane.set(16, numbered(100), 128);
            let Styles::Dense(values) = &lane else {
                unreachable!()
            };
            assert_eq!(pointer, values.as_ptr());
            assert!(exact_eq(lane.get(16), &numbered(100)));
        }
    }

    #[test]
    fn rebuilt_lanes_keep_no_historical_style_palette() {
        let mut lane = build((0..256).map(numbered), 256);
        for frame in 1..100 {
            lane = build((0..256).map(|i| numbered(i + frame * 256)), 256);
            let Styles::Dense(values) = &lane else {
                unreachable!()
            };
            assert_eq!(values.capacity(), 256);
        }
        drop(lane);
        let lane = build([Style::default(); 4], 4);
        assert!(matches!(lane, Styles::Default));
    }

    #[test]
    fn late_palette_overflow_and_late_nondefault_prefix_preserve_all_values() {
        let count = 4096;
        let value = |index| numbered(if index == count - 1 { 33 } else { index % 32 });
        let lane = build((0..count).map(value), count);
        assert!(matches!(lane, Styles::Dense(_)));
        for index in 0..count {
            assert!(exact_eq(lane.get(index), &value(index)));
        }
        let value = |index| {
            if index == count - 1 {
                numbered(7)
            } else {
                Style::default()
            }
        };
        let lane = build((0..count).map(value), count);
        assert!(matches!(lane, Styles::Shared { .. }));
        for index in 0..count {
            assert!(exact_eq(lane.get(index), &value(index)));
        }
    }

    #[test]
    fn exact_comparison_covers_every_style_field() {
        let base = Style::default();
        let mut changes = [base; 15];
        changes[0].width = Some(0.0);
        changes[1].height = Some(0.0);
        changes[2].gap = -0.0;
        changes[3].padding = -0.0;
        changes[4].font_size = 17.0;
        changes[5].flow = Flow::Row;
        changes[6].transform.a = 2.0;
        changes[7].transform.b = -0.0;
        changes[8].transform.c = -0.0;
        changes[9].transform.d = 2.0;
        changes[10].transform.tx = -0.0;
        changes[11].transform.ty = -0.0;
        changes[12].fg = Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap();
        changes[13].bg = Color::linear_srgb(0.0, 0.0, 0.0, 0.0).unwrap();
        changes[14].bg = Color::rgba(1, 0, 0, 0);
        assert!(changes.into_iter().all(|value| !exact_eq(&base, &value)));
    }

    #[test]
    fn style_lane_allocation_ledger() {
        assert_eq!(size_of::<Styles>(), 40);
        for (label, count, period) in [
            ("default", 4096, 0),
            ("small", 3, 3),
            ("shared", 4096, 8),
            ("unique", 4096, 4096),
        ] {
            let mut lane = None;
            let allocation = allocation_counter::measure(|| {
                lane = Some(build(
                    (0..count).map(|i| {
                        if period == 0 {
                            Style::default()
                        } else {
                            numbered(i % period)
                        }
                    }),
                    count,
                ));
            });
            let bytes = match lane.as_ref().unwrap() {
                Styles::Default => 0,
                Styles::Dense(values) => values.capacity() * size_of::<Style>(),
                Styles::Shared { palette, indices } => {
                    size_of_val(palette.as_ref()) + size_of_val(indices.as_ref())
                }
            };
            println!(
                "style_lane,{label},nodes={count},allocations={},requested_bytes={},live_bytes={bytes},peak_bytes={}",
                allocation.count_total, allocation.bytes_total, allocation.bytes_max
            );
            if period == 0 {
                assert_eq!(allocation.count_total, 0);
            }
        }
    }
}
