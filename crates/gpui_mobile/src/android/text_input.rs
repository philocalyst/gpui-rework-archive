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

/// The document state the platform's input connection last received.
#[derive(PartialEq)]
struct Snapshot {
    session: u64,
    text: String,
    anchor: i32,
    focus: i32,
    marked: (i32, i32),
    generation: u64,
}

thread_local! {
    static LAST_SNAPSHOT: RefCell<Option<Snapshot>> = const { RefCell::new(None) };
}

/// Sends the focused input's text, selection and composition to the input connection, unless it
/// already has them. This runs after every drain, so an unchanged document isn't sent again.
fn sync_snapshot(
    slot: &Rc<RefCell<Option<PlatformInputHandler>>>,
    native_session: Option<&super::jni::NativeSession>,
) {
    let mut snapshot = Snapshot {
        session: SESSION.load(Ordering::Acquire),
        text: String::new(),
        anchor: 0,
        focus: 0,
        marked: (-1, -1),
        generation: PROCESSED_GENERATION.load(Ordering::Acquire),
    };
    let handler = slot.borrow_mut().take();
    if let Some(mut handler) = handler {
        let mut adjusted = None;
        let text = handler.text_for_range(0..usize::MAX, &mut adjusted);
        let selection = handler.selected_text_range(false);
        let marked = handler.marked_text_range();
        slot.borrow_mut().get_or_insert(handler);
        if let (Some(text), Some(selection)) = (text, selection) {
            let range = selection.range;
            let (anchor, focus) = if selection.reversed {
                (range.end, range.start)
            } else {
                (range.start, range.end)
            };
            snapshot.text = text;
            snapshot.anchor = anchor as i32;
            snapshot.focus = focus as i32;
            snapshot.marked =
                marked.map_or((-1, -1), |range| (range.start as i32, range.end as i32));
        }
    }
    if LAST_SNAPSHOT.with(|last| last.borrow().as_ref() == Some(&snapshot)) {
        return;
    }
    super::jni::sync_input_snapshot_for_runtime(
        native_session,
        snapshot.session,
        &snapshot.text,
        snapshot.anchor,
        snapshot.focus,
        snapshot.marked.0,
        snapshot.marked.1,
        snapshot.generation,
    );
    LAST_SNAPSHOT.with(|last| *last.borrow_mut() = Some(snapshot));
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
