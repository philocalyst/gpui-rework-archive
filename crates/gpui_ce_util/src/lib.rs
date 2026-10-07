//! Small platform-neutral helpers shared by GPUI crates.
//!
//! The command helpers preserve the platform's process configuration, while the future and
//! logging extensions add context without changing the underlying result. Functions that log an
//! error intentionally return no error only where their name says so; use the `ResultExt` methods
//! when the failure has already been reported and execution can continue.

// FluentBuilder
// pub use gpui_util::{FutureExt, Timeout, arc_cow::ArcCow};

use std::{
    env,
    ffi::OsStr,
    ops::AddAssign,
    panic::Location,
    pin::Pin,
    sync::OnceLock,
    task::{Context, Poll},
    time::Instant,
};

pub mod arc_cow;

#[cfg(target_os = "windows")]
const CREATE_NO_WINDOW: u32 = 0x0800_0000_u32;

#[cfg(target_os = "windows")]
/// Creates a command without opening a console window on Windows.
pub fn new_std_command(program: impl AsRef<OsStr>) -> std::process::Command {
    use std::os::windows::process::CommandExt;

    let mut command = std::process::Command::new(program);
    command.creation_flags(CREATE_NO_WINDOW);
    command
}

#[cfg(not(target_os = "windows"))]
/// Create a standard-library command for `program`.
pub fn new_std_command(program: impl AsRef<OsStr>) -> std::process::Command {
    std::process::Command::new(program)
}

#[cfg(target_os = "windows")]
/// Locate the preferred installed PowerShell executable, if one is available.
pub fn get_powershell() -> Option<String> {
    use std::path::PathBuf;

    fn find_pwsh_in_programfiles(find_alternate: bool, find_preview: bool) -> Option<PathBuf> {
        #[cfg(target_pointer_width = "64")]
        let env_var = if find_alternate {
            "ProgramFiles(x86)"
        } else {
            "ProgramFiles"
        };

        #[cfg(target_pointer_width = "32")]
        let env_var = if find_alternate {
            "ProgramW6432"
        } else {
            "ProgramFiles"
        };

        let install_base_dir = PathBuf::from(std::env::var_os(env_var)?).join("PowerShell");
        install_base_dir
            .read_dir()
            .ok()?
            .filter_map(Result::ok)
            .filter(|entry| matches!(entry.file_type(), Ok(ft) if ft.is_dir()))
            .filter_map(|entry| {
                let dir_name = entry.file_name();
                let dir_name = dir_name.to_string_lossy();

                let version = if find_preview {
                    let dash_index = dir_name.find('-')?;
                    if &dir_name[dash_index + 1..] != "preview" {
                        return None;
                    };
                    dir_name[..dash_index].parse::<u32>().ok()?
                } else {
                    dir_name.parse::<u32>().ok()?
                };

                let exe_path = entry.path().join("pwsh.exe");
                if exe_path.is_file() {
                    Some((version, exe_path))
                } else {
                    None
                }
            })
            .max_by_key(|(version, _)| *version)
            .map(|(_, path)| path)
    }

    fn find_pwsh_in_msix(find_preview: bool) -> Option<PathBuf> {
        let msix_app_dir =
            PathBuf::from(std::env::var_os("LOCALAPPDATA")?).join("Microsoft\\WindowsApps");
        let package_family_name = if find_preview {
            "Microsoft.PowerShellPreview_8wekyb3d8bbwe"
        } else {
            "Microsoft.PowerShell_8wekyb3d8bbwe"
        };
        let pwsh_exe = msix_app_dir.join(package_family_name).join("pwsh.exe");
        pwsh_exe.exists().then_some(pwsh_exe)
    }

    fn find_pwsh_in_scoop() -> Option<PathBuf> {
        let pwsh_exe =
            PathBuf::from(std::env::var_os("USERPROFILE")?).join("scoop\\shims\\pwsh.exe");
        pwsh_exe.is_file().then_some(pwsh_exe)
    }

    fn find_pwsh_in_dotnet_tools() -> Option<PathBuf> {
        let pwsh_exe =
            PathBuf::from(std::env::var_os("USERPROFILE")?).join(".dotnet\\tools\\pwsh.exe");
        pwsh_exe.is_file().then_some(pwsh_exe)
    }

    fn find_windows_powershell() -> Option<PathBuf> {
        let system_root = PathBuf::from(std::env::var_os("SystemRoot")?);
        let powershell = system_root.join("System32\\WindowsPowerShell\\v1.0\\powershell.exe");
        powershell.is_file().then_some(powershell)
    }

    static POWERSHELL: std::sync::LazyLock<Option<String>> = std::sync::LazyLock::new(|| {
        let locations = [
            || find_pwsh_in_programfiles(false, false),
            || find_pwsh_in_programfiles(true, false),
            || find_pwsh_in_msix(false),
            || find_pwsh_in_programfiles(false, true),
            || find_pwsh_in_msix(true),
            || find_pwsh_in_programfiles(true, true),
            || find_pwsh_in_scoop(),
            || find_pwsh_in_dotnet_tools(),
            || which::which_global("pwsh.exe").ok(),
            || which::which_global("powershell.exe").ok(),
            || find_windows_powershell(),
        ];

        locations
            .into_iter()
            .find_map(|f| f())
            .map(|p| p.to_string_lossy().trim().to_owned())
            .inspect(|shell| log::info!("Found powershell in: {}", shell))
    });

    (*POWERSHELL).clone()
}

#[cfg(target_os = "windows")]
/// Returns the preferred PowerShell executable, or the system `cmd.exe` if none is found.
///
/// The result is cached on first use. PowerShell discovery checks installed
/// stable and preview builds, package-manager locations, `PATH`, and finally
/// Windows PowerShell under `SystemRoot`.
pub fn get_windows_system_shell() -> String {
    static CMD: std::sync::LazyLock<String> = std::sync::LazyLock::new(|| {
        log::warn!("Powershell not found, falling back to `cmd`");
        let system_root = std::env::var_os("SystemRoot").unwrap_or_else(|| "C:\\Windows".into());
        std::path::PathBuf::from(system_root)
            .join("System32\\cmd.exe")
            .to_string_lossy()
            .into_owned()
    });
    get_powershell().unwrap_or_else(|| (*CMD).clone())
}

/// Return the current value, then increment it by one.
pub fn post_inc<T: From<u8> + AddAssign<T> + Copy>(value: &mut T) -> T {
    let prev = *value;
    *value += T::from(1);
    prev
}

/// Runs `f`, printing its elapsed time when `ZED_MEASUREMENTS` is `1` or `true`.
///
/// The environment variable is read once per process on the first call; later
/// changes do not change measurement behavior. When enabled, the result is
/// printed to standard error as `label: duration`.
pub fn measure<R>(label: &str, f: impl FnOnce() -> R) -> R {
    static ZED_MEASUREMENTS: OnceLock<bool> = OnceLock::new();
    let zed_measurements = ZED_MEASUREMENTS.get_or_init(|| {
        env::var("ZED_MEASUREMENTS")
            .map(|measurements| measurements == "1" || measurements == "true")
            .unwrap_or(false)
    });

    if *zed_measurements {
        let start = Instant::now();
        let result = f();
        let elapsed = start.elapsed();
        eprintln!("{}: {:?}", label, elapsed);
        result
    } else {
        f()
    }
}

#[macro_export]
/// Panics in debug builds and logs the formatted message with a captured backtrace in release builds.
///
/// In release builds this macro returns after logging; it does not abort the
/// current operation.
macro_rules! debug_panic {
    ( $($fmt_arg:tt)* ) => {
        if cfg!(debug_assertions) {
            panic!( $($fmt_arg)* );
        } else {
            let backtrace = std::backtrace::Backtrace::capture();
            log::error!("{}\n{:?}", format_args!($($fmt_arg)*), backtrace);
        }
    };
}

#[track_caller]
/// Returns `Some` unchanged, or panics in debug builds when the value is `None`.
///
/// In release builds, `None` is returned unchanged. The panic location points
/// to the caller.
pub fn some_or_debug_panic<T>(option: Option<T>) -> Option<T> {
    #[cfg(debug_assertions)]
    if option.is_none() {
        panic!("Unexpected None");
    }
    option
}

/// Wraps a block in an immediately invoked closure, so `?` returns from that
/// block instead of from the surrounding function.
///
/// The normal form returns the closure's value. The `async` and `async move`
/// forms return a future. The surrounding function still needs to handle the
/// resulting `Option` or `Result` explicitly.
#[macro_export]
macro_rules! maybe {
    ($block:block) => {
        (|| $block)()
    };
    (async $block:block) => {
        (async || $block)()
    };
    (async move $block:block) => {
        (async move || $block)()
    };
}
/// Extension methods for reporting a `Result` error and continuing with an `Option`.
///
/// The logging methods preserve successful values and turn failures into
/// `None` after emitting a log record at the selected level. Use [`Self::anyhow`]
/// when the error must be returned to the caller instead of logged and dropped.
pub trait ResultExt<E> {
    type Ok;

    /// Log an error at error level and convert `Err` to `None`.
    fn log_err(self) -> Option<Self::Ok>;
    /// Like [`ResultExt::log_err`], but uses `{:?}` formatting so `anyhow::Error` values emit their
    /// full backtrace. Reach for this only when a backtrace is genuinely wanted — most call sites
    /// should stick with `log_err` / `warn_on_err`, whose output is a single chained error message.
    fn log_err_with_backtrace(self) -> Option<Self::Ok>
    where
        E: std::fmt::Debug;
    /// Reports an unexpected error as a debug panic, then returns the original result.
    ///
    /// In debug builds this panics on `Err`; in release builds it logs through
    /// [`debug_panic!`] and returns the same `Err`.
    fn debug_assert_ok(self, reason: &str) -> Self;
    /// Log an error at warning level and convert `Err` to `None`.
    fn warn_on_err(self) -> Option<Self::Ok>;
    /// Log an error at `level` and convert `Err` to `None`.
    fn log_with_level(self, level: log::Level) -> Option<Self::Ok>;
    /// Convert the error into `anyhow::Error` without logging it.
    fn anyhow(self) -> anyhow::Result<Self::Ok>
    where
        E: Into<anyhow::Error>;
}

impl<T, E> ResultExt<E> for Result<T, E>
where
    E: std::fmt::Display,
{
    type Ok = T;

    #[track_caller]
    fn log_err(self) -> Option<T> {
        self.log_with_level(log::Level::Error)
    }

    #[track_caller]
    fn log_err_with_backtrace(self) -> Option<T>
    where
        E: std::fmt::Debug,
    {
        match self {
            Ok(value) => Some(value),
            Err(error) => {
                log_error_with_caller(
                    *Location::caller(),
                    DebugAsDisplay(&error),
                    log::Level::Error,
                );
                None
            }
        }
    }

    #[track_caller]
    fn debug_assert_ok(self, reason: &str) -> Self {
        if let Err(error) = &self {
            debug_panic!("{reason} - {error:#}");
        }
        self
    }

    #[track_caller]
    fn warn_on_err(self) -> Option<T> {
        self.log_with_level(log::Level::Warn)
    }

    #[track_caller]
    fn log_with_level(self, level: log::Level) -> Option<T> {
        match self {
            Ok(value) => Some(value),
            Err(error) => {
                log_error_with_caller(*Location::caller(), error, level);
                None
            }
        }
    }

    fn anyhow(self) -> anyhow::Result<T>
    where
        E: Into<anyhow::Error>,
    {
        self.map_err(Into::into)
    }
}

fn log_error_with_caller<E>(caller: core::panic::Location<'_>, error: E, level: log::Level)
where
    E: std::fmt::Display,
{
    #[cfg(not(windows))]
    let file = caller.file();
    #[cfg(windows)]
    let file = caller.file().replace('\\', "/");
    // In this codebase all crates reside in a `crates` directory,
    // so discard the prefix up to that segment to find the crate name
    let file = file.split_once("crates/");
    let target = file.as_ref().and_then(|(_, s)| s.split_once("/src/"));

    let module_path = target.map(|(krate, module)| {
        if module.starts_with(krate) {
            module.trim_end_matches(".rs").replace('/', "::")
        } else {
            krate.to_owned() + "::" + &module.trim_end_matches(".rs").replace('/', "::")
        }
    });
    let file = file.map(|(_, file)| format!("crates/{file}"));
    log::logger().log(
        &log::Record::builder()
            .target(module_path.as_deref().unwrap_or(""))
            .module_path(file.as_deref())
            .args(format_args!("{:#}", error))
            .file(Some(caller.file()))
            .line(Some(caller.line()))
            .level(level)
            .build(),
    );
}

#[track_caller]
/// Logs `error` at error level, including the caller's source location.
pub fn log_err<E: std::fmt::Display>(error: &E) {
    log_error_with_caller(*Location::caller(), error, log::Level::Error);
}

// Forces `{:?}` formatting through a `Display`-bounded logging helper so `anyhow::Error` emits a
// backtrace instead of the single-line chained message produced by its `Display`/`{:#}` forms.
struct DebugAsDisplay<'a, E>(&'a E);

impl<E: std::fmt::Debug> std::fmt::Display for DebugAsDisplay<'_, E> {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "{:?}", self.0)
    }
}

/// Future adapters for `Future<Output = Result<T, E>>`.
pub trait TryFutureExt {
    /// Log an error at error level when the future resolves and return `Option<T>`.
    fn log_err(self) -> LogErrorFuture<Self>
    where
        Self: Sized;

    /// Logs an error at error level using an explicit source location.
    ///
    /// Use this when the future is created in one helper and the useful
    /// diagnostic location belongs to its caller.
    fn log_tracked_err(self, location: core::panic::Location<'static>) -> LogErrorFuture<Self>
    where
        Self: Sized;

    /// Logs an error at warning level when the future resolves and returns `Option<T>`.
    fn warn_on_err(self) -> LogErrorFuture<Self>
    where
        Self: Sized;
    /// Panics when the future resolves to `Err`; otherwise returns its value.
    fn unwrap(self) -> UnwrapFuture<Self>
    where
        Self: Sized;
}

/// `{:?}`-formatting companion to [`TryFutureExt`]; emits a backtrace for `anyhow::Error`. Prefer
/// [`TryFutureExt`] unless a backtrace is genuinely wanted.
pub trait TryFutureExtBacktrace {
    fn log_err_with_backtrace(self) -> LogErrorWithBacktraceFuture<Self>
    where
        Self: Sized;

    fn log_tracked_err_with_backtrace(
        self,
        location: core::panic::Location<'static>,
    ) -> LogErrorWithBacktraceFuture<Self>
    where
        Self: Sized;
}

impl<F, T, E> TryFutureExt for F
where
    F: Future<Output = Result<T, E>>,
    E: std::fmt::Display,
{
    #[track_caller]
    fn log_err(self) -> LogErrorFuture<Self>
    where
        Self: Sized,
    {
        let location = Location::caller();
        LogErrorFuture(self, log::Level::Error, *location)
    }

    fn log_tracked_err(self, location: core::panic::Location<'static>) -> LogErrorFuture<Self>
    where
        Self: Sized,
    {
        LogErrorFuture(self, log::Level::Error, location)
    }

    #[track_caller]
    fn warn_on_err(self) -> LogErrorFuture<Self>
    where
        Self: Sized,
    {
        let location = Location::caller();
        LogErrorFuture(self, log::Level::Warn, *location)
    }

    fn unwrap(self) -> UnwrapFuture<Self>
    where
        Self: Sized,
    {
        UnwrapFuture(self)
    }
}

impl<F, T, E> TryFutureExtBacktrace for F
where
    F: Future<Output = Result<T, E>>,
    E: std::fmt::Debug,
{
    #[track_caller]
    fn log_err_with_backtrace(self) -> LogErrorWithBacktraceFuture<Self>
    where
        Self: Sized,
    {
        let location = Location::caller();
        LogErrorWithBacktraceFuture(self, log::Level::Error, *location)
    }

    fn log_tracked_err_with_backtrace(
        self,
        location: core::panic::Location<'static>,
    ) -> LogErrorWithBacktraceFuture<Self>
    where
        Self: Sized,
    {
        LogErrorWithBacktraceFuture(self, log::Level::Error, location)
    }
}

#[must_use]
/// Future returned by [`TryFutureExt`] logging adapters.
pub struct LogErrorFuture<F>(F, log::Level, core::panic::Location<'static>);

impl<F, T, E> Future for LogErrorFuture<F>
where
    F: Future<Output = Result<T, E>>,
    E: std::fmt::Display,
{
    type Output = Option<T>;

    fn poll(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Self::Output> {
        let level = self.1;
        let location = self.2;
        let inner = unsafe { Pin::new_unchecked(&mut self.get_unchecked_mut().0) };
        match inner.poll(cx) {
            Poll::Ready(output) => Poll::Ready(match output {
                Ok(output) => Some(output),
                Err(error) => {
                    log_error_with_caller(location, error, level);
                    None
                }
            }),
            Poll::Pending => Poll::Pending,
        }
    }
}

#[must_use]
/// Future returned by [`TryFutureExtBacktrace`] logging adapters.
pub struct LogErrorWithBacktraceFuture<F>(F, log::Level, core::panic::Location<'static>);

impl<F, T, E> Future for LogErrorWithBacktraceFuture<F>
where
    F: Future<Output = Result<T, E>>,
    E: std::fmt::Debug,
{
    type Output = Option<T>;

    fn poll(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Self::Output> {
        let level = self.1;
        let location = self.2;
        let inner = unsafe { Pin::new_unchecked(&mut self.get_unchecked_mut().0) };
        match inner.poll(cx) {
            Poll::Ready(output) => Poll::Ready(match output {
                Ok(output) => Some(output),
                Err(error) => {
                    log_error_with_caller(location, DebugAsDisplay(&error), level);
                    None
                }
            }),
            Poll::Pending => Poll::Pending,
        }
    }
}

/// Future returned by [`TryFutureExt::unwrap`].
pub struct UnwrapFuture<F>(F);

impl<F, T, E> Future for UnwrapFuture<F>
where
    F: Future<Output = Result<T, E>>,
    E: std::fmt::Debug,
{
    type Output = T;

    fn poll(self: Pin<&mut Self>, cx: &mut Context) -> Poll<Self::Output> {
        let inner = unsafe { Pin::new_unchecked(&mut self.get_unchecked_mut().0) };
        match inner.poll(cx) {
            Poll::Ready(result) => Poll::Ready(result.unwrap()),
            Poll::Pending => Poll::Pending,
        }
    }
}

/// Runs a closure when this guard is dropped, unless [`Deferred::abort`] is called.
pub struct Deferred<F: FnOnce()>(Option<F>);

impl<F: FnOnce()> Deferred<F> {
    /// Drop without running the deferred function.
    pub fn abort(mut self) {
        self.0.take();
    }
}

impl<F: FnOnce()> Drop for Deferred<F> {
    fn drop(&mut self) {
        if let Some(f) = self.0.take() {
            f()
        }
    }
}

/// Defers `f` until the returned guard is dropped; [`Deferred::abort`] cancels it.
#[must_use]
pub fn defer<F: FnOnce()>(f: F) -> Deferred<F> {
    Deferred(Some(f))
}

#[derive(Default, Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
/// Build [`TypeIdHasher`] values for hash maps keyed by `TypeId`.
pub struct TypeIdHashBuilder;

impl std::hash::BuildHasher for TypeIdHashBuilder {
    type Hasher = TypeIdHasher;

    fn build_hasher(&self) -> Self::Hasher {
        TypeIdHasher::default()
    }
}

#[derive(Default, Copy, Clone, PartialEq, Eq, PartialOrd, Ord)]
/// A compact hasher for Rust's 64-bit `TypeId` representation.
///
/// This is specialized for `TypeId` keys, not a general-purpose hasher. It
/// reads the first eight bytes supplied by `Hash`; other input lengths trigger
/// [`debug_panic!`] in debug builds and log an error in release builds.
pub struct TypeIdHasher {
    value: u64,
}

impl std::hash::Hasher for TypeIdHasher {
    #[inline]
    fn write(&mut self, bytes: &[u8]) {
        // TypeId should only hash its first 8 bytes
        if let Some(bytes) = bytes.get(..8) {
            let array = <[u8; 8]>::try_from(bytes)
                .unwrap_or_else(|_| unreachable!("slice was sliced to 8 bytes"));
            self.value = u64::from_ne_bytes(array);
        } else {
            debug_panic!(
                "expected a 64-bit value, did you use this hasher with something other than a TypeId?"
            );
        }
    }

    #[inline]
    fn finish(&self) -> u64 {
        self.value
    }
}

#[test]
fn type_id_hasher() {
    use core::any::TypeId;
    use core::hash::{Hash, Hasher};
    fn verify_hashing_with(type_id: TypeId) {
        let mut hasher = TypeIdHasher::default();
        type_id.hash(&mut hasher);
        assert_ne!(hasher.finish(), 0);
    }
    // Pick a variety of types, just to demonstrate it’s all sane. Normal, zero-sized, unsized, &c.
    verify_hashing_with(TypeId::of::<usize>());
    verify_hashing_with(TypeId::of::<()>());
    verify_hashing_with(TypeId::of::<str>());
    verify_hashing_with(TypeId::of::<&str>());
    verify_hashing_with(TypeId::of::<Vec<u8>>());
}

/// Keeps the smallest `limit` items under `compare` and sorts the retained prefix.
///
/// The comparator defines both “smallest” and the output order. If `limit` is
/// zero the vector is cleared; if all items fit, the whole vector is sorted.
pub fn truncate_to_bottom_n_sorted_by<T, F>(items: &mut Vec<T>, limit: usize, compare: &F)
where
    F: Fn(&T, &T) -> std::cmp::Ordering,
{
    if limit == 0 {
        items.clear();
    }
    if items.len() <= limit {
        items.sort_by(compare);
        return;
    }
    // When limit is near to items.len() it may be more efficient to sort the whole list and
    // truncate, rather than always doing selection first as is done below. It's hard to analyze
    // where the threshold for this should be since the quickselect style algorithm used by
    // `select_nth_unstable_by` makes the prefix partially sorted, and so its work is not wasted -
    // the expected number of comparisons needed by `sort_by` is less than it is for some arbitrary
    // unsorted input.
    items.select_nth_unstable_by(limit, compare);
    items.truncate(limit);
    items.sort_by(compare);
}
