//! Source and layout-partition identities, once per published text site.
//! The adapter owns its tree. This cohort only leases source authority for
//! cross-thread actions; replacement cannot reinterpret an old ID in new bytes.
use super::*;
use crate::{FieldId, shared_text::SharedText};
use gpui_canvas::{CaretAffinity, TextOffset, TextPosition, TextSelection};
use icu_segmenter::GraphemeClusterSegmenter;

const INPUT_IDS: u64 = 1 << 63;

struct Input {
    identity: u64,
    field: Option<FieldId>,
    value: Option<SharedText>,
    geometry: Arc<gpui_canvas::TextGeometry>,
    root: Option<std::num::NonZeroU64>,
    base: u64,
    runs: u32,
}
struct Replacement {
    slot: usize,
    field: Option<FieldId>,
    runs: u32,
    source_changed: bool,
}
pub(super) struct Cohort {
    inputs: Vec<Input>,
    next: u64,
    window: Option<std::num::NonZeroU64>,
    #[cfg(test)]
    pub full_visits: usize,
    #[cfg(test)]
    pub sparse_visits: usize,
    #[cfg(test)]
    pub source_clones: usize,
}
pub(super) struct Relink {
    pub parents: Vec<u32>,
    pub root: bool,
    pub qualified: bool,
    pub new_ids: std::ops::Range<u64>,
}
impl Default for Relink {
    fn default() -> Self {
        Self {
            parents: Vec::new(),
            root: false,
            qualified: true,
            new_ids: 0..0,
        }
    }
}
impl Default for Cohort {
    fn default() -> Self {
        Self {
            inputs: Vec::new(),
            next: INPUT_IDS,
            window: None,
            #[cfg(test)]
            full_visits: 0,
            #[cfg(test)]
            sparse_visits: 0,
            #[cfg(test)]
            source_clones: 0,
        }
    }
}
impl Cohort {
    pub fn qualified(&self) -> bool {
        self.inputs
            .iter()
            .all(|input| input.value.is_none() || input.field.is_some())
    }
    #[cfg(test)]
    pub fn storage(&self) -> (usize, usize, usize) {
        (
            self.inputs.as_ptr() as usize,
            self.inputs.capacity(),
            self.inputs.len(),
        )
    }
    pub fn clear(&mut self) {
        self.inputs = Vec::new();
    }
    /// Rebuild one bounded publication cohort. IDs survive only the same input,
    /// field, and immutable text allocation. Retired ranges are never recycled.
    pub fn refresh<M: View + 'static, L: crate::remote::LaneSet<M>>(
        &mut self,
        owner: &Win<M, L>,
    ) -> Result<bool, Error> {
        let window = owner.accessibility_namespace()?;
        // Bridge/Cohort belongs to one owner lifetime, including empty/static
        // text allocations. A new Win requires a new native adapter, never an
        // arithmetic reinterpretation of this provider's old logical node IDs.
        if self.window.is_some_and(|previous| previous != window) {
            return Err(Error::StaleTarget);
        }
        let sheet = owner.accessibility_sheet()?;
        let mut count = 0;
        sheet.visit(|part| {
            #[cfg(test)]
            {
                self.full_visits += 1;
            }
            count += usize::from(part.text_geometry_lease().is_some());
        });
        let mut inputs = Vec::with_capacity(count);
        let mut next = self.next;
        let mut changed = count != self.inputs.len();
        let mut exhausted = false;
        sheet.visit(|part| {
            #[cfg(test)]
            {
                self.full_visits += 1;
            }
            let Some(geometry) = part.text_geometry_lease() else {
                return;
            };
            let lease = part.value().and_then(|_| part.text_lease());
            let field = qualified_field(owner, part);
            // All retained source is admitted by Canvas (at most32KiB).
            let runs = u32::try_from(geometry.runs().count()).expect("admitted Canvas run bound");
            let previous = self.input(part.native_id());
            let same_source = previous
                .is_some_and(|old| old.field == field && same_lease(old.value.as_ref(), lease));
            let root = if lease.is_some() {
                if same_source {
                    previous.unwrap().root
                } else {
                    changed = true;
                    let root = std::num::NonZeroU64::new(next);
                    match next.checked_add(1) {
                        Some(end) => next = end,
                        None => exhausted = true,
                    }
                    root
                }
            } else {
                None
            };
            let base = if let Some(old) =
                previous.filter(|old| same_source && Arc::ptr_eq(&old.geometry, geometry))
            {
                old.base
            } else {
                changed = true;
                let base = next;
                match next.checked_add(1 + u64::from(runs)) {
                    Some(end) => next = end,
                    None => exhausted = true,
                }
                base
            };
            inputs.push(Input {
                identity: part.native_id(),
                field,
                value: lease.cloned(),
                geometry: geometry.clone(),
                root,
                base,
                runs,
            });
        });
        if exhausted {
            return Err(Error::ResourceLimit);
        }
        inputs.sort_unstable_by_key(|input| input.identity);
        self.inputs = inputs;
        self.next = next;
        self.window = Some(window);
        #[cfg(test)]
        {
            self.source_clones += self
                .inputs
                .iter()
                .filter(|input| input.value.is_some())
                .count();
        }
        Ok(changed)
    }
    fn replacement<M: View + 'static, L: crate::remote::LaneSet<M>>(
        &self,
        owner: &Win<M, L>,
        part: Part<'_>,
    ) -> Result<Option<Replacement>, Error> {
        let Some(geometry) = part.text_geometry_lease() else {
            return Ok(None);
        };
        let index = self
            .inputs
            .binary_search_by_key(&part.native_id(), |input| input.identity)
            .map_err(|_| Error::StaleTarget)?;
        let lease = part.value().and_then(|_| part.text_lease());
        let field = qualified_field(owner, part);
        let previous = &self.inputs[index];
        let source_changed = previous.field != field || !same_lease(previous.value.as_ref(), lease);
        if !source_changed && Arc::ptr_eq(&previous.geometry, geometry) {
            Ok(None)
        } else {
            Ok(Some(Replacement {
                slot: index,
                field,
                runs: u32::try_from(geometry.runs().count()).expect("admitted Canvas run bound"),
                source_changed,
            }))
        }
    }

    /// An exact semantic frontier needs no full-sheet discovery or new table.
    /// Preflight ID capacity before mutating; only a real retirement needs the
    /// second bounded pass and an immediate-parent relink in native output.
    pub fn update_delta<M: View + 'static, L: crate::remote::LaneSet<M>>(
        &mut self,
        owner: &Win<M, L>,
        indices: &[u32],
    ) -> Result<Relink, Error> {
        if self.window != Some(owner.accessibility_namespace()?) {
            return Err(Error::StaleTarget);
        }
        let sheet = owner.accessibility_sheet()?;
        let mut end = self.next;
        let mut relink = Relink {
            new_ids: self.next..self.next,
            ..Relink::default()
        };
        for &index in indices {
            #[cfg(test)]
            {
                self.sparse_visits += 1;
            }
            let part = sheet.part_at(index as usize).ok_or(Error::StaleTarget)?;
            if let Some(change) = self.replacement(owner, part)? {
                relink.qualified &= part.value().is_none() || change.field.is_some();
                end = end
                    .checked_add(
                        1 + u64::from(change.runs)
                            + u64::from(change.source_changed && part.value().is_some()),
                    )
                    .ok_or(Error::ResourceLimit)?;
            }
        }
        if end == self.next {
            return Ok(relink);
        }
        for &index in indices {
            #[cfg(test)]
            {
                self.sparse_visits += 1;
            }
            let part = sheet.part_at(index as usize).unwrap();
            if let Some(change) = self.replacement(owner, part)? {
                let input = &mut self.inputs[change.slot];
                if change.source_changed {
                    input.field = change.field;
                    input.value = part.value().and_then(|_| part.text_lease()).cloned();
                    input.root = if input.value.is_some() {
                        let root = std::num::NonZeroU64::new(self.next);
                        self.next = self
                            .next
                            .checked_add(1)
                            .expect("preflight checked source ID");
                        root
                    } else {
                        None
                    };
                    #[cfg(test)]
                    {
                        self.source_clones += usize::from(input.value.is_some());
                    }
                    if part.value().is_some() {
                        if let Some(parent) = part.native_parent_index() {
                            relink.parents.push(parent as u32);
                        } else {
                            relink.root = true;
                        }
                    }
                }
                input.base = self.next;
                self.next = self
                    .next
                    .checked_add(1 + u64::from(change.runs))
                    .expect("preflight checked frozen run range");
                input.geometry = part.text_geometry_lease().unwrap().clone();
                input.runs = change.runs;
            }
        }
        relink.new_ids.end = end;
        debug_assert_eq!(self.next, end);
        relink.parents.sort_unstable();
        relink.parents.dedup();
        Ok(relink)
    }
    fn input(&self, identity: u64) -> Option<&Input> {
        self.inputs
            .binary_search_by_key(&identity, |input| input.identity)
            .ok()
            .map(|i| &self.inputs[i])
    }
    pub fn id(&self, part: Part<'_>) -> NodeId {
        self.input(part.native_id())
            .and_then(|input| input.root)
            .map_or(NodeId(part.native_id() * 2), |root| NodeId(root.get()))
    }
    pub fn text_count(&self, part: Part<'_>) -> usize {
        self.text_count_for(part, None)
    }
    pub fn text_count_for(&self, part: Part<'_>, new_ids: Option<&std::ops::Range<u64>>) -> usize {
        self.input(part.native_id()).map_or(0, |input| {
            usize::from(needs_parent(part))
                + if new_ids.is_none_or(|ids| ids.contains(&input.base)) {
                    input.runs as usize
                } else {
                    0
                }
        })
    }
    pub fn target<M: View + 'static, L: crate::remote::LaneSet<M>>(
        &self,
        owner: &Win<M, L>,
        id: NodeId,
    ) -> Result<Target, Error> {
        if self.window != Some(owner.accessibility_namespace()?) {
            return Err(Error::StaleTarget);
        }
        if id.0 < INPUT_IDS {
            if id.0 == 0 || id.0 & 1 != 0 {
                return Err(Error::StaleTarget);
            }
            // All P inputs, including unqualified ones, belong to this sorted
            // cohort. Identity reuse includes NodeKind, so an old low-ID static
            // target cannot become an input after a kind replacement.
            if self
                .input(id.0 / 2)
                .is_some_and(|input| input.value.is_some())
            {
                return Err(Error::StaleTarget);
            }
            return owner.accessibility_target(id.0 / 2);
        }
        let input = self
            .inputs
            .iter()
            .find(|input| input.root.is_some_and(|root| root.get() == id.0))
            .ok_or(Error::StaleTarget)?;
        let target = owner.accessibility_target(input.identity)?;
        let (field, value) = owner.accessibility_input(target)?;
        if input.field != Some(field)
            || !std::ptr::eq::<str>(input.value.as_ref().unwrap().as_ref(), value.as_ref())
        {
            return Err(Error::StaleTarget);
        }
        Ok(target)
    }
    pub fn selection(
        &self,
        id: NodeId,
        selection: accesskit::TextSelection,
    ) -> Option<TextSelection> {
        let input = self
            .inputs
            .iter()
            .find(|input| input.root.is_some_and(|root| root.get() == id.0))?;
        Some(TextSelection {
            anchor: input.position(selection.anchor)?,
            focus: input.position(selection.focus)?,
        })
    }
    pub fn append(
        &self,
        part: Part<'_>,
        node: &mut Node,
        nodes: &mut Vec<(NodeId, Node)>,
        new_ids: Option<&std::ops::Range<u64>>,
    ) {
        let Some(input) = self.input(part.native_id()) else {
            return;
        };
        let mut parent = needs_parent(part).then(|| {
            let mut parent = Node::new(if part.value().is_some() {
                accesskit::Role::GenericContainer
            } else {
                accesskit::Role::Label
            });
            parent.set_value(part.text().unwrap());
            parent
        });
        let carrier = parent.as_mut().unwrap_or(node);
        place_carrier(part, carrier);
        let emit_runs = new_ids.is_none_or(|ids| ids.contains(&input.base));
        let mut runs = input.geometry.runs().enumerate().peekable();
        let mut previous_line = None;
        while let Some((index, run)) = runs.next() {
            let id = NodeId(input.base + 1 + index as u64);
            carrier.push_child(id);
            if emit_runs {
                let mut node = geometry_run(
                    part.text().unwrap(),
                    &input.geometry,
                    run,
                    part.transform().is_some(),
                );
                if previous_line == Some(run.line()) {
                    node.set_previous_on_line(NodeId(id.0 - 1));
                }
                if runs
                    .peek()
                    .is_some_and(|(_, next)| next.line() == run.line())
                {
                    node.set_next_on_line(NodeId(id.0 + 1));
                }
                nodes.push((id, node));
            }
            previous_line = Some(run.line());
        }
        if let Some(parent) = parent {
            let id = NodeId(input.base);
            node.push_child(id);
            nodes.push((id, parent));
        }
        if input.value.is_some() {
            let selection = part.selection().expect("input selection belongs to P");
            node.set_text_selection(accesskit::TextSelection {
                anchor: input.native_position(selection.anchor),
                focus: input.native_position(selection.focus),
            });
            if input.field.is_some() {
                node.add_action(accesskit::Action::SetTextSelection);
                node.add_action(accesskit::Action::ReplaceSelectedText);
            } else {
                node.remove_action(accesskit::Action::SetValue);
                node.remove_action(accesskit::Action::Focus);
                node.remove_action(accesskit::Action::Blur);
            }
        }
    }
}

impl Input {
    fn position(&self, position: accesskit::TextPosition) -> Option<TextPosition> {
        let index = position.node.0.checked_sub(self.base + 1)?;
        if index >= u64::from(self.runs) {
            return None;
        }
        let value = self.value.as_ref()?;
        let run = self.geometry.runs().nth(index as usize)?;
        let range = run.text_range();
        let source = &value[range.start.byte()..range.end.byte()];
        let byte = GraphemeClusterSegmenter::new()
            .segment_str(source)
            .nth(position.character_index)?;
        let mut position = TextPosition {
            offset: TextOffset::new(range.start.byte() + byte)?,
            affinity: if byte == source.len() {
                CaretAffinity::Upstream
            } else {
                CaretAffinity::Downstream
            },
        };
        if self.geometry.caret_bounds(position).is_none() {
            position.affinity = CaretAffinity::Downstream;
        }
        self.geometry.caret_bounds(position).map(|_| position)
    }
    fn native_position(&self, position: TextPosition) -> accesskit::TextPosition {
        let byte = position.offset.byte();
        let value = self.value.as_ref().expect("only inputs publish selections");
        let mut runs = self.geometry.runs().enumerate().peekable();
        while let Some((index, run)) = runs.next() {
            let range = run.text_range();
            if byte < range.end.byte()
                || (byte == range.end.byte()
                    && (position.affinity == CaretAffinity::Upstream || runs.peek().is_none()))
            {
                let character_index = GraphemeClusterSegmenter::new()
                    .segment_str(&value[range.start.byte()..range.end.byte()])
                    .position(|boundary| boundary == byte - range.start.byte())
                    .expect("P selection uses source grapheme boundaries");
                return accesskit::TextPosition {
                    node: NodeId(self.base + 1 + index as u64),
                    character_index,
                };
            }
        }
        unreachable!("terminal run covers the P document end")
    }
}
fn same_lease(old: Option<&SharedText>, new: Option<&SharedText>) -> bool {
    match (old, new) {
        (Some(a), Some(b)) => std::ptr::eq::<str>(a.as_ref(), b.as_ref()),
        (None, None) => true,
        _ => false,
    }
}
fn qualified_field<M: View + 'static, L: crate::remote::LaneSet<M>>(
    owner: &Win<M, L>,
    part: Part<'_>,
) -> Option<FieldId> {
    part.value()?;
    let lease = part.text_lease()?;
    owner
        .accessibility_input(part.target())
        .ok()
        .filter(|(_, current)| std::ptr::eq::<str>(lease.as_ref(), current.as_ref()))
        .map(|(field, _)| field)
}
fn needs_parent(part: Part<'_>) -> bool {
    // El::child admits only Div/Button/Scroll, never Text/Input. Those leaf
    // carriers cannot accidentally absorb an independent app text document.
    renamed_text(part) || !matches!(part.role(), Role::Text | Role::TextInput)
}
fn place_carrier(part: Part<'_>, node: &mut Node) {
    let geometry = part.text_geometry().expect("P text has canonical geometry");
    if let Some(space) = geometry.transform() {
        node.set_transform(accesskit::Affine::new(space.coefficients()));
        let rect = part.local_bounds();
        let origin = geometry.origin();
        node.set_bounds(accesskit::Rect {
            x0: f64::from(rect.x) - f64::from(origin.x),
            y0: f64::from(rect.y) - f64::from(origin.y),
            x1: f64::from(rect.x) + f64::from(rect.width) - f64::from(origin.x),
            y1: f64::from(rect.y) + f64::from(rect.height) - f64::from(origin.y),
        });
    }
}
fn geometry_run(
    value: &str,
    geometry: &gpui_canvas::TextGeometry,
    run: gpui_canvas::TextRun,
    placed: bool,
) -> Node {
    let range = run.text_range();
    let mut node = text_run(&value[range.start.byte()..range.end.byte()]);
    // An admitted, nonpainted offscreen paragraph may have no invertible P
    // placement. Preserve text/actions without inventing window geometry.
    if !placed {
        return node;
    }
    let rect = run.bounds();
    node.set_bounds(accesskit::Rect {
        x0: f64::from(rect.x),
        y0: f64::from(rect.y),
        x1: f64::from(rect.x) + f64::from(rect.width),
        y1: f64::from(rect.y) + f64::from(rect.height),
    });
    let rtl = run.direction() == gpui_canvas::TextDirection::RightToLeft;
    node.set_text_direction(if rtl {
        accesskit::TextDirection::RightToLeft
    } else {
        accesskit::TextDirection::LeftToRight
    });
    let count = node.character_lengths().len();
    let mut positions = Vec::with_capacity(count);
    let mut widths = Vec::with_capacity(count);
    for unit in geometry
        .graphemes_in(range)
        .expect("run endpoints are legal grapheme boundaries")
    {
        let bounds = unit.bounds();
        positions.push(if rtl {
            rect.x + rect.width - bounds.x - bounds.width
        } else {
            bounds.x - rect.x
        });
        widths.push(bounds.width);
    }
    assert_eq!(positions.len(), count);
    node.set_character_positions(positions);
    node.set_character_widths(widths);
    node
}

pub(super) fn text_run(value: &str) -> Node {
    let mut node = Node::new(accesskit::Role::TextRun);
    node.set_value(value);
    let mut boundaries = GraphemeClusterSegmenter::new().segment_str(value);
    let mut previous = boundaries.next().unwrap_or(0);
    assert!(node.set_text_character_lengths(boundaries.map(|boundary| {
        // This is a slice of Canvas-admitted P text (at most 32 KiB).
        let length = u32::try_from(boundary - previous).expect("admitted Canvas input bound");
        previous = boundary;
        length
    })));
    node
}

#[cfg(test)]
#[test]
fn native_input_authority_memory_budget() {
    assert_eq!(size_of::<Input>(), 56);
    // Production Cohort40 plus three test-only usize work counters24.
    assert_eq!(size_of::<Cohort>(), 64);
    eprintln!(
        "NATIVE_TEXT_AUTHORITY input={} cohort_production={}",
        size_of::<Input>(),
        size_of::<Cohort>() - 3 * size_of::<usize>()
    );
}
