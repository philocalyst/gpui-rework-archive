//! Platform contracts shared by GPUI's native, browser, and test backends.
//!
//! The traits in this module describe capabilities rather than a particular window toolkit:
//! executors, displays, windows, text shaping, clipboard, image decoding, and optional capture.
//! Implementations own native handles and must preserve the threading rules stated by each trait;
//! application code normally reaches them through [`crate::App`] and [`crate::Window`].

mod app_menu;
mod keyboard;
mod keystroke;

#[cfg(any(test, feature = "headless"))]
mod diagnostics;
#[cfg(any(test, feature = "headless"))]
pub use diagnostics::*;

#[cfg(all(target_os = "linux", feature = "wayland"))]
/// Wayland layer-shell surfaces for panels, overlays, and other desktop shell UI.
pub mod layer_shell;

/// Types for configuring parent-anchored popup windows such as menus, dropdowns and tooltips.
pub mod popup;

#[cfg(any(test, feature = "headless", feature = "bench-support"))]
mod threaded_dispatcher;

#[cfg(any(test, feature = "headless", feature = "bench-support"))]
mod test;

#[cfg(all(target_os = "macos", any(test, feature = "headless")))]
mod visual_test;

#[cfg(all(feature = "screen-capture", target_os = "windows"))]
pub mod screen_capture;
#[cfg(target_os = "windows")]
mod windows_screen_capture;
#[cfg(target_os = "windows")]
pub use windows_screen_capture::WindowsScreenCaptureFrame;

#[cfg(all(target_os = "windows", feature = "screen-capture"))]
pub(crate) type PlatformScreenCaptureFrame = WindowsScreenCaptureFrame;
#[cfg(not(feature = "screen-capture"))]
pub(crate) type PlatformScreenCaptureFrame = ();
#[cfg(all(target_os = "macos", feature = "screen-capture"))]
pub(crate) type PlatformScreenCaptureFrame = core_video::image_buffer::CVImageBuffer;
#[cfg(all(
    feature = "screen-capture",
    not(any(target_os = "macos", target_os = "windows"))
))]
// Screen capture currently has native frame representations only on macOS and Windows. Keep the
// cross-platform API well-formed for enabled-but-unsupported targets; source enumeration simply
// yields no platform sources there.
pub(crate) type PlatformScreenCaptureFrame = ();

use crate::util::FluentBuilder;
use crate::{
    Action, AnyWindowHandle, App, AsyncWindowContext, BackgroundExecutor, Bounds,
    DEFAULT_WINDOW_SIZE, DevicePixels, DispatchEventResult, Edges, ExternalDragPayload, Font,
    FontId, FontMetrics, ForegroundExecutor, GlyphAtlasEntry, GlyphId, GlyphRasterRequest,
    GpuSpecs, ImageSource, InlineLayout, InlineLayoutRequest, Keymap, LineLayout, Pixels,
    PlatformGestures, PlatformInput, Point, PreparedRasterStyle, Priority, RasterStyleRequest,
    RasterizedGlyph, RasterizedGlyphFormat, RenderGlyphParams, RenderImage, RenderImageParams,
    RenderSvgParams, Scene, SharedString, Size, SvgRenderer, SystemWindowTab, Task,
    TextLayoutRequest, ValidatedRasterizedGlyph, Window, WindowControlArea, hash, point, px,
};
#[cfg(any(target_os = "linux", target_os = "freebsd"))]
use anyhow::bail;
use anyhow::{Context as _, Result};
use async_task::Runnable;
use collections::FxHashMap;
use futures::channel::oneshot;
#[cfg(any(test, feature = "headless", feature = "bench-support"))]
use image::RgbaImage;
use image::codecs::gif::GifDecoder;
use image::{AnimationDecoder as _, DynamicImage, Frame};
use raw_window_handle::{HasDisplayHandle, HasWindowHandle};
use scheduler::Instant;
pub use scheduler::RunnableMeta;
use schemars::JsonSchema;
use seahash::SeaHasher;
use serde::{Deserialize, Serialize};
use smallvec::SmallVec;
use std::borrow::Cow;
use std::hash::{Hash, Hasher};
use std::io::Cursor;
use std::ops;
use std::time::Duration;
use std::{
    ffi::OsString,
    fmt::{self, Debug},
    ops::Range,
    path::{Path, PathBuf},
    rc::Rc,
    sync::Arc,
};
use strum::EnumIter;
use uuid::Uuid;

pub use app_menu::*;
pub use keyboard::*;
pub use keystroke::*;

#[cfg(any(test, feature = "headless", feature = "bench-support"))]
pub(crate) use test::*;

#[cfg(any(test, feature = "headless"))]
pub use test::{TestDispatcher, TestScreenCaptureSource, TestScreenCaptureStream};

#[cfg(any(test, feature = "headless"))]
pub use tests::TestTextSystem;

#[cfg(any(test, feature = "headless", feature = "bench-support"))]
pub use threaded_dispatcher::ThreadedDispatcher;

#[cfg(all(target_os = "macos", any(test, feature = "headless")))]
pub use visual_test::VisualTestPlatform;

// TODO(jk): return an enum instead of a string
/// Guess the compositor selected by the environment without opening a connection.
///
/// `ZED_HEADLESS` wins over display variables. On Linux and FreeBSD, a non-empty
/// `WAYLAND_DISPLAY` selects Wayland before `DISPLAY` selects X11; otherwise the result is
/// `"Headless"`. The returned string is descriptive and should not be used as a capability test.
#[cfg(any(target_os = "linux", target_os = "freebsd"))]
#[inline]
pub fn guess_compositor() -> &'static str {
    if std::env::var_os("ZED_HEADLESS").is_some() {
        return "Headless";
    }

    #[cfg(feature = "wayland")]
    let wayland_display = std::env::var_os("WAYLAND_DISPLAY");
    #[cfg(not(feature = "wayland"))]
    let wayland_display: Option<std::ffi::OsString> = None;

    #[cfg(feature = "x11")]
    let x11_display = std::env::var_os("DISPLAY");
    #[cfg(not(feature = "x11"))]
    let x11_display: Option<std::ffi::OsString> = None;

    let use_wayland = wayland_display.is_some_and(|display| !display.is_empty());
    let use_x11 = x11_display.is_some_and(|display| !display.is_empty());

    if use_wayland {
        "Wayland"
    } else if use_x11 {
        "X11"
    } else {
        "Headless"
    }
}

/// The activation policy for a macOS application.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum MacActivationPolicy {
    /// The application is an ordinary app that appears in the Dock and may have a user interface.
    #[default]
    Regular,
    /// The application doesn't appear in the Dock and doesn't have a menu bar, but it may be activated programmatically or by clicking on one of its windows.
    Accessory,
    /// The application doesn't appear in the Dock and may not create windows or be activated.
    Prohibited,
}

/// The operating-system services used by a GPUI application.
///
/// A backend owns the event loop, window peers, and system integration. GPUI
/// calls this trait on the UI thread; work returned by [`Self::background_executor`]
/// may run elsewhere. Application code normally uses [`App`] instead. Implement
/// this trait when adding a backend or providing a controlled test environment.
///
/// Optional methods often default to doing nothing or returning `None`. That
/// default lets a backend omit a service; it does not establish that the
/// service succeeded. Follow the result/callback contract of the operation,
/// and see the [platform chapter](crate::_documentation::platforms) for backend
/// selection and known differences.
pub trait Platform: 'static {
    /// Executor for work that may run away from the UI thread.
    fn background_executor(&self) -> BackgroundExecutor;
    /// Executor for work serialized with the platform event loop.
    fn foreground_executor(&self) -> ForegroundExecutor;
    /// Shared backend text system used by new windows.
    fn text_system(&self) -> Arc<dyn PlatformTextSystem>;

    /// Apply the macOS activation policy; a no-op elsewhere.
    fn set_mac_activation_policy(&self, _policy: MacActivationPolicy) {}
    /// Enter the native event loop and invoke `on_finish_launching` after launch.
    fn run(&self, on_finish_launching: Box<dyn 'static + FnOnce()>);
    /// Ask the operating system to terminate the application.
    fn quit(&self);
    /// Relaunch the application, optionally with a replacement executable and arguments.
    fn restart(&self, binary_path: Option<PathBuf>, arguments: Vec<OsString>);
    /// Request application activation, optionally ignoring the currently active application.
    fn activate(&self, ignoring_other_apps: bool);
    /// Hide this application.
    fn hide(&self);
    /// Hide every other application where the platform supports it.
    fn hide_other_apps(&self);
    /// Undo a previous [`Self::hide_other_apps`] request.
    fn unhide_other_apps(&self);

    /// Enumerate displays currently visible to the backend.
    fn displays(&self) -> Vec<Rc<dyn PlatformDisplay>>;
    /// Return the platform-designated primary display, if one exists.
    fn primary_display(&self) -> Option<Rc<dyn PlatformDisplay>>;
    /// Return the active application window, if the platform exposes one.
    fn active_window(&self) -> Option<AnyWindowHandle>;
    /// Return windows in platform stacking order when supported.
    fn window_stack(&self) -> Option<Vec<AnyWindowHandle>> {
        None
    }

    /// Report whether native screen capture can be requested.
    fn is_screen_capture_supported(&self) -> bool {
        false
    }

    /// Discover capturable sources asynchronously, or return an unavailable error.
    fn screen_capture_sources(
        &self,
    ) -> oneshot::Receiver<anyhow::Result<Vec<Rc<dyn ScreenCaptureSource>>>> {
        let (sources_tx, sources_rx) = oneshot::channel();
        sources_tx
            .send(Err(anyhow::anyhow!(
                "gpui was compiled without the screen-capture feature"
            )))
            .ok();
        sources_rx
    }

    /// Create the native peer for a GPUI window.
    fn open_window(
        &self,
        handle: AnyWindowHandle,
        options: WindowParams,
    ) -> anyhow::Result<Box<dyn PlatformWindow>>;

    /// Returns the appearance of the application's windows.
    fn window_appearance(&self) -> WindowAppearance;

    /// Overrides the appearance (light/dark) applied to the app's windows, independent
    /// of the OS-wide setting. Pass `None` to clear the override and follow the system
    /// again. The override is reflected by [`Platform::window_appearance`].
    ///
    /// Currently only implemented on macOS, where it sets `NSApplication.appearance` so
    /// the native window chrome (the window border and titlebar) of every window matches
    /// a dark app theme even when the system is in light mode (or vice versa). A no-op on
    /// other platforms.
    fn set_window_appearance(&self, _appearance: Option<WindowAppearance>) {}

    /// Returns the window button layout configuration when supported.
    fn button_layout(&self) -> Option<WindowButtonLayout> {
        None
    }

    /// Ask the operating system to open `url` using its default handler.
    fn open_url(&self, url: &str);
    /// Register the callback for URLs delivered to an already-running application.
    ///
    /// The backend invokes it for URL-open events routed to this process. Registering the handler
    /// does not itself register a scheme; use [`Self::register_url_scheme`] for that. The callback
    /// is retained by the backend.
    fn on_open_urls(&self, callback: Box<dyn FnMut(Vec<String>)>);
    /// Register a URL scheme for this application and resolve with registration status.
    ///
    /// The task can fail when the operating system rejects the registration. Registration only
    /// routes future opens to this app; use [`Self::on_open_urls`] to receive them.
    fn register_url_scheme(&self, url: &str) -> Task<Result<()>>;

    /// Open a file/directory picker.
    ///
    /// The receiver resolves asynchronously to selected paths, `Ok(None)` on cancellation, or an
    /// error if the picker fails. A dropped receiver does not imply that the platform canceled
    /// the native dialog.
    fn prompt_for_paths(
        &self,
        options: PathPromptOptions,
    ) -> oneshot::Receiver<Result<Option<Vec<PathBuf>>>>;
    /// Open a save dialog, initially showing `directory` and `suggested_name`.
    ///
    /// The receiver resolves to the selected path, `Ok(None)` on cancellation, or an error if the
    /// dialog fails. A dropped receiver does not necessarily cancel the native dialog.
    fn prompt_for_new_path(
        &self,
        directory: &Path,
        suggested_name: Option<&str>,
    ) -> oneshot::Receiver<Result<Option<PathBuf>>>;
    /// Whether one picker can select files and directories together.
    fn can_select_mixed_files_and_dirs(&self) -> bool;
    /// Reveal a path in the platform's file manager.
    fn reveal_path(&self, path: &Path);
    /// Open a path with its registered system application.
    fn open_with_system(&self, path: &Path);

    /// Install the quit callback; its return value permits (`true`) or vetoes termination.
    fn on_quit(&self, callback: Box<dyn FnMut() -> bool>);
    /// Install the callback for reopening an already-running application.
    fn on_reopen(&self, callback: Box<dyn FnMut()>);
    /// Install the callback for waking from system sleep.
    fn on_system_wake(&self, callback: Box<dyn FnMut()>);

    // Mobile platform methods. On mobile the OS owns the application
    // lifecycle: apps are backgrounded, foregrounded, and killed at the
    // system's discretion, and must react rather than decide.

    /// Registers a callback invoked whenever the application's lifecycle
    /// phase changes. See [`AppLifecyclePhase`] for the phase vocabulary and
    /// its mapping onto iOS and Android.
    ///
    /// Desktop platforms never invoke this.
    fn on_app_lifecycle(&self, _callback: Box<dyn FnMut(AppLifecyclePhase)>) {}

    /// Registers a callback invoked when the OS signals memory pressure
    /// (iOS `didReceiveMemoryWarning`, Android `onTrimMemory`).
    ///
    /// Desktop platforms never invoke this.
    fn on_memory_warning(&self, _callback: Box<dyn FnMut()>) {}

    /// The platform's gesture recognition services, if it provides any
    /// beyond gpui's portable recognizers. See
    /// [`PlatformGestures`](crate::PlatformGestures).
    fn gestures(&self) -> Option<Rc<dyn PlatformGestures>> {
        None
    }

    /// Replace the application menu, using `keymap` to display shortcut labels.
    ///
    /// Menu actions are dispatched through [`Self::on_app_menu_action`]; the backend may also ask
    /// [`Self::on_validate_app_menu_command`] whether each action is currently enabled.
    fn set_menus(&self, menus: Vec<Menu>, keymap: &Keymap);
    /// Read back the application menu, when the backend supports it.
    fn get_menus(&self) -> Option<Vec<OwnedMenu>> {
        None
    }

    /// Replace the macOS Dock menu, using `keymap` to display shortcuts.
    fn set_dock_menu(&self, menu: Vec<MenuItem>, keymap: &Keymap);
    /// Dispatch a Dock menu action by its backend-assigned index.
    fn perform_dock_menu_action(&self, _action: usize) {}
    /// Add a path to the operating system's recent-document list, where supported.
    fn add_recent_document(&self, _path: &Path) {}
    /// Update the Windows jump list and return entries the system rejected.
    fn update_jump_list(
        &self,
        _menus: Vec<MenuItem>,
        _entries: Vec<SmallVec<[PathBuf; 2]>>,
    ) -> Task<Vec<SmallVec<[PathBuf; 2]>>> {
        Task::ready(Vec::new())
    }
    /// Install the callback that dispatches an application-menu action selected by the user.
    fn on_app_menu_action(&self, callback: Box<dyn FnMut(&dyn Action)>);
    /// Install the callback invoked immediately before the application menu opens.
    fn on_will_open_app_menu(&self, callback: Box<dyn FnMut()>);
    /// Install the callback that determines whether a menu action is enabled when the menu opens.
    fn on_validate_app_menu_command(&self, callback: Box<dyn FnMut(&dyn Action) -> bool>);

    /// Current system thermal pressure, for reducing discretionary work.
    fn thermal_state(&self) -> ThermalState;
    /// Install the callback for changes to [`Self::thermal_state`].
    fn on_thermal_state_change(&self, callback: Box<dyn FnMut()>);

    /// Sets the application's process-wide identity and user-visible name.
    ///
    /// The identifier is used for platform identity mechanisms such as the
    /// Windows AppUserModelID. The name is used wherever the operating system
    /// presents the application to the user. Call this once, early in startup,
    /// before opening windows or posting notifications.
    fn set_app_identity(&self, identifier: &str, name: &str) {
        _ = (identifier, name);
    }

    /// Posts a notification to the operating system's notification center.
    ///
    /// Posting a notification whose [`SystemNotification::tag`] matches an
    /// earlier one replaces that notification where the platform supports it.
    /// No-op on platforms without notification support, or when delivery is
    /// unavailable (e.g. authorization was denied).
    fn show_system_notification(&self, notification: SystemNotification) {
        _ = notification;
    }

    /// Removes the delivered or pending notification with this tag.
    ///
    /// Best-effort: some platforms cannot retract a notification once shown,
    /// in which case it ages out of the notification center on its own.
    fn dismiss_system_notification(&self, tag: &str) {
        _ = tag;
    }

    /// Registers the callback invoked when the user activates a system
    /// notification, either by clicking its body or one of its action
    /// buttons.
    ///
    /// Implementations must invoke the callback on the main thread.
    fn on_system_notification_response(
        &self,
        callback: Box<dyn FnMut(SystemNotificationResponse)>,
    ) {
        _ = callback;
    }

    /// A diagnostic compositor name, or an empty string when unavailable.
    fn compositor_name(&self) -> &'static str {
        ""
    }
    /// Locate the application bundle or executable, according to platform conventions.
    fn app_path(&self) -> Result<PathBuf>;
    /// Locate a named helper executable shipped with the application.
    fn path_for_auxiliary_executable(&self, name: &str) -> Result<PathBuf>;

    /// Change the cursor displayed over application windows.
    fn set_cursor_style(&self, style: CursorStyle);

    /// Hides the mouse cursor until the user moves the mouse over one of
    /// this application's windows.
    fn hide_cursor_until_mouse_moves(&self);

    /// Returns whether the mouse cursor is currently visible.
    fn is_cursor_visible(&self) -> bool;

    /// Whether the user's system preference is to hide idle scrollbars.
    fn should_auto_hide_scrollbars(&self) -> bool;

    /// Read synchronously available clipboard contents; prefer the async method on web.
    fn read_from_clipboard(&self) -> Option<ClipboardItem>;
    /// Replace the system clipboard contents.
    fn write_to_clipboard(&self, item: ClipboardItem);

    /// Reads the clipboard, resolving once its contents are available.
    ///
    /// Most platforms read synchronously and return a ready task. Platforms
    /// whose clipboard access is inherently asynchronous and permission-gated
    /// (e.g. the browser's async clipboard API) override this method; on those
    /// platforms [`Platform::read_from_clipboard`] cannot return the clipboard
    /// contents, so callers that can await should prefer this method.
    fn read_from_clipboard_async(&self) -> Task<Result<Option<ClipboardItem>, ClipboardReadError>> {
        Task::ready(Ok(self.read_from_clipboard()))
    }

    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    /// Read the primary selection, which is separate from the regular clipboard.
    fn read_from_primary(&self) -> Option<ClipboardItem>;
    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    /// Replace the primary selection.
    fn write_to_primary(&self, item: ClipboardItem);

    #[cfg(target_os = "macos")]
    /// Read the macOS find pasteboard shared by application search fields.
    fn read_from_find_pasteboard(&self) -> Option<ClipboardItem>;
    #[cfg(target_os = "macos")]
    /// Replace the macOS find pasteboard contents.
    fn write_to_find_pasteboard(&self, item: ClipboardItem);

    /// Store credentials scoped to `url` in the platform credential store.
    ///
    /// The returned task reports access, encoding, or backend errors.
    fn write_credentials(&self, url: &str, username: &str, password: &[u8]) -> Task<Result<()>>;
    /// Read stored credentials for `url`; `Ok(None)` means no entry exists.
    fn read_credentials(&self, url: &str) -> Task<Result<Option<(String, Vec<u8>)>>>;
    /// Remove credentials scoped to `url`; the task reports store errors.
    fn delete_credentials(&self, url: &str) -> Task<Result<()>>;

    /// Describe the currently selected keyboard layout for matching key input.
    fn keyboard_layout(&self) -> Box<dyn PlatformKeyboardLayout>;
    /// Map key equivalents and shortcut labels for the current keyboard layout.
    ///
    /// Use the mapper for layout-sensitive matching or display; raw parsed [`Keystroke`] values
    /// are appropriate when the keymap syntax itself is the data being stored.
    fn keyboard_mapper(&self) -> Rc<dyn PlatformKeyboardMapper>;
    /// Install the callback for keyboard-layout changes.
    fn on_keyboard_layout_change(&self, callback: Box<dyn FnMut()>);

    /// Register additional GPU device requirements (features, limits) before
    /// the first window is opened.  The concrete type inside the `Box` must be
    /// `gpui_wgpu::WgpuDeviceRequirements`.
    fn set_gpu_requirements(&self, _requirements: Box<dyn std::any::Any>) {}

    /// Sets the label applied to credentials stored in the system keyring.
    /// Only Linux/FreeBSD use this label.
    fn set_keyring_label(&self, _label: SharedString) {}

    /// Whether the current platform supports haptic feedback.
    fn supports_haptic_feedback(&self) -> bool {
        false
    }

    /// Play a haptic feedback of the given style.
    ///
    /// No-op on platforms that don't support haptic feedback.
    fn play_haptic_feedback(&self, _style: HapticFeedbackStyle) {}
}

/// A handle to a platform's display, e.g. a monitor or laptop screen.
pub trait PlatformDisplay: Debug {
    /// Return the backend-local ID for this display.
    fn id(&self) -> DisplayId;

    /// Return a stable identifier suitable for persisting across system restarts.
    ///
    /// Returns an error when the backend cannot obtain a persistent display identity.
    fn uuid(&self) -> Result<Uuid>;

    /// Return the full display rectangle in the shared global logical-pixel coordinate space.
    fn bounds(&self) -> Bounds<Pixels>;

    /// Return the usable global logical-pixel rectangle, excluding reserved work areas.
    ///
    /// The default is the full display bounds; backends may subtract areas such as a taskbar or
    /// dock when the window manager reports them.
    fn visible_bounds(&self) -> Bounds<Pixels> {
        self.bounds()
    }

    /// Return a default global logical-pixel rectangle for a new window on this display.
    ///
    /// The default centers `DEFAULT_WINDOW_SIZE` in the full display bounds, clipping the size to
    /// fit the display. Backends may override this policy.
    fn default_bounds(&self) -> Bounds<Pixels> {
        let bounds = self.bounds();
        let center = bounds.center();
        let clipped_window_size = DEFAULT_WINDOW_SIZE.min(&bounds.size);

        let offset = clipped_window_size / 2.0;
        let origin = point(center.x - offset.width, center.y - offset.height);
        Bounds::new(origin, clipped_window_size)
    }
}

/// A notification posted to the operating system's notification center,
/// rather than rendered as in-app UI.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SystemNotification {
    /// Stable identity for the notification. Posting a new notification with
    /// the same tag replaces the previous one where the platform supports it,
    /// and responses carry the tag back to the application.
    pub tag: SharedString,
    /// The notification's headline.
    pub title: SharedString,
    /// Additional text displayed below the title.
    pub body: SharedString,
    /// Buttons offered on the notification. Platforms that cannot display
    /// action buttons show the notification without them.
    pub actions: Vec<SystemNotificationAction>,
}

/// A button offered on a [`SystemNotification`].
#[derive(Clone, Debug, PartialEq, Eq, Hash)]
pub struct SystemNotificationAction {
    /// Identifies the action in [`SystemNotificationResponse::action_id`]
    /// when the user presses this button.
    pub id: SharedString,
    /// The button's user-visible label.
    pub label: SharedString,
}

/// The user's activation of a [`SystemNotification`].
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct SystemNotificationResponse {
    /// The [`SystemNotification::tag`] of the activated notification.
    pub tag: SharedString,
    /// The pressed action button's [`SystemNotificationAction::id`], or
    /// `None` when the user activated the notification body itself.
    pub action_id: Option<SharedString>,
}

/// Thermal state of the system
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ThermalState {
    /// System has no thermal constraints
    Nominal,
    /// System is slightly constrained, reduce discretionary work
    Fair,
    /// System is moderately constrained, reduce CPU/GPU intensive work
    Serious,
    /// System is critically constrained, minimize all resource usage
    Critical,
}

/// Styles of haptic feedback that can be played via the platform.
///
/// These correspond directly to [`NSHapticFeedbackPattern`](https://developer.apple.com/documentation/appkit/nshapticfeedbackmanager/feedbackpattern)
/// values on macOS. On other platforms, all styles are no-ops.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum HapticFeedbackStyle {
    /// A generic haptic tap — suitable for most interactions.
    Generic,
    /// A sharp snap — for alignment guides, detents, and snapping.
    Alignment,
    /// A distinct level-change click — for slider steps, toggles, and
    /// discrete state changes.
    LevelChange,
}

/// Metadata for a [`ScreenCaptureSource`] or its active stream.
#[derive(Clone)]
pub struct SourceMetadata {
    /// Opaque identifier of this screen.
    pub id: u64,
    /// Human-readable label for this source.
    pub label: Option<SharedString>,
    /// Whether this source is the main display.
    pub is_main: Option<bool>,
    /// Video resolution of this source in device pixels.
    pub resolution: Size<DevicePixels>,
}

/// A platform-owned source of on-screen video content that can be captured.
///
/// Keep the source alive while requesting a stream. Enumeration and stream startup can fail
/// independently, so handle both receiver errors and the returned `Result`.
pub trait ScreenCaptureSource {
    /// Returns metadata for this source.
    fn metadata(&self) -> Result<SourceMetadata>;

    /// Start video capture and invoke `frame_callback` for each available frame.
    ///
    /// The returned receiver resolves when the stream starts or startup fails. The callback may
    /// run on a native capture thread; marshal UI work through the foreground executor instead
    /// of borrowing GPUI state directly from it. Keep the returned stream alive to continue
    /// capture; dropping it stops the stream where supported.
    fn stream(
        &self,
        foreground_executor: &ForegroundExecutor,
        frame_callback: Box<dyn Fn(ScreenCaptureFrame) + Send>,
    ) -> oneshot::Receiver<Result<Box<dyn ScreenCaptureStream>>>;
}

/// A running video stream captured from a screen.
///
/// The stream owns the native capture session. Drop it to stop capture; metadata describes the
/// source associated with this session.
pub trait ScreenCaptureStream {
    /// Returns metadata for this source.
    fn metadata(&self) -> Result<SourceMetadata>;
}

/// A frame of video captured from a screen.
pub struct ScreenCaptureFrame(
    /// The native frame representation for this target and feature configuration.
    pub PlatformScreenCaptureFrame,
);

/// An opaque identifier for a hardware display
#[derive(PartialEq, Eq, Hash, Copy, Clone)]
pub struct DisplayId(pub(crate) u64);

impl DisplayId {
    /// Create a new `DisplayId` from a raw platform display identifier.
    pub fn new(id: u64) -> Self {
        Self(id)
    }
}

impl From<u64> for DisplayId {
    fn from(id: u64) -> Self {
        Self(id)
    }
}

impl From<DisplayId> for u64 {
    fn from(id: DisplayId) -> Self {
        id.0
    }
}

impl Debug for DisplayId {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "DisplayId({})", self.0)
    }
}

/// Which part of the window to resize
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum ResizeEdge {
    /// The top edge
    Top,
    /// The top right corner
    TopRight,
    /// The right edge
    Right,
    /// The bottom right corner
    BottomRight,
    /// The bottom edge
    Bottom,
    /// The bottom left corner
    BottomLeft,
    /// The left edge
    Left,
    /// The top left corner
    TopLeft,
}

/// Requested owner of window decorations such as the titlebar and borders.
#[derive(Debug, Copy, Clone, Eq, PartialEq, Hash, Default)]
pub enum WindowDecorations {
    #[default]
    /// Ask the window manager or compositor to draw decorations.
    Server,
    /// Draw decorations within the application surface.
    Client,
}

/// Effective decoration mode reported by the backend.
///
/// This can differ from the requested [`WindowDecorations`] when the window
/// system applies its own policy. Client decorations also carry the edge-tiling
/// state needed to decide which borders to draw.
#[derive(Debug, Copy, Clone, Eq, PartialEq, Hash, Default)]
pub enum Decorations {
    /// The window is configured to use server side decorations
    #[default]
    Server,
    /// The window is configured to use client side decorations
    Client {
        /// The edge tiling state
        tiling: Tiling,
    },
}

/// Window-management controls the backend reports as available.
///
/// The default enables all four controls. It is a backend fallback, not an
/// operating-system capability probe; obtain the window's reported value when
/// deciding which controls to show.
#[derive(Debug, Copy, Clone, Eq, PartialEq, Hash)]
pub struct WindowControls {
    /// Whether this platform supports fullscreen
    pub fullscreen: bool,
    /// Whether this platform supports maximize
    pub maximize: bool,
    /// Whether this platform supports minimize
    pub minimize: bool,
    /// Whether this platform supports a window menu
    pub window_menu: bool,
}

impl Default for WindowControls {
    fn default() -> Self {
        // Assume that we can do anything, unless told otherwise
        Self {
            fullscreen: true,
            maximize: true,
            minimize: true,
            window_menu: true,
        }
    }
}

/// A window control button type used in [`WindowButtonLayout`].
#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
pub enum WindowButton {
    /// The minimize button
    Minimize,
    /// The maximize button
    Maximize,
    /// The close button
    Close,
}

impl WindowButton {
    /// Returns a stable element ID for rendering this button.
    pub fn id(&self) -> &'static str {
        match self {
            WindowButton::Minimize => "minimize",
            WindowButton::Maximize => "maximize",
            WindowButton::Close => "close",
        }
    }

    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    fn index(&self) -> usize {
        match self {
            WindowButton::Minimize => 0,
            WindowButton::Maximize => 1,
            WindowButton::Close => 2,
        }
    }
}

/// Maximum number of [`WindowButton`]s per side in the titlebar.
pub const MAX_BUTTONS_PER_SIDE: usize = 3;

/// Describes which [`WindowButton`]s appear on each side of the titlebar.
///
/// On Linux, this is read from the desktop environment's configuration
/// (e.g. GNOME's `gtk-decoration-layout` setting) via the Linux/FreeBSD parser.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct WindowButtonLayout {
    /// Buttons on the left side of the titlebar.
    pub left: [Option<WindowButton>; MAX_BUTTONS_PER_SIDE],
    /// Buttons on the right side of the titlebar.
    pub right: [Option<WindowButton>; MAX_BUTTONS_PER_SIDE],
}

#[cfg(any(target_os = "linux", target_os = "freebsd"))]
impl WindowButtonLayout {
    /// Return GPUI's Linux fallback: minimize, maximize, and close on the right.
    pub fn linux_default() -> Self {
        Self {
            left: [None; MAX_BUTTONS_PER_SIDE],
            right: [
                Some(WindowButton::Minimize),
                Some(WindowButton::Maximize),
                Some(WindowButton::Close),
            ],
        }
    }

    /// Parses a GNOME-style `button-layout` string (e.g. `"close,minimize:maximize"`).
    ///
    /// A colon separates the left and right sides. Without one, all buttons
    /// belong to the right. Whitespace and empty comma-separated entries are
    /// ignored, and each recognized button appears only once across both sides.
    /// Unknown names are ignored if at least one valid button remains; a
    /// non-empty set of only unknown names returns an error. An empty string
    /// deliberately produces no buttons.
    pub fn parse(layout_string: &str) -> Result<Self> {
        fn parse_side(
            s: &str,
            seen_buttons: &mut [bool; MAX_BUTTONS_PER_SIDE],
            unrecognized: &mut Vec<String>,
        ) -> [Option<WindowButton>; MAX_BUTTONS_PER_SIDE] {
            let mut result = [None; MAX_BUTTONS_PER_SIDE];
            let mut i = 0;
            for name in s.split(',') {
                let trimmed = name.trim();
                if trimmed.is_empty() {
                    continue;
                }
                let button = match trimmed {
                    "minimize" => Some(WindowButton::Minimize),
                    "maximize" => Some(WindowButton::Maximize),
                    "close" => Some(WindowButton::Close),
                    other => {
                        unrecognized.push(other.to_string());
                        None
                    }
                };
                if let Some(button) = button {
                    if seen_buttons[button.index()] {
                        continue;
                    }
                    if let Some(slot) = result.get_mut(i) {
                        *slot = Some(button);
                        seen_buttons[button.index()] = true;
                        i += 1;
                    }
                }
            }
            result
        }

        let (left_str, right_str) = layout_string.split_once(':').unwrap_or(("", layout_string));
        let mut unrecognized = Vec::new();
        let mut seen_buttons = [false; MAX_BUTTONS_PER_SIDE];
        let layout = Self {
            left: parse_side(left_str, &mut seen_buttons, &mut unrecognized),
            right: parse_side(right_str, &mut seen_buttons, &mut unrecognized),
        };

        if !unrecognized.is_empty()
            && layout.left.iter().all(Option::is_none)
            && layout.right.iter().all(Option::is_none)
        {
            bail!(
                "button layout string {:?} contains no valid buttons (unrecognized: {})",
                layout_string,
                unrecognized.join(", ")
            );
        }

        Ok(layout)
    }

    /// Formats the layout back into a GNOME-style `button-layout` string.
    #[cfg(test)]
    pub fn format(&self) -> String {
        fn format_side(buttons: &[Option<WindowButton>; MAX_BUTTONS_PER_SIDE]) -> String {
            buttons
                .iter()
                .flatten()
                .map(|button| match button {
                    WindowButton::Minimize => "minimize",
                    WindowButton::Maximize => "maximize",
                    WindowButton::Close => "close",
                })
                .collect::<Vec<_>>()
                .join(",")
        }

        format!("{}:{}", format_side(&self.left), format_side(&self.right))
    }
}

/// A type to describe which sides of the window are currently tiled in some way
#[derive(Debug, Copy, Clone, Eq, PartialEq, Hash, Default)]
pub struct Tiling {
    /// Whether the top edge is tiled
    pub top: bool,
    /// Whether the left edge is tiled
    pub left: bool,
    /// Whether the right edge is tiled
    pub right: bool,
    /// Whether the bottom edge is tiled
    pub bottom: bool,
}

impl Tiling {
    /// Initializes a [`Tiling`] type with all sides tiled
    pub fn tiled() -> Self {
        Self {
            top: true,
            left: true,
            right: true,
            bottom: true,
        }
    }

    /// Whether any edge is tiled
    pub fn is_tiled(&self) -> bool {
        self.top || self.left || self.right || self.bottom
    }
}

/// Callbacks for the accessibility adapter.
pub struct A11yCallbacks {
    /// Called when the adapter is activated (a screen reader connects).
    pub activation: Box<dyn Fn() -> Option<accesskit::TreeUpdate> + Send + 'static>,
    /// Called when an action is requested by the screen reader.
    pub action: Box<dyn Fn(accesskit::ActionRequest) + Send + 'static>,
    /// Called when the adapter is deactivated (screen reader disconnects).
    pub deactivation: Box<dyn Fn() + Send + 'static>,
}

/// Requirements attached to a platform's request for a new frame.
#[derive(Debug, Copy, Clone, Eq, PartialEq, Default)]
pub struct RequestFrameOptions {
    /// Whether a presentation is required.
    pub require_presentation: bool,
    /// Force refresh of all rendering states when true.
    pub force_render: bool,
}

/// The application's lifecycle phase, as owned and reported by a mobile OS.
///
/// `Inactive` means visible but not receiving input (a system dialog on
/// top), while `Background` means not visible at all, with process death
/// possible at any time thereafter.
///
/// | Phase        | iOS                          | Android      |
/// |--------------|------------------------------|--------------|
/// | `Active`     | `didBecomeActive`            | `onResume`   |
/// | `Inactive`   | `willResignActive`           | `onPause`    |
/// | `Background` | `didEnterBackground`         | `onStop`     |
/// | `Foreground` | `willEnterForeground`        | `onStart`    |
#[derive(Debug, Copy, Clone, Eq, PartialEq, Hash)]
pub enum AppLifecyclePhase {
    /// Foreground and receiving input.
    Active,
    /// Foreground (visible) but not receiving input.
    Inactive,
    /// Not visible. The GPU surface may be destroyed while backgrounded and
    /// the process may be killed without further notice.
    Background,
    /// Becoming visible again, before input is restored.
    Foreground,
}

/// Edge distances reserved by system UI, display cutouts, and the soft keyboard.
///
/// Each field uses logical pixels measured inward from the corresponding
/// window edge. [`effective`](Self::effective) combines overlapping reservations
/// by taking the maximum at each edge. The application decides how its layout
/// responds; reporting an inset does not automatically pad the element tree.
#[derive(Debug, Clone, Default, PartialEq)]
pub struct WindowInsets {
    /// Regions covered by system UI or hardware: status bar, display
    /// cutouts/notch, home indicator, navigation bars.
    /// (iOS: `safeAreaInsets`. Android: `WindowInsets` of types
    /// `systemBars() | displayCutout()`.)
    pub safe_area: Edges<Pixels>,
    /// The region covered by the keyboard, when present.
    /// (iOS: derived from `keyboardWillShow`/frame-change notifications.
    /// Android: `WindowInsets.Type.ime()`.)
    pub ime: Edges<Pixels>,
}

impl WindowInsets {
    /// Combine system and keyboard reservations with a per-edge maximum.
    ///
    /// This does not add the two distances: overlapping areas are avoided once.
    pub fn effective(&self) -> Edges<Pixels> {
        Edges {
            top: self.safe_area.top.max(self.ime.top),
            right: self.safe_area.right.max(self.ime.right),
            bottom: self.safe_area.bottom.max(self.ime.bottom),
            left: self.safe_area.left.max(self.ime.left),
        }
    }
}

/// A change in the state of the focused text input.
#[derive(Debug, Copy, Clone, Eq, PartialEq, Hash)]
pub enum TextInputStateChange {
    /// An editable element gained focus.
    FocusGained,
    /// The focused editable element lost focus.
    FocusLost,
    /// The selection or caret moved
    SelectionChanged,
    /// The document content changed outside of platform-initiated edits.
    ContentChanged,
}

/// The native peer of a [`Window`], including input, presentation, and window management.
///
/// Positions and sizes use logical [`Pixels`] unless explicitly stated otherwise.
/// The scale factor converts them to device pixels. Callback setters connect the
/// native event loop to GPUI; their callbacks must run on the UI thread. Optional
/// services have defaults so a backend can omit unsupported system features.
pub trait PlatformWindow: HasWindowHandle + HasDisplayHandle {
    /// Return backend window geometry in logical pixels.
    ///
    /// Global position and decoration coverage depend on the window system.
    /// Wayland top-level surfaces and browser canvases cannot supply a normal
    /// desktop position. Use [`Self::content_size`] for drawable dimensions
    /// and [`Self::window_bounds`] for restoration state.
    fn bounds(&self) -> Bounds<Pixels>;
    /// Report whether the native window is maximized.
    fn is_maximized(&self) -> bool;
    /// Return the native window bounds, including platform-specific state.
    fn window_bounds(&self) -> WindowBounds;
    /// Return the drawable content size in logical pixels, excluding native decorations.
    fn content_size(&self) -> Size<Pixels>;
    /// Request a content resize; native constraints may adjust the result asynchronously.
    fn resize(&mut self, size: Size<Pixels>);
    /// Return device pixels per logical pixel (for example, `2.0` on a 2× display).
    fn scale_factor(&self) -> f32;
    /// Return the effective light/dark appearance for this window.
    fn appearance(&self) -> WindowAppearance;
    /// Return the display currently containing this window.
    fn display(&self) -> Option<Rc<dyn PlatformDisplay>>;
    /// Return the current pointer position relative to the window's content origin, in logical pixels.
    fn mouse_position(&self) -> Point<Pixels>;
    /// Return current modifier key state.
    fn modifiers(&self) -> Modifiers;
    /// Return current Caps Lock state.
    fn capslock(&self) -> Capslock;
    /// Install the focused input handler, replacing any previous handler.
    fn set_input_handler(&mut self, input_handler: PlatformInputHandler);
    /// Remove and return the focused input handler, if present.
    fn take_input_handler(&mut self) -> Option<PlatformInputHandler>;
    /// Apply the focused text region's [`TextInputConfiguration`] to the
    /// platform's text input session (e.g. attributes of the hidden editable
    /// element on web). Called only when the configuration changes, because
    /// reconfiguring a live input session can restart the IME connection.
    fn set_text_input_configuration(&mut self, _configuration: TextInputConfiguration) {}
    /// Show a native prompt and return the selected answer's zero-based index.
    /// Return `None` when this backend cannot show native prompts.
    fn prompt(
        &self,
        level: PromptLevel,
        msg: &str,
        detail: Option<&str>,
        answers: &[PromptButton],
    ) -> Option<oneshot::Receiver<usize>>;
    /// Request activation, optionally using an externally supplied token.
    /// Returns whether a request was sent, not whether focus was granted.
    fn activate(&self, token: Option<&str>) -> bool;
    /// Requests that the operating system draw attention to this window.
    fn request_attention(&self) {}
    /// Report whether this window is the active native window.
    fn is_active(&self) -> bool;
    /// Report whether the pointer is currently over this window.
    fn is_hovered(&self) -> bool;
    /// Return the window background mode used by the compositor.
    fn background_appearance(&self) -> WindowBackgroundAppearance;
    /// Set the native title text.
    fn set_title(&mut self, title: &str);
    /// Set the native/compositor background mode.
    fn set_background_appearance(&self, background_appearance: WindowBackgroundAppearance);
    /// Show or hide the window without explicitly requesting focus.
    ///
    /// The default implementation does nothing for platforms that do not support
    /// changing window visibility at runtime.
    fn set_visible(&self, _visible: bool) {}
    /// Returns native visibility when the platform can report it.
    fn is_visible(&self) -> Option<bool> {
        None
    }
    /// Minimize the native window.
    fn minimize(&self);
    /// Request native zoom/maximize behavior.
    fn zoom(&self);
    /// Toggle native fullscreen mode.
    fn toggle_fullscreen(&self);
    /// Report native fullscreen state.
    fn is_fullscreen(&self) -> bool;
    /// A callback that wakes frame scheduling, if the backend exposes one.
    fn frame_waker(&self) -> Option<Rc<dyn Fn()>> {
        None
    }
    /// Install the callback invoked when the platform requests a frame.
    fn on_request_frame(&self, callback: Box<dyn FnMut(RequestFrameOptions)>);
    /// Install the callback that routes native input into GPUI.
    ///
    /// The returned [`DispatchEventResult`] tells the backend whether GPUI stopped propagation or
    /// prevented the platform default for this event.
    fn on_input(&self, callback: Box<dyn FnMut(PlatformInput) -> DispatchEventResult>);
    /// Install the callback for native activation changes.
    fn on_active_status_change(&self, callback: Box<dyn FnMut(bool)>);
    /// Install the callback for the pointer entering or leaving the window.
    fn on_hover_status_change(&self, callback: Box<dyn FnMut(bool)>);
    /// Install the callback for content-size or scale-factor changes.
    ///
    /// The size is in logical pixels and the scale factor is device pixels per logical pixel.
    fn on_resize(&self, callback: Box<dyn FnMut(Size<Pixels>, f32)>);
    /// Install the callback for window-position changes.
    fn on_moved(&self, callback: Box<dyn FnMut()>);
    /// Install the close-request callback; `false` vetoes closing the window.
    fn on_should_close(&self, callback: Box<dyn FnMut() -> bool>);
    /// Install hit testing for controls supplied by a custom titlebar.
    fn on_hit_test_window_control(&self, callback: Box<dyn FnMut() -> Option<WindowControlArea>>);
    /// Install the callback invoked once the native window closes.
    fn on_close(&self, callback: Box<dyn FnOnce()>);
    /// Install the callback for changes to the window's effective appearance.
    fn on_appearance_changed(&self, callback: Box<dyn FnMut()>);
    /// Install the callback for native titlebar-button layout changes.
    fn on_button_layout_changed(&self, _callback: Box<dyn FnMut()>) {}
    /// Submit a device-scaled scene to the native renderer for this window.
    fn draw(&self, scene: &Scene);
    /// Ask the backend to schedule its next presentation frame.
    fn schedule_frame(&self) {}
    /// Return the glyph/image atlas used by this window's renderer.
    fn sprite_atlas(&self) -> Arc<dyn PlatformAtlas>;
    /// Report whether the backend can use subpixel glyph rendering.
    fn is_subpixel_rendering_supported(&self) -> bool;

    // macOS specific methods
    /// Read the native title, or an empty string when unsupported.
    fn get_title(&self) -> String {
        String::new()
    }
    /// Enumerate windows in this window's native tab group, if supported.
    fn tabbed_windows(&self) -> Option<Vec<SystemWindowTab>> {
        None
    }
    /// Whether the native tab bar is visible.
    fn tab_bar_visible(&self) -> bool {
        false
    }
    /// Set the document's edited indicator in native window chrome.
    fn set_edited(&mut self, _edited: bool) {}
    /// Associate a document path with the window, or clear it with `None`.
    fn set_document_path(&self, _path: Option<&std::path::Path>) {}
    /// Toggle fullscreen without moving the window to a dedicated macOS Space.
    fn toggle_simple_fullscreen(&self) {}
    /// Whether the window is in that simple fullscreen mode.
    fn is_simple_fullscreen(&self) -> bool {
        false
    }
    #[cfg(target_os = "macos")]
    /// Position native titlebar buttons in logical window coordinates.
    fn set_traffic_light_position(&self, _position: Point<Pixels>) {}
    /// Show the platform character palette.
    ///
    /// The default implementation logs a warning when the backend does not
    /// support showing a character palette.
    fn show_character_palette(&self) {
        log::warn!("show_character_palette is not implemented by this platform backend");
    }
    /// Apply the system preference for double-clicking a titlebar.
    fn titlebar_double_click(&self, _is_resizable: bool, _is_minimizable: bool) {}
    /// Install the callback for moving the selected native tab to a new window.
    fn on_move_tab_to_new_window(&self, _callback: Box<dyn FnMut()>) {}
    /// Install the callback for merging native windows into a tab group.
    fn on_merge_all_windows(&self, _callback: Box<dyn FnMut()>) {}
    /// Install the callback for selecting the previous native tab.
    fn on_select_previous_tab(&self, _callback: Box<dyn FnMut()>) {}
    /// Install the callback for selecting the next native tab.
    fn on_select_next_tab(&self, _callback: Box<dyn FnMut()>) {}
    /// Install the callback for toggling the native tab bar.
    fn on_toggle_tab_bar(&self, _callback: Box<dyn FnMut()>) {}
    /// Merge compatible native windows into this window's tab group.
    fn merge_all_windows(&self) {}
    /// Detach this native tab into its own window.
    fn move_tab_to_new_window(&self) {}
    /// Toggle the native overview of window tabs.
    fn toggle_window_tab_overview(&self) {}
    /// Set the identifier used to group compatible native window tabs.
    fn set_tabbing_identifier(&self, _identifier: Option<String>) {}

    #[cfg(target_os = "windows")]
    /// Return the Win32 window handle owned by this backend.
    fn get_raw_handle(&self) -> windows::Win32::Foundation::HWND;

    // Linux specific methods
    /// Return bounds excluding client-side decorations, where applicable.
    fn inner_window_bounds(&self) -> WindowBounds {
        self.window_bounds()
    }
    /// Request client- or server-side window decorations.
    fn request_decorations(&self, _decorations: WindowDecorations) {}
    /// Show the compositor's window menu at a logical window position.
    fn show_window_menu(&self, _position: Point<Pixels>) {}
    /// Begin an interactive window move using the current pointer gesture.
    fn start_window_move(&self) {}
    /// Whether this backend can initiate a drag into another application.
    fn can_start_external_drag(&self) -> bool {
        false
    }
    /// Start a native external drag; return whether the request was accepted.
    fn start_external_drag(&self, _payload: &ExternalDragPayload) -> bool {
        false
    }
    /// Begin an interactive resize from `edge` using the current pointer gesture.
    fn start_window_resize(&self, _edge: ResizeEdge) {}
    /// Reserve a logical-pixel region for a Wayland layer-shell surface.
    fn set_exclusive_zone(&self, _zone: Pixels) {}
    #[cfg(all(target_os = "linux", feature = "wayland"))]
    /// Select the edge from which a layer-shell exclusive zone is measured.
    fn set_exclusive_edge(&self, _edge: layer_shell::Anchor) {}
    /// Set pointer-input regions in logical window coordinates; `None` restores the whole surface.
    fn set_input_region(&self, _region: Option<&[Bounds<Pixels>]>) {}
    /// Report the effective decoration mode.
    fn window_decorations(&self) -> Decorations {
        Decorations::Server
    }
    /// Set the compositor's application identifier for this window.
    fn set_app_id(&mut self, _app_id: &str) {}
    /// Make an initially unmapped native window available to the compositor.
    fn map_window(&mut self) -> anyhow::Result<()> {
        Ok(())
    }
    /// Report which native window controls are available.
    fn window_controls(&self) -> WindowControls {
        WindowControls::default()
    }
    /// Set the inset occupied by client-side window decorations.
    fn set_client_inset(&self, _inset: Pixels) {}
    /// Describe the GPU selected by this window's renderer, if available.
    fn gpu_specs(&self) -> Option<GpuSpecs>;

    /// Returns the GPU context for this window's renderer.
    /// The returned `Box` contains `(Arc<wgpu::Device>, Arc<wgpu::Queue>)`.
    #[cfg(any(
        target_os = "linux",
        target_os = "freebsd",
        target_os = "windows",
        target_os = "macos"
    ))]
    fn gpu_context(&self) -> Option<Box<dyn std::any::Any>> {
        None
    }

    /// Returns typed backend-specific GPU context information for custom
    /// controls. The value is intentionally type-erased in this crate so the
    /// core UI crate does not depend on a rendering backend.
    #[cfg(any(
        target_family = "wasm",
        target_os = "linux",
        target_os = "freebsd",
        target_os = "macos"
    ))]
    fn gpu_context_info(&self) -> Option<Box<dyn std::any::Any>> {
        None
    }

    /// Whether this window's GPU device has been lost (the platform renderer
    /// recovers it on a subsequent draw). `None` when the backend cannot
    /// know. Safe to call mid-recovery, unlike `gpu_context`. Embedders that
    /// captured the device from `gpu_context` should stop submitting while
    /// this is `Some(true)` and re-acquire the device once it reads
    /// `Some(false)` again.
    #[cfg(any(
        target_os = "linux",
        target_os = "freebsd",
        target_os = "windows",
        target_os = "macos"
    ))]
    fn gpu_device_lost(&self) -> Option<bool> {
        None
    }

    /// Position the native IME candidate window near logical window-local bounds.
    ///
    /// The bounds come from [`InputHandler::bounds_for_range`]. They are in the
    /// same coordinate space as element layout, with an origin at the window's
    /// content area; the backend converts them to native device or surface
    /// coordinates as needed. GPUI supplies caret bounds during composition and
    /// uses the active selection endpoint otherwise.
    fn update_ime_position(&self, _bounds: Bounds<Pixels>);

    // Mobile platform methods.

    /// The regions of this window currently obscured or reserved by the
    /// system. Zero on platforms without such regions.
    fn insets(&self) -> WindowInsets {
        WindowInsets::default()
    }

    /// Registers a callback invoked whenever [`Self::insets`] change.
    ///
    /// Contract: fires continuously during animated transitions (Android
    /// `WindowInsetsAnimation` progress; on iOS the platform interpolates
    /// the keyboard animation curve on frame ticks) and is exact at rest.
    fn on_insets_changed(&self, _callback: Box<dyn FnMut(WindowInsets)>) {}

    /// Sets the handler for the system back action (Android back
    /// button/gesture; no source on iOS or desktop).
    fn set_back_handler(&self, _callback: Box<dyn FnMut()>) {}

    /// Declares whether the application would currently handle the system
    /// back action (e.g. navigation depth > 0).
    fn set_back_enabled(&self, _enabled: bool) {}

    /// Requests that the soft keyboard be shown.
    fn show_soft_keyboard(&self) {}

    /// Requests that the soft keyboard be hidden.
    fn hide_soft_keyboard(&self) {}

    /// Inform the operating system that the text input state has changed
    fn text_input_state_changed(&self, _change: TextInputStateChange) {}

    /// Request the user's configured system alert sound, where supported.
    fn play_system_bell(&self) {}

    /// Initialize the accessibility adapter with callbacks.
    fn a11y_init(&self, _callbacks: A11yCallbacks) {}

    /// Provide a TreeUpdate to the accessibility adapter.
    fn a11y_tree_update(&self, _tree_update: accesskit::TreeUpdate) {}

    /// Inform the adapter of updated window bounds.
    fn a11y_update_window_bounds(&self) {}

    #[cfg(any(test, feature = "headless", feature = "bench-support"))]
    /// Expose a test window when this native peer is backed by GPUI's test platform.
    fn as_test(&mut self) -> Option<&mut TestWindow> {
        None
    }

    /// Renders the given scene to a texture and returns the pixel data as an RGBA image.
    /// This does not present the frame to screen - useful for visual testing where we want
    /// to capture what would be rendered without displaying it or requiring the window to be visible.
    #[cfg(any(test, feature = "headless"))]
    fn render_to_image(&self, _scene: &Scene) -> Result<RgbaImage> {
        anyhow::bail!("render_to_image not implemented for this platform")
    }
}

/// A renderer for headless windows that can produce real rendered output.
#[cfg(any(test, feature = "headless", feature = "bench-support"))]
pub trait PlatformHeadlessRenderer {
    /// Render a scene and return the result as an RGBA image.
    fn render_scene_to_image(
        &mut self,
        scene: &Scene,
        size: Size<DevicePixels>,
    ) -> Result<RgbaImage>;

    /// Render a scene to an offscreen target without reading the result back.
    ///
    /// This is the headless analogue of presenting a frame: it performs the
    /// same CPU-side scene encoding and GPU submission as drawing to a real
    /// window, but doesn't block on GPU completion or copy pixels back.
    fn render_scene(&mut self, scene: &Scene, size: Size<DevicePixels>) -> Result<()>;

    /// Returns the sprite atlas used by this renderer.
    fn sprite_atlas(&self) -> Arc<dyn PlatformAtlas>;
}

/// Type alias for runnables with metadata.
/// Previously an enum with a single variant, now simplified to a direct type alias.
#[doc(hidden)]
pub type RunnableVariant = Runnable<RunnableMeta>;

#[doc(hidden)]
pub type TimerResolutionGuard = gpui_util::Deferred<Box<dyn FnOnce() + Send>>;

#[doc(hidden)]
pub enum TasksIncluded {
    OnlyCompleted,
    CompletedAndRunning,
}

/// This type is public so that our test macro can generate and use it, but it should not
/// be considered part of our public API.
#[doc(hidden)]
pub trait PlatformDispatcher: Send + Sync {
    fn is_main_thread(&self) -> bool;
    fn dispatch(&self, runnable: RunnableVariant, priority: Priority);
    fn dispatch_on_main_thread(&self, runnable: RunnableVariant, priority: Priority);
    fn dispatch_after(&self, duration: Duration, runnable: RunnableVariant);

    fn dispatch_on_main_thread_when_idle(
        &self,
        runnable: RunnableVariant,
        timeout: Option<Duration>,
    ) {
        let _ = timeout;
        self.dispatch_on_main_thread(runnable, Priority::Low);
    }

    fn idle_time_remaining(&self) -> Option<Duration> {
        None
    }

    fn spawn_realtime(&self, f: Box<dyn FnOnce() + Send>);

    fn now(&self) -> Instant {
        Instant::now()
    }

    fn increase_timer_resolution(&self) -> TimerResolutionGuard {
        gpui_util::defer(Box::new(|| {}))
    }

    #[cfg(any(test, feature = "headless", feature = "bench-support"))]
    fn as_test(&self) -> Option<&TestDispatcher> {
        None
    }

    // This cfg must match the `threaded_dispatcher` module's, which implements
    // this method whenever it compiles.
    #[cfg(any(test, feature = "headless", feature = "bench-support"))]
    fn as_threaded(&self) -> Option<&ThreadedDispatcher> {
        None
    }
}

/// Font discovery, shaping, and glyph rasterization supplied by a platform backend.
///
/// Unlike native window services, this trait is thread-safe. Font identifiers
/// belong to this text system; layout and rasterization must resolve them against
/// the same font collection. Bump [`Self::font_generation`] when that collection
/// changes so callers can invalidate cached layout.
pub trait PlatformTextSystem: Send + Sync {
    /// Add font files from owned or static bytes; reject files the backend cannot load.
    fn add_fonts(&self, fonts: Vec<Cow<'static, [u8]>>) -> Result<()>;
    /// Enumerate the family names available to this backend.
    ///
    /// A family can contain several faces. Use [`Self::font_id`] to resolve a
    /// descriptor with a particular weight, style, and feature configuration.
    fn all_font_names(&self) -> Vec<String>;
    /// Version of the font collection used to invalidate cached layout.
    ///
    /// Backends with a mutable collection must change this value after adding
    /// fonts. The default constant is suitable only for an immutable collection.
    fn font_generation(&self) -> u64 {
        0
    }
    /// Resolve a descriptor to a font identity owned by this text system.
    ///
    /// Return an error when the backend cannot resolve a face. A resolved face
    /// need not contain every character; shaping can select fallback faces.
    fn font_id(&self, descriptor: &Font) -> Result<FontId>;
    /// Prewarm any system font caches needed to shape text.
    fn prewarm_fonts(&self, _font_ids: &[FontId]) {}
    /// Read metrics in font design units for a previously resolved font.
    ///
    /// The ID must belong to this text system. Implementations may panic for
    /// an unknown ID; this method has no error return. Scale distances by
    /// `font_size / units_per_em` when converting them to logical pixels.
    fn font_metrics(&self, font_id: FontId) -> FontMetrics;
    /// Read a glyph's bounds in font design units, or report a backend error.
    ///
    /// These are font-relative bounds, not a positioned text-layout rectangle
    /// or a raster bitmap's device-pixel bounds. An empty glyph can have empty
    /// bounds and a nonzero advance.
    fn typographic_bounds(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Bounds<f32>>;
    /// Read a glyph's isolated advance in font design units.
    ///
    /// This does not apply contextual shaping, kerning, or ligatures. Measure
    /// a string with [`Self::layout_text`] rather than summing these advances.
    fn advance(&self, font_id: FontId, glyph_id: GlyphId) -> Result<Size<f32>>;
    /// Map one Unicode scalar to a nominal glyph in this face, if present.
    ///
    /// This does not search fallback fonts or shape a sequence of scalars.
    fn glyph_for_char(&self, font_id: FontId, ch: char) -> Option<GlyphId>;
    /// Rasterize a glyph into device-pixel bounds and bitmap data.
    ///
    /// The returned bounds position the bitmap relative to the glyph origin;
    /// [`PlatformAtlas`] allocates its texture tile separately. Return an error
    /// if the font, glyph, or requested raster settings cannot be rendered.
    fn rasterize_glyph(&self, params: &RenderGlyphParams) -> Result<RasterizedGlyph>;
    /// Optionally prepares a lazy batch for subsequent ordinary glyph painting.
    /// The default does not consume the iterator or allocate. A platform bridge
    /// can batch expensive transport while keeping rasterization semantics intact.
    fn prewarm_glyphs(&self, _requests: &mut dyn Iterator<Item = GlyphRasterRequest>) {}
    /// Normalizes the render settings that affect cached glyph pixels.
    fn prepare_raster_style(&self, request: RasterStyleRequest) -> PreparedRasterStyle {
        PreparedRasterStyle::independent(request.requested_mode)
    }
    /// Layout one complete text document, including hard breaks and optional wrapping.
    fn layout_text(&self, request: TextLayoutRequest<'_>) -> LineLayout;
    /// Layout one complete text document containing atomic element boxes.
    fn layout_inline(&self, request: InlineLayoutRequest<'_>) -> InlineLayout;
    /// Returns the recommended text rendering mode for the given font and size.
    fn recommended_rendering_mode(
        &self,
        _font_id: FontId,
        _font_size: Pixels,
    ) -> TextRenderingMode {
        TextRenderingMode::Subpixel
    }
}

#[cfg(any(test, feature = "headless"))]
mod tests {
    use crate::{
        Bounds, CaretAffinity, CaretMovement, CaretPosition, Font, FontId, FontMetrics, GlyphId,
        InlineLayout, InlineLayoutRequest, InlineVisualLine, LineLayout, PaintFragment, PaintStyle,
        Pixels, PlatformTextLayout, PlatformTextSystem, Point, PositionedInlineBox,
        RasterizedGlyph, RasterizedGlyphFormat, RenderGlyphParams, ResolvedDirection, ShapedGlyph,
        Size, TextAlign, TextBoundary, TextDirection, TextLayoutRequest, TextMovement,
        TextRenderingMode, TextSelectionKind, VisualDirection, VisualLine, align_inline_boxes,
        point, px, size,
    };
    use anyhow::Result;
    use std::{borrow::Cow, ops::Range, sync::Arc};

    /// A deterministic text system for tests that do not need real font shaping.
    ///
    /// Every UTF-16 code unit has the same advance, all text occupies one visual
    /// line, and rasterization produces no bitmap. Use a real platform text
    /// system for wrapping, bidirectional text, font fallback, or pixel comparisons.
    pub struct TestTextSystem;

    #[derive(Debug)]
    /// A deterministic test layout with exactly one visual and hard line.
    struct TestPlatformTextLayout {
        /// Source text.
        text: String,
        /// Ordered (byte index, x position) caret stops.
        stops: Vec<(usize, Pixels)>,
        /// Size of the single visual line.
        size: Size<Pixels>,
    }

    impl TestPlatformTextLayout {
        fn caret_stop(&self, byte_offset: usize) -> (usize, Pixels) {
            let stop_index = self
                .stops
                .partition_point(|(index, _position)| *index <= byte_offset)
                .saturating_sub(1);

            self.stops[stop_index]
        }
    }

    impl PlatformTextLayout for TestPlatformTextLayout {
        fn len(&self) -> usize {
            self.stops.last().map_or(0, |(index, _)| *index)
        }

        fn line_count(&self) -> usize {
            // This test layout deliberately reports its single visual line.
            1
        }

        fn size(&self) -> Size<Pixels> {
            self.size
        }

        fn byte_index_from_pixel_point(
            &self,
            pixel_point: Point<Pixels>,
            line_height: Pixels,
        ) -> Result<usize, usize> {
            let closest = self
                .caret_from_pixel_point(pixel_point, line_height)
                .unwrap_or_else(|caret| caret)
                .index;
            self.stops
                .windows(2)
                .find_map(|stops| {
                    let [(start_index, start_x), (_end_index, end_x)] = stops else {
                        return None;
                    };

                    (pixel_point.x >= *start_x && pixel_point.x < *end_x)
                        .then_some(Ok(*start_index))
                })
                .unwrap_or(Err(closest))
        }

        fn caret_from_pixel_point(
            &self,
            pixel_point: Point<Pixels>,
            line_height: Pixels,
        ) -> Result<CaretPosition, CaretPosition> {
            let index = self
                .stops
                .iter()
                .min_by(|(_, left), (_, right)| {
                    (f32::from(*left) - f32::from(pixel_point.x))
                        .abs()
                        .total_cmp(&(f32::from(*right) - f32::from(pixel_point.x)).abs())
                })
                .map_or(0, |(index, _)| *index);
            let caret = self.normalized_caret(CaretPosition {
                index,
                affinity: CaretAffinity::Downstream,
            });

            if pixel_point.y >= Pixels::ZERO
                && pixel_point.y < line_height
                && pixel_point.x >= Pixels::ZERO
                && pixel_point.x < self.size.width
            {
                Ok(caret)
            } else {
                Err(caret)
            }
        }

        fn caret_bounds(
            &self,
            caret: CaretPosition,
            line_height: Pixels,
        ) -> Option<Bounds<Pixels>> {
            let caret = self.normalized_caret(caret);
            let (_index, position) = self.caret_stop(caret.index);

            Some(Bounds::new(
                point(position, Pixels::ZERO),
                size(Pixels::ZERO, line_height),
            ))
        }

        fn normalized_caret(&self, caret: CaretPosition) -> CaretPosition {
            let (index, _position) = self.caret_stop(caret.index);
            let affinity = if index == self.len() && index != 0 {
                CaretAffinity::Upstream
            } else {
                caret.affinity
            };

            CaretPosition { index, affinity }
        }

        fn adjacent_visual_caret(
            &self,
            caret: CaretPosition,
            direction: VisualDirection,
        ) -> Option<CaretPosition> {
            let caret = self.normalized_caret(caret);
            let position = self
                .stops
                .iter()
                .position(|(index, _)| *index == caret.index)?;
            let position = match direction {
                VisualDirection::Left => position.checked_sub(1)?,
                VisualDirection::Right => position.checked_add(1)?,
            };

            let index = self.stops.get(position)?.0;
            Some(self.normalized_caret(CaretPosition {
                index,
                affinity: CaretAffinity::Downstream,
            }))
        }

        fn selection_bounds(
            &self,
            byte_range: Range<usize>,
            line_height: Pixels,
        ) -> Vec<Bounds<Pixels>> {
            if byte_range.is_empty() {
                return Vec::new();
            }

            let (_start_index, start) = self.caret_stop(byte_range.start);
            let (_end_index, end) = self.caret_stop(byte_range.end);

            // The platform contract returns one bound per visual line. Since this test
            // layout has exactly one visual line, every non-empty selection has one bound.
            vec![Bounds::from_corners(
                point(start.min(end), Pixels::ZERO),
                point(start.max(end), line_height),
            )]
        }

        fn logical_cluster_before(&self, caret: CaretPosition) -> Option<Range<usize>> {
            self.stops
                .windows(2)
                .rev()
                .find(|stops| stops[1].0 <= caret.index)
                .map(|stops| stops[0].0..stops[1].0)
        }

        fn logical_cluster_after(&self, caret: CaretPosition) -> Option<Range<usize>> {
            self.stops
                .windows(2)
                .find(|stops| stops[0].0 >= caret.index)
                .map(|stops| stops[0].0..stops[1].0)
        }

        fn caret_movement(
            &self,
            caret: CaretPosition,
            movement: TextMovement,
            vertical_navigation_x: Option<Pixels>,
        ) -> CaretMovement {
            use TextBoundary::*;
            use TextDirection::*;

            let index = match (movement.direction, movement.boundary) {
                (Left, Cluster) => {
                    self.adjacent_visual_caret(caret, VisualDirection::Left)
                        .unwrap_or(caret)
                        .index
                }
                (Right, Cluster) => {
                    self.adjacent_visual_caret(caret, VisualDirection::Right)
                        .unwrap_or(caret)
                        .index
                }
                (Left, Word) => {
                    let prefix = &self.text[..caret.index.min(self.text.len())];
                    let trimmed = prefix.trim_end_matches(char::is_whitespace);
                    trimmed.rfind(char::is_whitespace).map_or(0, |index| {
                        index + trimmed[index..].chars().next().unwrap().len_utf8()
                    })
                }
                (Right, Word) => {
                    let start = caret.index.min(self.text.len());
                    let suffix = &self.text[start..];
                    let word_end = suffix.find(char::is_whitespace).unwrap_or(suffix.len());
                    let rest = &suffix[word_end..];
                    start
                        + word_end
                        + rest
                            .find(|character: char| !character.is_whitespace())
                            .unwrap_or(rest.len())
                }
                // This test layout has one visual and hard line. Without wrapping or
                // additional hard lines, these movements resolve to the document endpoints.
                (Up | Start, VisualLine) | (Start, HardLine | Document) => 0,
                (Down | End, VisualLine) | (End, HardLine | Document) => self.len(),
                _ => caret.index,
            };

            let vertical_navigation_x =
                matches!(movement.direction, TextDirection::Up | TextDirection::Down).then(|| {
                    vertical_navigation_x.unwrap_or_else(|| {
                        self.caret_bounds(caret, self.size.height)
                            .map_or(Pixels::ZERO, |bounds| bounds.origin.x)
                    })
                });

            CaretMovement {
                result: self.normalized_caret(CaretPosition {
                    index,
                    affinity: CaretAffinity::Downstream,
                }),
                vertical_navigation_x,
            }
        }

        fn selection_from_pixel_point(
            &self,
            pixel_point: Point<Pixels>,
            line_height: Pixels,
            kind: TextSelectionKind,
        ) -> Range<usize> {
            if !matches!(kind, TextSelectionKind::Word) {
                return 0..self.len();
            }

            let index = self
                .caret_from_pixel_point(pixel_point, line_height)
                .unwrap_or_else(|caret| caret)
                .index
                .min(self.text.len());
            let start = self.text[..index]
                .rfind(char::is_whitespace)
                .map_or(0, |offset| {
                    offset + self.text[offset..].chars().next().unwrap().len_utf8()
                });
            let end = self.text[index..]
                .find(char::is_whitespace)
                .map_or(self.text.len(), |offset| index + offset);
            start..end
        }
    }

    impl TestTextSystem {
        #[allow(dead_code)]
        /// Construct the stateless test text system.
        pub fn new() -> Self {
            Self
        }

        fn em_width(&self, font_size: Pixels) -> Pixels {
            let metrics = self.font_metrics(FontId(0));
            let advance = self
                .advance(FontId(0), self.glyph_for_char(FontId(0), 'm').unwrap())
                .unwrap();

            font_size * advance.width / metrics.units_per_em as f32
        }
    }

    fn position_test_inline_boxes(
        request: InlineLayoutRequest<'_>,
        em_width: Pixels,
        baseline: Pixels,
    ) -> Vec<PositionedInlineBox> {
        let mut preceding_width = Pixels::ZERO;
        request
            .boxes
            .iter()
            .map(|inline_box| {
                let text_width = em_width
                    * request.text[..inline_box.index]
                        .chars()
                        .map(|character| character.len_utf16() as f32)
                        .sum::<f32>();
                let positioned = PositionedInlineBox {
                    id: inline_box.id,
                    line_index: 0,
                    bounds: Bounds::new(
                        point(
                            text_width + preceding_width,
                            baseline - inline_box.size.height,
                        ),
                        inline_box.size,
                    ),
                };

                preceding_width += inline_box.size.width;
                positioned
            })
            .collect()
    }

    fn add_test_inline_box_advances(layout: &mut LineLayout, request: InlineLayoutRequest<'_>) {
        for fragment in &mut layout.paint_fragments {
            // This layout owns its freshly built glyphs. If they become shared,
            // make_mut copies the slice before changing their positions.
            for (glyph, (index, _)) in Arc::make_mut(&mut fragment.glyphs)
                .iter_mut()
                .zip(request.text.char_indices())
            {
                glyph.position.x += request
                    .boxes
                    .iter()
                    .filter(|inline_box| inline_box.index <= index)
                    .map(|inline_box| inline_box.size.width)
                    .sum::<Pixels>();
            }
        }

        let box_width = request
            .boxes
            .iter()
            .map(|inline_box| inline_box.size.width)
            .sum::<Pixels>();
        for fragment in &mut layout.paint_fragments {
            fragment.x_range.end += box_width;
        }

        layout.width += box_width;

        if let Some(line) = layout.visual_lines.first_mut() {
            line.advance_width += box_width;
        }
    }

    impl PlatformTextSystem for TestTextSystem {
        fn add_fonts(&self, _fonts: Vec<Cow<'static, [u8]>>) -> Result<()> {
            Ok(())
        }

        fn all_font_names(&self) -> Vec<String> {
            Vec::new()
        }

        fn font_id(&self, _descriptor: &Font) -> Result<FontId> {
            Ok(FontId(1))
        }

        fn font_metrics(&self, _font_id: FontId) -> FontMetrics {
            FontMetrics {
                units_per_em: 1000,
                ascent: 1025.0,
                descent: -275.0,
                line_gap: 0.0,
                underline_position: -95.0,
                underline_thickness: 60.0,
                cap_height: 698.0,
                x_height: 516.0,
                bounding_box: Bounds {
                    origin: Point {
                        x: -260.0,
                        y: -245.0,
                    },
                    size: Size {
                        width: 1501.0,
                        height: 1364.0,
                    },
                },
            }
        }

        fn typographic_bounds(&self, _font_id: FontId, _glyph_id: GlyphId) -> Result<Bounds<f32>> {
            Ok(Bounds {
                origin: Point { x: 54.0, y: 0.0 },
                size: size(392.0, 528.0),
            })
        }

        fn advance(&self, _font_id: FontId, glyph_id: GlyphId) -> Result<Size<f32>> {
            Ok(size(600.0 * glyph_id.0 as f32, 0.0))
        }

        fn glyph_for_char(&self, _font_id: FontId, ch: char) -> Option<GlyphId> {
            Some(GlyphId(ch.len_utf16() as u32))
        }

        fn rasterize_glyph(&self, _params: &RenderGlyphParams) -> Result<RasterizedGlyph> {
            Ok(RasterizedGlyph {
                bounds: Default::default(),
                size: Default::default(),
                format: RasterizedGlyphFormat::AlphaMask,
                pixels: Vec::new(),
            })
        }

        fn layout_text(&self, request: TextLayoutRequest<'_>) -> LineLayout {
            let text = request.text;
            let font_size = request.font_size;
            let shaping_runs = request.runs;
            let mut position = px(0.);
            let metrics = self.font_metrics(FontId(0));
            let em_width = self.em_width(font_size);
            let mut glyphs = Vec::new();
            let mut stops = vec![(0, Pixels::ZERO)];

            for (idx, character) in text.char_indices() {
                let glyph_id = GlyphId(character.len_utf16() as u32);
                glyphs.push(ShapedGlyph {
                    id: glyph_id,
                    position: point(position, Pixels::ZERO),
                    is_emoji: glyph_id.0 == 2,
                });

                position += em_width * glyph_id.0 as f32;
                stops.push((idx + character.len_utf8(), position));
            }

            let mut tracking = px(0.);
            let mut tracking_covered = 0usize;
            for run in shaping_runs {
                let start = tracking_covered.min(text.len());
                let end = start.saturating_add(run.len).min(text.len()).max(start);
                let slice = text.get(start..end).unwrap_or("");
                let n = slice.chars().count();
                if n > 1 {
                    if let Some(spacing) = run.letter_spacing {
                        tracking += spacing * (n - 1) as f32;
                    }
                }
                tracking_covered = end;
            }

            let direction = match request.options.direction {
                crate::ParagraphDirection::LeftToRight => ResolvedDirection::LeftToRight,
                crate::ParagraphDirection::RightToLeft => ResolvedDirection::RightToLeft,
                crate::ParagraphDirection::Auto => {
                    ResolvedDirection::from_first_strong(text).unwrap_or_default()
                }
            };
            let advance = position + tracking;
            let alignment_width = request.options.alignment_width.unwrap_or(advance);
            let offset = match request.options.text_align {
                TextAlign::Start if direction.is_rtl() => alignment_width - advance,
                TextAlign::Start | TextAlign::Left => Pixels::ZERO,
                TextAlign::Center => (alignment_width - advance) / 2.0,
                TextAlign::End if direction.is_rtl() => Pixels::ZERO,
                TextAlign::End | TextAlign::Right => alignment_width - advance,
            };

            for (_idx, position) in &mut stops {
                *position += offset;
            }

            let visual_lines = [VisualLine {
                text_range: 0..text.len(),
                paint_fragment_range: 0..usize::from(!glyphs.is_empty()),
                advance_width: advance,
                offset,
                direction,
            }]
            .into_iter()
            .collect();
            let paint_fragments = (!glyphs.is_empty())
                .then(|| PaintFragment {
                    source_run: 0,
                    font_id: FontId(0),
                    font_size,
                    glyphs: glyphs.into(),
                    x_range: Pixels::ZERO..advance,
                    style: shaping_runs
                        .first()
                        .map_or_else(PaintStyle::default, PaintStyle::from),
                    underline_offset: Some(font_size * 0.1),
                    strikethrough_offset: Some(-font_size * 0.3),
                })
                .into_iter()
                .collect();
            LineLayout {
                font_size,
                width: advance,
                ascent: font_size * (metrics.ascent / metrics.units_per_em as f32),
                descent: font_size * (metrics.descent / metrics.units_per_em as f32),
                visual_lines,
                paint_fragments,
                len: text.len(),
                platform_layout: Arc::new(TestPlatformTextLayout {
                    text: text.to_owned(),
                    stops,
                    size: size(advance, font_size),
                }),
            }
        }

        fn layout_inline(&self, request: InlineLayoutRequest<'_>) -> InlineLayout {
            let mut layout = self.layout_text(TextLayoutRequest {
                text: request.text,
                font_size: request.font_size,
                runs: request.runs,
                options: request.options,
            });

            let em_width = self.em_width(request.font_size);
            let baseline = request
                .boxes
                .iter()
                .map(|inline_box| inline_box.size.height)
                .fold(request.line_height, Pixels::max);
            let positioned_boxes = position_test_inline_boxes(request, em_width, baseline);
            add_test_inline_box_advances(&mut layout, request);
            let line_width = request
                .options
                .wrap_width
                .unwrap_or(Pixels::MAX)
                .min(layout.width);
            let line_offset = layout.visual_lines[0].offset;
            let mut inline = InlineLayout {
                size: size(layout.width, baseline),
                layout: Arc::new(layout),
                lines: [InlineVisualLine {
                    origin: point(line_offset, Pixels::ZERO),
                    size: size(line_width, baseline),
                    baseline,
                }]
                .into_iter()
                .collect(),
                boxes: positioned_boxes,
                alignment_offset: Pixels::ZERO,
            };

            align_inline_boxes(
                &mut inline.lines,
                &mut inline.boxes,
                &mut inline.size,
                request.boxes,
                &[request.text_metrics],
                &[],
                request.text_metrics,
                request.line_height,
            );
            inline
        }

        fn recommended_rendering_mode(
            &self,
            _font_id: FontId,
            _font_size: Pixels,
        ) -> TextRenderingMode {
            TextRenderingMode::Grayscale
        }
    }
}

// Adapted from https://github.com/microsoft/terminal/blob/1283c0f5b99a2961673249fa77c6b986efb5086c/src/renderer/atlas/dwrite.cpp
// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.
/// Compute gamma correction ratios for subpixel text rendering.
#[allow(dead_code)]
pub fn get_gamma_correction_ratios(gamma: f32) -> [f32; 4] {
    const GAMMA_INCORRECT_TARGET_RATIOS: [[f32; 4]; 13] = [
        [0.0000 / 4.0, 0.0000 / 4.0, 0.0000 / 4.0, 0.0000 / 4.0], // gamma = 1.0
        [0.0166 / 4.0, -0.0807 / 4.0, 0.2227 / 4.0, -0.0751 / 4.0], // gamma = 1.1
        [0.0350 / 4.0, -0.1760 / 4.0, 0.4325 / 4.0, -0.1370 / 4.0], // gamma = 1.2
        [0.0543 / 4.0, -0.2821 / 4.0, 0.6302 / 4.0, -0.1876 / 4.0], // gamma = 1.3
        [0.0739 / 4.0, -0.3963 / 4.0, 0.8167 / 4.0, -0.2287 / 4.0], // gamma = 1.4
        [0.0933 / 4.0, -0.5161 / 4.0, 0.9926 / 4.0, -0.2616 / 4.0], // gamma = 1.5
        [0.1121 / 4.0, -0.6395 / 4.0, 1.1588 / 4.0, -0.2877 / 4.0], // gamma = 1.6
        [0.1300 / 4.0, -0.7649 / 4.0, 1.3159 / 4.0, -0.3080 / 4.0], // gamma = 1.7
        [0.1469 / 4.0, -0.8911 / 4.0, 1.4644 / 4.0, -0.3234 / 4.0], // gamma = 1.8
        [0.1627 / 4.0, -1.0170 / 4.0, 1.6051 / 4.0, -0.3347 / 4.0], // gamma = 1.9
        [0.1773 / 4.0, -1.1420 / 4.0, 1.7385 / 4.0, -0.3426 / 4.0], // gamma = 2.0
        [0.1908 / 4.0, -1.2652 / 4.0, 1.8650 / 4.0, -0.3476 / 4.0], // gamma = 2.1
        [0.2031 / 4.0, -1.3864 / 4.0, 1.9851 / 4.0, -0.3501 / 4.0], // gamma = 2.2
    ];

    const NORM13: f32 = ((0x10000 as f64) / (255.0 * 255.0) * 4.0) as f32;
    const NORM24: f32 = ((0x100 as f64) / (255.0) * 4.0) as f32;

    let index = ((gamma * 10.0).round() as usize).clamp(10, 22) - 10;
    let ratios = GAMMA_INCORRECT_TARGET_RATIOS[index];

    [
        ratios[0] * NORM13,
        ratios[1] * NORM24,
        ratios[2] * NORM13,
        ratios[3] * NORM24,
    ]
}

/// Identifies bitmap content cached in a renderer's atlas.
///
/// Keys include the parameters that affect pixels. A key is meaningful to the
/// owning [`PlatformAtlas`]; it is not a portable GPU texture handle.
#[derive(PartialEq, Eq, Hash, Clone)]
pub enum AtlasKey {
    /// A portable scene resource imported into this window's atlas.
    Captured {
        /// Stable identity of the captured bitmap resource.
        resource: uuid::Uuid,
        /// Pixel format required by this resource.
        kind: AtlasTextureKind,
    },
    /// A glyph rasterized with these parameters and pixel format.
    Glyph {
        /// Font, glyph, scale, and raster settings that determine the bitmap.
        params: RenderGlyphParams,
        /// The bitmap's channel interpretation.
        format: RasterizedGlyphFormat,
    },
    /// An SVG rendered at the requested dimensions.
    Svg(RenderSvgParams),
    /// A decoded image frame at the requested scale.
    Image(RenderImageParams),
}

impl AtlasKey {
    #[cfg_attr(
        all(
            any(target_os = "linux", target_os = "freebsd"),
            not(any(feature = "x11", feature = "wayland"))
        ),
        allow(dead_code)
    )]
    /// Returns the texture kind for this atlas key.
    pub fn texture_kind(&self) -> AtlasTextureKind {
        match self {
            AtlasKey::Captured { kind, .. } => *kind,
            AtlasKey::Glyph { format, .. } => match format {
                RasterizedGlyphFormat::AlphaMask => AtlasTextureKind::Monochrome,
                RasterizedGlyphFormat::BgraSubpixelMask => AtlasTextureKind::Subpixel,
                RasterizedGlyphFormat::BgraColor => AtlasTextureKind::Polychrome,
            },
            AtlasKey::Svg(_) => AtlasTextureKind::Monochrome,
            AtlasKey::Image(_) => AtlasTextureKind::Polychrome,
        }
    }
}

impl From<(RenderGlyphParams, RasterizedGlyphFormat)> for AtlasKey {
    fn from((params, format): (RenderGlyphParams, RasterizedGlyphFormat)) -> Self {
        Self::Glyph { params, format }
    }
}

impl From<RenderSvgParams> for AtlasKey {
    fn from(params: RenderSvgParams) -> Self {
        Self::Svg(params)
    }
}

impl From<RenderImageParams> for AtlasKey {
    fn from(params: RenderImageParams) -> Self {
        Self::Image(params)
    }
}

#[doc(hidden)]
#[derive(Default)]
pub struct GlyphAtlasCache {
    entries: FxHashMap<RenderGlyphParams, GlyphAtlasEntry>,
}

impl GlyphAtlasCache {
    pub fn get(&self, params: &RenderGlyphParams) -> Option<GlyphAtlasEntry> {
        self.entries.get(params).copied()
    }

    pub fn insert(
        &mut self,
        params: &RenderGlyphParams,
        glyph: &RasterizedGlyph,
        tile: Option<AtlasTile>,
    ) -> GlyphAtlasEntry {
        let entry = GlyphAtlasEntry {
            tile,
            bounds: glyph.bounds,
            format: glyph.format,
        };
        self.entries.insert(params.clone(), entry);

        entry
    }

    pub fn remove(&mut self, key: &AtlasKey) {
        let AtlasKey::Glyph { params, format } = key else {
            return;
        };

        if self
            .entries
            .get(params)
            .is_some_and(|entry| entry.format == *format)
        {
            self.entries.remove(params);
        }
    }

    pub fn clear(&mut self) {
        self.entries.clear();
    }
}

/// A window renderer's cache of glyph, image, and SVG bitmap tiles.
///
/// Tiles refer to textures owned by this atlas. Do not transfer them between
/// windows; use a portable [`crate::SceneCapture`] to import scene resources.
pub trait PlatformAtlas {
    /// Look up `key`, calling `build` only on a cache miss.
    ///
    /// The builder supplies dimensions and tightly packed pixels in the key's
    /// texture format. `Ok(None)` means there is no bitmap to insert. Errors
    /// from decoding, validation, or allocation propagate to the caller.
    fn get_or_insert_with<'a>(
        &self,
        key: &AtlasKey,
        build: &mut dyn FnMut() -> Result<Option<(Size<DevicePixels>, Cow<'a, [u8]>)>>,
    ) -> Result<Option<AtlasTile>>;
    /// On a cache miss, `build` returns a validated glyph for atlas insertion.
    fn get_or_insert_glyph_with(
        &self,
        params: &RenderGlyphParams,
        build: &mut dyn FnMut() -> Result<ValidatedRasterizedGlyph>,
    ) -> Result<GlyphAtlasEntry>;
    /// Evict the bitmap associated with `key`, if present.
    fn remove(&self, key: &AtlasKey);

    #[cfg(any(test, feature = "headless", feature = "bench-support"))]
    /// Check residency when supported by the test backend; the default returns `false`.
    fn contains(&self, _key: &AtlasKey) -> bool {
        false
    }
}

#[doc(hidden)]
pub struct AtlasTextureList<T> {
    pub textures: Vec<Option<T>>,
    pub free_list: Vec<usize>,
}

impl<T> Default for AtlasTextureList<T> {
    fn default() -> Self {
        Self {
            textures: Vec::default(),
            free_list: Vec::default(),
        }
    }
}

impl<T> ops::Index<usize> for AtlasTextureList<T> {
    type Output = Option<T>;

    fn index(&self, index: usize) -> &Self::Output {
        &self.textures[index]
    }
}

impl<T> AtlasTextureList<T> {
    #[allow(unused)]
    pub fn drain(&mut self) -> std::vec::Drain<'_, Option<T>> {
        self.free_list.clear();
        self.textures.drain(..)
    }

    #[allow(dead_code)]
    pub fn iter_mut(&mut self) -> impl DoubleEndedIterator<Item = &mut T> {
        self.textures.iter_mut().flatten()
    }
}

/// An allocated rectangle within a texture owned by one [`PlatformAtlas`].
#[derive(Copy, Clone, Debug, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[repr(C)]
pub struct AtlasTile {
    /// The texture this tile belongs to.
    pub texture_id: AtlasTextureId,
    /// The unique ID of this tile within its texture.
    pub tile_id: TileId,
    /// Padding around the tile content in pixels.
    pub padding: u32,
    /// The bounds of this tile within the texture.
    pub bounds: Bounds<DevicePixels>,
}

/// Identifies one texture in its owning atlas, including its pixel format.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[repr(C)]
pub struct AtlasTextureId {
    // We use u32 instead of usize for Metal Shader Language compatibility
    /// The index of this texture in the atlas.
    pub index: u32,
    /// The kind of content stored in this texture.
    pub kind: AtlasTextureKind,
}

/// The channel interpretation of an atlas bitmap.
#[derive(Clone, Copy, Debug, PartialEq, Eq, Hash, Serialize, Deserialize)]
#[repr(C)]
#[cfg_attr(
    all(
        any(target_os = "linux", target_os = "freebsd"),
        not(any(feature = "x11", feature = "wayland"))
    ),
    allow(dead_code)
)]
pub enum AtlasTextureKind {
    /// One coverage byte per pixel, used for grayscale glyphs and SVG masks.
    Monochrome = 0,
    /// Four BGRA bytes per pixel, used for color images and glyphs.
    Polychrome = 1,
    /// Four bytes per pixel carrying BGRA subpixel coverage for LCD text.
    Subpixel = 2,
}

impl AtlasTextureKind {
    /// Validates a tightly packed bitmap before an atlas allocates or caches its tile.
    /// Monochrome tiles contain one coverage byte; color and LCD tiles contain four bytes.
    pub fn validate_upload(self, size: Size<DevicePixels>, bytes: &[u8]) -> Result<()> {
        anyhow::ensure!(
            size.width.0 > 0 && size.height.0 > 0,
            "{self:?} atlas upload requires positive dimensions, got {size:?}"
        );
        let channels = match self {
            Self::Monochrome => 1,
            Self::Polychrome | Self::Subpixel => 4,
        };
        let expected = (size.width.0 as usize)
            .checked_mul(size.height.0 as usize)
            .and_then(|pixels| pixels.checked_mul(channels))
            .ok_or_else(|| anyhow::anyhow!("atlas upload byte count overflow for {size:?}"))?;
        anyhow::ensure!(
            bytes.len() == expected,
            "{self:?} atlas upload for {size:?} requires {expected} bytes, got {}",
            bytes.len()
        );
        Ok(())
    }
}

/// Allocator identity of a tile within its atlas texture.
#[derive(Clone, Copy, Debug, PartialEq, Eq, PartialOrd, Ord, Hash, Serialize, Deserialize)]
#[repr(C)]
pub struct TileId(
    /// Serialized atlas allocation identifier.
    pub u32,
);

impl From<etagere::AllocId> for TileId {
    fn from(id: etagere::AllocId) -> Self {
        Self(id.serialize())
    }
}

impl From<TileId> for etagere::AllocId {
    fn from(id: TileId) -> Self {
        Self::deserialize(id.0)
    }
}

/// Connects the platform's text-input session to a focused GPUI [`InputHandler`].
///
/// All text offsets and ranges count UTF-16 code units. Most methods briefly
/// borrow the associated window and app; if the window has closed, queries
/// return `None` and edits do nothing. Methods taking `window` and `cx` instead
/// reuse an existing borrow. Native callbacks must not call the borrowing
/// methods while GPUI already holds the app borrow.
pub struct PlatformInputHandler {
    cx: AsyncWindowContext,
    handler: Box<dyn InputHandler>,
}

#[cfg_attr(
    all(
        any(target_os = "linux", target_os = "freebsd"),
        not(any(feature = "x11", feature = "wayland"))
    ),
    allow(dead_code)
)]
impl PlatformInputHandler {
    /// Wrap a focused handler with the window context needed by native callbacks.
    pub fn new(cx: AsyncWindowContext, handler: Box<dyn InputHandler>) -> Self {
        Self { cx, handler }
    }

    /// Read the selection, optionally querying a handler that currently rejects text input.
    pub fn selected_text_range(&mut self, ignore_disabled_input: bool) -> Option<UTF16Selection> {
        self.cx
            .update(|window, cx| {
                self.handler
                    .selected_text_range(ignore_disabled_input, window, cx)
            })
            .ok()
            .flatten()
    }

    #[cfg_attr(target_os = "windows", allow(dead_code))]
    /// Read the active composition range, if any.
    pub fn marked_text_range(&mut self) -> Option<Range<usize>> {
        self.cx
            .update(|window, cx| self.handler.marked_text_range(window, cx))
            .ok()
            .flatten()
    }

    #[cfg_attr(
        any(target_os = "linux", target_os = "freebsd", target_os = "windows"),
        allow(dead_code)
    )]
    /// Read text in a UTF-16 range, reporting any boundary adjustment through `adjusted`.
    pub fn text_for_range(
        &mut self,
        range_utf16: Range<usize>,
        adjusted: &mut Option<Range<usize>>,
    ) -> Option<String> {
        self.cx
            .update(|window, cx| {
                self.handler
                    .text_for_range(range_utf16, adjusted, window, cx)
            })
            .ok()
            .flatten()
    }

    /// Replace a UTF-16 range; `None` lets the handler choose the selection or composition.
    pub fn replace_text_in_range(&mut self, replacement_range: Option<Range<usize>>, text: &str) {
        self.cx
            .update(|window, cx| {
                self.handler
                    .replace_text_in_range(replacement_range, text, window, cx);
            })
            .ok();
    }

    /// Replace text and mark it as an IME composition.
    /// `new_selected_range` is relative to `new_text`, in UTF-16 code units.
    pub fn replace_and_mark_text_in_range(
        &mut self,
        range_utf16: Option<Range<usize>>,
        new_text: &str,
        new_selected_range: Option<Range<usize>>,
    ) {
        self.cx
            .update(|window, cx| {
                self.handler.replace_and_mark_text_in_range(
                    range_utf16,
                    new_text,
                    new_selected_range,
                    window,
                    cx,
                )
            })
            .ok();
    }

    #[cfg_attr(target_os = "windows", allow(dead_code))]
    /// Commit the current composition by clearing its marked range.
    pub fn unmark_text(&mut self) {
        self.cx
            .update(|window, cx| self.handler.unmark_text(window, cx))
            .ok();
    }

    /// Deliver clipboard content directly to the focused handler.
    pub fn paste(&mut self, item: ClipboardItem) {
        self.cx
            .update(|window, cx| self.handler.paste(item, window, cx))
            .ok();
    }

    /// Query the logical-pixel window bounds of a UTF-16 text range.
    pub fn bounds_for_range(&mut self, range_utf16: Range<usize>) -> Option<Bounds<Pixels>> {
        self.cx
            .update(|window, cx| self.handler.bounds_for_range(range_utf16, window, cx))
            .ok()
            .flatten()
    }

    #[allow(dead_code)]
    /// Whether the handler permits Apple's press-and-hold accent picker.
    pub fn apple_press_and_hold_enabled(&mut self) -> bool {
        self.handler.apple_press_and_hold_enabled()
    }

    /// Insert text using an existing window/app borrow and the handler's current selection.
    pub fn dispatch_input(&mut self, input: &str, window: &mut Window, cx: &mut App) {
        self.handler.replace_text_in_range(None, input, window, cx);
    }

    /// Choose candidate-popup bounds from a selection and optional composition.
    ///
    /// During composition, use the start of the caret's visual line within the
    /// marked range. Otherwise use the selection's active endpoint. The supplied
    /// query receives UTF-16 ranges, including empty ranges for caret positions.
    pub fn compute_ime_candidate_bounds(
        marked_range: Option<Range<usize>>,
        selection: &UTF16Selection,
        mut bounds_for_range: impl FnMut(Range<usize>) -> Option<Bounds<Pixels>>,
    ) -> Option<Bounds<Pixels>> {
        let caret = if selection.reversed {
            selection.range.start
        } else {
            selection.range.end
        };
        if let Some(marked_range) = marked_range {
            // Default to the start of the marked (composing) range.
            let mut line_start = marked_range.start;

            // Walk backward from the caret looking for a line break. A change in
            // the Y coordinate means we crossed into the previous visual line, so
            // the line start is one position after the break point.
            if let Some(caret_bounds) = bounds_for_range(caret..caret) {
                for i in (marked_range.start..caret).rev() {
                    if let Some(b) = bounds_for_range(i..i) {
                        if (b.origin.y - caret_bounds.origin.y).abs() > px(0.1) {
                            line_start = i + 1;
                            break;
                        }
                    }
                }
            }
            bounds_for_range(line_start..line_start)
        } else {
            // No active composition — use the selection endpoint.
            bounds_for_range(caret..caret)
        }
    }

    /// Compute candidate-popup bounds using an existing window/app borrow.
    pub fn selected_bounds(&mut self, window: &mut Window, cx: &mut App) -> Option<Bounds<Pixels>> {
        let marked_range = self.handler.marked_text_range(window, cx);
        let selection = self.handler.selected_text_range(true, window, cx)?;
        Self::compute_ime_candidate_bounds(marked_range, &selection, |range| {
            self.handler.bounds_for_range(range, window, cx)
        })
    }

    /// Compute candidate-popup bounds by borrowing the associated window.
    pub fn ime_candidate_bounds(&mut self) -> Option<Bounds<Pixels>> {
        let marked_range = self.marked_text_range();
        let selection = self.selected_text_range(true)?;
        Self::compute_ime_candidate_bounds(marked_range, &selection, |range| {
            self.bounds_for_range(range)
        })
    }

    #[allow(unused)]
    /// Hit-test a logical window position and return its UTF-16 text offset.
    pub fn character_index_for_point(&mut self, point: Point<Pixels>) -> Option<usize> {
        self.cx
            .update(|window, cx| self.handler.character_index_for_point(point, window, cx))
            .ok()
            .flatten()
    }

    /// See [`InputHandler::set_selected_text_range`].
    pub fn set_selected_text_range(&mut self, range_utf16: Range<usize>) {
        self.cx
            .update(|window, cx| {
                self.handler
                    .set_selected_text_range(range_utf16, window, cx)
            })
            .ok();
    }

    /// See [`InputHandler::element_bounds`].
    pub fn element_bounds(&mut self) -> Option<Bounds<Pixels>> {
        self.cx
            .update(|window, cx| self.handler.element_bounds(window, cx))
            .ok()
            .flatten()
    }

    /// See [`InputHandler::text_length_utf16`].
    pub fn text_length_utf16(&mut self) -> Option<usize> {
        self.cx
            .update(|window, cx| self.handler.text_length_utf16(window, cx))
            .ok()
            .flatten()
    }

    #[allow(dead_code)]
    /// Query whether the handler accepts text, using an existing window/app borrow.
    pub fn accepts_text_input(&mut self, window: &mut Window, cx: &mut App) -> bool {
        self.handler.accepts_text_input(window, cx)
    }

    #[allow(dead_code)]
    /// Query whether the handler accepts text; defaults to `true` if the window is unavailable.
    pub fn query_accepts_text_input(&mut self) -> bool {
        self.cx
            .update(|window, cx| self.handler.accepts_text_input(window, cx))
            .unwrap_or(true)
    }

    /// See [`InputHandler::prefers_ime_for_printable_keys`].
    ///
    /// This is not a pure delegation to the handler: while a multi-stroke binding is pending this
    /// returns `false` regardless of the handler's preference, because the next printable key may
    /// complete a binding whose prefix already bypassed the IME.
    pub fn query_prefers_ime_for_printable_keys(&mut self) -> bool {
        self.cx
            .update(|window, cx| {
                // The next printable key may complete a chord whose prefix bypassed the IME.
                !window.has_pending_keystrokes()
                    && self.handler.prefers_ime_for_printable_keys(window, cx)
            })
            .unwrap_or(false)
    }

    /// See [`InputHandler::text_input_configuration`].
    pub fn text_input_configuration(
        &mut self,
        window: &mut Window,
        cx: &mut App,
    ) -> TextInputConfiguration {
        self.handler.text_input_configuration(window, cx)
    }

    /// Reads the focused handler's text assistance preferences outside an app borrow.
    pub fn query_text_input_configuration(&mut self) -> TextInputConfiguration {
        self.cx
            .update(|window, cx| self.handler.text_input_configuration(window, cx))
            .unwrap_or_default()
    }

    /// See [`InputHandler::text_input_editable_range`].
    pub fn text_input_editable_range(&mut self) -> Option<Range<usize>> {
        self.cx
            .update(|window, cx| self.handler.text_input_editable_range(window, cx))
            .ok()
            .flatten()
    }
}

#[cfg(test)]
mod ime_candidate_bounds_tests {
    use super::*;
    use crate::size;

    fn bounds_at(offset: usize) -> Bounds<Pixels> {
        let line = if offset < 3 { 0. } else { 20. };
        Bounds::new(point(px(offset as f32), px(line)), size(px(1.), px(20.)))
    }

    #[test]
    fn composition_follows_the_active_endpoint_of_a_reversed_selection() {
        let selection = UTF16Selection {
            range: 2..7,
            reversed: true,
        };
        let bounds =
            PlatformInputHandler::compute_ime_candidate_bounds(Some(0..8), &selection, |range| {
                Some(bounds_at(range.start))
            });
        assert_eq!(bounds, Some(bounds_at(0)));
    }

    #[test]
    fn composition_uses_the_start_of_the_active_visual_line() {
        let selection = UTF16Selection {
            range: 2..7,
            reversed: false,
        };
        let bounds =
            PlatformInputHandler::compute_ime_candidate_bounds(Some(0..8), &selection, |range| {
                Some(bounds_at(range.start))
            });
        assert_eq!(bounds, Some(bounds_at(3)));
    }

    #[test]
    fn without_composition_uses_the_active_endpoint() {
        let selection = UTF16Selection {
            range: 2..7,
            reversed: true,
        };
        let bounds =
            PlatformInputHandler::compute_ime_candidate_bounds(None, &selection, |range| {
                Some(bounds_at(range.start))
            });
        assert_eq!(bounds, Some(bounds_at(2)));
    }
}

/// A text selection measured in UTF-16 code units, including its direction.
///
/// `range` is ordered from the lower offset to the higher offset. `reversed`
/// identifies which endpoint is the active head, where movement extends or
/// contracts the selection. An empty range denotes a caret.
///
/// ```
/// use gpui::UTF16Selection;
///
/// // The user selected backward from offset 7 to offset 3.
/// let selection = UTF16Selection { range: 3..7, reversed: true };
/// let head = if selection.reversed { selection.range.start } else { selection.range.end };
/// assert_eq!(head, 3);
/// ```
#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub struct UTF16Selection {
    /// The selected half-open document range, in UTF-16 code units.
    pub range: Range<usize>,
    /// Whether the active head is at `range.start` rather than `range.end`.
    pub reversed: bool,
}

/// The focused text region's interface to platform text input.
///
/// The platform uses this protocol to query surrounding text, replace ranges,
/// maintain an [input method](https://en.wikipedia.org/wiki/Input_method)
/// composition, and position native text UI. A composition is provisional text
/// that the input method can replace repeatedly before committing it; its
/// *marked range* belongs to that session.
///
/// Every offset and range counts **UTF-16 code units**, even when the document
/// stores UTF-8. For example, `"a🦀"` has five UTF-8 bytes and three UTF-16 code
/// units. Convert at the boundary with [`crate::utf8_to_utf16_offset`] and
/// [`crate::utf16_to_utf8_offset`]. Neither encoding chooses user-visible
/// [grapheme boundaries](https://www.unicode.org/reports/tr29/).
///
/// Implement [`crate::EntityInputHandler`] on a view and install its
/// [`crate::ElementInputHandler`] during paint with [`Window::handle_input`].
/// Implement this lower-level trait directly when the handler is not an entity.
/// Keyboard listeners alone cannot represent composition or platform-driven
/// replacement. See the [input chapter](crate::_documentation::input) for routing and focus.
pub trait InputHandler: 'static {
    /// Read the selection and its active endpoint, or `None` if unavailable.
    ///
    /// A caret is `Some` with an empty range. When `ignore_disabled_input` is
    /// true, report the selection even if the region currently rejects edits,
    /// when that query is supported. Otherwise the handler can return `None`
    /// while disabled. See [`Self::accepts_text_input`].
    fn selected_text_range(
        &mut self,
        ignore_disabled_input: bool,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<UTF16Selection>;

    /// Read the provisional composition range in document coordinates.
    ///
    /// `None` means there is no active marked range. Keep this range in sync
    /// with replacements made by [`Self::replace_and_mark_text_in_range`].
    fn marked_text_range(&mut self, window: &mut Window, cx: &mut App) -> Option<Range<usize>>;

    /// Read text overlapping a UTF-16 document range.
    ///
    /// Return `None` when the query cannot be answered. If the requested range
    /// must be clamped or adjusted to a valid boundary, set `adjusted_range` to
    /// the document range represented by the returned string. The string
    /// itself is UTF-8, as usual for Rust.
    fn text_for_range(
        &mut self,
        range_utf16: Range<usize>,
        adjusted_range: &mut Option<Range<usize>>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<String>;

    /// Commit `text` by replacing a UTF-16 document range.
    ///
    /// For `None`, replace the current marked range if composing, or the
    /// current selection otherwise. Update the selection and clear the marked
    /// range as part of the edit. Notify the view so its next frame reflects
    /// the new text and caret. Repeated composition updates instead use
    /// [`Self::replace_and_mark_text_in_range`].
    fn replace_text_in_range(
        &mut self,
        replacement_range: Option<Range<usize>>,
        text: &str,
        window: &mut Window,
        cx: &mut App,
    );

    /// Replace text and mark the inserted text as provisional composition.
    ///
    /// `range_utf16` is a document range. For `None`, replace the previous
    /// marked range, or the selection when starting a composition.
    /// `new_selected_range` is relative to `new_text`, also in UTF-16 code
    /// units; translate it to document coordinates after insertion. When it
    /// is absent, choose the handler's default selection placement.
    ///
    /// A later call can replace this marked text again. Do not append every
    /// provisional update as if it were a separately committed keystroke.
    fn replace_and_mark_text_in_range(
        &mut self,
        range_utf16: Option<Range<usize>>,
        new_text: &str,
        new_selected_range: Option<Range<usize>>,
        window: &mut Window,
        cx: &mut App,
    );

    /// End composition without deleting or replacing the marked text.
    ///
    /// Clear the marked range and any composition decoration, keeping the text.
    fn unmark_text(&mut self, window: &mut Window, cx: &mut App);

    /// Commit the plain-text portion of a platform-initiated paste.
    ///
    /// Platforms that deliver paste as an input event rather than through an
    /// application-defined action (e.g. the DOM `paste` event on web) call
    /// this with the full clipboard contents. The default implementation
    /// calls [`Self::replace_text_in_range`] without an explicit range,
    /// replacing marked text during composition or the current selection.
    fn paste(&mut self, item: ClipboardItem, window: &mut Window, cx: &mut App) {
        if let Some(text) = item.text() {
            self.replace_text_in_range(None, &text, window, cx);
        }
    }

    /// Get the bounds of the given document range in logical window coordinates
    /// Corresponds to [firstRect(forCharacterRange:actualRange:)](https://developer.apple.com/documentation/appkit/nstextinputclient/1438240-firstrect)
    ///
    /// Return bounds in the coordinate space used by element layout, relative
    /// to the window's content origin. Do not convert to device pixels or add
    /// the window's screen position; the platform backend performs that mapping
    /// when positioning the IME candidate window. An empty UTF-16 range denotes
    /// a caret position.
    fn bounds_for_range(
        &mut self,
        range_utf16: Range<usize>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Bounds<Pixels>>;

    /// Get the character offset for a logical window-local point in UTF-16 code units.
    ///
    /// Corresponds to [characterIndexForPoint:](https://developer.apple.com/documentation/appkit/nstextinputclient/characterindex(for:))
    fn character_index_for_point(
        &mut self,
        point: Point<Pixels>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<usize>;

    /// Set the range of the user's currently selected text.
    ///
    /// This is the reverse data-flow direction from [`Self::selected_text_range`]:
    /// platforms call it when the system text machinery moves the selection on the
    /// application's behalf — e.g. the user drags a system selection handle or
    /// invokes Select All from system UI (iOS `UITextInput setSelectedTextRange:`,
    /// Android `InputConnection.setSelection`).
    ///
    /// `range_utf16` counts code units from the start of the document. The
    /// default does nothing; override it to support platform-driven selection.
    fn set_selected_text_range(
        &mut self,
        _range_utf16: Range<usize>,
        _window: &mut Window,
        _cx: &mut App,
    ) {
    }

    /// Get the bounds of the focused text element in window coordinates, if known.
    ///
    /// This is the pull counterpart to the [`PlatformWindow::update_ime_position`]
    /// push: mobile platforms ask for the focused element's geometry when they
    /// need it (e.g. to frame system text-interaction UI overlaid on the focused
    /// element).
    fn element_bounds(&mut self, _window: &mut Window, _cx: &mut App) -> Option<Bounds<Pixels>> {
        None
    }

    /// Read the document's UTF-16 code-unit length, or `None` if unavailable.
    fn text_length_utf16(&mut self, _window: &mut Window, _cx: &mut App) -> Option<usize> {
        None
    }

    /// Permit the macOS press-and-hold accent picker; the default is `true`.
    ///
    /// Return `false` when held printable keys should instead reach raw key
    /// handling as repeated input, for example in a terminal.
    #[allow(dead_code)]
    fn apple_press_and_hold_enabled(&mut self) -> bool {
        true
    }

    /// Whether this region accepts text insertion; the default is `true`.
    ///
    /// Returning `false` informs platform text routing. It does not disable
    /// pointer, key, or accessibility listeners, or guard direct calls to the
    /// edit methods. Enforce read-only rules in the document's edit operations.
    fn accepts_text_input(&mut self, _window: &mut Window, _cx: &mut App) -> bool {
        true
    }

    /// The contiguous range of text, in UTF-16 code units, that platform text
    /// input may read and edit around the current selection.
    ///
    /// Platforms that mirror document text into an IME-editable buffer clamp
    /// the mirrored window to this range, so multi-step IME edit gestures
    /// (word deletion, autocorrect rewrites, suggestion picks) cannot reach
    /// content outside it. The range should contain the current selection;
    /// when it cannot (a selection spanning a region boundary), platforms
    /// degrade the mirrored IME context rather than widening the range.
    /// `None` places no bound.
    fn text_input_editable_range(
        &mut self,
        _window: &mut Window,
        _cx: &mut App,
    ) -> Option<Range<usize>> {
        None
    }

    /// Returns whether printable keys should be routed to the IME before keybinding
    /// matching when a non-ASCII input source (e.g. Japanese, Korean, Chinese IME)
    /// is active. This prevents multi-stroke keybindings like `jj` from intercepting
    /// keys that the IME should compose.
    ///
    /// The default is `false`, useful for raw-key input such as a terminal.
    /// [`crate::ElementInputHandler`] instead follows its view's
    /// [`crate::EntityInputHandler::accepts_text_input`] result. A pending
    /// multi-stroke key binding overrides this preference; see
    /// [`PlatformInputHandler::query_prefers_ime_for_printable_keys`].
    fn prefers_ime_for_printable_keys(&mut self, _window: &mut Window, _cx: &mut App) -> bool {
        false
    }

    /// Get this handler's preferences for platform text assistance.
    ///
    /// GPUI re-queries this every frame and forwards it to the platform window
    /// only when it changes, so implementations must be cheap and may vary the
    /// result with application state (e.g. with the cursor's position).
    fn text_input_configuration(
        &mut self,
        _window: &mut Window,
        _cx: &mut App,
    ) -> TextInputConfiguration {
        TextInputConfiguration::default()
    }
}

/// Platform text-assistance preferences for the focused text region.
///
/// Returned by [`InputHandler::text_input_configuration`] and forwarded to the
/// platform whenever it changes; the platform maps the fields onto its native
/// input-session attributes (on web, DOM attributes of the hidden editable
/// element such as `autocorrect` and `enterkeyhint`).
///
/// The default disables all text assistance and requests no particular action
/// key presentation.
#[derive(Clone, Debug, Default, PartialEq, Eq, Serialize, Deserialize)]
pub struct TextInputConfiguration {
    /// Whether the platform may automatically correct entered text.
    pub autocorrect: bool,
    /// How software keyboards automatically capitalize entered text.
    pub autocapitalize: Autocapitalize,
    /// Whether software keyboards may offer word suggestions and spellcheck.
    pub suggestions: bool,
    /// The action advertised on a software keyboard's confirm ("enter") key.
    pub input_action: TextInputAction,
}

/// Automatic capitalization applied by software keyboards.
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Serialize, Deserialize)]
pub enum Autocapitalize {
    /// No automatic capitalization.
    #[default]
    None,
    /// Capitalize the first letter of each word.
    Words,
    /// Capitalize the first letter of each sentence.
    Sentences,
    /// Capitalize every letter.
    Characters,
}

/// The action a software keyboard advertises on its confirm ("enter") key.
///
/// This affects only how the key is presented (icon or label); pressing it is
/// still delivered as ordinary input.
///
/// The variants are the HTML `enterkeyhint` attribute's value set
/// (<https://html.spec.whatwg.org/multipage/interaction.html#input-modalities:-the-enterkeyhint-attribute>),
/// which also maps onto Android's `IME_ACTION_*` constants and iOS's
/// `UIReturnKeyType`; [`TextInputAction::Unspecified`] means "emit no hint".
#[derive(Clone, Copy, Debug, Default, PartialEq, Eq, Serialize, Deserialize)]
pub enum TextInputAction {
    /// Let the platform choose its default presentation.
    #[default]
    Unspecified,
    /// Inserting a line break.
    Enter,
    /// Committing the field's value.
    Done,
    /// Navigating to the typed target.
    Go,
    /// Moving to the next field.
    Next,
    /// Moving to the previous field.
    Previous,
    /// Executing a search.
    Search,
    /// Sending a message.
    Send,
}

/// Options for creating a window.
///
/// Chain setters on [`WindowOptions::default`] (or [`WindowOptions::new`]) to
/// override individual fields. Optional setters accept a value or an `Option`.
/// Pass `None` to clear the field.
///
/// The window background is configured per platform, so consumers explicitly
/// decide what each target needs:
///
/// ```
/// use gpui::WindowOptions;
///
/// let options = WindowOptions::new()
///     .focus(false)
///     .titlebar(None)
///     .app_id("org.example.app".to_owned());
/// ```
#[derive(Debug, derive_setters::Setters)]
#[setters(into)]
pub struct WindowOptions {
    /// Initial state and normal/restore geometry in logical pixels.
    ///
    /// `None` reuses an available active window's state and size, or the
    /// display's default bounds, then chooses a cascaded placement. Supply
    /// bounds explicitly when the initial size matters. For maximized or
    /// fullscreen windows, the supplied bounds describe the
    /// size to restore. Native placement remains subject to the window manager;
    /// Wayland and browser windows do not expose global desktop positioning.
    pub window_bounds: Option<WindowBounds>,

    /// The titlebar configuration of the window
    pub titlebar: Option<TitlebarOptions>,

    /// Whether the window should be focused when created
    pub focus: bool,

    /// Whether the window should be shown when created
    pub show: bool,

    /// The kind of window to create
    pub kind: WindowKind,

    /// Whether the window can be moved by the user. When `false`, the user cannot drag
    /// the window (on macOS this sets `NSWindow.isMovable`, which also disables the
    /// Window-menu tiling items); programmatic moves are still allowed.
    pub is_movable: bool,

    /// Whether the application owns dragging of the (custom) titlebar, rather than
    /// AppKit. Only has an effect on macOS.
    ///
    /// Set this to `true` for windows that draw their own titlebar and move the window
    /// themselves via [`Window::start_window_move`]. It marks the whole content view as
    /// app-owned titlebar content, so AppKit neither drags the window from the titlebar
    /// nor delays titlebar clicks while disambiguating double-clicks (a delay first
    /// observed on macOS 27). It is independent of `is_movable`, so such windows stay
    /// user-movable (via their own drag) and keep the Window-menu tiling items enabled.
    ///
    /// Leave this `false` for windows that rely on AppKit's native titlebar dragging.
    pub app_owns_titlebar_drag: bool,

    /// The minimum interval between animation frames while the window is inactive.
    ///
    /// Set to `None` to disable inactive-window animation frame throttling.
    pub inactive_frame_interval: Option<Duration>,

    /// Whether the window should be resizable by the user
    pub is_resizable: bool,

    /// Whether the window should be minimized by the user
    pub is_minimizable: bool,

    /// Preferred display, or `None` to let the platform choose its primary display.
    ///
    /// Display IDs belong to the running platform session. Check a restored ID
    /// with [`App::find_display`] before requesting it.
    pub display_id: Option<DisplayId>,

    /// The background appearance of a macOS window.
    #[cfg(target_os = "macos")]
    pub macos_window_background: MacosWindowBackground,

    /// The background appearance of a Windows window.
    #[cfg(target_os = "windows")]
    pub windows_window_background: WindowsWindowBackground,

    /// The background appearance of a Linux window.
    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    pub linux_window_background: LinuxWindowBackground,

    /// The background appearance of a web window.
    #[cfg(target_family = "wasm")]
    pub web_window_background: WebWindowBackground,

    /// Application identifier of the window. Can by used by desktop environments to group applications together.
    pub app_id: Option<String>,

    /// Window minimum size
    pub window_min_size: Option<Size<Pixels>>,

    /// Whether to use client or server-side decorations on X11 and Wayland.
    /// The platform may ignore requests it cannot satisfy.
    pub window_decorations: Option<WindowDecorations>,

    /// Native icon on X11 and on Wayland compositors supporting the icon protocol.
    pub icon: Option<Arc<image::RgbaImage>>,

    /// Tab group name, allows opening the window as a native tab on macOS 10.12+. Windows with the same tabbing identifier will be grouped together.
    pub tabbing_identifier: Option<String>,
}

impl FluentBuilder for WindowOptions {}

/// Resolved window-creation parameters passed from GPUI to a platform backend.
///
/// Application code normally supplies [`WindowOptions`]; GPUI resolves display
/// and geometry defaults before producing these parameters.
#[derive(Debug)]
#[cfg_attr(
    all(
        any(target_os = "linux", target_os = "freebsd"),
        not(any(feature = "x11", feature = "wayland"))
    ),
    allow(dead_code)
)]
pub struct WindowParams {
    /// Initial window bounds in logical display coordinates.
    pub bounds: Bounds<Pixels>,

    /// The titlebar configuration of the window
    #[cfg_attr(feature = "wayland", allow(dead_code))]
    pub titlebar: Option<TitlebarOptions>,

    /// The kind of window to create
    #[cfg_attr(any(target_os = "linux", target_os = "freebsd"), allow(dead_code))]
    pub kind: WindowKind,

    /// Whether the window should be movable by the user
    #[cfg_attr(any(target_os = "linux", target_os = "freebsd"), allow(dead_code))]
    pub is_movable: bool,

    /// Whether the application owns dragging of the (custom) titlebar (macOS only)
    #[cfg_attr(
        any(target_os = "linux", target_os = "freebsd", target_os = "windows"),
        allow(dead_code)
    )]
    pub app_owns_titlebar_drag: bool,

    /// Whether the window should be resizable by the user
    #[cfg_attr(any(target_os = "linux", target_os = "freebsd"), allow(dead_code))]
    pub is_resizable: bool,

    /// Whether the window should be minimized by the user
    #[cfg_attr(any(target_os = "linux", target_os = "freebsd"), allow(dead_code))]
    pub is_minimizable: bool,

    /// Whether to request focus when the window opens.
    #[cfg_attr(
        any(target_os = "linux", target_os = "freebsd", target_os = "windows"),
        allow(dead_code)
    )]
    pub focus: bool,

    /// Whether to show the window immediately after creation.
    #[cfg_attr(any(target_os = "linux", target_os = "freebsd"), allow(dead_code))]
    pub show: bool,

    /// An image to set as the window icon (X11 and Wayland only)
    /// Wayland requires the xdg-toplevel-icon protocol to be available
    #[cfg_attr(feature = "wayland", allow(dead_code))]
    pub icon: Option<Arc<image::RgbaImage>>,

    /// Display selected for the window, if explicitly resolved.
    #[cfg_attr(feature = "wayland", allow(dead_code))]
    pub display_id: Option<DisplayId>,

    /// Compositor application identifier, where supported.
    #[cfg_attr(feature = "wayland", allow(dead_code))]
    pub app_id: Option<String>,

    /// Minimum content size in logical pixels, if constrained.
    pub window_min_size: Option<Size<Pixels>>,

    #[cfg(target_os = "macos")]
    /// Identifier used to group compatible native macOS window tabs.
    pub tabbing_identifier: Option<String>,
}

/// A window's normal, maximized, or fullscreen state with its restore geometry.
///
/// Use [`Window::window_bounds`] to record this value for reopening a window.
/// [`Self::get_bounds`] extracts the normal/restore bounds, which can differ
/// from its current fullscreen or maximized viewport.
#[derive(Debug, Copy, Clone, PartialEq)]
pub enum WindowBounds {
    /// Indicates that the window should open in a windowed state with the given bounds.
    Windowed(Bounds<Pixels>),
    /// Indicates that the window should open in a maximized state.
    /// The bounds provided here represent the restore size of the window.
    Maximized(Bounds<Pixels>),
    /// Indicates that the window should open in fullscreen mode.
    /// The bounds provided here represent the restore size of the window.
    Fullscreen(Bounds<Pixels>),
}

impl Default for WindowBounds {
    fn default() -> Self {
        WindowBounds::Windowed(Bounds::default())
    }
}

impl WindowBounds {
    /// Extract normal bounds, or restore bounds for a maximized/fullscreen window.
    pub fn get_bounds(&self) -> Bounds<Pixels> {
        match self {
            WindowBounds::Windowed(bounds) => *bounds,
            WindowBounds::Maximized(bounds) => *bounds,
            WindowBounds::Fullscreen(bounds) => *bounds,
        }
    }

    /// Request a normal window centered on the primary display.
    pub fn centered(size: Size<Pixels>, cx: &App) -> Self {
        WindowBounds::Windowed(Bounds::centered(None, size, cx))
    }
}

impl Default for WindowOptions {
    fn default() -> Self {
        Self {
            window_bounds: None,
            titlebar: Some(TitlebarOptions {
                title: Default::default(),
                appears_transparent: Default::default(),
                traffic_light_position: Default::default(),
            }),
            focus: true,
            show: true,
            kind: WindowKind::Normal,
            is_movable: true,
            app_owns_titlebar_drag: false,
            inactive_frame_interval: Some(Duration::from_micros(33_333)),
            is_resizable: true,
            is_minimizable: true,
            display_id: None,
            #[cfg(target_os = "macos")]
            macos_window_background: MacosWindowBackground::default(),
            #[cfg(target_os = "windows")]
            windows_window_background: WindowsWindowBackground::default(),
            #[cfg(any(target_os = "linux", target_os = "freebsd"))]
            linux_window_background: LinuxWindowBackground::default(),
            #[cfg(target_family = "wasm")]
            web_window_background: WebWindowBackground::default(),
            icon: None,
            app_id: None,
            window_min_size: None,
            window_decorations: None,
            tabbing_identifier: None,
        }
    }
}

impl WindowOptions {
    /// Returns window options with the platform's defaults: a focused, shown,
    /// resizable, minimizable, movable normal window with a titlebar.
    pub fn new() -> Self {
        Self::default()
    }

    /// Returns the window's background appearance for the current platform,
    /// erased into the renderer-facing [`WindowBackgroundAppearance`].
    pub fn background_appearance(&self) -> WindowBackgroundAppearance {
        #[cfg(target_os = "macos")]
        {
            self.macos_window_background.into()
        }
        #[cfg(target_os = "windows")]
        {
            self.windows_window_background.into()
        }
        #[cfg(any(target_os = "linux", target_os = "freebsd"))]
        {
            self.linux_window_background.into()
        }
        #[cfg(target_family = "wasm")]
        {
            self.web_window_background.into()
        }
        #[cfg(not(any(
            target_os = "macos",
            target_os = "windows",
            any(target_os = "linux", target_os = "freebsd"),
            target_family = "wasm",
        )))]
        {
            WindowBackgroundAppearance::default()
        }
    }
}

/// Options for a window's titlebar.
///
/// Chain setters on [`TitlebarOptions::default`] and pass the result to
/// [`WindowOptions::titlebar()`]. Pass `None` to clear the title or traffic light position.
///
/// ```
/// use gpui::{SharedString, TitlebarOptions, point, px};
///
/// let titlebar = TitlebarOptions::default()
///     .title(SharedString::from("My app"))
///     .appears_transparent(true)
///     .traffic_light_position(point(px(16.0), px(16.0)));
/// ```
#[derive(Debug, Default, derive_setters::Setters)]
#[setters(into)]
pub struct TitlebarOptions {
    /// The initial title of the window
    pub title: Option<SharedString>,

    /// Should the default system titlebar be hidden to allow for a custom-drawn titlebar? (macOS and Windows only)
    /// Refer to [`WindowOptions::window_decorations`] on Linux
    pub appears_transparent: bool,

    /// The position of the macOS traffic light buttons
    pub traffic_light_position: Option<Point<Pixels>>,
}

impl FluentBuilder for TitlebarOptions {}

/// The kind of window to create
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum WindowKind {
    /// A normal application window
    Normal,

    /// A window that appears above all other windows, usually used for alerts or popups
    /// use sparingly!
    PopUp,

    /// A parent-anchored, platform-native popup window for menus, comboboxes, context menus and
    /// tooltips. Unlike [`WindowKind::PopUp`], it is positioned relative to a parent window.
    ///
    /// The popup's size comes from [`WindowOptions::window_bounds`], whose origin is ignored.
    /// See [`popup::PopupOptions`] for the placement options. Platforms without a native
    /// implementation reject it with [`popup::PopupNotSupportedError`].
    AnchoredPopup(popup::PopupOptions),

    /// A floating window that appears on top of its parent window
    Floating,

    /// A Wayland LayerShell window, used to draw overlays or backgrounds for applications such as
    /// docks, notifications or wallpapers.
    #[cfg(all(target_os = "linux", feature = "wayland"))]
    LayerShell(layer_shell::LayerShellOptions),

    /// A window that appears on top of its parent window and blocks interaction with it
    /// until the modal window is closed
    Dialog,
}

/// The appearance of the window, as defined by the operating system.
///
/// On macOS, this corresponds to named [`NSAppearance`](https://developer.apple.com/documentation/appkit/nsappearance)
/// values.
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq)]
pub enum WindowAppearance {
    /// A light appearance.
    ///
    /// On macOS, this corresponds to the `aqua` appearance.
    #[default]
    Light,

    /// A light appearance with vibrant colors.
    ///
    /// On macOS, this corresponds to the `NSAppearanceNameVibrantLight` appearance.
    VibrantLight,

    /// A dark appearance.
    ///
    /// On macOS, this corresponds to the `darkAqua` appearance.
    Dark,

    /// A dark appearance with vibrant colors.
    ///
    /// On macOS, this corresponds to the `NSAppearanceNameVibrantDark` appearance.
    VibrantDark,
}

/// The appearance of the background of the window itself, when there is
/// no content or the content is transparent.
///
/// The variants available depend on the target platform. In particular,
/// the Mica backdrop materials are only supported on Windows 11 and are
/// ignored elsewhere.
#[derive(Copy, Clone, Debug, Default, PartialEq)]
pub enum WindowBackgroundAppearance {
    /// Opaque.
    ///
    /// This lets the window manager know that content behind this
    /// window does not need to be drawn.
    ///
    /// Actual color depends on the system and themes should define a fully
    /// opaque background color instead.
    #[default]
    Opaque,
    /// Plain alpha transparency.
    Transparent,
    /// Transparency, but the contents behind the window are blurred.
    ///
    /// Not always supported.
    Blurred,
    /// The Mica backdrop material, supported on Windows 11.
    MicaBackdrop,
    /// The Mica Alt backdrop material, supported on Windows 11.
    MicaAltBackdrop,
}

impl WindowBackgroundAppearance {
    /// Whether the window's background hides everything behind the window,
    /// letting the platform skip compositing the content it covers.
    pub fn is_opaque(&self) -> bool {
        matches!(self, Self::Opaque)
    }

    /// Whether the window's background lets content behind the window show
    /// through, either directly, blurred, or via a system backdrop material.
    pub fn is_transparent(&self) -> bool {
        !self.is_opaque()
    }
}

#[cfg(test)]
mod window_background_appearance_tests {
    use super::WindowBackgroundAppearance;

    #[test]
    fn only_opaque_hides_the_content_behind_the_window() {
        assert!(WindowBackgroundAppearance::Opaque.is_opaque());
        assert!(!WindowBackgroundAppearance::Opaque.is_transparent());

        for appearance in [
            WindowBackgroundAppearance::Transparent,
            WindowBackgroundAppearance::Blurred,
            WindowBackgroundAppearance::MicaBackdrop,
            WindowBackgroundAppearance::MicaAltBackdrop,
        ] {
            assert!(appearance.is_transparent());
            assert!(!appearance.is_opaque());
        }
    }
}

/// The background appearance of a macOS window, set through
/// [`WindowOptions::macos_window_background`].
#[cfg(target_os = "macos")]
#[derive(Copy, Clone, Debug, Default, PartialEq)]
pub enum MacosWindowBackground {
    /// Hides everything behind the window. Themes should define a fully
    /// opaque background color instead of relying on the system's.
    #[default]
    Opaque,
    /// Plain alpha transparency.
    Transparent,
    /// Transparency with the contents behind the window blurred, via the
    /// system's vibrancy materials.
    Blurred,
}

/// The background appearance of a Windows window, set through
/// [`WindowOptions::windows_window_background`].
#[cfg(target_os = "windows")]
#[derive(Copy, Clone, Debug, Default, PartialEq)]
pub enum WindowsWindowBackground {
    /// Hides everything behind the window. Themes should define a fully
    /// opaque background color instead of relying on the system's.
    #[default]
    Opaque,
    /// Plain alpha transparency.
    Transparent,
    /// Transparency with the contents behind the window blurred.
    Blurred,
    /// The Mica backdrop material, supported on Windows 11.
    MicaBackdrop,
    /// The Mica Alt backdrop material, supported on Windows 11.
    MicaAltBackdrop,
}

/// The background appearance of a Linux window, set through
/// [`WindowOptions::linux_window_background`]. Whether blurring is honored
/// depends on the compositor; X11 treats it as plain transparency.
#[cfg(any(target_os = "linux", target_os = "freebsd"))]
#[derive(Copy, Clone, Debug, Default, PartialEq)]
pub enum LinuxWindowBackground {
    /// Hides everything behind the window. Themes should define a fully
    /// opaque background color instead of relying on the system's.
    #[default]
    Opaque,
    /// Plain alpha transparency.
    Transparent,
    /// Transparency with the contents behind the window blurred, when the
    /// compositor supports it.
    Blurred,
}

/// The background appearance of a web window, set through
/// [`WindowOptions::web_window_background`]. Web windows are always opaque at
/// the platform level.
#[cfg(target_family = "wasm")]
#[derive(Copy, Clone, Debug, Default, PartialEq)]
pub enum WebWindowBackground {
    /// The window background is always opaque.
    #[default]
    Opaque,
}

#[cfg(target_os = "macos")]
impl From<MacosWindowBackground> for WindowBackgroundAppearance {
    fn from(background: MacosWindowBackground) -> Self {
        match background {
            MacosWindowBackground::Opaque => Self::Opaque,
            MacosWindowBackground::Transparent => Self::Transparent,
            MacosWindowBackground::Blurred => Self::Blurred,
        }
    }
}

#[cfg(target_os = "windows")]
impl From<WindowsWindowBackground> for WindowBackgroundAppearance {
    fn from(background: WindowsWindowBackground) -> Self {
        match background {
            WindowsWindowBackground::Opaque => Self::Opaque,
            WindowsWindowBackground::Transparent => Self::Transparent,
            WindowsWindowBackground::Blurred => Self::Blurred,
            WindowsWindowBackground::MicaBackdrop => Self::MicaBackdrop,
            WindowsWindowBackground::MicaAltBackdrop => Self::MicaAltBackdrop,
        }
    }
}

#[cfg(any(target_os = "linux", target_os = "freebsd"))]
impl From<LinuxWindowBackground> for WindowBackgroundAppearance {
    fn from(background: LinuxWindowBackground) -> Self {
        match background {
            LinuxWindowBackground::Opaque => Self::Opaque,
            LinuxWindowBackground::Transparent => Self::Transparent,
            LinuxWindowBackground::Blurred => Self::Blurred,
        }
    }
}

#[cfg(target_family = "wasm")]
impl From<WebWindowBackground> for WindowBackgroundAppearance {
    fn from(background: WebWindowBackground) -> Self {
        match background {
            WebWindowBackground::Opaque => Self::Opaque,
        }
    }
}

#[cfg(test)]
mod platform_window_background_tests {
    use super::WindowBackgroundAppearance;

    #[cfg(target_os = "macos")]
    #[test]
    fn macos_backgrounds_map_to_appearances() {
        use super::MacosWindowBackground;
        assert_eq!(
            WindowBackgroundAppearance::from(MacosWindowBackground::Opaque),
            WindowBackgroundAppearance::Opaque
        );
        assert_eq!(
            WindowBackgroundAppearance::from(MacosWindowBackground::Blurred),
            WindowBackgroundAppearance::Blurred
        );
    }

    #[cfg(target_os = "windows")]
    #[test]
    fn windows_backgrounds_map_to_appearances() {
        use super::WindowsWindowBackground;
        assert_eq!(
            WindowBackgroundAppearance::from(WindowsWindowBackground::MicaAltBackdrop),
            WindowBackgroundAppearance::MicaAltBackdrop
        );
        assert_eq!(
            WindowBackgroundAppearance::from(WindowsWindowBackground::default()),
            WindowBackgroundAppearance::Opaque
        );
    }

    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    #[test]
    fn linux_backgrounds_map_to_appearances() {
        use super::LinuxWindowBackground;
        assert_eq!(
            WindowBackgroundAppearance::from(LinuxWindowBackground::Transparent),
            WindowBackgroundAppearance::Transparent
        );
    }

    #[cfg(target_family = "wasm")]
    #[test]
    fn web_backgrounds_map_to_appearances() {
        use super::WebWindowBackground;
        assert_eq!(
            WindowBackgroundAppearance::from(WebWindowBackground::Opaque),
            WindowBackgroundAppearance::Opaque
        );
    }
}

/// The text rendering mode to use for drawing glyphs.
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq, serde::Serialize, serde::Deserialize)]
pub enum TextRenderingMode {
    /// Use the platform's default text rendering mode.
    #[default]
    PlatformDefault,
    /// Use subpixel (ClearType-style) text rendering.
    Subpixel,
    /// Use grayscale text rendering.
    Grayscale,
}

/// The options that can be configured for a file dialog prompt
#[derive(Clone, Debug)]
pub struct PathPromptOptions {
    /// Should the prompt allow files to be selected?
    pub files: bool,
    /// Should the prompt allow directories to be selected?
    pub directories: bool,
    /// Should the prompt allow multiple files to be selected?
    pub multiple: bool,
    /// The prompt to show to a user when selecting a path
    pub prompt: Option<SharedString>,
}

/// Severity passed to a native or custom prompt renderer.
///
/// Native backends use it for alert styling. The built-in
/// [`FallbackPromptRenderer`](crate::FallbackPromptRenderer) currently uses
/// the same appearance for all three levels. This value does not change
/// the answer list or the meaning of its indices.
#[derive(Copy, Clone, Debug, PartialEq)]
pub enum PromptLevel {
    /// Information or a routine decision.
    Info,

    /// A decision with a potentially unwanted consequence.
    Warning,

    /// A serious failure or urgent decision.
    Critical,
}

/// A prompt answer's visible label and conventional role.
///
/// Pass these to [`Window::prompt`] in the desired answer order. Its result
/// is the answer's index in that slice, regardless of visual button placement.
/// Use at most one `Ok` and one `Cancel`: the Windows backend maps each role
/// to one native button ID, so duplicate roles cannot be distinguished there.
///
/// The role guides native behavior and the built-in fallback's keyboard
/// handling; it does not describe the answer's safety. A destructive answer
/// still needs an explicit label, such as “Discard changes.”
///
/// Converting an `&str` recognizes `"ok"` and `"cancel"` without regard to
/// case and uses the canonical labels `"OK"` and `"Cancel"`. Other strings
/// become `Other` unchanged. Use the constructors to choose the role and label
/// independently: `PromptButton::new("Cancel")` deliberately remains `Other`.
///
/// ```
/// use gpui::PromptButton;
///
/// let answers = [
///     PromptButton::cancel("Keep editing"),
///     PromptButton::ok("Discard changes"),
/// ];
/// assert!(answers[0].is_cancel());
/// assert_eq!(answers[1].label().as_ref(), "Discard changes");
/// ```
#[derive(Clone, Debug, PartialEq)]
pub enum PromptButton {
    /// The affirmative or default answer, with an application-chosen label.
    Ok(SharedString),
    /// The cancellation answer, with an application-chosen label.
    Cancel(SharedString),
    /// An answer with no conventional affirmative or cancellation role.
    Other(SharedString),
}

impl PromptButton {
    /// Creates an [`Other`](Self::Other) answer without inferring a role from its label.
    pub fn new(label: impl Into<SharedString>) -> Self {
        PromptButton::Other(label.into())
    }

    /// Creates an [`Ok`](Self::Ok) answer with `label`.
    pub fn ok(label: impl Into<SharedString>) -> Self {
        PromptButton::Ok(label.into())
    }

    /// Creates a [`Cancel`](Self::Cancel) answer with `label`.
    pub fn cancel(label: impl Into<SharedString>) -> Self {
        PromptButton::Cancel(label.into())
    }

    /// Returns true if this button is a cancel button.
    #[allow(dead_code)]
    pub fn is_cancel(&self) -> bool {
        matches!(self, PromptButton::Cancel(_))
    }

    /// Returns the visible label, independently of the answer's role.
    pub fn label(&self) -> &SharedString {
        match self {
            PromptButton::Ok(label) => label,
            PromptButton::Cancel(label) => label,
            PromptButton::Other(label) => label,
        }
    }
}

impl From<&str> for PromptButton {
    fn from(value: &str) -> Self {
        match value.to_lowercase().as_str() {
            "ok" => PromptButton::Ok("OK".into()),
            "cancel" => PromptButton::Cancel("Cancel".into()),
            _ => PromptButton::Other(SharedString::from(value.to_owned())),
        }
    }
}

/// The style of the cursor (pointer)
#[derive(Copy, Clone, Default, Debug, PartialEq, Eq, Hash, Serialize, Deserialize, JsonSchema)]
pub enum CursorStyle {
    /// The default cursor
    #[default]
    Arrow,

    /// A text input cursor
    /// corresponds to the CSS cursor value `text`
    IBeam,

    /// A crosshair cursor
    /// corresponds to the CSS cursor value `crosshair`
    Crosshair,

    /// A closed hand cursor
    /// corresponds to the CSS cursor value `grabbing`
    ClosedHand,

    /// An open hand cursor
    /// corresponds to the CSS cursor value `grab`
    OpenHand,

    /// A pointing hand cursor
    /// corresponds to the CSS cursor value `pointer`
    PointingHand,

    /// A resize left cursor
    /// corresponds to the CSS cursor value `w-resize`
    ResizeLeft,

    /// A resize right cursor
    /// corresponds to the CSS cursor value `e-resize`
    ResizeRight,

    /// A resize cursor to the left and right
    /// corresponds to the CSS cursor value `ew-resize`
    ResizeLeftRight,

    /// A resize up cursor
    /// corresponds to the CSS cursor value `n-resize`
    ResizeUp,

    /// A resize down cursor
    /// corresponds to the CSS cursor value `s-resize`
    ResizeDown,

    /// A resize cursor directing up and down
    /// corresponds to the CSS cursor value `ns-resize`
    ResizeUpDown,

    /// A resize cursor directing up-left and down-right
    /// corresponds to the CSS cursor value `nesw-resize`
    ResizeUpLeftDownRight,

    /// A resize cursor directing up-right and down-left
    /// corresponds to the CSS cursor value `nwse-resize`
    ResizeUpRightDownLeft,

    /// A cursor indicating that the item/column can be resized horizontally.
    /// corresponds to the CSS cursor value `col-resize`
    ResizeColumn,

    /// A cursor indicating that the item/row can be resized vertically.
    /// corresponds to the CSS cursor value `row-resize`
    ResizeRow,

    /// A text input cursor for vertical layout
    /// corresponds to the CSS cursor value `vertical-text`
    IBeamCursorForVerticalLayout,

    /// A cursor indicating that the operation is not allowed
    /// corresponds to the CSS cursor value `not-allowed`
    OperationNotAllowed,

    /// A cursor indicating that the operation will result in a link
    /// corresponds to the CSS cursor value `alias`
    DragLink,

    /// A cursor indicating that the operation will result in a copy
    /// corresponds to the CSS cursor value `copy`
    DragCopy,

    /// A cursor indicating that the operation will result in a context menu
    /// corresponds to the CSS cursor value `context-menu`
    ContextualMenu,
}

/// Clipboard content represented as an ordered sequence of entries.
///
/// Entries can contain text, encoded images, or external file paths. A platform
/// may support only some of them. Use [`Self::text`] for a plain-text paste;
/// inspect [`Self::entries`] when preserving richer content matters. Transfer
/// the item through [`App::write_to_clipboard`] or [`InputHandler::paste`].
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct ClipboardItem {
    /// The entries in this clipboard item.
    pub entries: Vec<ClipboardEntry>,
}

/// An error produced by [`Platform::read_from_clipboard_async`].
///
/// Callers surface these failures to users, so the variants distinguish
/// conditions that call for different user-facing guidance.
#[derive(Clone, Debug, PartialEq, Eq)]
pub enum ClipboardReadError {
    /// The platform clipboard is not available in this context, e.g. the
    /// browser does not expose the async clipboard API or the page is not a
    /// secure context.
    Unavailable,
    /// The platform refused access, e.g. the user declined the browser's
    /// clipboard permission prompt or paste confirmation.
    Denied(String),
    /// The clipboard contents could not be converted into a
    /// [`ClipboardItem`].
    UnsupportedContent,
}

impl std::fmt::Display for ClipboardReadError {
    fn fmt(&self, formatter: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Self::Unavailable => formatter.write_str("the clipboard is unavailable"),
            Self::Denied(message) => {
                write!(formatter, "clipboard access was denied: {message}")
            }
            Self::UnsupportedContent => {
                formatter.write_str("the clipboard contents are unsupported")
            }
        }
    }
}

impl std::error::Error for ClipboardReadError {}

/// One text, image, or external-path entry in a [`ClipboardItem`].
#[derive(Clone, Debug, Eq, PartialEq)]
pub enum ClipboardEntry {
    /// A string entry
    String(ClipboardString),
    /// An image entry
    Image(Image),
    /// A file entry
    ExternalPaths(crate::ExternalPaths),
}

impl ClipboardItem {
    /// Create an item containing one plain-text entry.
    pub fn new_string(text: String) -> Self {
        Self {
            entries: vec![ClipboardEntry::String(ClipboardString::new(text))],
        }
    }

    /// Create one text entry with application-defined metadata.
    ///
    /// Other applications and platform clipboard APIs need not preserve the metadata.
    pub fn new_string_with_metadata(text: String, metadata: String) -> Self {
        Self {
            entries: vec![ClipboardEntry::String(ClipboardString {
                text,
                metadata: Some(metadata),
            })],
        }
    }

    /// Create one text entry after serializing its metadata as JSON.
    ///
    /// # Panics
    ///
    /// Panics if `metadata` cannot be serialized. To handle serialization errors,
    /// serialize it first and call [`Self::new_string_with_metadata`].
    pub fn new_string_with_json_metadata<T: Serialize>(text: String, metadata: T) -> Self {
        Self {
            entries: vec![ClipboardEntry::String(
                ClipboardString::new(text).with_json_metadata(metadata),
            )],
        }
    }

    /// Create one image entry by cloning the encoded [`Image`].
    pub fn new_image(image: &Image) -> Self {
        Self {
            entries: vec![ClipboardEntry::Image(image.clone())],
        }
    }

    /// Flatten the item to nonempty text, with no separators between entries.
    ///
    /// Text entries take precedence. If their concatenation is empty, concatenate
    /// the display forms of external file paths instead. Image entries contribute
    /// nothing. Returns `None` if neither source produces any text, including an
    /// item containing only an empty string.
    ///
    /// ```
    /// use gpui::{ClipboardEntry, ClipboardItem};
    ///
    /// let item = ClipboardItem {
    ///     entries: vec![ClipboardEntry::from("one".to_owned()), "two".to_owned().into()],
    /// };
    /// assert_eq!(item.text().as_deref(), Some("onetwo"));
    /// assert_eq!(ClipboardItem::new_string(String::new()).text(), None);
    /// ```
    pub fn text(&self) -> Option<String> {
        let mut answer = String::new();

        for entry in self.entries.iter() {
            if let ClipboardEntry::String(ClipboardString { text, metadata: _ }) = entry {
                answer.push_str(text);
            }
        }

        if answer.is_empty() {
            for entry in self.entries.iter() {
                if let ClipboardEntry::ExternalPaths(paths) = entry {
                    for path in &paths.0 {
                        use std::fmt::Write as _;
                        _ = write!(answer, "{}", path.display());
                    }
                }
            }
        }

        if !answer.is_empty() {
            Some(answer)
        } else {
            None
        }
    }

    /// Read metadata only when the item consists of exactly one text entry.
    #[cfg_attr(not(target_os = "windows"), allow(dead_code))]
    pub fn metadata(&self) -> Option<&String> {
        match self.entries().first() {
            Some(ClipboardEntry::String(clipboard_string)) if self.entries.len() == 1 => {
                clipboard_string.metadata.as_ref()
            }
            _ => None,
        }
    }

    /// Borrow the entries in their original order.
    pub fn entries(&self) -> &[ClipboardEntry] {
        &self.entries
    }

    /// Consume the item and iterate over its entries in order.
    pub fn into_entries(self) -> impl Iterator<Item = ClipboardEntry> {
        self.entries.into_iter()
    }
}

impl From<ClipboardString> for ClipboardEntry {
    fn from(value: ClipboardString) -> Self {
        Self::String(value)
    }
}

impl From<String> for ClipboardEntry {
    fn from(value: String) -> Self {
        Self::from(ClipboardString::from(value))
    }
}

impl From<Image> for ClipboardEntry {
    fn from(value: Image) -> Self {
        Self::Image(value)
    }
}

impl From<ClipboardEntry> for ClipboardItem {
    fn from(value: ClipboardEntry) -> Self {
        Self {
            entries: vec![value],
        }
    }
}

impl From<String> for ClipboardItem {
    fn from(value: String) -> Self {
        Self::from(ClipboardEntry::from(value))
    }
}

impl From<Image> for ClipboardItem {
    fn from(value: Image) -> Self {
        Self::from(ClipboardEntry::from(value))
    }
}

/// One of the editor's supported image formats (e.g. PNG, JPEG) - used when dealing with images in the clipboard
#[derive(Clone, Copy, Debug, Eq, PartialEq, EnumIter, Hash)]
pub enum ImageFormat {
    // Sorted from most to least likely to be pasted into an editor,
    // which matters when we iterate through them trying to see if
    // clipboard content matches them.
    /// .png
    Png,
    /// .jpeg or .jpg
    Jpeg,
    /// .webp
    Webp,
    /// .gif
    Gif,
    /// .svg
    Svg,
    /// .bmp
    Bmp,
    /// .tif or .tiff
    Tiff,
    /// .ico
    Ico,
    /// Netpbm image formats (.pbm, .ppm, .pgm).
    Pnm,
}

impl ImageFormat {
    /// Returns the mime type for the ImageFormat
    pub const fn mime_type(self) -> &'static str {
        match self {
            ImageFormat::Png => "image/png",
            ImageFormat::Jpeg => "image/jpeg",
            ImageFormat::Webp => "image/webp",
            ImageFormat::Gif => "image/gif",
            ImageFormat::Svg => "image/svg+xml",
            ImageFormat::Bmp => "image/bmp",
            ImageFormat::Tiff => "image/tiff",
            ImageFormat::Ico => "image/ico",
            ImageFormat::Pnm => "image/x-portable-anymap",
        }
    }

    /// Returns the file extension for this image format (without leading dot).
    pub const fn extension(self) -> &'static str {
        match self {
            ImageFormat::Png => "png",
            ImageFormat::Jpeg => "jpg",
            ImageFormat::Webp => "webp",
            ImageFormat::Gif => "gif",
            ImageFormat::Svg => "svg",
            ImageFormat::Bmp => "bmp",
            ImageFormat::Tiff => "tiff",
            ImageFormat::Ico => "ico",
            ImageFormat::Pnm => "pnm",
        }
    }

    /// Returns the ImageFormat for the given mime type, including known aliases.
    pub fn from_mime_type(mime_type: &str) -> Option<Self> {
        use strum::IntoEnumIterator;
        Self::iter()
            .find(|format| format.mime_type() == mime_type)
            .or_else(|| Self::from_mime_type_alias(mime_type))
    }

    /// Non-canonical mime types that some producers use in the wild.
    /// Unlike `mime_type()` which returns the single canonical form,
    /// these are legacy or shortened variants we still need to recognize.
    fn from_mime_type_alias(mime_type: &str) -> Option<Self> {
        match mime_type {
            "image/jpg" => Some(Self::Jpeg),
            "image/tif" => Some(Self::Tiff),
            _ => None,
        }
    }
}

/// Encoded image bytes with an explicit file format.
///
/// Creating an `Image` does not decode it. Use [`crate::img`] to load it
/// asynchronously, or [`Self::to_image_data`] when synchronous decoding is
/// appropriate. [`RenderImage`] holds the decoded frames used for painting.
/// Keep the bytes, format, and ID consistent when sharing this value through
/// `Arc`; the asset cache uses its ID when hashing it.
#[derive(Clone, Debug, PartialEq, Eq)]
pub struct Image {
    /// The image format the bytes represent (e.g. PNG)
    pub format: ImageFormat,
    /// Encoded file bytes, such as a complete PNG file, rather than raw pixels.
    pub bytes: Vec<u8>,
    /// A content hash used for asset lookup; it is not a guaranteed unique ID.
    pub id: u64,
}

pub(crate) fn decode_static_image(
    bytes: &[u8],
    format: image::ImageFormat,
) -> Result<SmallVec<[Frame; 1]>> {
    let decoder = image::ImageReader::with_format(Cursor::new(bytes), format)
        .into_decoder()
        .context("creating image decoder")?;
    decode_static_image_from_decoder(decoder)
}

pub(crate) fn decode_static_image_from_decoder(
    mut decoder: impl image::ImageDecoder,
) -> Result<SmallVec<[Frame; 1]>> {
    let orientation = decoder
        .orientation()
        .context("reading decoder's orientation")?;
    let mut image = DynamicImage::from_decoder(decoder).context("decoding image")?;
    image.apply_orientation(orientation);

    let mut data = image.into_rgba8();
    for pixel in data.chunks_exact_mut(4) {
        pixel.swap(0, 2);
    }

    Ok(SmallVec::from_elem(Frame::new(data), 1))
}

impl Hash for Image {
    fn hash<H: Hasher>(&self, state: &mut H) {
        state.write_u64(self.id);
    }
}

impl Image {
    /// Creates a PNG-format value with no bytes.
    ///
    /// This is a placeholder, not a valid encoded image. Decoding it fails.
    pub fn empty() -> Self {
        Self::from_bytes(ImageFormat::Png, Vec::new())
    }

    /// Stores encoded bytes and computes their content hash.
    ///
    /// This does not validate that the bytes match `format`. Decoding reports
    /// an invalid file later; use [`Self::to_image_data`] to decode immediately.
    pub fn from_bytes(format: ImageFormat, bytes: Vec<u8>) -> Self {
        Self {
            id: hash(&bytes),
            format,
            bytes,
        }
    }

    /// Returns the content hash assigned by [`Self::from_bytes`].
    pub fn id(&self) -> u64 {
        self.id
    }

    /// Starts or polls asynchronous decoding through [`Window::use_asset`].
    ///
    /// Returns `None` while decoding is pending or if it fails. The request that
    /// first starts the load arranges a notification for its current view.
    /// Failures are logged; use an [`ImageSource::Custom`] loader when the UI
    /// needs to distinguish an error from a pending result.
    pub fn use_render_image(
        self: Arc<Self>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Arc<RenderImage>> {
        ImageSource::Image(self)
            .use_data(None, window, cx)
            .and_then(|result| result.ok())
    }

    /// Starts or polls decoding without arranging a view notification.
    ///
    /// Like [`Self::use_render_image`], this returns `None` for both pending
    /// loads and failures. The caller must arrange a redraw to poll again.
    pub fn get_render_image(
        self: Arc<Self>,
        window: &mut Window,
        cx: &mut App,
    ) -> Option<Arc<RenderImage>> {
        ImageSource::Image(self)
            .get_data(None, window, cx)
            .and_then(|result| result.ok())
    }

    /// Removes the cached decoding request or result for these encoded bytes.
    ///
    /// This does not release renderer uploads. Use [`App::drop_image`] when a
    /// decoded [`RenderImage`] is no longer needed by the windows.
    pub fn remove_asset(self: Arc<Self>, cx: &mut App) {
        ImageSource::Image(self).remove_asset(cx);
    }

    /// Check whether this image is present in GPUI's asset cache (loading or
    /// loaded), without fetching it.
    #[cfg(any(test, feature = "headless"))]
    pub fn is_asset_cached(self: &Arc<Self>, cx: &App) -> bool {
        ImageSource::Image(self.clone()).is_asset_cached(cx)
    }

    /// Decodes these bytes synchronously into renderer-ready BGRA frames.
    ///
    /// GIF preserves its animation frames. Other raster formats, including WebP,
    /// use the static decoder and apply image orientation. SVG uses the supplied
    /// renderer at scale `1.0`. Invalid or unsupported data returns an error.
    /// This can be expensive; [`Self::use_render_image`] moves decoding off the
    /// foreground thread.
    pub fn to_image_data(&self, svg_renderer: SvgRenderer) -> Result<Arc<RenderImage>> {
        let frames = match self.format {
            ImageFormat::Gif => {
                let decoder = GifDecoder::new(Cursor::new(&self.bytes))?;
                let mut frames = SmallVec::new();

                for frame in decoder.into_frames() {
                    match frame {
                        Ok(mut frame) => {
                            // Convert from RGBA to BGRA.
                            for pixel in frame.buffer_mut().chunks_exact_mut(4) {
                                pixel.swap(0, 2);
                            }
                            frames.push(frame);
                        }
                        Err(err) => {
                            log::debug!("Skipping GIF frame due to decode error: {err}");
                        }
                    }
                }

                if frames.is_empty() {
                    anyhow::bail!("GIF could not be decoded: all frames failed");
                }

                frames
            }
            ImageFormat::Png => decode_static_image(&self.bytes, image::ImageFormat::Png)?,
            ImageFormat::Jpeg => decode_static_image(&self.bytes, image::ImageFormat::Jpeg)?,
            ImageFormat::Webp => decode_static_image(&self.bytes, image::ImageFormat::WebP)?,
            ImageFormat::Bmp => decode_static_image(&self.bytes, image::ImageFormat::Bmp)?,
            ImageFormat::Tiff => decode_static_image(&self.bytes, image::ImageFormat::Tiff)?,
            ImageFormat::Ico => decode_static_image(&self.bytes, image::ImageFormat::Ico)?,
            ImageFormat::Svg => {
                return svg_renderer
                    .render_single_frame(&self.bytes, 1.0)
                    .map_err(Into::into);
            }
            ImageFormat::Pnm => decode_static_image(&self.bytes, image::ImageFormat::Pnm)?,
        };

        Ok(Arc::new(RenderImage::new(frames)))
    }

    /// Get the format of the clipboard image
    pub fn format(&self) -> ImageFormat {
        self.format
    }

    /// Get the raw bytes of the clipboard image
    pub fn bytes(&self) -> &[u8] {
        self.bytes.as_slice()
    }
}

/// Text with optional application-defined clipboard metadata.
///
/// The metadata is an opaque string. [`Self::with_json_metadata`] and
/// [`Self::metadata_json`] provide a JSON convention for applications sharing
/// structured text. It is not part of the plain text returned by
/// [`ClipboardItem::text`], and another application may discard it.
#[derive(Clone, Debug, Eq, PartialEq)]
pub struct ClipboardString {
    /// The text content.
    pub text: String,
    /// Optional metadata associated with this clipboard string.
    pub metadata: Option<String>,
}

impl ClipboardString {
    /// Create a new clipboard string with the given text
    pub fn new(text: String) -> Self {
        Self {
            text,
            metadata: None,
        }
    }

    /// Replace the metadata with the JSON encoding of `metadata`.
    ///
    /// # Panics
    ///
    /// Panics if serialization fails, for example for a map with keys that JSON
    /// cannot represent. Serialize separately and set [`Self::metadata`] when
    /// the error needs to be handled.
    pub fn with_json_metadata<T: Serialize>(mut self, metadata: T) -> Self {
        self.metadata = Some(serde_json::to_string(&metadata).unwrap());
        self
    }

    /// Get the text of the clipboard string
    pub fn text(&self) -> &String {
        &self.text
    }

    /// Get the owned text of the clipboard string
    pub fn into_text(self) -> String {
        self.text
    }

    /// Decode metadata as JSON into `T`.
    ///
    /// Returns `None` for absent metadata, invalid JSON, or a value that cannot
    /// be deserialized as `T`.
    pub fn metadata_json<T>(&self) -> Option<T>
    where
        T: for<'a> Deserialize<'a>,
    {
        self.metadata
            .as_ref()
            .and_then(|m| serde_json::from_str(m).ok())
    }

    #[cfg_attr(any(target_os = "linux", target_os = "freebsd"), allow(dead_code))]
    /// Compute a hash of the given text for clipboard change detection.
    pub fn text_hash(text: &str) -> u64 {
        let mut hasher = SeaHasher::new();
        text.hash(&mut hasher);
        hasher.finish()
    }
}

impl From<String> for ClipboardString {
    fn from(value: String) -> Self {
        Self {
            text: value,
            metadata: None,
        }
    }
}

#[cfg(test)]
mod image_tests {
    use crate::{AssetRegistry, size};

    use super::*;
    use std::sync::Arc;

    #[test]
    fn test_image_to_image_data_applies_exif_orientation() {
        let image = Image::from_bytes(
            ImageFormat::Jpeg,
            include_bytes!("../examples/assets/images/exif-orientation-rotate-180.jpg").to_vec(),
        );

        let render_image = image
            .to_image_data(SvgRenderer::new(Arc::new(AssetRegistry::default())))
            .unwrap();

        assert_eq!(render_image.size(0), size(16.into(), 32.into()));

        let bytes = render_image.as_bytes(0).unwrap();
        assert_eq!(&bytes[..4], &[255, 255, 255, 255]);
        assert_eq!(&bytes[(16 * 32 - 1) * 4..], &[0, 0, 0, 255]);
    }

    #[test]
    fn test_svg_image_to_image_data_converts_to_bgra() {
        let image = Image::from_bytes(
            ImageFormat::Svg,
            br##"<svg xmlns="http://www.w3.org/2000/svg" width="1" height="1">
<rect width="1" height="1" fill="#38BDF8"/>
</svg>"##
                .to_vec(),
        );

        let render_image = image
            .to_image_data(SvgRenderer::new(Arc::new(AssetRegistry::default())))
            .unwrap();
        let bytes = render_image.as_bytes(0).unwrap();

        for pixel in bytes.chunks_exact(4) {
            assert_eq!(pixel, &[0xF8, 0xBD, 0x38, 0xFF]);
        }
    }
}

#[cfg(all(test, any(target_os = "linux", target_os = "freebsd")))]
mod window_button_layout_tests {
    use super::*;
    use std::collections::HashSet;

    #[test]
    fn test_window_button_layout_parse_standard() {
        let layout = WindowButtonLayout::parse("close,minimize:maximize").unwrap();
        assert_eq!(
            layout.left,
            [
                Some(WindowButton::Close),
                Some(WindowButton::Minimize),
                None
            ]
        );
        assert_eq!(layout.right, [Some(WindowButton::Maximize), None, None]);
    }

    #[test]
    fn test_window_button_layout_parse_right_only() {
        let layout = WindowButtonLayout::parse("minimize,maximize,close").unwrap();
        assert_eq!(layout.left, [None, None, None]);
        assert_eq!(
            layout.right,
            [
                Some(WindowButton::Minimize),
                Some(WindowButton::Maximize),
                Some(WindowButton::Close)
            ]
        );
    }

    #[test]
    fn test_window_button_layout_parse_left_only() {
        let layout = WindowButtonLayout::parse("close,minimize,maximize:").unwrap();
        assert_eq!(
            layout.left,
            [
                Some(WindowButton::Close),
                Some(WindowButton::Minimize),
                Some(WindowButton::Maximize)
            ]
        );
        assert_eq!(layout.right, [None, None, None]);
    }

    #[test]
    fn test_window_button_layout_parse_with_whitespace() {
        let layout = WindowButtonLayout::parse(" close , minimize : maximize ").unwrap();
        assert_eq!(
            layout.left,
            [
                Some(WindowButton::Close),
                Some(WindowButton::Minimize),
                None
            ]
        );
        assert_eq!(layout.right, [Some(WindowButton::Maximize), None, None]);
    }

    #[test]
    fn test_window_button_layout_parse_empty() {
        let layout = WindowButtonLayout::parse("").unwrap();
        assert_eq!(layout.left, [None, None, None]);
        assert_eq!(layout.right, [None, None, None]);
    }

    #[test]
    fn test_window_button_layout_parse_intentionally_empty() {
        let layout = WindowButtonLayout::parse(":").unwrap();
        assert_eq!(layout.left, [None, None, None]);
        assert_eq!(layout.right, [None, None, None]);
    }

    #[test]
    fn test_window_button_layout_parse_invalid_buttons() {
        let layout = WindowButtonLayout::parse("close,invalid,minimize:maximize,foo").unwrap();
        assert_eq!(
            layout.left,
            [
                Some(WindowButton::Close),
                Some(WindowButton::Minimize),
                None
            ]
        );
        assert_eq!(layout.right, [Some(WindowButton::Maximize), None, None]);
    }

    #[test]
    fn test_window_button_layout_parse_deduplicates_same_side_buttons() {
        let layout = WindowButtonLayout::parse("close,close,minimize").unwrap();
        assert_eq!(
            layout.right,
            [
                Some(WindowButton::Close),
                Some(WindowButton::Minimize),
                None
            ]
        );
        assert_eq!(layout.format(), ":close,minimize");
    }

    #[test]
    fn test_window_button_layout_parse_deduplicates_buttons_across_sides() {
        let layout = WindowButtonLayout::parse("close:maximize,close,minimize").unwrap();
        assert_eq!(layout.left, [Some(WindowButton::Close), None, None]);
        assert_eq!(
            layout.right,
            [
                Some(WindowButton::Maximize),
                Some(WindowButton::Minimize),
                None
            ]
        );

        let button_ids: Vec<_> = layout
            .left
            .iter()
            .chain(layout.right.iter())
            .flatten()
            .map(WindowButton::id)
            .collect();
        let unique_button_ids = button_ids.iter().copied().collect::<HashSet<_>>();
        assert_eq!(unique_button_ids.len(), button_ids.len());
        assert_eq!(layout.format(), "close:maximize,minimize");
    }

    #[test]
    fn test_window_button_layout_parse_gnome_style() {
        let layout = WindowButtonLayout::parse("close").unwrap();
        assert_eq!(layout.left, [None, None, None]);
        assert_eq!(layout.right, [Some(WindowButton::Close), None, None]);
    }

    #[test]
    fn test_window_button_layout_parse_elementary_style() {
        let layout = WindowButtonLayout::parse("close:maximize").unwrap();
        assert_eq!(layout.left, [Some(WindowButton::Close), None, None]);
        assert_eq!(layout.right, [Some(WindowButton::Maximize), None, None]);
    }

    #[test]
    fn test_window_button_layout_round_trip() {
        let cases = [
            "close:minimize,maximize",
            "minimize,maximize,close:",
            ":close",
            "close:",
            "close:maximize",
            ":",
        ];

        for case in cases {
            let layout = WindowButtonLayout::parse(case).unwrap();
            assert_eq!(layout.format(), case, "Round-trip failed for: {}", case);
        }
    }

    #[test]
    fn test_window_button_layout_linux_default() {
        let layout = WindowButtonLayout::linux_default();
        assert_eq!(layout.left, [None, None, None]);
        assert_eq!(
            layout.right,
            [
                Some(WindowButton::Minimize),
                Some(WindowButton::Maximize),
                Some(WindowButton::Close)
            ]
        );

        let round_tripped = WindowButtonLayout::parse(&layout.format()).unwrap();
        assert_eq!(round_tripped, layout);
    }

    #[test]
    fn test_window_button_layout_parse_all_invalid() {
        assert!(WindowButtonLayout::parse("asdfghjkl").is_err());
    }
}
