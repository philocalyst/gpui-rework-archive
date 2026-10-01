use crate::editable_text::{
    TextBoundary, UnicodeTextStorage,
    actions::EditableTextActionHandler,
    caret::CaretNotify,
    history::{EditableTextHistory, HistoryKind, HistorySnapshot},
    layout::{EditableTextLayoutResult, TextLineSegment},
};
use crate::rich_text::{
    Affinity, Change, ChangeError, ChangeSet, Document, InlineStyle, RangeSet, RichText, Selection,
    SelectionDirection, Span, Transaction, TransactionBuilder,
};
use gpui::{
    App, Bounds, ClipboardItem, Context, ElementId, Entity, EntityInputHandler, EventEmitter,
    FocusHandle, Focusable, NavigationDirection, Pixels, Point, UTF16Selection, Window, point,
};
use std::{borrow::Cow, cell::RefCell, ops::Range, sync::Arc};

const CARET_PIXELS_EPSILON: Pixels = gpui::px(4.);

fn utf16_offset_in_text(text: &str, utf16_offset: usize) -> usize {
    let mut utf16_index = 0;
    for (byte_index, character) in text.char_indices() {
        if utf16_index >= utf16_offset {
            return byte_index;
        }
        utf16_index += character.len_utf16();
        if utf16_index >= utf16_offset {
            return byte_index + character.len_utf8();
        }
    }
    text.len()
}

/// Internal state for EditableText elements.
pub struct EditableTextState {
    /// The storage medium backing this element-state. Hypothetically supports both
    /// std String and other crates (e.g. long document text).
    storage: Box<dyn UnicodeTextStorage>,
    /// Stable document snapshot for this state generation, including legacy storage adapters.
    document_snapshot_cache: RefCell<Option<(u64, Document)>>,
    /// Monotonic state revision, including text and formatting transactions.
    generation: u64,
    /// A caret move needs to be resolved against the next freshly shaped layout.
    pending_scroll_to_caret: bool,
    /// Prevents transactions prepared by another field from applying to this one.
    owner: Arc<()>,

    /// The directional selection, including its anchor and moving caret head.
    selection: Selection,
    /// Persistent inline formatting owned by this state.
    inline_styles: RangeSet<InlineStyle>,
    /// True while an IME composition is represented by one history transition.
    ime_history_active: bool,
    /// Whether the current composition has made a recorded text change.
    ime_history_recorded: bool,

    /// The utf-8 character range of `storage` which is being composed by IME
    marked_range: Option<Range<usize>>,

    /// True while the user is in the act of highlighting a section of the text (e.g. during mouse pressed & dragging).
    is_selecting: bool,
    /// The last ui location relative to the element that the user clicked. Used to filter when a user clicks multiple times in the same area.
    last_click_position: Option<Point<Pixels>>,
    /// The number of times the user has clicked `last_click_position`. Used to determine which click behavior to trigger, depending on single, double, or triple clicks.
    click_count: usize,

    focus_handle: FocusHandle,
    history: Option<EditableTextHistory>,

    pub(super) layout_data: EditableTextLayoutResult,
}

impl EventEmitter<CaretNotify> for EditableTextState {}

/// Event emitted when an `EditableTextState`'s document text changes, including undo and redo.
///
/// This is not suitable for input sanitation (which should occur before the mutation).
/// Formatting-only changes notify the state without emitting this text event.
pub struct TextChanged;
impl EventEmitter<TextChanged> for EditableTextState {}

/// Event emitted after a validated text edit has been committed.
///
/// Undo and redo emit [`TextChanged`] when they restore text. They do not emit `TextEdited`, since
/// a grouped edit or IME composition may contain several intermediate change sets.
#[derive(Clone, Debug)]
pub struct TextEdited {
    /// All replacements in this atomic edit, expressed against the pre-edit snapshot.
    pub changes: ChangeSet,
}
impl EventEmitter<TextEdited> for EditableTextState {}

/// A state-bound builder for atomic edits in original-snapshot byte coordinates.
#[must_use = "build and dispatch the transaction to apply its edits"]
pub struct EditableTextTransactionBuilder {
    builder: TransactionBuilder,
    owner: Arc<()>,
    generation: u64,
}

impl EditableTextTransactionBuilder {
    /// Adds a replacement using byte coordinates from the state snapshot.
    pub fn replace(mut self, range: Range<usize>, text: impl Into<String>) -> Self {
        self.builder = self.builder.replace(range, text);
        self
    }

    /// Sets the resulting directional selection in post-edit byte coordinates.
    pub fn selection(mut self, selection: Selection) -> Self {
        self.builder = self.builder.selection(selection);
        self
    }

    /// Validates the batch and binds it to this editor state generation.
    pub fn build(self) -> Result<EditableTextTransaction, ChangeError> {
        Ok(EditableTextTransaction {
            transaction: self.builder.build()?,
            owner: self.owner,
            generation: self.generation,
        })
    }
}

/// A validated edit batch tied to one editable-text state and revision.
#[derive(Clone, Debug)]
pub struct EditableTextTransaction {
    transaction: Transaction,
    owner: Arc<()>,
    generation: u64,
}

impl EditableTextTransaction {
    /// Returns the validated edits, in original-snapshot byte coordinates.
    pub fn changes(&self) -> &ChangeSet {
        self.transaction.change_set()
    }

    /// Returns the explicitly supplied post-edit selection, if any.
    pub fn selection(&self) -> Option<Selection> {
        self.transaction.selection()
    }
}

impl Focusable for EditableTextState {
    fn focus_handle(&self, _: &App) -> FocusHandle {
        self.focus_handle.clone()
    }
}

impl AsRef<str> for EditableTextState {
    fn as_ref(&self) -> &str {
        self.as_str()
    }
}

impl EditableTextState {
    /// Uses a pre-existing state attached to the element at `key`, as long as the element has existed over consecutive frames.
    /// If the state does not yet exist, a new one is created using the default [`UnicodeTextStorage`] medium.
    pub fn use_keyed(key: impl Into<ElementId>, window: &mut Window, cx: &mut App) -> Entity<Self> {
        Self::use_keyed_init(key, window, cx, |_, _| Document::new(""))
    }

    /// Uses a pre-existing state attached to the element at `key`, as long as the element has existed over consecutive frames.
    /// If the state does not yet exist, a new one is created calling `init` to create a [`UnicodeTextStorage`] medium.
    ///
    /// ```
    /// # use gpui::{RenderOnce, Window, App, IntoElement, ElementId};
    /// # use gpui_ce_elements::editable_text::{EditableTextState, StringStorage, editable_text};
    /// pub struct Form;
    /// impl RenderOnce for Form {
    ///     fn render(self, window: &mut Window, cx: &mut App) -> impl IntoElement {
    ///         let field_a_id = ElementId::from("field_a");
    ///         let field_a = EditableTextState::use_keyed_init(field_a_id.clone(), window, cx,
    ///             |_window, _cx| StringStorage::from("this is some default editable text content"));
    ///         editable_text(field_a_id).state(field_a.downgrade())
    ///     }
    /// }
    /// ```
    pub fn use_keyed_init<F, StorageType>(
        key: impl Into<ElementId>,
        window: &mut Window,
        cx: &mut App,
        init: F,
    ) -> Entity<Self>
    where
        F: 'static + FnOnce(&mut Window, &mut Context<'_, EditableTextState>) -> StorageType,
        StorageType: 'static + UnicodeTextStorage,
    {
        window.use_keyed_state(key, cx, |window, cx| Self::new(init(window, cx), cx))
    }

    /// Uses keyed state initialized once from rich text, including its persistent inline styles.
    pub fn use_keyed_rich_text<F>(
        key: impl Into<ElementId>,
        window: &mut Window,
        cx: &mut App,
        init: F,
    ) -> Entity<Self>
    where
        F: 'static + FnOnce(&mut Window, &mut Context<'_, EditableTextState>) -> RichText,
    {
        window.use_keyed_state(key, cx, |window, cx| {
            Self::from_rich_text(init(window, cx), cx)
        })
    }

    /// Creates a new EditableText state with a given storage medium.
    ///
    /// Does not intrinsicly handle the state being attached to an element
    /// over multiple frames (e.g. via [`RenderOnce`]). Use [`use_keyed`] or [`use_keyed_init`] for that.
    ///
    /// Expected to be called via [`AppContext::new`] such as:
    /// ```
    /// # use gpui::{AppContext, Window, App, Entity};
    /// # use gpui_ce_elements::editable_text::{StringStorage, EditableTextState};
    /// # fn new(_window: &mut Window, cx: &mut App) -> Entity<EditableTextState> {
    /// cx.new(|cx| EditableTextState::new(StringStorage::default(), cx))
    /// # }
    /// ```
    pub fn new(storage: impl UnicodeTextStorage + 'static, cx: &mut Context<Self>) -> Self {
        Self {
            storage: Box::new(storage),
            document_snapshot_cache: RefCell::default(),
            generation: 0,
            pending_scroll_to_caret: false,
            owner: Arc::new(()),

            selection: Selection::new(0, 0),
            inline_styles: RangeSet::default(),
            ime_history_active: false,
            ime_history_recorded: false,
            marked_range: None,

            is_selecting: false,
            last_click_position: None,
            click_count: 0,

            focus_handle: cx.focus_handle(),
            // TODO: what is the best way to give users access to configure this via element
            history: Some(EditableTextHistory::default()),

            layout_data: EditableTextLayoutResult::default(),
        }
    }

    /// Creates state from rich text with a fresh undo history.
    pub fn from_rich_text(rich_text: RichText, cx: &mut Context<Self>) -> Self {
        let mut state = Self::new(Document::from_shared_string(rich_text.shared_string()), cx);
        state.inline_styles = rich_text.ranges().clone();
        state
    }

    /// Returns a flat presentation snapshot with the current text and persistent marks.
    ///
    /// A native persistent document is flattened and cached on the first call per text revision;
    /// callers that recompute this value every frame should cache it at the view level.
    pub fn rich_text_snapshot(&self) -> RichText {
        RichText::try_from_parts(self.shared_string(), self.inline_styles.clone())
            .expect("editable text marks are kept within UTF-8 document boundaries")
    }

    /// Returns the current contents of [`storage`] as a string slice.
    pub fn as_str(&self) -> &str {
        self.storage.content_utf8()
    }

    pub fn version(&self) -> u16 {
        self.generation as u16
    }

    /// Returns the storage revision used by text layout and external transactions.
    pub fn revision(&self) -> u64 {
        self.generation
    }

    /// Returns the document's UTF-8 byte length without flattening a persistent backend.
    pub fn len_bytes(&self) -> usize {
        self.storage.len_bytes()
    }

    /// Returns the current content as a shared snapshot.
    pub fn shared_string(&self) -> gpui::SharedString {
        self.storage.shared_string()
    }

    /// Returns a persistent snapshot of this state’s text document.
    pub fn document_snapshot(&self) -> Document {
        if let Some((generation, document)) = self.document_snapshot_cache.borrow().as_ref()
            && *generation == self.generation
        {
            return document.clone();
        }

        let document = self.storage.document_snapshot();
        self.document_snapshot_cache
            .replace(Some((self.generation, document.clone())));
        document
    }

    /// Replaces the contents of the stored text with the provided string slice.
    pub fn emplace(&mut self, content: &str, cx: &mut Context<Self>) {
        self.finish_ime_history();
        let len = self.storage.len_bytes();
        let changes = self.replace_text_with_grouping(0..len, content, false);
        self.emit_text_edited(&changes, cx);
        cx.notify();
    }

    /// Returns the current selection as a canonical UTF-8 byte range.
    pub(super) fn selected_range(&self) -> Range<usize> {
        self.selection.range()
    }

    pub(super) fn selection_direction(&self) -> Option<NavigationDirection> {
        if self.selection.is_empty() {
            None
        } else {
            match self.selection.direction() {
                SelectionDirection::Backward => Some(NavigationDirection::Back),
                SelectionDirection::Forward => Some(NavigationDirection::Forward),
            }
        }
    }

    /// Returns the position of the caret in utf8 character space.
    pub(super) fn caret_pos(&self) -> usize {
        self.selection.caret()
    }

    /// Returns the current directional selection in UTF-8 byte offsets.
    pub fn selection(&self) -> Selection {
        self.selection
    }

    /// Returns persistent inline formatting in document byte coordinates.
    pub fn inline_styles(&self) -> &RangeSet<InlineStyle> {
        &self.inline_styles
    }

    /// Starts an atomic edit batch against this state's current text snapshot.
    ///
    /// The returned transaction also captures the state generation and identity. A transaction
    /// becomes stale after any text or formatting edit, undo, redo, or field replacement.
    /// Caret-only moves do not stale it: omitted result selections are mapped from the live
    /// selection at dispatch, while an explicit result selection is applied as requested.
    pub fn transaction(&self) -> EditableTextTransactionBuilder {
        EditableTextTransactionBuilder {
            builder: self.document_snapshot().transaction(),
            owner: self.owner.clone(),
            generation: self.generation,
        }
    }

    /// Applies one validated atomic edit batch to this state.
    pub fn dispatch(
        &mut self,
        transaction: &EditableTextTransaction,
        cx: &mut Context<Self>,
    ) -> Result<(), ChangeError> {
        self.dispatch_inner(transaction, None, cx)
    }

    /// Applies an edit batch and installs inline styles expressed in its post-edit coordinates.
    ///
    /// This is useful for commands that produce text and annotations together, such as pasting
    /// parsed rich text. All ranges are validated before either text or styles are changed.
    pub fn dispatch_with_styles(
        &mut self,
        transaction: &EditableTextTransaction,
        inline_styles: RangeSet<InlineStyle>,
        cx: &mut Context<Self>,
    ) -> Result<(), ChangeError> {
        self.dispatch_inner(transaction, Some(inline_styles), cx)
    }

    /// Replaces a byte range with rich text, mapping existing marks and shifting fragment marks
    /// into place as one undoable edit. Existing destination properties remain underneath the
    /// imported style, so imported properties override matching values and inherit the rest.
    pub fn replace_rich_text(
        &mut self,
        range: Range<usize>,
        rich_text: RichText,
        cx: &mut Context<Self>,
    ) -> Result<(), ChangeError> {
        let caret = range
            .start
            .checked_add(rich_text.as_str().len())
            .ok_or(ChangeError::LengthOverflow)?;
        let transaction = self
            .transaction()
            .replace(range.clone(), rich_text.as_str().to_owned())
            .selection(Selection::new(caret, caret))
            .build()?;
        let changes = transaction.changes();
        let start = changes.map_position(range.start, Affinity::Before)?;
        let mut spans: Vec<_> = self
            .inline_styles
            .map_through(changes)?
            .iter()
            .cloned()
            .collect();
        spans.extend(rich_text.ranges().iter().map(|span| span.shifted(start)));
        self.dispatch_with_styles(&transaction, RangeSet::new(spans), cx)
    }

    fn dispatch_inner(
        &mut self,
        transaction: &EditableTextTransaction,
        replacement_styles: Option<RangeSet<InlineStyle>>,
        cx: &mut Context<Self>,
    ) -> Result<(), ChangeError> {
        if !Arc::ptr_eq(&self.owner, &transaction.owner)
            || self.generation != transaction.generation
        {
            return Err(ChangeError::StaleSource);
        }

        let changes = transaction.changes();
        let replacing_styles = replacement_styles.is_some();
        let selection = match transaction.selection() {
            Some(selection) => selection,
            None => self.selection.map_through(changes)?,
        };
        changes.validate_result_position(selection.anchor)?;
        changes.validate_result_position(selection.head)?;

        let inline_styles = match replacement_styles {
            Some(styles) => {
                for (index, span) in styles.iter().enumerate() {
                    if span.range.start > span.range.end {
                        return Err(ChangeError::ReversedRange { index });
                    }
                    changes.validate_result_position(span.range.start)?;
                    changes.validate_result_position(span.range.end)?;
                }
                styles
            }
            None => self.inline_styles.map_through(changes)?,
        };

        let text_changed = !changes.is_empty();
        let styles_changed = inline_styles != self.inline_styles;
        if !text_changed && !styles_changed {
            if selection != self.selection {
                self.break_history_grouping();
            }
            self.selection = selection;
            self.scroll_to_caret();
            cx.notify();
            return Ok(());
        }

        self.finish_ime_history();
        let before = self.history_snapshot();
        self.storage.apply_changes(changes)?;
        self.inline_styles = inline_styles;
        self.selection = selection;
        self.marked_range = None;
        self.ime_history_active = false;
        self.ime_history_recorded = false;
        self.bump_generation();

        let after = self.history_snapshot();
        let one_simple_insert = !replacing_styles
            && transaction.selection().is_none()
            && changes.changes().len() == 1
            && changes.changes()[0].range.is_empty()
            && !changes.changes()[0].insert.is_empty()
            && before.selection.is_empty()
            && before.selection.head == changes.changes()[0].range.start;
        if let Some(history) = &mut self.history {
            history.record(before, after, one_simple_insert, text_changed);
        }

        if text_changed {
            cx.emit(TextEdited {
                changes: changes.clone(),
            });
            self.emit_text_changed(cx);
        }
        self.scroll_to_caret();
        cx.notify();
        Ok(())
    }

    /// Applies inline styling to the current selection as one undoable formatting operation.
    ///
    /// A collapsed selection creates a point annotation that expands around subsequent inserted
    /// text, preserving the style as formatting at the caret.
    pub fn format_selection(&mut self, style: InlineStyle, cx: &mut Context<Self>) {
        if style == InlineStyle::default() {
            return;
        }
        let range = self.selection.range();
        if self.inline_styles.iter().last().is_some_and(|span| {
            span.range == range
                && span.start_affinity == Affinity::Before
                && span.end_affinity == Affinity::After
                && span.value() == &style
        }) {
            return;
        }
        if self.ime_history_active {
            self.finish_ime_history();
        }
        let before = self.history_snapshot();
        let inline_styles =
            self.inline_styles
                .with(Span::new(range, Affinity::Before, Affinity::After, style));
        if inline_styles == self.inline_styles {
            return;
        }

        self.inline_styles = inline_styles;
        self.bump_generation();
        let after = self.history_snapshot();
        if let Some(history) = &mut self.history {
            history.record(before, after, false, false);
        }
        cx.notify();
    }

    /// Returns the IME marked range for character operations.
    pub(super) fn marked_range(&self) -> Option<Range<usize>> {
        self.marked_range.clone()
    }
}

impl EditableTextState {
    /// Validates/sanitizes incoming text according to the rules of the field.
    fn validate_incoming_text<'text>(
        &self,
        _range: &Range<usize>,
        text_to_insert: &'text str,
    ) -> Cow<'text, str> {
        // TODO: Apply text sanitization, ideally using externally-sourced implementations.
        // example optional/opt-in sanitations include:
        // - single-line fields should prune /n & /r
        // - maximum utf8 length
        // - numbers only
        // should also consider validation support, for features such as:
        // - total syntax evaluation (e.g. passwords)
        // - conforms to regex or math (e.g. ssn, phone number, email, etc)
        let mut text_to_insert = Cow::Borrowed(text_to_insert);

        if !self.layout_data.supports_multiline
            && (text_to_insert.contains('\n') || text_to_insert.contains('\r'))
        {
            text_to_insert = Cow::Owned(text_to_insert.replace(['\n', '\r'], ""));
        }

        /* A sample implementation of max-length sampled from gpuikit
        // Decide the effective new text up front (honouring `max_length`).
        // This avoids the "apply, then truncate" path which would leave the caret past the end.
        let max_length = None::<usize>;
        if let Some(cap) = max_length {
            let existing_len = self.as_str().len() - (range.end - range.start);
            let room = cap.saturating_sub(existing_len);
            text_to_insert = &text_to_insert[..text_to_insert.len().min(room)];
        }
        */

        // for now, this function is no-op
        text_to_insert
    }

    /// Internal method for one text replacement. Selection moves after inserted text, and marks
    /// and history selection state are mapped through the exact same validated edit batch.
    fn replace_text(&mut self, range: Range<usize>, text_to_insert: &str) -> ChangeSet {
        self.replace_text_with_grouping(range, text_to_insert, true)
    }

    fn replace_text_with_grouping(
        &mut self,
        range: Range<usize>,
        text_to_insert: &str,
        allow_grouping: bool,
    ) -> ChangeSet {
        let range_start = self.storage.clamp_byte_offset(range.start.min(range.end));
        let range_end = self.storage.clamp_byte_offset(range.start.max(range.end));
        let range = range_start..range_end;
        let document = self.document_snapshot();
        let changes =
            ChangeSet::for_document(&document, [Change::new(range.clone(), text_to_insert)])
                .expect("internal editable-text replacement must use a valid document range");

        let before = self.history_snapshot();
        let styles = self
            .inline_styles
            .map_through(&changes)
            .expect("persistent inline styles must map through a validated edit");
        let end_pos = changes
            .map_position(range.end, Affinity::After)
            .expect("replacement range end must map to the new document");
        if !changes.is_empty() {
            let was_composing = self.ime_history_active;
            self.storage
                .apply_changes(&changes)
                .expect("change set was validated against the current document snapshot");
            self.inline_styles = styles;
            self.selection = Selection::new(end_pos, end_pos);
            self.bump_generation();
            let after = self.history_snapshot();
            if let Some(history) = &mut self.history {
                if was_composing && self.ime_history_recorded {
                    history.update_composition_after(after);
                } else {
                    let simple_insert = allow_grouping
                        && range.is_empty()
                        && !text_to_insert.is_empty()
                        && before.selection.is_empty()
                        && before.selection.head == range.start;
                    history.record(before, after, simple_insert, true);
                    if was_composing {
                        self.ime_history_recorded = true;
                    }
                }
            }
        } else {
            self.selection = Selection::new(end_pos, end_pos);
        }
        self.marked_range = None;
        changes
    }

    fn emit_text_changed(&self, cx: &mut Context<Self>) {
        cx.emit(TextChanged);
    }

    fn emit_text_edited(&self, changes: &ChangeSet, cx: &mut Context<Self>) {
        if changes.is_empty() {
            return;
        }
        cx.emit(TextEdited {
            changes: changes.clone(),
        });
        self.emit_text_changed(cx);
    }

    fn history_snapshot(&self) -> HistorySnapshot {
        HistorySnapshot {
            document: self.document_snapshot(),
            inline_styles: self.inline_styles.clone(),
            selection: self.selection,
        }
    }

    fn bump_generation(&mut self) {
        self.generation = self
            .generation
            .checked_add(1)
            .expect("editable text generation overflowed");
    }

    fn break_history_grouping(&mut self) {
        if let Some(history) = &mut self.history {
            history.break_grouping();
        }
    }

    fn finish_ime_history(&mut self) {
        let was_composing = self.ime_history_active || self.ime_history_recorded;
        if self.ime_history_recorded
            && let Some(history) = &mut self.history
        {
            history.discard_noop_composition();
        }
        self.marked_range = None;
        self.ime_history_active = false;
        self.ime_history_recorded = false;
        if was_composing {
            self.break_history_grouping();
        }
    }
}

/// Parameters used to find a desired TextLineSegment from layout data.
enum TextSegmentQuery {
    /// Find the line containing a character at a position (relative to the document, not a given line).
    CharacterPosition(usize),
    /// Find the line that most closely contains the provided screen position.
    ScreenPosition {
        point: Point<Pixels>,
        line_height: Pixels,
    },
    /// Find the line containing a visual row of text, which may be wrapped
    /// (relative to the document, not a given line).
    Row(usize),
}

// Screen space (text layout engine output) & String space transformers
impl EditableTextState {
    /// Attempts to find a text segment based on the provided query parameters.
    /// If found, the returned tuple is the segment & the number of preceding visual rows.
    /// If not found, the resulting "err" is the total number of visual rows of all line segments.
    fn find_segment(&self, query: TextSegmentQuery) -> Result<(&TextLineSegment, usize), usize> {
        let lines = self.layout_data.lines.as_ref();
        let Some(last) = lines.last() else {
            return Err(0);
        };
        let total_rows = last.pos_y + last.row_count();

        let (index, row) = match query {
            TextSegmentQuery::CharacterPosition(position) => {
                let index = lines
                    .partition_point(|segment| segment.text_range.start <= position)
                    .saturating_sub(1);
                let segment = &lines[index];
                if segment.contains_position(position, false) {
                    return Ok((segment, segment.pos_y));
                }
                if index + 1 == lines.len() && position >= segment.text_range.end {
                    // Caret-at-end is a valid position after the last text byte. Line-clamped
                    // layouts also place out-of-range carets at their final visible segment.
                    return Ok((segment, segment.pos_y));
                }
                return Err(total_rows);
            }
            TextSegmentQuery::ScreenPosition { point, line_height } => {
                let row = if line_height > Pixels::ZERO {
                    (point.y / line_height).floor().max(0.) as usize
                } else {
                    0
                };
                let index = lines
                    .partition_point(|segment| segment.pos_y <= row)
                    .saturating_sub(1);
                (index, row)
            }
            TextSegmentQuery::Row(row) => {
                let index = lines
                    .partition_point(|segment| segment.pos_y <= row)
                    .saturating_sub(1);
                (index, row)
            }
        };

        let segment = &lines[index];
        if row >= segment.pos_y && row < segment.pos_y + segment.row_count() {
            Ok((segment, segment.pos_y))
        } else {
            Err(total_rows)
        }
    }

    /// Returns the utf-8 character position of the start of the line that contains the provided pixel-point.
    fn index_for_pixel_point(&self, point: Point<Pixels>, line_height: Pixels) -> usize {
        let storage_len_utf8 = self.storage.len_bytes();
        if storage_len_utf8 == 0 {
            return 0;
        }

        let segment = self.find_segment(TextSegmentQuery::ScreenPosition { point, line_height });
        let Ok((segment, _preceding_row_count)) = segment else {
            return storage_len_utf8;
        };

        // the screen position of the caret relative to the text segment
        let relative_point = point - gpui::point(Pixels::ZERO, segment.pos_y * line_height);

        return segment.character_index_at_point(relative_point, line_height);
    }

    fn find_position_in_vertical_direction(
        &self,
        direction: i32,
        line_height: Pixels,
    ) -> Option<usize> {
        let (caret_line_index, caret_point) = self.line_index_and_point_at_caret(line_height);
        let target_line_index = caret_line_index.saturating_add_signed(direction as isize);

        let segment = self.find_segment(TextSegmentQuery::Row(target_line_index));
        let Ok((segment, preceding_row_count)) = segment else {
            return (direction > 0).then(|| self.storage.len_bytes());
        };

        // calculate the screen space position of the row we are navigating to,
        // relative to the y-position of the segment.
        let row_index = (target_line_index - preceding_row_count) as f32;
        let relative_point = gpui::point(caret_point.x, row_index * line_height);

        Some(segment.character_index_at_point(relative_point, line_height))
    }

    fn line_index_and_point_at_caret(&self, line_height: Pixels) -> (usize, Point<Pixels>) {
        if self.layout_data.lines.is_empty() {
            return (0, Point::default());
        }

        let caret_pos = self.caret_pos();
        let segment = self.find_segment(TextSegmentQuery::CharacterPosition(caret_pos));
        let (segment, preceding_row_count) = match segment {
            Ok(segment) => segment,
            Err(total_row_count) => return (total_row_count.saturating_sub(1), Point::default()),
        };

        // Find the screen position relative to this segment where the caret is at.
        let relative_point = segment.position_for_index(caret_pos, line_height);

        let point = relative_point.unwrap_or_default();
        // the visual row offset from the start of the segment
        let row_offset = (point.y / line_height).floor() as usize;
        (preceding_row_count + row_offset, point)
    }

    /// Converts a screen point to a UTF-8 byte position using the current text viewport and scroll.
    pub fn index_for_position(&self, screen_position: Point<Pixels>) -> Option<usize> {
        if self.layout_data.lines.is_empty() {
            return None;
        }
        let content_position = screen_position - self.layout_data.inner_bounds.origin
            + self.layout_data.scroll_bounds.origin;
        Some(self.index_for_pixel_point(content_position, self.layout_data.line_height))
    }

    /// Returns screen-space bounds for a UTF-8 byte range using the current text viewport.
    pub fn bounds_for_range(&self, range: Range<usize>) -> Option<Bounds<Pixels>> {
        self.bounds_for_range_in(range, self.layout_data.inner_bounds)
    }

    fn bounds_for_range_in(
        &self,
        range: Range<usize>,
        inner_bounds: Bounds<Pixels>,
    ) -> Option<Bounds<Pixels>> {
        let len = self.storage.len_bytes();
        if range.start > range.end
            || range.end > len
            || self.storage.clamp_byte_offset(range.start) != range.start
            || self.storage.clamp_byte_offset(range.end) != range.end
        {
            return None;
        }

        let line_height = self.layout_data.line_height;
        let scroll = self.layout_data.scroll_bounds.origin;
        let mut result: Option<Bounds<Pixels>> = None;
        for segment in self.layout_data.lines.iter() {
            if range.is_empty() {
                if !segment.contains_position(range.start, true) {
                    continue;
                }
                let origin =
                    inner_bounds.origin + point(-scroll.x, segment.pos_y * line_height - scroll.y);
                let position = segment
                    .position_for_index(range.start, line_height)
                    .unwrap_or_default();
                return Some(Bounds::from_corners(
                    origin + position,
                    origin + position + point(CARET_PIXELS_EPSILON, line_height),
                ));
            }

            let start = range.start.max(segment.text_range.start);
            let end = range.end.min(segment.text_range.end);
            if start >= end {
                continue;
            }
            let Some(wrapped) = &segment.wrapped_line else {
                continue;
            };
            let origin =
                inner_bounds.origin + point(-scroll.x, segment.pos_y * line_height - scroll.y);
            let start_position = wrapped
                .position_for_index(start - segment.text_range.start, line_height)
                .unwrap_or_default();
            let end_position = wrapped
                .position_for_index(end - segment.text_range.start, line_height)
                .unwrap_or_else(|| {
                    let last_row = line_height * (segment.row_count().saturating_sub(1) as f32);
                    point(wrapped.width(), last_row)
                });
            let bounds = Bounds::from_corners(
                origin + start_position,
                origin + end_position + point(Pixels::ZERO, line_height),
            );
            result = Some(match result {
                None => bounds,
                Some(existing) => Bounds::from_corners(
                    point(
                        existing.left().min(bounds.left()),
                        existing.top().min(bounds.top()),
                    ),
                    point(
                        existing.right().max(bounds.right()),
                        existing.bottom().max(bounds.bottom()),
                    ),
                ),
            });
        }
        result
    }
}

// Internal user action / logical processors
impl EditableTextState {
    fn scroll_to_caret(&mut self) {
        self.pending_scroll_to_caret = true;
        self.layout_data.next_scroll_offset = None;
    }

    pub(super) fn pending_scroll_to_caret(&self) -> bool {
        self.pending_scroll_to_caret
    }

    pub(super) fn clear_pending_scroll_to_caret(&mut self) {
        self.pending_scroll_to_caret = false;
    }

    /// Moves the caret to the provided position.
    ///
    /// Will cause the current scroll position/offset to update on the next frame,
    /// if the line the carent is on is out of view.
    pub fn move_to(&mut self, caret_pos: usize, cx: &mut Context<Self>) {
        cx.emit(CaretNotify::PauseBlinking);
        let caret_pos = self.storage.clamp_byte_offset(caret_pos);
        self.break_history_grouping();
        self.selection = Selection::new(caret_pos, caret_pos);
        self.scroll_to_caret();
        cx.notify();
    }

    /// Changes the current selection to extend to the provided position.
    ///
    /// Will cause the current scroll position/offset to update on the next frame,
    /// if the line the carent is on is out of view.
    pub fn select_to(&mut self, caret_pos: usize, cx: &mut Context<Self>) {
        cx.emit(CaretNotify::PauseBlinking);
        let caret_pos = self.storage.clamp_byte_offset(caret_pos);
        self.break_history_grouping();
        self.selection = Selection::new(self.selection.anchor, caret_pos);
        self.scroll_to_caret();
        cx.notify();
    }

    /// Removes a chunk of text at the cursor/selection.
    /// No-op if the element is currently not accepting input.
    ///
    /// If there is a selection of multiple characters, the slice of text represented
    /// by range is replaced with an empty string.
    /// If there is no selection, `direction` and `boundary` are used to determine the slice of text to remove.
    ///
    /// [`NavigationDirection::Back`] represents scanning earlier in the text string from the caret.
    ///
    /// [`NavigationDirection::Forward`] represents scanning later in the text string from the caret.
    ///
    /// [`TextBoundary`] describes how far to jump from the caret.
    pub fn delete_linear(
        &mut self,
        direction: NavigationDirection,
        boundary: TextBoundary,
        cx: &mut Context<Self>,
    ) {
        if !self.layout_data.accepts_input {
            return;
        }

        self.finish_ime_history();
        let range = self.selected_range();
        let range = match range.is_empty() {
            false => range,
            true => self
                .storage
                .range_from_caret(self.caret_pos(), direction, boundary),
        };
        let storage_len_utf8 = self.storage.len_bytes();
        let start = range.start.min(storage_len_utf8);
        let end = range.end.max(start).min(storage_len_utf8);

        let changes = self.replace_text_with_grouping(start..end, "", false);
        self.finish_ime_history();
        self.emit_text_edited(&changes, cx);
        cx.notify();
    }

    /// Moves the caret somewhere relative to its current location, according to `direction` and `boundary`.
    ///
    /// If there is currently a selection, the cursor will jump to the start/end of that selection based on `direction`.
    ///
    /// [`NavigationDirection::Back`] represents scanning earlier in the text string from the current caret.
    ///
    /// [`NavigationDirection::Forward`] represents scanning later in the text string from the current caret.
    ///
    /// [`TextBoundary`] describes how far to jump from the current caret
    pub fn nav_linear(
        &mut self,
        direction: NavigationDirection,
        boundary: TextBoundary,
        cx: &mut Context<Self>,
    ) {
        let caret_pos = match self.selection.is_empty() {
            false => match direction {
                NavigationDirection::Back => self.selection.range().start,
                NavigationDirection::Forward => self.selection.range().end,
            },
            true => self
                .storage
                .offset_from_caret(self.caret_pos(), direction, boundary),
        };
        self.move_to(caret_pos, cx);
    }

    /// Sets the current selection to be the entire text in the storage medium
    pub fn select_document(&mut self, cx: &mut Context<Self>) {
        self.break_history_grouping();
        self.selection = Selection::new(self.storage.len_bytes(), 0);
        cx.notify();
    }

    /// Extends the current selection to include some amount of textrelative the current
    /// location of the caret, according to `direction` and `boundary`.
    ///
    /// [`NavigationDirection::Back`] represents scanning earlier in the text string from the current caret.
    ///
    /// [`NavigationDirection::Forward`] represents scanning later in the text string from the current caret.
    ///
    /// [`TextBoundary`] describes how far to jump from the current caret
    pub fn select_linear(
        &mut self,
        direction: NavigationDirection,
        boundary: TextBoundary,
        cx: &mut Context<Self>,
    ) {
        let caret_pos = self
            .storage
            .offset_from_caret(self.caret_pos(), direction, boundary);
        self.select_to(caret_pos, cx);
    }

    /// Updates the mouse-click tracker so we can detect when a mouse click results in different actions.
    fn apply_click(&mut self, click_count: usize, text_position: Point<Pixels>) {
        let should_continue_click =
            click_count > 1 && self.is_position_nearly_at_previous_click(text_position);
        self.click_count = if should_continue_click {
            click_count
        } else {
            1
        };
        self.last_click_position = Some(text_position);
    }

    fn is_position_nearly_at_previous_click(&self, point: Point<Pixels>) -> bool {
        match self.last_click_position {
            None => false,
            Some(previous_pos) => point.is_nearly_eq(&previous_pos, CARET_PIXELS_EPSILON),
        }
    }

    fn select_word_at(&mut self, caret_pos: usize, cx: &mut Context<Self>) {
        let range = self.storage.word_range_at(caret_pos);
        self.break_history_grouping();
        self.selection = Selection::new(range.end, range.start);
        cx.notify();
    }

    fn select_line_at(&mut self, caret_pos: usize, cx: &mut Context<Self>) {
        use NavigationDirection::*;
        use TextBoundary::*;

        let line_start = self.storage.offset_from_caret(caret_pos, Back, Line);
        let line_end = self.storage.offset_from_caret(caret_pos, Forward, Line);
        let line_end_with_newline = if line_end < self.storage.len_bytes() {
            line_end + 1
        } else {
            line_end
        };
        self.break_history_grouping();
        self.selection = Selection::new(line_end_with_newline, line_start);
        cx.notify();
    }
}

// History management
impl EditableTextState {
    /// Returns the history log of the element, which is the data that supports undo/redo operations.
    pub fn history(&self) -> Option<&EditableTextHistory> {
        self.history.as_ref()
    }

    fn apply_from_history(&mut self, src: HistoryKind, dst: HistoryKind, cx: &mut Context<Self>) {
        let Some(entry) = self.history.as_mut().and_then(|history| history.take(src)) else {
            return;
        };

        let text_changed = entry.text_changed;
        let target = match src {
            HistoryKind::Undo => &entry.before,
            HistoryKind::Redo => &entry.after,
        };
        self.storage
            .restore_document(&target.document)
            .expect("history snapshot must restore into its originating storage");
        self.inline_styles = target.inline_styles.clone();
        self.selection = target.selection;
        self.marked_range = None;
        self.ime_history_active = false;
        self.ime_history_recorded = false;
        self.bump_generation();

        if let Some(history) = &mut self.history {
            history.push(dst, entry);
            history.break_grouping();
        }

        if text_changed {
            self.emit_text_changed(cx);
        }
        self.scroll_to_caret();
        cx.notify();
    }
}

impl EditableTextState {
    fn ime_resolve_range(&self, range_utf16: Option<Range<usize>>) -> Range<usize> {
        // Use a series of fallbacks to pick the range to operate on.
        // Fallback order: IME provided range, active IME marked range, selection
        let range = range_utf16.map(|range_utf16| self.storage.utf_range_16to8(&range_utf16));
        let range = range.or_else(|| self.marked_range.clone());
        let range = range.unwrap_or_else(|| self.selected_range());

        let storage_len_utf8 = self.storage.len_bytes();
        range.start.min(storage_len_utf8)..range.end.min(storage_len_utf8)
    }

    fn ime_mark_text_in_range(&mut self, range: &Range<usize>, text_len: usize) {
        self.marked_range = match text_len {
            0 => None,
            _ => Some(range.start..range.start + text_len),
        };
    }

    fn ime_mark_selected_range(
        &mut self,
        range_overwritten: &Range<usize>,
        new_selected_range_utf16: &Option<Range<usize>>,
        inserted_text: &str,
    ) {
        // NOTE: Differs from yororen-ui
        // https://github.com/MeowLynxSea/yororen-ui/blob/346502ac654b77fdaff3be2d7444fca8783acfc9/crates/yororen-ui-core/src/headless/text_input_core.rs#L359-L371
        let selected_range = new_selected_range_utf16
            .as_ref()
            .map(|range| {
                let start = utf16_offset_in_text(inserted_text, range.start);
                let end = utf16_offset_in_text(inserted_text, range.end);
                range_overwritten.start + start..range_overwritten.start + end
            })
            .unwrap_or_else(|| {
                let end = range_overwritten.start + inserted_text.len();
                end..end
            });
        self.selection = Selection::new(selected_range.end, selected_range.start);
    }
}

// IME handler
impl EntityInputHandler for EditableTextState {
    fn text_for_range(
        &mut self,
        range_utf16: Range<usize>,
        adjusted_range: &mut Option<Range<usize>>,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<String> {
        let range = self.storage.utf_range_16to8(&range_utf16);
        let storage_len_utf8 = self.storage.len_bytes();
        let clamped_range = range.start.min(storage_len_utf8)..range.end.min(storage_len_utf8);
        adjusted_range.replace(self.storage.utf_range_8to16(&clamped_range));
        Some(self.storage.slice_bytes(clamped_range))
    }

    fn selected_text_range(
        &mut self,
        _ignore_disabled_input: bool,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<UTF16Selection> {
        let selection_range = self.selected_range();
        let direction = self.selection_direction();
        Some(UTF16Selection {
            range: self.storage.utf_range_8to16(&selection_range),
            reversed: direction == Some(NavigationDirection::Back),
        })
    }

    fn marked_text_range(
        &self,
        _window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<Range<usize>> {
        self.marked_range
            .as_ref()
            .map(|range| self.storage.utf_range_8to16(range))
    }

    fn unmark_text(&mut self, _window: &mut Window, _cx: &mut Context<Self>) {
        self.finish_ime_history();
    }

    fn replace_text_in_range(
        &mut self,
        range_utf16: Option<Range<usize>>,
        text_to_insert: &str,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        if !self.layout_data.accepts_input {
            return;
        }
        let range_utf8 = self.ime_resolve_range(range_utf16);
        let text_to_insert = self.validate_incoming_text(&range_utf8, text_to_insert);
        let changes = self.replace_text(range_utf8, text_to_insert.as_ref());
        self.finish_ime_history();
        cx.emit(CaretNotify::PauseBlinking);
        self.emit_text_edited(&changes, cx);
        cx.notify();
    }

    fn replace_and_mark_text_in_range(
        &mut self,
        range_utf16: Option<Range<usize>>,
        text_to_insert: &str,
        new_selected_range_utf16: Option<Range<usize>>,
        _window: &mut Window,
        cx: &mut Context<Self>,
    ) {
        if !self.layout_data.accepts_input {
            return;
        }
        let range = self.ime_resolve_range(range_utf16);
        let text_to_insert = self.validate_incoming_text(&range, text_to_insert);
        let changes =
            self.replace_text_with_grouping(range.clone(), text_to_insert.as_ref(), false);
        self.ime_mark_text_in_range(&range, text_to_insert.len());
        self.ime_history_active = text_to_insert.len() > 0;
        if !self.ime_history_active {
            if let Some(history) = &mut self.history {
                history.break_grouping();
            }
        }
        if !changes.is_empty() {
            self.ime_history_recorded = true;
        }
        self.ime_mark_selected_range(&range, &new_selected_range_utf16, &text_to_insert);
        if self.ime_history_recorded {
            let after = self.history_snapshot();
            if let Some(history) = &mut self.history {
                history.update_composition_after(after);
            }
        }
        if !self.ime_history_active {
            self.finish_ime_history();
        }
        self.emit_text_edited(&changes, cx);
        cx.notify();
    }

    fn bounds_for_range(
        &mut self,
        range_utf16: Range<usize>,
        bounds: Bounds<Pixels>,
        window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<Bounds<Pixels>> {
        let range = self.storage.utf_range_16to8(&range_utf16);
        let _ = window;
        self.bounds_for_range_in(range, bounds)
    }

    fn character_index_for_point(
        &mut self,
        point: Point<Pixels>,
        window: &mut Window,
        _cx: &mut Context<Self>,
    ) -> Option<usize> {
        let _ = window;
        let index = self.index_for_position(point)?;
        Some(self.storage.utf_offset_8to16(index))
    }
}

// Input Action handler
use super::actions::*;
impl<'app> EditableTextActionHandler<Context<'app, Self>> for EditableTextState {
    fn escape(&mut self, _: &Escape, window: &mut Window, cx: &mut Context<'app, Self>) {
        self.selection = Selection::new(0, 0);
        cx.notify();

        window.blur(cx);
    }

    fn insert_enter(&mut self, _: &Enter, window: &mut Window, cx: &mut Context<'app, Self>) {
        if !self.layout_data.supports_multiline {
            return;
        }
        if !self.layout_data.accepts_input {
            return;
        }
        self.replace_text_in_range(None, "\n", window, cx);
    }

    fn insert_tab(&mut self, _: &Tab, window: &mut Window, cx: &mut Context<'app, Self>) {
        if !self.layout_data.accepts_input {
            return;
        }
        self.replace_text_in_range(None, "\t", window, cx);
    }

    fn delete_left(&mut self, _: &DeleteLeft, _: &mut Window, cx: &mut Context<'app, Self>) {
        self.delete_linear(NavigationDirection::Back, TextBoundary::Graphmeme, cx);
    }

    fn delete_right(&mut self, _: &DeleteRight, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.delete_linear(NavigationDirection::Forward, TextBoundary::Graphmeme, cx);
    }

    fn delete_word_left(
        &mut self,
        _: &DeleteWordLeft,
        _w: &mut Window,
        cx: &mut Context<'app, Self>,
    ) {
        self.delete_linear(NavigationDirection::Back, TextBoundary::Word, cx);
    }

    fn delete_word_right(
        &mut self,
        _: &DeleteWordRight,
        _w: &mut Window,
        cx: &mut Context<'app, Self>,
    ) {
        self.delete_linear(NavigationDirection::Forward, TextBoundary::Word, cx);
    }

    fn delete_to_line_start(
        &mut self,
        _: &DeleteToLineStart,
        _w: &mut Window,
        cx: &mut Context<'app, Self>,
    ) {
        self.delete_linear(NavigationDirection::Back, TextBoundary::Line, cx);
    }

    fn delete_to_line_end(
        &mut self,
        _: &DeleteToLineEnd,
        _w: &mut Window,
        cx: &mut Context<'app, Self>,
    ) {
        self.delete_linear(NavigationDirection::Forward, TextBoundary::Line, cx);
    }

    fn nav_left(&mut self, _: &NavLeft, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.nav_linear(NavigationDirection::Back, TextBoundary::Graphmeme, cx);
    }

    fn nav_right(&mut self, _: &NavRight, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.nav_linear(NavigationDirection::Forward, TextBoundary::Graphmeme, cx);
    }

    fn nav_up(&mut self, _: &NavUp, window: &mut Window, cx: &mut Context<'app, Self>) {
        if !self.layout_data.supports_multiline {
            // semantically equivalent to line
            self.nav_linear(NavigationDirection::Back, TextBoundary::Line, cx);
            return;
        }

        if let Some(caret_pos) = self.find_position_in_vertical_direction(-1, window.line_height())
        {
            self.move_to(caret_pos, cx);
        }
    }

    fn nav_down(&mut self, _: &NavDown, window: &mut Window, cx: &mut Context<'app, Self>) {
        if !self.layout_data.supports_multiline {
            // semantically equivalent to line
            self.nav_linear(NavigationDirection::Forward, TextBoundary::Line, cx);
            return;
        }

        if let Some(caret_pos) = self.find_position_in_vertical_direction(1, window.line_height()) {
            self.move_to(caret_pos, cx);
        }
    }

    fn nav_line_start(&mut self, _: &NavLineStart, _w: &mut Window, cx: &mut Context<'app, Self>) {
        // [when not multiline] semantically equivalent to document
        self.nav_linear(NavigationDirection::Back, TextBoundary::Line, cx);
    }

    fn nav_line_end(&mut self, _: &NavLineEnd, _w: &mut Window, cx: &mut Context<'app, Self>) {
        // [when not multiline] semantically equivalent to document
        self.nav_linear(NavigationDirection::Forward, TextBoundary::Line, cx);
    }

    fn nav_start(&mut self, _: &NavDocumentStart, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.nav_linear(NavigationDirection::Back, TextBoundary::Document, cx);
    }

    fn nav_end(&mut self, _: &NavDocumentEnd, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.nav_linear(NavigationDirection::Forward, TextBoundary::Document, cx);
    }

    fn nav_left_word(&mut self, _: &NavWordLeft, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.nav_linear(NavigationDirection::Back, TextBoundary::Word, cx);
    }

    fn nav_right_word(&mut self, _: &NavWordRight, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.nav_linear(NavigationDirection::Forward, TextBoundary::Word, cx);
    }

    fn select_all(&mut self, _: &SelectAll, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.select_document(cx);
    }

    fn select_left(&mut self, _: &SelectLeft, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.select_linear(NavigationDirection::Back, TextBoundary::Graphmeme, cx);
    }

    fn select_right(&mut self, _: &SelectRight, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.select_linear(NavigationDirection::Forward, TextBoundary::Graphmeme, cx);
    }

    fn select_up(&mut self, _: &SelectUp, window: &mut Window, cx: &mut Context<'app, Self>) {
        if !self.layout_data.supports_multiline {
            // semantically equivalent to select document
            self.select_linear(NavigationDirection::Back, TextBoundary::Document, cx);
            return;
        }

        if let Some(caret_pos) = self.find_position_in_vertical_direction(-1, window.line_height())
        {
            self.select_to(caret_pos, cx);
        }
    }

    fn select_down(&mut self, _: &SelectDown, window: &mut Window, cx: &mut Context<'app, Self>) {
        if !self.layout_data.supports_multiline {
            // semantically equivalent to select document
            self.select_linear(NavigationDirection::Forward, TextBoundary::Document, cx);
            return;
        }

        if let Some(caret_pos) = self.find_position_in_vertical_direction(1, window.line_height()) {
            self.select_to(caret_pos, cx);
        }
    }

    fn select_start(
        &mut self,
        _: &SelectDocumentStart,
        _w: &mut Window,
        cx: &mut Context<'app, Self>,
    ) {
        self.select_linear(NavigationDirection::Back, TextBoundary::Document, cx);
    }

    fn select_end(&mut self, _: &SelectDocumentEnd, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.select_linear(NavigationDirection::Forward, TextBoundary::Document, cx);
    }

    fn select_left_word(
        &mut self,
        _: &SelectWordLeft,
        _w: &mut Window,
        cx: &mut Context<'app, Self>,
    ) {
        self.select_linear(NavigationDirection::Back, TextBoundary::Word, cx);
    }

    fn select_right_word(
        &mut self,
        _: &SelectWordRight,
        _w: &mut Window,
        cx: &mut Context<'app, Self>,
    ) {
        self.select_linear(NavigationDirection::Forward, TextBoundary::Word, cx);
    }

    fn cut(&mut self, _: &Cut, _w: &mut Window, cx: &mut Context<'app, Self>) {
        if !self.layout_data.accepts_input {
            return;
        }
        self.finish_ime_history();

        let range_to_cut = match self.selection.is_empty() {
            // selection is more than a caret, use that range of text
            false => self.selection.range(),
            // No selection: cut the entire current line (including newline)
            true => {
                use NavigationDirection::*;
                use TextBoundary::*;

                let caret = self.caret_pos();
                let line_start = self.storage.offset_from_caret(caret, Back, Line);
                let line_end = self.storage.offset_from_caret(caret, Forward, Line);
                let storage_len_utf8 = self.storage.len_bytes();

                // Include the newline character if there is one after the line
                let cut_end = if line_end < storage_len_utf8 {
                    line_end + 1 // Include the newline
                } else if line_start > 0 {
                    // Last line with no trailing newline - include preceding newline instead
                    line_end
                } else {
                    line_end
                };

                // For last line, also remove the preceding newline if it exists
                let cut_start = if line_end >= storage_len_utf8 && line_start > 0 {
                    line_start - 1 // Include preceding newline for last line
                } else {
                    line_start
                };

                cut_start..cut_end
            }
        };

        // Cut selected text
        let slice = self.storage.slice_bytes(range_to_cut.clone());
        cx.write_to_clipboard(ClipboardItem::new_string(slice));
        let changes = self.replace_text_with_grouping(range_to_cut, "", false);
        self.emit_text_edited(&changes, cx);
        cx.notify();
    }

    fn copy(&mut self, _: &Copy, _w: &mut Window, cx: &mut Context<'app, Self>) {
        if !self.selection.is_empty() {
            let slice = self.storage.slice_bytes(self.selection.range());
            cx.write_to_clipboard(ClipboardItem::new_string(slice));
        }
    }

    fn paste(&mut self, _: &Paste, _w: &mut Window, cx: &mut Context<'app, Self>) {
        if !self.layout_data.accepts_input {
            return;
        }
        self.finish_ime_history();

        let Some(text) = cx.read_from_clipboard().and_then(|item| item.text()) else {
            return;
        };

        let range = self.ime_resolve_range(None);
        let text_to_insert = self.validate_incoming_text(&range, &text);
        let changes = self.replace_text_with_grouping(range, text_to_insert.as_ref(), false);
        self.finish_ime_history();
        self.emit_text_edited(&changes, cx);
        cx.notify();
    }

    fn undo(&mut self, _: &Undo, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.apply_from_history(HistoryKind::Undo, HistoryKind::Redo, cx);
    }

    fn redo(&mut self, _: &Redo, _w: &mut Window, cx: &mut Context<'app, Self>) {
        self.apply_from_history(HistoryKind::Redo, HistoryKind::Undo, cx);
    }

    fn on_mouse_down(
        &mut self,
        event: &gpui::MouseDownEvent,
        text_position: Point<Pixels>,
        window: &mut Window,
        cx: &mut Context<'app, Self>,
    ) {
        const DOUBLE_CLICK: usize = 2;
        const TRIPLE_CLICK: usize = 3;

        let caret_pos = self.index_for_pixel_point(text_position, window.line_height());

        self.is_selecting = true;
        self.apply_click(event.click_count, text_position);

        match self.click_count {
            DOUBLE_CLICK => self.select_word_at(caret_pos, cx),
            TRIPLE_CLICK => self.select_line_at(caret_pos, cx),
            _ if event.modifiers.shift => self.select_to(caret_pos, cx),
            _ => self.move_to(caret_pos, cx),
        }
    }

    fn on_mouse_up(
        &mut self,
        _event: &gpui::MouseUpEvent,
        _w: &mut Window,
        _cx: &mut Context<'app, Self>,
    ) {
        self.is_selecting = false;
    }

    fn on_mouse_move(
        &mut self,
        _event: &gpui::MouseMoveEvent,
        text_position: Point<Pixels>,
        window: &mut Window,
        cx: &mut Context<'app, Self>,
    ) {
        if self.is_selecting && self.click_count == 1 {
            let character_pos = self.index_for_pixel_point(text_position, window.line_height());
            self.select_to(character_pos, cx);
        }
    }
}

/// Backlog:
/// - tests for text layout (generating TextLineSegment and wrap-boundaries);
///     permutations of: single and multiline fields, wrap vs no-wrap, overflow scroll vs no scroll
#[cfg(test)]
impl From<(usize, usize)> for Selection {
    fn from((head, anchor): (usize, usize)) -> Self {
        Self::new(anchor, head)
    }
}

#[cfg(test)]
impl From<Range<usize>> for Selection {
    fn from(range: Range<usize>) -> Self {
        Self::new(range.end, range.start)
    }
}

#[cfg(test)]
mod tests {
    use std::cell::Cell;
    use std::rc::Rc;
    use std::time::Duration;

    use super::*;
    use crate::editable_text::StringStorage;
    use gpui::{AppContext, Entity, IntoElement, Render, TestAppContext, WindowHandle, div};

    struct TestView {
        input: Entity<EditableTextState>,
        text_changed_events: Rc<Cell<usize>>,
    }

    impl TestView {
        fn new(input: Entity<EditableTextState>, cx: &mut Context<Self>) -> Self {
            let text_changed_events = Rc::new(Cell::new(0));
            let events = text_changed_events.clone();
            cx.subscribe(
                &input,
                move |_: &mut TestView, _input, _: &TextChanged, _cx| {
                    events.set(events.get() + 1);
                },
            )
            .detach();
            Self {
                input,
                text_changed_events,
            }
        }
    }

    impl Render for TestView {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            div()
        }
    }

    fn default_state(content: &str, cx: &mut Context<EditableTextState>) -> EditableTextState {
        EditableTextState::new(StringStorage::from(content), cx)
    }

    fn create_test_input(
        cx: &mut TestAppContext,
        content: &str,
        range: impl Into<Selection>,
    ) -> WindowHandle<TestView> {
        cx.add_window(|_window, cx| {
            let input = cx.new(|cx| {
                let mut input = default_state(content, cx);
                input.selection = range.into();
                input.layout_data.accepts_input = true;
                input
            });
            TestView::new(input, cx)
        })
    }

    // Disable grouping for predictable test behavior
    fn without_history_grouping(state: &mut EditableTextState) {
        state
            .history
            .get_or_insert_default()
            .set_grouping_interval(Duration::from_secs(0));
    }

    fn is_history_kind_available(state: &EditableTextState, kind: HistoryKind) -> bool {
        state
            .history()
            .map(|history| history.has_next(kind))
            .unwrap_or_default()
    }

    // ============================================================
    // BASIC MOVEMENT
    // ============================================================

    #[gpui::test]
    fn test_left_at_start_of_content(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_left_moves_by_grapheme(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 3);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection, 2.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_left_collapses_selection_to_start(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", (1, 4));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection, 1.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_left_stops_at_end_of_line(cx: &mut TestAppContext) {
        // "ab\ncd" - cursor at position 3 (start of "cd", after newline)
        // Pressing left should move to position 2 (end of "ab", before newline)
        let view = create_test_input(cx, "ab\ncd", 3);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection, 2.into()); // cursor at end of line 1
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_right_at_end_of_content(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 5.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_right_moves_by_grapheme(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 2);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 3.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_right_collapses_selection_to_end(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", (1, 4));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 4.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_right_stops_at_end_of_line(cx: &mut TestAppContext) {
        // "ab\ncd" - cursor at position 1 (after 'a')
        // Pressing right should move to position 2 (end of "ab", before newline)
        let view = create_test_input(cx, "ab\ncd", 1);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 2.into()); // cursor at end of line 1
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_right_crosses_newline(cx: &mut TestAppContext) {
        // "ab\ncd" - cursor at position 2 (end of "ab", before newline)
        // Pressing right should move to position 3 (after newline, start of "cd")
        let view = create_test_input(cx, "ab\ncd", 2);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 3.into()); // cursor at start of line 2
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_left_crosses_newline(cx: &mut TestAppContext) {
        // "ab\ncd" - cursor at position 2 (end of "ab", before newline)
        // Pressing left should move to position 1 (after 'a')
        let view = create_test_input(cx, "ab\ncd", 2);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection, 1.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_home_moves_to_line_start(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "first\nsecond", 9);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_line_start(&NavLineStart, window, cx);
                assert_eq!(input.selection, 6.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_end_moves_to_line_end(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "first\nsecond", 8);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_line_end(&NavLineEnd, window, cx);
                assert_eq!(input.selection, 12.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_move_to_beginning(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "first\nsecond\nthird", 9);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_start(&NavDocumentStart, window, cx);
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_move_to_end(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "first\nsecond\nthird", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_end(&NavDocumentEnd, window, cx);
                assert_eq!(input.selection, 18.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn segment_queries_clamp_above_view_and_keep_end_of_document_caret(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "abc\ndef", 7);
        view.update(cx, |view, _window, cx| {
            view.input.update(cx, |input, _cx| {
                input.layout_data.lines = vec![
                    TextLineSegment {
                        text_range: 0..4,
                        wrapped_line: None,
                        pos_y: 0,
                    },
                    TextLineSegment {
                        text_range: 4..7,
                        wrapped_line: None,
                        pos_y: 1,
                    },
                ]
                .into();
                input.layout_data.line_height = gpui::px(20.);

                assert_eq!(
                    input.index_for_pixel_point(point(gpui::px(0.), gpui::px(-1.)), gpui::px(20.)),
                    0
                );
                assert_eq!(
                    input.index_for_pixel_point(point(gpui::px(0.), gpui::px(100.)), gpui::px(20.)),
                    7
                );
                let (last, preceding_rows) = input
                    .find_segment(TextSegmentQuery::CharacterPosition(7))
                    .unwrap();
                assert_eq!(last.text_range, 4..7);
                assert_eq!(preceding_rows, 1);
                assert!(
                    input
                        .find_position_in_vertical_direction(-1, gpui::px(20.))
                        .is_some()
                );
            });
        })
        .unwrap();
    }

    // ============================================================
    // WORD MOVEMENT
    // ============================================================

    #[gpui::test]
    fn test_word_left_at_start(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_left_word(&NavWordLeft, window, cx);
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_word_left_stops_at_boundary(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world test", 11);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_left_word(&NavWordLeft, window, cx);
                assert_eq!(input.selection, 6.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_word_right_at_end(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 11);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right_word(&NavWordRight, window, cx);
                assert_eq!(input.selection, 11.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_word_right_stops_at_boundary(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world test", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right_word(&NavWordRight, window, cx);
                assert_eq!(input.selection, 5.into());
            });
        })
        .unwrap();
    }

    // ============================================================
    // SELECTION
    // ============================================================

    #[gpui::test]
    fn test_select_left_extends_selection(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 3);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.select_left(&SelectLeft, window, cx);
                assert_eq!(input.selection, (2, 3).into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_select_right_extends_selection(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 2..2);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.select_right(&SelectRight, window, cx);
                assert_eq!(input.selection, (3, 2).into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_select_all(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello\nworld", 3);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.select_all(&SelectAll, window, cx);
                assert_eq!(input.selection, (0, 11).into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_select_to_beginning(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 6);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.select_start(&SelectDocumentStart, window, cx);
                assert_eq!(input.selection, (0, 6).into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_select_to_end(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 6);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.select_end(&SelectDocumentEnd, window, cx);
                assert_eq!(input.selection, (11, 6).into());
            });
        })
        .unwrap();
    }

    // ============================================================
    // EDITING - BACKSPACE
    // ============================================================

    #[gpui::test]
    fn test_backspace_deletes_selection(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", (6, 11));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_left(&DeleteLeft, window, cx);
                assert_eq!(input.as_str(), "hello ");
                assert_eq!(input.selection, 6.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_backspace_deletes_previous_grapheme(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_left(&DeleteLeft, window, cx);
                assert_eq!(input.as_str(), "hell");
                assert_eq!(input.selection, 4.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_backspace_at_start_does_nothing(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_left(&DeleteLeft, window, cx);
                assert_eq!(input.as_str(), "hello");
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_backspace_deletes_entire_emoji(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "Hi 👋", 7);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_left(&DeleteLeft, window, cx);
                assert_eq!(input.as_str(), "Hi ");
                assert_eq!(input.selection, 3.into());
            });
        })
        .unwrap();
    }

    // ============================================================
    // EDITING - DELETE
    // ============================================================

    #[gpui::test]
    fn test_delete_deletes_selection(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", (0, 5));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_right(&DeleteRight, window, cx);
                assert_eq!(input.as_str(), " world");
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_deletes_next_grapheme(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_right(&DeleteRight, window, cx);
                assert_eq!(input.as_str(), "ello");
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_at_end_does_nothing(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_right(&DeleteRight, window, cx);
                assert_eq!(input.as_str(), "hello");
                assert_eq!(input.selection, 5.into());
            });
        })
        .unwrap();
    }

    // ============================================================
    // EDITING - ENTER
    // ============================================================

    #[gpui::test]
    fn test_enter_inserts_newline(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.layout_data.supports_multiline = true;
                input.insert_enter(&Enter, window, cx);
                assert_eq!(input.as_str(), "hello\n world");
                assert_eq!(input.selection, 6.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_enter_replaces_selection(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", (5, 6));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.layout_data.supports_multiline = true;
                input.insert_enter(&Enter, window, cx);
                assert_eq!(input.as_str(), "hello\nworld");
                assert_eq!(input.selection, 6.into());
            });
        })
        .unwrap();
    }

    // ============================================================
    // CLIPBOARD
    // ============================================================

    #[gpui::test]
    fn test_copy_with_selection(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", (6, 11));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.copy(&Copy, window, cx);
            });
        })
        .unwrap();

        let clipboard = cx.read_from_clipboard();
        assert!(clipboard.is_some());
        assert_eq!(clipboard.unwrap().text().as_deref(), Some("world"));
    }

    #[gpui::test]
    fn test_cut_with_selection(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", (0, 5));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.cut(&Cut, window, cx);
                assert_eq!(input.as_str(), " world");
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();

        let clipboard = cx.read_from_clipboard();
        assert_eq!(clipboard.unwrap().text().as_deref(), Some("hello"));
    }

    #[gpui::test]
    fn test_paste_inserts_text(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 5);
        cx.write_to_clipboard(ClipboardItem::new_string(" there".to_string()));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                EditableTextActionHandler::paste(input, &Paste, window, cx);
                assert_eq!(input.as_str(), "hello there world");
                assert_eq!(input.selection, 11.into());
            });
        })
        .unwrap();
    }

    // ============================================================
    // UNICODE / GRAPHEME HANDLING
    // ============================================================

    #[gpui::test]
    fn test_movement_with_multibyte_utf8(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "café", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 1.into());
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 2.into());
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 3.into());
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 5.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_movement_with_emoji(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "a👋b", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 1.into());
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 5.into());
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 6.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_selection_with_multibyte_characters(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "日本語", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.select_right(&SelectRight, window, cx);
                assert_eq!(input.selection, (3, 0).into());
                input.select_right(&SelectRight, window, cx);
                assert_eq!(input.selection, (6, 0).into());
                input.select_right(&SelectRight, window, cx);
                assert_eq!(input.selection, (9, 0).into());
            });
        })
        .unwrap();
    }

    // ============================================================
    // NEWLINE HANDLING
    // ============================================================

    #[gpui::test]
    fn test_find_line_start_and_end(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "first\nsecond\nthird", 0);
        view.update(cx, |view, _window, cx| {
            view.input.update(cx, |input, _cx| {
                use NavigationDirection::*;
                use TextBoundary::*;
                let storage = &input.storage;

                assert_eq!(storage.offset_from_caret(0, Back, Line), 0);
                assert_eq!(storage.offset_from_caret(3, Back, Line), 0);
                assert_eq!(storage.offset_from_caret(6, Back, Line), 6);
                assert_eq!(storage.offset_from_caret(13, Back, Line), 13);

                assert_eq!(storage.offset_from_caret(0, Forward, Line), 5);
                assert_eq!(storage.offset_from_caret(6, Forward, Line), 12);
                assert_eq!(storage.offset_from_caret(13, Forward, Line), 18);
            });
        })
        .unwrap();
    }

    // ============================================================
    // EDGE CASES
    // ============================================================

    #[gpui::test]
    fn test_operations_on_empty_content(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection, 0.into());

                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection, 0.into());

                input.delete_left(&DeleteLeft, window, cx);
                assert_eq!(input.as_str(), "");

                input.delete_right(&DeleteRight, window, cx);
                assert_eq!(input.as_str(), "");

                input.select_all(&SelectAll, window, cx);
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_set_content_resets_selection(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", (3, 8));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.marked_range = Some(5..7);
                input.replace_text_in_range(Some(0..11), "new content", window, cx);
                assert_eq!(input.as_str(), "new content");
                assert_eq!(input.selection, 11.into());
                assert_eq!(input.marked_range, None);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_cursor_clamped_to_content_length(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 100);
        view.update(cx, |view, _window, cx| {
            view.input.update(cx, |input, cx| {
                input.move_to(1000, cx);
                assert_eq!(input.selection, 5.into());

                input.selection = 0.into();
                input.select_to(1000, cx);
                assert_eq!(input.selection, (5, 0).into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_previous_boundary_at_start(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 0);
        view.update(cx, |view, _window, cx| {
            view.input.update(cx, |input, _cx| {
                use NavigationDirection::*;
                use TextBoundary::*;
                assert_eq!(input.storage.offset_from_caret(0, Back, Graphmeme), 0);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_next_boundary_at_end(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 0);
        view.update(cx, |view, _window, cx| {
            view.input.update(cx, |input, _cx| {
                use NavigationDirection::*;
                use TextBoundary::*;
                let storage = &input.storage;
                assert_eq!(storage.offset_from_caret(5, Forward, Graphmeme), 5);
                assert_eq!(storage.offset_from_caret(100, Forward, Graphmeme), 5);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_word_range_at_boundary(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 0);
        view.update(cx, |view, _window, cx| {
            view.input.update(cx, |input, _cx| {
                let range = input.storage.word_range_at(5);
                assert_eq!(range.start, 0);
                assert_eq!(range.end, 5);

                let range = input.storage.word_range_at(8);
                assert_eq!(range.start, 6);
                assert_eq!(range.end, 11);
            });
        })
        .unwrap();
    }

    // ============================================================
    // EMOJI & GRAPHEME CLUSTERS
    // ============================================================

    #[gpui::test]
    fn test_simple_emoji_navigation(cx: &mut TestAppContext) {
        // 😀 is 4 bytes in UTF-8
        let view = create_test_input(cx, "a😀b", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                // Move right through: a -> 😀 -> b
                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection.head, 1); // after 'a'

                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection.head, 5); // after 😀 (1 + 4 bytes)

                input.nav_right(&NavRight, window, cx);
                assert_eq!(input.selection.head, 6); // after 'b'

                // Move left back
                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection.head, 5); // before 'b'

                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection.head, 1); // before 😀
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_emoji_with_skin_tone_modifier(cx: &mut TestAppContext) {
        // 👋🏽 = 👋 (U+1F44B, 4 bytes) + 🏽 (U+1F3FD, 4 bytes) = 8 bytes total
        let emoji = "👋🏽";
        assert_eq!(emoji.len(), 8);

        let view = create_test_input(cx, &format!("a{}b", emoji), 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx); // past 'a'
                assert_eq!(input.selection.head, 1);

                input.nav_right(&NavRight, window, cx); // past entire emoji with modifier
                assert_eq!(input.selection.head, 9); // 1 + 8

                input.nav_left(&NavLeft, window, cx); // back before emoji
                assert_eq!(input.selection.head, 1);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_zwj_family_emoji(cx: &mut TestAppContext) {
        // 👨‍👩‍👧 = man + ZWJ + woman + ZWJ + girl
        // Each person emoji is 4 bytes, ZWJ is 3 bytes
        // Total: 4 + 3 + 4 + 3 + 4 = 18 bytes
        let family = "👨‍👩‍👧";
        assert_eq!(family.len(), 18);

        let view = create_test_input(cx, &format!("x{}y", family), 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx); // past 'x'
                assert_eq!(input.selection.head, 1);

                input.nav_right(&NavRight, window, cx); // past entire ZWJ sequence
                assert_eq!(input.selection.head, 19); // 1 + 18

                input.nav_right(&NavRight, window, cx); // past 'y'
                assert_eq!(input.selection.head, 20);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_backspace_deletes_emoji_between_ascii(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "a😀b", 5); // cursor after emoji
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_left(&DeleteLeft, window, cx);
                assert_eq!(input.as_str(), "ab");
                assert_eq!(input.selection.head, 1);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_backspace_deletes_zwj_sequence(cx: &mut TestAppContext) {
        let family = "👨‍👩‍👧";
        let content = format!("a{}b", family);
        let cursor_pos = 1 + family.len(); // after the family emoji

        let view = create_test_input(cx, &content, cursor_pos..cursor_pos);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_left(&DeleteLeft, window, cx);
                assert_eq!(input.as_str(), "ab");
                assert_eq!(input.selection.head, 1);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_removes_entire_emoji(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "a😀b", 1); // cursor before emoji
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_right(&DeleteRight, window, cx);
                assert_eq!(input.as_str(), "ab");
                assert_eq!(input.selection.head, 1);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_flag_emoji_navigation(cx: &mut TestAppContext) {
        // 🇯🇵 = Regional Indicator J (4 bytes) + Regional Indicator P (4 bytes)
        let flag = "🇯🇵";
        assert_eq!(flag.len(), 8);

        let view = create_test_input(cx, &format!("x{}y", flag), 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx); // past 'x'
                input.nav_right(&NavRight, window, cx); // past flag (should be single grapheme)
                assert_eq!(input.selection.head, 9); // 1 + 8
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_combining_diacritical_marks(cx: &mut TestAppContext) {
        // é as e + combining acute accent (U+0301)
        let combining = "e\u{0301}"; // 1 + 2 = 3 bytes
        assert_eq!(combining.len(), 3);

        let view = create_test_input(cx, &format!("a{}b", combining), 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx); // past 'a'
                assert_eq!(input.selection.head, 1);

                input.nav_right(&NavRight, window, cx); // past e + combining mark (single grapheme)
                assert_eq!(input.selection.head, 4); // 1 + 3

                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection.head, 1);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_multiple_combining_marks(cx: &mut TestAppContext) {
        // ë́ = e + combining diaeresis (U+0308) + combining acute (U+0301)
        let multi_combining = "e\u{0308}\u{0301}"; // 1 + 2 + 2 = 5 bytes
        assert_eq!(multi_combining.len(), 5);

        let view = create_test_input(cx, &format!("x{}y", multi_combining), 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx); // past 'x'
                input.nav_right(&NavRight, window, cx); // past entire combined character
                assert_eq!(input.selection.head, 6); // 1 + 5
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_select_emoji_with_shift(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "a😀b", 1); // cursor before emoji
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.select_right(&SelectRight, window, cx);
                assert_eq!(input.selection, (5, 1).into()); // selected the entire emoji
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_cjk_characters(cx: &mut TestAppContext) {
        // 你好 - each character is 3 bytes in UTF-8
        let view = create_test_input(cx, "a你好b", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx); // past 'a'
                assert_eq!(input.selection.head, 1);

                input.nav_right(&NavRight, window, cx); // past 你
                assert_eq!(input.selection.head, 4); // 1 + 3

                input.nav_right(&NavRight, window, cx); // past 好
                assert_eq!(input.selection.head, 7); // 4 + 3

                input.nav_right(&NavRight, window, cx); // past 'b'
                assert_eq!(input.selection.head, 8);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_mixed_script_text(cx: &mut TestAppContext) {
        // Mix of ASCII, CJK, and emoji
        let view = create_test_input(cx, "Hi你😀", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx); // past 'H'
                assert_eq!(input.selection.head, 1);

                input.nav_right(&NavRight, window, cx); // past 'i'
                assert_eq!(input.selection.head, 2);

                input.nav_right(&NavRight, window, cx); // past 你 (3 bytes)
                assert_eq!(input.selection.head, 5);

                input.nav_right(&NavRight, window, cx); // past 😀 (4 bytes)
                assert_eq!(input.selection.head, 9);

                // Now go back
                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection.head, 5);

                input.nav_left(&NavLeft, window, cx);
                assert_eq!(input.selection.head, 2);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_variation_selector_emoji(cx: &mut TestAppContext) {
        // ☺️ = ☺ (U+263A, 3 bytes) + variation selector-16 (U+FE0F, 3 bytes)
        let emoji_presentation = "☺\u{FE0F}";
        assert_eq!(emoji_presentation.len(), 6);

        let view = create_test_input(cx, &format!("a{}b", emoji_presentation), 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx); // past 'a'
                input.nav_right(&NavRight, window, cx); // past emoji with variation selector
                assert_eq!(input.selection.head, 7); // 1 + 6
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_keycap_emoji(cx: &mut TestAppContext) {
        // 1️⃣ = 1 + variation selector + combining enclosing keycap
        let keycap = "1\u{FE0F}\u{20E3}";

        let view = create_test_input(cx, &format!("x{}y", keycap), 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_right(&NavRight, window, cx); // past 'x'
                input.nav_right(&NavRight, window, cx); // past keycap sequence
                let expected_pos = 1 + keycap.len();
                assert_eq!(input.selection.head, expected_pos);
            });
        })
        .unwrap();
    }

    // Single-line input tests

    fn create_single_line_input(
        cx: &mut TestAppContext,
        content: &str,
        selection: impl Into<Selection>,
    ) -> WindowHandle<TestView> {
        cx.add_window(|_window, cx| {
            let input = cx.new(|cx| {
                let mut input = default_state(content, cx);
                input.selection = selection.into();
                input
            });
            TestView::new(input, cx)
        })
    }

    #[gpui::test]
    fn test_single_line_enter_does_nothing(cx: &mut TestAppContext) {
        let view = create_single_line_input(cx, "hello", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.insert_enter(&Enter, window, cx);
                assert_eq!(input.as_str(), "hello");
                assert_eq!(input.selection, 5.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_single_line_up_moves_to_start(cx: &mut TestAppContext) {
        let view = create_single_line_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_up(&NavUp, window, cx);
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_single_line_down_moves_to_end(cx: &mut TestAppContext) {
        let view = create_single_line_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.nav_down(&NavDown, window, cx);
                assert_eq!(input.selection, 11.into()); // "hello world".len() == 11
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_single_line_select_up_selects_to_start(cx: &mut TestAppContext) {
        let view = create_single_line_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.select_up(&SelectUp, window, cx);
                assert_eq!(input.selection, (0, 5).into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_single_line_select_down_selects_to_end(cx: &mut TestAppContext) {
        let view = create_single_line_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.select_down(&SelectDown, window, cx);
                assert_eq!(input.selection, (11, 5).into()); // "hello world".len() == 11
            });
        })
        .unwrap();
    }

    // ============================================================
    // UNDO / REDO
    // ============================================================

    #[gpui::test]
    fn test_undo_restores_content(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                // Make an edit
                input.replace_text_in_range(None, " world", window, cx);
                assert_eq!(input.as_str(), "hello world");

                // Undo should restore original content
                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_redo_restores_undone_content(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.replace_text_in_range(None, " world", window, cx);
                assert_eq!(input.as_str(), "hello world");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello");

                input.redo(&Redo, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_undo_with_no_history_does_nothing(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                assert!(!is_history_kind_available(input, HistoryKind::Undo));
                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_redo_with_no_history_does_nothing(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                assert!(!is_history_kind_available(input, HistoryKind::Redo));
                input.redo(&Redo, window, cx);
                assert_eq!(input.as_str(), "hello");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_undo_restores_selection(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", (0, 5));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                // Delete selection
                input.replace_text_in_range(None, "", window, cx);
                assert_eq!(input.as_str(), " world");
                assert_eq!(input.selection, 0.into());

                // Undo should restore content and selection
                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello world");
                assert_eq!(input.selection, (0, 5).into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_atomic_dispatch_maps_styles_and_undoes_text_with_marks(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "abcdefghij", 3);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);
                input.inline_styles = RangeSet::new([Span::new(
                    7..10,
                    Affinity::Before,
                    Affinity::After,
                    InlineStyle::default().bold(),
                )]);
                let original_marks = input.inline_styles.clone();

                let transaction = input
                    .transaction()
                    .replace(1..2, "XX")
                    .replace(4..5, "")
                    .selection(Selection::new(10, 10))
                    .build()
                    .unwrap();
                input.dispatch(&transaction, cx).unwrap();

                assert_eq!(input.as_str(), "aXXcdfghij");
                assert_eq!(input.inline_styles.iter().next().unwrap().range, 7..10);
                assert_eq!(input.selection(), Selection::new(10, 10));

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "abcdefghij");
                assert_eq!(input.inline_styles, original_marks);

                input.redo(&Redo, window, cx);
                assert_eq!(input.as_str(), "aXXcdfghij");
                assert_eq!(input.inline_styles.iter().next().unwrap().range, 7..10);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_formatting_is_undoable_and_stales_prepared_dispatch(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", (0, 5));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                let stale = input.transaction().replace(0..0, "!").build().unwrap();
                input.format_selection(InlineStyle::default().bold(), cx);
                assert_eq!(input.inline_styles.len(), 1);
                assert!(matches!(
                    input.dispatch(&stale, cx),
                    Err(ChangeError::StaleSource)
                ));

                input.undo(&Undo, window, cx);
                assert!(input.inline_styles.is_empty());
                input.redo(&Redo, window, cx);
                assert_eq!(input.inline_styles.len(), 1);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn text_changed_tracks_text_undo_redo_but_stays_quiet_for_format_history(
        cx: &mut TestAppContext,
    ) {
        let view = create_test_input(cx, "a", 1);

        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);
                input.replace_text_in_range(None, "b", window, cx);
                assert_eq!(input.as_str(), "ab");
            });
        })
        .unwrap();
        assert_eq!(
            cx.read(|app| view.read(app).unwrap().text_changed_events.get()),
            1
        );

        view.update(cx, |view, window, cx| {
            view.input
                .update(cx, |input, cx| input.undo(&Undo, window, cx));
        })
        .unwrap();
        assert_eq!(
            cx.read(|app| view.read(app).unwrap().text_changed_events.get()),
            2
        );

        view.update(cx, |view, window, cx| {
            view.input
                .update(cx, |input, cx| input.redo(&Redo, window, cx));
        })
        .unwrap();
        assert_eq!(
            cx.read(|app| view.read(app).unwrap().text_changed_events.get()),
            3
        );

        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.selection = Selection::new(0, 2);
                input.format_selection(InlineStyle::default().bold(), cx);
                assert_eq!(input.inline_styles.len(), 1);
                input.undo(&Undo, window, cx);
                assert!(input.inline_styles.is_empty());
            });
        })
        .unwrap();
        assert_eq!(
            cx.read(|app| view.read(app).unwrap().text_changed_events.get()),
            3
        );
    }

    #[gpui::test]
    fn rich_text_snapshot_and_replacement_round_trip_marks(cx: &mut TestAppContext) {
        let original = RichText::new()
            .text("left ")
            .span("old", InlineStyle::default().bold())
            .text(" right")
            .finish();
        let fragment = RichText::new()
            .span("new", InlineStyle::default().italic())
            .finish();
        let expected_original_marks = original.ranges().clone();
        let view = cx.add_window(|_, cx| {
            let input = cx.new(|cx| EditableTextState::from_rich_text(original.clone(), cx));
            TestView::new(input, cx)
        });

        view.update(cx, |view, _, cx| {
            view.input.update(cx, |input, _cx| {
                let snapshot = input.rich_text_snapshot();
                assert_eq!(snapshot.as_str(), original.as_str());
                assert_eq!(snapshot.ranges(), original.ranges());

                input
                    .replace_rich_text(5..8, fragment.clone(), _cx)
                    .unwrap();
                assert_eq!(input.as_str(), "left new right");
                assert_eq!(input.selection(), Selection::new(8, 8));
                let marks: Vec<_> = input.inline_styles.iter().collect();
                assert_eq!(marks.len(), 2);
                assert_eq!(marks[0].range, 5..8);
                assert_eq!(marks[0].value(), &InlineStyle::default().bold());
                assert_eq!(marks[1].range, 5..8);
                assert_eq!(marks[1].value(), &InlineStyle::default().italic());
                let runs = input
                    .rich_text_snapshot()
                    .text_runs(&gpui::TextStyle::default());
                assert_eq!(runs[1].font.weight, gpui::FontWeight::BOLD);
                assert_eq!(runs[1].font.style, gpui::FontStyle::Italic);
            });
        })
        .unwrap();

        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), original.as_str());
                assert_eq!(input.inline_styles, expected_original_marks);
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_dispatch_rejects_invalid_post_edit_marks_before_mutation(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 0);
        view.update(cx, |view, _window, cx| {
            view.input.update(cx, |input, cx| {
                let transaction = input.transaction().replace(0..1, "H").build().unwrap();
                let invalid_styles = RangeSet::new([Span::new(
                    0..99,
                    Affinity::Before,
                    Affinity::After,
                    InlineStyle::default().bold(),
                )]);

                assert!(matches!(
                    input.dispatch_with_styles(&transaction, invalid_styles, cx),
                    Err(ChangeError::PositionOutOfBounds { .. })
                ));
                assert_eq!(input.as_str(), "hello");
                assert!(input.inline_styles.is_empty());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_insert_followed_by_adjacent_replacement_undoes_both_exactly(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "abc", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.replace_text_in_range(None, "x", window, cx);
                assert_eq!(input.as_str(), "xabc");

                input.selection = Selection::new(4, 1);
                input.replace_text_in_range(None, "y", window, cx);
                assert_eq!(input.as_str(), "xy");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "xabc");
                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "abc");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn canceled_ime_composition_removes_its_noop_history_entry(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "abc", 1);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.replace_and_mark_text_in_range(None, "X", None, window, cx);
                assert_eq!(input.as_str(), "aXbc");
                assert!(is_history_kind_available(input, HistoryKind::Undo));

                // The platform cancels composition by replacing its marked text with empty text.
                input.replace_and_mark_text_in_range(None, "", None, window, cx);
                assert_eq!(input.as_str(), "abc");
                assert!(!is_history_kind_available(input, HistoryKind::Undo));
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn consecutive_native_text_insertions_keep_typing_grouping(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.replace_text_in_range(None, "a", window, cx);
                input.replace_text_in_range(None, "b", window, cx);
                assert_eq!(input.as_str(), "ab");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_multiple_undo_redo(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.replace_text_in_range(None, "a", window, cx);
                input.replace_text_in_range(None, "b", window, cx);
                input.replace_text_in_range(None, "c", window, cx);
                assert_eq!(input.as_str(), "abc");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "ab");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "a");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "");

                input.redo(&Redo, window, cx);
                assert_eq!(input.as_str(), "a");

                input.redo(&Redo, window, cx);
                assert_eq!(input.as_str(), "ab");

                input.redo(&Redo, window, cx);
                assert_eq!(input.as_str(), "abc");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_new_edit_clears_redo_stack(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.replace_text_in_range(None, " world", window, cx);
                assert_eq!(input.as_str(), "hello world");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello");
                assert!(is_history_kind_available(input, HistoryKind::Redo));

                // New edit should clear redo stack
                input.replace_text_in_range(None, "!", window, cx);
                assert_eq!(input.as_str(), "hello!");
                assert!(!is_history_kind_available(input, HistoryKind::Redo));
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_can_undo_can_redo(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                assert!(!is_history_kind_available(input, HistoryKind::Undo));
                assert!(!is_history_kind_available(input, HistoryKind::Redo));

                input.replace_text_in_range(None, "!", window, cx);
                assert!(is_history_kind_available(input, HistoryKind::Undo));
                assert!(!is_history_kind_available(input, HistoryKind::Redo));

                input.undo(&Undo, window, cx);
                assert!(!is_history_kind_available(input, HistoryKind::Undo));
                assert!(is_history_kind_available(input, HistoryKind::Redo));

                input.redo(&Redo, window, cx);
                assert!(is_history_kind_available(input, HistoryKind::Undo));
                assert!(!is_history_kind_available(input, HistoryKind::Redo));
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_backspace_is_undoable(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.delete_left(&DeleteLeft, window, cx);
                assert_eq!(input.as_str(), "hell");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_is_undoable(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.delete_right(&DeleteRight, window, cx);
                assert_eq!(input.as_str(), "ello");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_cut_is_undoable(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", (0, 5));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.cut(&Cut, window, cx);
                assert_eq!(input.as_str(), " world");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_cut_line_with_no_selection(cx: &mut TestAppContext) {
        // Cursor in middle line, no selection - should cut entire line including newline
        let view = create_test_input(cx, "line1\nline2\nline3", 8); // cursor in "line2"
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.cut(&Cut, window, cx);
                assert_eq!(input.as_str(), "line1\nline3");
            });
        })
        .unwrap();

        let clipboard = cx.read_from_clipboard();
        assert_eq!(clipboard.unwrap().text().as_deref(), Some("line2\n"));
    }

    #[gpui::test]
    fn test_cut_first_line_with_no_selection(cx: &mut TestAppContext) {
        // Cursor on first line, no selection
        let view = create_test_input(cx, "line1\nline2\nline3", 2); // cursor in "line1"
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.cut(&Cut, window, cx);
                assert_eq!(input.as_str(), "line2\nline3");
            });
        })
        .unwrap();

        let clipboard = cx.read_from_clipboard();
        assert_eq!(clipboard.unwrap().text().as_deref(), Some("line1\n"));
    }

    #[gpui::test]
    fn test_cut_last_line_with_no_selection(cx: &mut TestAppContext) {
        // Cursor on last line, no selection - should include preceding newline
        let view = create_test_input(cx, "line1\nline2\nline3", 14); // cursor in "line3"
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.cut(&Cut, window, cx);
                assert_eq!(input.as_str(), "line1\nline2");
            });
        })
        .unwrap();

        let clipboard = cx.read_from_clipboard();
        assert_eq!(clipboard.unwrap().text().as_deref(), Some("\nline3"));
    }

    #[gpui::test]
    fn test_cut_empty_line(cx: &mut TestAppContext) {
        // Cursor on empty line - should remove that line
        let view = create_test_input(cx, "line1\n\nline3", 6); // cursor on empty line
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.cut(&Cut, window, cx);
                assert_eq!(input.as_str(), "line1\nline3");
            });
        })
        .unwrap();

        let clipboard = cx.read_from_clipboard();
        assert_eq!(clipboard.unwrap().text().as_deref(), Some("\n"));
    }

    #[gpui::test]
    fn test_cut_only_line_with_no_selection(cx: &mut TestAppContext) {
        // Single line content, no selection - should cut entire content
        let view = create_test_input(cx, "hello", 2);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.cut(&Cut, window, cx);
                assert_eq!(input.as_str(), "");
            });
        })
        .unwrap();

        let clipboard = cx.read_from_clipboard();
        assert_eq!(clipboard.unwrap().text().as_deref(), Some("hello"));
    }

    #[gpui::test]
    fn test_cut_line_is_undoable(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "line1\nline2\nline3", 8);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.cut(&Cut, window, cx);
                assert_eq!(input.as_str(), "line1\nline3");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "line1\nline2\nline3");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_paste_is_undoable(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello", 5);
        cx.write_to_clipboard(ClipboardItem::new_string(" world".to_string()));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                EditableTextActionHandler::paste(input, &Paste, window, cx);
                assert_eq!(input.as_str(), "hello world");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_enter_is_undoable(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);
                input.layout_data.supports_multiline = true;

                input.insert_enter(&Enter, window, cx);
                assert_eq!(input.as_str(), "hello\n world");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_word_left(cx: &mut TestAppContext) {
        // Cursor at end of "hello" in "hello world"
        let view = create_test_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_word_left(&DeleteWordLeft, window, cx);
                assert_eq!(input.as_str(), " world");
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_word_left_with_selection(cx: &mut TestAppContext) {
        // Selection from 0 to 5 ("hello")
        let view = create_test_input(cx, "hello world", (0, 5));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_word_left(&DeleteWordLeft, window, cx);
                assert_eq!(input.as_str(), " world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_word_left_at_start(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_word_left(&DeleteWordLeft, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_word_right(cx: &mut TestAppContext) {
        // Cursor at start
        let view = create_test_input(cx, "hello world", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_word_right(&DeleteWordRight, window, cx);
                assert_eq!(input.as_str(), " world");
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_word_right_with_selection(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", (0, 5));
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_word_right(&DeleteWordRight, window, cx);
                assert_eq!(input.as_str(), " world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_word_right_at_end(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 11);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_word_right(&DeleteWordRight, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_to_beginning_of_line(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_to_line_start(&DeleteToLineStart, window, cx);
                assert_eq!(input.as_str(), " world");
                assert_eq!(input.selection, 0.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_to_beginning_of_line_multiline(cx: &mut TestAppContext) {
        // Cursor at position 8 (middle of "line2")
        let view = create_test_input(cx, "line1\nline2\nline3", 8);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_to_line_start(&DeleteToLineStart, window, cx);
                assert_eq!(input.as_str(), "line1\nne2\nline3");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_to_beginning_of_line_at_start(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 0);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_to_line_start(&DeleteToLineStart, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_to_end_of_line(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_to_line_end(&DeleteToLineEnd, window, cx);
                assert_eq!(input.as_str(), "hello");
                assert_eq!(input.selection, 5.into());
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_to_end_of_line_multiline(cx: &mut TestAppContext) {
        // Cursor at position 8 (middle of "line2")
        let view = create_test_input(cx, "line1\nline2\nline3", 8);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_to_line_end(&DeleteToLineEnd, window, cx);
                assert_eq!(input.as_str(), "line1\nli\nline3");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_to_end_of_line_at_end(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 11);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                input.delete_to_line_end(&DeleteToLineEnd, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_word_left_is_undoable(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.delete_word_left(&DeleteWordLeft, window, cx);
                assert_eq!(input.as_str(), " world");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_word_right_is_undoable(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 6);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.delete_word_right(&DeleteWordRight, window, cx);
                assert_eq!(input.as_str(), "hello ");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_to_beginning_of_line_is_undoable(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.delete_to_line_start(&DeleteToLineStart, window, cx);
                assert_eq!(input.as_str(), " world");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }

    #[gpui::test]
    fn test_delete_to_end_of_line_is_undoable(cx: &mut TestAppContext) {
        let view = create_test_input(cx, "hello world", 5);
        view.update(cx, |view, window, cx| {
            view.input.update(cx, |input, cx| {
                without_history_grouping(input);

                input.delete_to_line_end(&DeleteToLineEnd, window, cx);
                assert_eq!(input.as_str(), "hello");

                input.undo(&Undo, window, cx);
                assert_eq!(input.as_str(), "hello world");
            });
        })
        .unwrap();
    }
}
