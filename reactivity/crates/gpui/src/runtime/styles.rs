//! Current-owner resolved styles. A sheet never borrows this mutable lane.
use super::Style;

const PALETTE_LIMIT: usize = 32;
const SMALL_OWNER: usize = 8;
const _: () = assert!(PALETTE_LIMIT <= u8::MAX as usize);

#[derive(Clone, Copy)]
pub(super) struct Entry {
    value: Style,
    users: u32,
}

#[derive(Default)]
pub(super) enum Styles {
    #[default]
    Default,
    Dense(Vec<Style>),
    Shared {
        palette: Box<[Entry]>,
        indices: Box<[u8]>,
    },
}

impl Styles {
    #[inline]
    pub(super) fn get(&self, index: usize) -> &Style {
        match self {
            Self::Default => &Style::DEFAULT,
            Self::Dense(values) => &values[index],
            Self::Shared { palette, indices } => &palette[usize::from(indices[index])].value,
        }
    }

    // Counts belong to patterns, not nodes. A unique pattern mutates in place;
    // shared patterns split into a bounded palette and vacated slots are reused.
    // Only genuinely diverse owners need a dense style lane.
    pub(super) fn set(&mut self, index: usize, value: Style, count: usize) {
        match self {
            Self::Dense(values) => {
                values[index] = value;
                return;
            }
            Self::Default => {
                if exact_eq(&Style::DEFAULT, &value) {
                    return;
                }
                if count > SMALL_OWNER {
                    let mut indices = vec![0; count];
                    indices[index] = 1;
                    *self = Self::Shared {
                        palette: Box::new([
                            Entry {
                                value: Style::DEFAULT,
                                users: u32::try_from(count - 1).unwrap(),
                            },
                            Entry { value, users: 1 },
                        ]),
                        indices: indices.into_boxed_slice(),
                    };
                    return;
                }
            }
            Self::Shared { palette, indices } => {
                let old = usize::from(indices[index]);
                if let Some(next) = palette
                    .iter()
                    .position(|entry| entry.users != 0 && exact_eq(&entry.value, &value))
                {
                    palette[old].users -= 1;
                    palette[next].users += 1;
                    indices[index] = next as u8;
                    return;
                }
                if palette[old].users == 1 {
                    palette[old].value = value;
                    return;
                }
                let next = if let Some(next) = palette.iter().position(|entry| entry.users == 0) {
                    palette[next] = Entry { value, users: 1 };
                    Some(next)
                } else if palette.len() < PALETTE_LIMIT {
                    // Exact capacity avoids a second shrink allocation. This
                    // bounded copy happens only when a live pattern splits.
                    let next = palette.len();
                    let mut expanded = Vec::with_capacity(next + 1);
                    expanded.extend_from_slice(palette);
                    expanded.push(Entry { value, users: 1 });
                    *palette = expanded.into_boxed_slice();
                    Some(next)
                } else {
                    None
                };
                if let Some(next) = next {
                    palette[old].users -= 1;
                    indices[index] = next as u8;
                    return;
                }
            }
        }
        let mut values: Vec<_> = (0..count).map(|index| *self.get(index)).collect();
        values[index] = value;
        *self = Self::Dense(values);
    }
}

enum Building {
    Default,
    Dense(Vec<Style>),
    Shared {
        palette: Vec<Entry>,
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

    // Runtime is instantiated in downstream applications too. Keep this
    // per-node helper available to their optimizer, not just our unit harness.
    #[inline]
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
                    palette.push(Entry {
                        value: Style::default(),
                        users: u32::try_from(self.count).unwrap(),
                    });
                    indices.resize(self.count, 0);
                }
                Building::Shared { palette, indices }
            };
        }
        match &mut self.mode {
            Building::Default => {}
            Building::Dense(values) => values.push(*style),
            Building::Shared { palette, indices } => {
                if let Some(index) = palette
                    .iter()
                    .position(|entry| exact_eq(&entry.value, style))
                {
                    palette[index].users += 1;
                    indices.push(index as u8);
                } else if palette.len() < PALETTE_LIMIT {
                    indices.push(palette.len() as u8);
                    palette.push(Entry {
                        value: *style,
                        users: 1,
                    });
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
                let shared = palette.len() * size_of::<Entry>() + indices.len();
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

fn dense(palette: &[Entry], indices: &[u8], capacity: usize) -> Vec<Style> {
    let mut values = Vec::with_capacity(capacity);
    values.extend(
        indices
            .iter()
            .map(|&index| palette[usize::from(index)].value),
    );
    values
}

// Numerical equality intentionally treats signed zero as equal. Interning has
// the stronger obligation to retain the exact authored channels and profile.
#[inline]
pub(super) fn exact_eq(a: &Style, b: &Style) -> bool {
    use crate::property::ExactValue;
    Option::<f32>::same(&a.width, &b.width)
        && Option::<f32>::same(&a.height, &b.height)
        && f32::same(&a.gap, &b.gap)
        && f32::same(&a.padding, &b.padding)
        && f32::same(&a.font_size, &b.font_size)
        && crate::Flow::same(&a.flow, &b.flow)
        && crate::Align::same(&a.align, &b.align)
        && crate::Justify::same(&a.justify, &b.justify)
        && bool::same(&a.wrap, &b.wrap)
        && crate::Affine::same(&a.transform, &b.transform)
        && crate::Color::same(&a.fg, &b.fg)
        && crate::Color::same(&a.bg, &b.bg)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{Align, Color, Flow, Justify};

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
    fn independent_edits_keep_shared_peers_and_reuse_their_unique_slot() {
        for mut lane in [
            build([Style::default(); 128], 128),
            build((0..128).map(|i| numbered(i % 2)), 128),
        ] {
            let old = *lane.get(17);
            lane.set(16, numbered(99), 128);
            assert!(exact_eq(lane.get(17), &old));
            assert!(matches!(lane, Styles::Shared { .. }));
            let allocation = allocation_counter::measure(|| {
                for value in 100..1_000 {
                    lane.set(16, numbered(value), 128);
                }
            });
            assert_eq!(allocation.count_total, 0);
            assert!(exact_eq(lane.get(16), &numbered(999)));
            assert_counts(&lane);
        }
    }

    fn assert_counts(lane: &Styles) {
        if let Styles::Shared { palette, indices } = lane {
            for (index, entry) in palette.iter().enumerate() {
                assert_eq!(
                    entry.users as usize,
                    indices.iter().filter(|&&i| i as usize == index).count()
                );
            }
        }
    }

    #[test]
    fn changing_an_entire_shared_cohort_reuses_vacated_patterns_without_allocating() {
        let count = 128;
        let mut lane = build([numbered(1); 128], count);
        for index in 0..count {
            lane.set(index, numbered(2), count);
        }
        let allocations = allocation_counter::measure(|| {
            for frame in 3..100 {
                for index in 0..count {
                    lane.set(index, numbered(frame), count);
                }
            }
        });
        assert_eq!(allocations.count_total, 0);
        let Styles::Shared { palette, .. } = &lane else {
            panic!("shared cohort densified")
        };
        assert_eq!(palette.len(), 2);
        for index in 0..count {
            assert!(exact_eq(lane.get(index), &numbered(99)));
        }
        assert_counts(&lane);
    }

    #[test]
    fn only_live_pattern_diversity_overflows_to_dense_storage() {
        let count = 128;
        let mut lane = build([numbered(1); 128], count);
        let mut expected = [numbered(1); 128];
        for index in 0..PALETTE_LIMIT {
            expected[index] = numbered(index + 2);
            lane.set(index, expected[index], count);
            for (index, value) in expected.iter().enumerate() {
                assert!(exact_eq(lane.get(index), value));
            }
            assert_counts(&lane);
        }
        assert!(matches!(lane, Styles::Dense(_)));
    }

    #[test]
    fn mutable_palette_matches_a_dense_oracle_through_split_merge_and_slot_reuse() {
        let count = 128;
        let mut lane = build((0..count).map(|i| numbered(i % 8)), count);
        let mut expected: Vec<_> = (0..count).map(|i| numbered(i % 8)).collect();
        for turn in 0..2_000usize {
            let index = (turn * 73) % count;
            let mut value = numbered((turn * 17) % 12);
            value.gap = if turn % 2 == 0 { -0.0 } else { 0.0 };
            expected[index] = value;
            lane.set(index, value, count);
            for (index, value) in expected.iter().enumerate() {
                assert!(exact_eq(lane.get(index), value));
            }
            assert_counts(&lane);
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
        let mut changes = [base; 18];
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
        changes[15].align = Align::End;
        changes[16].justify = Justify::End;
        changes[17].wrap = true;
        assert!(changes.into_iter().all(|value| !exact_eq(&base, &value)));
    }

    #[test]
    fn style_lane_allocation_ledger() {
        assert_eq!(size_of::<Styles>(), 40);
        println!("style_entry,bytes={}", size_of::<Entry>());
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
        for (label, period) in [("default", 0), ("shared", 8)] {
            let count = 4096;
            let mut lane = build(
                (0..count).map(|i| {
                    if period == 0 {
                        Style::default()
                    } else {
                        numbered(i % period)
                    }
                }),
                count,
            );
            let allocation = allocation_counter::measure(|| lane.set(0, numbered(99), count));
            let live = match &lane {
                Styles::Default => 0,
                Styles::Dense(values) => values.capacity() * size_of::<Style>(),
                Styles::Shared { palette, indices } => {
                    size_of_val(palette.as_ref()) + size_of_val(indices.as_ref())
                }
            };
            println!(
                "style_mutation,{label},nodes={count},allocations={},requested_bytes={},live_bytes={live},peak_bytes={}",
                allocation.count_total, allocation.bytes_total, allocation.bytes_max
            );
            assert_counts(&lane);
        }
    }
}
