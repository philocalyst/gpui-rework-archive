//! UI-thread IME events are queued, then applied on GPUI's native thread.

use crate::ime_ranges::{deletion_ranges, selection_after_deletion};
use gpui::{
    DispatchEventResult, KeyDownEvent, Keystroke, Modifiers, PlatformInput, PlatformInputHandler,
};
use parking_lot::Mutex;
use std::{
    cell::RefCell,
    collections::VecDeque,
    rc::Rc,
    sync::atomic::{AtomicBool, AtomicU64, Ordering},
};

static SESSION: AtomicU64 = AtomicU64::new(0);
static COMPOSING: AtomicBool = AtomicBool::new(false);
static PROCESSED_GENERATION: AtomicU64 = AtomicU64::new(0);
static EVENTS: Mutex<VecDeque<ImeEvent>> = Mutex::new(VecDeque::new());

pub(super) struct ImeEvent {
    pub session: u64,
    pub kind: i32,
    pub text: String,
    pub start: usize,
    pub end: usize,
    pub generation: u64,
}

pub(super) fn new_session() -> u64 {
    let session = SESSION.fetch_add(1, Ordering::AcqRel) + 1;
    EVENTS.lock().clear();
    COMPOSING.store(false, Ordering::Release);
    PROCESSED_GENERATION.store(0, Ordering::Release);
    session
}

pub(super) fn enqueue(event: ImeEvent) {
    let queued = super::jni::with_runtime_slot(|| {
        if event.session != SESSION.load(Ordering::Acquire) {
            return false;
        }
        EVENTS.lock().push_back(event);
        true
    });
    if queued {
        crate::mark_text_input_dirty();
    }
}

pub(super) fn drain(
    slot: &Rc<RefCell<Option<PlatformInputHandler>>>,
    input: &mut dyn FnMut(PlatformInput) -> DispatchEventResult,
    native_session: Option<&super::jni::NativeSession>,
) {
    let Some(events) = super::jni::with_current_runtime_state(native_session, || {
        std::mem::take(&mut *EVENTS.lock())
    }) else {
        return;
    };
    for event in events {
        let current = super::jni::with_current_runtime_state(native_session, || {
            if event.session != SESSION.load(Ordering::Acquire) {
                return false;
            }
            PROCESSED_GENERATION.fetch_max(event.generation, Ordering::AcqRel);
            match event.kind {
                0 => COMPOSING.store(true, Ordering::Release),
                1 => COMPOSING.store(false, Ordering::Release),
                _ => {}
            }
            true
        })
        .unwrap_or(false);
        if !current {
            continue;
        }
        if event.kind == 6 {
            // InputConnection.setSelection reports UTF-16 offsets from the proxy to
            // the focused GPUI field; the proxy itself intentionally has no document.
            let Some(mut handler) = slot.borrow_mut().take() else {
                continue;
            };
            handler.set_selected_text_range(event.start..event.end);
            let mut current = slot.borrow_mut();
            if current.is_none() {
                *current = Some(handler);
            }
            continue;
        }
        if event.kind == 5 {
            // The user hid the keyboard (back) but the input keeps focus: unlike 4 this
            // is not an Escape, which would close whatever owns the field (a search
            // overlay, with its query). See `jni::keyboard_hidden_by_user`.
            finish_composition(slot, native_session);
            super::jni::keyboard_hidden_by_user_for_runtime(native_session);
            continue;
        }
        if event.kind == 4 {
            finish_composition(slot, native_session);
            input(PlatformInput::KeyDown(KeyDownEvent {
                keystroke: Keystroke {
                    key: "escape".into(),
                    key_char: None,
                    modifiers: Modifiers::default(),
                },
                is_held: false,
                prefer_character_input: false,
            }));
            continue;
        }
        // No RefCell borrow spans a GPUI update (which may replace the handler).
        let Some(mut handler) = slot.borrow_mut().take() else {
            // There is no focused GPUI input target. Text must remain scoped
            // to this window's PlatformInputHandler; never fall back to a
            // process-global callback that could mutate another window.
            continue;
        };
        match event.kind {
            0 => {
                handler.replace_and_mark_text_in_range(
                    None,
                    &event.text,
                    Some(event.start..event.end),
                );
            }
            1 => {
                handler.replace_text_in_range(None, &event.text);
                handler.unmark_text();
            }
            2 | 3 => {
                if let Some(selection) = handler.selected_text_range(false) {
                    let mut adjusted = None;
                    if let Some(text) = handler.text_for_range(0..usize::MAX, &mut adjusted) {
                        let (before_range, after_range) = deletion_ranges(
                            &text,
                            selection.range.clone(),
                            handler.marked_text_range(),
                            event.start,
                            event.end,
                            event.kind == 3,
                        );
                        // Delete the right side first so left UTF-16 offsets remain valid.
                        if !after_range.is_empty() {
                            handler.replace_text_in_range(Some(after_range), "");
                        }
                        if !before_range.is_empty() {
                            handler.replace_text_in_range(Some(before_range.clone()), "");
                        }
                        // PlatformInputHandler replacement may collapse its live
                        // selection. AOSP deleteSurroundingText preserves the
                        // protected selection, so restore its directed endpoints
                        // after applying both surrounding ranges. A left-side
                        // deletion shifts both endpoints; a right-side deletion
                        // does not.
                        let directed = selection_after_deletion(
                            selection.range.clone(),
                            selection.reversed,
                            before_range,
                        );
                        handler.set_selected_text_range(directed);
                    }
                }
            }
            _ => {}
        }
        let mut current = slot.borrow_mut();
        if current.is_none() {
            *current = Some(handler);
        }
    }
    sync_snapshot(slot, native_session);
}

fn sync_snapshot(
    slot: &Rc<RefCell<Option<PlatformInputHandler>>>,
    native_session: Option<&super::jni::NativeSession>,
) {
    let Some(mut handler) = slot.borrow_mut().take() else {
        super::jni::sync_input_snapshot_for_runtime(
            native_session,
            SESSION.load(Ordering::Acquire),
            "",
            0,
            0,
            -1,
            -1,
            PROCESSED_GENERATION.load(Ordering::Acquire),
        );
        return;
    };
    let mut adjusted = None;
    let text = handler.text_for_range(0..usize::MAX, &mut adjusted);
    let selection = handler.selected_text_range(false);
    let marked = handler.marked_text_range();
    let mut current = slot.borrow_mut();
    if current.is_none() {
        *current = Some(handler);
    }
    drop(current);

    let (Some(text), Some(selection)) = (text, selection) else {
        super::jni::sync_input_snapshot_for_runtime(
            native_session,
            SESSION.load(Ordering::Acquire),
            "",
            0,
            0,
            -1,
            -1,
            PROCESSED_GENERATION.load(Ordering::Acquire),
        );
        return;
    };
    let (anchor, focus) = if selection.reversed {
        (selection.range.end, selection.range.start)
    } else {
        (selection.range.start, selection.range.end)
    };
    let (marked_start, marked_end) = marked
        .map(|range| (range.start as i32, range.end as i32))
        .unwrap_or((-1, -1));
    super::jni::sync_input_snapshot_for_runtime(
        native_session,
        SESSION.load(Ordering::Acquire),
        &text,
        anchor as i32,
        focus as i32,
        marked_start,
        marked_end,
        PROCESSED_GENERATION.load(Ordering::Acquire),
    );
}

pub(super) fn finish_composition(
    slot: &Rc<RefCell<Option<PlatformInputHandler>>>,
    native_session: Option<&super::jni::NativeSession>,
) {
    let composing = super::jni::with_current_runtime_state(native_session, || {
        COMPOSING.swap(false, Ordering::AcqRel)
    })
    .unwrap_or(false);
    if !composing {
        return;
    }
    let handler = slot.borrow_mut().take();
    if let Some(mut handler) = handler {
        handler.unmark_text();
        let mut current = slot.borrow_mut();
        if current.is_none() {
            *current = Some(handler);
        }
    }
    super::jni::reset_keyboard_composition_for_runtime(native_session);
}

/// Keep the original TextInput callback contract for clients without a platform
/// input handler. Its backspace sentinel deletes one character per callback;
/// exact UTF-16 ranges and forward deletion require PlatformInputHandler.
#[cfg(test)]
fn forward_legacy_text(kind: i32, text: &str, before: usize, mut dispatch: impl FnMut(&str)) {
    match kind {
        1 => dispatch(text),
        2 | 3 => {
            for _ in 0..before {
                dispatch("\x08");
            }
        }
        _ => {}
    }
}

#[cfg(test)]
mod tests {
    use super::forward_legacy_text;
    #[test]
    fn legacy_inputs_receive_commits_and_backspace_sentinels() {
        let mut received = Vec::new();
        for (kind, text, before) in [(0, "ni", 0), (1, "你", 0), (2, "", 1), (3, "", 2)] {
            forward_legacy_text(kind, text, before, |text| received.push(text.to_owned()));
        }
        assert_eq!(received, vec!["你", "\x08", "\x08", "\x08"]);
    }
}
