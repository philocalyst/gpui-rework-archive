//! Owner-authoring colors, distinct from the complete Canvas working bank.
//!
//! A source slot is a relationship, never a deduplicated current value. Two
//! different qualified fields remain distinct even when their colors compare
//! equal. Literal values may share exact authoring bits; implicit defaults need
//! neither a slot allocation nor a source registration.
use super::super::{Destination, Fanout, FieldId, Style};
use crate::{Affine, Align, Color, Flow, Justify, Length};
use gpui_canvas::{PaintColor, PaintSlot};
use std::collections::BTreeMap;

const SOURCE: u32 = 1 << 31;
const DEFAULT_FG: Slot = Slot(0);
const DEFAULT_BG: Slot = Slot(1);
const BLACK: Slot = Slot(2);
const WHITE: Slot = Slot(3);
const TRANSPARENT: Slot = Slot(4);
const FIRST_LITERAL: u32 = 5;
const LITERAL_SEARCH: usize = 32;

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(in crate::runtime) struct Slot(u32);
impl Slot {
    fn source(index: usize) -> Self {
        // At most two distinct color sources are admitted per logical node.
        assert!(index < SOURCE as usize);
        Self(SOURCE | index as u32)
    }
    pub(in crate::runtime) fn source_code(self) -> u32 {
        assert!(self.0 & SOURCE != 0);
        self.0
    }
    pub(in crate::runtime) fn from_source_code(code: u32) -> Option<Self> {
        if code == 0 {
            None
        } else {
            assert!(code & SOURCE != 0);
            Some(Self(code))
        }
    }
    fn source_index(self) -> Option<usize> {
        (self.0 & SOURCE != 0).then_some((self.0 & !SOURCE) as usize)
    }
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(in crate::runtime) struct Pair {
    pub(in crate::runtime) fg: Slot,
    pub(in crate::runtime) bg: Slot,
}
impl Default for Pair {
    fn default() -> Self {
        Self {
            fg: DEFAULT_FG,
            bg: DEFAULT_BG,
        }
    }
}
impl Pair {
    fn sources(self) -> impl Iterator<Item = usize> {
        [self.fg.source_index(), self.bg.source_index()]
            .into_iter()
            .enumerate()
            .filter_map(move |(port, index)| index.filter(|_| port == 0 || self.bg != self.fg))
    }
}

pub(in crate::runtime) struct SourceColor {
    field: FieldId,
    value: Color,
    working: PaintColor,
    canvas: Option<PaintSlot>,
    // Count nodes, not ports: one node bound in FG and BG is counted once.
    users: u32,
}
#[derive(Default)]
pub(in crate::runtime) struct Bank {
    sources: Vec<SourceColor>,
    literals: Vec<Color>,
}
impl Bank {
    pub(in crate::runtime) fn literal_code(&self, code: u32) -> Color {
        assert!(code < SOURCE);
        self.get(Slot(code))
    }
    pub(in crate::runtime) fn get(&self, slot: Slot) -> Color {
        if let Some(index) = slot.source_index() {
            return self.sources[index].value;
        }
        match slot {
            DEFAULT_FG => Style::DEFAULT.fg,
            DEFAULT_BG => Style::DEFAULT.bg,
            BLACK => Color::BLACK,
            TRANSPARENT => Color::TRANSPARENT,
            WHITE => Color::WHITE,
            Slot(index) => self.literals[(index - FIRST_LITERAL) as usize],
        }
    }
    pub(in crate::runtime) fn literal(&mut self, color: Color) -> Slot {
        for (slot, value) in [
            (DEFAULT_FG, Style::DEFAULT.fg),
            (DEFAULT_BG, Style::DEFAULT.bg),
            (BLACK, Color::BLACK),
            (TRANSPARENT, Color::TRANSPARENT),
            (WHITE, Color::WHITE),
        ] {
            if color.same_authoring(value) {
                return slot;
            }
        }
        // Discovery is bounded. Unique literal colors never cause a quadratic
        // scan or retain a second hash table beside the canonical values.
        if let Some(index) = self
            .literals
            .iter()
            .take(LITERAL_SEARCH)
            .position(|value| color.same_authoring(*value))
        {
            return Slot(FIRST_LITERAL + index as u32);
        }
        assert!(self.literals.len() < (SOURCE - FIRST_LITERAL) as usize);
        let slot = Slot(FIRST_LITERAL + self.literals.len() as u32);
        self.literals.push(color);
        slot
    }
    pub(in crate::runtime) fn colors(&self, pair: Pair) -> (Color, Color) {
        (self.get(pair.fg), self.get(pair.bg))
    }
    pub(in crate::runtime) fn change_users(&mut self, previous: Pair, next: Pair) {
        for index in previous.sources() {
            self.sources[index].users -= 1;
        }
        for index in next.sources() {
            self.sources[index].users += 1;
        }
    }
    pub(in crate::runtime) fn add_user(&mut self, pair: Pair) {
        for index in pair.sources() {
            self.sources[index].users += 1;
        }
    }
    /// One write regardless of the number of styles, declarations or masked
    /// inspector bases that refer to this source. No callback executes here.
    pub(in crate::runtime) fn update(&mut self, slot: Slot, color: Color) -> Option<Change> {
        let entry = &mut self.sources[slot.source_index().expect("source field slot")];
        if entry.value.same_authoring(color) {
            return None;
        }
        let previous = entry.working;
        entry.value = color;
        entry.working = PaintColor::new(color);
        Some(Change {
            users: entry.users,
            previous,
            value: entry.working,
            canvas: entry.canvas,
        })
    }
}

pub(in crate::runtime) struct Change {
    pub(in crate::runtime) users: u32,
    pub(in crate::runtime) previous: PaintColor,
    pub(in crate::runtime) value: PaintColor,
    pub(in crate::runtime) canvas: Option<PaintSlot>,
}
/// Source discovery is transient. It disappears when the ordinary static
/// fanout receives the resulting slot; no second retained FieldId map is needed.
#[derive(Default)]
pub(in crate::runtime) struct Discovery {
    pub(in crate::runtime) bank: Bank,
    fields: BTreeMap<FieldId, Slot>,
    ports: Vec<Binding>,
}
// Reuse the checked destination encoding instead of introducing another packed
// node/port format. This vector is transient and contains only registered colors.
struct Binding {
    destination: Destination,
    slot: Slot,
}
impl Discovery {
    pub(in crate::runtime) fn literal_code(&mut self, color: Color) -> u32 {
        self.bank.literal(color).0
    }
    pub(in crate::runtime) fn register(&mut self, field: FieldId, value: Color) -> Slot {
        *self.fields.entry(field).or_insert_with(|| {
            let slot = Slot::source(self.bank.sources.len());
            self.bank.sources.push(SourceColor {
                field,
                value,
                working: PaintColor::new(value),
                canvas: None,
                users: 0,
            });
            slot
        })
    }
    /// A recipe has its own bounded mutable slot even when its true source field
    /// also feeds other recipes. These entries never become field-wide fanouts.
    pub(in crate::runtime) fn mapped(&mut self, field: FieldId, value: Color) -> Slot {
        let slot = Slot::source(self.bank.sources.len());
        self.bank.sources.push(SourceColor {
            field,
            value,
            working: PaintColor::new(value),
            canvas: None,
            users: 0,
        });
        slot
    }
    pub(in crate::runtime) fn mapped_port(&mut self, destination: Destination, slot: Slot) {
        self.ports.push(Binding { destination, slot });
    }
    /// Fanout already owns every resolved typed destination. Freeze only its
    /// color subset into one exactly sized sparse allocation, then sort once.
    pub(in crate::runtime) fn capture(&mut self, fanout: &BTreeMap<FieldId, Fanout>) {
        let count = self
            .fields
            .keys()
            .map(|id| fanout[id].destinations().len())
            .sum();
        let mut ports = std::mem::take(&mut self.ports);
        ports.reserve_exact(count);
        for (&field, &slot) in &self.fields {
            ports.extend(
                fanout[&field]
                    .destinations()
                    .iter()
                    .map(|&destination| Binding { destination, slot }),
            );
        }
        ports.sort_unstable_by_key(|binding| binding.destination.packed());
        debug_assert!(
            ports
                .windows(2)
                .all(|pair| pair[0].destination.packed() < pair[1].destination.packed())
        );
        self.ports = ports;
    }
    fn bindings(&self, node: usize) -> [Option<Slot>; 2] {
        let first = self
            .ports
            .partition_point(|binding| binding.destination.node() < node);
        let mut slots = [None; 2];
        for binding in self.ports[first..]
            .iter()
            .take_while(|binding| binding.destination.node() == node)
        {
            let port = match binding.destination.property() {
                Some(crate::property::PropertyId::Foreground) => 0,
                Some(crate::property::PropertyId::Background) => 1,
                _ => unreachable!("registered color fanout contains only FG/BG"),
            };
            slots[port] = Some(binding.slot);
        }
        slots
    }
    #[cfg(test)]
    fn bind(&mut self, field: FieldId, node: usize, foreground: bool, value: Color) {
        let slot = self.register(field, value);
        let destination = Destination::style(
            node,
            if foreground {
                crate::property::PropertyId::Foreground
            } else {
                crate::property::PropertyId::Background
            },
        );
        // Unit producers mirror flattened node-major order; production freezes
        // the existing field-major fanouts with capture instead.
        assert!(
            self.ports
                .last()
                .is_none_or(|old| old.destination.packed() < destination.packed())
        );
        self.ports.push(Binding { destination, slot });
    }
    pub(in crate::runtime) fn is_empty(&self) -> bool {
        self.bank.sources.is_empty()
    }
    pub(in crate::runtime) fn binding_fields(&self, node: usize) -> [Option<FieldId>; 2] {
        self.bindings(node)
            .map(|slot| slot.map(|slot| self.bank.sources[slot.source_index().unwrap()].field))
    }
    pub(in crate::runtime) fn fields(&self) -> impl Iterator<Item = (FieldId, Slot)> + '_ {
        self.fields.iter().map(|(&field, &slot)| (field, slot))
    }
    pub(in crate::runtime) fn declaration(&mut self, node: usize, style: &Style) -> Pair {
        let [foreground, background] = self.bindings(node);
        Pair {
            fg: foreground.unwrap_or_else(|| self.bank.literal(style.fg)),
            bg: background.unwrap_or_else(|| self.bank.literal(style.bg)),
        }
    }
}

/// Retained geometry/layout values exclude both 16-byte author colors. Public
/// Style stays the ordinary authored value; reconstructing it is a borrowed
/// owner read, never mutation or a second retained resolved copy.
#[derive(Clone, Copy)]
pub(in crate::runtime) struct LayoutStyle {
    width: Length,
    height: Length,
    gap: f32,
    padding: f32,
    font_size: f32,
    flow: Flow,
    align: Align,
    justify: Justify,
    wrap: bool,
    transform: Affine,
}
impl LayoutStyle {
    pub(in crate::runtime) const fn from_style(value: Style) -> Self {
        Self {
            width: value.width,
            height: value.height,
            gap: value.gap,
            padding: value.padding,
            font_size: value.font_size,
            flow: value.flow,
            align: value.align,
            justify: value.justify,
            wrap: value.wrap,
            transform: value.transform,
        }
    }
    pub(in crate::runtime) fn resolve(self, bank: &Bank, pair: Pair) -> Style {
        let (fg, bg) = bank.colors(pair);
        Style {
            width: self.width,
            height: self.height,
            gap: self.gap,
            padding: self.padding,
            font_size: self.font_size,
            fg,
            bg,
            flow: self.flow,
            align: self.align,
            justify: self.justify,
            wrap: self.wrap,
            transform: self.transform,
        }
    }
    pub(in crate::runtime) fn same(self, other: Self) -> bool {
        use crate::property::ExactValue;
        Length::same(&self.width, &other.width)
            && Length::same(&self.height, &other.height)
            && f32::same(&self.gap, &other.gap)
            && f32::same(&self.padding, &other.padding)
            && f32::same(&self.font_size, &other.font_size)
            && Flow::same(&self.flow, &other.flow)
            && Align::same(&self.align, &other.align)
            && Justify::same(&self.justify, &other.justify)
            && bool::same(&self.wrap, &other.wrap)
            && Affine::same(&self.transform, &other.transform)
    }
}
#[derive(Clone, Copy)]
pub(in crate::runtime) struct Record {
    pub(in crate::runtime) layout: LayoutStyle,
    pub(in crate::runtime) declared: Pair,
    pub(in crate::runtime) effective: Pair,
}
impl Record {
    pub(in crate::runtime) fn resolve(self, bank: &Bank) -> Style {
        self.layout.resolve(bank, self.effective)
    }
    pub(in crate::runtime) fn same(self, other: Self) -> bool {
        self.declared == other.declared
            && self.effective == other.effective
            && self.layout.same(other.layout)
    }
}

impl super::Value for Record {
    const DEFAULT: Self = Self {
        layout: LayoutStyle::from_style(Style::DEFAULT),
        declared: Pair {
            fg: DEFAULT_FG,
            bg: DEFAULT_BG,
        },
        effective: Pair {
            fg: DEFAULT_FG,
            bg: DEFAULT_BG,
        },
    };
    fn same(&self, other: &Self) -> bool {
        (*self).same(*other)
    }
}

pub(in crate::runtime) struct Bound {
    records: super::Lane<Record>,
    pub(in crate::runtime) bank: Bank,
    #[cfg(feature = "native-core")]
    pub(in crate::runtime) transition: Option<super::super::paint::SlotTransition>,
}
impl Bound {
    pub(in crate::runtime) fn literal_code(&self, code: u32) -> Color {
        self.bank.literal_code(code)
    }
    #[cfg(test)]
    pub(in crate::runtime) fn bytes(&self) -> usize {
        size_of::<Self>()
            + self.records.bytes()
            + self.bank.sources.capacity() * size_of::<SourceColor>()
            + self.bank.literals.capacity() * size_of::<Color>()
    }
    pub(in crate::runtime) fn get(&self, index: usize) -> Style {
        self.records.get(index).resolve(&self.bank)
    }
    pub(in crate::runtime) fn reset_canvas_slots(&mut self) {
        for source in &mut self.bank.sources {
            source.canvas = None;
        }
    }
    pub(in crate::runtime) fn shared_paint(
        &mut self,
        index: usize,
        foreground: bool,
    ) -> Option<(PaintColor, &mut Option<PaintSlot>)> {
        let pair = self.records.get(index).effective;
        let slot = if foreground { pair.fg } else { pair.bg };
        let index = slot.source_index()?;
        let source = &mut self.bank.sources[index];
        Some((source.working, &mut source.canvas))
    }
    pub(in crate::runtime) fn binding_fields(&self, index: usize) -> [Option<FieldId>; 2] {
        let pair = self.records.get(index).declared;
        [pair.fg, pair.bg].map(|slot| slot.source_index().map(|i| self.bank.sources[i].field))
    }
    pub(in crate::runtime) fn declared_colors(&self, index: usize) -> (Color, Color) {
        self.bank.colors(self.records.get(index).declared)
    }
    pub(in crate::runtime) fn set(&mut self, index: usize, value: Style, count: usize) {
        let mut record = self.records.get(index);
        let previous = record.resolve(&self.bank);
        let old = record.effective;
        if !previous.fg.same_authoring(value.fg) {
            record.effective.fg = self.bank.literal(value.fg);
        }
        if !previous.bg.same_authoring(value.bg) {
            record.effective.bg = self.bank.literal(value.bg);
        }
        record.layout = LayoutStyle::from_style(value);
        self.bank.change_users(old, record.effective);
        self.records.set(index, record, count);
    }
    pub(in crate::runtime) fn contribution(
        &mut self,
        index: usize,
        id: crate::property::PropertyId,
        value: Style,
        explicit: bool,
        count: usize,
    ) -> bool {
        use crate::property::PropertyId;
        if !matches!(id, PropertyId::Foreground | PropertyId::Background) {
            return false;
        }
        let mut record = self.records.get(index);
        let old = record.effective;
        if id == PropertyId::Foreground {
            record.effective.fg = if explicit {
                self.bank.literal(value.fg)
            } else {
                record.declared.fg
            };
        } else {
            record.effective.bg = if explicit {
                self.bank.literal(value.bg)
            } else {
                record.declared.bg
            };
        }
        self.bank.change_users(old, record.effective);
        self.records.set(index, record, count);
        old != record.effective
    }
}

pub(in crate::runtime) struct Builder {
    records: super::LaneBuilder<Record>,
    discovery: Discovery,
}
impl Builder {
    pub(in crate::runtime) fn new(total: usize, discovery: Discovery) -> Self {
        Self {
            records: super::LaneBuilder::new(total),
            discovery,
        }
    }
    pub(in crate::runtime) fn binding_fields(&self, node: usize) -> [Option<FieldId>; 2] {
        self.discovery.binding_fields(node)
    }
    pub(in crate::runtime) fn push(
        &mut self,
        node: usize,
        declared: Style,
        resolved: Style,
        mask: u8,
    ) {
        let pair = self.discovery.declaration(node, &declared);
        let effective = Pair {
            fg: if mask & 1 != 0 {
                self.discovery.bank.literal(resolved.fg)
            } else {
                pair.fg
            },
            bg: if mask & 2 != 0 {
                self.discovery.bank.literal(resolved.bg)
            } else {
                pair.bg
            },
        };
        self.discovery.bank.add_user(effective);
        self.records.push(Record {
            layout: LayoutStyle::from_style(resolved),
            declared: pair,
            effective,
        });
    }
    pub(in crate::runtime) fn finish(self) -> Bound {
        Bound {
            records: self.records.finish(),
            bank: self.discovery.bank,
            #[cfg(feature = "native-core")]
            transition: None,
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::property::PropertyId;

    #[test]
    fn existing_fanouts_freeze_one_sparse_port_allocation_and_both_fields() {
        assert_eq!(size_of::<Binding>(), 8);
        let mut discovery = Discovery::default();
        let foreground = FieldId::new(1);
        let background = FieldId::new(2);
        discovery.register(foreground, Color::BLACK);
        discovery.register(background, Color::WHITE);
        let mut fanout = BTreeMap::new();
        for (field, property) in [
            (foreground, PropertyId::Foreground),
            (background, PropertyId::Background),
        ] {
            let entry = fanout.entry(field).or_insert_with(|| {
                Fanout::new(super::super::super::TextCodec::for_style::<Color>())
            });
            for node in (0..4096).rev() {
                entry
                    .destinations_mut()
                    .push(Destination::style(node * 2, property));
            }
        }
        let allocation = allocation_counter::measure(|| discovery.capture(&fanout));
        assert_eq!(allocation.count_total, 1);
        assert_eq!(allocation.bytes_total, (8192 * size_of::<Binding>()) as u64);
        assert_eq!(discovery.ports.capacity(), 8192);
        for node in 0..8192 {
            assert_eq!(
                discovery.binding_fields(node),
                if node % 2 == 0 {
                    [Some(foreground), Some(background)]
                } else {
                    [None; 2]
                }
            );
        }
        let mut empty = Discovery::default();
        let allocation = allocation_counter::measure(|| empty.capture(&fanout));
        assert_eq!((allocation.count_total, allocation.bytes_total), (0, 0));
        assert!(empty.ports.is_empty());
    }

    #[test]
    fn sparse_port_storage_compares_exact_old_map_and_paired_payloads() {
        for nodes in [1, 16, 4096] {
            for dual in [false, true] {
                let mut discovery = Discovery::default();
                let field = FieldId::new(1);
                let slot = discovery.register(field, Color::BLACK);
                let mut fanout = BTreeMap::new();
                let entry = fanout.entry(field).or_insert_with(|| {
                    Fanout::new(super::super::super::TextCodec::for_style::<Color>())
                });
                for node in 0..nodes {
                    entry
                        .destinations_mut()
                        .push(Destination::style(node * 2, PropertyId::Foreground));
                    if dual {
                        entry
                            .destinations_mut()
                            .push(Destination::style(node * 2, PropertyId::Background));
                    }
                }
                // This is the old key/value type and node-major insertion
                // order, not an estimate of BTree node overhead.
                let mut old: BTreeMap<(usize, bool), Slot> = BTreeMap::new();
                let old_cost = allocation_counter::measure(|| {
                    for node in 0..nodes {
                        old.insert((node * 2, true), slot);
                        if dual {
                            old.insert((node * 2, false), slot);
                        }
                    }
                });
                let new_cost = allocation_counter::measure(|| discovery.capture(&fanout));
                let ports = nodes * if dual { 2 } else { 1 };
                assert_eq!(new_cost.count_total, 1);
                assert_eq!(new_cost.bytes_total, (ports * size_of::<Binding>()) as u64);
                for node in 0..nodes * 2 {
                    assert_eq!(
                        discovery.bindings(node),
                        [true, false].map(|port| old.get(&(node, port)).copied())
                    );
                }
                eprintln!(
                    "port_storage,nodes={nodes},dual={dual},old_allocations={},old_requested={},old_live={},new_allocations={},new_requested={},new_live={},paired_payload={}",
                    old_cost.count_total,
                    old_cost.bytes_total,
                    old_cost.bytes_current,
                    new_cost.count_total,
                    new_cost.bytes_total,
                    new_cost.bytes_current,
                    nodes * size_of::<[u32; 3]>()
                );
            }
        }
    }

    #[test]
    fn equal_fields_are_distinct_and_masked_bases_follow_their_source() {
        let mut discovery = Discovery::default();
        let first = FieldId::new(1);
        let second = FieldId::new(2);
        discovery.bind(first, 0, true, Color::BLACK);
        discovery.bind(second, 1, true, Color::BLACK);
        let slots: Vec<_> = discovery.fields().collect();
        assert_ne!(slots[0].1, slots[1].1);
        let declared = Style {
            fg: Color::BLACK,
            ..Style::default()
        };
        let mut builder = Builder::new(2, discovery);
        builder.push(0, declared, declared, 0);
        builder.push(1, declared, declared, 0);
        let mut bound = builder.finish();
        // An explicit equal value still masks subsequent source changes.
        bound.contribution(0, PropertyId::Foreground, declared, true, 2);
        assert_eq!(
            bound
                .bank
                .update(slots[0].1, Color::WHITE)
                .map(|change| change.users),
            Some(0)
        );
        assert!(bound.get(0).fg.same_authoring(Color::BLACK));
        assert!(bound.declared_colors(0).0.same_authoring(Color::WHITE));
        assert!(bound.get(1).fg.same_authoring(Color::BLACK));
        bound.contribution(0, PropertyId::Foreground, declared, false, 2);
        assert!(bound.get(0).fg.same_authoring(Color::WHITE));
        assert_eq!(
            bound
                .bank
                .update(slots[0].1, Color::BLACK)
                .map(|change| change.users),
            Some(1)
        );
        assert!(bound.get(0).fg.same_authoring(Color::BLACK));
    }

    #[test]
    fn source_update_has_one_owned_write_and_no_allocation() {
        let field = FieldId::new(8);
        let mut discovery = Discovery::default();
        for node in 0..4096 {
            discovery.bind(field, node, true, Color::BLACK);
        }
        let slot = discovery.fields().next().unwrap().1;
        let declared = Style {
            fg: Color::BLACK,
            ..Style::default()
        };
        let mut builder = Builder::new(4096, discovery);
        for node in 0..4096 {
            builder.push(node, declared, declared, 0);
        }
        let mut bound = builder.finish();
        let allocation = allocation_counter::measure(|| {
            assert_eq!(
                bound
                    .bank
                    .update(slot, Color::WHITE)
                    .map(|change| change.users),
                Some(4096)
            );
        });
        assert_eq!((allocation.count_total, allocation.bytes_total), (0, 0));
        for index in 0..4096 {
            assert!(bound.get(index).fg.same_authoring(Color::WHITE));
        }
        eprintln!(
            "color_bank_layout,Styles={},Fanout={},Layout={},Record={},Bound={},Bank={},Source={},Slot={},Pair={},retained={}",
            size_of::<super::super::Styles>(),
            size_of::<super::super::super::Fanout>(),
            size_of::<LayoutStyle>(),
            size_of::<Record>(),
            size_of::<Bound>(),
            size_of::<Bank>(),
            size_of::<SourceColor>(),
            size_of::<Slot>(),
            size_of::<Pair>(),
            bound.bytes()
        );
    }

    #[test]
    fn default_authored_spaces_and_negative_zero_do_not_collapse() {
        let mut bank = Bank::default();
        assert!(
            bank.get(Pair::default().fg)
                .same_authoring(Style::DEFAULT.fg)
        );
        assert!(
            bank.get(Pair::default().bg)
                .same_authoring(Style::DEFAULT.bg)
        );
        let srgb = bank.literal(Style::DEFAULT.fg);
        let oklch = bank.literal(Color::BLACK);
        assert_ne!(srgb, oklch);
        assert!(bank.sources.is_empty() && bank.literals.is_empty());
        let neg = Color::linear_srgb(-0.0, 0.0, 0.0, 1.0).unwrap();
        let pos = Color::linear_srgb(0.0, 0.0, 0.0, 1.0).unwrap();
        let neg_slot = bank.literal(neg);
        let pos_slot = bank.literal(pos);
        assert_ne!(neg_slot, pos_slot);
        assert!(bank.get(neg_slot).same_authoring(neg));
        assert!(bank.get(pos_slot).same_authoring(pos));
    }
}

#[cfg(test)]
mod admission_tests {
    use super::*;
    #[test]
    fn more_than_canvas_bank_limit_distinct_source_ports_can_emit_no_commands() {
        const N: usize = 65_537;
        let mut discovery = Discovery::default();
        for node in 0..N {
            discovery.bind(FieldId::new((node * 2) as u32), node, true, Color::BLACK);
            discovery.bind(
                FieldId::new((node * 2 + 1) as u32),
                node,
                false,
                Color::BLACK,
            );
        }
        assert_eq!(discovery.bank.sources.len(), N * 2);
        let declared = Style {
            width: crate::Length::Points(0.),
            height: crate::Length::Points(0.),
            fg: Color::BLACK,
            bg: Color::BLACK,
            ..Style::DEFAULT
        };
        let mut builder = Builder::new(N, discovery);
        for node in 0..N {
            builder.push(node, declared, declared, 0);
        }
        let mut bound = builder.finish();
        let mut canvas =
            gpui_canvas::Canvas::recording(32, 32, gpui_canvas::ColorConfig::default()).unwrap();
        let mut scene = canvas.stage();
        let clip = gpui_canvas::Rect::new(0., 0., 32., 32.);
        let allocation = allocation_counter::measure(|| {
            for node in 0..N {
                for foreground in [false, true] {
                    let (value, cache) = bound.shared_paint(node, foreground).unwrap();
                    scene
                        .fill_rounded_rect_shared(
                            gpui_canvas::Rect::new(0., 0., 0., 0.),
                            0.,
                            Affine::IDENTITY,
                            clip,
                            value,
                            cache,
                        )
                        .unwrap();
                    assert!(cache.is_none());
                }
            }
        });
        assert_eq!((allocation.count_total, allocation.bytes_total), (0, 0));
        scene.commit();
        assert_eq!(canvas.prepared_scene().paint_bank().len(), 0);
        assert_eq!(canvas.prepared_scene().draws().len(), 0);
    }
}
