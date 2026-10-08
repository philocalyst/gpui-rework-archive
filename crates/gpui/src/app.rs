//! Application state, entities, windows, and the contexts used to access them.
//!
//! [`Application`] owns the platform run loop. Once it is running, [`App`] is
//! the root synchronous context for entities, globals, windows, executors,
//! and system services. Entity and asynchronous contexts provide scoped access
//! to that same application. Cloning an entity handle retains its value;
//! reading or updating the value requires an [`AppContext`]. See the
//! [counter walkthrough](https://gpui-ce.github.io/examples/counter/#state) for
//! the smallest complete example, and the [update walkthrough](https://gpui-ce.github.io/examples/counter/#update)
//! for the access rules in practice.

use crate::{
    Action, ActionBuildError, ActionRegistry, Any, AnyView, AnyWindowHandle, AppContext, Arena,
    ArenaBox, Asset, AssetRegistry, BackgroundExecutor, Bounds, ClipboardItem, ClipboardReadError,
    CursorStyle, DispatchPhase, DisplayId, EventEmitter, ExternalDragPayload, FocusHandle,
    FocusMap, ForegroundExecutor, Global, HapticFeedbackStyle, KeyBinding, KeyContext, Keymap,
    Keystroke, LayoutId, Menu, MenuItem, OwnedMenu, PathPromptOptions, Pixels, Platform,
    PlatformDisplay, PlatformKeyboardLayout, PlatformKeyboardMapper, Point, Priority,
    PromptBuilder, PromptButton, PromptHandle, PromptLevel, Render, RenderImage,
    RenderablePromptHandle, Reservation, ScreenCaptureSource, SharedString, SubscriberSet,
    Subscription, SvgRenderer, SystemNotification, SystemNotificationResponse, Task,
    TextRenderingMode, TextSystem, ThermalState, Window, WindowAppearance, WindowButtonLayout,
    WindowHandle, WindowId, WindowInvalidator,
    colors::{Colors, GlobalColors},
    hash,
    http_client::{HttpClient, NullHttpClient},
    init_app_menus,
};
use anyhow::{Context as _, Result, anyhow};
use collections::{FxHashMap, FxHashSet, HashMap, TypeIdHashMap, TypeIdHashSet, VecDeque};
use derive_more::{Deref, DerefMut};
use futures::{
    Future, FutureExt,
    channel::oneshot,
    future::{LocalBoxFuture, Shared},
};
use gpui_util::{ResultExt, debug_panic};
use itertools::Itertools;
use parking_lot::RwLock;
use scheduler::Instant;
use slotmap::SlotMap;
use smallvec::SmallVec;
use std::{
    any::{TypeId, type_name},
    cell::{BorrowMutError, Cell, Ref, RefCell, RefMut},
    ffi::OsString,
    marker::PhantomData,
    mem,
    ops::{Deref, DerefMut},
    path::{Path, PathBuf},
    rc::{Rc, Weak},
    sync::{Arc, atomic::Ordering::SeqCst},
    time::Duration,
};

mod async_context;
#[cfg(feature = "bench-support")]
mod bench_context;
mod context;
mod entity_map;
#[cfg(any(test, feature = "headless"))]
mod headless_app_context;
#[cfg(any(test, feature = "headless"))]
mod test_app;
#[cfg(any(test, feature = "headless"))]
mod test_context;
#[cfg(all(target_os = "macos", any(test, feature = "headless")))]
mod visual_test_context;

pub use async_context::*;
#[cfg(feature = "bench-support")]
pub use bench_context::{
    BenchAppContext, BenchReport, BenchWindowContext, ForegroundWorkSummary, bench_platform,
};
pub use context::*;
pub use entity_map::*;
#[cfg(any(test, feature = "headless"))]
pub use headless_app_context::*;
#[cfg(any(test, feature = "headless"))]
pub use test_app::*;
#[cfg(any(test, feature = "headless"))]
pub use test_context::*;
#[cfg(all(target_os = "macos", any(test, feature = "headless")))]
pub use visual_test_context::*;

#[cfg(any(feature = "inspector", debug_assertions))]
use crate::InspectorElementRegistry;
#[cfg(target_os = "macos")]
use crate::MacActivationPolicy;

/// The duration for which native applications wait for futures returned from
/// [Context::on_app_quit] before fully quitting.
pub const SHUTDOWN_TIMEOUT: Duration = Duration::from_millis(200);

/// Temporary(?) wrapper around [`RefCell<App>`] to help us debug any double borrows.
/// Strongly consider removing after stabilization.
#[doc(hidden)]
pub struct AppCell {
    app: RefCell<App>,
}

impl AppCell {
    #[doc(hidden)]
    #[track_caller]
    pub fn borrow(&self) -> AppRef<'_> {
        if option_env!("TRACK_THREAD_BORROWS").is_some() {
            let thread_id = std::thread::current().id();
            eprintln!("borrowed {thread_id:?}");
        }
        AppRef(self.app.borrow())
    }

    #[doc(hidden)]
    #[track_caller]
    pub fn borrow_mut(&self) -> AppRefMut<'_> {
        if option_env!("TRACK_THREAD_BORROWS").is_some() {
            let thread_id = std::thread::current().id();
            eprintln!("borrowed {thread_id:?}");
        }
        AppRefMut(self.app.borrow_mut())
    }

    #[doc(hidden)]
    #[track_caller]
    pub fn try_borrow_mut(&self) -> Result<AppRefMut<'_>, BorrowMutError> {
        if option_env!("TRACK_THREAD_BORROWS").is_some() {
            let thread_id = std::thread::current().id();
            eprintln!("borrowed {thread_id:?}");
        }
        Ok(AppRefMut(self.app.try_borrow_mut()?))
    }
}

#[doc(hidden)]
#[derive(Deref, DerefMut)]
pub struct AppRef<'a>(Ref<'a, App>);

impl Drop for AppRef<'_> {
    fn drop(&mut self) {
        if option_env!("TRACK_THREAD_BORROWS").is_some() {
            let thread_id = std::thread::current().id();
            eprintln!("dropped borrow from {thread_id:?}");
        }
    }
}

#[doc(hidden)]
#[derive(Deref, DerefMut)]
pub struct AppRefMut<'a>(RefMut<'a, App>);

impl Drop for AppRefMut<'_> {
    fn drop(&mut self) {
        if option_env!("TRACK_THREAD_BORROWS").is_some() {
            let thread_id = std::thread::current().id();
            eprintln!("dropped {thread_id:?}");
        }
    }
}

/// A platform-backed builder for starting a GPUI application.
///
/// Construct and configure this value before startup. [`run`](Self::run) owns
/// the ordinary platform run loop; embedders use [`run_embedded`](Self::run_embedded)
/// and keep its [`ApplicationHandle`] alive while their own loop drives GPUI.
/// Neither type is the state context passed to callbacks: that is [`App`].
// docs:examples:begin
#[doc = include_str!("docs/examples/gpui-Application-eb7618d3.md")]
// docs:examples:end
pub struct Application(Rc<AppCell>);

/// A strong handle to an [`Application`] started with [`Application::run_embedded`].
///
/// Dropping this handle releases the app, so an embedder must hold it for as long as the
/// app should run. While held, it is the embedder's entry point back into GPUI each time
/// the external run loop gives it control.
pub struct ApplicationHandle {
    app: Rc<AppCell>,
}

impl ApplicationHandle {
    /// Invoke `f` with exclusive access to the app.
    ///
    /// This method is the re-entry point for an embedder's event loop. It must
    /// not be called while another app update is active: the nested borrow
    /// panics. Keep the closure short and use [`AsyncApp::spawn`] for work that
    /// waits.
    ///
    /// The closure forms one app update. On normal return, GPUI processes
    /// notifications, deferred callbacks, and releases before returning the
    /// closure's result. Nested entity/window updates do not flush halfway
    /// through this closure. This does not poll queued tasks or advance a clock.
    pub fn update<R>(&self, f: impl FnOnce(&mut App) -> R) -> R {
        let cx = &mut *self.app.borrow_mut();
        cx.update(f)
    }

    /// An [`AsyncApp`] for use across await points. It holds the app weakly; keeping the
    /// app alive remains this handle's job.
    pub fn to_async(&self) -> AsyncApp {
        self.update(|cx| cx.to_async())
    }
}

/// Represents an application before it is fully launched. Once your app is
/// configured, start it with [`Application::run`].
impl Application {
    /// Builds an application around a caller-provided platform implementation.
    ///
    /// Configure assets, HTTP, and quit behavior on the returned builder before
    /// calling [`Self::run`] or [`Self::run_embedded`].
    pub fn with_platform(platform: Rc<dyn Platform>) -> Self {
        Self(App::new_app(
            platform,
            AssetRegistry::default().into(),
            Arc::new(NullHttpClient),
        ))
    }

    /// Builds an app with accessibility (AccessKit) integration forcibly
    /// disabled.
    ///
    /// In this mode, accessibility APIs (e.g.
    /// [`div().role()`][crate::StatefulInteractiveElement::role]) silently
    /// no-op.
    ///
    /// See the [accessibility guide](crate::_accessibility) for an overview of
    /// the features this disables.
    pub fn new_inaccessible(platform: Rc<dyn Platform>) -> Self {
        let this = Self::with_platform(platform);
        this.0.borrow_mut().accessibility_force_disabled = true;
        this
    }

    /// Build every window's accessibility tree every frame, even when no
    /// assistive technology is connected.
    ///
    /// For automation and tree inspection: [`crate::Window::debug_a11y_tree_json`]
    /// otherwise reports nothing until a screen reader activates the platform
    /// adapter. [`Application::new_inaccessible`] still wins when both are set.
    pub fn with_accessibility_forced(self) -> Self {
        self.0.borrow_mut().accessibility_forced = true;
        self
    }

    /// Installs the application's asset sources, including those used by SVGs.
    ///
    /// Register embedded fonts, icons, or other bundled files before startup.
    /// This replaces the existing registry; see [`AssetRegistry`] for combining
    /// multiple sources.
    pub fn with_assets(self, assets: impl Into<AssetRegistry>) -> Self {
        let mut context_lock = self.0.borrow_mut();
        let asset_registry = Arc::new(assets.into());
        context_lock.asset_registry = asset_registry.clone();
        context_lock.svg_renderer = SvgRenderer::new(asset_registry);
        drop(context_lock);
        self
    }

    /// Sets the arguments used by [`App::restart`].
    ///
    /// These replace the builder's restart argument list. They do not change
    /// the current process's arguments.
    pub fn with_restart_arguments(self, arguments: Vec<OsString>) -> Self {
        self.0.borrow_mut().restart_arguments = arguments;
        self
    }

    /// Installs the HTTP client used by app services and remote asset loading.
    ///
    /// The default [`NullHttpClient`] rejects requests. Supply a concrete
    /// [`HttpClient`] before startup when the app needs network access.
    pub fn with_http_client(self, http_client: Arc<dyn HttpClient>) -> Self {
        let mut context_lock = self.0.borrow_mut();
        context_lock.http_client = http_client;
        drop(context_lock);
        self
    }

    /// Configures when the application should automatically quit.
    /// By default, [`QuitMode::Default`] is used.
    pub fn with_quit_mode(self, mode: QuitMode) -> Self {
        self.0.borrow_mut().quit_mode = mode;
        self
    }

    /// Sets the activation policy for the application (macOS only).
    ///
    /// This determines how the application appears in the system:
    /// - `Regular`: Normal app with Dock icon and menu bar
    /// - `Accessory`: Background app without Dock icon (LSUIElement)
    /// - `Prohibited`: Runs in background, no UI allowed
    ///
    /// This must be called before the application finishes launching to take effect.
    ///
    /// # Example
    /// ```no_run
    /// # use gpui::Application;
    /// # fn configure(app: Application) -> Application {
    /// app.with_activation_policy(gpui::MacActivationPolicy::Accessory)
    /// # }
    /// ```
    #[cfg(target_os = "macos")]
    pub fn with_activation_policy(self, policy: MacActivationPolicy) -> Self {
        self.0.borrow().platform.set_mac_activation_policy(policy);
        self
    }

    /// Starts the platform run loop and invokes `on_finish_launching` once.
    ///
    /// On native platforms this call normally blocks until the app quits. On
    /// Wasm the browser owns the loop, so startup is scheduled and this method
    /// returns; the application is retained for the page lifetime.
    // docs:examples:begin
    #[doc = include_str!("docs/examples/gpui-Application-run-d0b8e587.md")]
    // docs:examples:end
    pub fn run<F>(self, on_finish_launching: F)
    where
        F: 'static + FnOnce(&mut App),
    {
        #[cfg(all(
            feature = "hot-patching",
            debug_assertions,
            not(target_family = "wasm")
        ))]
        dioxus_devtools::connect_subsecond();

        let this = self.0.clone();
        let platform = self.0.borrow().platform.clone();
        platform.run(Box::new(move || {
            let cx = &mut *this.borrow_mut();
            on_finish_launching(cx);
        }));

        // Native platform run loops block until shutdown, keeping `self` alive for the
        // application's lifetime. The web platform schedules startup and returns
        // immediately, so retain the application until the browser tears down the page.
        #[cfg(target_family = "wasm")]
        std::mem::forget(self);
    }

    /// Start the application for an embedder that drives the run loop itself.
    ///
    /// On ordinary platforms `Platform::run` blocks for the lifetime of the app, and the
    /// app state is kept alive by [`Application::run`]'s stack frame. Embedded platforms —
    /// where the run loop belongs to someone else, e.g. GPUI compiled into a Wasm guest,
    /// or a GPUI view hosted inside a foreign native application — implement
    /// `Platform::run` to invoke the launch callback and return immediately. This method
    /// supports that shape: it returns an [`ApplicationHandle`] that keeps the app alive
    /// and lets the embedder re-enter it whenever the external run loop yields control.
    pub fn run_embedded<F>(self, on_finish_launching: F) -> ApplicationHandle
    where
        F: 'static + FnOnce(&mut App),
    {
        let this = self.0.clone();
        let platform = self.0.borrow().platform.clone();
        platform.run(Box::new(move || {
            let cx = &mut *this.borrow_mut();
            on_finish_launching(cx);
        }));
        ApplicationHandle { app: self.0 }
    }

    /// Registers the handler for URLs delivered by the platform.
    ///
    /// Register before [`Self::run`]. The platform retains one handler for the
    /// application; a later registration replaces the earlier one. Backends
    /// that do not deliver external URLs never invoke it.
    pub fn on_open_urls<F>(&self, mut callback: F) -> &Self
    where
        F: 'static + FnMut(Vec<String>),
    {
        self.0.borrow().platform.on_open_urls(Box::new(callback));
        self
    }

    /// Registers a handler for a platform request to reopen the running app.
    ///
    /// On macOS this can happen when the user clicks the app icon in the Dock.
    /// The handler receives synchronous [`App`] access and should return
    /// promptly. Backends without a reopen event never invoke it; a later
    /// registration replaces the earlier handler.
    pub fn on_reopen<F>(&self, mut callback: F) -> &Self
    where
        F: 'static + FnMut(&mut App),
    {
        let this = Rc::downgrade(&self.0);
        self.0.borrow_mut().platform.on_reopen(Box::new(move || {
            if let Some(app) = this.upgrade() {
                callback(&mut app.borrow_mut());
            }
        }));
        self
    }

    /// Returns the background executor configured for this application.
    ///
    /// Use it for owned `Send` work that can run without UI access; return
    /// results through a foreground task before updating entities or windows.
    pub fn background_executor(&self) -> BackgroundExecutor {
        self.0.borrow().background_executor.clone()
    }

    /// Returns the foreground executor configured for this application.
    ///
    /// Foreground futures are polled on the UI thread and must not block while
    /// doing long CPU or I/O work. Use the background executor for that work.
    pub fn foreground_executor(&self) -> ForegroundExecutor {
        self.0.borrow().foreground_executor.clone()
    }

    /// Returns a shared handle to the text system configured for this app.
    ///
    /// The returned `Arc` can be retained independently of the application
    /// builder and is also available from the live [`App`].
    pub fn text_system(&self) -> Arc<TextSystem> {
        self.0.borrow().text_system.clone()
    }

    /// Locates a helper executable named `name` according to platform bundle conventions.
    ///
    /// This is useful for native applications that ship helper binaries with
    /// their app bundle. The platform may return an error when helper lookup
    /// is unsupported or the executable is absent.
    pub fn path_for_auxiliary_executable(&self, name: &str) -> Result<PathBuf> {
        self.0.borrow().path_for_auxiliary_executable(name)
    }
}

type Handler = Box<dyn FnMut(&mut App) -> bool + 'static>;
type Listener = Box<dyn FnMut(&dyn Any, &mut App) -> bool + 'static>;
pub(crate) type KeystrokeObserver =
    Box<dyn FnMut(&KeystrokeEvent, &mut Window, &mut App) -> bool + 'static>;
type QuitHandler = Box<dyn FnOnce(&mut App) -> LocalBoxFuture<'static, ()> + 'static>;
type WindowClosedHandler = Box<dyn FnMut(&mut App, WindowId)>;
type ReleaseListener = Box<dyn FnOnce(&mut dyn Any, &mut App) + 'static>;
type NewEntityListener = Box<dyn FnMut(AnyEntity, &mut Option<&mut Window>, &mut App) + 'static>;

/// Defines when the application should automatically quit.
#[derive(Debug, Clone, Copy, PartialEq, Eq, Default)]
pub enum QuitMode {
    /// Use [`QuitMode::Explicit`] on macOS and [`QuitMode::LastWindowClosed`] on other platforms.
    #[default]
    Default,
    /// Quit automatically when the last window is closed.
    LastWindowClosed,
    /// Quit only when requested via [`App::quit`].
    Explicit,
}

/// Controls when GPUI hides the mouse cursor in response to keyboard input.
///
/// Restoration on mouse motion is handled by the platform layer; this enum
/// only describes the policy for *triggering* a hide.
#[derive(Copy, Clone, Debug, Default, PartialEq, Eq)]
pub enum CursorHideMode {
    /// Never hide the cursor automatically.
    Never,
    /// Hide on character-producing key presses (typing).
    OnTyping,
    /// Hide on character-producing key presses, *and* when a key binding
    /// resolves to an action that consumes the keystroke.
    #[default]
    OnTypingAndAction,
}

#[doc(hidden)]
#[derive(Clone, PartialEq, Eq)]
pub struct SystemWindowTab {
    pub id: WindowId,
    pub title: SharedString,
    pub handle: AnyWindowHandle,
    pub last_active_at: Instant,
}

impl SystemWindowTab {
    /// Create a new instance of the window tab.
    pub fn new(title: SharedString, handle: AnyWindowHandle) -> Self {
        Self {
            id: handle.id,
            title,
            handle,
            last_active_at: Instant::now(),
        }
    }
}

/// App-global records for system window tabs and their groups.
///
/// GPUI installs this global when it constructs the app. [`init`](Self::init)
/// replaces it with empty records; static mutation methods panic if the global
/// has been removed.
/// Group and title changes update GPUI's records; they do not themselves ask
/// the operating system to regroup or rename windows. Selection methods use
/// the recorded handles to activate a window.
///
/// Prefer the corresponding [`Window`] operations when handling a user's
/// request to change native tabs. This controller supports the bookkeeping
/// shared by those operations.
#[derive(Default)]
pub struct SystemWindowTabController {
    visible: Option<bool>,
    tab_groups: FxHashMap<usize, Vec<SystemWindowTab>>,
}

impl Global for SystemWindowTabController {}

impl SystemWindowTabController {
    /// Creates empty tab records with no visibility preference.
    pub fn new() -> Self {
        Self {
            visible: None,
            tab_groups: FxHashMap::default(),
        }
    }

    /// Installs a fresh controller, replacing any existing records.
    pub fn init(cx: &mut App) {
        cx.set_global(SystemWindowTabController::new());
    }

    /// Returns the recorded groups, keyed by an internal group identifier.
    ///
    /// Map order does not define the visual order of native windows.
    pub fn tab_groups(&self) -> &FxHashMap<usize, Vec<SystemWindowTab>> {
        &self.tab_groups
    }

    /// Returns a window from the next tab group.
    ///
    /// Groups are visited in the map's current key order, which is not a
    /// user-facing ordering guarantee. Within the selected group, the most
    /// recently active tab is preferred. Returns `None` when `id` is not in a
    /// group or no group is registered. Selection wraps around; with one group,
    /// it returns a tab in that same group.
    pub fn get_next_tab_group_window(cx: &mut App, id: WindowId) -> Option<&AnyWindowHandle> {
        let controller = cx.global::<SystemWindowTabController>();
        let current_group = controller
            .tab_groups
            .iter()
            .find_map(|(group, tabs)| tabs.iter().find(|tab| tab.id == id).map(|_| group));

        let current_group = current_group?;
        // TODO: `.keys()` returns arbitrary order, what does "next" mean?
        let mut group_ids: Vec<_> = controller.tab_groups.keys().collect();
        let idx = group_ids.iter().position(|g| *g == current_group)?;
        let next_idx = (idx + 1) % group_ids.len();

        controller
            .tab_groups
            .get(group_ids[next_idx])
            .and_then(|tabs| {
                tabs.iter()
                    .max_by_key(|tab| tab.last_active_at)
                    .or_else(|| tabs.first())
                    .map(|tab| &tab.handle)
            })
    }

    /// Returns a window from the previous tab group.
    ///
    /// Groups are visited in the map's current key order, which is not a
    /// user-facing ordering guarantee. Within the selected group, the most
    /// recently active tab is preferred. Returns `None` when `id` is not in a
    /// group or no group is registered. Selection wraps around; with one group,
    /// it returns a tab in that same group.
    pub fn get_prev_tab_group_window(cx: &mut App, id: WindowId) -> Option<&AnyWindowHandle> {
        let controller = cx.global::<SystemWindowTabController>();
        let current_group = controller
            .tab_groups
            .iter()
            .find_map(|(group, tabs)| tabs.iter().find(|tab| tab.id == id).map(|_| group));

        let current_group = current_group?;
        // TODO: `.keys()` returns arbitrary order, what does "previous" mean?
        let mut group_ids: Vec<_> = controller.tab_groups.keys().collect();
        let idx = group_ids.iter().position(|g| *g == current_group)?;
        let prev_idx = if idx == 0 {
            group_ids.len() - 1
        } else {
            idx - 1
        };

        controller
            .tab_groups
            .get(group_ids[prev_idx])
            .and_then(|tabs| {
                tabs.iter()
                    .max_by_key(|tab| tab.last_active_at)
                    .or_else(|| tabs.first())
                    .map(|tab| &tab.handle)
            })
    }

    /// Returns the group containing `id`, in recorded tab order.
    ///
    /// Returns `None` when no group contains that window.
    pub fn tabs(&self, id: WindowId) -> Option<&Vec<SystemWindowTab>> {
        self.tab_groups
            .values()
            .find(|tabs| tabs.iter().any(|tab| tab.id == id))
    }

    /// Sets the initial tab-bar preference if none has been recorded.
    ///
    /// A later call leaves the existing value unchanged. Use
    /// [`set_visible`](Self::set_visible) to replace it.
    pub fn init_visible(cx: &mut App, visible: bool) {
        let mut controller = cx.global_mut::<SystemWindowTabController>();
        if controller.visible.is_none() {
            controller.visible = Some(visible);
        }
    }

    /// Returns the recorded tab-bar preference, or `false` before initialization.
    pub fn is_visible(&self) -> bool {
        self.visible.unwrap_or(false)
    }

    /// Replaces the recorded tab-bar preference.
    pub fn set_visible(cx: &mut App, visible: bool) {
        let mut controller = cx.global_mut::<SystemWindowTabController>();
        controller.visible = Some(visible);
    }

    /// Records the current time as `id`'s most recent activation.
    ///
    /// Unregistered windows are ignored. Group navigation uses this timestamp
    /// to choose the most recently active tab within a group.
    pub fn update_last_active(cx: &mut App, id: WindowId) {
        let mut controller = cx.global_mut::<SystemWindowTabController>();
        for windows in controller.tab_groups.values_mut() {
            for tab in windows.iter_mut() {
                if tab.id == id {
                    tab.last_active_at = Instant::now();
                }
            }
        }
    }

    /// Moves `id` to zero-based position `ix` in its recorded group.
    ///
    /// An absent window or out-of-range position leaves the records unchanged.
    pub fn update_tab_position(cx: &mut App, id: WindowId, ix: usize) {
        let mut controller = cx.global_mut::<SystemWindowTabController>();
        for (_, windows) in controller.tab_groups.iter_mut() {
            if let Some(current_pos) = windows.iter().position(|tab| tab.id == id) {
                if ix < windows.len() && current_pos != ix {
                    let window_tab = windows.remove(current_pos);
                    windows.insert(ix, window_tab);
                }
                break;
            }
        }
    }

    /// Changes `id`'s recorded title when it differs from `title`.
    ///
    /// An absent window or unchanged title leaves the global untouched.
    pub fn update_tab_title(cx: &mut App, id: WindowId, title: SharedString) {
        let controller = cx.global::<SystemWindowTabController>();
        let tab = controller
            .tab_groups
            .values()
            .flat_map(|windows| windows.iter())
            .find(|tab| tab.id == id);

        if tab.map_or(true, |t| t.title == title) {
            return;
        }

        let mut controller = cx.global_mut::<SystemWindowTabController>();
        for windows in controller.tab_groups.values_mut() {
            for tab in windows.iter_mut() {
                if tab.id == id {
                    tab.title = title;
                    return;
                }
            }
        }
    }

    /// Records the group reported after adding window `id` to native tabs.
    ///
    /// `tabs` must contain `id` and the group's other members. If those other
    /// members match an existing group, this appends the new tab there;
    /// otherwise it records `tabs` as a new group. Missing `id` is ignored.
    pub fn add_tab(cx: &mut App, id: WindowId, tabs: Vec<SystemWindowTab>) {
        let mut controller = cx.global_mut::<SystemWindowTabController>();
        let Some(tab) = tabs.iter().find(|tab| tab.id == id).cloned() else {
            return;
        };

        let mut expected_tab_ids: Vec<_> = tabs
            .iter()
            .filter(|tab| tab.id != id)
            .map(|tab| tab.id)
            .sorted()
            .collect();

        let mut tab_group_id = None;
        for (group_id, group_tabs) in &controller.tab_groups {
            let tab_ids: Vec<_> = group_tabs.iter().map(|tab| tab.id).sorted().collect();
            if tab_ids == expected_tab_ids {
                tab_group_id = Some(*group_id);
                break;
            }
        }

        if let Some(tab_group_id) = tab_group_id {
            if let Some(tabs) = controller.tab_groups.get_mut(&tab_group_id) {
                tabs.push(tab);
            }
        } else {
            let new_group_id = controller.tab_groups.keys().max().map_or(0, |id| id + 1);
            controller.tab_groups.insert(new_group_id, tabs);
        }
    }

    /// Removes `id` from the records and returns its tab, if present.
    ///
    /// Groups left empty are removed too. This does not close the native window.
    pub fn remove_tab(cx: &mut App, id: WindowId) -> Option<SystemWindowTab> {
        let mut controller = cx.global_mut::<SystemWindowTabController>();
        let mut removed_tab = None;

        controller.tab_groups.retain(|_, tabs| {
            if let Some(pos) = tabs.iter().position(|tab| tab.id == id) {
                removed_tab = Some(tabs.remove(pos));
            }
            !tabs.is_empty()
        });

        removed_tab
    }

    /// Moves a recorded tab into a new, one-member group.
    ///
    /// Does nothing for an unregistered window. The native detach operation
    /// must be performed separately.
    pub fn move_tab_to_new_window(cx: &mut App, id: WindowId) {
        let mut removed_tab = Self::remove_tab(cx, id);
        let mut controller = cx.global_mut::<SystemWindowTabController>();

        if let Some(tab) = removed_tab {
            let new_group_id = controller.tab_groups.keys().max().map_or(0, |k| k + 1);
            controller.tab_groups.insert(new_group_id, vec![tab]);
        }
    }

    /// Combines all records into one group, starting with `id`'s group.
    ///
    /// The remaining groups have no guaranteed order. If `id` is unregistered,
    /// the records are unchanged. This does not merge native windows itself.
    pub fn merge_all_windows(cx: &mut App, id: WindowId) {
        let mut controller = cx.global_mut::<SystemWindowTabController>();
        let Some(initial_tabs) = controller.tabs(id) else {
            return;
        };

        let initial_tabs_len = initial_tabs.len();
        let mut all_tabs = initial_tabs.clone();

        for (_, mut tabs) in controller.tab_groups.drain() {
            tabs.retain(|tab| !all_tabs[..initial_tabs_len].contains(tab));
            all_tabs.extend(tabs);
        }

        controller.tab_groups.insert(0, all_tabs);
    }

    /// Activates the next recorded tab, wrapping at the group's end.
    ///
    /// An absent `id` or unavailable target window is silently ignored.
    pub fn select_next_tab(cx: &mut App, id: WindowId) {
        let mut controller = cx.global_mut::<SystemWindowTabController>();
        let Some(tabs) = controller.tabs(id) else {
            return;
        };

        let current_index = tabs.iter().position(|tab| tab.id == id).unwrap();
        let next_index = (current_index + 1) % tabs.len();

        let _ = &tabs[next_index].handle.update(cx, |_, window, _| {
            window.activate();
        });
    }

    /// Activates the previous recorded tab, wrapping at the group's beginning.
    ///
    /// An absent `id` or unavailable target window is silently ignored.
    pub fn select_previous_tab(cx: &mut App, id: WindowId) {
        let mut controller = cx.global_mut::<SystemWindowTabController>();
        let Some(tabs) = controller.tabs(id) else {
            return;
        };

        let current_index = tabs.iter().position(|tab| tab.id == id).unwrap();
        let previous_index = if current_index == 0 {
            tabs.len() - 1
        } else {
            current_index - 1
        };

        let _ = &tabs[previous_index].handle.update(cx, |_, window, _| {
            window.activate();
        });
    }
}

pub(crate) enum GpuiMode {
    #[cfg(any(test, feature = "headless"))]
    Test {
        skip_drawing: bool,
        draw_on_flush: bool,
    },
    Production,
}

impl GpuiMode {
    #[cfg(any(test, feature = "headless"))]
    pub fn test() -> Self {
        GpuiMode::Test {
            skip_drawing: false,
            draw_on_flush: true,
        }
    }

    #[cfg(any(test, feature = "headless", feature = "bench-support"))]
    #[inline]
    fn draw_on_flush(&self) -> bool {
        match self {
            #[cfg(any(test, feature = "headless"))]
            GpuiMode::Test { draw_on_flush, .. } => *draw_on_flush,
            GpuiMode::Production => true,
        }
    }
    pub(crate) fn skip_drawing(&self) -> bool {
        match self {
            #[cfg(any(test, feature = "headless"))]
            GpuiMode::Test { skip_drawing, .. } => *skip_drawing,
            GpuiMode::Production => false,
        }
    }
}

struct PlatformOwnedDrag {
    source_window: WindowId,
    state: PlatformOwnedDragState,
}

enum PlatformOwnedDragState {
    Suspended(AnyDrag),
    // A source-window drop consumes `active_drag` before AppKit ends the dragging session, so this
    // marker can outlive the active drag and is cleaned up by `FileDropEvent::Ended`.
    RestoredInSourceWindow,
}

/// The live application's synchronous state and access context.
///
/// GPUI passes `&mut App` to launch, window, and event callbacks. Use it to
/// create entities, open windows, bind actions, access globals, and schedule
/// work. [`Context<T>`] dereferences to this context and adds operations for
/// one entity, such as [`Context::notify`] and [`Context::subscribe`].
///
/// An entity handle does not borrow its value until a read or update receives
/// a context. Updates lease a value exclusively; recursively accessing the
/// same leased entity panics. See [`crate::_ownership_and_data_flow`] for the
/// access rules and effect timing.
///
/// Borrow this context only for the callback's duration. Use [`Self::to_async`]
/// for foreground work that must reacquire app access after an `await`, and
/// [`Self::background_executor`] for owned `Send` work that must leave the
/// foreground thread. An [`AsyncApp`] does not keep this app alive.
///
/// ## Platform services
///
/// `App` also exposes services supplied by [`Platform`], including clipboard,
/// file pickers, credentials, notifications, and display information. Prefer
/// the async clipboard read when a callback can await it; the synchronous
/// clipboard read cannot access browser clipboard contents. Treat methods with
/// no result as best-effort requests, `Option` as a possibly absent value, and
/// `Task<Result<...>>` or picker receivers as the place to inspect failures.
/// Check the corresponding `is_*_supported` method when one exists, then still
/// handle runtime failures.
pub struct App {
    pub(crate) this: Weak<AppCell>,
    pub(crate) platform: Rc<dyn Platform>,
    text_system: Arc<TextSystem>,

    pub(crate) actions: Rc<ActionRegistry>,
    pub(crate) active_drag: Option<AnyDrag>,
    platform_owned_drag: Option<PlatformOwnedDrag>,
    pub(crate) background_executor: BackgroundExecutor,
    pub(crate) foreground_executor: ForegroundExecutor,
    #[cfg(feature = "profiler")]
    foreground_journal: crate::profiler::journal::ForegroundJournal,
    pub(crate) entities: EntityMap,
    pub(crate) new_entity_observers: SubscriberSet<TypeId, NewEntityListener>,
    pub(crate) windows: SlotMap<WindowId, Option<Box<Window>>>,
    pub(crate) window_handles: FxHashMap<WindowId, AnyWindowHandle>,
    pub(crate) focus_handles: Arc<FocusMap>,
    pub(crate) keymap: Rc<RefCell<Keymap>>,
    pub(crate) keyboard_layout: Box<dyn PlatformKeyboardLayout>,
    pub(crate) keyboard_mapper: Rc<dyn PlatformKeyboardMapper>,
    pub(crate) global_action_listeners:
        TypeIdHashMap<Vec<Rc<dyn Fn(&dyn Any, DispatchPhase, &mut Self)>>>,
    pending_effects: VecDeque<Effect>,

    pub(crate) observers: SubscriberSet<EntityId, Handler>,
    pub(crate) event_listeners: SubscriberSet<EntityId, (TypeId, Listener)>,
    pub(crate) keystroke_observers: SubscriberSet<(), KeystrokeObserver>,
    pub(crate) keystroke_interceptors: SubscriberSet<(), KeystrokeObserver>,
    pub(crate) keyboard_layout_observers: SubscriberSet<(), Handler>,
    pub(crate) thermal_state_observers: SubscriberSet<(), Handler>,
    pub(crate) system_wake_observers: SubscriberSet<(), Handler>,
    pub(crate) release_listeners: SubscriberSet<EntityId, ReleaseListener>,
    pub(crate) global_observers: SubscriberSet<TypeId, Handler>,
    pub(crate) quit_observers: SubscriberSet<(), QuitHandler>,
    pub(crate) restart_observers: SubscriberSet<(), Handler>,
    pub(crate) window_closed_observers: SubscriberSet<(), WindowClosedHandler>,

    /// Per-App element arena. This isolates element allocations between different
    /// App instances (important for tests where multiple Apps run concurrently).
    pub(crate) element_arena: RefCell<Arena>,
    /// Per-App event arena.
    pub(crate) event_arena: Arena,

    // Drop globals last. We need to ensure all tasks owned by entities and
    // callbacks are marked cancelled at this point as this will also shutdown
    // the tokio runtime. As any task attempting to spawn a blocking tokio task,
    // might panic.
    pub(crate) globals_by_type: TypeIdHashMap<Box<dyn Any>>,
    // Entities which are retained until explicitly removed from the app or dropped at end of life-cycle.
    // This is an alternative way to define "global" data which uses entities.
    // There can be multiple entities of a given type & each `Entity<T>` is stored as `Box<dyn Any>`.
    global_entities: Vec<AnyEntity>,

    // assets
    pub(crate) loading_assets: FxHashMap<(TypeId, u64), Box<dyn Any>>,
    asset_registry: Arc<AssetRegistry>,
    pub(crate) svg_renderer: SvgRenderer,
    http_client: Arc<dyn HttpClient>,

    // below is plain data, the drop order is insignificant here
    pub(crate) pending_notifications: FxHashSet<EntityId>,
    pub(crate) pending_global_notifications: TypeIdHashSet,
    pub(crate) restart_path: Option<PathBuf>,
    pub(crate) restart_arguments: Vec<OsString>,
    pub(crate) layout_id_buffer: Vec<LayoutId>, // We recycle this memory across layout requests.
    pub(crate) propagate_event: bool,
    pub(crate) prompt_builder: Option<PromptBuilder>,
    pub(crate) window_invalidators_by_entity:
        FxHashMap<EntityId, FxHashMap<WindowId, WindowInvalidator>>,
    pub(crate) tracked_entities: FxHashMap<WindowId, FxHashSet<EntityId>>,
    pub(crate) current_window_by_entity: FxHashMap<EntityId, WindowId>,
    #[cfg(any(feature = "inspector", debug_assertions))]
    pub(crate) inspector_renderer: Option<crate::InspectorRenderer>,
    #[cfg(any(feature = "inspector", debug_assertions))]
    pub(crate) inspector_element_registry: InspectorElementRegistry,
    #[cfg(any(test, feature = "headless", debug_assertions))]
    pub(crate) name: Option<&'static str>,
    pub(crate) text_rendering_mode: Rc<Cell<TextRenderingMode>>,

    pub(crate) window_update_stack: Vec<WindowId>,
    pub(crate) mode: GpuiMode,
    pub(crate) cursor_hide_mode: CursorHideMode,
    pub(crate) reduce_motion: bool,
    /// Origin of the shared clock that phase-locks synced repeating animations.
    pub(crate) synced_animation_epoch: Instant,
    /// Whether the app was created by [`Application::new_inaccessible`]. No
    /// accesskit APIs will be called when this flag is set.
    pub(crate) accessibility_force_disabled: bool,
    /// Whether windows build their accessibility tree every frame without an
    /// assistive-technology client. See [`Application::with_accessibility_forced`].
    pub(crate) accessibility_forced: bool,
    flushing_effects: bool,
    pending_updates: usize,
    quit_mode: QuitMode,
    quitting: bool,

    // We need to ensure the leak detector drops last, after all tasks, callbacks and things have been dropped.
    // Otherwise it may report false positives.
    #[cfg(any(test, feature = "leak-detection"))]
    _ref_counts: Arc<RwLock<EntityRefCounts>>,
}

impl App {
    #[allow(clippy::new_ret_no_self)]
    pub(crate) fn new_app(
        platform: Rc<dyn Platform>,
        asset_registry: Arc<AssetRegistry>,
        http_client: Arc<dyn HttpClient>,
    ) -> Rc<AppCell> {
        let background_executor = platform.background_executor();
        let foreground_executor = platform.foreground_executor();
        assert!(
            background_executor.is_main_thread(),
            "must construct App on main thread"
        );
        #[cfg(feature = "profiler")]
        let foreground_journal = crate::profiler::journal::install_foreground_journal();
        let synced_animation_epoch = background_executor.now();

        let text_system = Arc::new(TextSystem::new(platform.text_system()));
        let entities = EntityMap::new();
        let keyboard_layout = platform.keyboard_layout();
        let keyboard_mapper = platform.keyboard_mapper();

        #[cfg(any(test, feature = "leak-detection"))]
        let _ref_counts = entities.ref_counts_drop_handle();

        let app = Rc::new_cyclic(|this| AppCell {
            app: RefCell::new(App {
                this: this.clone(),
                platform: platform.clone(),
                text_system,
                text_rendering_mode: Rc::new(Cell::new(TextRenderingMode::default())),
                mode: GpuiMode::Production,
                actions: Rc::new(ActionRegistry::default()),
                flushing_effects: false,
                pending_updates: 0,
                active_drag: None,
                platform_owned_drag: None,
                background_executor,
                foreground_executor,
                #[cfg(feature = "profiler")]
                foreground_journal,
                svg_renderer: SvgRenderer::new(asset_registry.clone()),
                loading_assets: Default::default(),
                asset_registry,
                http_client,
                globals_by_type: Default::default(),
                global_entities: Default::default(),
                entities,
                new_entity_observers: SubscriberSet::new(),
                windows: SlotMap::with_key(),
                window_update_stack: Vec::new(),
                window_handles: FxHashMap::default(),
                focus_handles: Arc::new(RwLock::new(SlotMap::with_key())),
                keymap: Rc::new(RefCell::new(Keymap::default())),
                keyboard_layout,
                keyboard_mapper,
                global_action_listeners: Default::default(),
                pending_effects: VecDeque::new(),
                pending_notifications: FxHashSet::default(),
                pending_global_notifications: Default::default(),
                observers: SubscriberSet::new(),
                tracked_entities: FxHashMap::default(),
                window_invalidators_by_entity: FxHashMap::default(),
                current_window_by_entity: FxHashMap::default(),
                event_listeners: SubscriberSet::new(),
                release_listeners: SubscriberSet::new(),
                keystroke_observers: SubscriberSet::new(),
                keystroke_interceptors: SubscriberSet::new(),
                keyboard_layout_observers: SubscriberSet::new(),
                thermal_state_observers: SubscriberSet::new(),
                system_wake_observers: SubscriberSet::new(),
                global_observers: SubscriberSet::new(),
                quit_observers: SubscriberSet::new(),
                restart_observers: SubscriberSet::new(),
                restart_path: None,
                restart_arguments: Vec::new(),
                window_closed_observers: SubscriberSet::new(),
                layout_id_buffer: Default::default(),
                propagate_event: true,
                prompt_builder: Some(PromptBuilder::Default),
                #[cfg(any(feature = "inspector", debug_assertions))]
                inspector_renderer: None,
                #[cfg(any(feature = "inspector", debug_assertions))]
                inspector_element_registry: InspectorElementRegistry::default(),
                quit_mode: QuitMode::default(),
                quitting: false,
                cursor_hide_mode: CursorHideMode::default(),
                reduce_motion: false,
                synced_animation_epoch,
                accessibility_force_disabled: false,
                accessibility_forced: false,

                #[cfg(any(test, feature = "headless", debug_assertions))]
                name: None,
                element_arena: RefCell::new(Arena::new(1024 * 1024)),
                event_arena: Arena::new(1024 * 1024),

                #[cfg(any(test, feature = "leak-detection"))]
                _ref_counts,
            }),
        });

        init_app_menus(platform.as_ref(), &app.borrow());
        SystemWindowTabController::init(&mut app.borrow_mut());

        platform.on_keyboard_layout_change(Box::new({
            let app = Rc::downgrade(&app);
            move || {
                if let Some(app) = app.upgrade() {
                    let cx = &mut app.borrow_mut();
                    cx.keyboard_layout = cx.platform.keyboard_layout();
                    cx.keyboard_mapper = cx.platform.keyboard_mapper();
                    cx.keyboard_layout_observers
                        .clone()
                        .retain(&(), move |callback| (callback)(cx));
                }
            }
        }));

        platform.on_thermal_state_change(Box::new({
            let app = Rc::downgrade(&app);
            move || {
                if let Some(app) = app.upgrade() {
                    let cx = &mut app.borrow_mut();
                    cx.thermal_state_observers
                        .clone()
                        .retain(&(), move |callback| (callback)(cx));
                }
            }
        }));

        platform.on_system_wake(Box::new({
            let app = Rc::downgrade(&app);
            move || {
                if let Some(app) = app.upgrade() {
                    let cx = &mut app.borrow_mut();
                    cx.system_wake_observers
                        .clone()
                        .retain(&(), move |callback| (callback)(cx));
                }
            }
        }));

        platform.on_quit(Box::new({
            let cx = Rc::downgrade(&app);
            move || {
                let Some(cx) = cx.upgrade() else {
                    return true;
                };
                match cx.try_borrow_mut() {
                    Ok(mut cx) => {
                        cx.shutdown();
                        true
                    }
                    Err(_) => {
                        // Quit was requested while the AppCell was borrowed, so we can't shut down synchronously.
                        // The platform decides how to proceed.
                        false
                    }
                }
            }
        }));

        app
    }

    #[doc(hidden)]
    pub fn ref_counts_drop_handle(&self) -> impl Sized + use<> {
        self.entities.ref_counts_drop_handle()
    }

    /// Captures a snapshot of all entities that currently have alive handles.
    ///
    /// The returned [`LeakDetectorSnapshot`] can later be passed to
    /// [`assert_no_new_leaks`](Self::assert_no_new_leaks) to verify that no
    /// entities created after the snapshot are still alive.
    /// Take it after creating shared test services and before creating the
    /// owner whose teardown is under test. Use the snapshot with this same app;
    /// it carries no app identity to reject a snapshot from another instance.
    #[cfg(any(test, feature = "leak-detection"))]
    pub fn leak_detector_snapshot(&self) -> LeakDetectorSnapshot {
        self.entities.leak_detector_snapshot()
    }

    /// Asserts that no entities created after `snapshot` still have alive handles.
    ///
    /// Entities that were already tracked at the time of the snapshot are ignored,
    /// even if they still have handles. Only *new* entities (those whose
    /// `EntityId` was not present in the snapshot) are considered leaks.
    /// Flush app effects after dropping fixture handles so released values
    /// can drop their own subscriptions and tasks. This checks entity handles,
    /// not arbitrary memory, and does not require an entity already present in
    /// the snapshot to be released. See [`LeakDetectorSnapshot`] for its scope.
    ///
    /// # Panics
    ///
    /// Panics if any new entity handles exist. The panic message lists every
    /// leaked entity with its type name, and includes allocation-site backtraces
    /// when `LEAK_BACKTRACE` is set.
    #[cfg(any(test, feature = "leak-detection"))]
    pub fn assert_no_new_leaks(&self, snapshot: &LeakDetectorSnapshot) {
        self.entities.assert_no_new_leaks(snapshot)
    }

    /// Closes app windows and runs registered shutdown handlers.
    ///
    /// Native applications give handlers registered with [`Context::on_app_quit`]
    /// [`SHUTDOWN_TIMEOUT`] to complete. WebAssembly runs them asynchronously as best-effort cleanup
    /// because its event-loop thread cannot block.
    ///
    /// The platform calls this during shutdown. Use [`quit`](Self::quit) to
    /// request that the platform end its run loop; this method performs cleanup
    /// without requesting a platform quit itself. Quit handlers run at most once.
    pub fn shutdown(&mut self) {
        let mut futures = Vec::new();

        for observer in self.quit_observers.remove(&()) {
            futures.push(observer(self));
        }

        self.windows.clear();
        self.window_handles.clear();
        self.flush_effects();
        self.quitting = true;

        let futures = futures::future::join_all(futures);
        #[cfg(not(target_family = "wasm"))]
        if self
            .foreground_executor
            .block_with_timeout(SHUTDOWN_TIMEOUT, futures)
            .is_err()
        {
            log::error!("timed out waiting on app_will_quit");
        }
        #[cfg(target_family = "wasm")]
        self.foreground_executor.spawn(futures).detach();

        self.quitting = false;
    }

    /// Returns the platform keyboard layout currently used to interpret keys.
    ///
    /// Register [`on_keyboard_layout_change`](Self::on_keyboard_layout_change)
    /// when the app caches layout-dependent labels or mappings.
    pub fn keyboard_layout(&self) -> &dyn PlatformKeyboardLayout {
        self.keyboard_layout.as_ref()
    }

    /// Returns the mapper used to translate key equivalents and shortcut labels.
    ///
    /// Reacquire it after [`on_keyboard_layout_change`](Self::on_keyboard_layout_change)
    /// when the active keyboard layout changes.
    pub fn keyboard_mapper(&self) -> &Rc<dyn PlatformKeyboardMapper> {
        &self.keyboard_mapper
    }

    /// Invokes `callback` when the platform reports a keyboard-layout change.
    ///
    /// Query [`keyboard_layout`](Self::keyboard_layout) or
    /// [`keyboard_mapper`](Self::keyboard_mapper) again inside the callback;
    /// the app refreshes those values before invoking observers. Dropping the
    /// returned subscription unregisters this callback.
    pub fn on_keyboard_layout_change<F>(&self, mut callback: F) -> Subscription
    where
        F: 'static + FnMut(&mut App),
    {
        let (subscription, activate) = self.keyboard_layout_observers.insert(
            (),
            Box::new(move |cx| {
                callback(cx);
                true
            }),
        );
        activate();
        subscription
    }

    /// Requests a quit through the platform's normal shutdown routine.
    ///
    /// The platform then invokes [`shutdown`](Self::shutdown) to close windows
    /// and run quit handlers. The browser backend cannot close the user's tab
    /// and ignores this request.
    pub fn quit(&self) {
        self.platform.quit();
    }

    /// Returns the current policy for hiding the cursor in response to
    /// keyboard input.
    pub fn cursor_hide_mode(&self) -> CursorHideMode {
        self.cursor_hide_mode
    }

    /// Sets the policy controlling when GPUI hides the cursor in response
    /// to keyboard input.
    pub fn set_cursor_hide_mode(&mut self, mode: CursorHideMode) {
        self.cursor_hide_mode = mode;
    }

    /// Returns whether the cursor is currently visible according to the
    /// platform. This will report `false` after a keyboard input has hidden
    /// the cursor and the user has not yet moved the mouse to restore it.
    ///
    /// See [`App::set_cursor_hide_mode`].
    pub fn is_cursor_visible(&self) -> bool {
        self.platform.is_cursor_visible()
    }

    /// Returns the app's preference for a static presentation of decorative motion.
    ///
    /// This starts as `false`; GPUI does not read an operating-system or browser
    /// preference into it automatically. The application sets it through
    /// [`Self::set_reduce_motion`], usually from its settings or by reading the
    /// platform's accessibility preference.
    ///
    /// Style transitions and [`AnimationExt`](crate::AnimationExt) consult this
    /// flag. Caller-owned [`Animated`](crate::Animated), [`Motion`](crate::Motion),
    /// and [`Transition`](crate::Transition) values do not. A reduced duration
    /// effect presents its configured resting endpoint, which can differ from
    /// the forward endpoint for reverse or repeating playback. See the
    /// [animation chapter](crate::_documentation::animation#respect-reduced-motion-at-the-adapter-boundary).
    // docs:examples:begin
    #[doc = include_str!("docs/examples/gpui-App-reduce-motion-bcfa3417.md")]
    // docs:examples:end
    pub fn reduce_motion(&self) -> bool {
        self.reduce_motion
    }

    /// Changes the app's reduced-motion preference and refreshes all windows.
    ///
    /// An equal value does nothing. This queues a refresh rather than drawing
    /// synchronously. Animation adapters apply the preference when next built;
    /// their retained identities and application state are not recreated.
    /// Custom animation code must read [`Self::reduce_motion`] itself.
    pub fn set_reduce_motion(&mut self, reduce_motion: bool) {
        if self.reduce_motion != reduce_motion {
            self.reduce_motion = reduce_motion;
            self.refresh_windows();
        }
    }

    /// Schedules all windows in the application to be redrawn. This can be called
    /// multiple times in an update cycle and still result in a single redraw.
    pub fn refresh_windows(&mut self) {
        self.pending_effects.push_back(Effect::RefreshWindows);
    }

    pub(crate) fn update<R>(&mut self, update: impl FnOnce(&mut Self) -> R) -> R {
        self.start_update();
        let result = update(self);
        self.finish_update();
        result
    }

    pub(crate) fn start_update(&mut self) {
        self.pending_updates += 1;
    }

    pub(crate) fn finish_update(&mut self) {
        if !self.flushing_effects && self.pending_updates == 1 {
            self.flushing_effects = true;
            self.flush_effects();
            self.flushing_effects = false;
        }
        self.pending_updates -= 1;
    }

    /// Observes notifications sent by `entity`.
    ///
    /// Registration is deferred until app effect processing. Retain the returned
    /// subscription to keep the observer active; dropping it cancels future calls.
    /// The callback receives the publisher's handle and can read its latest state.
    pub fn observe<W>(
        &mut self,
        entity: &Entity<W>,
        mut on_notify: impl FnMut(Entity<W>, &mut App) + 'static,
    ) -> Subscription
    where
        W: 'static,
    {
        self.observe_internal(entity, move |e, cx| {
            on_notify(e, cx);
            true
        })
    }

    pub(crate) fn detect_accessed_entities<R>(
        &mut self,
        callback: impl FnOnce(&mut App) -> R,
    ) -> (R, FxHashSet<EntityId>) {
        let accessed_entities_start = self.entities.accessed_entities.get_mut().clone();
        let result = callback(self);
        let entities_accessed_in_callback = self
            .entities
            .accessed_entities
            .get_mut()
            .difference(&accessed_entities_start)
            .copied()
            .collect::<FxHashSet<EntityId>>();
        (result, entities_accessed_in_callback)
    }

    pub(crate) fn record_entities_accessed(
        &mut self,
        window_handle: AnyWindowHandle,
        invalidator: WindowInvalidator,
        entities: &FxHashSet<EntityId>,
    ) {
        let mut tracked_entities =
            std::mem::take(self.tracked_entities.entry(window_handle.id).or_default());
        for entity in tracked_entities.iter() {
            self.window_invalidators_by_entity
                .entry(*entity)
                .and_modify(|windows| {
                    windows.remove(&window_handle.id);
                });
        }
        for entity in entities.iter() {
            self.window_invalidators_by_entity
                .entry(*entity)
                .or_default()
                .insert(window_handle.id, invalidator.clone());
            self.current_window_by_entity
                .insert(*entity, window_handle.id);
        }
        tracked_entities.clear();
        tracked_entities.extend(entities.iter().copied());
        self.tracked_entities
            .insert(window_handle.id, tracked_entities);
    }

    pub(crate) fn new_observer(&mut self, key: EntityId, value: Handler) -> Subscription {
        let (subscription, activate) = self.observers.insert(key, value);
        self.defer(move |_| activate());
        subscription
    }

    pub(crate) fn observe_internal<W>(
        &mut self,
        entity: &Entity<W>,
        mut on_notify: impl FnMut(Entity<W>, &mut App) -> bool + 'static,
    ) -> Subscription
    where
        W: 'static,
    {
        let entity_id = entity.entity_id();
        let handle = entity.downgrade();
        self.new_observer(
            entity_id,
            Box::new(move |cx| {
                if let Some(entity) = handle.upgrade() {
                    on_notify(entity, cx)
                } else {
                    false
                }
            }),
        )
    }

    /// Receives typed events emitted by `entity` during app effect processing.
    ///
    /// The callback receives the publisher's handle and event payload.
    /// Registration is deferred until effect processing. Effects run in queue
    /// order, so a subscription registered before an emission in the same
    /// update is active when the event is delivered. The callback runs after
    /// the update closure returns. Retain the returned subscription or call
    /// [`Subscription::detach`] to leave it registered without a cancellation handle.
    pub fn subscribe<T, Event>(
        &mut self,
        entity: &Entity<T>,
        mut on_event: impl FnMut(Entity<T>, &Event, &mut App) + 'static,
    ) -> Subscription
    where
        T: 'static + EventEmitter<Event>,
        Event: 'static,
    {
        self.subscribe_internal(entity, move |entity, event, cx| {
            on_event(entity, event, cx);
            true
        })
    }

    pub(crate) fn new_subscription(
        &mut self,
        key: EntityId,
        value: (TypeId, Listener),
    ) -> Subscription {
        let (subscription, activate) = self.event_listeners.insert(key, value);
        self.defer(move |_| activate());
        subscription
    }
    pub(crate) fn subscribe_internal<T, Evt>(
        &mut self,
        entity: &Entity<T>,
        mut on_event: impl FnMut(Entity<T>, &Evt, &mut App) -> bool + 'static,
    ) -> Subscription
    where
        T: 'static + EventEmitter<Evt>,
        Evt: 'static,
    {
        let entity_id = entity.entity_id();
        let handle = entity.downgrade();
        self.new_subscription(
            entity_id,
            (
                TypeId::of::<Evt>(),
                Box::new(move |event, cx| {
                    let event: &Evt = event.downcast_ref().expect("invalid event type");
                    if let Some(entity) = handle.upgrade() {
                        on_event(entity, event, cx)
                    } else {
                        false
                    }
                }),
            ),
        )
    }

    /// Returns handles to all open windows in the application.
    /// Use [`AnyWindowHandle::downcast`] to select windows whose root view has a
    /// particular type. This collection has no stacking-order guarantee; use
    /// [`Self::window_stack`] when front-to-back order matters.
    pub fn windows(&self) -> Vec<AnyWindowHandle> {
        self.windows
            .keys()
            .flat_map(|window_id| self.window_handles.get(&window_id).copied())
            .collect()
    }

    /// Returns the window handles ordered by their appearance on screen, front to back.
    ///
    /// The first window in the returned list is the active/topmost window of the application.
    ///
    /// This method returns None if the platform doesn't implement the method yet.
    pub fn window_stack(&self) -> Option<Vec<AnyWindowHandle>> {
        self.platform.window_stack()
    }

    /// Register GPU features or limits before opening the first window.
    ///
    /// The boxed value must contain `gpui_wgpu::WgpuDeviceRequirements` for
    /// backends that use this API. Configure requirements before device
    /// initialization; a backend may ignore requirements it does not support.
    pub fn set_gpu_requirements(&self, requirements: Box<dyn std::any::Any>) {
        self.platform.set_gpu_requirements(requirements);
    }

    /// Sets the namespace label used for credentials in the system keyring.
    ///
    /// Configure it before reading, writing, or deleting credentials so all
    /// three operations address the same entries. Linux and FreeBSD apply the
    /// label; other backends ignore it.
    pub fn set_keyring_label(&self, label: impl Into<SharedString>) {
        self.platform.set_keyring_label(label.into());
    }

    /// Returns a handle to the window that is currently focused at the platform level, if one exists.
    pub fn active_window(&self) -> Option<AnyWindowHandle> {
        self.platform.active_window()
    }

    /// Opens a platform window and installs the entity returned by `build_root_view` as its root.
    ///
    /// The builder runs only after the platform creates the window and receives
    /// that window for setup. Returns an error if the platform rejects the
    /// request or creation fails; for example, the web backend allows one
    /// normal window per document and rejects unsupported window kinds. Check
    /// the error before retaining or using the returned handle.
    // docs:examples:begin
    #[doc = include_str!("docs/examples/gpui-App-open-window-f8ec0f6b.md")]
    // docs:examples:end
    pub fn open_window<V: 'static + Render>(
        &mut self,
        options: crate::WindowOptions,
        build_root_view: impl FnOnce(&mut Window, &mut App) -> Entity<V>,
    ) -> anyhow::Result<WindowHandle<V>> {
        self.open_window_inner(options, build_root_view, true)
    }

    pub(crate) fn open_window_inner<V: 'static + Render>(
        &mut self,
        options: crate::WindowOptions,
        build_root_view: impl FnOnce(&mut Window, &mut App) -> Entity<V>,
        draw_initial: bool,
    ) -> anyhow::Result<WindowHandle<V>> {
        self.update(|cx| {
            let id = cx.windows.insert(None);
            let handle = WindowHandle::new(id);
            match Window::new(handle.into(), options, cx) {
                Ok(mut window) => {
                    cx.window_update_stack.push(id);
                    let root_view = build_root_view(&mut window, cx);
                    cx.window_update_stack.pop();
                    window.root.replace(root_view.into());
                    window.defer(cx, |window: &mut Window, cx| window.appearance_changed(cx));

                    // allow a window to draw at least once before returning
                    // this didn't cause any issues on non windows platforms as it seems we always won the race to on_request_frame
                    // on windows we quite frequently lose the race and return a window that has never rendered, which leads to a crash
                    // where DispatchTree::root_node_id asserts on empty nodes
                    if draw_initial {
                        window.draw(cx).clear(cx);
                    }

                    cx.window_handles.insert(id, window.handle);
                    cx.windows.get_mut(id).unwrap().replace(Box::new(window));
                    Ok(handle)
                }
                Err(e) => {
                    cx.windows.remove(id);
                    Err(e)
                }
            }
        })
    }

    /// Asks the platform to bring the application to the foreground.
    ///
    /// `ignoring_other_apps` is a platform hint. Some backends do not support
    /// application activation, and this method has no result to report whether
    /// activation succeeded.
    pub fn activate(&self, ignoring_other_apps: bool) {
        self.platform.activate(ignoring_other_apps);
    }

    /// Asks the platform to hide the application.
    ///
    /// This is a no-op on backends without application hiding support, and
    /// there is no result indicating whether the request succeeded.
    pub fn hide(&self) {
        self.platform.hide();
    }

    /// Asks the platform to hide other applications where supported.
    pub fn hide_other_apps(&self) {
        self.platform.hide_other_apps();
    }

    /// Asks the platform to restore other applications hidden by
    /// [`hide_other_apps`](Self::hide_other_apps), where supported.
    pub fn unhide_other_apps(&self) {
        self.platform.unhide_other_apps();
    }

    /// Returns the displays currently exposed by the platform.
    ///
    /// Use [`find_display`](Self::find_display) to resolve a saved
    /// [`DisplayId`]. An empty list means the backend currently exposes no
    /// displays; it does not establish stacking order for windows.
    pub fn displays(&self) -> Vec<Rc<dyn PlatformDisplay>> {
        self.platform.displays()
    }

    /// Returns the platform-designated primary display, if one exists.
    ///
    /// Use this when choosing an initial display; a backend may return `None`.
    pub fn primary_display(&self) -> Option<Rc<dyn PlatformDisplay>> {
        self.platform.primary_display()
    }

    /// Reports whether this backend may provide screen-capture sources.
    ///
    /// Screen capture must be enabled by the `screen-capture` feature on the
    /// supported native backends. Check this before awaiting
    /// [`screen_capture_sources`](Self::screen_capture_sources), and still
    /// handle that receiver's error because availability can depend on the OS
    /// version and runtime permissions.
    pub fn is_screen_capture_supported(&self) -> bool {
        self.platform.is_screen_capture_supported()
    }

    /// Requests the available screen-capture sources asynchronously.
    ///
    /// The receiver resolves to either the current sources or an error when
    /// capture is unsupported or unavailable. Check
    /// [`is_screen_capture_supported`](Self::is_screen_capture_supported)
    /// first, but treat the result as authoritative.
    pub fn screen_capture_sources(
        &self,
    ) -> oneshot::Receiver<Result<Vec<Rc<dyn ScreenCaptureSource>>>> {
        self.platform.screen_capture_sources()
    }

    /// Returns the display with the given ID, if one exists.
    ///
    /// Display IDs can become stale when monitors change; query
    /// [`displays`](Self::displays) again when this returns `None`.
    pub fn find_display(&self, id: DisplayId) -> Option<Rc<dyn PlatformDisplay>> {
        self.displays()
            .iter()
            .find(|display| display.id() == id)
            .cloned()
    }

    /// Returns the thermal state reported by the platform.
    ///
    /// macOS reports the system state; Linux, Windows, and Web currently
    /// return [`ThermalState::Nominal`] because they do not expose this value.
    /// Use [`on_thermal_state_change`](Self::on_thermal_state_change) when
    /// responding to supported changes, and treat a constant value as an
    /// unsupported report rather than an assertion about hardware.
    pub fn thermal_state(&self) -> ThermalState {
        self.platform.thermal_state()
    }

    /// Invokes `callback` when the platform reports a thermal-state change.
    ///
    /// Query [`thermal_state`](Self::thermal_state) in the callback for the
    /// current value. The returned subscription controls this app-level
    /// callback. Currently macOS reports changes; Linux and Windows do not,
    /// and Web may retain the callback without delivering changes.
    pub fn on_thermal_state_change<F>(&self, mut callback: F) -> Subscription
    where
        F: 'static + FnMut(&mut App),
    {
        let (subscription, activate) = self.thermal_state_observers.insert(
            (),
            Box::new(move |cx| {
                callback(cx);
                true
            }),
        );
        activate();
        subscription
    }

    /// Invokes `callback` when the platform reports that the system woke from sleep.
    ///
    /// The callback is retained until its [`Subscription`] is dropped. Backends
    /// without a wake notification simply never invoke it.
    pub fn on_system_wake<F>(&self, mut callback: F) -> Subscription
    where
        F: 'static + FnMut(&mut App),
    {
        let (subscription, activate) = self.system_wake_observers.insert(
            (),
            Box::new(move |cx| {
                callback(cx);
                true
            }),
        );
        activate();
        subscription
    }

    /// Returns the appearance currently reported for application windows.
    ///
    /// This reflects the platform's effective appearance (including an
    /// override where supported), not necessarily the appearance of every
    /// custom-painted element. See [`set_window_appearance`](Self::set_window_appearance).
    pub fn window_appearance(&self) -> WindowAppearance {
        self.platform.window_appearance()
    }

    /// Overrides the appearance (light/dark) applied to the app's windows, independent of
    /// the OS-wide setting. Pass `None` to clear the override and follow the system again.
    /// The current value is reported by [`App::window_appearance`].
    ///
    /// On macOS this sets the underlying `NSApplication.appearance`, which controls the
    /// native window chrome (the window border and titlebar) of every window. Use this
    /// when the app uses a dark theme while the system is in light mode (or vice versa)
    /// so the window edges render to match the theme. While an appearance is forced,
    /// windows stop tracking system light/dark changes; pass `None` to resume following
    /// the system. On other platforms this is a no-op.
    pub fn set_window_appearance(&self, appearance: Option<WindowAppearance>) {
        self.platform.set_window_appearance(appearance);
    }

    /// Returns whether this device currently supports haptic feedback.
    ///
    /// The macOS backend queries device support at runtime; other backends
    /// currently report `false`. Check this before offering a haptic action,
    /// then call [`play_haptic_feedback`](Self::play_haptic_feedback).
    pub fn supports_haptic_feedback(&self) -> bool {
        self.platform.supports_haptic_feedback()
    }

    /// Play a haptic feedback of the given style.
    ///
    /// Must be called from the main thread. Unsupported devices ignore the
    /// request; check [`supports_haptic_feedback`](Self::supports_haptic_feedback)
    /// first when the action depends on feedback. Styles correspond to
    /// [`NSHapticFeedbackPattern`](https://developer.apple.com/documentation/appkit/nshapticfeedbackmanager/feedbackpattern)
    /// values on macOS.
    pub fn play_haptic_feedback(&self, style: HapticFeedbackStyle) {
        self.platform.play_haptic_feedback(style)
    }

    /// Returns the platform's window-button layout when it exposes one.
    ///
    /// Use `None` to select a layout-independent fallback for controls placed
    /// beside native title-bar buttons.
    pub fn button_layout(&self) -> Option<WindowButtonLayout> {
        self.platform.button_layout()
    }

    /// Reads synchronously available data from the platform clipboard.
    ///
    /// `None` can mean that no supported item is available or that this
    /// backend cannot read synchronously. For code that can await, prefer
    /// [`read_from_clipboard_async`](Self::read_from_clipboard_async), which
    /// distinguishes access failures from an empty or unsupported clipboard.
    pub fn read_from_clipboard(&self) -> Option<ClipboardItem> {
        self.platform.read_from_clipboard()
    }

    /// Reads clipboard data asynchronously and reports access or conversion errors.
    ///
    /// Prefer this over [`App::read_from_clipboard`] in code that can await:
    /// on platforms where clipboard access is asynchronous and
    /// permission-gated (e.g. web), the synchronous read always returns
    /// `None` while this method performs a real read. On the web, call this
    /// method directly from the user action that initiates the read so the
    /// browser still grants user activation. `Ok(None)` means no supported
    /// item was returned; permission and unsupported-content failures are
    /// represented by [`ClipboardReadError`].
    pub fn read_from_clipboard_async(
        &self,
    ) -> Task<Result<Option<ClipboardItem>, ClipboardReadError>> {
        self.platform.read_from_clipboard_async()
    }

    /// Changes the text-rasterization preference read by windows during paint.
    ///
    /// This does not schedule a redraw. Call [`refresh_windows`](Self::refresh_windows)
    /// when changing the mode should repaint existing content immediately.
    /// Backend capabilities can constrain the effective mode; see [`TextRenderingMode`].
    pub fn set_text_rendering_mode(&mut self, mode: TextRenderingMode) {
        self.text_rendering_mode.set(mode);
    }

    /// Returns the current text rendering mode for the application.
    pub fn text_rendering_mode(&self) -> TextRenderingMode {
        self.text_rendering_mode.get()
    }

    /// Asks the platform to write `item` to the system clipboard.
    ///
    /// This operation has no completion result, and backends may support only
    /// a subset of clipboard entry types (the web backend currently writes
    /// text). On the web, call it directly in the user action that initiates
    /// the copy. Use this for best-effort copy actions.
    pub fn write_to_clipboard(&self, item: ClipboardItem) {
        self.platform.write_to_clipboard(item)
    }

    /// Reads the X11/Wayland primary selection, separate from the clipboard.
    /// Only available on Linux and FreeBSD.
    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    pub fn read_from_primary(&self) -> Option<ClipboardItem> {
        self.platform.read_from_primary()
    }

    /// Replaces the X11/Wayland primary selection, separate from the clipboard.
    /// Only available on Linux and FreeBSD.
    #[cfg(any(target_os = "linux", target_os = "freebsd"))]
    pub fn write_to_primary(&self, item: ClipboardItem) {
        self.platform.write_to_primary(item)
    }

    /// Reads data from macOS's "Find" pasteboard.
    ///
    /// Used to share the current search string between apps.
    ///
    /// <https://developer.apple.com/documentation/appkit/nspasteboard/name-swift.struct/find>
    #[cfg(target_os = "macos")]
    pub fn read_from_find_pasteboard(&self) -> Option<ClipboardItem> {
        self.platform.read_from_find_pasteboard()
    }

    /// Writes data to macOS's "Find" pasteboard.
    ///
    /// Used to share the current search string between apps.
    ///
    /// <https://developer.apple.com/documentation/appkit/nspasteboard/name-swift.struct/find>
    #[cfg(target_os = "macos")]
    pub fn write_to_find_pasteboard(&self, item: ClipboardItem) {
        self.platform.write_to_find_pasteboard(item)
    }

    /// Stores credentials for `url` in the platform credential store.
    ///
    /// Await the returned task to learn whether the write succeeded. A backend
    /// may reject credential storage entirely; do not treat dropping the task
    /// as confirmation that the write completed.
    pub fn write_credentials(
        &self,
        url: &str,
        username: &str,
        password: &[u8],
    ) -> Task<Result<()>> {
        self.platform.write_credentials(url, username, password)
    }

    /// Reads credentials for `url` from the platform credential store.
    ///
    /// `Ok(None)` means no usable entry was found (some platforms also use it
    /// when a credential prompt is canceled). Await the task to distinguish
    /// that result from a backend error or unavailable credential store.
    pub fn read_credentials(&self, url: &str) -> Task<Result<Option<(String, Vec<u8>)>>> {
        self.platform.read_credentials(url)
    }

    /// Deletes credentials for `url` from the platform credential store.
    ///
    /// Await the returned task to observe backend errors. Whether deleting a
    /// missing entry is treated as success is platform-dependent.
    pub fn delete_credentials(&self, url: &str) -> Task<Result<()>> {
        self.platform.delete_credentials(url)
    }

    /// Asks the platform's default handler to open `url`.
    ///
    /// This is a fire-and-forget request: the method does not validate that the
    /// URL is handled or report whether the browser opened it.
    pub fn open_url(&self, url: &str) {
        self.platform.open_url(url);
    }

    /// Requests runtime registration of `scheme` (for example, `zed` for
    /// `zed://` URLs) as a scheme handled by this app.
    ///
    /// On some platforms (e.g. macOS) you may be able to register URL schemes
    /// as part of app distribution, but this method exists to let you register
    /// schemes at runtime. Support and meaning vary by backend: unsupported
    /// native platforms return an error, and the web backend completes without
    /// registering a browser-level protocol handler. Await the task and do not
    /// infer registration from `Ok(())` on every platform.
    pub fn register_url_scheme(&self, scheme: &str) -> Task<Result<()>> {
        self.platform.register_url_scheme(scheme)
    }

    /// Sets the application's platform identity and user-visible name where supported.
    ///
    /// The identifier is used for platform identity mechanisms such as the
    /// Windows AppUserModelID. The name is used wherever the operating system
    /// presents the application to the user. Linux uses the name for system
    /// notifications; platforms without an identity hook ignore this call.
    /// Call it once, early in startup, before opening windows or posting
    /// notifications.
    pub fn set_app_identity(&self, identifier: &str, name: &str) {
        self.platform.set_app_identity(identifier, name);
    }

    /// Asks the platform to post a system notification.
    ///
    /// Posting a notification whose [`SystemNotification::tag`] matches an
    /// earlier one replaces that notification where the platform supports it.
    /// No-op on platforms without notification support, or when delivery is
    /// unavailable (e.g. authorization was denied). This method is
    /// fire-and-forget, so it cannot confirm delivery or permission status.
    pub fn show_system_notification(&self, notification: SystemNotification) {
        self.platform.show_system_notification(notification);
    }

    /// Removes the delivered or pending notification with this tag.
    ///
    /// Best-effort: some platforms cannot retract a notification once shown,
    /// in which case it ages out of the notification center on its own.
    pub fn dismiss_system_notification(&self, tag: &str) {
        self.platform.dismiss_system_notification(tag);
    }

    /// Registers the handler invoked when the user activates a system
    /// notification, either by clicking its body or one of its action
    /// buttons. The platform retains one handler for the application; a later
    /// registration replaces it. Supported backends deliver it on the
    /// foreground thread.
    pub fn on_system_notification_response<F>(&self, mut callback: F)
    where
        F: 'static + FnMut(SystemNotificationResponse, &mut App),
    {
        let this = self.this.clone();
        self.platform
            .on_system_notification_response(Box::new(move |response| {
                if let Some(app) = this.upgrade() {
                    callback(response, &mut app.borrow_mut());
                }
            }));
    }

    /// Returns the app's bundle or executable path according to the platform.
    ///
    /// macOS returns the application bundle path; Linux and Windows return the
    /// current executable path. The browser backend returns an error because
    /// it has no local process path.
    pub fn app_path(&self) -> Result<PathBuf> {
        self.platform.app_path()
    }

    /// Returns a diagnostic name for the active compositor or backend.
    ///
    /// Linux reports its compositor, the web backend reports `Web`, and
    /// backends without a name return an empty string. Do not use this value
    /// for capability detection.
    pub fn compositor_name(&self) -> &'static str {
        self.platform.compositor_name()
    }

    /// Locates a helper executable named `name` according to platform bundle conventions.
    ///
    /// This is implemented for bundled macOS applications. Linux, Windows,
    /// and the browser currently return an error when asked for an auxiliary
    /// executable.
    pub fn path_for_auxiliary_executable(&self, name: &str) -> Result<PathBuf> {
        self.platform.path_for_auxiliary_executable(name)
    }

    /// Opens a platform file or directory picker.
    ///
    /// Results arrive asynchronously through the returned receiver. Use
    /// [`can_select_mixed_files_and_dirs`](Self::can_select_mixed_files_and_dirs)
    /// when the picker must select both files and directories. The receiver
    /// yields `Ok(Some(paths))` for a selection, `Ok(None)` for
    /// cancellation (and on Linux builds without a picker backend), or `Err`
    /// when the picker cannot open. The web backend reports unsupported with
    /// an error. This is asynchronous; it does not block the app callback.
    pub fn prompt_for_paths(
        &self,
        options: PathPromptOptions,
    ) -> oneshot::Receiver<Result<Option<Vec<PathBuf>>>> {
        self.platform.prompt_for_paths(options)
    }

    /// Opens a platform save picker for a new file path.
    ///
    /// `directory` and `suggested_name` supply the picker's initial location
    /// and filename where supported.
    /// The receiver yields `Ok(Some(path))` for a selection, `Ok(None)` for
    /// cancellation (and on Linux builds without a picker backend), or `Err`
    /// when the picker cannot open. The web backend reports unsupported with
    /// an error. This is asynchronous; it does not block the app callback.
    pub fn prompt_for_new_path(
        &self,
        directory: &Path,
        suggested_name: Option<&str>,
    ) -> oneshot::Receiver<Result<Option<PathBuf>>> {
        self.platform.prompt_for_new_path(directory, suggested_name)
    }

    /// Asks the platform file manager to reveal `path`, where supported.
    ///
    /// The operation is best effort and has no result; the web backend does
    /// nothing.
    pub fn reveal_path(&self, path: &Path) {
        self.platform.reveal_path(path)
    }

    /// Asks the operating system to open `path` with its registered application.
    ///
    /// The operation is best effort and has no result; the web backend does
    /// nothing.
    pub fn open_with_system(&self, path: &Path) {
        self.platform.open_with_system(path)
    }

    /// Returns whether the backend reports that scrollbars should auto-hide.
    ///
    /// This reflects a system preference where available; some backends use a
    /// fixed policy (the web backend currently returns `true`).
    pub fn should_auto_hide_scrollbars(&self) -> bool {
        self.platform.should_auto_hide_scrollbars()
    }

    /// Runs app restart observers, then asks the platform to relaunch the app.
    ///
    /// Restart support is platform-dependent and this method has no result to
    /// report failure. The configured restart path and arguments are consumed
    /// by this request; without a path, the platform locates the current app.
    pub fn restart(&mut self) {
        self.restart_observers
            .clone()
            .retain(&(), |observer| observer(self));
        self.platform.restart(
            self.restart_path.take(),
            std::mem::take(&mut self.restart_arguments),
        )
    }

    /// Sets the path the platform should relaunch on the next
    /// [`restart`](Self::restart) request.
    ///
    /// This value is consumed by that request; it does not affect the current
    /// process or persist automatically for later restarts.
    pub fn set_restart_path(&mut self, path: PathBuf) {
        self.restart_path = Some(path);
    }

    /// Clones the HTTP client used by this app.
    ///
    /// The returned client can be moved into background work. Replacing the
    /// app's client later does not change an already-cloned handle.
    pub fn http_client(&self) -> Arc<dyn HttpClient> {
        self.http_client.clone()
    }

    /// Replaces the client for future app requests and resource loads.
    ///
    /// Existing requests and cloned clients keep using the previous instance.
    /// Use [`Application::with_http_client`] for configuration before startup.
    pub fn set_http_client(&mut self, new_client: Arc<dyn HttpClient>) {
        self.http_client = new_client;
    }

    /// Configures when the application should automatically quit.
    /// By default, [`QuitMode::Default`] is used.
    pub fn set_quit_mode(&mut self, mode: QuitMode) {
        self.quit_mode = mode;
    }

    /// Returns the SVG renderer used by the application.
    pub fn svg_renderer(&self) -> SvgRenderer {
        self.svg_renderer.clone()
    }

    pub(crate) fn push_effect(&mut self, effect: Effect) {
        match &effect {
            Effect::Notify { emitter } => {
                if !self.pending_notifications.insert(*emitter) {
                    return;
                }
            }
            Effect::NotifyGlobalObservers { global_type } => {
                if !self.pending_global_notifications.insert(*global_type) {
                    return;
                }
            }
            _ => {}
        };

        self.pending_effects.push_back(effect);
    }

    /// Called at the end of [`App::update`] to complete any side effects
    /// such as notifying observers, emitting events, etc. Effects can themselves
    /// cause effects, so we continue looping until all effects are processed.
    fn flush_effects(&mut self) {
        loop {
            self.release_dropped_entities();
            self.release_dropped_focus_handles();
            if let Some(effect) = self.pending_effects.pop_front() {
                match effect {
                    Effect::Notify { emitter } => {
                        self.apply_notify_effect(emitter);
                    }

                    Effect::Emit {
                        emitter,
                        event_type,
                        event,
                    } => self.apply_emit_effect(emitter, event_type, &*event),

                    Effect::RefreshWindows => {
                        self.apply_refresh_effect();
                    }

                    Effect::NotifyGlobalObservers { global_type } => {
                        self.apply_notify_global_observers_effect(global_type);
                    }

                    Effect::Defer { callback } => {
                        self.apply_defer_effect(callback);
                    }
                    Effect::EntityCreated {
                        entity,
                        tid,
                        window,
                    } => {
                        self.apply_entity_created_effect(entity, tid, window);
                    }
                }
            } else {
                #[cfg(any(test, feature = "headless", feature = "bench-support"))]
                if self.mode.draw_on_flush() {
                    for window in self
                        .windows
                        .values()
                        .filter_map(|window| {
                            let window = window.as_deref()?;
                            window.invalidator.is_dirty().then_some(window.handle)
                        })
                        .collect::<Vec<_>>()
                    {
                        self.update_window(window, |_, window, cx| window.draw(cx).clear(cx))
                            .unwrap();
                    }
                }

                if self.pending_effects.is_empty() {
                    for window in self.windows.values().filter_map(|window| window.as_deref()) {
                        if window.invalidator.is_dirty()
                            || window.needs_present.get()
                            || !window.next_frame_callbacks.borrow().is_empty()
                        {
                            window.platform_window.schedule_frame();
                        }
                    }

                    self.event_arena.clear();
                    break;
                }
            }
        }
    }

    /// Repeatedly called during `flush_effects` to release any entities whose
    /// reference count has become zero. We invoke any release observers before dropping
    /// each entity.
    fn release_dropped_entities(&mut self) {
        loop {
            let dropped = self.entities.take_dropped();
            if dropped.is_empty() {
                break;
            }

            for (entity_id, mut entity) in dropped {
                self.observers.remove(&entity_id);
                self.event_listeners.remove(&entity_id);
                self.window_invalidators_by_entity.remove(&entity_id);
                self.current_window_by_entity.remove(&entity_id);
                for release_callback in self.release_listeners.remove(&entity_id) {
                    release_callback(entity.as_mut(), self);
                }
            }
        }
    }

    /// Repeatedly called during `flush_effects` to handle a focused handle being dropped.
    fn release_dropped_focus_handles(&mut self) {
        self.focus_handles
            .clone()
            .write()
            .retain(|handle_id, focus| {
                if focus.ref_count.load(SeqCst) == 0 {
                    for window_handle in self.windows() {
                        window_handle
                            .update(self, |_, window, cx| {
                                if window.focus == Some(handle_id) {
                                    window.blur(cx);
                                }
                            })
                            .unwrap();
                    }
                    false
                } else {
                    true
                }
            });
    }

    fn apply_notify_effect(&mut self, emitter: EntityId) {
        self.pending_notifications.remove(&emitter);

        self.observers
            .clone()
            .retain(&emitter, |handler| handler(self));
    }

    fn apply_emit_effect(&mut self, emitter: EntityId, event_type: TypeId, event: &dyn Any) {
        self.event_listeners
            .clone()
            .retain(&emitter, |(stored_type, handler)| {
                if *stored_type == event_type {
                    handler(event, self)
                } else {
                    true
                }
            });
    }

    fn apply_refresh_effect(&mut self) {
        for window in self.windows.values_mut() {
            if let Some(window) = window.as_deref_mut() {
                window.refreshing = true;
                window.invalidator.set_dirty(true);
            }
        }
    }

    fn apply_notify_global_observers_effect(&mut self, type_id: TypeId) {
        self.pending_global_notifications.remove(&type_id);
        self.global_observers
            .clone()
            .retain(&type_id, |observer| observer(self));
    }

    fn apply_defer_effect(&mut self, callback: Box<dyn FnOnce(&mut Self) + 'static>) {
        callback(self);
    }

    fn apply_entity_created_effect(
        &mut self,
        entity: AnyEntity,
        tid: TypeId,
        window: Option<WindowId>,
    ) {
        // Seed the entity's current window from its creation context so
        // `with_window` resolves correctly before the entity has ever been
        // rendered.
        if let Some(id) = window {
            self.current_window_by_entity.insert(entity.entity_id(), id);
        }

        self.new_entity_observers.clone().retain(&tid, |observer| {
            if let Some(id) = window {
                self.update_window_id(id, {
                    let entity = entity.clone();
                    |_, window, cx| (observer)(entity, &mut Some(window), cx)
                })
                .expect("All windows should be off the stack when flushing effects");
            } else {
                (observer)(entity.clone(), &mut None, self)
            }
            true
        });
    }

    /// Run `f` against the entity's *current* window — the most recently
    /// rendered window that referenced the entity, or its creation window if
    /// it has yet to be rendered. Returns `None` if the entity has no
    /// current window, or if that window has been closed, or if it is
    /// already on the update stack.
    pub fn with_window<R>(
        &mut self,
        entity_id: EntityId,
        f: impl FnOnce(&mut Window, &mut App) -> R,
    ) -> Option<R> {
        let window_id = *self.current_window_by_entity.get(&entity_id)?;
        self.update_window_id(window_id, |_, window, cx| f(window, cx))
            .ok()
    }

    fn ensure_window(&mut self, entity_id: EntityId, window: WindowId) {
        self.current_window_by_entity
            .entry(entity_id)
            .or_insert(window);
    }

    pub(crate) fn update_window_id<T, F>(&mut self, id: WindowId, update: F) -> Result<T>
    where
        F: FnOnce(AnyView, &mut Window, &mut App) -> T,
    {
        self.update(|cx| {
            let mut window = cx.windows.get_mut(id)?.take()?;

            let root_view = window.root.clone().unwrap();

            cx.window_update_stack.push(window.handle.id);
            let result = update(root_view, &mut window, cx);
            fn trail(id: WindowId, window: Box<Window>, cx: &mut App) -> Option<()> {
                cx.window_update_stack.pop();

                if window.removed {
                    cx.end_platform_drag(id);
                    cx.window_handles.remove(&id);
                    cx.windows.remove(id);
                    if let Some(tracked) = cx.tracked_entities.remove(&id) {
                        for entity_id in tracked {
                            if let Some(windows) =
                                cx.window_invalidators_by_entity.get_mut(&entity_id)
                            {
                                windows.remove(&id);
                            }
                            if cx.current_window_by_entity.get(&entity_id) == Some(&id) {
                                cx.current_window_by_entity.remove(&entity_id);
                            }
                        }
                    }

                    cx.window_closed_observers.clone().retain(&(), |callback| {
                        callback(cx, id);
                        true
                    });

                    let quit_on_empty = match cx.quit_mode {
                        QuitMode::Explicit => false,
                        QuitMode::LastWindowClosed => true,
                        QuitMode::Default => cfg!(not(target_os = "macos")),
                    };

                    if quit_on_empty && cx.windows.is_empty() {
                        cx.quit();
                    }
                } else {
                    cx.windows.get_mut(id)?.replace(window);
                }
                Some(())
            }
            trail(id, window, cx)?;

            Some(result)
        })
        .context("window not found")
    }

    /// Creates an [`AsyncApp`] that can be cloned and held across `await` points.
    ///
    /// The handle is weak: it does not keep this app alive. Operations that need
    /// the app fail or panic according to the individual `AsyncApp` method once
    /// shutdown has released the app.
    pub fn to_async(&self) -> AsyncApp {
        AsyncApp {
            app: self.this.clone(),
            background_executor: self.background_executor.clone(),
            foreground_executor: self.foreground_executor.clone(),
        }
    }

    /// Returns the executor for `Send` work that does not borrow app state.
    ///
    /// Await its tasks from [`spawn`](Self::spawn) before applying results to
    /// entities or windows on the foreground thread.
    pub fn background_executor(&self) -> &BackgroundExecutor {
        &self.background_executor
    }

    /// Returns the executor for work that must run with foreground app access.
    ///
    /// This accessor panics while the application is running quit handlers.
    /// Prefer [`spawn`](Self::spawn) when the future needs app access after an
    /// `.await`; use the background executor for CPU or I/O work that can leave
    /// the UI thread.
    pub fn foreground_executor(&self) -> &ForegroundExecutor {
        if self.quitting {
            panic!("Can't spawn on main thread after on_app_quit")
        };
        &self.foreground_executor
    }

    /// Returns the foreground work journal for this app's foreground thread.
    /// Apps constructed on the same thread share the stream.
    #[cfg(feature = "profiler")]
    pub fn foreground_journal(&self) -> crate::profiler::journal::ForegroundJournal {
        self.foreground_journal.clone()
    }

    /// Spawns a future on the foreground executor with app access across awaits.
    ///
    /// The closure receives an [`AsyncApp`], which reacquires synchronous app
    /// access for each operation. A poll runs on the UI thread, so move long
    /// CPU or I/O work to [`background_executor`](Self::background_executor).
    /// Dropping the returned task cancels remaining polling; detach it or keep
    /// it on an owner when it should continue.
    #[track_caller]
    pub fn spawn<AsyncFn, R>(&self, f: AsyncFn) -> Task<R>
    where
        AsyncFn: AsyncFnOnce(&mut AsyncApp) -> R + 'static,
        R: 'static,
    {
        if self.quitting {
            debug_panic!("Can't spawn on main thread after on_app_quit")
        };

        let mut cx = self.to_async();

        self.foreground_executor
            .spawn(async move { f(&mut cx).await }.boxed_local())
    }

    /// Spawns foreground work with app access and the given scheduling priority.
    ///
    /// The closure receives an [`AsyncApp`] and follows [`spawn`](Self::spawn)'s
    /// borrowing, thread, and cancellation rules. Priority affects scheduling;
    /// it does not move work to a background thread or interrupt a poll already
    /// running.
    pub fn spawn_with_priority<AsyncFn, R>(&self, priority: Priority, f: AsyncFn) -> Task<R>
    where
        AsyncFn: AsyncFnOnce(&mut AsyncApp) -> R + 'static,
        R: 'static,
    {
        if self.quitting {
            debug_panic!("Can't spawn on main thread after on_app_quit")
        };

        let mut cx = self.to_async();

        self.foreground_executor
            .spawn_with_priority(priority, async move { f(&mut cx).await }.boxed_local())
    }

    /// Queues `f` for the current effect cycle after active entity leases end.
    ///
    /// Use this to reacquire an entity that is currently being updated; the
    /// callback runs with fresh app access while effects are flushed. It does
    /// not wait for a frame. Use a task or a window's next-frame callback when
    /// work needs a time-based or frame-based delay.
    pub fn defer(&mut self, f: impl FnOnce(&mut App) + 'static) {
        self.push_effect(Effect::Defer {
            callback: Box::new(f),
        });
    }

    /// Returns the byte registry installed with [`Application::with_assets`].
    ///
    /// Registry paths are exact, app-defined keys. For asynchronous typed
    /// resource loading and deduplication, use [`fetch_asset`](Self::fetch_asset).
    pub fn assets(&self) -> &Arc<AssetRegistry> {
        &self.asset_registry
    }

    /// Returns the shared font, shaping, and glyph service for this app.
    ///
    /// Register bundled fonts here before first use. See [`TextSystem`] for
    /// shaping and measurement, and [`Window::text_system`] for frame-local
    /// text layout caching.
    pub fn text_system(&self) -> &Arc<TextSystem> {
        &self.text_system
    }

    /// Check whether a global of the given type has been assigned.
    pub fn has_global<G: Global>(&self) -> bool {
        self.globals_by_type.contains_key(&TypeId::of::<G>())
    }

    /// Borrows the app's value of type `G`.
    ///
    /// Panics if no value is installed, including while that global is leased
    /// by an update callback. Use [`try_global`](Self::try_global) for optional
    /// lookup or [`default_global`](Self::default_global) to initialize a value.
    #[track_caller]
    pub fn global<G: Global>(&self) -> &G {
        self.globals_by_type
            .get(&TypeId::of::<G>())
            .map(|any_state| any_state.downcast_ref::<G>().unwrap())
            .unwrap_or_else(|| panic!("no state of type {} exists", type_name::<G>()))
    }

    /// Access the global of the given type if a value has been assigned.
    pub fn try_global<G: Global>(&self) -> Option<&G> {
        self.globals_by_type
            .get(&TypeId::of::<G>())
            .map(|any_state| any_state.downcast_ref::<G>().unwrap())
    }

    /// Borrows an assigned global mutably and schedules its observers.
    ///
    /// Mutable access schedules observers even if the value is left unchanged.
    /// Panics when no value of this type has been installed; use
    /// [`try_global`](Self::try_global) when absence is expected.
    #[track_caller]
    pub fn global_mut<G: Global>(&mut self) -> &mut G {
        let global_type = TypeId::of::<G>();
        self.push_effect(Effect::NotifyGlobalObservers { global_type });
        self.globals_by_type
            .get_mut(&global_type)
            .and_then(|any_state| any_state.downcast_mut::<G>())
            .unwrap_or_else(|| panic!("no state of type {} exists", type_name::<G>()))
    }

    /// Borrows a global mutably, inserting `G::default()` if it is absent.
    ///
    /// The access schedules observers even when the value already existed and
    /// the callback makes no change. Use [`update_default_global`](crate::BorrowAppContext::update_default_global)
    /// when the global also needs callback-scoped access to the app context.
    pub fn default_global<G: Global + Default>(&mut self) -> &mut G {
        let global_type = TypeId::of::<G>();
        self.push_effect(Effect::NotifyGlobalObservers { global_type });
        self.globals_by_type
            .entry(global_type)
            .or_insert_with(|| Box::<G>::default())
            .downcast_mut::<G>()
            .unwrap()
    }

    /// Replaces the value of the global of type `G` and schedules its observers.
    ///
    /// The old value is dropped when replaced. Observers run during effect
    /// processing after the current app update, and can query the new value.
    pub fn set_global<G: Global>(&mut self, global: G) {
        let global_type = TypeId::of::<G>();
        self.push_effect(Effect::NotifyGlobalObservers { global_type });
        self.globals_by_type.insert(global_type, Box::new(global));
    }

    /// Clear all stored globals. Does not notify global observers.
    #[cfg(any(test, feature = "headless"))]
    pub fn clear_globals(&mut self) {
        self.globals_by_type.drain();
    }

    /// Removes and returns the assigned global, then schedules its observers.
    ///
    /// Observers run during effect processing and should handle the global now
    /// being absent. Panics if no value of this type is assigned.
    pub fn remove_global<G: Global>(&mut self) -> G {
        let global_type = TypeId::of::<G>();
        self.push_effect(Effect::NotifyGlobalObservers { global_type });
        *self
            .globals_by_type
            .remove(&global_type)
            .unwrap_or_else(|| panic!("no global added for {}", type_name::<G>()))
            .downcast()
            .unwrap()
    }

    /// Registers a callback for mutations or replacement of global type `G`.
    ///
    /// Registration becomes active during effect processing, so this callback
    /// does not observe a change queued earlier in the same update. It receives
    /// the app, not the global value; call [`try_global`](Self::try_global) or
    /// [`global`](Self::global) to read the current value. Retain the returned
    /// subscription to keep observing.
    pub fn observe_global<G: Global>(
        &mut self,
        mut f: impl FnMut(&mut Self) + 'static,
    ) -> Subscription {
        let (subscription, activate) = self.global_observers.insert(
            TypeId::of::<G>(),
            Box::new(move |cx| {
                f(cx);
                true
            }),
        );
        self.defer(move |_| activate());
        subscription
    }

    /// Move the global of the given type to the stack.
    #[track_caller]
    pub(crate) fn lease_global<G: Global>(&mut self) -> GlobalLease<G> {
        GlobalLease::new(
            self.globals_by_type
                .remove(&TypeId::of::<G>())
                .with_context(|| format!("no global registered of type {}", type_name::<G>()))
                .unwrap(),
        )
    }

    /// Restore the global of the given type after it is moved to the stack.
    pub(crate) fn end_global_lease<G: Global>(&mut self, lease: GlobalLease<G>) {
        let global_type = TypeId::of::<G>();

        self.push_effect(Effect::NotifyGlobalObservers { global_type });
        self.globals_by_type.insert(global_type, lease.global);
    }

    pub(crate) fn new_entity_observer(
        &self,
        key: TypeId,
        value: NewEntityListener,
    ) -> Subscription {
        let (subscription, activate) = self.new_entity_observers.insert(key, value);
        activate();
        subscription
    }

    /// Arrange for `on_new` to run whenever an entity of type `T` is created.
    ///
    /// This applies to models as well as renderable views. The callback gets
    /// mutable access to the new value, its [`Context`], and the creating
    /// window when construction happened inside a window; otherwise the window
    /// argument is `None`. Retain the subscription while new entities should
    /// be observed.
    ///
    /// Registration is immediate; delivery follows construction during effect
    /// processing. Entities constructed with [`AppContext::insert_entity`]
    /// from a reservation do not invoke this hook.
    pub fn observe_new<T: 'static>(
        &self,
        on_new: impl 'static + Fn(&mut T, Option<&mut Window>, &mut Context<T>),
    ) -> Subscription {
        self.new_entity_observer(
            TypeId::of::<T>(),
            Box::new(
                move |any_entity: AnyEntity, window: &mut Option<&mut Window>, cx: &mut App| {
                    any_entity
                        .downcast::<T>()
                        .unwrap()
                        .update(cx, |entity_state, cx| {
                            on_new(entity_state, window.as_deref_mut(), cx)
                        })
                },
            ),
        )
    }

    /// Observe the release of an entity. The callback runs after its last
    /// strong handle is gone and before its value is dropped.
    pub fn observe_release<T>(
        &self,
        handle: &Entity<T>,
        on_release: impl FnOnce(&mut T, &mut App) + 'static,
    ) -> Subscription
    where
        T: 'static,
    {
        let (subscription, activate) = self.release_listeners.insert(
            handle.entity_id(),
            Box::new(move |entity, cx| {
                let entity = entity.downcast_mut().expect("invalid entity type");
                on_release(entity, cx)
            }),
        );
        activate();
        subscription
    }

    /// Observe the release of an entity with access to a window.
    ///
    /// The callback runs after the last strong handle is gone but before the
    /// value is dropped. If the window has closed or cannot be updated at that
    /// time, the callback is skipped. Retain the subscription to keep it armed.
    pub fn observe_release_in<T>(
        &self,
        handle: &Entity<T>,
        window: &Window,
        on_release: impl FnOnce(&mut T, &mut Window, &mut App) + 'static,
    ) -> Subscription
    where
        T: 'static,
    {
        let window_handle = window.handle;
        self.observe_release(handle, move |entity, cx| {
            let _ = window_handle.update(cx, |_, window, cx| on_release(entity, window, cx));
        })
    }

    /// Observes resolved keystrokes from any app window.
    ///
    /// The callback runs after key-binding resolution and dispatch. A consumed
    /// action is still reported in [`KeystrokeEvent::action`]; raw key events
    /// stopped by an element handler are not reported. Pending chord prefixes
    /// are not reported as they arrive. A handled replay reports its action
    /// with an empty context stack; unhandled replayed keys are not reported.
    /// Observations concern key-down, not key-up or text composition.
    /// Registration is immediate; keep the returned subscription.
    ///
    /// Use [`intercept_keystrokes`](Self::intercept_keystrokes) to prevent an
    /// input from reaching action dispatch.
    pub fn observe_keystrokes(
        &mut self,
        mut f: impl FnMut(&KeystrokeEvent, &mut Window, &mut App) + 'static,
    ) -> Subscription {
        fn inner(
            keystroke_observers: &SubscriberSet<(), KeystrokeObserver>,
            handler: KeystrokeObserver,
        ) -> Subscription {
            let (subscription, activate) = keystroke_observers.insert((), handler);
            activate();
            subscription
        }

        inner(
            &self.keystroke_observers,
            Box::new(move |event, window, cx| {
                f(event, window, cx);
                true
            }),
        )
    }

    /// Intercepts keystrokes before key-binding resolution in any app window.
    ///
    /// Call [`stop_propagation`](Self::stop_propagation) in the callback to
    /// prevent action dispatch. This runs before an action has been selected,
    /// so the event's `action` is `None`. Keep the returned subscription while
    /// interception is needed; prefer an element handler for behavior limited
    /// to one focused view.
    pub fn intercept_keystrokes(
        &mut self,
        mut f: impl FnMut(&KeystrokeEvent, &mut Window, &mut App) + 'static,
    ) -> Subscription {
        fn inner(
            keystroke_interceptors: &SubscriberSet<(), KeystrokeObserver>,
            handler: KeystrokeObserver,
        ) -> Subscription {
            let (subscription, activate) = keystroke_interceptors.insert((), handler);
            activate();
            subscription
        }

        inner(
            &self.keystroke_interceptors,
            Box::new(move |event, window, cx| {
                f(event, window, cx);
                true
            }),
        )
    }

    /// Adds key bindings and schedules windows to refresh their dispatch trees.
    ///
    /// Later bindings take precedence at the same context depth. Each binding
    /// selects an action; register a handler separately with an element's
    /// [`on_action`](crate::InteractiveElement::on_action) or [`Self::on_action`].
    /// See [`KeyBinding`] for sequences and context predicates.
    // docs:examples:begin
    #[doc = include_str!("docs/examples/gpui-App-bind-keys-b1c931c1.md")]
    // docs:examples:end
    pub fn bind_keys(&mut self, bindings: impl IntoIterator<Item = KeyBinding>) {
        self.keymap.borrow_mut().add_bindings(bindings);
        self.pending_effects.push_back(Effect::RefreshWindows);
    }

    /// Clear all key bindings in the app.
    pub fn clear_key_bindings(&mut self) {
        self.keymap.borrow_mut().clear();
        self.pending_effects.push_back(Effect::RefreshWindows);
    }

    /// Returns shared access to this app's keymap.
    ///
    /// Prefer [`bind_keys`](Self::bind_keys) and
    /// [`clear_key_bindings`](Self::clear_key_bindings) for mutation: those
    /// methods also refresh windows. A direct `RefCell` borrow obeys ordinary
    /// runtime borrow checks and does not schedule a refresh itself.
    pub fn key_bindings(&self) -> Rc<RefCell<Keymap>> {
        self.keymap.clone()
    }

    /// Adds an app-wide handler for action `A`, retained for the app's lifetime.
    ///
    /// Window dispatch reaches these handlers after bubbling through the
    /// focused element path, if no element consumes the action. Newer global
    /// handlers run first. Call [`propagate`](Self::propagate) to let a window
    /// dispatch continue to an older global handler.
    ///
    /// These handlers also receive programmatic and menu dispatch, and
    /// [`dispatch_action`](Self::dispatch_action) can invoke them when no window
    /// is active. Prefer an element handler for view-specific behavior.
    pub fn on_action<A: Action>(
        &mut self,
        listener: impl Fn(&A, &mut Self) + 'static,
    ) -> &mut Self {
        self.global_action_listeners
            .entry(TypeId::of::<A>())
            .or_default()
            .push(Rc::new(move |action, phase, cx| {
                if phase == DispatchPhase::Bubble {
                    let action = action.downcast_ref().unwrap();
                    listener(action, cx)
                }
            }));
        self
    }

    /// Stops further delivery of the input or action currently being dispatched.
    ///
    /// Mouse and raw key handlers propagate by default. Stopping a bubbling
    /// event prevents delivery to remaining mouse listeners or keyboard
    /// ancestors; stopping during capture also prevents the bubble phase.
    /// Action handlers already consume by default during bubbling.
    ///
    /// Dispatch checks this flag after the callback returns. Calling
    /// [`propagate`](Self::propagate) later in the same callback reverses it.
    pub fn stop_propagation(&mut self) {
        self.propagate_event = false;
    }

    /// Allows the current dispatch to continue after this callback.
    ///
    /// A bubbling action handler consumes an action by default. Call this when
    /// it cannot handle the action, or when an ancestor should handle it too.
    /// For example, an editor at its first line can propagate a movement action
    /// so a parent chooses the next focus target.
    ///
    /// This reverses [`stop_propagation`](Self::stop_propagation) within the
    /// current callback; it does not replay dispatch that has already stopped.
    pub fn propagate(&mut self) {
        self.propagate_event = true;
    }

    /// Build an action from some arbitrary data, typically a keymap entry.
    pub fn build_action(
        &self,
        name: &str,
        data: Option<serde_json::Value>,
    ) -> std::result::Result<Box<dyn Action>, ActionBuildError> {
        self.actions.build_action(name, data)
    }

    /// Get all action names that have been registered. Note that registration only allows for
    /// actions to be built dynamically, and is unrelated to binding actions in the element tree.
    pub fn all_action_names(&self) -> &[&'static str] {
        self.actions.all_action_names()
    }

    /// Returns complete key-sequence matches for `input`, ignoring focus and context.
    ///
    /// Results are in reverse insertion order, with newer bindings first.
    /// Prefixes awaiting another key are excluded. These are possible matches,
    /// not a prediction of the focused element's dispatch: context predicates
    /// and propagation can change which action actually runs.
    pub fn all_bindings_for_input(&self, input: &[Keystroke]) -> Vec<KeyBinding> {
        RefCell::borrow(&self.keymap).all_bindings_for_input(input)
    }

    /// Get all non-internal actions that have been registered, along with their schemas.
    pub fn action_schemas(
        &self,
        generator: &mut schemars::SchemaGenerator,
    ) -> Vec<(&'static str, Option<schemars::Schema>)> {
        self.actions.action_schemas(generator)
    }

    /// Get the schema for a specific action by name.
    /// Returns `None` if the action is not found.
    /// Returns `Some(None)` if the action exists but has no schema.
    /// Returns `Some(Some(schema))` if the action exists and has a schema.
    pub fn action_schema_by_name(
        &self,
        name: &str,
        generator: &mut schemars::SchemaGenerator,
    ) -> Option<Option<schemars::Schema>> {
        self.actions.action_schema_by_name(name, generator)
    }

    /// Get a map from a deprecated action name to the canonical name.
    pub fn deprecated_actions_to_preferred_actions(&self) -> &HashMap<&'static str, &'static str> {
        self.actions.deprecated_aliases()
    }

    /// Get a map from an action name to the deprecation messages.
    pub fn action_deprecation_messages(&self) -> &HashMap<&'static str, &'static str> {
        self.actions.deprecation_messages()
    }

    /// Get a map from an action name to the documentation.
    pub fn action_documentation(&self) -> &HashMap<&'static str, &'static str> {
        self.actions.documentation()
    }

    /// Registers cleanup to run during [`shutdown`](Self::shutdown).
    ///
    /// The callback cannot veto shutdown. It runs once with synchronous app
    /// access and returns an owned future; native platforms wait up to
    /// [`SHUTDOWN_TIMEOUT`] for all such futures together. Browser cleanup is
    /// scheduled without blocking and may be interrupted by page teardown.
    /// Keep the returned subscription until shutdown or detach it for app-wide
    /// cleanup. See [`Context::on_app_quit`] for entity-scoped cleanup.
    ///
    /// Copy any data needed from windows in the synchronous callback. Shutdown
    /// removes the windows before polling the returned futures, so a future
    /// cannot rely on reacquiring them. The timeout bounds the cleanup attempt;
    /// save irreplaceable work during normal operation as well.
    pub fn on_app_quit<Fut>(
        &self,
        mut on_quit: impl FnMut(&mut App) -> Fut + 'static,
    ) -> Subscription
    where
        Fut: 'static + Future<Output = ()>,
    {
        let (subscription, activate) = self.quit_observers.insert(
            (),
            Box::new(move |cx| {
                let future = on_quit(cx);
                future.boxed_local()
            }),
        );
        activate();
        subscription
    }

    /// Observe a restart request before the platform attempts to relaunch.
    ///
    /// Registration is immediate. Retain the returned subscription; dropping
    /// it cancels the callback. The callback runs synchronously from
    /// [`restart`](Self::restart), before any quit callbacks the platform's
    /// restart path triggers. A request does not guarantee that the backend
    /// supports restart or that a replacement process starts successfully.
    pub fn on_app_restart(&self, mut on_restart: impl 'static + FnMut(&mut App)) -> Subscription {
        let (subscription, activate) = self.restart_observers.insert(
            (),
            Box::new(move |cx| {
                on_restart(cx);
                true
            }),
        );
        activate();
        subscription
    }

    /// Receives the identity of a window removed during a window update.
    ///
    /// The window is already inaccessible when the callback runs. Keep the
    /// returned subscription to receive later closures. Bulk window cleanup
    /// during [`shutdown`](Self::shutdown) does not invoke this hook.
    pub fn on_window_closed(
        &self,
        mut on_closed: impl FnMut(&mut App, WindowId) + 'static,
    ) -> Subscription {
        let (subscription, activate) = self.window_closed_observers.insert((), Box::new(on_closed));
        activate();
        subscription
    }

    pub(crate) fn clear_pending_keystrokes(&mut self) {
        for window in self.windows() {
            window
                .update(self, |_, window, cx| {
                    window.clear_pending_keystrokes(cx);
                })
                .ok();
        }
    }

    /// Returns whether the focused path or an app-wide listener can handle this action type.
    ///
    /// This checks handler registration, not whether a key binding exists or
    /// whether a handler will accept the action's particular payload. If the
    /// active window cannot be accessed, only app-wide listeners are checked.
    pub fn is_action_available(&mut self, action: &dyn Action) -> bool {
        let mut action_available = false;
        if let Some(window) = self.active_window()
            && let Ok(window_action_available) =
                window.update(self, |_, window, cx| window.is_action_available(action, cx))
        {
            action_available = window_action_available;
        }

        action_available
            || self
                .global_action_listeners
                .contains_key(&action.as_any().type_id())
    }

    /// Sets the menu bar for this application. This will replace any existing menu bar.
    pub fn set_menus(&self, menus: impl IntoIterator<Item = Menu>) {
        let menus: Vec<Menu> = menus.into_iter().collect();
        self.platform.set_menus(menus, &self.keymap.borrow());
    }

    /// Gets the menu bar for this application.
    pub fn get_menus(&self) -> Option<Vec<OwnedMenu>> {
        self.platform.get_menus()
    }

    /// Sets the right click menu for the app icon in the dock
    pub fn set_dock_menu(&self, menus: Vec<MenuItem>) {
        self.platform.set_dock_menu(menus, &self.keymap.borrow())
    }

    /// Performs the action associated with the given dock menu item, only used on Windows for now.
    pub fn perform_dock_menu_action(&self, action: usize) {
        self.platform.perform_dock_menu_action(action);
    }

    /// Adds given path to the bottom of the list of recent paths for the application.
    /// The list is usually shown on the application icon's context menu in the dock,
    /// and allows to open the recent files via that context menu.
    /// If the path is already in the list, it will be moved to the bottom of the list.
    pub fn add_recent_document(&self, path: &Path) {
        self.platform.add_recent_document(path);
    }

    /// Updates the jump list with the updated list of recent paths for the application, only used on Windows for now.
    /// Note that this also sets the dock menu on Windows.
    pub fn update_jump_list(
        &self,
        menus: Vec<MenuItem>,
        entries: Vec<SmallVec<[PathBuf; 2]>>,
    ) -> Task<Vec<SmallVec<[PathBuf; 2]>>> {
        self.platform.update_jump_list(menus, entries)
    }

    /// Dispatch an action to the currently active window or global action handler
    /// See [`crate::Action`] for more information on how actions work
    pub fn dispatch_action(&mut self, action: &dyn Action) {
        if let Some(active_window) = self.active_window() {
            active_window
                .update(self, |_, window, cx| {
                    window.dispatch_action(action.boxed_clone(), cx)
                })
                .log_err();
        } else {
            self.dispatch_global_action(action);
        }
    }

    fn dispatch_global_action(&mut self, action: &dyn Action) {
        self.propagate_event = true;

        if let Some(mut global_listeners) = self
            .global_action_listeners
            .remove(&action.as_any().type_id())
        {
            for listener in &global_listeners {
                listener(action.as_any(), DispatchPhase::Capture, self);
                if !self.propagate_event {
                    break;
                }
            }

            global_listeners.extend(
                self.global_action_listeners
                    .remove(&action.as_any().type_id())
                    .unwrap_or_default(),
            );

            self.global_action_listeners
                .insert(action.as_any().type_id(), global_listeners);
        }

        if self.propagate_event
            && let Some(mut global_listeners) = self
                .global_action_listeners
                .remove(&action.as_any().type_id())
        {
            for listener in global_listeners.iter().rev() {
                listener(action.as_any(), DispatchPhase::Bubble, self);
                if !self.propagate_event {
                    break;
                }
            }

            global_listeners.extend(
                self.global_action_listeners
                    .remove(&action.as_any().type_id())
                    .unwrap_or_default(),
            );

            self.global_action_listeners
                .insert(action.as_any().type_id(), global_listeners);
        }
    }

    /// Is there currently something being dragged?
    pub fn has_active_drag(&self) -> bool {
        self.active_drag.is_some()
    }

    /// Returns a reference to the current drag payload.
    pub fn active_drag(&self) -> Option<&AnyDrag> {
        self.active_drag.as_ref()
    }

    /// Gets the cursor style of the currently active drag operation.
    pub fn active_drag_cursor_style(&self) -> Option<CursorStyle> {
        self.active_drag.as_ref().and_then(|drag| drag.cursor_style)
    }

    /// Installs the app's current internal drag.
    ///
    /// Call [`Window::refresh`] to draw its view immediately. This method does
    /// not schedule a redraw and debug builds assert that no drag is active.
    pub fn start_drag(&mut self, drag: AnyDrag) {
        debug_assert!(self.active_drag.is_none());
        self.active_drag = Some(drag);
    }

    /// Removes the current internal drag and returns its payload.
    ///
    /// Returns `None` if no internal drag is active. This does not refresh the
    /// window; [`stop_active_drag`](Self::stop_active_drag) does. Native drag
    /// sessions are managed separately by the platform's drag-end callback.
    pub fn stop_drag(&mut self, window: &Window) -> Option<Arc<dyn Any>> {
        let drag = self.active_drag.take();
        if drag.is_some()
            && let Some(platform_drag) = self.platform_owned_drag.as_ref()
        {
            if platform_drag.source_window == window.window_handle().window_id()
                && matches!(
                    &platform_drag.state,
                    PlatformOwnedDragState::RestoredInSourceWindow
                )
            {
                self.platform_owned_drag = None;
            }
        }
        Some(drag?.value)
    }

    /// Stops active drag and clears any related effects.
    pub fn stop_active_drag(&mut self, window: &mut Window) -> bool {
        if self.stop_drag(window).is_some() {
            window.refresh();
            true
        } else {
            false
        }
    }

    pub(crate) fn hand_active_drag_to_platform(&mut self, source_window: WindowId) -> bool {
        let Some(drag) = self.active_drag.take() else {
            return false;
        };
        self.platform_owned_drag = Some(PlatformOwnedDrag {
            source_window,
            state: PlatformOwnedDragState::Suspended(drag),
        });
        true
    }

    pub(crate) fn restore_platform_drag(&mut self, source_window: WindowId) -> bool {
        let Some(platform_drag) = self
            .platform_owned_drag
            .as_mut()
            .filter(|drag| drag.source_window == source_window)
        else {
            return false;
        };
        let state = std::mem::replace(
            &mut platform_drag.state,
            PlatformOwnedDragState::RestoredInSourceWindow,
        );
        let PlatformOwnedDragState::Suspended(drag) = state else {
            return false;
        };
        self.active_drag = Some(drag);
        true
    }

    pub(crate) fn hand_restored_drag_to_platform(&mut self, source_window: WindowId) -> bool {
        let Some(platform_drag) = self.platform_owned_drag.as_mut().filter(|drag| {
            drag.source_window == source_window
                && matches!(&drag.state, PlatformOwnedDragState::RestoredInSourceWindow)
        }) else {
            return false;
        };
        let Some(drag) = self.active_drag.take() else {
            return false;
        };
        platform_drag.state = PlatformOwnedDragState::Suspended(drag);
        true
    }

    pub(crate) fn end_platform_drag(&mut self, source_window: WindowId) -> bool {
        if !self
            .platform_owned_drag
            .as_ref()
            .is_some_and(|drag| drag.source_window == source_window)
        {
            return false;
        }
        self.platform_owned_drag = None;
        self.active_drag = None;
        true
    }

    /// Sets the cursor style for the currently active drag operation.
    pub fn set_active_drag_cursor_style(
        &mut self,
        cursor_style: CursorStyle,
        window: &mut Window,
    ) -> bool {
        if let Some(ref mut drag) = self.active_drag {
            drag.cursor_style = Some(cursor_style);
            window.refresh();
            true
        } else {
            false
        }
    }

    /// Installs an app-wide builder for prompts rendered inside a GPUI window.
    ///
    /// [`Window::prompt`] calls this instead of asking the platform for a
    /// native dialog. The builder receives message text and ordered answers;
    /// attach its view with [`PromptHandle::with_view`] and return the resulting
    /// handle. Emit [`PromptResponse`](crate::PromptResponse) to choose an answer. The builder owns
    /// the view's keyboard, accessibility, and styling behavior.
    ///
    /// Use `cx.set_prompt_builder(gpui::fallback_prompt_renderer)` for the
    /// built-in in-window appearance on every platform. Do not call
    /// [`Window::prompt`] from the builder: reentrant construction panics.
    pub fn set_prompt_builder(
        &mut self,
        renderer: impl Fn(
            PromptLevel,
            &str,
            Option<&str>,
            &[PromptButton],
            PromptHandle,
            &mut Window,
            &mut App,
        ) -> RenderablePromptHandle
        + 'static,
    ) {
        self.prompt_builder = Some(PromptBuilder::Custom(Box::new(renderer)));
    }

    /// Restores native prompts with GPUI's in-window fallback when unavailable.
    ///
    /// This changes future prompts; it does not replace an already displayed view.
    pub fn reset_prompt_builder(&mut self) {
        self.prompt_builder = Some(PromptBuilder::Default);
    }

    /// Removes this typed source's task from the app's resource cache.
    ///
    /// The next [`fetch_asset`](Self::fetch_asset) starts a new load. Existing
    /// clones of the shared task or its output remain valid; removing the cache
    /// entry does not discard copies already owned by callers.
    pub fn remove_asset<A: Asset>(&mut self, source: &A::Source) {
        let asset_id = (TypeId::of::<A>(), hash(source));
        self.loading_assets.remove(&asset_id);
    }

    /// Check whether an asset is present in GPUI's cache (loading or loaded),
    /// without fetching it.
    #[cfg(any(test, feature = "headless"))]
    pub fn has_asset<A: Asset>(&self, source: &A::Source) -> bool {
        let asset_id = (TypeId::of::<A>(), hash(source));
        self.loading_assets.contains_key(&asset_id)
    }

    /// Returns a shared load task and whether this call created it.
    ///
    /// The cache key combines the asset type with a hash of `source`. Repeated
    /// requests reuse the same task and completed output until
    /// [`remove_asset`](Self::remove_asset) evicts the entry. `true` means this
    /// call invoked [`Asset::load`] and spawned its future on the background
    /// executor; `false` means it reused a cached task.
    ///
    /// Await the shared task outside a render callback, then notify the owning
    /// view so it can display the result. The cache retains a task clone, so
    /// dropping a caller's clone alone does not cancel loading.
    pub fn fetch_asset<A: Asset>(&mut self, source: &A::Source) -> (Shared<Task<A::Output>>, bool) {
        let asset_id = (TypeId::of::<A>(), hash(source));
        let mut is_first = false;
        let task = self
            .loading_assets
            .remove(&asset_id)
            .map(|boxed_task| *boxed_task.downcast::<Shared<Task<A::Output>>>().unwrap())
            .unwrap_or_else(|| {
                is_first = true;
                let future = A::load(source.clone(), self);

                self.background_executor().spawn(future).shared()
            });

        self.loading_assets.insert(asset_id, Box::new(task.clone()));

        (task, is_first)
    }

    /// Creates an unfocused handle for an element's keyboard-focus identity.
    ///
    /// Store it with the view and attach it during render with
    /// [`track_focus`](crate::InteractiveElement::track_focus). Creating the
    /// handle does not select a window or move focus; call [`FocusHandle::focus`]
    /// with the window that should receive keyboard input.
    #[track_caller]
    pub fn focus_handle(&self) -> FocusHandle {
        FocusHandle::new(&self.focus_handles)
    }

    /// Returns the name for this [`App`].
    #[cfg(any(test, feature = "headless", debug_assertions))]
    pub fn get_name(&self) -> Option<&'static str> {
        self.name
    }

    /// Returns `true` if the platform file picker supports selecting a mix of files and directories.
    pub fn can_select_mixed_files_and_dirs(&self) -> bool {
        self.platform.can_select_mixed_files_and_dirs()
    }

    /// Removes a decoded image's uploads from the windows' sprite atlases.
    ///
    /// Pass the currently borrowed window as `current_window`: an update
    /// temporarily takes it out of the app's window collection. Other windows
    /// are handled automatically. An atlas without this image is unchanged;
    /// renderer errors during removal are ignored.
    ///
    /// This neither removes the app's [`fetch_asset`](Self::fetch_asset) entry
    /// nor invalidates copies of the [`RenderImage`] held by callers. Painting
    /// that image again can upload it again. Evict the owning load cache too
    /// when a later request should reread or decode the source. See the
    /// [cache ownership guide](crate::_documentation::assets#give-the-cache-an-owner).
    pub fn drop_image(&mut self, image: Arc<RenderImage>, current_window: Option<&mut Window>) {
        // remove the texture from all other windows
        for window in self.windows.values_mut().flatten() {
            _ = window.drop_image(image.clone());
        }

        // remove the texture from the current window
        if let Some(window) = current_window {
            _ = window.drop_image(image);
        }
    }

    /// Sets the renderer for the inspector.
    #[cfg(any(feature = "inspector", debug_assertions))]
    pub fn set_inspector_renderer(&mut self, f: crate::InspectorRenderer) {
        self.inspector_renderer = Some(f);
    }

    /// Registers a renderer specific to an inspector state.
    #[cfg(any(feature = "inspector", debug_assertions))]
    pub fn register_inspector_element<T: 'static, R: crate::IntoElement>(
        &mut self,
        f: impl 'static + Fn(crate::InspectorElementId, &T, &mut Window, &mut App) -> R,
    ) {
        self.inspector_element_registry.register(f);
    }

    /// Installs the light semantic palette as [`GlobalColors`].
    ///
    /// This replaces any existing palette and schedules its global observers.
    /// It does not inspect a window's appearance or subscribe to changes.
    /// Use [`Colors::for_appearance`] and [`Self::set_global`] when appearance
    /// should choose the palette. Import [`DefaultColors`](crate::colors::DefaultColors)
    /// to read the installed value with `cx.default_colors()`.
    pub fn init_colors(&mut self) {
        self.set_global(GlobalColors(Arc::new(Colors::default())));
    }
}

impl AppContext for App {
    /// Builds an entity that is owned by the application.
    ///
    /// The given function will be invoked with a [`Context`] and must return an object representing the entity. An
    /// [`Entity`] handle will be returned, which can be used to access the entity in a context.
    fn new<T: 'static>(&mut self, build_entity: impl FnOnce(&mut Context<T>) -> T) -> Entity<T> {
        self.update(|cx| {
            let slot = cx.entities.reserve();
            let handle = slot.clone();
            let entity = build_entity(&mut Context::new_context(cx, slot.downgrade()));

            cx.push_effect(Effect::EntityCreated {
                entity: handle.into_any(),
                tid: TypeId::of::<T>(),
                window: cx.window_update_stack.last().cloned(),
            });

            cx.entities.insert(slot, entity)
        })
    }

    fn reserve_entity<T: 'static>(&mut self) -> Reservation<T> {
        Reservation(self.entities.reserve())
    }

    fn insert_entity<T: 'static>(
        &mut self,
        reservation: Reservation<T>,
        build_entity: impl FnOnce(&mut Context<T>) -> T,
    ) -> Entity<T> {
        self.update(|cx| {
            let slot = reservation.0;
            let entity = build_entity(&mut Context::new_context(cx, slot.downgrade()));
            cx.entities.insert(slot, entity)
        })
    }

    /// Updates the entity referenced by the given handle. The function is passed a mutable reference to the
    /// entity along with a `Context` for the entity.
    fn update_entity<T: 'static, R>(
        &mut self,
        handle: &Entity<T>,
        update: impl FnOnce(&mut T, &mut Context<T>) -> R,
    ) -> R {
        self.update(|cx| {
            let mut entity = cx.entities.lease(handle);
            let result = update(
                &mut entity,
                &mut Context::new_context(cx, handle.downgrade()),
            );
            cx.entities.end_lease(entity);
            result
        })
    }

    fn as_mut<'a, T>(&'a mut self, handle: &Entity<T>) -> GpuiBorrow<'a, T>
    where
        T: 'static,
    {
        GpuiBorrow::new(handle.clone(), self)
    }

    fn read_entity<T, R>(&self, handle: &Entity<T>, read: impl FnOnce(&T, &App) -> R) -> R
    where
        T: 'static,
    {
        let entity = self.entities.read(handle);
        read(entity, self)
    }

    fn notify(&mut self, entity_id: EntityId) {
        let window_invalidators = mem::take(
            self.window_invalidators_by_entity
                .entry(entity_id)
                .or_default(),
        );

        // `window_invalidators_by_entity` is monotonic, so an entry alone
        // doesn't mean the window is currently rendering the entity. Filter
        // through `tracked_entities` to keep invalidation tight to windows
        // that actually display this entity right now.
        let live_invalidators: SmallVec<[WindowInvalidator; 2]> = window_invalidators
            .iter()
            .filter(|(window_id, _)| {
                self.tracked_entities
                    .get(window_id)
                    .is_some_and(|set| set.contains(&entity_id))
            })
            .map(|(_, invalidator)| invalidator.clone())
            .collect();

        if live_invalidators.is_empty() {
            if self.pending_notifications.insert(entity_id) {
                self.pending_effects
                    .push_back(Effect::Notify { emitter: entity_id });
            }
        } else {
            for invalidator in &live_invalidators {
                invalidator.invalidate_view(entity_id, self);
            }
        }

        self.window_invalidators_by_entity
            .insert(entity_id, window_invalidators);
    }

    fn emit<EntityType, EventType>(&mut self, entity: &Entity<EntityType>, event: EventType)
    where
        EntityType: EventEmitter<EventType>,
        EventType: 'static,
    {
        let event = self
            .event_arena
            .alloc(|| event)
            .map(|it| it as &mut dyn Any);
        self.pending_effects.push_back(Effect::Emit {
            emitter: entity.entity_id(),
            event_type: TypeId::of::<EventType>(),
            event,
        });
    }

    fn update_window<T, F>(&mut self, handle: AnyWindowHandle, update: F) -> Result<T>
    where
        F: FnOnce(AnyView, &mut Window, &mut App) -> T,
    {
        self.update_window_id(handle.id, update)
    }

    fn with_window<R>(
        &mut self,
        entity_id: EntityId,
        f: impl FnOnce(&mut Window, &mut App) -> R,
    ) -> Option<R> {
        App::with_window(self, entity_id, f)
    }

    fn read_window<T, R>(
        &self,
        window: &WindowHandle<T>,
        read: impl FnOnce(Entity<T>, &App) -> R,
    ) -> Result<R>
    where
        T: 'static,
    {
        let window = self
            .windows
            .get(window.id)
            .context("window not found")?
            .as_deref()
            .expect("attempted to read a window that is already on the stack");

        let root_view = window.root.clone().unwrap();
        let view = root_view
            .downcast::<T>()
            .map_err(|_| anyhow!("root view's type has changed"))?;

        Ok(read(view, self))
    }

    fn background_spawn<R>(&self, future: impl Future<Output = R> + Send + 'static) -> Task<R>
    where
        R: Send + 'static,
    {
        self.background_executor.spawn(future)
    }

    fn read_global<G, R>(&self, callback: impl FnOnce(&G, &App) -> R) -> R
    where
        G: Global,
    {
        let mut g = self.global::<G>();
        callback(g, self)
    }

    fn insert_global_entity<T: 'static>(&mut self, entity: Entity<T>) {
        let any = entity.into_any();
        if !self.global_entities.contains(&any) {
            self.global_entities.push(any);
        }
    }

    fn remove_global_entity<T: 'static>(&mut self, entity: &Entity<T>) {
        self.global_entities
            .retain(|any| any.entity_id() != entity.entity_id());
    }

    fn global_entities<T: 'static>(&self) -> impl Iterator<Item = Entity<T>> {
        let mut iter = self.global_entities.iter();
        iter.filter_map(|any| any.clone().downcast::<T>().ok())
    }
}

/// These effects are processed at the end of each application update cycle.
pub(crate) enum Effect {
    Notify {
        emitter: EntityId,
    },
    Emit {
        emitter: EntityId,
        event_type: TypeId,
        event: ArenaBox<dyn Any>,
    },
    RefreshWindows,
    NotifyGlobalObservers {
        global_type: TypeId,
    },
    Defer {
        callback: Box<dyn FnOnce(&mut App) + 'static>,
    },
    EntityCreated {
        entity: AnyEntity,
        tid: TypeId,
        window: Option<WindowId>,
    },
}

impl std::fmt::Debug for Effect {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            Effect::Notify { emitter } => write!(f, "Notify({})", emitter),
            Effect::Emit { emitter, .. } => write!(f, "Emit({:?})", emitter),
            Effect::RefreshWindows => write!(f, "RefreshWindows"),
            Effect::NotifyGlobalObservers { global_type } => {
                write!(f, "NotifyGlobalObservers({:?})", global_type)
            }
            Effect::Defer { .. } => write!(f, "Defer(..)"),
            Effect::EntityCreated { entity, .. } => write!(f, "EntityCreated({:?})", entity),
        }
    }
}

/// Wraps a global variable value during `update_global` while the value has been moved to the stack.
pub(crate) struct GlobalLease<G: Global> {
    global: Box<dyn Any>,
    global_type: PhantomData<G>,
}

impl<G: Global> GlobalLease<G> {
    fn new(global: Box<dyn Any>) -> Self {
        GlobalLease {
            global,
            global_type: PhantomData,
        }
    }
}

impl<G: Global> Deref for GlobalLease<G> {
    type Target = G;

    fn deref(&self) -> &Self::Target {
        self.global.downcast_ref().unwrap()
    }
}

impl<G: Global> DerefMut for GlobalLease<G> {
    fn deref_mut(&mut self) -> &mut Self::Target {
        self.global.downcast_mut().unwrap()
    }
}

/// Contains state associated with an active drag operation, started by dragging an element
/// within the window or by dragging into the app from the underlying platform.
pub struct AnyDrag {
    /// The view used to render this drag
    pub view: AnyView,

    /// The value of the dragged item, to be dropped
    pub value: Arc<dyn Any>,

    /// This is used to render the dragged item in the same place
    /// on the original element that the drag was initiated
    pub cursor_offset: Point<Pixels>,

    /// The cursor style to use while dragging
    pub cursor_style: Option<CursorStyle>,

    /// Resolves the payload to offer the platform if the drag leaves the window.
    /// Invoked at most once per drag gesture, at promotion time.
    pub external_payload_source: Option<ExternalDragPayloadSource>,
}
impl AnyDrag {
    /// Constructs a new drag with a value and view.
    pub fn new<T: 'static + Sized>(value: T, view: impl Into<AnyView>) -> Self {
        Self {
            view: view.into(),
            value: Arc::new(value),
            cursor_offset: Point::default(),
            cursor_style: None,
            external_payload_source: None,
        }
    }

    /// Assigns the offset of the view from the cursor when dragging begins.
    pub fn offset(mut self, offset: Point<Pixels>) -> Self {
        self.cursor_offset = offset;
        self
    }

    /// Assigns the style of the cursor while dragging is active.
    pub fn cursor_style(mut self, style: Option<CursorStyle>) -> Self {
        self.cursor_style = style;
        self
    }

    /// Assigns a constructor of an external payload to be called when the drag moves outside of the application window.
    pub fn external_payload(
        mut self,
        predicate: impl FnOnce(&mut Window, &mut App) -> Option<ExternalDragPayload> + 'static,
    ) -> Self {
        self.external_payload_source = Some(Box::new(predicate));
        self
    }

    /// Returns whether the dragged payload has concrete type `T`.
    ///
    /// This tests the value inside the shared pointer, not the pointer's type.
    /// Borrow it with `drag.value.downcast_ref::<T>()` when the payload is needed.
    pub fn is_type<T: 'static>(&self) -> bool {
        self.value.as_ref().type_id() == TypeId::of::<T>()
    }
}

/// Lazily resolves the payload handed to the platform when an internal drag is
/// promoted to a native drag session.
pub type ExternalDragPayloadSource =
    Box<dyn FnOnce(&mut Window, &mut App) -> Option<ExternalDragPayload> + 'static>;

/// Contains state associated with a tooltip. You'll only need this struct if you're implementing
/// tooltip behavior on a custom element. Otherwise, use [Div::tooltip](crate::Interactivity::tooltip).
#[derive(Clone)]
pub struct AnyTooltip {
    /// The view used to display the tooltip
    pub view: AnyView,

    /// The absolute position of the mouse when the tooltip was deployed.
    pub mouse_position: Point<Pixels>,

    /// Given the bounds of the tooltip, checks whether the tooltip should still be visible and
    /// updates its state accordingly. This is needed atop the hovered element's mouse move handler
    /// to handle the case where the element is not painted (e.g. via use of `visible_on_hover`).
    pub check_visible_and_update: Rc<dyn Fn(Bounds<Pixels>, &mut Window, &mut App) -> bool>,
}

/// A key press reported before or after key binding resolution.
///
/// [`App::intercept_keystrokes`] reports the press before resolution, with no
/// action. [`App::observe_keystrokes`] reports a consumed action or an unhandled
/// ordinary key press after dispatch. Neither is a stream of key releases or
/// composed text; see the [input chapter](crate::_documentation::input).
#[derive(Debug)]
pub struct KeystrokeEvent {
    /// The key and modifiers of the reported press.
    pub keystroke: Keystroke,

    /// The action whose dispatch stopped propagation, if any.
    ///
    /// This is always `None` for interceptors. For observers, `None` does not
    /// prove that no binding matched: its action handlers may all have
    /// propagated. An action's presence describes dispatch, not whether its
    /// handler changed application state.
    pub action: Option<Box<dyn Action>>,

    /// Key contexts ordered from the root toward the focused node.
    ///
    /// Nodes without a context contribute no entry. A consumed action replayed
    /// from pending chord input is currently reported with an empty stack.
    pub context_stack: Vec<KeyContext>,
}

/// A mutable entity lease that notifies observers when it is dropped.
///
/// Obtain one with [`Entity::as_mut`]. It borrows the app and dereferences to
/// the stored value, so the same app cannot be borrowed again while the guard
/// is alive. Dropping the guard releases the entity before flushing effects;
/// observers can then read the updated value. It notifies even if no mutation
/// occurred. For access to the entity's [`Context`] and explicit notification,
/// use [`Entity::update`] instead.
pub struct GpuiBorrow<'a, T> {
    inner: Option<Lease<T>>,
    app: &'a mut App,
}

impl<'a, T: 'static> GpuiBorrow<'a, T> {
    fn new(inner: Entity<T>, app: &'a mut App) -> Self {
        app.start_update();
        let lease = app.entities.lease(&inner);
        Self {
            inner: Some(lease),
            app,
        }
    }
}

impl<'a, T: 'static> std::borrow::Borrow<T> for GpuiBorrow<'a, T> {
    fn borrow(&self) -> &T {
        self.inner.as_ref().unwrap().borrow()
    }
}

impl<'a, T: 'static> std::borrow::BorrowMut<T> for GpuiBorrow<'a, T> {
    fn borrow_mut(&mut self) -> &mut T {
        self.inner.as_mut().unwrap().borrow_mut()
    }
}

impl<'a, T: 'static> std::ops::Deref for GpuiBorrow<'a, T> {
    type Target = T;

    fn deref(&self) -> &Self::Target {
        self.inner.as_ref().unwrap()
    }
}

impl<'a, T: 'static> std::ops::DerefMut for GpuiBorrow<'a, T> {
    fn deref_mut(&mut self) -> &mut T {
        self.inner.as_mut().unwrap()
    }
}

impl<'a, T> Drop for GpuiBorrow<'a, T> {
    fn drop(&mut self) {
        let lease = self.inner.take().unwrap();
        self.app.notify(lease.id);
        self.app.entities.end_lease(lease);
        self.app.finish_update();
    }
}

#[cfg(test)]
mod test {
    use std::{
        cell::{Cell, RefCell},
        ffi::OsString,
        path::PathBuf,
        rc::Rc,
    };

    #[cfg(unix)]
    use std::os::unix::ffi::OsStringExt;

    use crate::{AppContext, Context, Empty, IntoElement, Render, TestAppContext, Window};

    struct RenderCounter(Rc<Cell<usize>>);

    impl Render for RenderCounter {
        fn render(&mut self, _: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
            self.0.set(self.0.get() + 1);
            Empty
        }
    }

    #[test]
    fn embedded_update_flushes_effects_after_the_outer_closure() {
        let cx = TestAppContext::single();
        let handle = super::ApplicationHandle {
            app: cx.app.clone(),
        };
        let completed = Rc::new(Cell::new(false));

        handle.update(|app| {
            app.defer({
                let completed = completed.clone();
                move |_| completed.set(true)
            });
            app.new(|_| 0_u32);
            assert!(
                !completed.get(),
                "nested entity creation must not end the outer update"
            );
        });

        assert!(
            completed.get(),
            "the embedder must not need another event to flush effects"
        );
    }

    #[gpui::test]
    fn adding_a_tab_group_after_removal_preserves_other_groups(cx: &mut TestAppContext) {
        use super::{SystemWindowTab, SystemWindowTabController};

        let windows: Vec<_> = (0..4).map(|_| cx.add_window(|_, _| Empty)).collect();
        cx.update(|app| {
            for (index, window) in windows.iter().take(3).enumerate() {
                SystemWindowTabController::add_tab(
                    app,
                    window.window_id(),
                    vec![SystemWindowTab::new(
                        format!("Window {index}").into(),
                        (*window).into(),
                    )],
                );
            }
            SystemWindowTabController::remove_tab(app, windows[0].window_id());
            SystemWindowTabController::add_tab(
                app,
                windows[3].window_id(),
                vec![SystemWindowTab::new("New window".into(), windows[3].into())],
            );

            let controller = app.global::<SystemWindowTabController>();
            assert_eq!(controller.tab_groups().len(), 3);
            for window in &windows[1..] {
                assert_eq!(controller.tabs(window.window_id()).unwrap().len(), 1);
            }
        });
    }

    #[gpui::test]
    fn drag_type_matches_payload_instead_of_shared_pointer(cx: &mut TestAppContext) {
        cx.update(|cx| {
            let view = cx.new(|_| Empty);
            let drag = super::AnyDrag::new(String::from("row"), view);
            assert!(drag.is_type::<String>());
            assert!(!drag.is_type::<usize>());
            assert!(!drag.is_type::<std::sync::Arc<dyn std::any::Any>>());
            assert_eq!(drag.value.downcast_ref::<String>().unwrap(), "row");
        });
    }

    #[gpui::test]
    fn async_app_refresh_flushes_refresh_effect(cx: &mut TestAppContext) {
        let render_count = Rc::new(Cell::new(0));

        let _window = cx.add_window({
            let render_count = render_count.clone();
            move |_, _| RenderCounter(render_count)
        });

        cx.run_until_parked();
        let render_count_before_refresh = render_count.get();

        cx.to_async().refresh();

        assert_eq!(render_count.get(), render_count_before_refresh + 1);
    }

    #[test]
    fn test_gpui_borrow() {
        let cx = TestAppContext::single();
        let observation_count = Rc::new(RefCell::new(0));

        let state = cx.update(|cx| {
            let state = cx.new(|_| false);
            cx.observe(&state, {
                let observation_count = observation_count.clone();
                move |_, _| {
                    let mut count = observation_count.borrow_mut();
                    *count += 1;
                }
            })
            .detach();

            state
        });

        cx.update(|cx| {
            // Calling this like this so that we don't clobber the borrow_mut above
            *std::borrow::BorrowMut::borrow_mut(&mut state.as_mut(cx)) = true;
        });

        cx.update(|cx| {
            state.write(cx, false);
        });

        assert_eq!(*observation_count.borrow(), 2);
    }

    #[gpui::test]
    async fn test_restart_preserves_path_and_arguments(cx: &mut TestAppContext) {
        #[cfg(unix)]
        let user_data_dir = OsString::from_vec(b"/tmp/zed data/\xff".to_vec());
        #[cfg(not(unix))]
        let user_data_dir = OsString::from("C:\\zed data");
        let arguments = vec![OsString::from("--user-data-dir"), user_data_dir];
        let restart_path = PathBuf::from("updated-zed");
        let _application =
            super::Application(cx.app.clone()).with_restart_arguments(arguments.clone());
        let restart = cx.expect_restart();

        cx.update(|cx| {
            cx.set_restart_path(restart_path.clone());
            cx.restart();
        });

        let (path, restart_arguments) = restart.await.expect("restart was not requested");
        assert_eq!(path, Some(restart_path));
        assert_eq!(restart_arguments, arguments);
    }
}
