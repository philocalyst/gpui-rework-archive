use crate::{
    Bounds, Capslock, Context, Empty, IntoElement, Keystroke, LongPressEvent, Modifiers, Pixels,
    Point, Render, TouchDragEvent, Window, point, seal::Sealed,
};
use smallvec::SmallVec;
use std::{any::Any, fmt::Debug, ops::Deref, path::PathBuf};

/// An event from a platform input source.
///
/// Event values are converted into [`PlatformInput`] before GPUI dispatches them. Application
/// code normally receives the concrete event through an element listener rather than calling this
/// trait directly.
pub trait InputEvent: Sealed + 'static {
    /// Convert this event into the platform input enum.
    fn to_platform_input(self) -> PlatformInput;
}

/// A key event from the platform.
pub trait KeyEvent: InputEvent {}

/// A mouse event from the platform.
pub trait MouseEvent: InputEvent {}

/// A gesture event from the platform.
pub trait GestureEvent: InputEvent {}

/// A key press, including repeated key-down notifications.
#[derive(Clone, Debug, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct KeyDownEvent {
    /// The keystroke that was generated.
    pub keystroke: Keystroke,

    /// Whether the platform reports this as an auto-repeat while the key remains held.
    pub is_held: bool,

    /// Whether text insertion should take priority over keymap dispatch.
    /// In some cases, like AltGr on Windows, modifiers are significant for character input.
    pub prefer_character_input: bool,
}

impl Sealed for KeyDownEvent {}
impl InputEvent for KeyDownEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::KeyDown(self)
    }
}
impl KeyEvent for KeyDownEvent {}

/// A key release event.
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub struct KeyUpEvent {
    /// The keystroke that was released.
    pub keystroke: Keystroke,
}

impl Sealed for KeyUpEvent {}
impl InputEvent for KeyUpEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::KeyUp(self)
    }
}
impl KeyEvent for KeyUpEvent {}

/// A change to modifier or Caps Lock state without a key press or release.
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct ModifiersChangedEvent {
    /// The new modifier state.
    pub modifiers: Modifiers,
    /// The new Caps Lock state.
    pub capslock: Capslock,
}

impl Sealed for ModifiersChangedEvent {}
impl InputEvent for ModifiersChangedEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::ModifiersChanged(self)
    }
}
impl KeyEvent for ModifiersChangedEvent {}

impl Deref for ModifiersChangedEvent {
    type Target = Modifiers;

    fn deref(&self) -> &Self::Target {
        &self.modifiers
    }
}

/// The phase of a touch contact.
///
/// A contact begins with [`TouchPhase::Started`], may produce any number of [`TouchPhase::Moved`]
/// events, and ends with [`TouchPhase::Ended`] or [`TouchPhase::Cancelled`]. Cancellation means the platform took ownership; gesture recognizers
/// must release any provisional state without treating the contact as a completed action.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
pub enum TouchPhase {
    /// The touch started.
    Started,
    /// The touch event is moving.
    #[default]
    Moved,
    /// The touch phase has ended
    Ended,
    /// The touch was cancelled: the system took it and it will not end
    /// normally. Consumers must fully unwind any in-progress interaction,
    /// treating the touch as if it never committed.
    Cancelled,
}

/// Identifies one touch (finger or stylus contact) for its lifetime, from
/// [`TouchPhase::Started`] through [`TouchPhase::Ended`] or
/// [`TouchPhase::Cancelled`].
///
/// The value is opaque and assigned by the platform. A platform window must
/// not reuse an identifier for a later touch.
#[derive(
    Clone,
    Copy,
    Debug,
    Default,
    PartialEq,
    Eq,
    Hash,
    PartialOrd,
    Ord,
    serde::Serialize,
    serde::Deserialize,
)]
pub struct TouchId(pub u64);

/// A raw touch contact update from the platform.
///
/// GPUI dispatches each update through the ordinary mouse-event path at its current `position`,
/// then feeds it to the portable gesture recognizer. `id` connects the updates for one contact;
/// `Started` begins provisional recognition and `Ended` or `Cancelled` closes that contact.
/// A raw touch update is not itself a click: the recognizer may resolve the sequence as a tap,
/// long press, pan, or cancellation.
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct TouchEvent {
    /// Which touch this event belongs to.
    pub id: TouchId,
    /// The phase of the touch.
    pub phase: TouchPhase,
    /// The position of the touch in window coordinates.
    pub position: Point<Pixels>,
    /// Where the platform predicts the touch will be roughly one frame from
    /// now, in the same coordinate space as `position`, when the platform
    /// offers a prediction for a [`TouchPhase::Moved`] event.
    ///
    /// Best-effort latency compensation only: it may influence how far a
    /// recognized pan scrolls within a frame, but never hit testing, gesture
    /// classification, or velocity estimation, and any error it introduces
    /// must be corrected by later events for the same touch.
    pub predicted_position: Option<Point<Pixels>>,
    /// Normalized touch force in `0.0..=1.0`, if the hardware reports it.
    pub force: Option<f32>,
}

impl Sealed for TouchEvent {}
impl InputEvent for TouchEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::Touch(self)
    }
}

/// A mouse-button press in logical window coordinates.
///
/// A press alone is not activation. Use
/// [`StatefulInteractiveElement::on_click`](crate::StatefulInteractiveElement::on_click)
/// for a control that should activate after a matching release, including
/// keyboard activation. Use a press listener when the interaction must begin
/// immediately, such as placing a caret or starting a drag.
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct MouseDownEvent {
    /// Which mouse button was pressed.
    pub button: MouseButton,

    /// The position of the mouse on the window.
    pub position: Point<Pixels>,

    /// The modifiers that were held down when the mouse was pressed.
    pub modifiers: Modifiers,

    /// The platform's consecutive-click count for this press.
    ///
    /// A first click normally has count one. Timing and distance thresholds
    /// belong to the input backend; this is not a count of all clicks on an
    /// element.
    pub click_count: usize,

    /// Whether the backend marks this as the click activating the window.
    ///
    /// This does not report whether a particular element acquired focus.
    /// Backends that do not supply this distinction leave it false.
    pub first_mouse: bool,
}

impl Sealed for MouseDownEvent {}
impl InputEvent for MouseDownEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::MouseDown(self)
    }
}
impl MouseEvent for MouseDownEvent {}

impl MouseDownEvent {
    /// Whether this button conventionally requests focus: currently the left button.
    ///
    /// This classification does not focus an element or inspect window focus.
    pub fn is_focusing(&self) -> bool {
        match self.button {
            MouseButton::Left => true,
            _ => false,
        }
    }
}

/// A mouse-button release from the platform.
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct MouseUpEvent {
    /// Which mouse button was released.
    pub button: MouseButton,

    /// The position of the mouse on the window.
    pub position: Point<Pixels>,

    /// The modifiers that were held down when the mouse was released.
    pub modifiers: Modifiers,

    /// The number of times the button has been clicked.
    pub click_count: usize,
}

impl Sealed for MouseUpEvent {}
impl InputEvent for MouseUpEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::MouseUp(self)
    }
}

impl MouseEvent for MouseUpEvent {}

impl MouseUpEvent {
    /// Whether this button conventionally requests focus: currently the left button.
    ///
    /// This classification does not focus an element or inspect window focus.
    pub fn is_focusing(&self) -> bool {
        match self.button {
            MouseButton::Left => true,
            _ => false,
        }
    }
}

/// The press and release retained for a mouse activation.
///
/// Their positions and modifiers may differ. [`ClickEvent::position`] and
/// [`ClickEvent::modifiers`] use the release; inspect `down` when the starting
/// position or initial modifiers matter.
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct MouseClickEvent {
    /// The mouse event when the button was pressed.
    pub down: MouseDownEvent,

    /// The mouse event when the button was released.
    pub up: MouseUpEvent,
}

/// The stage of a pressure click event.
#[derive(Clone, Copy, Debug, Default, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum PressureStage {
    /// No pressure.
    #[default]
    Zero,
    /// Normal click pressure.
    Normal,
    /// High pressure, enough to trigger a force click.
    Force,
}

/// A pressure change from a force-sensitive pointing device.
///
/// Support is platform-dependent; currently GPUI produces this event for macOS trackpads.
#[derive(Debug, Clone, Default, serde::Serialize, serde::Deserialize)]
pub struct MousePressureEvent {
    /// Pressure of the current stage as a float between 0 and 1
    pub pressure: f32,
    /// The pressure stage of the event.
    pub stage: PressureStage,
    /// The position of the mouse on the window.
    pub position: Point<Pixels>,
    /// The modifiers that were held down when the mouse pressure changed.
    pub modifiers: Modifiers,
}

impl Sealed for MousePressureEvent {}
impl InputEvent for MousePressureEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::MousePressure(self)
    }
}
impl MouseEvent for MousePressureEvent {}

/// A click event that was generated by a keyboard button being pressed and released.
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct KeyboardClickEvent {
    /// The keyboard button that was pressed to trigger the click.
    pub button: KeyboardButton,

    /// The bounds of the element that was clicked.
    pub bounds: Bounds<Pixels>,
}

/// A click event that was generated by a recognized tap gesture on a touch
/// screen.
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct TouchClickEvent {
    /// The position of the tap in window coordinates.
    pub position: Point<Pixels>,
    /// The number of consecutive taps at this location (double tap = 2),
    /// analogous to the mouse `click_count`.
    pub tap_count: usize,
    /// Whether this was a long press rather than a tap. Long presses are
    /// touch's secondary activation: they are delivered to aux-click
    /// listeners alongside right clicks, not to primary click listeners.
    pub long_press: bool,
}

/// An activation produced by a mouse click, keyboard activation, or platform touch activation.
///
/// A click is not necessarily mouse input: use [`Self::mouse_position`] when
/// a handler specifically needs a cursor position. The portable touch recognizer currently
/// synthesizes a mouse press/release for a tap; this enum's touch variant is for input paths that
/// provide touch activation directly. A recognized portable long press is delivered as a phased
/// [`LongPressEvent`], not as a click. Primary click listeners receive primary activation;
/// aux-click listeners receive secondary click activation such as a right click.
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub enum ClickEvent {
    /// A mouse button was pressed and released.
    Mouse(MouseClickEvent),
    /// A keyboard key activated the focused element.
    Keyboard(KeyboardClickEvent),
    /// A touch activation supplied directly by an input path.
    Touch(TouchClickEvent),
}

impl Default for ClickEvent {
    fn default() -> Self {
        ClickEvent::Keyboard(KeyboardClickEvent::default())
    }
}

impl ClickEvent {
    /// Modifiers at mouse release, or an empty set for keyboard and touch activation.
    ///
    /// GPUI generates keyboard clicks only without modifiers. For a mouse
    /// click whose modifiers changed while held, inspect the stored
    /// [`MouseClickEvent::down`] separately if the initial state matters.
    pub fn modifiers(&self) -> Modifiers {
        match self {
            // Click events are only generated from keyboard events _without any modifiers_, so we know the modifiers are always Default
            ClickEvent::Keyboard(_) => Modifiers::default(),
            // Click events on the web only reflect the modifiers for the keyup event,
            // tested via observing the behavior of the `ClickEvent.shiftKey` field in Chrome 138
            // under various combinations of modifiers and keyUp / keyDown events.
            ClickEvent::Mouse(event) => event.up.modifiers,
            // Touch screens have no modifier keys.
            ClickEvent::Touch(_) => Modifiers::default(),
        }
    }

    /// An anchor in logical window coordinates for this activation.
    ///
    /// Mouse activation uses the release position; touch activation uses the
    /// tap position. Keyboard activation uses the element's bottom-left
    /// corner, so a popup can be placed beside the control without a cursor.
    /// Use [`mouse_position`](Self::mouse_position) when the operation
    /// specifically requires mouse input rather than an activation anchor.
    pub fn position(&self) -> Point<Pixels> {
        match self {
            ClickEvent::Keyboard(event) => event.bounds.bottom_left(),
            ClickEvent::Mouse(event) => event.up.position,
            ClickEvent::Touch(event) => event.position,
        }
    }

    /// The mouse release position, if this is a mouse activation.
    ///
    /// Keyboard and direct touch activation return `None`. Portable touch
    /// taps currently synthesize mouse events, however, and arrive as
    /// [`ClickEvent::Mouse`]; this method cannot identify their physical device.
    pub fn mouse_position(&self) -> Option<Point<Pixels>> {
        match self {
            ClickEvent::Keyboard(_) => None,
            ClickEvent::Mouse(event) => Some(event.up.position),
            ClickEvent::Touch(_) => None,
        }
    }

    /// Whether both mouse events used the right button.
    ///
    /// Returns false for keyboard and touch variants. Use
    /// [`is_secondary`](Self::is_secondary) to include a direct touch long press.
    pub fn is_right_click(&self) -> bool {
        match self {
            ClickEvent::Keyboard(_) => false,
            ClickEvent::Mouse(event) => {
                event.down.button == MouseButton::Right && event.up.button == MouseButton::Right
            }
            ClickEvent::Touch(_) => false,
        }
    }

    /// Whether both mouse events used the middle button.
    ///
    /// Returns false for keyboard and touch variants.
    pub fn is_middle_click(&self) -> bool {
        match self {
            ClickEvent::Keyboard(_) => false,
            ClickEvent::Mouse(event) => {
                event.down.button == MouseButton::Middle && event.up.button == MouseButton::Middle
            }
            ClickEvent::Touch(_) => false,
        }
    }

    /// Returns whether the click is a secondary activation, i.e. a context
    /// menu trigger: a right click from a mouse (macOS ctrl-clicks arrive
    /// already converted to right clicks by the platform layer), or a long
    /// press on a touch screen.
    pub fn is_secondary(&self) -> bool {
        match self {
            ClickEvent::Keyboard(_) => false,
            ClickEvent::Mouse(event) => {
                event.down.button == MouseButton::Right && event.up.button == MouseButton::Right
            }
            ClickEvent::Touch(event) => event.long_press,
        }
    }

    /// Whether this is primary activation: a left click, keyboard click, or tap.
    ///
    /// A direct touch long press is secondary activation and returns false.
    pub fn standard_click(&self) -> bool {
        match self {
            ClickEvent::Keyboard(_) => true,
            ClickEvent::Mouse(event) => {
                event.down.button == MouseButton::Left && event.up.button == MouseButton::Left
            }
            ClickEvent::Touch(event) => !event.long_press,
        }
    }

    /// The mouse press's window-activation flag, or false for other variants.
    ///
    /// This does not establish that the clicked element acquired focus.
    /// See [`MouseDownEvent::first_mouse`] for the backend-dependent flag and
    /// [`FocusHandle::is_focused`](crate::FocusHandle::is_focused) to query
    /// an element's focus.
    pub fn first_focus(&self) -> bool {
        match self {
            ClickEvent::Keyboard(_) => false,
            ClickEvent::Mouse(event) => event.down.first_mouse,
            ClickEvent::Touch(_) => false,
        }
    }

    /// The mouse release's consecutive-click count, the tap count, or one for a key.
    ///
    /// The count follows the input sequence, not the lifetime of the control.
    pub fn click_count(&self) -> usize {
        match self {
            ClickEvent::Keyboard(_) => 1,
            ClickEvent::Mouse(event) => event.up.click_count,
            ClickEvent::Touch(event) => event.tap_count,
        }
    }

    /// Returns whether the click event is generated by a keyboard event
    pub fn is_keyboard(&self) -> bool {
        match self {
            ClickEvent::Mouse(_) | ClickEvent::Touch(_) => false,
            ClickEvent::Keyboard(_) => true,
        }
    }
}

/// An enum representing the keyboard button that was pressed for a click event.
#[derive(
    Hash, PartialEq, Eq, Copy, Clone, Debug, Default, serde::Serialize, serde::Deserialize,
)]
pub enum KeyboardButton {
    /// Enter key was clicked
    #[default]
    Enter,
    /// Space key was clicked
    Space,
}

/// An enum representing the mouse button that was pressed.
#[derive(
    Hash, Default, PartialEq, Eq, Copy, Clone, Debug, serde::Serialize, serde::Deserialize,
)]
pub enum MouseButton {
    /// The left mouse button.
    #[default]
    Left,

    /// The right mouse button.
    Right,

    /// The middle mouse button.
    Middle,

    /// A navigation button, such as back or forward.
    Navigate(NavigationDirection),
}

impl MouseButton {
    /// Return every mouse button in a stable order.
    ///
    /// The list includes back and forward navigation buttons after the three standard buttons.
    pub fn all() -> Vec<Self> {
        vec![
            MouseButton::Left,
            MouseButton::Right,
            MouseButton::Middle,
            MouseButton::Navigate(NavigationDirection::Back),
            MouseButton::Navigate(NavigationDirection::Forward),
        ]
    }
}

/// A navigation direction, such as back or forward.
#[derive(
    Hash, Default, PartialEq, Eq, Copy, Clone, Debug, serde::Serialize, serde::Deserialize,
)]
pub enum NavigationDirection {
    /// The back button.
    #[default]
    Back,

    /// The forward button.
    Forward,
}

/// A mouse move event from the platform.
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct MouseMoveEvent {
    /// The position of the mouse on the window.
    pub position: Point<Pixels>,

    /// The mouse button that was pressed, if any.
    pub pressed_button: Option<MouseButton>,

    /// The modifiers that were held down when the mouse was moved.
    pub modifiers: Modifiers,
}

impl Sealed for MouseMoveEvent {}
impl InputEvent for MouseMoveEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::MouseMove(self)
    }
}
impl MouseEvent for MouseMoveEvent {}

impl MouseMoveEvent {
    /// Returns true if the left mouse button is currently held down.
    pub fn dragging(&self) -> bool {
        self.pressed_button == Some(MouseButton::Left)
    }
}

/// Scrolling input from a wheel, trackpad, or GPUI's portable pan recognizer.
///
/// [`ScrollDelta`] distinguishes logical-pixel movement from line-based input.
/// A scrolling [`Div`](crate::Div) adds the converted delta to its content
/// offset: positive values move content right/down, and negative values reveal
/// content farther along that axis. Use [`ScrollDelta::pixel_delta`] when a
/// custom handler needs the same conversion.
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct ScrollWheelEvent {
    /// The reported pointer or pan position in logical window coordinates.
    pub position: Point<Pixels>,

    /// Incremental content movement, with its pixel or line unit preserved.
    pub delta: ScrollDelta,

    /// Modifiers held when this scrolling event was reported.
    pub modifiers: Modifiers,

    /// The phase of a scroll gesture when the input path supplies one.
    ///
    /// Some paths, including ordinary browser wheel input, report only `Moved`.
    /// Do not require `Started` before accepting a delta.
    pub touch_phase: TouchPhase,
}

impl Sealed for ScrollWheelEvent {}
impl InputEvent for ScrollWheelEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::ScrollWheel(self)
    }
}
impl MouseEvent for ScrollWheelEvent {}

impl Deref for ScrollWheelEvent {
    type Target = Modifiers;

    fn deref(&self) -> &Self::Target {
        &self.modifiers
    }
}

/// Incremental scrolling in logical pixels or caller-scaled line units.
///
/// Use [`Self::pixel_delta`] to convert a line delta with the control's line
/// height. A precise pixel delta is already in logical pixels; do not multiply
/// it by the display scale.
#[derive(Clone, Copy, Debug, serde::Serialize, serde::Deserialize)]
pub enum ScrollDelta {
    /// A precise movement in logical pixels, typically from a trackpad.
    Pixels(Point<Pixels>),
    /// Movement in line units; the control chooses each line's pixel extent.
    Lines(Point<f32>),
}

impl Default for ScrollDelta {
    fn default() -> Self {
        Self::Lines(Default::default())
    }
}

/// A platform-provided pinch gesture, typically from a desktop trackpad.
///
/// GPUI's portable touch recognizer currently recognizes taps, pans, and long
/// presses; it does not synthesize this event from two touch contacts. Support
/// and scale conventions depend on the platform input path.
///
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct PinchEvent {
    /// The reported gesture location in logical window coordinates.
    ///
    /// Current desktop backends use the pointer location, which need not be the
    /// centroid of the user's fingers.
    pub position: Point<Pixels>,

    /// Signed scale change for this update: positive zooms in, negative zooms out.
    ///
    /// Current macOS and Windows paths report a fractional change from the
    /// preceding update. X11 and Wayland instead subtract successive scales
    /// relative to the gesture's start. For example, a gesture scale changing
    /// from 1.5 to 1.6 produces `0.1` on those Linux paths, rather than
    /// `1.6 / 1.5 - 1.0`. This field is therefore not a uniform multiplicative
    /// scale across backends, nor an absolute scale to assign to a view.
    pub delta: f32,

    /// The modifiers that were held down during the pinch gesture.
    pub modifiers: Modifiers,

    /// The phase of the pinch gesture.
    pub phase: TouchPhase,
}

impl Sealed for PinchEvent {}
impl InputEvent for PinchEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::Pinch(self)
    }
}
impl GestureEvent for PinchEvent {}
impl MouseEvent for PinchEvent {}

impl Deref for PinchEvent {
    type Target = Modifiers;

    fn deref(&self) -> &Self::Target {
        &self.modifiers
    }
}

impl ScrollDelta {
    /// Returns true if this is a precise scroll delta in pixels.
    pub fn precise(&self) -> bool {
        match self {
            ScrollDelta::Pixels(_) => true,
            ScrollDelta::Lines(_) => false,
        }
    }

    /// Convert this delta to pixels, using `line_height` for line-based input.
    ///
    /// Pixel deltas are returned unchanged. Line deltas are multiplied by the supplied line
    /// height on each axis; the result is a scale choice for the caller, not a platform-provided
    /// exact distance.
    pub fn pixel_delta(&self, line_height: Pixels) -> Point<Pixels> {
        match self {
            ScrollDelta::Pixels(delta) => *delta,
            ScrollDelta::Lines(delta) => point(line_height * delta.x, line_height * delta.y),
        }
    }

    /// Combine deltas of the same unit for event coalescing.
    ///
    /// Per axis, matching signs are added and opposite signs use `other`, which preserves a
    /// direction reversal. If one delta is in pixels and the other in lines, `other` is returned
    /// unchanged because their units cannot be combined here.
    pub fn coalesce(self, other: ScrollDelta) -> ScrollDelta {
        match (self, other) {
            (ScrollDelta::Pixels(a), ScrollDelta::Pixels(b)) => {
                let x = if a.x.signum() == b.x.signum() {
                    a.x + b.x
                } else {
                    b.x
                };

                let y = if a.y.signum() == b.y.signum() {
                    a.y + b.y
                } else {
                    b.y
                };

                ScrollDelta::Pixels(point(x, y))
            }

            (ScrollDelta::Lines(a), ScrollDelta::Lines(b)) => {
                let x = if a.x.signum() == b.x.signum() {
                    a.x + b.x
                } else {
                    b.x
                };

                let y = if a.y.signum() == b.y.signum() {
                    a.y + b.y
                } else {
                    b.y
                };

                ScrollDelta::Lines(point(x, y))
            }

            _ => other,
        }
    }
}

/// A mouse exit event from the platform, generated when the mouse leaves the window.
#[derive(Clone, Debug, Default, serde::Serialize, serde::Deserialize)]
pub struct MouseExitEvent {
    /// The position of the mouse relative to the window.
    pub position: Point<Pixels>,
    /// The mouse button that was pressed, if any.
    pub pressed_button: Option<MouseButton>,
    /// The modifiers that were held down when the mouse was moved.
    pub modifiers: Modifiers,
}

impl Sealed for MouseExitEvent {}
impl InputEvent for MouseExitEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::MouseExited(self)
    }
}

impl MouseEvent for MouseExitEvent {}

impl Deref for MouseExitEvent {
    type Target = Modifiers;

    fn deref(&self) -> &Self::Target {
        &self.modifiers
    }
}

/// A collection of paths from the platform, such as from a file drop.
#[derive(Debug, Clone, Default, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct ExternalPaths(pub SmallVec<[PathBuf; 2]>);

impl ExternalPaths {
    /// Convert this collection of paths into a slice.
    pub fn paths(&self) -> &[PathBuf] {
        &self.0
    }
}

/// Data offered to the platform when an internal drag leaves the window and is
/// promoted to a native drag session.
#[derive(Debug, Clone, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub enum ExternalDragPayload {
    /// Real on-disk paths, handed to the platform as an outbound file drag.
    Files(FileDragPaths),
}

/// Paths handed to the platform for a native file drag. Directory metadata is
/// provided by the caller to avoid querying it when the platform drag starts.
#[derive(Debug, Clone, Default, Eq, PartialEq, serde::Serialize, serde::Deserialize)]
pub struct FileDragPaths(SmallVec<[(PathBuf, bool); 2]>);

impl FileDragPaths {
    /// Creates a native file-drag payload from paths paired with whether each path is a directory.
    pub fn new(entries: impl IntoIterator<Item = (PathBuf, bool)>) -> Self {
        Self(entries.into_iter().collect())
    }

    /// The dragged paths, each paired with whether it is a directory.
    pub fn entries(&self) -> &[(PathBuf, bool)] {
        &self.0
    }
}

impl Render for ExternalPaths {
    fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
        // the platform will render icons for the dragged files
        Empty
    }
}

/// A file drop event from the platform, generated when files are dragged and dropped onto the window.
///
/// `Entered` carries the offered paths. `Pending` updates only the pointer position while the
/// platform drag remains over the window. `Submit` marks the drop at a position, while `Exited`
/// and `Ended` report leaving the window and completion of the platform-owned drag session.
#[derive(Debug, Clone, serde::Serialize, serde::Deserialize)]
pub enum FileDropEvent {
    /// The files have entered the window.
    Entered {
        /// The position of the mouse relative to the window.
        position: Point<Pixels>,
        /// The paths of the files that are being dragged.
        paths: ExternalPaths,
    },
    /// The files are being dragged over the window
    Pending {
        /// The position of the mouse relative to the window.
        position: Point<Pixels>,
    },
    /// The files have been dropped onto the window.
    Submit {
        /// The position of the mouse relative to the window.
        position: Point<Pixels>,
    },
    /// The user has stopped dragging the files over the window.
    Exited,
    /// The platform-owned drag session has ended.
    Ended,
}

impl Sealed for FileDropEvent {}
impl InputEvent for FileDropEvent {
    fn to_platform_input(self) -> PlatformInput {
        PlatformInput::FileDrop(self)
    }
}
impl MouseEvent for FileDropEvent {}

/// An enum corresponding to all kinds of platform input events.
#[derive(Clone, Debug, serde::Serialize, serde::Deserialize)]
pub enum PlatformInput {
    /// A key was pressed.
    KeyDown(KeyDownEvent),
    /// A key was released.
    KeyUp(KeyUpEvent),
    /// The keyboard modifiers were changed.
    ModifiersChanged(ModifiersChangedEvent),
    /// The mouse was pressed.
    MouseDown(MouseDownEvent),
    /// The mouse was released.
    MouseUp(MouseUpEvent),
    /// Mouse pressure.
    MousePressure(MousePressureEvent),
    /// The mouse was moved.
    MouseMove(MouseMoveEvent),
    /// The mouse exited the window.
    MouseExited(MouseExitEvent),
    /// The scroll wheel was used.
    ScrollWheel(ScrollWheelEvent),
    /// A pinch gesture was performed.
    Pinch(PinchEvent),
    /// A long-press gesture recognized from touch input.
    LongPress(LongPressEvent),
    /// A direct touch drag claimed by an element.
    TouchDrag(TouchDragEvent),
    /// Files were dragged and dropped onto the window.
    FileDrop(FileDropEvent),
    /// A raw touch event on a touch screen.
    Touch(TouchEvent),
}

impl PlatformInput {
    pub(crate) fn mouse_event(&self) -> Option<&dyn Any> {
        match self {
            PlatformInput::KeyDown { .. } => None,
            PlatformInput::KeyUp { .. } => None,
            PlatformInput::ModifiersChanged { .. } => None,
            PlatformInput::MouseDown(event) => Some(event),
            PlatformInput::MouseUp(event) => Some(event),
            PlatformInput::MouseMove(event) => Some(event),
            PlatformInput::MousePressure(event) => Some(event),
            PlatformInput::MouseExited(event) => Some(event),
            PlatformInput::ScrollWheel(event) => Some(event),
            PlatformInput::Pinch(event) => Some(event),
            PlatformInput::LongPress(event) => Some(event),
            PlatformInput::TouchDrag(event) => Some(event),
            PlatformInput::FileDrop(event) => Some(event),
            PlatformInput::Touch(_) => None,
        }
    }

    pub(crate) fn keyboard_event(&self) -> Option<&dyn Any> {
        match self {
            PlatformInput::KeyDown(event) => Some(event),
            PlatformInput::KeyUp(event) => Some(event),
            PlatformInput::ModifiersChanged(event) => Some(event),
            PlatformInput::MouseDown(_) => None,
            PlatformInput::MouseUp(_) => None,
            PlatformInput::MouseMove(_) => None,
            PlatformInput::MousePressure(_) => None,
            PlatformInput::MouseExited(_) => None,
            PlatformInput::ScrollWheel(_) => None,
            PlatformInput::Pinch(_) => None,
            PlatformInput::LongPress(_) => None,
            PlatformInput::TouchDrag(_) => None,
            PlatformInput::FileDrop(_) => None,
            PlatformInput::Touch(_) => None,
        }
    }

    /// A short static name for this input's variant, for diagnostics and
    /// telemetry.
    pub fn kind_name(&self) -> &'static str {
        match self {
            PlatformInput::KeyDown(_) => "key_down",
            PlatformInput::KeyUp(_) => "key_up",
            PlatformInput::ModifiersChanged(_) => "modifiers_changed",
            PlatformInput::MouseDown(_) => "mouse_down",
            PlatformInput::MouseUp(_) => "mouse_up",
            PlatformInput::MousePressure(_) => "mouse_pressure",
            PlatformInput::MouseMove(_) => "mouse_move",
            PlatformInput::MouseExited(_) => "mouse_exited",
            PlatformInput::ScrollWheel(_) => "scroll_wheel",
            PlatformInput::Pinch(_) => "pinch",
            PlatformInput::LongPress(_) => "long_press",
            PlatformInput::TouchDrag(_) => "touch_drag",
            PlatformInput::FileDrop(_) => "file_drop",
            PlatformInput::Touch(_) => "touch",
        }
    }

    /// Returns the touch event contained in this input, if any.
    pub fn touch_event(&self) -> Option<&TouchEvent> {
        match self {
            PlatformInput::Touch(event) => Some(event),
            _ => None,
        }
    }
}

#[cfg(test)]
mod test {

    use crate::{
        self as gpui, AppContext as _, Context, FocusHandle, InteractiveElement, IntoElement,
        KeyBinding, Keystroke, Modifiers, ParentElement, Render, TestAppContext, Window, div,
    };

    struct TestView {
        saw_key_down: bool,
        saw_action: bool,
        focus_handle: FocusHandle,
    }

    actions!(test_only, [TestAction]);

    impl Render for TestView {
        fn render(&mut self, _: &mut Window, cx: &mut Context<Self>) -> impl IntoElement {
            div().id("testview").child(
                div()
                    .key_context("parent")
                    .on_key_down(cx.listener(|this, _, _, cx| {
                        cx.stop_propagation();
                        this.saw_key_down = true
                    }))
                    .on_action(cx.listener(|this: &mut TestView, _: &TestAction, _, _| {
                        this.saw_action = true
                    }))
                    .child(
                        div()
                            .key_context("nested")
                            .track_focus(&self.focus_handle)
                            .into_element(),
                    ),
            )
        }
    }

    #[gpui::test]
    fn test_on_events(cx: &mut TestAppContext) {
        let window = cx.update(|cx| {
            cx.open_window(Default::default(), |_, cx| {
                cx.new(|cx| TestView {
                    saw_key_down: false,
                    saw_action: false,
                    focus_handle: cx.focus_handle(),
                })
            })
            .unwrap()
        });

        cx.update(|cx| {
            cx.bind_keys(vec![KeyBinding::new("ctrl-g", TestAction, Some("parent"))]);
        });

        window
            .update(cx, |test_view, window, cx| {
                window.focus(&test_view.focus_handle, cx)
            })
            .unwrap();

        cx.dispatch_keystroke(*window, Keystroke::parse("a").unwrap());
        cx.dispatch_keystroke(*window, Keystroke::parse("ctrl-g").unwrap());

        window
            .update(cx, |test_view, _, _| {
                assert!(test_view.saw_key_down || test_view.saw_action);
                assert!(test_view.saw_key_down);
                assert!(test_view.saw_action);
            })
            .unwrap();
    }

    #[gpui::test]
    fn test_multi_modifier_gesture_does_not_dispatch_standalone_modifier_binding(
        cx: &mut TestAppContext,
    ) {
        let (test_view, cx) = cx.add_window_view(|_, cx| TestView {
            saw_key_down: false,
            saw_action: false,
            focus_handle: cx.focus_handle(),
        });

        cx.update(|_, cx| {
            cx.bind_keys(vec![KeyBinding::new("shift", TestAction, None)]);
        });
        test_view.update_in(cx, |test_view, window, cx| {
            window.focus(&test_view.focus_handle, cx);
        });

        cx.simulate_modifiers_change(Modifiers::alt());
        cx.simulate_modifiers_change(Modifiers::alt() | Modifiers::shift());
        cx.simulate_modifiers_change(Modifiers::shift());
        cx.simulate_modifiers_change(Modifiers::none());
        assert!(!test_view.read_with(cx, |test_view, _| test_view.saw_action));

        cx.simulate_modifiers_change(Modifiers::shift());
        cx.simulate_modifiers_change(Modifiers::none());
        assert!(test_view.read_with(cx, |test_view, _| test_view.saw_action));
    }
}
