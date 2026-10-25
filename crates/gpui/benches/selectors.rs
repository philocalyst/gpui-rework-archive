//! Run with `cargo bench -p gpui-ce --features bench-support --bench selectors`.
//! `-- --allocations` counts warm operations separately from timing runs.
//! Set `GPUI_TRACE_ALLOCATION_BYTES` to capture a matching allocation's stack.

use criterion::Criterion;
use gpui::{bench_platform, selector_benchmarks};
use smol::{
    block_on,
    process::{Command, Output},
};
use std::{
    alloc::{GlobalAlloc, Layout, System},
    backtrace::Backtrace,
    cell::{Cell, RefCell},
    collections::HashSet,
    env,
};

#[derive(Clone, Copy, Default)]
struct Allocations {
    count: usize,
    bytes: usize,
}

thread_local! {
    static ALLOCATIONS: Cell<Option<Allocations>> = const { Cell::new(None) };
    static TRACE_BYTES: Cell<Option<usize>> = const { Cell::new(None) };
    static ALLOCATION_TRACE: RefCell<Option<Backtrace>> = const { RefCell::new(None) };
}

struct CountingAllocator;

fn record(bytes: usize) {
    let _recorded = ALLOCATIONS.try_with(|counter| {
        if let Some(mut allocations) = counter.get() {
            allocations.count += 1;
            allocations.bytes += bytes;
            counter.set(Some(allocations));

            if TRACE_BYTES.with(|target| target.get()) == Some(bytes)
                && ALLOCATION_TRACE.with(|trace| trace.borrow().is_none())
            {
                // Capturing a stack allocates. Exclude that instrumentation and
                // prevent the allocator hook from recursively tracing itself.
                counter.set(None);
                let trace = Backtrace::force_capture();
                ALLOCATION_TRACE.with(|stored| *stored.borrow_mut() = Some(trace));
                counter.set(Some(allocations));
            }
        }
    });
}

unsafe impl GlobalAlloc for CountingAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        record(layout.size());

        // SAFETY: Forward the caller's allocation contract to the system allocator.
        unsafe { System.alloc(layout) }
    }

    unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
        record(layout.size());

        // SAFETY: Forward the caller's allocation contract to the system allocator.
        unsafe { System.alloc_zeroed(layout) }
    }

    unsafe fn dealloc(&self, pointer: *mut u8, layout: Layout) {
        // SAFETY: The pointer and layout came from the system allocator.
        unsafe { System.dealloc(pointer, layout) };
    }

    unsafe fn realloc(&self, pointer: *mut u8, layout: Layout, size: usize) -> *mut u8 {
        record(size);

        // SAFETY: Forward the caller's reallocation contract to the system allocator.
        unsafe { System.realloc(pointer, layout, size) }
    }
}

#[global_allocator]
static ALLOCATOR: CountingAllocator = CountingAllocator;

fn command_output(command: &mut Command) -> Output {
    block_on(command.output()).unwrap()
}

fn main() {
    if env::args().any(|argument| argument == "--allocations") {
        // Criterion's profiling mode calibrates every case for a full second. The fixtures
        // already warm their metadata and frames; test mode runs every assertion and counts
        // one operation without that unrelated timing work.
        let status = block_on(
            Command::new(env::current_exe().unwrap())
                .arg("--test")
                .env("GPUI_PROFILE_ALLOCATIONS", "1")
                .status(),
        )
        .unwrap();
        assert!(status.success(), "allocation profile failed: {status}");
        return;
    }

    let revision = command_output(Command::new("git").args(["rev-parse", "HEAD"]));
    let status = command_output(Command::new("git").args(["status", "--porcelain"]));
    let rustc = command_output(Command::new("rustc").arg("-V"));

    eprintln!(
        "revision={} dirty={}; {}; target={}-{}; backend=CPU TestPlatform; GPU=none; debug_assertions={}; font-kit={}; wayland={}; x11={}; windows-manifest={}",
        String::from_utf8_lossy(&revision.stdout).trim(),
        !status.stdout.is_empty(),
        String::from_utf8_lossy(&rustc.stdout).trim(),
        env::consts::ARCH,
        env::consts::OS,
        cfg!(debug_assertions),
        cfg!(feature = "font-kit"),
        cfg!(feature = "wayland"),
        cfg!(feature = "x11"),
        cfg!(feature = "windows-manifest"),
    );

    let allocations = env::var_os("GPUI_PROFILE_ALLOCATIONS").is_some();
    let trace_bytes = env::var("GPUI_TRACE_ALLOCATION_BYTES").ok().map(|bytes| {
        bytes
            .parse::<usize>()
            .expect("allocation size must be an integer")
    });
    let mut criterion = Criterion::default().configure_from_args();
    let platform = bench_platform(None, gpui_platform::current_platform(true).text_system());
    let mut recorded = HashSet::new();

    selector_benchmarks::run(&mut criterion, platform, |name, operation| {
        if !allocations || !recorded.insert(name.to_owned()) {
            return;
        }

        TRACE_BYTES.with(|target| target.set(trace_bytes));
        ALLOCATION_TRACE.with(|trace| *trace.borrow_mut() = None);
        ALLOCATIONS.with(|counter| counter.set(Some(Allocations::default())));
        operation();
        let result = ALLOCATIONS.with(|counter| counter.replace(None).unwrap());
        println!(
            "{name}: allocations={} bytes={}",
            result.count, result.bytes
        );
        ALLOCATION_TRACE.with(|trace| {
            if let Some(trace) = trace.borrow_mut().take() {
                eprintln!(
                    "{name}: allocation of {} bytes\n{trace}",
                    trace_bytes.unwrap()
                );
            }
        });
    });

    if !allocations {
        criterion.final_summary();
    }
}
