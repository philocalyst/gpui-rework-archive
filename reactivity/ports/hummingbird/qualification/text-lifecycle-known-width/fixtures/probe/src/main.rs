use gpui::{Win, WindowOptions};
use hummingbird_gpui_port::{
    app::{Library, connect},
    database::Database,
    search::SourceError,
    worker::{LibraryEvent, Selection, Worker},
};
use std::{
    alloc::{GlobalAlloc, Layout, System},
    cell::Cell,
    ffi::{c_char, c_int, c_void},
    fs::File,
    io::{BufWriter, Write},
    path::Path,
};
const FRAMES: usize = 40;
const CAPACITY: usize = 65536;
#[repr(C)]
struct DlInfo {
    name: *const c_char,
    base: *mut c_void,
    symbol: *const c_char,
    address: *mut c_void,
}
unsafe extern "C" {
    fn backtrace(buffer: *mut *mut c_void, size: c_int) -> c_int;
    fn dladdr(address: *const c_void, info: *mut DlInfo) -> c_int;
}
#[derive(Clone, Copy)]
struct Event {
    allocation: bool,
    pointer: usize,
    size: usize,
    depth: usize,
    frames: [usize; FRAMES],
}
struct Recorder {
    events: Vec<Event>,
    overflow: bool,
}
thread_local! { static ACTIVE:Cell<*mut Recorder> = const { Cell::new(std::ptr::null_mut()) }; }
struct TracingAllocator;
fn record(allocation: bool, pointer: *mut u8, size: usize) {
    let _ = ACTIVE.try_with(|active| {
        let recorder = active.replace(std::ptr::null_mut());
        if recorder.is_null() {
            return;
        }
        // Only this owner thread can access its recorder. Disabling ACTIVE
        // prevents instrumentation re-entry and allocation in the traced path.
        let recorder_ref = unsafe { &mut *recorder };
        if recorder_ref.events.len() == recorder_ref.events.capacity() {
            recorder_ref.overflow = true;
        } else {
            let mut frames = [0usize; FRAMES];
            let depth = unsafe { backtrace(frames.as_mut_ptr().cast(), FRAMES as c_int) };
            recorder_ref.events.push(Event {
                allocation,
                pointer: pointer as usize,
                size,
                depth: depth.max(0) as usize,
                frames,
            });
        }
        active.set(recorder);
    });
}
unsafe impl GlobalAlloc for TracingAllocator {
    unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
        let pointer = unsafe { System.alloc(layout) };
        record(true, pointer, layout.size());
        pointer
    }
    unsafe fn dealloc(&self, pointer: *mut u8, layout: Layout) {
        record(false, pointer, layout.size());
        unsafe { System.dealloc(pointer, layout) };
    }
    // Keep GlobalAlloc's default realloc/alloc_zeroed semantics, matching
    // allocation-counter's allocator rather than changing request accounting.
}
#[global_allocator]
static ALLOCATOR: TracingAllocator = TracingAllocator;
#[derive(Clone, Copy, Debug, Default)]
struct AllocationInfo {
    count_total: u64,
    count_current: i64,
    count_max: u64,
    bytes_total: u64,
    bytes_current: i64,
    bytes_max: u64,
}
#[derive(Clone, Copy, Default)]
struct Phase {
    start: usize,
    end: usize,
}
fn measure(recorder: &mut Recorder, phase: &mut Phase, work: impl FnOnce()) -> AllocationInfo {
    phase.start = recorder.events.len();
    ACTIVE.with(|active| assert!(active.replace(recorder as *mut Recorder).is_null()));
    work();
    ACTIVE.with(|active| active.set(std::ptr::null_mut()));
    phase.end = recorder.events.len();
    assert!(
        !recorder.overflow,
        "preallocated trace capacity exhausted; attribution invalid"
    );
    let mut info = AllocationInfo::default();
    for event in &recorder.events[phase.start..phase.end] {
        if event.allocation {
            info.count_total += 1;
            info.count_current += 1;
            info.bytes_total += event.size as u64;
            info.bytes_current += event.size as i64;
            info.count_max = info.count_max.max(info.count_current.max(0) as u64);
            info.bytes_max = info.bytes_max.max(info.bytes_current.max(0) as u64);
        } else {
            info.count_current -= 1;
            info.bytes_current -= event.size as i64;
        }
    }
    info
}
fn save(output: &Path, recorder: &Recorder, phases: &[[Phase; 3]; 4]) -> std::io::Result<()> {
    for (cohort, cohort_phases) in phases.iter().enumerate() {
        for (name, phase) in ["spawn", "connected", "mounted"]
            .into_iter()
            .zip(cohort_phases)
        {
            let mut file =
                BufWriter::new(File::create(output.join(format!("{cohort}-{name}.csv")))?);
            writeln!(file, "kind,pointer,size,pcs")?;
            for event in &recorder.events[phase.start..phase.end] {
                write!(
                    file,
                    "{},{:x},{},",
                    if event.allocation { "alloc" } else { "free" },
                    event.pointer,
                    event.size
                )?;
                for (index, address) in event.frames[..event.depth].iter().enumerate() {
                    if index != 0 {
                        write!(file, ";")?;
                    }
                    write!(file, "{address:x}")?;
                }
                writeln!(file)?;
            }
        }
    }
    std::fs::write(output.join("maps.txt"), std::fs::read("/proc/self/maps")?)?;
    let mut info = DlInfo {
        name: std::ptr::null(),
        base: std::ptr::null_mut(),
        symbol: std::ptr::null(),
        address: std::ptr::null_mut(),
    };
    assert_ne!(
        unsafe { dladdr(main as *const () as *const c_void, &mut info) },
        0
    );
    std::fs::write(
        output.join("exe-base.txt"),
        format!("{:x}\n", info.base as usize),
    )?;
    Ok(())
}
fn main() {
    let output = std::path::PathBuf::from(std::env::args().nth(1).expect("fresh output directory"));
    std::fs::create_dir(&output).unwrap();
    let mut warmup = [std::ptr::null_mut(); FRAMES];
    unsafe { backtrace(warmup.as_mut_ptr(), FRAMES as c_int) };
    let mut recorder = Recorder {
        events: Vec::with_capacity(CAPACITY),
        overflow: false,
    };
    let mut phases = [[Phase::default(); 3]; 4];
    println!(
        "AUDIO_ERROR_SIZE {}",
        size_of::<hummingbird_gpui_port::audio::AudioError>()
    );
    for (cohort, phase) in phases.iter_mut().enumerate() {
        let database = Database::fixture().unwrap();
        let mut spawned = None;
        let spawn = measure(&mut recorder, &mut phase[0], || {
            spawned = Some(Worker::new(database).unwrap())
        });
        let (worker, inbox) = spawned.unwrap();
        let mut connection = None;
        let connected = measure(&mut recorder, &mut phase[1], || {
            connection = Some(connect(worker.handle()).unwrap())
        });
        let (model, questions) = connection.unwrap();
        let model_bytes = size_of_val(&model);
        let questions_bytes = size_of_val(&questions);
        let mut window = None;
        let mounted = measure(&mut recorder, &mut phase[2], || {
            window = Some(
                Win::with_questions(
                    model,
                    questions,
                    WindowOptions {
                        size: [720, 1100],
                        ..Default::default()
                    },
                )
                .unwrap()
                .with_inbox_status(inbox, Library::receive)
                .unwrap(),
            );
        });
        let window = window.unwrap();
        println!(
            "COHORT {cohort} model={model_bytes} questions={questions_bytes} event={} selection={} error={} win={} ui_current_plus_inline={} spawn={spawn:?} connected={connected:?} mounted={mounted:?}",
            size_of::<LibraryEvent>(),
            size_of::<Selection>(),
            size_of::<SourceError>(),
            size_of_val(&window),
            spawn.bytes_current
                + connected.bytes_current
                + mounted.bytes_current
                + size_of_val(&window) as i64
        );
        drop(window);
        worker.finish().unwrap();
    }
    save(&output, &recorder, &phases).unwrap();
    println!("TRACE_EVENTS {}", recorder.events.len());
}
