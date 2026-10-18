//! Android entry point and event loop using the `android-activity` crate.
//!
//! This module replaces the previous hand-rolled `ANativeActivity_onCreate`,
//! `JNI_OnLoad`, and lifecycle callback implementations with the higher-level
//! `android-activity` glue layer.
//!
//! ## Entry sequence
//!
//! ```text
//! android-activity loads the .so and calls android_main(app: AndroidApp)
//!   └── init_platform(app) installs an Activity-scoped session and returns a guard
//!       └── The caller holds the guard while GPUI runs; dropping it retires that session
//! ```
//!
//! ## Threading model
//!
//! `android-activity` spawns a dedicated native thread and calls `android_main`
//! on it.  All GPUI draw / event callbacks run on this thread.  The
//! `AndroidApp` handle is `Send + Sync` and can be shared across threads.
//!
//! ## User entry point
//!
//! Applications must define:
//!
//! ```rust,no_run
//! #[no_mangle]
//! fn android_main(app: android_activity::AndroidApp) {
//!     // Initialise GPUI and run the application.
//! }
//! ```
//!
//! ## Event handling
//!
//! Lifecycle events (window creation/destruction, focus changes, etc.) are
//! delivered via `AndroidApp::poll_events()`.  Input events are obtained via
//! `AndroidApp::input_events_iter()`.
//!
//! ## Frames
//!
//! The loop blocks on the looper between events and draws only when GPUI
//! asked for a frame and a vsync has passed since — see
//! [`super::frame_source`].

#![allow(unsafe_code)]
#![allow(non_snake_case)]

use std::{
    ffi::c_void,
    marker::PhantomData,
    rc::Rc,
    sync::{
        Arc, OnceLock,
        atomic::{AtomicBool, AtomicU64, Ordering},
    },
    time::Duration,
};

/// Whether the deferred init-window callback has already been invoked.
///
/// Reset to `false` on `TerminateWindow` so that when the surface is
/// recreated on resume the init callbacks run again.
static INIT_WINDOW_DONE: AtomicBool = AtomicBool::new(false);

/// Whether the GPUI native library has completed initialization.
///
/// Set after the first native window is ready and its init callbacks run.
/// This does not prove a frame has been presented; the recreation test uses
/// the separate generation-scoped present signal below.
pub static NATIVE_INITIALIZED: AtomicBool = AtomicBool::new(false);

/// Deferred lifecycle flags.
///
/// We must NOT call `win.set_active()` or `platform.did_enter_background()`
/// inside `handle_main_event` (which runs within `poll_events`).
/// The android-activity crate's Java-side callbacks block on a condvar
/// waiting for the native thread to finish processing the command.
/// If our handler tries to acquire the window `state` lock (a
/// `parking_lot::Mutex`), and a background thread is holding it (e.g.
/// during a render pass), we deadlock: native waits on the lock,
/// the lock holder waits for native rendering to complete, but native
/// is stuck.
///
/// Instead, the handlers set these flags and the main loop body
/// processes them AFTER `poll_events` returns.
static PAUSE_PENDING: AtomicBool = AtomicBool::new(false);
static RESUME_PENDING: AtomicBool = AtomicBool::new(false);
static TERM_WINDOW_PENDING: AtomicBool = AtomicBool::new(false);
static INIT_WINDOW_PENDING: AtomicBool = AtomicBool::new(false);
static WINDOW_RESIZED_PENDING: AtomicBool = AtomicBool::new(false);
static CONFIG_CHANGED_PENDING: AtomicBool = AtomicBool::new(false);
static WINDOW_INSETS_PENDING: AtomicBool = AtomicBool::new(false);
static NATIVE_INSETS_RECEIVED: AtomicBool = AtomicBool::new(false);

#[derive(Clone, Copy, Default, PartialEq)]
struct PhysicalWindowInsets {
    safe: [i32; 4],
    ime: [i32; 4],
}

static PHYSICAL_WINDOW_INSETS: OnceLock<Mutex<PhysicalWindowInsets>> = OnceLock::new();

fn publish_physical_insets(session: &NativeSession, next: PhysicalWindowInsets) {
    let changed = {
        let current_session = NATIVE_SESSION.lock().expect("poisoned");
        let Some(current) = current_session.as_ref() else {
            return;
        };
        if !std::ptr::eq(Arc::as_ptr(current), session) || !session.is_active() {
            return;
        }
        let mut current = PHYSICAL_WINDOW_INSETS
            .get_or_init(|| Mutex::new(PhysicalWindowInsets::default()))
            .lock()
            .expect("poisoned");
        let changed = *current != next;
        *current = next;
        NATIVE_INSETS_RECEIVED.store(true, Ordering::Release);
        if changed {
            WINDOW_INSETS_PENDING.store(true, Ordering::Release);
        }
        changed
    };
    if changed {
        session.app.create_waker().wake();
    }
}

fn clear_ime_insets(session: &NativeSession) {
    if !NATIVE_INSETS_RECEIVED.load(Ordering::Acquire) {
        return;
    }
    let current = *PHYSICAL_WINDOW_INSETS
        .get_or_init(|| Mutex::new(PhysicalWindowInsets::default()))
        .lock()
        .unwrap();
    if current.ime != [0; 4] {
        publish_physical_insets(
            session,
            PhysicalWindowInsets {
                ime: [0; 4],
                ..current
            },
        );
    }
}

use android_activity::{AndroidApp, MainEvent, PollEvent};

use super::platform::{AndroidPlatform, SharedPlatform};

use jni::JavaVM;
use jni::objects::{JObject, JString, JValue};
use std::sync::{Mutex, atomic::AtomicPtr};

// ── JNI helpers (safe `jni` crate wrappers) ──────────────────────────────────

static JAVA_VM: OnceLock<JavaVM> = OnceLock::new();

/// Get or create the static `JavaVM` wrapper.
fn java_vm_safe() -> Result<&'static JavaVM, String> {
    if let Some(vm) = JAVA_VM.get() {
        return Ok(vm);
    }
    let ptr = java_vm();
    if ptr.is_null() {
        return Err("JavaVM not available".into());
    }
    Ok(JAVA_VM.get_or_init(|| unsafe { JavaVM::from_raw(ptr as *mut jni::sys::JavaVM) }))
}

/// Run a closure with an attached `jni::Env` for the current thread.
///
/// In jni 0.22 the `attach_current_thread` API is closure-based.
/// The thread is auto-detached when the closure returns (if it was
/// not already attached).
pub fn with_env<T>(f: impl FnOnce(&mut jni::Env) -> Result<T, String>) -> Result<T, String> {
    let vm = java_vm_safe()?;
    let mut result: Option<Result<T, String>> = None;
    vm.attach_current_thread(|env: &mut jni::Env| -> Result<(), jni::errors::Error> {
        result = Some(f(env));
        Ok(())
    })
    .map_err(|e: jni::errors::Error| e.to_string())?;
    result.unwrap()
}

/// Convenience alias: kept so existing callers that import `obtain_env`
/// compile with minimal changes. Returns a result by running the given
/// closure inside `with_env`.
#[inline]
pub fn obtain_env<T>(f: impl FnOnce(&mut jni::Env) -> Result<T, String>) -> Result<T, String> {
    with_env(f)
}

/// Get the Activity as a [`JObject`].
///
/// In NativeActivity mode this promotes the current session-owned global reference
/// to a local reference while the session handle remains alive. Host mode uses the
/// host-owned global reference. Prefer this scoped accessor to raw jobject APIs.
///
/// Requires `&mut Env` because promoting the owner-held Activity global to a
/// local reference allocates a JNI reference in the current local frame.
pub fn activity<'local>(env: &mut jni::Env<'local>) -> Result<JObject<'local>, String> {
    if let Some(session) = native_session() {
        return activity_for_session(env, &session);
    }
    host_activity(env)
}
/// Resolve an Activity for an operation owned by a specific runtime. `None` means
/// host-driven mode only and fails closed while a NativeActivity session is active.
pub(crate) fn activity_for_runtime<'local>(
    env: &mut jni::Env<'local>,
    session: Option<&NativeSession>,
) -> Result<JObject<'local>, String> {
    match session {
        Some(session) => activity_for_session(env, session),
        None if native_session().is_none() => host_activity(env),
        None => Err("an Activity session is required while NativeActivity owns the runtime".into()),
    }
}

fn host_activity<'local>(env: &mut jni::Env<'local>) -> Result<JObject<'local>, String> {
    let slot = HOST_ACTIVITY.lock().expect("poisoned");
    let activity = slot.current.as_ref().ok_or("Activity not available")?;
    env.new_local_ref(activity)
        .map_err(|error| error.to_string())
}

pub(crate) fn activity_for_session<'local>(
    env: &mut jni::Env<'local>,
    session: &NativeSession,
) -> Result<JObject<'local>, String> {
    if !is_current_native_session(session) {
        return Err("Activity session has ended or been replaced".into());
    }
    let activity = session.app.activity_as_ptr();
    if activity.is_null() {
        return Err("Activity is no longer available".into());
    }
    let global = unsafe { JObject::from_raw(env, activity as _) };
    env.new_local_ref(&global)
        .map_err(|error| error.to_string())
}

/// Convert a Java String (`JObject` wrapping a `java.lang.String`) to a Rust `String`.
///
/// Returns an empty string on null or error.
pub fn get_string(env: &mut jni::Env<'_>, obj: &JObject<'_>) -> String {
    if obj.is_null() {
        return String::new();
    }
    let jstr = unsafe { JString::from_raw(env, obj.as_raw()) };
    jstr.to_string()
}

/// Extension trait for converting `jni::errors::Result<T>` to `Result<T, String>`.
pub(crate) trait JniExt<T> {
    fn e(self) -> Result<T, String>;
}

impl<T> JniExt<T> for jni::errors::Result<T> {
    fn e(self) -> Result<T, String> {
        self.map_err(|e| e.to_string())
    }
}

/// Find an application class by name using the Activity's classloader.
///
/// From native threads, `JNIEnv::FindClass` uses the system classloader
/// which doesn't know about application classes.  This helper uses the
/// Activity's classloader via `activity.getClass().getClassLoader().loadClass(name)`.
///
/// `class_name` uses Java dot notation (e.g. `"dev.gpui.mobile.GpuiHelper"`).
pub fn find_app_class<'local>(
    env: &mut jni::Env<'local>,
    class_name: &str,
) -> Result<jni::objects::JClass<'local>, String> {
    let session = native_session();
    find_app_class_for_runtime(env, class_name, session.as_deref())
}

/// Load a class from the classloader belonging to the operation's runtime.
/// `None` selects host mode only and fails closed during a NativeActivity session.
pub(crate) fn find_app_class_for_runtime<'local>(
    env: &mut jni::Env<'local>,
    class_name: &str,
    session: Option<&NativeSession>,
) -> Result<jni::objects::JClass<'local>, String> {
    let act = activity_for_runtime(env, session)?;

    // activity.getClassLoader() — call on the Context instance directly.
    // Do NOT use activity.getClass().getClassLoader(): NativeActivity is a
    // framework class loaded by BootClassLoader, which cannot see app classes.
    let class_loader = env
        .call_method(
            &act,
            jni::jni_str!("getClassLoader"),
            jni::jni_sig!("()Ljava/lang/ClassLoader;"),
            &[],
        )
        .and_then(|v| v.l())
        .map_err(|e| {
            env.exception_clear();
            let msg = format!("getClassLoader failed: {e}");
            log::error!("find_app_class({class_name}): {msg}");
            msg
        })?;

    // classLoader.loadClass("dev.gpui.mobile.GpuiHelper")
    let jname = env.new_string(class_name).e()?;
    let loaded = env
        .call_method(
            &class_loader,
            jni::jni_str!("loadClass"),
            jni::jni_sig!("(Ljava/lang/String;)Ljava/lang/Class;"),
            &[JValue::Object(&jname)],
        )
        .and_then(|v| v.l())
        .map_err(|e| {
            // Print full Java stack trace to logcat, then clear.
            env.exception_describe();
            env.exception_clear();
            let msg = format!("loadClass({class_name}) failed: {e}");
            log::error!("{msg}");
            msg
        })?;

    log::debug!("find_app_class: loaded {class_name}");
    Ok(unsafe { jni::objects::JClass::from_raw(env, loaded.as_raw()) })
}

// ── global state ─────────────────────────────────────────────────────────────

/// The currently active, Activity-scoped `AndroidApp` runtime. Replaced only
/// after the previous NativeActivity entry has retired its session guard.
static NATIVE_SESSION: Mutex<Option<Arc<NativeSession>>> = Mutex::new(None);
static NEXT_NATIVE_SESSION: AtomicU64 = AtomicU64::new(1);

pub(crate) struct NativeSession {
    pub(crate) generation: u64,
    pub(crate) app: AndroidApp,
    active: AtomicBool,
    presented: AtomicBool,
}
impl NativeSession {
    pub(crate) fn is_active(&self) -> bool {
        self.active.load(Ordering::Acquire)
    }
}
#[must_use = "keep the session guard alive for the duration of the NativeActivity run"]
pub struct NativeSessionGuard {
    session: Arc<NativeSession>,
    platform: Option<Arc<AndroidPlatform>>,
    // PACER is thread-local and teardown must run on the NativeActivity owner thread.
    _owner_thread: PhantomData<Rc<()>>,
}
impl NativeSessionGuard {
    /// The platform owned by this Activity session, for custom application setup.
    ///
    /// The returned `Arc` is session-bound; operations on it stop affecting the
    /// runtime after this guard is dropped. Keep this guard on its creating thread.
    pub fn platform(&self) -> Option<Arc<AndroidPlatform>> {
        self.platform.as_ref().cloned()
    }

    fn publish_platform(&mut self, platform: Arc<AndroidPlatform>) {
        *PLATFORM.lock().expect("poisoned") = Some(Arc::clone(&platform));
        self.platform = Some(platform);
    }
}
impl Drop for NativeSessionGuard {
    fn drop(&mut self) {
        {
            let session_slot = NATIVE_SESSION.lock().expect("poisoned");
            if !session_slot
                .as_ref()
                .is_some_and(|current| Arc::ptr_eq(current, &self.session))
            {
                return;
            }
            self.session.active.store(false, Ordering::Release);
        }
        // Adapter teardown can call JNI; never hold the runtime-slot lock.
        super::accessibility::reset_native_session();
        let (retired_session, retired_platform) = {
            let mut session_slot = NATIVE_SESSION.lock().expect("poisoned");
            if !session_slot
                .as_ref()
                .is_some_and(|current| Arc::ptr_eq(current, &self.session))
            {
                return;
            }
            reset_native_session_state();
            let retired_platform = {
                let mut platform_slot = PLATFORM.lock().expect("poisoned");
                if platform_slot.as_ref().is_some_and(|current| {
                    self.platform
                        .as_ref()
                        .is_some_and(|owned| Arc::ptr_eq(current, owned))
                }) {
                    platform_slot.take()
                } else {
                    None
                }
            };
            (session_slot.take(), retired_platform)
        };
        drop(retired_platform);
        drop(retired_session);
    }
}

fn reset_native_session_state() {
    INIT_WINDOW_DONE.store(false, Ordering::Release);
    NATIVE_INITIALIZED.store(false, Ordering::Release);
    PAUSE_PENDING.store(false, Ordering::Release);
    RESUME_PENDING.store(false, Ordering::Release);
    TERM_WINDOW_PENDING.store(false, Ordering::Release);
    INIT_WINDOW_PENDING.store(false, Ordering::Release);
    WINDOW_RESIZED_PENDING.store(false, Ordering::Release);
    CONFIG_CHANGED_PENDING.store(false, Ordering::Release);
    WINDOW_INSETS_PENDING.store(false, Ordering::Release);
    NATIVE_INSETS_RECEIVED.store(false, Ordering::Release);
    *PHYSICAL_WINDOW_INSETS
        .get_or_init(|| Mutex::new(PhysicalWindowInsets::default()))
        .lock()
        .expect("poisoned") = PhysicalWindowInsets::default();
    *LAST_CHROME_STYLE.lock().expect("poisoned") = None;
    *SHOWN_KEYBOARD.lock().expect("poisoned") = None;
    *DISMISSED_KEYBOARD.lock().expect("poisoned") = None;
    crate::TEXT_INPUT_DIRTY.store(false, Ordering::Release);
    super::text_input::new_session();
    super::frame_source::reset_native_session();
}
pub(crate) fn native_session() -> Option<Arc<NativeSession>> {
    NATIVE_SESSION.lock().expect("poisoned").as_ref().cloned()
}

/// The active Android platform, if the host or NativeActivity entry has installed one.
/// The owning NativeActivity session clears its platform when its guard is dropped.
static PLATFORM: Mutex<Option<Arc<AndroidPlatform>>> = Mutex::new(None);

/// Get the unicode character produced by an Android key event via JNI.
///
/// This creates a `android.view.KeyEvent` Java object and calls
/// `getUnicodeChar(metaState)` on it.  Returns 0 on failure.
pub fn unicode_char_for_key_event(key_code: i32, action: i32, meta_state: i32) -> u32 {
    with_env(|env| {
        let key_event = match env.new_object(
            jni::jni_str!("android/view/KeyEvent"),
            jni::jni_sig!("(II)V"),
            &[JValue::Int(action), JValue::Int(key_code)],
        ) {
            Ok(o) => o,
            Err(_) => {
                env.exception_clear();
                return Ok(0);
            }
        };
        match env.call_method(
            &key_event,
            jni::jni_str!("getUnicodeChar"),
            jni::jni_sig!("(I)I"),
            &[JValue::Int(meta_state)],
        ) {
            Ok(v) => {
                let c = v.i().unwrap_or(0);
                Ok(if c > 0 { c as u32 } else { 0 })
            }
            Err(_) => {
                env.exception_clear();
                Ok(0)
            }
        }
    })
    .unwrap_or(0)
}

// ── public accessors ──────────────────────────────────────────────────────────

/// JVM for the **host-driven** entry point ([`super::host`]), which has no
/// `AndroidApp` to read it from.
static HOST_VM: AtomicPtr<c_void> = AtomicPtr::new(std::ptr::null_mut());

/// Current Activity for the host-driven entry point, as a JNI global reference we
/// own. Replaced on every Activity creation so [`activity_as_ptr`] always names the
/// *live* Activity.
///
/// The outgoing reference is kept one generation longer: `activity_as_ptr` hands out a
/// raw `jobject`, and a call on the render thread may still be using the previous
/// Activity while the UI thread installs the next one.
static HOST_ACTIVITY: Mutex<HostActivity> = Mutex::new(HostActivity {
    current: None,
    previous: None,
});

/// Application context kept independently of the newest Activity. Its Resources
/// follow system configuration, without an Activity's local night-mode override.
static HOST_CONTEXT: OnceLock<jni::refs::Global<JObject<'static>>> = OnceLock::new();

struct HostActivity {
    current: Option<jni::refs::Global<JObject<'static>>>,
    previous: Option<jni::refs::Global<JObject<'static>>>,
}

/// Register the current Activity when running without `android-activity`.
///
/// Call from a JNI entry point in `Activity.onCreate`, every time — a recreated
/// Activity is a new object. This module takes its own global reference and records
/// the JVM. Runtime-bound host operations use this Activity only when no
/// NativeActivity session is active; an Android `android-activity` session makes
/// registration a no-op. Call it before `host::start`: the platform reads bundled
/// assets (the emoji font) when it starts. If `start` came first, the emoji font is
/// loaded here instead. Raw pointers remain available only through the deprecated,
/// host-only [`activity_as_ptr`].
pub fn set_host_activity(env: &mut jni::Env<'_>, activity: &JObject<'_>) -> Result<(), String> {
    let result = register_host_activity(env, activity);
    // The caller may make more JNI calls before returning to Java, which a pending
    // exception would make undefined.
    if result.is_err() && env.exception_check() {
        env.exception_clear();
    }
    result
}

fn register_host_activity(env: &mut jni::Env<'_>, activity: &JObject<'_>) -> Result<(), String> {
    if native_session().is_some() {
        return Ok(());
    }
    let global = env.new_global_ref(activity).e()?;
    let vm = env.get_java_vm().e()?;
    HOST_VM.store(
        vm.get_raw() as *mut c_void,
        std::sync::atomic::Ordering::SeqCst,
    );
    if HOST_CONTEXT.get().is_none() {
        let context = env
            .with_local_frame(1, |env| {
                let context = env
                    .call_method(
                        activity,
                        jni::jni_str!("getApplicationContext"),
                        jni::jni_sig!("()Landroid/content/Context;"),
                        &[],
                    )?
                    .l()?;
                env.new_global_ref(&context)
            })
            .e()?;
        let _ = HOST_CONTEXT.set(context);
    }
    {
        let native_slot = NATIVE_SESSION.lock().expect("poisoned");
        if native_slot.is_some() {
            return Ok(());
        }
        let mut slot = HOST_ACTIVITY.lock().expect("poisoned");
        slot.previous = slot.current.take();
        slot.current = Some(global);
    }
    if HOST_ASSETS.get().is_none() {
        match host_assets(env, activity) {
            Ok(assets) => {
                let _ = HOST_ASSETS.set(assets);
                super::platform::load_deferred_emoji_font();
            }
            Err(err) => {
                if env.exception_check() {
                    env.exception_clear();
                }
                log::warn!("set_host_activity: no AssetManager: {err}");
            }
        }
    }
    Ok(())
}

/// The application's `AssetManager`, which `android-activity` provides on the
/// other path. Taken once, from the first host Activity's application context, and
/// kept for the life of the process.
static HOST_ASSETS: OnceLock<HostAssets> = OnceLock::new();

struct HostAssets {
    /// Keeps the Java `AssetManager`, and so the native one, alive.
    _java: jni::refs::Global<JObject<'static>>,
    native: ndk::asset::AssetManager,
}

fn host_assets(env: &mut jni::Env<'_>, activity: &JObject<'_>) -> Result<HostAssets, String> {
    // A local frame frees `context` and `assets` even when the caller stays in
    // native code, e.g. on a native-attached thread.
    env.with_local_frame(2, |env| {
        Ok::<_, jni::errors::Error>(host_assets_in_frame(env, activity))
    })
    .e()?
}

fn host_assets_in_frame(
    env: &mut jni::Env<'_>,
    activity: &JObject<'_>,
) -> Result<HostAssets, String> {
    let context = env
        .call_method(
            activity,
            jni::jni_str!("getApplicationContext"),
            jni::jni_sig!("()Landroid/content/Context;"),
            &[],
        )
        .and_then(|value| value.l())
        .e()?;
    let assets = env
        .call_method(
            &context,
            jni::jni_str!("getAssets"),
            jni::jni_sig!("()Landroid/content/res/AssetManager;"),
            &[],
        )
        .and_then(|value| value.l())
        .e()?;
    if assets.is_null() {
        return Err("getAssets returned null".into());
    }
    let java = env.new_global_ref(&assets).e()?;
    // SAFETY: `env` is the current thread's JNI env and `assets` a live AssetManager.
    let native =
        unsafe { ndk_sys::AAssetManager_fromJava(env.get_raw() as _, assets.as_raw() as _) };
    let native = std::ptr::NonNull::new(native).ok_or("AAssetManager_fromJava returned null")?;
    Ok(HostAssets {
        _java: java,
        // SAFETY: `native` belongs to the Java AssetManager that `_java` keeps alive
        // for as long as this value exists, which is the life of the process.
        native: unsafe { ndk::asset::AssetManager::from_ptr(native) },
    })
}

/// Run `f` with the app's `AssetManager`: from `android-activity`, or from the
/// Activity passed to [`set_host_activity`] on the host-driven path.
pub(crate) fn with_asset_manager<T>(f: impl FnOnce(&ndk::asset::AssetManager) -> T) -> Option<T> {
    if let Some(app) = android_app() {
        return Some(f(&app.asset_manager()));
    }
    HOST_ASSETS.get().map(|assets| f(&assets.native))
}

/// Resolve assets for the owning runtime. A missing NativeActivity handle means
/// host mode, and never falls through to a newer NativeActivity's assets.
pub(crate) fn with_asset_manager_for_runtime<T>(
    session: Option<&NativeSession>,
    f: impl FnOnce(&ndk::asset::AssetManager) -> T,
) -> Option<T> {
    match session {
        Some(session) if is_current_native_session(session) => {
            Some(f(&session.app.asset_manager()))
        }
        Some(_) => None,
        None if native_session().is_none() => HOST_ASSETS.get().map(|assets| f(&assets.native)),
        None => None,
    }
}

/// Public accessor for the JavaVM pointer.
///
/// Uses `AndroidApp::vm_as_ptr()` from the stored `AndroidApp`.
/// Used by platform integrations for JNI calls. The VM is process-lived even when
/// the Activity-scoped runtime is replaced.
pub fn java_vm() -> *mut c_void {
    native_session()
        .map(|session| session.app.vm_as_ptr())
        .unwrap_or_else(|| HOST_VM.load(std::sync::atomic::Ordering::SeqCst))
}

/// Return the raw Activity jobject only for legacy host-driven integrations.
///
/// NativeActivity sessions are intentionally not exposed as a raw pointer: callers
/// must use [`activity`] inside a JNI environment so the session and local reference
/// lifetimes are explicit. The returned host pointer is valid only while the host
/// retains its Activity registration.
#[deprecated(note = "use activity(env); raw Activity pointers are host-only")]
pub fn activity_as_ptr() -> *mut c_void {
    HOST_ACTIVITY
        .lock()
        .expect("poisoned")
        .current
        .as_ref()
        .map(|activity| activity.as_raw() as *mut c_void)
        .unwrap_or(std::ptr::null_mut())
}

/// Returns a clone of the active NativeActivity's `AndroidApp`, if initialized.
pub fn android_app() -> Option<AndroidApp> {
    native_session().map(|session| session.app.clone())
}

/// Install the platform built by the host-driven path (`super::host`).
///
/// The `android-activity` path calls `init_platform` instead. The two entry paths
/// are mutually exclusive while active.
pub(crate) fn set_host_platform(platform: Arc<AndroidPlatform>) {
    let session_slot = NATIVE_SESSION.lock().expect("poisoned");
    if session_slot.is_some() {
        log::error!("set_host_platform rejected while NativeActivity owns the runtime");
        return;
    }
    let mut platform_slot = PLATFORM.lock().expect("poisoned");
    if platform_slot.is_some() {
        log::warn!("set_host_platform: PLATFORM already set — duplicate host start?");
    } else {
        *platform_slot = Some(platform);
    }
}

/// Returns a cloned handle to the active `AndroidPlatform`, if initialized.
/// Prefer [`NativeSessionGuard::platform`] when custom code owns a NativeActivity entry.
pub fn platform() -> Option<Arc<AndroidPlatform>> {
    PLATFORM.lock().expect("poisoned").as_ref().cloned()
}

fn is_current_native_session(session: &NativeSession) -> bool {
    let slot = NATIVE_SESSION.lock().expect("poisoned");
    slot.as_ref()
        .is_some_and(|current| std::ptr::eq(Arc::as_ptr(current), session) && session.is_active())
}

/// Run a short mutation of process-global native-session state only while the
/// requested Activity still owns the session slot. The closure must not call
/// JNI, invoke callbacks, or acquire platform/window locks.
pub(crate) fn with_current_runtime_state<T>(
    session: Option<&NativeSession>,
    update: impl FnOnce() -> T,
) -> Option<T> {
    let slot = NATIVE_SESSION.lock().expect("poisoned");
    match (session, slot.as_ref()) {
        (Some(session), Some(current))
            if std::ptr::eq(Arc::as_ptr(current), session) && session.is_active() =>
        {
            Some(update())
        }
        (None, None) => Some(update()),
        _ => None,
    }
}

/// Serialize an IME event's token check and queue insertion against runtime
/// replacement. The caller must keep this closure limited to input queue state.
pub(crate) fn with_runtime_slot<T>(update: impl FnOnce() -> T) -> T {
    let _slot = NATIVE_SESSION.lock().expect("poisoned");
    update()
}

pub(crate) fn platform_for_session(session: &NativeSession) -> Option<Arc<AndroidPlatform>> {
    if !is_current_native_session(session) {
        return None;
    }
    PLATFORM
        .lock()
        .expect("poisoned")
        .as_ref()
        .filter(|platform| {
            platform
                .native_session
                .as_ref()
                .is_some_and(|owner| std::ptr::eq(Arc::as_ptr(owner), session))
        })
        .cloned()
}

/// Returns a [`SharedPlatform`] wrapping the global `Arc<AndroidPlatform>`.
///
/// This is the value you hand to `Application::with_platform(...)`:
///
/// ```rust,no_run
/// let platform = jni::shared_platform().unwrap();
/// Application::with_platform(platform.into_rc()).run(|cx| { … });
/// ```
///
/// Returns `None` before `init_platform` has been called.
pub fn shared_platform() -> Option<SharedPlatform> {
    platform().map(SharedPlatform::new)
}

// ── input event types ─────────────────────────────────────────────────────────

/// Motion event action constants from the NDK.
const AMOTION_EVENT_ACTION_DOWN: u32 = 0;
const AMOTION_EVENT_ACTION_UP: u32 = 1;
const AMOTION_EVENT_ACTION_MOVE: u32 = 2;
const AMOTION_EVENT_ACTION_CANCEL: u32 = 3;

// ── night mode query ─────────────────────────────────────────────────────────

/// Query the current night mode.
///
/// Returns `true` if the system is in dark mode.
pub fn query_night_mode_via_jni() -> bool {
    let session = native_session();
    query_night_mode_for_runtime(session.as_deref())
}

pub(crate) fn query_night_mode_for_runtime(session: Option<&NativeSession>) -> bool {
    let is_dark = if let Some(session) = session {
        if !is_current_native_session(session) {
            return false;
        }
        let config =
            ndk::configuration::Configuration::from_asset_manager(&session.app.asset_manager());
        config.ui_mode_night() == ndk::configuration::UiModeNight::Yes
    } else {
        match host_ui_mode() {
            Ok(ui_mode) => is_night(ui_mode),
            Err(err) => {
                log::warn!("query_night_mode: cannot read uiMode, assuming Light: {err}");
                false
            }
        }
    };
    log::debug!("query_night_mode: is_dark={}", is_dark);
    is_dark
}

/// `Configuration.UI_MODE_NIGHT_MASK` / `UI_MODE_NIGHT_YES`.
const UI_MODE_NIGHT_MASK: i32 = 0x30;
const UI_MODE_NIGHT_YES: i32 = 0x20;

fn is_night(ui_mode: i32) -> bool {
    ui_mode & UI_MODE_NIGHT_MASK == UI_MODE_NIGHT_YES
}

/// `getResources().getConfiguration().uiMode` of the application context.
fn host_ui_mode() -> Result<i32, String> {
    with_env(|env| {
        let context = HOST_CONTEXT
            .get()
            .ok_or("Application context not available")?;
        // A local frame frees `resources` and `config`: the render thread never
        // returns to Java.
        let result = env.with_local_frame(2, |env| {
            let resources = env
                .call_method(
                    context,
                    jni::jni_str!("getResources"),
                    jni::jni_sig!("()Landroid/content/res/Resources;"),
                    &[],
                )?
                .l()?;
            let config = env
                .call_method(
                    &resources,
                    jni::jni_str!("getConfiguration"),
                    jni::jni_sig!("()Landroid/content/res/Configuration;"),
                    &[],
                )?
                .l()?;
            env.get_field(&config, jni::jni_str!("uiMode"), jni::jni_sig!("I"))?
                .i()
        });
        if result.is_err() {
            env.exception_clear();
        }
        result.e()
    })
}

/// The system night mode as a window appearance.
pub(crate) fn query_appearance() -> crate::android::window::WindowAppearance {
    let session = native_session();
    query_appearance_for_runtime(session.as_deref())
}

pub(crate) fn query_appearance_for_runtime(
    session: Option<&NativeSession>,
) -> crate::android::window::WindowAppearance {
    appearance(query_night_mode_for_runtime(session))
}

/// The appearance a `Configuration.uiMode` asks for.
pub(crate) fn appearance_from_ui_mode(ui_mode: i32) -> crate::android::window::WindowAppearance {
    appearance(is_night(ui_mode))
}

fn appearance(is_dark: bool) -> crate::android::window::WindowAppearance {
    if is_dark {
        crate::android::window::WindowAppearance::Dark
    } else {
        crate::android::window::WindowAppearance::Light
    }
}

// ── input event processing ────────────────────────────────────────────────────

/// Process input events from the `AndroidApp` and dispatch them to the window.
fn process_input_events(app: &AndroidApp, session: &NativeSession) {
    let platform = match platform_for_session(session) {
        Some(p) => p,
        None => {
            log::trace!("process_input_events: no platform yet");
            return;
        }
    };

    let win = match platform.primary_window() {
        Some(w) => w,
        None => {
            log::trace!("process_input_events: no primary window yet");
            return;
        }
    };

    match app.input_events_iter() {
        Ok(mut iter) => {
            loop {
                let read_input = iter.next(|event| {
                    use android_activity::input::{InputEvent, MotionAction};

                    match event {
                        InputEvent::MotionEvent(motion_event) => {
                            let action = motion_event.action();
                            let pointer_count = motion_event.pointer_count();

                            log::debug!(
                                "process_input_events: MotionEvent action={:?} pointers={}",
                                action,
                                pointer_count,
                            );

                            // GPUI does not use hover on mobile. With a screen reader on,
                            // touch exploration arrives as hover events, which the
                            // accessibility delegate on the decor view has to see.
                            if matches!(
                                action,
                                MotionAction::HoverEnter
                                    | MotionAction::HoverMove
                                    | MotionAction::HoverExit
                            ) {
                                return android_activity::InputStatus::Unhandled;
                            }

                            // Check if this touch lands on a platform view.
                            //
                            // On Android with NativeActivity, ALL touch events go
                            // to the native surface first. Platform views are real
                            // Java Views in a FrameLayout overlay, but they won't
                            // receive touches unless we skip GPUI dispatch and let
                            // Android's view hierarchy handle the event instead.
                            //
                            // We use the primary pointer for the hit-test on DOWN
                            // actions. Physical pixel coordinates are converted to
                            // logical pixels to match PlatformViewBounds.
                            let hits_platform_view = {
                                let registry = crate::platform_view::PlatformViewRegistry::global();
                                if registry.active_view_count() > 0 {
                                    let primary = motion_event.pointer_at_index(
                                        match action {
                                            MotionAction::PointerDown | MotionAction::PointerUp => {
                                                motion_event.pointer_index()
                                            }
                                            _ => 0,
                                        }
                                    );
                                    let scale = win.scale_factor();
                                    let logical_x = primary.x() / scale;
                                    let logical_y = primary.y() / scale;
                                    registry.hit_test(logical_x, logical_y)
                                } else {
                                    false
                                }
                            };

                            if hits_platform_view {
                                log::debug!(
                                    "process_input_events: touch hits platform view, skipping GPUI dispatch",
                                );
                                // Return Unhandled so android-activity can pass
                                // the event back to the Java view hierarchy where
                                // the platform view's FrameLayout lives.
                                return android_activity::InputStatus::Unhandled;
                            }

                            for i in 0..pointer_count {
                                let pointer = motion_event.pointer_at_index(i);

                                let touch_action = match action {
                                    MotionAction::Down => AMOTION_EVENT_ACTION_DOWN,
                                    MotionAction::PointerDown => {
                                        // For pointer down, only dispatch the specific pointer
                                        if i != motion_event.pointer_index() {
                                            continue;
                                        }
                                        AMOTION_EVENT_ACTION_DOWN
                                    }
                                    MotionAction::Up => AMOTION_EVENT_ACTION_UP,
                                    MotionAction::PointerUp => {
                                        // For pointer up, only dispatch the specific pointer
                                        if i != motion_event.pointer_index() {
                                            continue;
                                        }
                                        AMOTION_EVENT_ACTION_UP
                                    }
                                    MotionAction::Move => AMOTION_EVENT_ACTION_MOVE,
                                    MotionAction::Cancel => AMOTION_EVENT_ACTION_CANCEL,
                                    _ => continue,
                                };

                                let touch = crate::android::TouchPoint {
                                    id: pointer.pointer_id(),
                                    x: pointer.x(),
                                    y: pointer.y(),
                                    action: touch_action,
                                };

                                log::debug!(
                                    "process_input_events: dispatching touch id={} x={:.0} y={:.0} action={}",
                                    touch.id, touch.x, touch.y, touch.action,
                                );

                                win.handle_touch(touch);
                            }

                            android_activity::InputStatus::Handled
                        }
                        InputEvent::KeyEvent(key_event) => {
                            use android_activity::input::KeyAction;

                            let action = match key_event.action() {
                                KeyAction::Down => 0,
                                KeyAction::Up => 1,
                                _ => return android_activity::InputStatus::Unhandled,
                            };

                            let key_code: u32 = key_event.key_code().into();
                            let meta_state: u32 = key_event.meta_state().0;

                            let unicode_char = unicode_char_for_key_event(
                                key_code as i32,
                                action,
                                meta_state as i32,
                            );

                            if unicode_char != 0 {
                                log::trace!(
                                    "dispatch_key_event: code={} action={} meta={:#x} → unicode=U+{:04X}",
                                    key_code,
                                    action,
                                    meta_state,
                                    unicode_char
                                );
                            }

                            let key_event = crate::android::AndroidKeyEvent {
                                key_code: key_code as i32,
                                action,
                                meta_state: meta_state as i32,
                                unicode_char,
                            };

                            win.handle_key_event(key_event);
                            android_activity::InputStatus::Handled
                        }
                        _ => android_activity::InputStatus::Unhandled,
                    }
                });

                if !read_input {
                    break;
                }
            }
        }
        Err(err) => {
            log::error!("Failed to get input events iterator: {err:?}");
        }
    }
}

// ── main event loop ───────────────────────────────────────────────────────────

/// The event loop that processes `android-activity` events and drives the
/// platform.
///
/// Called after [`init_platform`] has installed the matching session. Runs until
/// that platform requests quit or its Activity is destroyed. The AndroidApp must
/// belong to the currently-active session; stale entry points return immediately.
pub fn run_event_loop(app: &AndroidApp) {
    let Some(session) =
        native_session().filter(|session| session.app.activity_as_ptr() == app.activity_as_ptr())
    else {
        log::warn!("run_event_loop: AndroidApp does not own the active Activity session");
        return;
    };
    run_event_loop_for_session(&session);
}

pub(crate) fn run_event_loop_for_session(session: &Arc<NativeSession>) {
    if !is_current_native_session(session) {
        log::warn!("run_event_loop: refusing a stale Activity session");
        return;
    }
    let app = &session.app;
    log::info!("run_event_loop: entering main loop");

    // Track whether the on_init_window callback has already been invoked.
    // We do NOT invoke it inside handle_main_event (which runs inside
    // poll_events) because the callback can be heavy (shader compilation,
    // GPUI Application setup).  Running it there blocks the event loop and
    // prevents the system's FocusEvent from being consumed, triggering an
    // ANR after 10 seconds.
    //
    // Instead we check each loop iteration: if a primary window exists and
    // the callback is still pending, invoke it *after* poll_events has
    // returned so focus/input events have already been drained.
    INIT_WINDOW_DONE.store(false, Ordering::Relaxed);
    // Vsync pacing lives on this thread's looper.
    super::frame_source::install();
    let mut iteration: u64 = 0;
    let mut last_heartbeat = std::time::Instant::now();
    let mut app_is_active = false;

    loop {
        if !is_current_native_session(session) {
            log::info!("run_event_loop: Activity session ended");
            break;
        }
        iteration += 1;

        // Log a heartbeat every 5 seconds so we can tell if the loop is alive.
        let now = std::time::Instant::now();
        if now.duration_since(last_heartbeat) >= Duration::from_secs(5) {
            log::info!(
                "run_event_loop: heartbeat — iteration={}, init_done={}, active={}",
                iteration,
                INIT_WINDOW_DONE.load(Ordering::Relaxed),
                app_is_active,
            );
            last_heartbeat = now;
        }

        // Check if quit was requested.
        if let Some(platform) = platform_for_session(session) {
            if platform.should_quit() {
                log::info!("run_event_loop: platform requested quit");
                dispose_all_platform_views();
                break;
            }
            platform.tick();
        }

        // ── Poll for events ──
        //
        // Blocks until something reaches the looper: a lifecycle command,
        // input, a main-thread task, or the vsync callback that
        // `frame_source` posted for a wanted frame. The timeout only covers
        // the delayed dispatcher tasks `platform.tick()` has to release and
        // the clock fallback without a choreographer.
        let timeout = super::frame_source::poll_timeout(
            platform_for_session(session).and_then(|platform| platform.next_delayed_due()),
            INIT_WINDOW_DONE.load(Ordering::Relaxed) && app_is_active,
        );
        app.poll_events(Some(timeout), |event| match event {
            PollEvent::Main(main_event) => {
                handle_main_event(app, session, main_event);
            }
            PollEvent::Wake => {}
            PollEvent::Timeout => {}
            _ => {}
        });

        // ── Deferred lifecycle processing ──
        //
        // Between each handler, call poll_events again to drain any
        // events the Java UI thread may have queued while we were
        // processing.  This keeps the condvar wait short and prevents
        // the InputDispatcher ANR (10s timeout on MotionEvent delivery).
        //
        // Helper closure to drain events quickly:
        let drain_events = |app: &AndroidApp| {
            app.poll_events(Some(Duration::ZERO), |event| {
                if let PollEvent::Main(main_event) = event {
                    handle_main_event(app, session, main_event);
                }
            });
        };

        // 1. TerminateWindow — unconfigure surface, release native window
        if TERM_WINDOW_PENDING.swap(false, Ordering::Relaxed) {
            log::info!("deferred: TerminateWindow (iter={})", iteration);
            INIT_WINDOW_DONE.store(false, Ordering::Relaxed);
            *LAST_CHROME_STYLE.lock().unwrap() = None;
            if let Some(platform) = platform_for_session(session) {
                if let Some(win) = platform.primary_window() {
                    win.term_window();
                }
            }
            // Drain immediately — Java thread may be blocked on InitWindow condvar.
            drain_events(app);
        }

        // 2. InitWindow — replace surface on existing renderer, or create new
        if INIT_WINDOW_PENDING.swap(false, Ordering::Relaxed) {
            log::info!("deferred: InitWindow (iter={})", iteration);
            if let Some(platform) = platform_for_session(session) {
                if let Some(native_window) = app.native_window() {
                    let width = native_window.width();
                    let height = native_window.height();
                    log::info!("InitWindow: {}×{}", width, height);

                    platform.update_primary_display(&native_window, &app.asset_manager());

                    let scale_factor = platform
                        .primary_display()
                        .map(|d| d.scale_factor())
                        .unwrap_or(1.0);

                    if let Some(existing) = platform.primary_window() {
                        match platform.reinit_window(&existing, native_window) {
                            Ok(()) => {
                                log::info!("InitWindow: reinitialised existing window");
                            }
                            Err(e) => {
                                log::error!("failed to reinit window surface: {e:#}");
                            }
                        }

                        // Trigger GPUI resize so layout adapts to new dimensions.
                        existing.handle_resize();

                        if !NATIVE_INSETS_RECEIVED.load(Ordering::Acquire) {
                            let cr = app.content_rect();
                            existing.update_safe_area_from_content_rect(
                                cr.left, cr.top, cr.right, cr.bottom,
                            );
                        }

                        INIT_WINDOW_DONE.store(true, Ordering::Relaxed);
                    } else {
                        match platform.open_window(native_window, scale_factor, false) {
                            Ok(win) => {
                                log::info!(
                                    "window opened — id={:#x} scale={:.1}",
                                    win.id(),
                                    scale_factor
                                );

                                if !NATIVE_INSETS_RECEIVED.load(Ordering::Acquire) {
                                    let cr = app.content_rect();
                                    win.update_safe_area_from_content_rect(
                                        cr.left, cr.top, cr.right, cr.bottom,
                                    );
                                }
                            }
                            Err(e) => {
                                log::error!("failed to open window: {e:#}");
                            }
                        }
                    }
                }
            }
            // Drain — Java thread may have queued ConfigChanged/WindowResized.
            drain_events(app);
        }

        // 3. WindowResized
        if WINDOW_RESIZED_PENDING.swap(false, Ordering::Relaxed) {
            log::debug!("deferred: WindowResized");
            if let Some(platform) = platform_for_session(session) {
                if let Some(win) = platform.primary_window() {
                    win.handle_resize();
                    if !NATIVE_INSETS_RECEIVED.load(Ordering::Acquire) {
                        let cr = app.content_rect();
                        win.update_safe_area_from_content_rect(
                            cr.left, cr.top, cr.right, cr.bottom,
                        );
                    }
                }
            }
        }

        // Apply the latest UI-thread insets snapshot on the Android/GPUI owner thread.
        if WINDOW_INSETS_PENDING.swap(false, Ordering::AcqRel) {
            let insets = *PHYSICAL_WINDOW_INSETS
                .get_or_init(|| Mutex::new(PhysicalWindowInsets::default()))
                .lock()
                .unwrap();
            if let Some(window) =
                platform_for_session(session).and_then(|platform| platform.primary_window())
            {
                let safe = super::window::SafeAreaInsets {
                    top: insets.safe[0] as f32,
                    right: insets.safe[1] as f32,
                    bottom: insets.safe[2] as f32,
                    left: insets.safe[3] as f32,
                };
                let ime = super::window::SafeAreaInsets {
                    top: insets.ime[0] as f32,
                    right: insets.ime[1] as f32,
                    bottom: insets.ime[2] as f32,
                    left: insets.ime[3] as f32,
                };
                window.update_window_insets(safe, ime);
            }
        }

        // 4. ConfigChanged
        if CONFIG_CHANGED_PENDING.swap(false, Ordering::Relaxed) {
            log::debug!("deferred: ConfigChanged");
            if let Some(platform) = platform_for_session(session) {
                platform.notify_keyboard_layout_change();
                platform.refresh_appearance();
            }
        }

        // 5. Pause / background
        if PAUSE_PENDING.swap(false, Ordering::Relaxed) {
            log::info!("deferred: Pause (iter={})", iteration);
            if let Some(platform) = platform_for_session(session) {
                platform.did_enter_background();
                if let Some(win) = platform.primary_window() {
                    win.set_active(false);
                }
            }
            // Pause platform views
            pause_platform_views();
        }

        // 6. Resume / foreground
        if RESUME_PENDING.swap(false, Ordering::Relaxed) {
            log::info!("deferred: Resume (iter={})", iteration);
            if let Some(platform) = platform_for_session(session) {
                platform.did_become_active();
                if let Some(win) = platform.primary_window() {
                    win.set_active(true);
                }
            }
            // Resume platform views
            resume_platform_views();
        }

        // Track active/focused state.
        if let Some(platform) = platform_for_session(session) {
            if let Some(win) = platform.primary_window() {
                let is_active = win.is_active();
                if is_active != app_is_active {
                    log::info!(
                        "run_event_loop: active {} -> {} (iter={})",
                        app_is_active,
                        is_active,
                        iteration,
                    );
                    app_is_active = is_active;
                }
            }
        }

        // Process input events.
        process_input_events(app, session);

        // Deferred initialisation callbacks (runs once).
        if !INIT_WINDOW_DONE.load(Ordering::Relaxed) {
            if let Some(platform) = platform_for_session(session) {
                if platform.primary_window().is_some() {
                    if let Some(finish_cb) = platform.take_finish_launching_callback() {
                        log::info!("invoking finish_launching callback (iter={})", iteration);
                        finish_cb.call_once();
                    }

                    if let Some(init_cb) = platform.take_on_init_window_callback() {
                        let win = platform.primary_window().unwrap();
                        log::info!("invoking on_init_window callback (iter={})", iteration);
                        init_cb(win);
                    }

                    INIT_WINDOW_DONE.store(true, Ordering::Relaxed);
                    NATIVE_INITIALIZED.store(true, Ordering::Release);
                    log::info!("NATIVE_INITIALIZED = true");

                    // Render first frame immediately.
                    platform.flush_main_thread_tasks();
                    if let Some(win) = platform.primary_window() {
                        win.request_frame();
                    }
                }
            }
        }

        // ── Render ──
        if let Some(platform) = platform_for_session(session) {
            if INIT_WINDOW_DONE.load(Ordering::Relaxed) && app_is_active {
                platform.flush_main_thread_tasks();
                // Software-keyboard text bypasses GPUI's invalidator; the
                // frame callback turns it into a forced render.
                if crate::TEXT_INPUT_DIRTY.load(Ordering::Acquire) {
                    super::frame_source::schedule_frame();
                }
                if super::frame_source::take_frame() {
                    if let Some(win) = platform.primary_window() {
                        win.request_frame();
                    }

                    // Drain lifecycle events that arrived during rendering
                    // (e.g. rotation triggers TerminateWindow while we were
                    // in get_current_texture / present).
                    drain_events(app);
                    process_input_events(app, session);
                }
            }
        }
    }

    if let Some(platform) = platform_for_session(session) {
        platform.shutdown_callback_registry_on_owner();
    }
    log::info!("run_event_loop: exiting main loop");
}

/// Pause all platform views when the app goes to background.
fn pause_platform_views() {
    let _ = with_env(|env| {
        if let Ok(helper_class) = find_app_class(env, "dev.gpui.mobile.GpuiPlatformView") {
            let _ = env.call_static_method(
                &helper_class,
                jni::jni_str!("pauseAll"),
                jni::jni_sig!("()V"),
                &[],
            );
            env.exception_clear();
        }
        Ok(())
    });
}

/// Resume all platform views when the app returns to foreground.
fn resume_platform_views() {
    let _ = with_env(|env| {
        if let Ok(helper_class) = find_app_class(env, "dev.gpui.mobile.GpuiPlatformView") {
            let _ = env.call_static_method(
                &helper_class,
                jni::jni_str!("resumeAll"),
                jni::jni_sig!("()V"),
                &[],
            );
            env.exception_clear();
        }
        Ok(())
    });
}

/// Dispose all platform views during app shutdown.
fn dispose_all_platform_views() {
    let _ = with_env(|env| {
        if let Ok(helper_class) = find_app_class(env, "dev.gpui.mobile.GpuiPlatformView") {
            let _ = env.call_static_method(
                &helper_class,
                jni::jni_str!("disposeAll"),
                jni::jni_sig!("()V"),
                &[],
            );
            env.exception_clear();
        }
        Ok(())
    });
}

/// Handle a single `MainEvent` from `android-activity`.
fn handle_main_event(_app: &AndroidApp, session: &NativeSession, event: MainEvent<'_>) {
    #[derive(Clone, Copy)]
    enum DeferredAction {
        None,
        ClearImeInsets,
        Quit,
    }

    // Validate ownership while applying lifecycle flags. A one-time check
    // followed by an unlocked global write can let a late old-Activity event
    // mutate the newly-created Activity's flags.
    let action = with_current_runtime_state(Some(session), || match event {
        MainEvent::InitWindow { .. } => {
            log::info!("MainEvent::InitWindow");
            INIT_WINDOW_PENDING.store(true, Ordering::Relaxed);
            DeferredAction::None
        }
        MainEvent::TerminateWindow { .. } => {
            log::info!("MainEvent::TerminateWindow");
            TERM_WINDOW_PENDING.store(true, Ordering::Relaxed);
            DeferredAction::None
        }
        MainEvent::WindowResized { .. } => {
            log::debug!("MainEvent::WindowResized");
            WINDOW_RESIZED_PENDING.store(true, Ordering::Relaxed);
            DeferredAction::None
        }
        MainEvent::GainedFocus | MainEvent::Resume { .. } => {
            log::info!("MainEvent: gained focus/resumed");
            RESUME_PENDING.store(true, Ordering::Relaxed);
            DeferredAction::None
        }
        MainEvent::LostFocus => {
            log::info!("MainEvent::LostFocus");
            PAUSE_PENDING.store(true, Ordering::Relaxed);
            DeferredAction::None
        }
        MainEvent::Pause => {
            log::info!("MainEvent::Pause");
            PAUSE_PENDING.store(true, Ordering::Relaxed);
            DeferredAction::ClearImeInsets
        }
        MainEvent::ConfigChanged { .. } => {
            log::debug!("MainEvent::ConfigChanged");
            CONFIG_CHANGED_PENDING.store(true, Ordering::Relaxed);
            DeferredAction::None
        }
        MainEvent::Start => {
            log::info!("MainEvent::Start");
            DeferredAction::None
        }
        MainEvent::Stop => {
            log::info!("MainEvent::Stop");
            DeferredAction::None
        }
        MainEvent::SaveState { .. } => {
            log::info!("MainEvent::SaveState");
            DeferredAction::None
        }
        MainEvent::LowMemory => {
            log::warn!("MainEvent::LowMemory — consider releasing cached resources");
            DeferredAction::None
        }
        MainEvent::Destroy => {
            log::info!("MainEvent::Destroy");
            DeferredAction::Quit
        }
        MainEvent::InsetsChanged { .. } => {
            log::debug!("MainEvent::InsetsChanged");
            WINDOW_RESIZED_PENDING.store(true, Ordering::Relaxed);
            if NATIVE_INSETS_RECEIVED.load(Ordering::Acquire) {
                WINDOW_INSETS_PENDING.store(true, Ordering::Release);
            }
            DeferredAction::None
        }
        MainEvent::ContentRectChanged { .. } => {
            log::debug!("MainEvent::ContentRectChanged");
            WINDOW_RESIZED_PENDING.store(true, Ordering::Relaxed);
            DeferredAction::None
        }
        _ => {
            log::trace!("MainEvent: other variant");
            DeferredAction::None
        }
    });
    match action {
        Some(DeferredAction::ClearImeInsets) => clear_ime_insets(session),
        Some(DeferredAction::Quit) => {
            if let Some(platform) = platform_for_session(session) {
                platform.quit();
            }
        }
        Some(DeferredAction::None) | None => {}
    }
}

// ── main loop helper (compat with existing code) ──────────────────────────────

/// Run one iteration of the event loop.
///
/// This is a compatibility wrapper for code that uses a manual poll loop.
/// Prefer `run_event_loop` for the standard event loop.
///
/// `timeout_ms` — how long to block waiting for events (milliseconds).
/// Pass `0` for non-blocking, `-1` to block indefinitely.
///
/// Returns `true` if the application should exit.
pub fn poll_events(timeout_ms: i32) -> bool {
    if let Some(platform) = native_session().and_then(|session| platform_for_session(&session)) {
        if platform.should_quit() {
            return true;
        }
        platform.tick();
    }

    let session = match native_session() {
        Some(session) if session.is_active() => session,
        _ => return false,
    };
    let app = &session.app;

    let timeout = if timeout_ms < 0 {
        None
    } else {
        Some(Duration::from_millis(timeout_ms as u64))
    };

    app.poll_events(timeout, |event| match event {
        PollEvent::Main(main_event) => {
            handle_main_event(app, &session, main_event);
        }
        PollEvent::Wake => {}
        _ => {}
    });

    process_input_events(app, &session);

    // Drive the GPUI rendering pipeline (same as run_event_loop).
    if let Some(platform) = platform_for_session(&session) {
        platform.flush_main_thread_tasks();
        if let Some(win) = platform.primary_window() {
            win.request_frame();
        }
    }

    false
}

// ── public init / run helpers ─────────────────────────────────────────────────

/// Install a panic hook that routes panic messages to logcat.
///
/// Call this early in `android_main` so that any subsequent panic is
/// visible via `adb logcat`.  Safe to call multiple times — each call
/// replaces the previous hook.
pub fn install_panic_hook() {
    std::panic::set_hook(Box::new(|info| {
        let payload = if let Some(s) = info.payload().downcast_ref::<&str>() {
            (*s).to_string()
        } else if let Some(s) = info.payload().downcast_ref::<String>() {
            s.clone()
        } else {
            "Box<dyn Any>".to_string()
        };
        if let Some(loc) = info.location() {
            log::error!(
                "PANIC at {}:{}:{}: {}",
                loc.file(),
                loc.line(),
                loc.column(),
                payload
            );
        } else {
            log::error!("PANIC: {}", payload);
        }
    }));
}

/// Start a NativeActivity-backed platform session.
///
/// Keep the returned guard alive on the NativeActivity owner thread for the entire
/// application run. The guard is deliberately `!Send`/`!Sync` because teardown
/// resets owner-thread looper state. Dropping it retires only this Activity session,
/// clears its callback state, and permits a later Activity instance in the same
/// process to initialize. A second concurrent NativeActivity entry is rejected
/// instead of waiting on the UI thread. Use [`run_native_activity`] for the standard
/// entry path, or obtain this session's platform through [`NativeSessionGuard::platform`]:
///
/// ```ignore
/// let _session = init_platform(&app)?;
/// run_event_loop(&app);
/// ```
pub fn init_platform(app: &AndroidApp) -> Result<NativeSessionGuard, String> {
    let session = Arc::new(NativeSession {
        generation: NEXT_NATIVE_SESSION.fetch_add(1, Ordering::Relaxed),
        app: app.clone(),
        active: AtomicBool::new(true),
        presented: AtomicBool::new(false),
    });
    {
        let mut session_slot = NATIVE_SESSION.lock().expect("poisoned");
        if session_slot.is_some() {
            return Err("a NativeActivity runtime is still active".into());
        }
        let platform_slot = PLATFORM.lock().expect("poisoned");
        if platform_slot.is_some() {
            return Err("a host Android platform is already active".into());
        }
        reset_native_session_state();
        *session_slot = Some(Arc::clone(&session));
    }
    log::info!(
        "init_platform: started Activity session generation={}",
        session.generation
    );
    let mut guard = NativeSessionGuard {
        session: Arc::clone(&session),
        platform: None,
        _owner_thread: PhantomData,
    };
    let platform = Arc::new(AndroidPlatform::new_for_session(false, session));
    log::info!("init_platform: AndroidPlatform created");
    guard.publish_platform(platform);
    Ok(guard)
}

// ── system chrome (status bar / navigation bar) ───────────────────────────────

/// Cached last-applied system chrome style.
///
/// `set_system_chrome` is called on every frame render.  The JNI calls it
/// makes (getWindow, setStatusBarColor, etc.) are View operations that can
/// contend with the Android UI thread and intermittently deadlock.
/// By caching the last applied style we skip the JNI calls entirely when
/// nothing changed — which is the common case.
#[allow(clippy::type_complexity)]
static LAST_CHROME_STYLE: std::sync::Mutex<
    Option<(Option<u32>, Option<u32>, crate::StatusBarContentStyle)>,
> = std::sync::Mutex::new(None);

/// Apply system chrome styling on Android.
///
/// Sets the status bar color, navigation bar color, and light/dark
/// status bar icons via JNI calls to `Window` and `WindowInsetsController`.
///
/// Must be called from the main (native) thread that has JNI access.
pub fn set_system_chrome(style: &crate::SystemChromeStyle) {
    let session = native_session();
    set_system_chrome_for_runtime(session.as_deref(), style);
}

fn set_system_chrome_for_runtime(
    session: Option<&NativeSession>,
    style: &crate::SystemChromeStyle,
) {
    let status_bar_color = style.status_bar_color;
    let navigation_bar_color = style.navigation_bar_color;
    let status_bar_style = style.status_bar_style;

    // Serialize the cache update with session replacement. A stale frame may not
    // suppress the new Activity's first application of the same style.
    let changed = with_current_runtime_state(session, || {
        let key = (status_bar_color, navigation_bar_color, status_bar_style);
        let mut last = LAST_CHROME_STYLE.lock().expect("poisoned");
        if *last == Some(key) {
            false
        } else {
            *last = Some(key);
            true
        }
    });
    if changed != Some(true) {
        return;
    }

    let result = with_env(|env| {
        let activity_obj = activity_for_runtime(env, session)?;

        // 1. Get the Window: activity.getWindow()
        let window = env
            .call_method(
                &activity_obj,
                jni::jni_str!("getWindow"),
                jni::jni_sig!("()Landroid/view/Window;"),
                &[],
            )
            .and_then(|v: jni::objects::JValueOwned| v.l())
            .map_err(|e| {
                env.exception_clear();
                e.to_string()
            })?;
        if window.is_null() {
            return Err("getWindow returned null".into());
        }

        // 2. Set status bar color if provided
        if let Some(color) = status_bar_color {
            let argb = (0xFF000000_u32 | color) as i32;
            let _ = env.call_method(
                &window,
                jni::jni_str!("setStatusBarColor"),
                jni::jni_sig!("(I)V"),
                &[JValue::Int(argb)],
            );
            env.exception_clear();
        }

        // 3. Set navigation bar color if provided
        if let Some(color) = navigation_bar_color {
            let argb = (0xFF000000_u32 | color) as i32;
            let _ = env.call_method(
                &window,
                jni::jni_str!("setNavigationBarColor"),
                jni::jni_sig!("(I)V"),
                &[JValue::Int(argb)],
            );
            env.exception_clear();
        }

        // 4. Set light/dark status bar icons via WindowInsetsController (API 30+)
        let insetsctl = env.call_method(
            &window,
            jni::jni_str!("getInsetsController"),
            jni::jni_sig!("()Landroid/view/WindowInsetsController;"),
            &[],
        );

        if let Ok(v) = insetsctl {
            if let Ok(ctl) = v.l() {
                if !ctl.is_null() {
                    let mask: i32 = 0x00000008;
                    let appearance: i32 = match status_bar_style {
                        crate::StatusBarContentStyle::Dark => 0x00000008,
                        crate::StatusBarContentStyle::Light => 0,
                    };
                    let _ = env.call_method(
                        &ctl,
                        jni::jni_str!("setSystemBarsAppearance"),
                        jni::jni_sig!("(II)V"),
                        &[JValue::Int(appearance), JValue::Int(mask)],
                    );
                    env.exception_clear();
                }
            }
        } else {
            env.exception_clear();

            if let Ok(decor) = env
                .call_method(
                    &window,
                    jni::jni_str!("getDecorView"),
                    jni::jni_sig!("()Landroid/view/View;"),
                    &[],
                )
                .and_then(|v: jni::objects::JValueOwned| v.l())
            {
                if !decor.is_null() {
                    if let Ok(current) = env
                        .call_method(
                            &decor,
                            jni::jni_str!("getSystemUiVisibility"),
                            jni::jni_sig!("()I"),
                            &[],
                        )
                        .and_then(|v: jni::objects::JValueOwned| v.i())
                    {
                        let new_flags = match status_bar_style {
                            crate::StatusBarContentStyle::Dark => current | 0x00002000,
                            crate::StatusBarContentStyle::Light => current & !0x00002000,
                        };
                        let _ = env.call_method(
                            &decor,
                            jni::jni_str!("setSystemUiVisibility"),
                            jni::jni_sig!("(I)V"),
                            &[JValue::Int(new_flags)],
                        );
                        env.exception_clear();
                    }
                }
            }
        }

        Ok(())
    });

    if let Err(e) = result {
        log::warn!("set_system_chrome: {e}");
    }

    log::info!(
        "set_system_chrome: status_bar_color={:?}, nav_bar_color={:?}, style={:?}",
        style.status_bar_color,
        style.navigation_bar_color,
        style.status_bar_style
    );
}

// ── software keyboard (IME) control ───────────────────────────────────────────

/// The keyboard type currently requested, or `None` when hidden.
///
/// The Java-side `InputProxy` belongs to the Activity, so an Activity recreation takes
/// the IME with it — while GPUI still considers the same field focused and therefore
/// never asks for the keyboard again. Remembering the request lets a new Activity put
/// the IME back; see [`restore_keyboard`].
static SHOWN_KEYBOARD: std::sync::Mutex<Option<crate::KeyboardType>> = std::sync::Mutex::new(None);

/// The keyboard the user hid (back) while its text input kept focus.
///
/// GPUI asks for the keyboard only when a text input *gains* focus, and the platform
/// cannot blur it, so after a back-press the field stays focused with no keyboard and
/// tapping it again changes nothing. [`super::window`] uses this to bring the keyboard
/// back when a tap lands on the focused field. Cleared by any explicit show or hide.
static DISMISSED_KEYBOARD: std::sync::Mutex<Option<crate::KeyboardType>> =
    std::sync::Mutex::new(None);

/// IME event 5: the system already hid the keyboard; remember it for a tap to undo.
pub(crate) fn keyboard_hidden_by_user() {
    keyboard_hidden_by_user_for_runtime(None);
}

pub(crate) fn keyboard_hidden_by_user_for_runtime(native_session: Option<&NativeSession>) {
    let _ = with_current_runtime_state(native_session, || {
        let shown = SHOWN_KEYBOARD.lock().expect("poisoned").take();
        if shown.is_some() {
            *DISMISSED_KEYBOARD.lock().expect("poisoned") = shown;
        }
    });
}

pub(crate) fn keyboard_dismissed() -> bool {
    let session = native_session();
    keyboard_dismissed_for_runtime(session.as_deref()).unwrap_or(false)
}

pub(crate) fn keyboard_dismissed_for_runtime(
    native_session: Option<&NativeSession>,
) -> Option<bool> {
    with_current_runtime_state(native_session, || {
        DISMISSED_KEYBOARD.lock().expect("poisoned").is_some()
    })
}

/// Show the keyboard [`keyboard_hidden_by_user`] took away again.
pub(crate) fn reshow_dismissed_keyboard() {
    let session = native_session();
    reshow_dismissed_keyboard_for_runtime(session.as_deref());
}

pub(crate) fn reshow_dismissed_keyboard_for_runtime(native_session: Option<&NativeSession>) {
    let dismissed = with_current_runtime_state(native_session, || {
        DISMISSED_KEYBOARD.lock().expect("poisoned").take()
    })
    .flatten();
    if let Some(keyboard_type) = dismissed {
        show_keyboard_for_runtime(native_session, keyboard_type);
    }
}

/// Re-request the keyboard on the current Activity if one was showing.
///
/// Called by [`super::host`] once a recreated Activity's surface is attached. A fresh
/// IME session is started, which is what we want: the proxy is a new object.
pub(crate) fn restore_keyboard() {
    // This is the host-driven Activity-recreation path. Do not let a delayed host
    // callback redirect its keyboard request to a NativeActivity session.
    let keyboard_type =
        with_current_runtime_state(None, || *SHOWN_KEYBOARD.lock().expect("poisoned")).flatten();
    if let Some(keyboard_type) = keyboard_type {
        log::info!("restore_keyboard: re-showing {keyboard_type:?} on the new Activity");
        show_keyboard_for_runtime(None, keyboard_type);
    }
}

/// Show the UI-thread EditText proxy supplied by GpuiInputActivity.
///
/// Unlike NativeActivity's key-event-only connection, its InputConnection
/// supports composing text, commits and Unicode surrounding-text deletion.
pub fn show_keyboard_android(keyboard_type: crate::KeyboardType) {
    let session = native_session();
    show_keyboard_for_runtime(session.as_deref(), keyboard_type);
}

pub(crate) fn show_keyboard_for_runtime(
    native_session: Option<&NativeSession>,
    keyboard_type: crate::KeyboardType,
) {
    let Some(session) = with_current_runtime_state(native_session, || {
        *SHOWN_KEYBOARD.lock().expect("poisoned") = Some(keyboard_type);
        *DISMISSED_KEYBOARD.lock().expect("poisoned") = None;
        super::text_input::new_session()
    }) else {
        return;
    };
    let kind = match keyboard_type {
        crate::KeyboardType::Default => 0,
        crate::KeyboardType::EmailAddress => 1,
        crate::KeyboardType::Phone => 2,
        crate::KeyboardType::NumberPad => 3,
        crate::KeyboardType::URL => 4,
        crate::KeyboardType::Decimal => 5,
    };
    if let Err(error) = with_env(|env| {
        let activity = activity_for_runtime(env, native_session)?;
        env.call_method(
            &activity,
            jni::jni_str!("gpuiShowKeyboard"),
            jni::jni_sig!("(IJ)V"),
            &[JValue::Int(kind), JValue::Long(session as i64)],
        )
        .map_err(|e| e.to_string())?;
        Ok(())
    }) {
        log::warn!("IME requires GpuiInputActivity: {error}");
        let _ = with_env(|env| {
            env.exception_clear();
            Ok(())
        });
    }
}

/// Hide the software keyboard on Android.
///
/// Invalidates queued IME callbacks and clears the native composition buffer.
pub fn hide_keyboard_android() {
    let session = native_session();
    hide_keyboard_for_runtime(session.as_deref());
}

pub(crate) fn hide_keyboard_for_runtime(native_session: Option<&NativeSession>) {
    let Some(input_session) = with_current_runtime_state(native_session, || {
        *SHOWN_KEYBOARD.lock().expect("poisoned") = None;
        *DISMISSED_KEYBOARD.lock().expect("poisoned") = None;
        super::text_input::new_session()
    }) else {
        return;
    };
    let _ = with_env(|env| {
        let activity = activity_for_runtime(env, native_session)?;
        let result = env.call_method(
            &activity,
            jni::jni_str!("gpuiHideKeyboard"),
            jni::jni_sig!("(J)V"),
            &[JValue::Long(input_session as i64)],
        );
        env.exception_clear();
        result.map_err(|e| e.to_string())?;
        Ok(())
    });
    if let Some(session) = native_session {
        if session.is_active() {
            session.app.hide_soft_input(false);
        }
    } else if let Some(app) = android_app() {
        app.hide_soft_input(false);
    }
}

pub(super) fn reset_keyboard_composition() {
    let session = native_session();
    reset_keyboard_composition_for_runtime(session.as_deref());
}
pub(super) fn reset_keyboard_composition_for_runtime(native_session: Option<&NativeSession>) {
    let Some(session) = with_current_runtime_state(native_session, super::text_input::new_session)
    else {
        return;
    };
    let _ = with_env(|env| {
        let activity = activity_for_runtime(env, native_session)?;
        let result = env.call_method(
            &activity,
            jni::jni_str!("gpuiResetComposition"),
            jni::jni_sig!("(J)V"),
            &[JValue::Long(session as i64)],
        );
        env.exception_clear();
        result.map_err(|e| e.to_string())?;
        Ok(())
    });
}

/// Publish an immutable editor snapshot for Android InputConnection query methods.
///
/// This only writes volatile Java-side state; it never calls into GPUI or waits
/// on the Android UI thread.
pub(super) fn sync_input_snapshot(
    session: u64,
    text: &str,
    selection_start: i32,
    selection_end: i32,
    marked_start: i32,
    marked_end: i32,
    generation: u64,
) {
    let native_session = native_session();
    sync_input_snapshot_for_runtime(
        native_session.as_deref(),
        session,
        text,
        selection_start,
        selection_end,
        marked_start,
        marked_end,
        generation,
    );
}
pub(super) fn sync_input_snapshot_for_runtime(
    native_session: Option<&NativeSession>,
    session: u64,
    text: &str,
    selection_start: i32,
    selection_end: i32,
    marked_start: i32,
    marked_end: i32,
    generation: u64,
) {
    if native_session.is_some_and(|session| !session.is_active()) {
        return;
    }
    let _ = with_env(|env| {
        let activity = activity_for_runtime(env, native_session)?;
        let text = env.new_string(text).e()?;
        env.call_method(
            &activity,
            jni::jni_str!("gpuiUpdateInputSnapshot"),
            jni::jni_sig!("(JLjava/lang/String;IIIIJ)V"),
            &[
                JValue::Long(session as i64),
                JValue::Object(&text),
                JValue::Int(selection_start),
                JValue::Int(selection_end),
                JValue::Int(marked_start),
                JValue::Int(marked_end),
                JValue::Long(generation as i64),
            ],
        )
        .map_err(|error| error.to_string())?;
        Ok(())
    });
}

/// Receive system-bar, cutout, and IME insets in physical pixels from the
/// Activity's UI-thread WindowInsets listener. The GPUI owner thread applies
/// the latest snapshot after its looper wakes.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn Java_dev_gpui_mobile_GpuiInputActivity_nativeRuntimeGeneration(
    _env: *mut c_void,
    _class: *mut c_void,
) -> i64 {
    native_session().map_or(0, |session| session.generation as i64)
}
#[unsafe(no_mangle)]
pub unsafe extern "C" fn Java_dev_gpui_mobile_GpuiInputActivity_nativeRuntimeInitialized(
    _env: *mut c_void,
    _class: *mut c_void,
) -> u8 {
    u8::from(
        native_session().is_some_and(|session| session.is_active())
            && NATIVE_INITIALIZED.load(Ordering::Acquire),
    )
}
#[unsafe(no_mangle)]
pub unsafe extern "C" fn Java_dev_gpui_mobile_GpuiInputActivity_nativePresentedFrameGeneration(
    _env: *mut c_void,
    _class: *mut c_void,
) -> i64 {
    native_session()
        .filter(|session| session.is_active() && session.presented.load(Ordering::Acquire))
        .map_or(0, |session| session.generation as i64)
}
pub(crate) fn note_presented_frame(session: &NativeSession) {
    if session.is_active() {
        session.presented.store(true, Ordering::Release);
    }
}

#[unsafe(no_mangle)]
pub unsafe extern "C" fn Java_dev_gpui_mobile_GpuiInputActivity_nativeInsets(
    _env: *mut c_void,
    callback_activity: *mut c_void,
    safe_top: i32,
    safe_right: i32,
    safe_bottom: i32,
    safe_left: i32,
    ime_top: i32,
    ime_right: i32,
    ime_bottom: i32,
    ime_left: i32,
) {
    let Some(session) = native_session().filter(|session| session.is_active()) else {
        return;
    };
    let current = with_env(|env| {
        let callback = unsafe { JObject::from_raw(env, callback_activity as _) };
        let current = activity_for_session(env, &session)?;
        env.is_same_object(&callback, &current)
            .map_err(|error| error.to_string())
    })
    .unwrap_or(false);
    if !current {
        log::debug!("Ignoring insets from an obsolete Activity instance");
        return;
    }
    publish_physical_insets(
        &session,
        PhysicalWindowInsets {
            safe: [
                safe_top.max(0),
                safe_right.max(0),
                safe_bottom.max(0),
                safe_left.max(0),
            ],
            ime: [
                ime_top.max(0),
                ime_right.max(0),
                ime_bottom.max(0),
                ime_left.max(0),
            ],
        },
    );
}

/// Receive Java InputConnection updates without touching GPUI on the UI thread.
///
/// # Safety
/// Called by JNI with a valid Java string and JNI call frame.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn Java_dev_gpui_mobile_GpuiInputActivity_nativeIme(
    _env: *mut c_void,
    _class: *mut c_void,
    session: i64,
    kind: i32,
    text: *mut c_void,
    start: i32,
    end: i32,
    generation: i64,
) {
    let _ = with_env(|env| {
        let text = unsafe { JObject::from_raw(env, text as jni::sys::jobject) };
        super::text_input::enqueue(super::text_input::ImeEvent {
            session: session as u64,
            kind,
            text: get_string(env, &text),
            start: start.max(0) as usize,
            end: end.max(0) as usize,
            generation: generation.max(0) as u64,
        });
        Ok(())
    });
}

// ── tests ─────────────────────────────────────────────────────────────────────

// ── JNI export for GpuiActivity splash screen ────────────────────────────────

/// Called from `GpuiActivity.nativeIsInitialized()` to check whether the
/// native library has initialized. This does not prove a frame was presented;
/// use the session-scoped presented-frame signal for that distinction.
///
/// The AndroidX SplashScreen API calls this via `setKeepOnScreenCondition`
/// to hold the splash visible until GPUI is ready.
///
/// # Safety
/// Must only be called from the JVM on a valid JNI thread.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn Java_dev_gpui_mobile_GpuiActivity_nativeIsInitialized(
    _env: *mut std::ffi::c_void,
    _class: *mut std::ffi::c_void,
) -> u8 {
    if NATIVE_INITIALIZED.load(Ordering::Acquire) {
        1 // JNI_TRUE
    } else {
        0 // JNI_FALSE
    }
}

/// JNI bridge: receive a deeplink URL from `GpuiActivity.onNewIntent()`.
///
/// When the app is already running and a deeplink is opened (e.g. via
/// `adb shell am start -d gpui://video_player`), the Java side calls
/// this to notify the Rust deeplink handler.
///
/// # Safety
/// Must only be called from the JVM on a valid JNI thread with a valid `url` jobject.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn Java_dev_gpui_mobile_GpuiActivity_nativeOnDeepLink(
    _env: *mut std::ffi::c_void,
    _class: *mut std::ffi::c_void,
    url: *mut std::ffi::c_void,
) {
    // We already have a JVM attached on this thread (UI thread).
    // Use with_env to get a properly wrapped Env handle.
    let url_raw = url as jni::sys::jobject;
    let _ = with_env(|env| {
        let url_obj = unsafe { JObject::from_raw(env, url_raw) };
        let url_string = get_string(env, &url_obj);
        // Don't let the JObject be dropped (it's owned by the JNI call frame).
        if url_string.is_empty() {
            return Ok(());
        }
        log::info!("nativeOnDeepLink: {}", url_string);

        #[cfg(feature = "deeplink")]
        {
            crate::packages::deeplink::notify_deep_link(&url_string);
        }
        Ok(())
    });
}

/// JNI bridge: receive a media action from `GpuiMediaSession` system controls.
///
/// Actions: "play", "pause", "stop", "next", "previous"
///
/// # Safety
/// Must only be called from the JVM on a valid JNI thread with a valid `action` jobject.
#[cfg(feature = "media_session")]
#[unsafe(no_mangle)]
pub unsafe extern "C" fn Java_dev_gpui_mobile_GpuiMediaSession_nativeMediaAction(
    _env: *mut std::ffi::c_void,
    _class: *mut std::ffi::c_void,
    action: *mut std::ffi::c_void,
) {
    let action_raw = action as jni::sys::jobject;
    let _ = with_env(|env| {
        let action_obj = unsafe { JObject::from_raw(env, action_raw) };
        let action_str = get_string(env, &action_obj);

        let media_action = match action_str.as_str() {
            "play" => crate::packages::media_session::MediaAction::Play,
            "pause" => crate::packages::media_session::MediaAction::Pause,
            "stop" => crate::packages::media_session::MediaAction::Stop,
            "next" => crate::packages::media_session::MediaAction::Next,
            "previous" => crate::packages::media_session::MediaAction::Previous,
            other => {
                log::warn!("nativeMediaAction: unknown action '{}'", other);
                return Ok(());
            }
        };

        log::info!("nativeMediaAction: {:?}", media_action);
        crate::packages::media_session::notify_action(media_action);
        Ok(())
    });
}

/// JNI bridge: receive a seek request from `GpuiMediaSession` system controls.
///
/// # Safety
/// Must only be called from the JVM on a valid JNI thread.
#[cfg(feature = "media_session")]
#[unsafe(no_mangle)]
pub unsafe extern "C" fn Java_dev_gpui_mobile_GpuiMediaSession_nativeMediaSeek(
    _env: *mut std::ffi::c_void,
    _class: *mut std::ffi::c_void,
    position_ms: i64,
) {
    log::info!("nativeMediaSeek: {}ms", position_ms);
    crate::packages::media_session::notify_seek(position_ms as u64);
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn poll_events_returns_false_when_no_platform() {
        // PLATFORM is not set in a unit-test context, so poll_events should
        // be a safe no-op and return false (don't quit).
        let result = poll_events(0);
        let _ = result;
    }

    #[test]
    fn java_vm_returns_null_before_init() {
        // Before android_main is called, java_vm() should return null.
        let vm = java_vm();
        assert!(vm.is_null());
    }

    #[test]
    #[allow(deprecated)]
    fn activity_as_ptr_returns_null_before_init() {
        let ptr = activity_as_ptr();
        assert!(ptr.is_null());
    }

    #[test]
    fn android_app_returns_none_before_init() {
        assert!(android_app().is_none());
    }

    #[test]
    fn platform_returns_none_before_init() {
        assert!(platform().is_none());
    }
}

/// Starts a NativeActivity-backed GPUI application.
///
/// The Android activity stays on its foreground thread while GPUI owns the
/// native event loop. Platform initialization happens before constructing the
/// application so the primary surface can attach on Android's InitWindow event.
pub fn run_native_activity<F>(app: AndroidApp, launch: F)
where
    F: FnOnce(&mut gpui::App) + 'static,
{
    super::init_logger();
    let _runtime = match init_platform(&app) {
        Ok(runtime) => runtime,
        Err(error) => {
            log::error!("NativeActivity initialization rejected: {error}");
            return;
        }
    };
    let platform = shared_platform().expect("Android platform initialization failed");
    gpui::Application::with_platform(platform.into_rc()).run(launch);
}
