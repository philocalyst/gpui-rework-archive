//! Source-qualified native identities, once per published input, never per unit.
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
    value: SharedText,
    base: u64,
    runs: u32,
}
pub(super) struct Cohort {
    inputs: Vec<Input>,
    next: u64,
    window: Option<std::num::NonZeroU64>,
}
impl Default for Cohort {
    fn default() -> Self {
        Self {
            inputs: Vec::new(),
            next: INPUT_IDS,
            window: None,
        }
    }
}
impl Cohort {
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
        sheet.visit(|part| count += usize::from(part.value().is_some()));
        let mut inputs = Vec::with_capacity(count);
        let mut next = self.next;
        let mut changed = count != self.inputs.len();
        let mut exhausted = false;
        sheet.visit(|part| {
            let Some(value) = part.value() else {
                return;
            };
            let lease = part.text_lease().unwrap();
            let field = owner
                .accessibility_input(part.target())
                .ok()
                .filter(|(_, current)| std::ptr::eq::<str>(lease.as_ref(), current.as_ref()))
                .map(|(field, _)| field);
            let runs = runs(value).count() as u32;
            let previous = self.input(part.native_id()).filter(|old| {
                old.field == field && std::ptr::eq::<str>(old.value.as_ref(), lease.as_ref())
            });
            let base = if let Some(old) = previous {
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
                value: lease.clone(),
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
        Ok(changed)
    }
    fn input(&self, identity: u64) -> Option<&Input> {
        self.inputs
            .binary_search_by_key(&identity, |input| input.identity)
            .ok()
            .map(|i| &self.inputs[i])
    }
    pub fn id(&self, part: Part<'_>) -> NodeId {
        self.input(part.native_id())
            .map_or(NodeId(part.native_id() * 2), |input| NodeId(input.base))
    }
    pub fn text_count(&self, part: Part<'_>) -> usize {
        self.input(part.native_id())
            .map_or(usize::from(renamed_text(part)), |input| input.runs as usize)
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
            let target = owner.accessibility_target(id.0 / 2)?;
            // Inputs are never authorized by the old logical-ID namespace.
            let mut input = false;
            owner.visit(|part| input |= part.target() == target && part.value().is_some())?;
            if input {
                return Err(Error::StaleTarget);
            }
            return Ok(target);
        }
        let input = self
            .inputs
            .iter()
            .find(|input| input.base == id.0)
            .ok_or(Error::StaleTarget)?;
        let target = owner.accessibility_target(input.identity)?;
        let (field, value) = owner.accessibility_input(target)?;
        if input.field != Some(field) || !std::ptr::eq::<str>(input.value.as_ref(), value.as_ref())
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
        let input = self.inputs.iter().find(|input| input.base == id.0)?;
        Some(TextSelection {
            anchor: input.position(selection.anchor)?,
            focus: input.position(selection.focus)?,
        })
    }
    pub fn append(&self, part: Part<'_>, node: &mut Node, nodes: &mut Vec<(NodeId, Node)>) {
        if let Some(input) = self.input(part.native_id()) {
            for (index, value) in runs(&input.value).enumerate() {
                let id = NodeId(input.base + 1 + index as u64);
                node.push_child(id);
                nodes.push((id, text_run(value)));
            }
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
        } else if let Some(text) = projected_text(part, node) {
            let id = NodeId(self.id(part).0 + 1);
            node.push_child(id);
            nodes.push((id, text));
        }
    }
}
impl Input {
    fn position(&self, position: accesskit::TextPosition) -> Option<TextPosition> {
        let index = position.node.0.checked_sub(self.base + 1)?;
        if index >= u64::from(self.runs) {
            return None;
        }
        let mut start = 0usize;
        for (i, value) in runs(&self.value).enumerate() {
            if i as u64 == index {
                let byte = GraphemeClusterSegmenter::new()
                    .segment_str(value)
                    .nth(position.character_index)?;
                return Some(TextPosition {
                    offset: TextOffset::new(start + byte)?,
                    affinity: CaretAffinity::Downstream,
                });
            }
            start += value.len();
        }
        None
    }
    fn native_position(&self, position: TextPosition) -> accesskit::TextPosition {
        let byte = position.offset.byte();
        let mut start = 0usize;
        for (index, value) in runs(&self.value).enumerate() {
            let end = start + value.len();
            if byte < end || (byte == end && !value.ends_with('\n')) {
                let character_index = GraphemeClusterSegmenter::new()
                    .segment_str(value)
                    .position(|boundary| boundary == byte - start)
                    .expect("P selection uses source grapheme boundaries");
                return accesskit::TextPosition {
                    node: NodeId(self.base + 1 + index as u64),
                    character_index,
                };
            }
            start = end;
        }
        unreachable!("terminal empty run covers the document end")
    }
}

fn runs(value: &str) -> impl Iterator<Item = &str> {
    value
        .split_inclusive('\n')
        .chain((value.is_empty() || value.ends_with('\n')).then_some(""))
}

pub(super) fn text_run(value: &str) -> Node {
    let mut node = Node::new(accesskit::Role::TextRun);
    node.set_value(value);
    let mut boundaries = GraphemeClusterSegmenter::new().segment_str(value);
    let mut previous = boundaries.next().unwrap_or(0);
    assert!(node.set_text_character_lengths(boundaries.map(|boundary| {
        let length = (boundary - previous) as u32;
        previous = boundary;
        length
    })));
    node
}
