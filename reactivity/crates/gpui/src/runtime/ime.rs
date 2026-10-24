//! IME owns a temporary display domain; source writes happen only at commit.
use super::editing::{position, validates};
use super::*;
use std::{
    ops::Range,
    sync::atomic::{AtomicU64, Ordering},
};

static NEXT_SESSION: AtomicU64 = AtomicU64::new(1);

/// One caller-owned IME stream, shared by native input and ordinary tests.
/// Enable binds it to this window's current focused source. Focus/source changes
/// revoke it; events from an old stream never acquire the next field's authority.
#[derive(Default, Debug)]
pub struct ImeSession {
    stamp: Option<NonZeroU64>,
}
impl ImeSession {
    /// Whether this transport has received Enabled without a terminal event.
    /// Source/focus changes can revoke runtime authority before the next event;
    /// this flag is not permission to edit or a current-presentation proof.
    pub fn is_enabled(&self) -> bool {
        self.stamp.is_some()
    }
}

/// Winit-compatible composition events. Cursor endpoints are UTF-8 byte offsets
/// within preedit, including valid character boundaries inside a grapheme.
/// None hides the caret. Empty Preedit clears the preview while retaining the
/// original replacement range for the following Commit. An ordinary editing key
/// instead cancels that cleared composition and resumes from the original
/// selection. Cancel ends the stream.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum ImeEvent<'a> {
    Enabled,
    Preedit {
        text: &'a str,
        cursor: Option<(usize, usize)>,
    },
    Commit(&'a str),
    Disabled,
    Cancel,
}

/// Marked UTF-8 bytes from the acknowledged display, not a source-edit range.
/// Cursor preserves the IME's exact byte intent. Part::selection supplies its
/// nearest legal grapheme endpoints for canonical geometry (ties downstream).
#[derive(Clone, Debug, PartialEq, Eq, Serialize)]
pub struct MarkedText {
    pub session: u64,
    pub range: Range<usize>,
    pub cursor: Option<Range<usize>>,
}
#[derive(Clone, Copy, PartialEq, Eq)]
pub(super) struct MarkSnapshot {
    identity: NonZeroU64,
    stamp: NonZeroU64,
    range: [u32; 2],
    cursor: Option<[u32; 2]>,
}
impl MarkSnapshot {
    pub fn marked(self, identity: u64) -> Option<MarkedText> {
        (self.identity.get() == identity).then(|| MarkedText {
            session: self.stamp.get(),
            range: self.range[0] as usize..self.range[1] as usize,
            cursor: self.cursor.map(|c| c[0] as usize..c[1] as usize),
        })
    }
    pub fn caret_visible(self, identity: u64) -> bool {
        self.identity.get() != identity || self.cursor.is_some()
    }
}
#[derive(Default)]
pub(super) struct Ime {
    active: Option<Box<Active>>,
    pub candidate: Option<MarkSnapshot>,
    pub presented: Option<MarkSnapshot>,
}
impl Ime {
    pub fn unused(&self) -> bool {
        self.active.is_none() && self.candidate.is_none() && self.presented.is_none()
    }
}
struct Active {
    stamp: NonZeroU64,
    target: Target,
    field: FieldId,
    epoch: u64,
    source: SharedText,
    preview: Option<Box<Preview>>,
}
pub(super) struct Preview {
    replacement: gpui_canvas::TextSelection,
    pub display: SharedText,
    pub selection: gpui_canvas::TextSelection,
    pub decoration: gpui_canvas::TextSelection,
    pub mark: MarkSnapshot,
}
fn nearest(value: &str, byte: usize) -> Result<gpui_canvas::TextPosition, Error> {
    let byte = icu_segmenter::GraphemeClusterSegmenter::new()
        .segment_str(value)
        .min_by_key(|&boundary| (boundary.abs_diff(byte), std::cmp::Reverse(boundary)))
        .unwrap_or(0);
    position(byte)
}
fn preview_selections(
    value: &str,
    marked: Range<usize>,
    cursor: Option<[u32; 2]>,
) -> Result<(gpui_canvas::TextSelection, gpui_canvas::TextSelection), Error> {
    // An ASCII prefix has no grapheme context before its final grapheme.
    // Retain that grapheme: a leading Extend can join it, and LF can follow CR.
    // Keep the complete suffix for joins across the other marked-text seam.
    // ASCII bytes also certify the restart offset is a UTF-8 boundary.
    let bytes = value.as_bytes();
    let mut base = if bytes.get(..marked.start).is_some_and(<[u8]>::is_ascii) {
        marked.start.saturating_sub(1)
    } else {
        0
    };
    if base > 0 && bytes[base - 1..=base] == *b"\r\n" {
        base -= 1;
    }
    // Keep the scan in suffix coordinates; translate its four results once.
    let [a, b] = cursor
        .map_or([marked.start; 2], |c| c.map(|n| n as usize))
        .map(|n| n - base);
    let marked = marked.start - base..marked.end - base;
    let mut anchor = 0;
    let mut focus = 0;
    let mut left = 0;
    let mut right = value.len() - base;
    let mut previous = 0;
    // Admission places both raw cursor endpoints inside the marked range. Each
    // nearest endpoint needs only its adjacent boundaries; ties go downstream.
    // The first boundary at/after marked.end also completes its decoration.
    for boundary in icu_segmenter::GraphemeClusterSegmenter::new().segment_str(&value[base..]) {
        let nearest = |byte: usize| {
            if byte.abs_diff(previous) < byte.abs_diff(boundary) {
                previous
            } else {
                boundary
            }
        };
        if (previous..=boundary).contains(&a) {
            anchor = nearest(a);
        }
        if (previous..=boundary).contains(&b) {
            focus = nearest(b);
        }
        if boundary <= marked.start {
            left = boundary;
        }
        if boundary >= marked.end {
            right = boundary;
            break;
        }
        previous = boundary;
    }
    Ok((
        gpui_canvas::TextSelection {
            anchor: position(base + anchor)?,
            focus: position(base + focus)?,
        },
        gpui_canvas::TextSelection {
            anchor: position(base + left)?,
            focus: position(base + right)?,
        },
    ))
}
impl<M: View + 'static> Runtime<M> {
    fn ime_active(&self) -> Option<&Active> {
        self.metadata
            .as_ref()?
            .editing
            .as_ref()?
            .ime
            .as_ref()?
            .active
            .as_deref()
    }
    fn ime_valid(&self, active: &Active) -> bool {
        self.logical_valid
            && self.focused == Some(active.target)
            && self.source_epoch == active.epoch
            && self.input_index(active.target).ok().is_some_and(|index| {
                let site = self.nodes[index].text_slot().get(&self.texts).unwrap();
                site.field == Some(active.field)
                    && std::ptr::eq::<str>(site.value.as_ref(), active.source.as_ref())
            })
    }
    pub(super) fn composition_preview(&self) -> Option<(u64, &Preview)> {
        let active = self.ime_active()?;
        self.ime_valid(active).then_some(())?;
        Some((
            self.sites.resolve(active.target)?,
            active.preview.as_deref()?,
        ))
    }
    pub(super) fn composition_snapshot(&self) -> Option<MarkSnapshot> {
        Some(self.composition_preview()?.1.mark)
    }
    pub(super) fn source_position(
        &self,
        target: Target,
        point: gpui_canvas::TextPosition,
    ) -> Result<gpui_canvas::TextPosition, Error> {
        let Some(active) = self
            .ime_active()
            .filter(|a| a.target == target && self.ime_valid(a))
        else {
            return Ok(point);
        };
        let Some(preview) = &active.preview else {
            return Ok(point);
        };
        let [start, end] = preview.mark.range.map(|n| n as usize);
        if start == end {
            return Ok(point);
        }
        let source_end = preview
            .replacement
            .anchor
            .offset
            .byte()
            .max(preview.replacement.focus.offset.byte());
        let byte = point.offset.byte();
        let mapped = if byte <= start {
            byte
        } else if byte >= end {
            byte - (end - start) + (source_end - start)
        } else if byte - start < end - byte {
            start
        } else {
            source_end
        };
        nearest(&active.source, mapped)
    }
    pub(super) fn ime_has_preedit(&self) -> bool {
        self.composition_preview()
            .is_some_and(|(_, preview)| preview.mark.range[0] != preview.mark.range[1])
    }
    pub(super) fn cancel_cleared_preedit(&mut self) -> bool {
        if self
            .composition_preview()
            .is_some_and(|(_, preview)| preview.mark.range[0] == preview.mark.range[1])
        {
            self.cancel_ime()
        } else {
            false
        }
    }
    fn invalidate_display(&mut self, target: Target) {
        if let Ok(index) = self.input_index(target) {
            self.nodes[index]
                .text_slot()
                .get_mut(&mut self.texts)
                .unwrap()
                .shaped = None;
            self.layout_dirty.insert(self.nodes[index].identity());
        }
        self.dirty = true;
    }
    pub(super) fn cancel_ime(&mut self) -> bool {
        let active = self
            .metadata
            .as_mut()
            .and_then(|m| m.editing.as_mut())
            .and_then(|e| e.ime.as_mut())
            .and_then(|ime| ime.active.take());
        let Some(active) = active else { return false };
        let changed = if let Some(preview) = active.preview.as_ref() {
            if self.ime_valid(&active)
                && let Ok(index) = self.input_index(active.target)
            {
                self.set_selection(index, preview.replacement, None);
            }
            self.invalidate_display(active.target);
            true
        } else {
            false
        };
        self.reclaim_ime();
        changed
    }
    pub(super) fn reconcile_ime(&mut self) -> bool {
        if self
            .ime_active()
            .is_some_and(|active| !self.ime_valid(active))
        {
            self.cancel_ime()
        } else {
            false
        }
    }
    pub(super) fn reclaim_ime(&mut self) {
        if let Some(editing) = self.metadata.as_mut().and_then(|m| m.editing.as_mut())
            && editing.ime.as_ref().is_some_and(|ime| ime.unused())
        {
            editing.ime = None;
        }
        if let Some(metadata) = &mut self.metadata
            && metadata.editing.as_ref().is_some_and(|e| e.unused())
        {
            metadata.editing = None;
        }
        if self.metadata.as_deref().is_some_and(Metadata::unused) {
            self.metadata = None;
        }
    }
    fn install_ime(&mut self, active: Box<Active>) {
        self.metadata
            .get_or_insert_with(Default::default)
            .editing
            .get_or_insert_with(Default::default)
            .ime
            .get_or_insert_with(Default::default)
            .active = Some(active);
    }
    fn refresh_ime(&self, active: &mut Active) -> bool {
        if !self.logical_valid
            || self.focused != Some(active.target)
            || active.epoch.checked_add(1) != Some(self.source_epoch)
        {
            return false;
        }
        let Ok(index) = self.input_index(active.target) else {
            return false;
        };
        let site = self.nodes[index].text_slot().get(&self.texts).unwrap();
        if site.field != Some(active.field) {
            return false;
        }
        // Only this stream's canonical write can advance its original source
        // capability. Rebinding/removal never acquires the next field.
        active.epoch = self.source_epoch;
        active.source = site.value.clone();
        true
    }
    fn bind_ime(&self, stamp: NonZeroU64) -> Result<Box<Active>, Error> {
        let target = self.focused.ok_or(Error::NotInput)?;
        let index = self.input_index(target)?;
        let site = self.nodes[index].text_slot().get(&self.texts).unwrap();
        Ok(Box::new(Active {
            stamp,
            target,
            field: site.field.unwrap(),
            epoch: self.source_epoch,
            source: site.value.clone(),
            preview: None,
        }))
    }
}
/// Native request generation; source bytes remain an exclusive runtime proof.
#[cfg(feature = "native-core")]
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub(crate) struct ImeTarget {
    target: Target,
    field: FieldId,
    epoch: u64,
}
impl<M: View + 'static, L: LaneSet<M>> Win<M, L> {
    #[cfg(feature = "native-core")]
    pub(crate) fn ime_target(&self) -> Option<ImeTarget> {
        let runtime = self.runtime().ok()?;
        if !runtime.logical_valid {
            return None;
        }
        let target = runtime.focused?;
        let index = runtime.input_index(target).ok()?;
        Some(ImeTarget {
            target,
            field: runtime.nodes[index]
                .text_slot()
                .get(&runtime.texts)?
                .field?,
            epoch: runtime.source_epoch,
        })
    }
    #[cfg(feature = "native-core")]
    pub(crate) fn ime_session_live(&self, session: &ImeSession) -> bool {
        self.runtime()
            .ok()
            .and_then(|r| {
                r.ime_active()
                    .map(|a| Some(a.stamp) == session.stamp && r.ime_valid(a))
            })
            .unwrap_or(false)
    }

    /// Apply the same scoped IME protocol as the native adapter. Preedit prepares
    /// a display candidate without changing Signal or source_epoch. Commit writes
    /// once through the ordinary text codec. A stale/cancelled stream is consumed.
    pub fn ime_event(
        &mut self,
        session: &mut ImeSession,
        event: ImeEvent<'_>,
    ) -> Result<Commit, Error> {
        let ending = matches!(event, ImeEvent::Cancel | ImeEvent::Disabled);
        let stamp = if ending {
            session.stamp.take()
        } else {
            session.stamp
        };
        let mut runtime = self.runtime_mut()?;
        let prior = runtime.ime_active().map(|active| active.target);
        let result = runtime.ime_event(stamp, event);
        match result {
            Ok((commit, next)) => {
                session.stamp = next;
                Ok(commit)
            }
            Err(error) => {
                session.stamp = None;
                runtime.cancel_ime();
                if let Some(target) = prior {
                    runtime.invalidate_display(target);
                }
                runtime.reclaim_ime();
                Err(error)
            }
        }
    }
    /// Candidate-window area from acknowledged text geometry in physical window
    /// coordinates, clipped by that presentation's transforms and viewports.
    /// A hidden IME cursor, detached P or revoked stream has no area.
    pub fn ime_cursor_area(&self, session: &ImeSession) -> Result<Option<Rect>, Error> {
        let runtime = self.runtime()?;
        let Some(active) = runtime
            .ime_active()
            .filter(|a| Some(a.stamp) == session.stamp && runtime.ime_valid(a))
        else {
            return Ok(None);
        };
        if !runtime.presentation_valid {
            return Ok(None);
        }
        let mut area = None;
        self.visit(|part| {
            if part.target() == active.target
                && part.marked_text().is_none_or(|mark| mark.cursor.is_some())
                && let Some(selection) = part.selection()
                && let Some(geometry) = part.text_geometry()
                && let Some(local) = geometry.layout().caret_bounds(selection.focus)
            {
                area = geometry.visible_bounds(local);
            }
        })?;
        Ok(area)
    }
}
impl<M: View + 'static, L: LaneSet<M>> RuntimeMut<'_, M, L> {
    fn update_preedit(
        &mut self,
        active: &mut Active,
        text: &str,
        cursor: Option<(usize, usize)>,
    ) -> Result<(), Error> {
        if cursor.is_some_and(|(a, b)| !text.is_char_boundary(a) || !text.is_char_boundary(b)) {
            self.runtime.invalidate_display(active.target);
            return Err(Error::InvalidSelection);
        }
        let index = self.input_index(active.target)?;
        let replacement = active
            .preview
            .as_ref()
            .map_or_else(|| self.selection_at(index), |p| Ok(p.replacement))?;
        if !validates(&active.source, replacement) {
            return Err(Error::InvalidSelection);
        }
        let start = replacement
            .anchor
            .offset
            .byte()
            .min(replacement.focus.offset.byte());
        let end = replacement
            .anchor
            .offset
            .byte()
            .max(replacement.focus.offset.byte());
        let joined_len = active
            .source
            .len()
            .checked_sub(end - start)
            .and_then(|n| n.checked_add(text.len()))
            .ok_or(Error::ResourceLimit)?;
        if joined_len > 32 * 1024 {
            self.runtime.invalidate_display(active.target);
            return Err(Error::ResourceLimit);
        }
        let identity = NonZeroU64::new(self.nodes[index].identity()).unwrap();
        let preview = active.preview.get_or_insert_with(|| {
            Box::new(Preview {
                replacement,
                display: active.source.clone(),
                selection: replacement,
                decoration: replacement,
                mark: MarkSnapshot {
                    identity,
                    stamp: active.stamp,
                    range: [start as u32; 2],
                    cursor: None,
                },
            })
        });
        let changed = if text.is_empty() {
            let changed = !std::ptr::eq::<str>(preview.display.as_ref(), active.source.as_ref());
            if changed {
                preview.display = active.source.clone();
            }
            changed
        } else {
            // Source and replacement stay fixed for this composition. Only the
            // raw UTF-8 middle can differ; an empty mark denotes Source itself.
            let [left, right] = preview.mark.range.map(|n| n as usize);
            let previous = if left == right {
                &active.source[start..end]
            } else {
                &preview.display[left..right]
            };
            if previous != text {
                preview.display =
                    SharedText::try_join([&active.source[..start], text, &active.source[end..]])
                        .ok_or(Error::ResourceLimit)?;
                true
            } else {
                false
            }
        };
        let finish = start + text.len();
        let exact = cursor.map(|(a, b)| [(start + a) as u32, (start + b) as u32]);
        (preview.selection, preview.decoration) =
            preview_selections(&preview.display, start..finish, exact)?;
        preview.mark = MarkSnapshot {
            identity,
            stamp: active.stamp,
            range: [start as u32, finish as u32],
            cursor: exact,
        };
        let source_caret = position(start)?;
        self.runtime.set_selection(
            index,
            gpui_canvas::TextSelection {
                anchor: source_caret,
                focus: source_caret,
            },
            None,
        );
        if changed {
            self.runtime.invalidate_display(active.target);
        }
        self.runtime.dirty = true;
        Ok(())
    }
    fn ime_event(
        &mut self,
        stamp: Option<NonZeroU64>,
        event: ImeEvent<'_>,
    ) -> Result<(Commit, Option<NonZeroU64>), Error> {
        self.live()?;
        self.changed_nodes = 0;
        self.runtime.reconcile_ime();
        if matches!(event, ImeEvent::Enabled) {
            self.runtime.cancel_ime();
            let next = NEXT_SESSION
                .try_update(Ordering::Relaxed, Ordering::Relaxed, |n| n.checked_add(1))
                .map_err(|_| Error::EpochExhausted)?;
            let stamp = NonZeroU64::new(next).expect("IME stamps start at one");
            let active = self.runtime.bind_ime(stamp)?;
            self.runtime.install_ime(active);
            let commit = if self.dirty {
                self.present()?
            } else {
                self.commit()
            };
            return Ok((commit, Some(stamp)));
        }
        if self.ime_active().is_none_or(|a| Some(a.stamp) != stamp) {
            return Ok((self.commit(), None));
        }
        if matches!(event, ImeEvent::Disabled | ImeEvent::Cancel) {
            let changed = self.runtime.cancel_ime();
            return Ok((
                if changed {
                    self.present()?
                } else {
                    self.commit()
                },
                None,
            ));
        }
        let mut active = self
            .metadata
            .as_mut()
            .unwrap()
            .editing
            .as_mut()
            .unwrap()
            .ime
            .as_mut()
            .unwrap()
            .active
            .take()
            .unwrap();
        match event {
            ImeEvent::Commit(text) => {
                let index = self.input_index(active.target)?;
                let range = active
                    .preview
                    .as_ref()
                    .map_or_else(|| self.selection_at(index), |p| Ok(p.replacement))?;
                // Restore the source selection before any fallible codec work.
                // Drop the composition display lease before canonical allocation;
                // Source ownership follows ordinary keyboard policy.
                self.runtime.set_selection(index, range, None);
                active.preview = None;
                self.runtime.invalidate_display(active.target);
                let commit = self.replace_input(active.target, Some(range), text)?;
                if self.runtime.refresh_ime(&mut active) {
                    self.runtime.install_ime(active);
                    Ok((commit, stamp))
                } else {
                    self.runtime.reclaim_ime();
                    Ok((commit, None))
                }
            }
            ImeEvent::Preedit { text, cursor } => {
                // Keep the exclusive owner installed even when validation or
                // preparation fails, so the common cancellation path restores
                // the original source selection and releases the active lease.
                let result = self.update_preedit(&mut active, text, cursor);
                self.runtime.install_ime(active);
                result?;
                Ok((self.present()?, stamp))
            }
            _ => unreachable!(),
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{El, Signal, Source, Sources, text_input};
    struct Input(Signal<String>);
    impl Input {
        const VALUE: Source<Self, String> =
            Source::new(FieldId::new(1), "value", |m| &m.0, |m| &mut m.0);
    }
    impl View for Input {
        fn sources() -> Sources<Self> {
            Sources::new().direct(Self::VALUE)
        }
        fn view(&self) -> El<'_> {
            text_input(&self.0).w(300)
        }
    }
    fn ack(win: &mut Win<Input>) {
        win.presented(win.with_scene(|_, t| t).unwrap()).unwrap();
    }
    #[test]
    fn one_pass_preview_geometry_matches_exact_full_scan_at_all_raw_byte_positions() {
        fn original_decoration(
            value: &str,
            start: usize,
            end: usize,
        ) -> gpui_canvas::TextSelection {
            let mut left = 0;
            let mut right = value.len();
            for boundary in icu_segmenter::GraphemeClusterSegmenter::new().segment_str(value) {
                if boundary <= start {
                    left = boundary;
                }
                if boundary >= end {
                    right = boundary;
                    break;
                }
            }
            gpui_canvas::TextSelection {
                anchor: position(left).unwrap(),
                focus: position(right).unwrap(),
            }
        }
        let mut cases = 0;
        for value in [
            "",
            "abc",
            "a\u{301}z",
            "👩‍❤️‍💋‍👨x",
            "🇫🇷🇯🇵",
            "👍🏽x",
            "עברית",
            "a\r\nb",
        ] {
            for start in 0..=value.len() {
                for end in start..=value.len() {
                    let decoration = original_decoration(value, start, end);
                    let hidden = preview_selections(value, start..end, None).unwrap();
                    assert_eq!(
                        hidden,
                        (
                            gpui_canvas::TextSelection {
                                anchor: nearest(value, start).unwrap(),
                                focus: nearest(value, start).unwrap()
                            },
                            decoration
                        )
                    );
                    for anchor in start..=end {
                        for focus in start..=end {
                            let cursor = Some([anchor as u32, focus as u32]);
                            let actual = preview_selections(value, start..end, cursor).unwrap();
                            let selected = gpui_canvas::TextSelection {
                                anchor: nearest(value, anchor).unwrap(),
                                focus: nearest(value, focus).unwrap(),
                            };
                            assert_eq!(
                                actual,
                                (selected, decoration),
                                "{value:?}/{start}/{end}/{anchor}/{focus}"
                            );
                            cases += 1;
                        }
                    }
                }
            }
        }
        assert_eq!(cases, 79_333);
    }
    #[test]
    fn ascii_restart_preserves_both_unicode_seams_and_full_scan_geometry() {
        let segmenter = icu_segmenter::GraphemeClusterSegmenter::new();
        let mut cases = 0;
        for byte in 0..=127 {
            for preedit in ["", "x", "\u{301}", "\u{fe0f}\u{20e3}", "👩‍", "🇦", "क्‍ष"]
            {
                for suffix in ["", "\n", "\u{301}", "💻", "🇧🇨", "ष"] {
                    let prefix = format!("left\r\n{}", char::from(byte));
                    let value = format!("{prefix}{preedit}{suffix}");
                    let marked = prefix.len()..prefix.len() + preedit.len();
                    let boundaries = segmenter.segment_str(&value).collect::<Vec<_>>();
                    let nearest = |byte: usize| {
                        position(
                            *boundaries
                                .iter()
                                .min_by_key(|&&n| (n.abs_diff(byte), std::cmp::Reverse(n)))
                                .unwrap(),
                        )
                        .unwrap()
                    };
                    let decoration = gpui_canvas::TextSelection {
                        anchor: position(
                            *boundaries.iter().rfind(|&&n| n <= marked.start).unwrap(),
                        )
                        .unwrap(),
                        focus: position(*boundaries.iter().find(|&&n| n >= marked.end).unwrap())
                            .unwrap(),
                    };
                    let offsets = (0..=preedit.len())
                        .filter(|&n| preedit.is_char_boundary(n))
                        .collect::<Vec<_>>();
                    for a in &offsets {
                        for b in &offsets {
                            let a = marked.start + a;
                            let b = marked.start + b;
                            assert_eq!(
                                preview_selections(
                                    &value,
                                    marked.clone(),
                                    Some([a as u32, b as u32]),
                                )
                                .unwrap(),
                                (
                                    gpui_canvas::TextSelection {
                                        anchor: nearest(a),
                                        focus: nearest(b),
                                    },
                                    decoration,
                                ),
                                "{value:?}/{marked:?}/{a}/{b}"
                            );
                            cases += 1;
                        }
                    }
                    assert_eq!(
                        preview_selections(&value, marked.clone(), None).unwrap(),
                        (
                            gpui_canvas::TextSelection {
                                anchor: nearest(marked.start),
                                focus: nearest(marked.start),
                            },
                            decoration,
                        ),
                    );
                }
            }
        }
        assert_eq!(cases, 43_008);
    }
    #[test]
    fn initial_equal_preedit_and_clear_reuse_the_exact_source_lease() {
        let mut win = Win::recording(
            Input(Signal::new("source".into())),
            WindowOptions::default(),
        )
        .unwrap();
        ack(&mut win);
        let target = win.input();
        win.focus(target).unwrap();
        win.select(
            target,
            gpui_canvas::TextSelection {
                anchor: position(0).unwrap(),
                focus: position(6).unwrap(),
            },
        )
        .unwrap();
        ack(&mut win);
        let mut session = ImeSession::default();
        win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
        let pointer = win.runtime().unwrap().ime_active().unwrap().source.as_ptr();
        for text in ["source", "", "source"] {
            win.ime_event(&mut session, ImeEvent::Preedit { text, cursor: None })
                .unwrap();
            let preview = win.runtime().unwrap().composition_preview().unwrap().1;
            assert!(std::ptr::eq(preview.display.as_ptr(), pointer));
            ack(&mut win);
        }
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "x",
                cursor: Some((0, 0)),
            },
        )
        .unwrap();
        let changed = win
            .runtime()
            .unwrap()
            .composition_preview()
            .unwrap()
            .1
            .display
            .clone();
        assert!(!std::ptr::eq(changed.as_ptr(), pointer));
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "source",
                cursor: Some((6, 6)),
            },
        )
        .unwrap();
        let equal = win
            .runtime()
            .unwrap()
            .composition_preview()
            .unwrap()
            .1
            .display
            .clone();
        assert_eq!(equal.as_ref(), "source");
        assert!(
            !std::ptr::eq(equal.as_ptr(), pointer),
            "equal bytes after different display retain baseline lease authority"
        );
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "source",
                cursor: Some((0, 0)),
            },
        )
        .unwrap();
        assert!(std::ptr::eq(
            win.runtime()
                .unwrap()
                .composition_preview()
                .unwrap()
                .1
                .display
                .as_ptr(),
            equal.as_ptr()
        ));
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "",
                cursor: None,
            },
        )
        .unwrap();
        assert!(std::ptr::eq(
            win.runtime()
                .unwrap()
                .composition_preview()
                .unwrap()
                .1
                .display
                .as_ptr(),
            pointer
        ));
        assert_eq!(changed.as_ref(), "x");
        win.ime_event(&mut session, ImeEvent::Commit("done"))
            .unwrap();
        assert_eq!(win.read(Input::VALUE).unwrap(), "done");
    }
    #[test]
    fn ime_cold_ownership_reuses_immutable_display_and_releases_after_final_ack() {
        let mut win = Win::recording(
            Input(Signal::new("source".into())),
            WindowOptions::default(),
        )
        .unwrap();
        ack(&mut win);
        let target = win.input();
        win.focus(target).unwrap();
        ack(&mut win);
        // Materialize the ordinary selection before measuring only IME admission.
        let selected = win.selection(target).unwrap();
        win.select(target, selected).unwrap();
        ack(&mut win);
        assert!(
            win.runtime()
                .unwrap()
                .metadata
                .as_ref()
                .unwrap()
                .editing
                .as_ref()
                .unwrap()
                .ime
                .is_none()
        );
        eprintln!(
            "IME_PUBLIC_VALUES event={} marked_text={}",
            size_of::<ImeEvent<'_>>(),
            size_of::<MarkedText>()
        );
        let mut promotion = None;
        let promoted = allocation_counter::measure(|| {
            promotion = Some(SharedText::from("twenty four bytes source!"));
        });
        eprintln!(
            "IME_TEXT_PROMOTION allocations={} bytes={} retained={} peak={} text_len={}",
            promoted.count_total,
            promoted.bytes_total,
            promoted.bytes_current,
            promoted.bytes_max,
            promotion.as_ref().unwrap().len()
        );
        drop(promotion);
        let mut session = ImeSession::default();
        let enabled = allocation_counter::measure(|| {
            win.ime_event(&mut session, ImeEvent::Enabled).unwrap();
        });
        eprintln!(
            "IME_ENABLED allocations={} bytes={} retained={} peak={}",
            enabled.count_total, enabled.bytes_total, enabled.bytes_current, enabled.bytes_max
        );
        let first = allocation_counter::measure(|| {
            win.ime_event(
                &mut session,
                ImeEvent::Preedit {
                    text: "long marked phrase",
                    cursor: Some((18, 18)),
                },
            )
            .unwrap();
        });
        eprintln!(
            "IME_FIRST_PREEDIT calling_thread_allocations={} bytes={} retained={} peak={}",
            first.count_total, first.bytes_total, first.bytes_current, first.bytes_max
        );
        ack(&mut win);
        let preview = win.runtime().unwrap().composition_preview().unwrap().1;
        let display = preview.display.as_ptr();
        assert_eq!(
            SharedText::strong_count(&preview.display),
            Some(2),
            "only active L and acknowledged P own display bytes"
        );
        eprintln!(
            "IME_LEASES display_strong={} source_strong={}",
            SharedText::strong_count(&preview.display).unwrap(),
            SharedText::strong_count(&win.runtime().unwrap().ime_active().unwrap().source).unwrap()
        );
        eprintln!(
            "IME_STORAGE session={} active={} preview={} mark={} owner={} editing={} text_resources={} display_bytes={}",
            size_of::<ImeSession>(),
            size_of::<Active>(),
            size_of::<Preview>(),
            size_of::<MarkSnapshot>(),
            size_of::<Ime>(),
            size_of::<super::super::editing::Editing>(),
            size_of::<super::super::text_geometry::TextResources>(),
            preview.display.len()
        );
        let old_display = preview.display.clone();
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "long marked phrase",
                cursor: Some((0, 0)),
            },
        )
        .unwrap();
        let preview = win.runtime().unwrap().composition_preview().unwrap().1;
        assert_eq!(
            preview.display.as_ptr(),
            display,
            "cursor-only update shares immutable display"
        );
        ack(&mut win);
        win.ime_event(
            &mut session,
            ImeEvent::Preedit {
                text: "x",
                cursor: Some((1, 1)),
            },
        )
        .unwrap();
        let preview = win.runtime().unwrap().composition_preview().unwrap().1;
        assert_ne!(preview.display.as_ptr(), display);
        assert_eq!(old_display.as_ref(), "sourcelong marked phrase");
        assert_eq!(preview.display.as_ref(), "sourcex");
        ack(&mut win);
        win.ime_event(&mut session, ImeEvent::Cancel).unwrap();
        let owner = win
            .runtime()
            .unwrap()
            .metadata
            .as_ref()
            .unwrap()
            .editing
            .as_ref()
            .unwrap()
            .ime
            .as_ref()
            .unwrap();
        assert!(
            owner.active.is_none(),
            "cancel immediately drops active and preview owners"
        );
        assert!(
            owner.presented.is_some(),
            "old P keeps its exact mark until ACK"
        );
        ack(&mut win);
        assert!(
            win.runtime()
                .unwrap()
                .metadata
                .as_ref()
                .unwrap()
                .editing
                .as_ref()
                .unwrap()
                .ime
                .is_none()
        );
        assert_eq!(win.read(Input::VALUE).unwrap(), "source");
        assert_eq!(old_display.as_ref(), "sourcelong marked phrase");
        assert_eq!(old_display.strong_count(), Some(1));
        win.close();
        assert!(win.inner.is_none());
        if cfg!(target_pointer_width = "64") {
            assert_eq!(size_of::<ImeSession>(), 8);
            assert_eq!(size_of::<Active>(), 56);
            assert_eq!(size_of::<Preview>(), 96);
            assert_eq!(size_of::<MarkSnapshot>(), 40);
            assert_eq!(size_of::<Ime>(), 88);
        }
    }
}
