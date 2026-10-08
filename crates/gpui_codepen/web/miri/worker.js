import { WASI, WASIProcExit, Fd, File, Directory, PreopenDirectory, ConsoleStdout } from "./wasi/index.js";
import { pollClock } from "./wasi-clock.js";

let instance;
let mode = "vm";
let compilerIdentity;
let pendingPatch;
let inputWaiter;
let programWaiter;
let replacement;
let interrupted = false;
let cancelledGeneration;
let acknowledgedCancellation;
let root;
let initialPrograms = [];
let current;
const queue = [];
let diagnostics = "";
let started = false;
let compileStarted;
let executionStarted;
let compileMs = 0;
let patchTimings;
let patchStarted;
let profileFunctions = false;
let firstInput = true;
const stdoutDecoder = new TextDecoder();
const stderrDecoder = new TextDecoder();
// Alternate task sources: repeatedly reposting to the same MessagePort can
// monopolize its drain loop and starve incoming edit/cancel messages.
const yields = [new MessageChannel(), new MessageChannel()];
let nextYield = 0;
let yieldWaiter;
for (const channel of yields) channel.port1.onmessage = () => {
  const resume = yieldWaiter;
  yieldWaiter = undefined;
  resume();
};

class MetadataFile extends File {
  constructor(blob) {
    super(new ArrayBuffer(0), { readonly: true });
    this.blob = blob;
    this.cachedBytes = undefined;
  }
  get size() { return BigInt(this.blob.size); }
  get data() {
    return this.cachedBytes ??= new Uint8Array(new FileReaderSync().readAsArrayBuffer(this.blob));
  }
  set data(bytes) { this.cachedBytes = bytes; }
  path_open(...args) {
    const result = super.path_open(...args);
    if (result.fd_obj) {
      const close = result.fd_obj.fd_close.bind(result.fd_obj);
      const file = result.fd_obj;
      file.fd_read = size => {
        const data = this.data.subarray(Number(file.file_pos), Number(file.file_pos) + size);
        file.file_pos += BigInt(data.length);
        return { ret: 0, data };
      };
      file.fd_pread = (size, offset) => ({ ret: 0, data: this.data.subarray(Number(offset), Number(offset) + size) });
      result.fd_obj.fd_close = () => {
        // rustc owns the file it just read. Release the temporary JS copy.
        this.cachedBytes = undefined;
        return close();
      };
    }
    return result;
  }
}

function copyInput(message, pointer, capacity) {
  if (message.kind === "cancel") return 0;
  if (message.kind === "reload") {
    replacement = message;
    return 0; // Return normally through GPUI and Miri before replacing rustc.
  }
  patchTimings = message.patch ? { queue_ms: performance.now() - message.receivedAt } : undefined;
  if (message.patch) pendingPatch = message.patch;
  if (message.input.byteLength > capacity) throw new Error("GPUI input exceeds its transport capacity");
  current = { generation: message.generation };
  if (!firstInput) {
    executionStarted = performance.now();
    compileMs = message.compile_ms || 0;
  }
  firstInput = false;
  new Uint8Array(instance.exports.memory.buffer, pointer, message.input.byteLength).set(message.input);
  return message.input.byteLength;
}

function beginProgram(message) {
  firstInput = true;
  interrupted = false;
  cancelledGeneration = undefined;
  acknowledgedCancellation = undefined;
  current = { generation: message.generation };
  diagnostics = "";
  stdoutDecoder.decode();
  stderrDecoder.decode();
  if (message.source !== undefined) {
    put(root.dir, "/component.rs", new File(new TextEncoder().encode(programSource(message.source))));
  }
  root.dir.contents.delete("component.mir");
  if (mode === "vm") queue.push({ kind: "input", generation: message.generation, input: message.input });
  postMessage({ kind: "program", generation: message.generation });
  return 1;
}

function programSource(source) {
  if (mode === "compiler") {
    return source + (compilerIdentity
      ? "\npub fn __gpui_codepen_start() { gpui_codepen_guest::run(component); }\n"
      : "\nfn main() { gpui_codepen_guest::run(component); }\n");
  }
  const initial = initialPrograms.find(program => program.source === source);
  return initial ? `fn main() { ${initial.crate}::__gpui_codepen_start(); }\n`
    : source + "\nfn main() { gpui_codepen_guest::run(component); }\n";
}

function nextProgram(exitCode) {
  if (mode === "compiler") {
    diagnostics += stdoutDecoder.decode() + stderrDecoder.decode();
    const artifact = root.dir.contents.get("component.mir");
    const patch = exitCode === 0 && artifact ? artifact.data.slice() : undefined;
    root.dir.contents.delete("component.mir");
    postMessage({ kind: "compiled", generation: current.generation, patch,
      diagnostics: patch ? "" : diagnostics.trim(), compile_ms: performance.now() - compileStarted },
      patch ? [patch.buffer] : []);
    return new Promise(resolve => {
      programWaiter = message => { programWaiter = undefined; resolve(beginProgram(message)); };
    });
  }
  if (replacement) {
    const message = replacement;
    replacement = undefined;
    return beginProgram(message);
  }
  acknowledgeCancellation();
  // Interpreter failures can drop their complete compiler session and recover
  // in this same Worker. A fatal WASM trap still uses the hard restart path.
  postMessage({ kind: "reply", generation: current.generation,
    diagnostics: (diagnostics + `\nRust component stopped with status ${exitCode}`).trim(),
    failure: "rust", failed: true, recoverable: true });
  return new Promise(resolve => {
    programWaiter = message => {
      programWaiter = undefined;
      resolve(beginProgram(message));
    };
  });
}

function receiveInput(pointer, capacity) {
  if (interrupted) { acknowledgeCancellation(); return 0; }
  if (queue.length) return copyInput(queue.shift(), pointer, capacity);
  return new Promise((resolve, reject) => {
    inputWaiter = message => {
      inputWaiter = undefined;
      try { resolve(copyInput(message, pointer, capacity)); }
      catch (error) { reject(error); }
    };
  });
}

function receivePatch(pointer, capacity) {
  if (!pendingPatch) return 0;
  const length = pendingPatch.byteLength;
  if (capacity === 0) {
    patchStarted = performance.now();
    return length;
  }
  if (capacity < length) throw new Error("MIR patch destination is too small");
  const started = performance.now();
  new Uint8Array(instance.exports.memory.buffer, pointer, length).set(pendingPatch);
  patchTimings.copy_ms = performance.now() - started;
  pendingPatch = undefined;
  return length;
}
function reloadResult(accepted) {
  patchTimings.apply_ms = performance.now() - patchStarted;
  executionStarted = performance.now();
  postMessage({ kind: "patched", generation: current.generation, accepted: accepted !== 0,
    timings: patchTimings });
}

function checkpoint() {
  // Miri checks at block boundaries, yielding at most once per 16 ms. A message
  // task avoids the browser's nested-timer clamp on this long-lived loop.
  return new Promise(resolve => {
    yieldWaiter = () => {
      acknowledgeCancellation();
      resolve(interrupted ? 1 : 0);
    };
    yields[nextYield ^= 1].port2.postMessage(0);
  });
}

function acknowledgeCancellation() {
  if (interrupted && cancelledGeneration !== undefined && acknowledgedCancellation !== cancelledGeneration) {
    acknowledgedCancellation = cancelledGeneration;
    postMessage({ kind: "cancelled", generation: cancelledGeneration });
  }
}

function emitFrame(pointer, length) {
  if (!length) {
    postMessage({ kind: "ready", generation: current.generation });
    return;
  }
  const frame = new Uint8Array(instance.exports.memory.buffer, pointer, length).slice();
  const executionMs = performance.now() - executionStarted;
  postMessage({ kind: "reply", generation: current.generation, frame, diagnostics: "",
    timings: { compile_ms: compileMs, execution_ms: executionMs, ...patchTimings },
    ...(profileFunctions ? { profile: diagnostics } : {}) }, [frame.buffer]);
  if (profileFunctions) diagnostics = "";
  compileMs = 0;
  patchTimings = undefined;
}

function compilerPhase(phase) {
  if (phase === 0) compileStarted = performance.now();
  else {
    executionStarted = performance.now();
    compileMs = executionStarted - compileStarted;
  }
  postMessage({ kind: "phase", generation: current.generation, phase });
}

function fail(error) {
  diagnostics += stdoutDecoder.decode() + stderrDecoder.decode();
  const message = error instanceof WASIProcExit
    ? `Rust interpreter exited with status ${error.code}`
    : String(error?.message || error);
  postMessage({ kind: "reply", generation: current?.generation, diagnostics: (diagnostics + "\n" + message).trim(),
    failure: "unavailable", failed: true });
}

function put(root, path, file) {
  const parts = path.replace(/^\//, "").split("/");
  const name = parts.pop();
  let directory = root;
  for (const part of parts) {
    if (!directory.contents.has(part)) directory.contents.set(part, new Directory(new Map()));
    directory = directory.contents.get(part);
  }
  directory.contents.set(name, file);
}

async function start(message) {
  if (started) throw new Error("Rust interpreter was initialized twice");
  started = true;
  mode = message.mode || "vm";
  compilerIdentity = message.identity;
  current = { generation: message.generation };
  const bootStarted = performance.now();
  const startup = phase => postMessage({ kind: "startup", phase, generation: current.generation,
    elapsed_ms: performance.now() - bootStarted });
  startup("metadata");
  initialPrograms = message.manifest.starters || [];
  if (mode === "vm") queue.push({ generation: message.generation, input: message.input });
  // Browser Workers provide synchronous Blob reads, so the WASI filesystem can
  // load each immutable metadata file lazily. Headless JS runtimes use an eager
  // view of the same bytes when FileReaderSync is unavailable.
  const bytes = typeof FileReaderSync === "undefined" ? new Uint8Array(await message.metadata.arrayBuffer()) : undefined;
  root = new PreopenDirectory("/", []);
  for (const entry of message.manifest.files) {
    const file = bytes ? new File(new ArrayBuffer(0), { readonly: true })
      : new MetadataFile(message.metadata.slice(entry.offset, entry.offset + entry.length));
    if (bytes) file.data = bytes.subarray(entry.offset, entry.offset + entry.length);
    put(root.dir, entry.path, file);
  }
  put(root.dir, "/component.rs", new File(new TextEncoder().encode(programSource(message.source))));
  put(root.dir, "/tmp", new Directory([]));
  const record = decoder => chunk => {
    diagnostics += decoder.decode(chunk, { stream: true });
    if (diagnostics.length > 128 * 1024) diagnostics = diagnostics.slice(-128 * 1024);
  };
  const args = message.manifest.args.slice();
  const env = ["GPUI_CODEPEN_IPC=1", "GPUI_CODEPEN_HOT_RELOAD=1", "RUST_BACKTRACE=0", "RUSTC_ICE=0", "PWD=/", "TMPDIR=/tmp"];
  profileFunctions = message.manifest.profile_functions === true;
  if (profileFunctions) env.push("GPUI_CODEPEN_PROFILE=functions");
  if (message.manifest.software_float === true) env.push("GPUI_CODEPEN_SOFT_FLOAT=1");
  if (mode === "compiler") {
    env.push("GPUI_CODEPEN_EXPORT_MIR=/component.mir");
    if (message.manifest.incremental_compiler) {
      put(root.dir, "/incremental", new Directory([]));
      args.push("-Cincremental=/incremental");
      env.push("GPUI_CODEPEN_INCREMENTAL=1");
    }
    if (compilerIdentity) {
      args[args.indexOf("--crate-name") + 1] = compilerIdentity.crate;
      args.push("--crate-type=rlib");
    }
  } else {
    const starter = initialPrograms.find(program => program.source === message.source);
    if (starter) args.push("--extern", starter.crate + "=" + starter.path);
    if (starter?.packet) env.push("GPUI_CODEPEN_BASELINE_MIR=" + starter.packet);
  }
  const wasi = new WASI(args, env,
    [new Fd(), new ConsoleStdout(record(stdoutDecoder)), new ConsoleStdout(record(stderrDecoder)), root],
    { debug: false });
  startup("instantiate");
  instance = await WebAssembly.instantiate(message.module, {
    wasi_snapshot_preview1: { ...wasi.wasiImport,
      poll_oneoff: new WebAssembly.Suspending((...args) => pollClock(wasi, ...args)) },
    gpui_codepen: { emit_frame: emitFrame, receive_input: new WebAssembly.Suspending(receiveInput),
      next_program: new WebAssembly.Suspending(nextProgram), checkpoint: new WebAssembly.Suspending(checkpoint),
      compiler_phase: compilerPhase, receive_patch: receivePatch, reload_result: reloadResult },
  });
  wasi.inst = instance;
  startup("rust");
  // The virtual files own the inflated metadata. Do not retain the compressed
  // archive, module or source in this suspended invocation as well.
  message = undefined;
  // JSPI keeps rustc's arenas, Miri's call stack and actual GPUI entities alive
  // while the Worker waits for a click. No main-thread waits or interpreter
  // loop instrumentation are involved.
  await WebAssembly.promising(instance.exports._start)();
  fail(new Error("Rust component stopped before another frame"));
}

onmessage = ({ data }) => {
  if (data.kind === "start") start(data).catch(fail);
  else if (data.kind === "cancel") {
    if (current?.generation > data.generation) {
      postMessage({ kind: "cancel_ignored", generation: data.generation });
      return;
    }
    if (replacement?.generation === data.generation) replacement = undefined;
    interrupted = true;
    cancelledGeneration = data.generation;
    queue.length = 0;
    if (inputWaiter) {
      acknowledgeCancellation();
      inputWaiter(data);
    }
  } else if (data.kind === "compile") {
    if (programWaiter) programWaiter(data);
    else throw new Error("Compiler received overlapping source generations");
  } else if (data.kind === "reload") {
    queue.length = 0;
    if (programWaiter) programWaiter(data);
    else {
      replacement = data;
      interrupted = true;
      if (inputWaiter) inputWaiter(data);
    }
  } else if (data.kind === "input" || data.kind === "patch") {
    data.receivedAt = performance.now();
    if (programWaiter) programWaiter(data);
    else if (inputWaiter) inputWaiter(data);
    else queue.push(data);
  }
};
