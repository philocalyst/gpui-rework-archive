//! Browser-local services for the GPUI frame driver. These imports exchange
//! bytes with the Worker host; guest addresses never escape Miri's memory model.
//! The compiled GPUI platform supplies text services, and the containing GPUI
//! window consumes the unchanged scene capture format.

#[link(wasm_import_module = "gpui_codepen")]
unsafe extern "C" {
    fn emit_frame(bytes: *const u8, len: usize);
    fn receive_patch(bytes: *mut u8, capacity: usize) -> usize;
    fn reload_result(accepted: u32);
    fn receive_input(bytes: *mut u8, capacity: usize) -> usize;
    #[link_name = "next_program"]
    fn host_next_program(exit_code: i32) -> u32;
    #[link_name = "checkpoint"]
    fn host_checkpoint() -> u32;
    #[link_name = "compiler_phase"]
    fn host_compiler_phase(phase: u32);
}

/// Yield only at interpreter basic-block boundaries. JSPI lets the Worker
/// receive edits without rebuilding the instance or instrumenting guest Rust.
/// The interpreter's entire heap can then be dropped through its normal exit
/// path before another compiler session is created.
pub fn checkpoint(blocks: u64) -> bool {
    if !blocks.is_multiple_of(4096) {
        return false;
    }
    LAST_CHECKPOINT.with(|last| {
        let now = std::time::Instant::now();
        if last.get().is_some_and(|previous| now.duration_since(previous).as_millis() < 16) {
            return false;
        }
        last.set(Some(now));
        unsafe { host_checkpoint() != 0 }
    })
}

std::thread_local! {
    static LAST_CHECKPOINT: std::cell::Cell<Option<std::time::Instant>> = const { std::cell::Cell::new(None) };
    static TEXT: std::cell::RefCell<Result<gpui_codepen_guest::rpc::TextService, String>> =
        std::cell::RefCell::new(gpui_codepen_guest::rpc::TextService::new().map_err(|e| e.to_string()));
}

pub fn platform_call(bytes: &[u8]) -> Result<Vec<u8>, String> {
    TEXT.with(|service| match &mut *service.borrow_mut() {
        Ok(service) => Ok(service.handle(bytes)),
        Err(error) => Err(error.clone()),
    })
}

pub fn emit(bytes: &[u8]) {
    unsafe {
        emit_frame(bytes.as_ptr(), bytes.len());
    }
}

pub fn receive(capacity: usize) -> Result<Vec<u8>, &'static str> {
    let mut input = vec![0; capacity];
    let len = unsafe { receive_input(input.as_mut_ptr(), capacity) };
    if len > capacity {
        return Err("GPUI browser input exceeds destination capacity");
    }
    input.truncate(len);
    Ok(input)
}

/// Wait for another component only after all of the previous compiler's arenas,
/// interpreter allocations and GPUI entities have been dropped. The host keeps
/// the WASM instance, immutable dependency files and incremental query cache.
pub fn next_program(exit_code: i32) -> bool {
    unsafe { host_next_program(exit_code) != 0 }
}

/// Distinguish compiler latency from interpreted GPUI work in the real Worker.
pub fn compiler_phase(phase: u32) {
    unsafe { host_compiler_phase(phase); }
}

/// A compiler Worker provides a complete validated MIR generation at an input
/// boundary. The VM Worker and its interpreted heap stay suspended until then.
pub fn patch() -> Result<Option<Vec<u8>>, &'static str> {
    let length = unsafe { receive_patch(std::ptr::null_mut(), 0) };
    if length == 0 { return Ok(None); }
    if length > 64 * 1024 * 1024 { return Err("MIR patch exceeds its transport budget"); }
    let mut bytes = vec![0; length];
    if unsafe { receive_patch(bytes.as_mut_ptr(), length) } != length {
        return Err("MIR patch changed during transfer");
    }
    Ok(Some(bytes))
}
pub fn patched(accepted: bool) { unsafe { reload_result(u32::from(accepted)); } }
