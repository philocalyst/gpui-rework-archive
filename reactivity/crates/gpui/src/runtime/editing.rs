//! One active logical selection. Its text lease proves which immutable source
//! bytes the offsets address; geometry remains in the existing TextSite cache.
use super::*;
use gpui_canvas::{CaretAffinity, TextOffset, TextPosition, TextSelection};
use icu_segmenter::GraphemeClusterSegmenter;

struct LogicalSelection {
    identity: u64,
    field: FieldId,
    value: SharedText,
    selection: TextSelection,
}

/// The two immutable presentation endpoints, not another logical editor. This
/// remains available when a provider activates while a newer edit has failed.
/// Nonzero identities are allocated by Sites; Option uses that existing niche.
#[derive(Clone, Copy, PartialEq, Eq)]
pub(super) struct SelectionSnapshot {
    identity: NonZeroU64,
    selection: TextSelection,
}
/// One cold owner keeps logical, candidate and acknowledged lifetimes separate.
/// Revocation drops the logical source lease immediately; old P/C offsets remain
/// until the corresponding complete scene is replaced. This avoids another
/// Metadata slot/allocation, at the cost of 40 empty bytes while only P/C survive.
#[derive(Default)]
pub(super) struct Editing {
    logical: Option<LogicalSelection>,
    pub presented: Option<SelectionSnapshot>,
    pub candidate: Option<SelectionSnapshot>,
}
impl SelectionSnapshot {
    pub fn selection(self, identity: u64) -> Option<TextSelection> {
        (self.identity.get() == identity).then_some(self.selection)
    }
}
impl Editing {
    pub fn unused(&self) -> bool {
        self.logical.is_none() && self.presented.is_none() && self.candidate.is_none()
    }
}

/// Stack-only post-admission intent. It is consumed after the source is frozen
/// back into the live text lane and before a candidate scene is prepared.
#[derive(Clone, Copy)]
pub(super) enum EditingIntent {
    None,
    Replace {
        identity: u64,
        field: FieldId,
        byte: usize,
    },
    Focus,
}

fn position(byte: usize) -> Result<TextPosition, Error> {
    Ok(TextPosition {
        offset: TextOffset::new(byte).ok_or(Error::ResourceLimit)?,
        affinity: CaretAffinity::Downstream,
    })
}

fn validates(value: &str, selection: TextSelection) -> bool {
    let a = selection.anchor.offset.byte();
    let b = selection.focus.offset.byte();
    let mut anchor = false;
    let mut focus = false;
    for boundary in GraphemeClusterSegmenter::new().segment_str(value) {
        anchor |= boundary == a;
        focus |= boundary == b;
        if anchor && focus {
            return true;
        }
    }
    false
}

impl<M: View + 'static> Runtime<M> {
    pub(super) fn active_selection(&self) -> Option<(u64, TextSelection)> {
        let state = self.metadata.as_ref()?.editing.as_ref()?.logical.as_ref()?;
        let index = self.by_identity.get(state.identity)?;
        self.editing_at(index)
            .map(|state| (state.identity, state.selection))
    }

    pub(super) fn selection_snapshot(&self) -> Option<SelectionSnapshot> {
        self.active_selection()
            .map(|(identity, selection)| SelectionSnapshot {
                identity: NonZeroU64::new(identity).expect("Sites identities are nonzero"),
                selection,
            })
    }

    fn interaction_layout(&mut self, index: usize) -> Result<&TextLayout, Error> {
        let slot = self.nodes[index].text_slot();
        let ready = slot
            .get(&self.texts)
            .and_then(|site| site.shaped.as_ref())
            .is_some_and(|shape| shape.layout.caret_bounds(position(0).unwrap()).is_some());
        if !ready {
            let width = self
                .layout
                .layout(self.layout_nodes[index])?
                .content_box_width();
            let font = self
                .text
                .as_ref()
                .and_then(|text| text.system.as_ref())
                .expect("current text presentation has a font service")
                .font_face()
                .clone();
            slot.get_mut(&mut self.texts).unwrap().shape_for(
                &mut font.shaper(),
                self.styles.get(index).font_size,
                Some(width),
                true,
            )?;
        }
        Ok(&slot
            .get(&self.texts)
            .unwrap()
            .shaped
            .as_ref()
            .unwrap()
            .layout)
    }

    fn input_index(&self, target: Target) -> Result<usize, Error> {
        let index = self.resolve_index(target)?;
        if self.nodes[index].kind() != NodeKind::Input {
            return Err(Error::NotInput);
        }
        if self.nodes[index]
            .text_slot()
            .get(&self.texts)
            .and_then(|site| site.field)
            .is_none()
        {
            return Err(Error::UnregisteredInput { node: index });
        }
        Ok(index)
    }

    fn editing_at(&self, index: usize) -> Option<&LogicalSelection> {
        let state = self.metadata.as_ref()?.editing.as_ref()?.logical.as_ref()?;
        let node = &self.nodes[index];
        let text = node.text_slot().get(&self.texts)?;
        (node.kind() == NodeKind::Input
            && node.identity() == state.identity
            && text.field == Some(state.field)
            && std::ptr::eq::<str>(state.value.as_ref(), text.value.as_ref()))
        .then_some(state)
    }

    fn selection_at(&self, index: usize) -> Result<TextSelection, Error> {
        if let Some(state) = self.editing_at(index) {
            return Ok(state.selection);
        }
        let caret = position(
            self.nodes[index]
                .text_slot()
                .get(&self.texts)
                .unwrap()
                .value
                .len(),
        )?;
        Ok(TextSelection {
            anchor: caret,
            focus: caret,
        })
    }

    fn set_selection(&mut self, index: usize, selection: TextSelection) -> bool {
        let node = &self.nodes[index];
        if self
            .editing_at(index)
            .is_some_and(|state| state.selection == selection)
        {
            return false;
        }
        let text = node.text_slot().get(&self.texts).unwrap();
        let next = LogicalSelection {
            identity: node.identity(),
            field: text.field.unwrap(),
            value: text.value.clone(),
            selection,
        };
        let previous = self
            .metadata
            .as_mut()
            .and_then(|metadata| metadata.editing.as_mut())
            .and_then(|editing| editing.logical.take());
        drop(previous);
        self.metadata
            .get_or_insert_with(|| Box::new(Metadata::default()))
            .editing
            .get_or_insert_with(Default::default)
            .logical = Some(next);
        self.dirty = true;
        true
    }

    pub(super) fn clear_editing(&mut self) -> bool {
        let Some(_) = self
            .metadata
            .as_mut()
            .and_then(|metadata| metadata.editing.as_mut())
            .and_then(|editing| editing.logical.take())
        else {
            return false;
        };
        self.dirty = true;
        true
    }

    pub(super) fn reconcile_editing(&mut self, intent: EditingIntent) -> Result<bool, Error> {
        if let EditingIntent::Replace {
            identity,
            field,
            byte,
        } = intent
        {
            if let Some(index) = self.by_identity.get(identity)
                && self.nodes[index].kind() == NodeKind::Input
                && let Some(site) = self.nodes[index].text_slot().get(&self.texts)
                && site.field == Some(field)
            {
                let byte = GraphemeClusterSegmenter::new()
                    .segment_str(&site.value)
                    .find(|&boundary| boundary >= byte.min(site.value.len()))
                    .unwrap_or(site.value.len());
                let caret = position(byte)?;
                return Ok(self.set_selection(
                    index,
                    TextSelection {
                        anchor: caret,
                        focus: caret,
                    },
                ));
            }
            return Ok(self.clear_editing());
        }
        let stale = self
            .metadata
            .as_ref()
            .and_then(|metadata| metadata.editing.as_ref())
            .and_then(|editing| editing.logical.as_ref())
            .is_some_and(|state| {
                !self.logical_valid
                    || self
                        .by_identity
                        .get(state.identity)
                        .is_none_or(|index| self.editing_at(index).is_none())
            });
        let changed = stale && self.clear_editing();
        if matches!(intent, EditingIntent::Focus) {
            self.dirty = true;
            return Ok(true);
        }
        Ok(changed)
    }
}

impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    #[cfg(feature = "accessibility")]
    pub(crate) fn accessibility_input(
        &self,
        target: Target,
    ) -> Result<(FieldId, &SharedText), Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        runtime.current_presentation()?;
        let index = runtime.input_index(target)?;
        let site = runtime.nodes[index]
            .text_slot()
            .get(&runtime.texts)
            .unwrap();
        Ok((site.field.unwrap(), &site.value))
    }
    /// Current logical selection, or a collapsed caret at the input's end.
    /// This query uses current source authority and remains available after a
    /// presentation failure. It never returns geometry from an older frame.
    pub fn selection(&self, target: Target) -> Result<TextSelection, Error> {
        let runtime = self.runtime()?;
        runtime.live()?;
        runtime.selection_at(runtime.input_index(target)?)
    }

    /// Set UTF-8 grapheme endpoints on a live input. Invalid endpoints are
    /// rejected before state or publication changes. This does not change focus.
    pub fn select(&mut self, target: Target, selection: TextSelection) -> Result<Commit, Error> {
        self.runtime_mut()?.select_input(target, selection)
    }

    /// Replace an explicit range interpreted in the CURRENT logical source.
    /// The range is positional, not a snapshot or revision capability.
    /// Replacement uses the same source codec and
    /// reconciliation barrier as typing, backspace and accessibility SetValue.
    /// The resulting caret follows the entire joined grapheme after insertion.
    pub fn replace(
        &mut self,
        target: Target,
        range: TextSelection,
        text: &str,
    ) -> Result<Commit, Error> {
        self.runtime_mut()?.replace_input(target, Some(range), text)
    }
}

impl<M: View + 'static, L: LaneSet<M>> RuntimeMut<'_, M, L> {
    pub(super) fn focus_needs_paint(&self, previous: Option<Target>) -> bool {
        self.active_selection()
            .is_some_and(|(identity, selection)| {
                let before =
                    previous.and_then(|target| self.sites.resolve(target)) == Some(identity);
                let after =
                    self.focused.and_then(|target| self.sites.resolve(target)) == Some(identity);
                before != after && selection.anchor.offset == selection.focus.offset
            })
    }

    pub(super) fn publish_focus_change(
        &mut self,
        previous: Option<Target>,
    ) -> Result<Commit, Error> {
        if !self.focus_needs_paint(previous) {
            return Ok(self.commit());
        }
        let Some(epoch) = self.source_epoch.checked_add(1) else {
            self.runtime.focused = previous;
            return Err(Error::EpochExhausted);
        };
        self.runtime.source_epoch = epoch;
        self.runtime.counters.source_operations += 1;
        self.runtime.dirty = true;
        self.present()
    }

    pub(super) fn select_pointer(
        &mut self,
        target: Target,
        point: Point,
        extend: bool,
    ) -> Result<Commit, Error> {
        self.live()?;
        self.current_presentation()?;
        let index = self.input_index(target)?;
        let anchor = if extend {
            Some(
                self.editing_at(index)
                    .ok_or(Error::StaleTarget)?
                    .selection
                    .anchor,
            )
        } else {
            None
        };
        let identity = self.nodes[index].identity();
        let transform = self
            .presented
            .iter()
            .find(|node| node.identity == identity)
            .and_then(|node| node.transform(self.presented_geometry().bases()))
            .ok_or(Error::NotHittable)?;
        let local = CoordinateSpace::new(transform)
            .to_local(point)
            .ok_or(Error::NotHittable)?;
        let measured = self.layout.layout(self.layout_nodes[index])?;
        let point = Point {
            x: local.x - measured.padding.left,
            y: local.y - measured.padding.top,
        };
        let focus = self
            .runtime
            .interaction_layout(index)?
            .position_at(point)
            .ok_or(Error::NotHittable)?;
        self.source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        // The point and map are resolved before focus or selection can publish.
        let previous = self.focused;
        let prepared = self.latest_token;
        self.focus(target)?;
        let commit = self.select_input(
            target,
            TextSelection {
                anchor: anchor.unwrap_or(focus),
                focus,
            },
        )?;
        // select_input either prepares a full scene containing current focus,
        // or does no publication. It cannot mint a bank-only token.
        if self.latest_token == prepared {
            self.publish_focus_change(previous)
        } else {
            Ok(commit)
        }
    }

    pub(super) fn move_selection(
        &mut self,
        target: Target,
        right: bool,
        extend: bool,
    ) -> Result<Commit, Error> {
        self.live()?;
        self.current_presentation()?;
        let index = self.input_index(target)?;
        let selection = self.selection_at(index)?;
        let layout = self.runtime.interaction_layout(index)?;
        // GPUI's collapse policy uses the physical ordering of the two
        // endpoints. Unicode bidi defines visual ordering, not this policy.
        let focus = if !extend && selection.anchor.offset != selection.focus.offset {
            let a = layout
                .caret_bounds(selection.anchor)
                .ok_or(Error::InvalidSelection)?;
            let b = layout
                .caret_bounds(selection.focus)
                .ok_or(Error::InvalidSelection)?;
            let anchor_first = a.y < b.y || (a.y == b.y && a.x < b.x);
            if right == anchor_first {
                selection.focus
            } else {
                selection.anchor
            }
        } else if right {
            layout
                .next_visual(selection.focus)
                .ok_or(Error::InvalidSelection)?
        } else {
            layout
                .previous_visual(selection.focus)
                .ok_or(Error::InvalidSelection)?
        };
        self.select_input(
            target,
            TextSelection {
                anchor: if extend { selection.anchor } else { focus },
                focus,
            },
        )
    }

    pub(super) fn select_input(
        &mut self,
        target: Target,
        selection: TextSelection,
    ) -> Result<Commit, Error> {
        self.live()?;
        let index = self.input_index(target)?;
        let value = &self.nodes[index]
            .text_slot()
            .get(&self.texts)
            .unwrap()
            .value;
        if !validates(value, selection) {
            return Err(Error::InvalidSelection);
        }
        let epoch = self
            .source_epoch
            .checked_add(1)
            .ok_or(Error::EpochExhausted)?;
        self.changed_nodes = 0;
        if !self.set_selection(index, selection) {
            return Ok(self.commit());
        }
        self.runtime.source_epoch = epoch;
        self.runtime.counters.source_operations += 1;
        self.runtime.changed_nodes = 1;
        self.present()
    }

    pub(super) fn replace_input(
        &mut self,
        target: Target,
        range: Option<TextSelection>,
        text: &str,
    ) -> Result<Commit, Error> {
        self.live()?;
        let index = self.input_index(target)?;
        let node = &self.nodes[index];
        let identity = node.identity();
        let field = node.text_slot().get(&self.texts).unwrap().field.unwrap();
        let codec = self.fanout[&field].codec();
        let range = range.map_or_else(|| self.selection_at(index), Ok)?;
        let mut input = match catch_unwind(AssertUnwindSafe(|| {
            self.sources
                .read_text(&self.model, field, codec)
                .map(|text| text.into_owned())
        })) {
            Ok(result) => result?,
            Err(_) => {
                self.poison();
                return Err(Error::OwnerPanicked);
            }
        };
        if !validates(&input, range) {
            return Err(Error::InvalidSelection);
        }
        let start = range.anchor.offset.byte().min(range.focus.offset.byte());
        let end = range.anchor.offset.byte().max(range.focus.offset.byte());
        let byte = start.checked_add(text.len()).ok_or(Error::ResourceLimit)?;
        input.replace_range(start..end, text);
        let intent = EditingIntent::Replace {
            identity,
            field,
            byte,
        };
        self.operation_with_editing(
            Some(field),
            move |model, sources, _| {
                sources.write_text(model, field, input, codec)?;
                Ok(())
            },
            intent,
        )
    }

    pub(super) fn backspace_input(&mut self, target: Target) -> Result<Commit, Error> {
        self.live()?;
        let index = self.input_index(target)?;
        let mut selection = self.selection_at(index)?;
        if selection.anchor.offset == selection.focus.offset {
            let value = &self.nodes[index]
                .text_slot()
                .get(&self.texts)
                .unwrap()
                .value;
            let previous = GraphemeClusterSegmenter::new()
                .segment_str(value)
                .take_while(|&byte| byte < selection.focus.offset.byte())
                .last()
                .unwrap_or(0);
            selection.anchor = position(previous)?;
        }
        self.replace_input(target, Some(selection), "")
    }

    pub(super) fn set_input_value(&mut self, target: Target, text: &str) -> Result<Commit, Error> {
        self.live()?;
        let index = self.input_index(target)?;
        let value = &self.nodes[index]
            .text_slot()
            .get(&self.texts)
            .unwrap()
            .value;
        let range = TextSelection {
            anchor: position(0)?,
            focus: position(value.len())?,
        };
        self.replace_input(target, Some(range), text)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::Signal;

    struct Inputs {
        a: Signal<String>,
        b: Signal<String>,
    }
    impl View for Inputs {
        fn sources() -> Sources<Self> {
            Sources::new()
                .direct(Source::new(
                    FieldId::new(1),
                    "a",
                    |m: &Self| &m.a,
                    |m| &mut m.a,
                ))
                .direct(Source::new(
                    FieldId::new(2),
                    "b",
                    |m: &Self| &m.b,
                    |m| &mut m.b,
                ))
        }
        fn view(&self) -> crate::El<'_> {
            crate::column((crate::text_input(&self.a), crate::text_input(&self.b)))
        }
    }

    #[test]
    fn shared_owner_drops_revoked_logical_lease_but_keeps_old_p_until_repair_ack() {
        let mut win = Win::recording(
            Inputs {
                a: Signal::new("ab".into()),
                b: Signal::new("cd".into()),
            },
            WindowOptions::default(),
        )
        .unwrap();
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
        let input = win.role(crate::Role::TextInput).text("ab").one().unwrap();
        let selection = TextSelection {
            anchor: position(0).unwrap(),
            focus: position(1).unwrap(),
        };
        win.select(input, selection).unwrap();
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
        let allocation = std::ptr::from_ref(
            win.runtime()
                .unwrap()
                .metadata
                .as_ref()
                .unwrap()
                .editing
                .as_deref()
                .unwrap(),
        );
        assert!(win.update(|m| *m.a = "漢".into()).is_err());
        {
            let runtime = win.runtime().unwrap();
            let editing = runtime.metadata.as_ref().unwrap().editing.as_ref().unwrap();
            assert!(
                editing.logical.is_none(),
                "revocation drops the source lease, not merely its authority bit"
            );
            assert_eq!(
                editing
                    .presented
                    .unwrap()
                    .selection(runtime.resolve(input).unwrap()),
                Some(selection)
            );
        }
        win.perform(input, Action::SetValue("repair")).unwrap();
        assert_eq!(
            std::ptr::from_ref(
                win.runtime()
                    .unwrap()
                    .metadata
                    .as_ref()
                    .unwrap()
                    .editing
                    .as_deref()
                    .unwrap()
            ),
            allocation
        );
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
        assert_eq!(win.selection(input).unwrap().focus.offset.byte(), 6);
        win.update(|m| *m.a = "plain".into()).unwrap();
        win.presented(win.with_scene(|_, token| token).unwrap())
            .unwrap();
        assert!(
            win.runtime()
                .unwrap()
                .metadata
                .as_ref()
                .is_none_or(|m| m.editing.is_none())
        );
    }

    #[test]
    fn all_presented_inputs_retain_stable_geometry_and_share_one_cold_editor() {
        let mut win = Win::demo(Inputs {
            a: Signal::new("first".into()),
            b: Signal::new("אבג".into()),
        });
        let targets = [
            win.role(crate::Role::TextInput)
                .text("first")
                .one()
                .unwrap(),
            win.role(crate::Role::TextInput).text("אבג").one().unwrap(),
        ];
        let has_map = |runtime: &Runtime<Inputs>, target| {
            let index = runtime.resolve_index(target).unwrap();
            runtime.nodes[index]
                .text_slot()
                .get(&runtime.texts)
                .unwrap()
                .shaped
                .as_ref()
                .unwrap()
                .layout
                .caret_bounds(position(0).unwrap())
                .is_some()
        };
        let maps = targets.map(|target| {
            let runtime = win.runtime().unwrap();
            let index = runtime.resolve_index(target).unwrap();
            let layout = &runtime.nodes[index]
                .text_slot()
                .get(&runtime.texts)
                .unwrap()
                .shaped
                .as_ref()
                .unwrap()
                .layout;
            std::ptr::from_ref(layout.geometry().unwrap())
        });
        {
            let runtime = win.runtime().unwrap();
            assert!(
                runtime
                    .metadata
                    .as_ref()
                    .is_none_or(|m| m.editing.is_none())
            );
            assert!(has_map(runtime, targets[0]));
            assert!(has_map(runtime, targets[1]));
        }
        let caret = TextSelection {
            anchor: position(0).unwrap(),
            focus: position(0).unwrap(),
        };
        win.select(targets[0], caret).unwrap();
        let allocation = {
            let runtime = win.runtime().unwrap();
            assert!(has_map(runtime, targets[0]));
            assert!(has_map(runtime, targets[1]));
            std::ptr::from_ref(
                runtime
                    .metadata
                    .as_ref()
                    .unwrap()
                    .editing
                    .as_deref()
                    .unwrap(),
            )
        };
        win.select(targets[1], caret).unwrap();
        let runtime = win.runtime().unwrap();
        assert!(has_map(runtime, targets[0]));
        assert!(has_map(runtime, targets[1]));
        for (target, map) in targets.into_iter().zip(maps) {
            let index = runtime.resolve_index(target).unwrap();
            let layout = &runtime.nodes[index]
                .text_slot()
                .get(&runtime.texts)
                .unwrap()
                .shaped
                .as_ref()
                .unwrap()
                .layout;
            assert_eq!(std::ptr::from_ref(layout.geometry().unwrap()), map);
        }
        assert_eq!(
            std::ptr::from_ref(
                runtime
                    .metadata
                    .as_ref()
                    .unwrap()
                    .editing
                    .as_deref()
                    .unwrap()
            ),
            allocation
        );
        if cfg!(target_pointer_width = "64") {
            assert_eq!(std::mem::size_of::<LogicalSelection>(), 40);
            assert_eq!(std::mem::size_of::<Option<LogicalSelection>>(), 40);
            assert_eq!(std::mem::size_of::<Editing>(), 88);
            assert_eq!(std::mem::size_of::<SelectionSnapshot>(), 24);
            assert_eq!(std::mem::size_of::<Option<SelectionSnapshot>>(), 24);
            assert_eq!(std::mem::size_of::<Option<Box<Editing>>>(), 8);
            assert_eq!(std::mem::size_of::<Node>(), 40);
            assert_eq!(std::mem::size_of::<TextSite>(), 80);
        }
    }

    #[test]
    fn exhausted_epoch_rejects_focus_publication_without_changing_logical_focus() {
        let mut win = Win::demo(Inputs {
            a: Signal::new("first".into()),
            b: Signal::new("second".into()),
        });
        let input = win
            .role(crate::Role::TextInput)
            .text("first")
            .one()
            .unwrap();
        let caret = TextSelection {
            anchor: position(0).unwrap(),
            focus: position(0).unwrap(),
        };
        win.select(input, caret).unwrap();
        win.runtime_mut().unwrap().runtime.source_epoch = u64::MAX;
        assert_eq!(win.focus(input), Err(Error::EpochExhausted));
        assert_eq!(win.focused().unwrap(), None);
        assert_eq!(win.selection(input).unwrap(), caret);
    }
}
