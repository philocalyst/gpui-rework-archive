//! Real Rust execution in a persistent vendored Miri interpreter.
//! A compiled source owns one interpreter; input events reuse that process.
#![allow(
    clippy::disallowed_methods,
    reason = "process I/O is confined to worker threads"
)]
use crate::session::{Reply, Request};
use anyhow::{Context, Result, bail};
use gpui_codepen_guest::{Frame, MAX_FRAME_BYTES, MAX_SOURCE_BYTES};
use std::{
    fs,
    io::{BufRead, BufReader, Read, Write},
    path::{Path, PathBuf},
    process::{Child, Command, Stdio},
    sync::{
        Arc, Mutex,
        atomic::{AtomicU64, Ordering},
        mpsc,
    },
    thread,
    time::{Duration, Instant},
};

pub const TOOLCHAIN: &str = "nightly-2026-09-30";
const MAX_DIAGNOSTICS_BYTES: usize = 64 * 1024;
const MIRI_FLAGS: &str = "-Zmiri-ignore-leaks -Zmiri-disable-leak-backtraces -Zmiri-disable-validation -Zmiri-disable-stacked-borrows -Zmiri-disable-data-race-detector -Zmiri-disable-alignment-check -Zmiri-disable-isolation -Zmiri-preemption-rate=0 -Zmiri-address-reuse-rate=0 -Zmiri-compare-exchange-weak-failure-rate=0";

/// Cargo resolves the fixed SDK once. Reuse its exact compiler invocation for
/// later edits, while rustc still parses and type-checks every new source.
#[derive(serde::Deserialize)]
struct CompilerInvocation {
    args: Vec<String>,
    env: Vec<(std::ffi::OsString, std::ffi::OsString)>,
}
pub fn repository_root() -> PathBuf {
    Path::new(env!("CARGO_MANIFEST_DIR"))
        .join("../..")
        .canonicalize()
        .expect("workspace root")
}

fn driver_libraries(command: &mut Command, sysroot: &Path) -> Result<()> {
    #[cfg(unix)]
    {
        let variable = if cfg!(target_os = "macos") {
            "DYLD_LIBRARY_PATH"
        } else {
            "LD_LIBRARY_PATH"
        };
        let mut paths = vec![sysroot.join("lib")];
        paths.extend(std::env::split_paths(
            &std::env::var_os(variable).unwrap_or_default(),
        ));
        command.env(variable, std::env::join_paths(paths)?);
    }
    Ok(())
}

pub struct Runtime {
    directory: tempfile::TempDir,
    bin: String,
    source: Option<String>,
    interpreter: Option<Interpreter>,
    sysroot: PathBuf,
    miri_sysroot: PathBuf,
    invocation: Option<CompilerInvocation>,
    platform: Arc<crate::platform_service::PlatformService>,
}
impl Runtime {
    pub fn new() -> Result<Self> {
        let directory = tempfile::Builder::new().prefix("gpui-codepen-").tempdir()?;
        // One shared dependency cache, unique component targets: concurrent views
        // cannot overwrite each other's MIR or force serde recompilation.
        let bin = format!("component_{}", uuid::Uuid::new_v4().simple());
        let sdk = Path::new(env!("CARGO_MANIFEST_DIR")).join("guest");
        let framework = sdk.join("../../gpui");
        let manifest = format!(
            "[workspace]\n[package]\nname = {bin:?}\nversion = \"0.0.0\"\nedition = \"2024\"\n[dependencies]\ngpui_codepen_guest = {{ path = {}, features = [\"interpreter\"] }}\ngpui = {{ package = \"gpui-ce\", path = {}, default-features = false, features = [\"headless\"] }}\n[[bin]]\nname = {bin:?}\npath = \"component.rs\"\n[profile.dev]\ndebug = 0\n",
            serde_json::to_string(&sdk.to_string_lossy())?,
            serde_json::to_string(&framework.to_string_lossy())?
        );
        fs::write(directory.path().join("Cargo.toml"), manifest)?;
        fs::copy(
            repository_root().join("Cargo.lock"),
            directory.path().join("Cargo.lock"),
        )?;
        let sysroot = Command::new("rustup")
            .args(["run", TOOLCHAIN, "rustc", "--print", "sysroot"])
            .output()
            .context("rustup is required; run scripts/codepen/setup.py")?;
        if !sysroot.status.success() {
            bail!("Pinned toolchain is missing; run python3 scripts/codepen/setup.py");
        }
        let wrapper = repository_root().join(format!(
            "vendor/miri/cargo-miri/target/debug/cargo-miri{}",
            std::env::consts::EXE_SUFFIX
        ));
        let sysroot = PathBuf::from(String::from_utf8(sysroot.stdout)?.trim());
        let mut setup = Command::new(wrapper);
        driver_libraries(&mut setup, &sysroot)?;
        let miri_sysroot = setup
            .args(["miri", "setup", "--print-sysroot"])
            .env(
                "MIRI",
                repository_root().join(format!(
                    "vendor/miri/target/release/miri{}",
                    std::env::consts::EXE_SUFFIX
                )),
            )
            .env(
                "RUSTC",
                sysroot.join(format!("bin/rustc{}", std::env::consts::EXE_SUFFIX)),
            )
            .output()
            .context("Vendored Miri is not built; run scripts/codepen/setup.py")?;
        if !miri_sysroot.status.success() {
            bail!("Miri sysroot is unavailable; run scripts/codepen/setup.py");
        }
        Ok(Self {
            directory,
            bin,
            source: None,
            interpreter: None,
            sysroot,
            miri_sysroot: PathBuf::from(String::from_utf8(miri_sysroot.stdout)?.trim()),
            invocation: None,
            platform: Arc::new(crate::platform_service::PlatformService::new()?),
        })
    }
    pub fn evaluate(&mut self, request: Request, latest: &AtomicU64) -> Reply {
        let start = Instant::now();
        let result = self.execute(&request, latest);
        let (frame, diagnostics) = match result {
            Ok(frame) => (Some(frame), String::new()),
            Err(e) => {
                // A cancelled, panicking or invalid guest can never contaminate
                // the next response. Drop kills descendants and joins pipe readers.
                self.interpreter = None;
                (None, format!("{e:#}"))
            }
        };
        Reply {
            generation: request.generation,
            frame,
            diagnostics,
            elapsed_ms: start.elapsed().as_millis() as u64,
        }
    }
    fn command(&self) -> Result<Command> {
        let optimization =
            std::env::var("GPUI_CODEPEN_MIR_OPT_LEVEL").unwrap_or_else(|_| "2".into());
        anyhow::ensure!(
            matches!(optimization.as_str(), "0" | "1" | "2"),
            "unsupported Codepen MIR optimization level"
        );
        let root = repository_root();
        let driver = root.join(format!(
            "vendor/miri/target/release/miri{}",
            std::env::consts::EXE_SUFFIX
        ));
        let wrapper = root.join(format!(
            "vendor/miri/cargo-miri/target/debug/cargo-miri{}",
            std::env::consts::EXE_SUFFIX
        ));
        if !driver.is_file() || !wrapper.is_file() {
            bail!("Vendored Miri is not built. Run: python3 scripts/codepen/setup.py");
        }
        let mut c = if let Some(invocation) = &self.invocation {
            let mut command = Command::new(&driver);
            command.arg("--sysroot").arg(&self.miri_sysroot);
            command.args(invocation.args.iter().filter(|arg| {
                !arg.starts_with("--error-format=")
                    && !arg.starts_with("--json=")
                    && arg.as_str() != "--force-warn=unused_crate_dependencies"
            }));
            command.envs(
                invocation
                    .env
                    .iter()
                    .filter(|(key, _)| key != "CARGO_MAKEFLAGS")
                    .map(|(key, value)| (key, value)),
            );
            command.args(MIRI_FLAGS.split_whitespace());
            if optimization != "0" {
                command.arg(format!("-Zmir-opt-level={optimization}"));
            }
            command.arg("--");
            command
        } else {
            let mut command = Command::new("rustup");
            command.args([
                "run",
                TOOLCHAIN,
                "cargo",
                "miri",
                "run",
                "--offline",
                "--bin",
                &self.bin,
                "--quiet",
            ]);
            command
        };
        c.current_dir(self.directory.path());
        c.env("CARGO_TARGET_DIR", root.join("target/codepen-real-miri"));
        for name in [
            "RUSTC_WRAPPER",
            "RUSTC_WORKSPACE_WRAPPER",
            "RUSTFLAGS",
            "CARGO_ENCODED_RUSTFLAGS",
            "MIRI_BE_RUSTC",
        ] {
            c.env_remove(name);
        }
        c.env(
            "RUSTC",
            self.sysroot
                .join(format!("bin/rustc{}", std::env::consts::EXE_SUFFIX)),
        );
        c.env(
            "RUSTDOC",
            self.sysroot
                .join(format!("bin/rustdoc{}", std::env::consts::EXE_SUFFIX)),
        );
        c.env("CARGO_TERM_COLOR", "never");
        let rustflags = if optimization == "0" {
            "-Cdebug-assertions=no -Awarnings".to_owned()
        } else {
            format!("-Cdebug-assertions=no -Awarnings -Copt-level=3 -Zmir-opt-level={optimization}")
        };
        c.env("RUSTFLAGS", rustflags);
        let mut paths = vec![
            wrapper.parent().unwrap().to_path_buf(),
            self.sysroot.join("bin"),
            self.sysroot.join("lib"),
        ];
        paths.extend(std::env::split_paths(
            &std::env::var_os("PATH").unwrap_or_default(),
        ));
        c.env("PATH", std::env::join_paths(paths)?);
        c.env("MIRI", driver);
        c.env("MIRI_SYSROOT", &self.miri_sysroot);
        c.env("MIRIFLAGS", MIRI_FLAGS);
        c.env("GPUI_CODEPEN_IPC", "1");
        c.env("GPUI_CODEPEN_PARENT_PID", std::process::id().to_string());
        driver_libraries(&mut c, &self.sysroot)?;
        Ok(c)
    }
    fn cache_invocation(&mut self) {
        if self.invocation.is_some() {
            return;
        }
        let targets = repository_root().join("target/codepen-real-miri/miri");
        if let Ok(entries) = fs::read_dir(targets) {
            for target in entries.flatten() {
                let descriptor = target.path().join("debug").join(&self.bin);
                if let Ok(bytes) = fs::read(descriptor) {
                    self.invocation = serde_json::from_slice(&bytes).ok();
                    if self.invocation.is_some() {
                        break;
                    }
                }
            }
        }
    }
    fn execute(&mut self, request: &Request, latest: &AtomicU64) -> Result<Frame> {
        if latest.load(Ordering::Relaxed) != request.generation {
            bail!("Superseded by a newer edit");
        }
        if request.source.len() > MAX_SOURCE_BYTES {
            bail!("Source exceeds 64 KiB");
        }
        let fresh = request.restart
            || self.source.as_deref() != Some(&request.source)
            || self.interpreter.is_none();
        let mut context = request.input.clone();
        if fresh {
            context.elapsed_ms = 0;
        }
        let input = gpui_codepen_guest::wire::encode_value(&context).map_err(anyhow::Error::msg)?;
        if input.len() >= 64 * 1024 + 512 {
            bail!("Input state exceeds 64 KiB");
        }
        request.input.validate().map_err(anyhow::Error::msg)?;
        if fresh {
            self.interpreter = None;
            fs::write(
                self.directory.path().join("component.rs"),
                format!(
                    "{}\n\nfn main() {{ gpui_codepen_guest::run(component); }}\n",
                    request.source
                ),
            )?;
            let mut interpreter = Interpreter::spawn(self.command()?, self.platform.clone())?;
            match interpreter.receive(latest, request.generation, Duration::from_secs(45))? {
                Message::Ready => {}
                Message::Frame(_) => bail!("Unexpected frame before interpreter initialization"),
            }
            self.cache_invocation();
            self.source = Some(request.source.clone());
            self.interpreter = Some(interpreter);
        }
        let mut packet = (input.len() as u32).to_le_bytes().to_vec();
        packet.extend_from_slice(&input);
        let interpreter = self.interpreter.as_mut().unwrap();
        interpreter.errors.lock().unwrap().clear();
        interpreter
            .input
            .as_ref()
            .unwrap()
            .try_send(packet)
            .context("Miri input transport is unavailable")?;
        let Message::Frame(bytes) =
            interpreter.receive(latest, request.generation, Duration::from_secs(30))?
        else {
            bail!("Unexpected interpreter restart");
        };
        let frame = gpui_codepen_guest::wire::decode(&bytes)
            .map_err(anyhow::Error::msg)
            .context("Invalid Miri frame")?;
        Ok(frame)
    }
}

impl Drop for Runtime {
    fn drop(&mut self) {
        self.interpreter.take();
    }
}

enum Message {
    Ready,
    Frame(Vec<u8>),
}
struct Interpreter {
    tree: ProcessTree,
    _platform: Arc<crate::platform_service::PlatformService>,
    input: Option<mpsc::SyncSender<Vec<u8>>>,
    output: Option<mpsc::Receiver<Message>>,
    errors: Arc<Mutex<Vec<u8>>>,
    overflow: Arc<AtomicU64>,
    threads: Vec<thread::JoinHandle<()>>,
}
impl Interpreter {
    fn spawn(
        mut command: Command,
        platform: Arc<crate::platform_service::PlatformService>,
    ) -> Result<Self> {
        command.env("GPUI_CODEPEN_RPC", &platform.address);
        let nonce = uuid::Uuid::new_v4().simple().to_string();
        command.env("GPUI_CODEPEN_NONCE", &nonce);
        prepare_process(&mut command);
        command
            .stdin(Stdio::piped())
            .stdout(Stdio::piped())
            .stderr(Stdio::piped());
        let mut tree = ProcessTree::new(command.spawn().context("Cannot start vendored Miri")?)?;
        let (send, output) = mpsc::sync_channel(2);
        let overflow = Arc::new(AtomicU64::new(0));
        let errors = Arc::new(Mutex::new(Vec::new()));
        let stdout = tree.child.stdout.take().unwrap();
        let excessive = overflow.clone();
        let reader = thread::spawn(move || {
            let mut pipe = BufReader::new(stdout);
            let mut noise = 0;
            let ready = format!("CODEPEN_{nonce}:READY:4\n").into_bytes();
            let prefix = format!("CODEPEN_{nonce}:FRAME:").into_bytes();
            loop {
                let mut bytes = Vec::new();
                match pipe
                    .by_ref()
                    .take((MAX_FRAME_BYTES + 32) as u64)
                    .read_until(b'\n', &mut bytes)
                {
                    Ok(0) | Err(_) => break,
                    Ok(_) => {}
                }
                if bytes.len() > MAX_FRAME_BYTES + 16 || bytes.last() != Some(&b'\n') {
                    excessive.store(1, Ordering::Relaxed);
                    break;
                }
                let message = if bytes == ready {
                    Some(Message::Ready)
                } else if let Some(header) = bytes.strip_prefix(prefix.as_slice()) {
                    let len = std::str::from_utf8(header)
                        .ok()
                        .and_then(|s| s.trim().parse::<usize>().ok());
                    let Some(len) = len.filter(|n| *n > 0 && *n <= MAX_FRAME_BYTES) else {
                        excessive.store(1, Ordering::Relaxed);
                        break;
                    };
                    let mut frame = vec![0; len];
                    let mut newline = [0];
                    if pipe
                        .read_exact(&mut frame)
                        .and_then(|_| pipe.read_exact(&mut newline))
                        .is_err()
                        || newline != [b'\n']
                    {
                        excessive.store(1, Ordering::Relaxed);
                        break;
                    }
                    noise = 0;
                    Some(Message::Frame(frame))
                } else {
                    noise += bytes.len();
                    None
                };
                if noise > MAX_DIAGNOSTICS_BYTES {
                    excessive.store(1, Ordering::Relaxed);
                    break;
                }
                if let Some(message) = message {
                    if send.try_send(message).is_err() {
                        excessive.store(1, Ordering::Relaxed);
                        break;
                    }
                }
            }
        });
        let mut stderr = tree.child.stderr.take().unwrap();
        let excessive = overflow.clone();
        let diagnostics = errors.clone();
        let profile = std::env::var_os("GPUI_CODEPEN_PROFILE").is_some();
        let error_reader = thread::spawn(move || {
            let mut bytes = [0; 8192];
            while let Ok(n) = stderr.read(&mut bytes) {
                if n == 0 {
                    break;
                }
                if profile {
                    eprint!("{}", String::from_utf8_lossy(&bytes[..n]));
                }
                let mut errors = diagnostics.lock().unwrap();
                if errors.len() + n > MAX_DIAGNOSTICS_BYTES {
                    excessive.store(1, Ordering::Relaxed);
                    break;
                }
                errors.extend_from_slice(&bytes[..n]);
            }
        });
        let (input, receive) = mpsc::sync_channel::<Vec<u8>>(1);
        let mut stdin = tree.child.stdin.take().unwrap();
        let writer = thread::spawn(move || {
            while let Ok(bytes) = receive.recv() {
                if stdin.write_all(&bytes).and_then(|_| stdin.flush()).is_err() {
                    break;
                }
            }
        });
        Ok(Self {
            tree,
            _platform: platform,
            input: Some(input),
            output: Some(output),
            errors,
            overflow,
            threads: vec![reader, error_reader, writer],
        })
    }
    fn receive(
        &mut self,
        latest: &AtomicU64,
        generation: u64,
        timeout: Duration,
    ) -> Result<Message> {
        let start = Instant::now();
        #[cfg(target_os = "macos")]
        let mut memory_sample = start;
        loop {
            if latest.load(Ordering::Relaxed) != generation {
                bail!("Superseded by a newer edit");
            }
            if start.elapsed() > timeout {
                bail!(
                    "Rust execution exceeded its {} second time budget",
                    timeout.as_secs()
                );
            }
            if self.overflow.load(Ordering::Relaxed) != 0 {
                bail!("Compiler or guest output exceeds its transport budget");
            }
            #[cfg(target_os = "macos")]
            if memory_sample.elapsed() >= Duration::from_millis(150) {
                memory_sample = Instant::now();
                if self.tree.exceeds_memory_budget() {
                    bail!("Rust execution exceeded the 4 GiB memory budget");
                }
            }
            match self
                .output
                .as_ref()
                .unwrap()
                .recv_timeout(Duration::from_millis(5))
            {
                Ok(message) => return Ok(message),
                Err(mpsc::RecvTimeoutError::Timeout) => {}
                Err(mpsc::RecvTimeoutError::Disconnected) => {
                    // Wait for stderr as well, so UB/panic diagnostics cannot race EOF.
                    self.input.take();
                    self.tree.terminate();
                    for thread in self.threads.drain(..) {
                        let _ = thread.join();
                    }
                    let errors = self.errors.lock().unwrap();
                    bail!(
                        "Miri stopped: {}{}",
                        String::from_utf8_lossy(&errors),
                        self._platform
                            .failure()
                            .map(|message| format!("\nPlatform service: {message}"))
                            .unwrap_or_default()
                    );
                }
            }
        }
    }
}
impl Drop for Interpreter {
    fn drop(&mut self) {
        self.input.take();
        self.output.take();
        self.tree.terminate();
        for thread in self.threads.drain(..) {
            let _ = thread.join();
        }
    }
}

fn prepare_process(command: &mut Command) {
    #[cfg(unix)]
    {
        use std::os::unix::process::CommandExt;
        command.process_group(0);
        #[cfg(target_os = "linux")]
        unsafe {
            command.pre_exec(|| {
                let limit = libc::rlimit {
                    rlim_cur: 4 * 1024 * 1024 * 1024,
                    rlim_max: 4 * 1024 * 1024 * 1024,
                };
                if libc::setrlimit(libc::RLIMIT_AS, &limit) != 0 {
                    return Err(std::io::Error::last_os_error());
                }
                Ok(())
            });
        }
    }
}

/// Own every compiler descendant, including on early errors and successful
/// parent exit. A descendant retaining a pipe must never strand a reader join.
struct ProcessTree {
    child: Child,
    terminated: bool,
    #[cfg(windows)]
    job: windows::Win32::Foundation::HANDLE,
}
impl ProcessTree {
    fn new(child: Child) -> Result<Self> {
        #[cfg(windows)]
        {
            use std::os::windows::io::AsRawHandle;
            use windows::{
                Win32::{Foundation::HANDLE, System::JobObjects::*},
                core::PCWSTR,
            };
            let mut tree = Self {
                child,
                terminated: false,
                job: HANDLE::default(),
            };
            unsafe {
                let job = CreateJobObjectW(None, PCWSTR::null())?;
                tree.job = job;
                let mut limits = JOBOBJECT_EXTENDED_LIMIT_INFORMATION::default();
                limits.BasicLimitInformation.LimitFlags =
                    JOB_OBJECT_LIMIT_KILL_ON_JOB_CLOSE | JOB_OBJECT_LIMIT_PROCESS_MEMORY;
                limits.ProcessMemoryLimit = 4 * 1024 * 1024 * 1024;
                SetInformationJobObject(
                    job,
                    JobObjectExtendedLimitInformation,
                    &limits as *const _ as _,
                    std::mem::size_of_val(&limits) as u32,
                )?;
                AssignProcessToJobObject(job, HANDLE(tree.child.as_raw_handle()))?;
            }
            Ok(tree)
        }
        #[cfg(not(windows))]
        {
            Ok(Self {
                child,
                terminated: false,
            })
        }
    }
    fn terminate(&mut self) {
        if self.terminated {
            return;
        }
        self.terminated = true;
        #[cfg(unix)]
        unsafe {
            libc::kill(-(self.child.id() as i32), libc::SIGKILL);
        }
        #[cfg(windows)]
        if !self.job.is_invalid() {
            unsafe {
                let _ = windows::Win32::System::JobObjects::TerminateJobObject(self.job, 1);
            }
        }
        let _ = self.child.kill();
        let _ = self.child.wait();
    }
    #[cfg(target_os = "macos")]
    fn exceeds_memory_budget(&self) -> bool {
        // Darwin rejects useful 64-bit rlimits. Sample resident memory for the
        // whole process group instead; this is a watchdog, not a hard sandbox.
        const PROC_PGRP_ONLY: u32 = 2;
        let mut pids = [0i32; 1024];
        unsafe {
            let bytes = libc::proc_listpids(
                PROC_PGRP_ONLY,
                self.child.id(),
                pids.as_mut_ptr().cast(),
                std::mem::size_of_val(&pids) as i32,
            );
            if bytes <= 0 {
                return false;
            }
            let count = bytes as usize / std::mem::size_of::<i32>();
            if count >= pids.len() {
                return true;
            }
            let mut resident = 0u64;
            for pid in &pids[..count] {
                let mut info: libc::proc_taskinfo = std::mem::zeroed();
                if libc::proc_pidinfo(
                    *pid,
                    libc::PROC_PIDTASKINFO,
                    0,
                    (&mut info as *mut libc::proc_taskinfo).cast(),
                    std::mem::size_of_val(&info) as i32,
                ) > 0
                {
                    resident = resident.saturating_add(info.pti_resident_size);
                }
            }
            resident > 4 * 1024 * 1024 * 1024
        }
    }
}
impl Drop for ProcessTree {
    fn drop(&mut self) {
        self.terminate();
        #[cfg(windows)]
        if !self.job.is_invalid() {
            unsafe {
                let _ = windows::Win32::Foundation::CloseHandle(self.job);
            }
        }
    }
}

/// Read concurrently so a full pipe cannot deadlock the compiler. Limit bytes
/// while reading; kill the entire process group on cancellation/timeout/overflow.
#[cfg(test)]
fn run_process(
    mut command: Command,
    input: &[u8],
    latest: &AtomicU64,
    generation: u64,
    timeout: Duration,
) -> Result<Vec<u8>> {
    #[cfg(unix)]
    {
        use std::os::unix::process::CommandExt;
        command.process_group(0);
        // Linux address-space limits also cover mmap allocations. macOS does
        // not support a useful RLIMIT_AS/DATA limit for modern 64-bit processes.
        #[cfg(target_os = "linux")]
        unsafe {
            command.pre_exec(|| {
                let limit = libc::rlimit {
                    rlim_cur: 4 * 1024 * 1024 * 1024,
                    rlim_max: 4 * 1024 * 1024 * 1024,
                };
                if libc::setrlimit(libc::RLIMIT_AS, &limit) != 0 {
                    return Err(std::io::Error::last_os_error());
                }
                Ok(())
            });
        }
    }
    command
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped());
    let child = command
        .spawn()
        .context("Cannot start Rust toolchain; run scripts/codepen/setup.py")?;
    let mut tree = ProcessTree::new(child)?;
    let overflow = Arc::new(AtomicU64::new(0));
    fn reader(
        mut pipe: impl Read + Send + 'static,
        overflow: Arc<AtomicU64>,
    ) -> thread::JoinHandle<Vec<u8>> {
        thread::spawn(move || {
            let mut out = Vec::new();
            let mut bytes = [0; 8192];
            loop {
                match pipe.read(&mut bytes) {
                    Ok(0) | Err(_) => break,
                    Ok(n) => {
                        if out.len() + n > MAX_FRAME_BYTES {
                            overflow.store(1, Ordering::Relaxed);
                            break;
                        }
                        out.extend_from_slice(&bytes[..n]);
                    }
                }
            }
            out
        })
    }
    let stdout = reader(tree.child.stdout.take().unwrap(), overflow.clone());
    let stderr = reader(tree.child.stderr.take().unwrap(), overflow.clone());
    let mut stdin = tree.child.stdin.take().unwrap();
    // Input is bounded to 64 KiB, but must also be written off-thread: a
    // compiler or a guest that ignores stdin must not defeat the watchdog.
    let input = input.to_vec();
    let writer = thread::spawn(move || {
        let _ = stdin.write_all(&input);
    });
    let start = Instant::now();
    #[cfg(target_os = "macos")]
    let mut memory_sample = start;
    let mut stopped = None;
    let status = loop {
        if latest.load(Ordering::Relaxed) != generation {
            stopped = Some("Superseded by a newer edit");
        }
        if start.elapsed() > timeout {
            stopped = Some("Rust execution exceeded its time budget");
        }
        if overflow.load(Ordering::Relaxed) != 0 {
            stopped = Some("Compiler or guest output exceeds its transport budget");
        }
        #[cfg(target_os = "macos")]
        if memory_sample.elapsed() >= Duration::from_millis(150) {
            memory_sample = Instant::now();
            if tree.exceeds_memory_budget() {
                stopped = Some("Rust processes exceeded their memory or process budget");
            }
        }
        if stopped.is_some() {
            break None;
        }
        if let Some(status) = tree.child.try_wait()? {
            break Some(status);
        }
        thread::sleep(Duration::from_millis(15));
    };
    tree.terminate();
    let _ = writer.join();
    let output = stdout.join().unwrap_or_default();
    let errors = stderr.join().unwrap_or_default();
    if let Some(stopped) = stopped {
        bail!("{stopped}");
    }
    if overflow.load(Ordering::Relaxed) != 0 {
        bail!("Compiler or guest output exceeds its transport budget");
    }
    if !status
        .context("Compiler stopped without an exit status")?
        .success()
    {
        bail!("{}", String::from_utf8_lossy(&errors));
    }
    Ok(output)
}

#[cfg(all(test, unix))]
mod tests {
    use super::*;

    #[test]
    fn successful_parent_cannot_leave_a_pipe_open_in_a_descendant() {
        let mut command = Command::new("sh");
        command.args(["-c", "sleep 60 & printf complete"]);
        let start = Instant::now();
        let output =
            run_process(command, &[], &AtomicU64::new(1), 1, Duration::from_secs(2)).unwrap();
        assert_eq!(output, b"complete");
        assert!(start.elapsed() < Duration::from_secs(2));
    }

    #[test]
    fn cancellation_terminates_descendants_and_recovers() {
        let mut command = Command::new("sh");
        command.args(["-c", "sleep 60 & wait"]);
        let error =
            run_process(command, &[], &AtomicU64::new(2), 1, Duration::from_secs(2)).unwrap_err();
        assert!(error.to_string().contains("Superseded"));
    }
}
