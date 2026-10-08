// Browser-local Miri sessions. Compilation runs in a separate Worker; validated
// MIR generations update the resident interpreter at an input boundary.
const sessions = new Map();
const base = new URL("./", import.meta.url);
let assets;

async function cached(url) {
  const cache = await globalThis.caches?.open("gpui-miri-v1").catch(() => undefined);
  const hit = await cache?.match(url);
  if (hit) return hit;
  const response = await fetch(url);
  if (!response.ok) throw new Error(`Could not load Miri: ${response.status} ${url.pathname}`);
  if (cache) void cache.put(url, response.clone()).catch(() => {});
  return response;
}

async function compilerModule(url, compression) {
  let response = await cached(url);
  if (compression === "gzip") {
    response = new Response(response.body.pipeThrough(new DecompressionStream("gzip")),
      { headers: { "Content-Type": "application/wasm" } });
  } else if (compression) throw new Error(`Unsupported Miri module compression: ${compression}`);
  if (WebAssembly.compileStreaming && response.headers.get("Content-Type")?.split(";")[0] === "application/wasm") {
    return WebAssembly.compileStreaming(response);
  }
  return WebAssembly.compile(await response.arrayBuffer());
}

async function compilerMetadata(url) {
  const cache = await globalThis.caches?.open("gpui-miri-v1").catch(() => undefined);
  const expanded = new URL(url);
  expanded.pathname += ".raw";
  const hit = await cache?.match(expanded);
  if (hit) return hit.blob();
  const compressed = await cached(url);
  const response = new Response(compressed.body.pipeThrough(new DecompressionStream("gzip")));
  const cacheResponse = cache ? response.clone() : undefined;
  // Inflate once per immutable dependency bundle, not once per edited program.
  // Blob clones share storage; Workers read metadata files only when rustc asks.
  // Persisting hundreds of MiB must not delay the ready in-memory compiler.
  // A failed/background cache write only affects startup on the next visit.
  if (cache) void cache.put(expanded, cacheResponse).catch(() => {});
  return response.blob();
}

async function pruneCache(manifest) {
  const cache = await globalThis.caches?.open("gpui-miri-v1").catch(() => undefined);
  if (!cache?.keys) return;
  const keep = new Set([manifest.module, ...(manifest.metadata_parts || [manifest.metadata])]
    .flatMap(part => [new URL(part, base).href, new URL(part + ".raw", base).href]));
  for (const request of await cache.keys()) {
    const url = new URL(request.url);
    if (url.origin === base.origin && url.pathname.startsWith(base.pathname)
      && /^(miri-|metadata-)/.test(url.pathname.slice(base.pathname.length)) && !keep.has(url.href)) {
      await cache.delete(request);
    }
  }
}

function load() {
  if (!assets) assets = (async () => {
    if (!globalThis.Worker || !WebAssembly.Suspending || !WebAssembly.promising) {
      throw new Error("This browser needs WebAssembly Promise Integration to run Rust. Use a current browser.");
    }
    const response = await fetch(new URL("assets.json", base), { cache: "no-cache" });
    if (!response.ok) throw new Error("Browser Miri bundle is missing. Run scripts/codepen/browser.py all.");
    const manifest = await response.json();
    const [module, metadata] = await Promise.all([
      compilerModule(new URL(manifest.module, base), manifest.module_compression),
      // Blob structured clones share immutable storage across Workers. A source
      // edit does not copy the full compressed dependency archive on the UI thread.
      Promise.all((manifest.metadata_parts || [manifest.metadata])
        .map(part => compilerMetadata(new URL(part, base)))).then(parts => new Blob(parts)),
    ]);
    void pruneCache(manifest).catch(() => {});
    return { manifest, module, metadata };
  })().catch(error => { assets = undefined; throw error; });
  return assets;
}

function close(id, session, reason = "Superseded by a newer edit") {
  clearTimeout(session.cancelTimer);
  clearTimeout(session.compileTimer);
  clearTimeout(session.patchTimer);
  session.worker?.terminate();
  session.compiler?.terminate();
  session.pending?.reject(new Error(reason));
  session.pending = undefined;
  if (sessions.get(id) === session) sessions.delete(id);
}

function cancel(id, generation) {
  const session = sessions.get(id);
  if (!session || session.pending?.generation !== generation) return;
  const phase = session.pending.phase;
  session.pending.reject(new Error("Superseded by a newer edit"));
  session.pending = undefined;
  clearTimeout(session.compileTimer);
  clearTimeout(session.patchTimer);
  if (phase === "compile") {
    // Compiler cancellation never touches the interpreter or its entity heap.
    session.compiler?.terminate();
    session.compiler = undefined;
    return;
  }
  if (!session.worker) { close(id, session); return; }
  boundObsoleteWork(id, session, generation);
}

function finishInterruption(id, session) {
  clearTimeout(session.cancelTimer);
  session.cancelTimer = undefined;
  session.interrupting = false;
  session.needsReload = true;
  session.worker?.terminate();
  session.worker = undefined;
  const pending = session.pending;
  // Independent compilation can finish normally while the stopped VM is
  // replaced. It will initialize the newest source after validation succeeds.
  if (pending?.phase === "compile") return;
  if (pending) {
    pending.phase = "boot";
    startVm(id, session, pending.source, pending.generation, pending.input);
  } else close(id, session, "Rust interpreter stopped responding");
}

function boundObsoleteWork(id, session, generation) {
  session.cancelGeneration = generation;
  // Preserve the first deadline across rapid inputs/edits. Normal queued input
  // keeps its entity state; an obsolete infinite frame cannot starve new work.
  if (session.cancelTimer || !session.worker) return;
  session.cancelTimer = setTimeout(() => {
    session.interrupting = true;
    session.worker?.postMessage({ kind: "cancel", generation: session.cancelGeneration });
    // JSPI checkpoints normally acknowledge in one message task. A compiler
    // phase or fatal trap may not yield, so retain a short hard-stop deadline.
    session.cancelTimer = setTimeout(() => finishInterruption(id, session), 100);
  }, 2000);
}

function reply(session, data) {
  const pending = session.pending;
  if (!pending || pending.generation !== data.generation) return;
  clearTimeout(session.compileTimer);
  clearTimeout(session.patchTimer);
  session.pending = undefined;
  pending.resolve({ frame: data.frame, diagnostics: data.diagnostics || "",
    failure: data.failure || (data.diagnostics ? "rust" : undefined),
    elapsed_ms: performance.now() - pending.started, timings: data.timings });
}

function startVm(id, session, source, generation, input) {
  clearTimeout(session.cancelTimer);
  session.cancelTimer = undefined;
  session.cancelGeneration = undefined;
  session.interrupting = false;
  session.worker?.terminate();
  session.identity = session.bundle.manifest.starters?.find(program => program.source === source);
  if (session.compilerIdentity !== session.identity?.crate) {
    session.compiler?.terminate();
    session.compiler = undefined;
  }
  session.vmSource = source;
  session.patchSources = new Map();
  session.patchTarget = undefined;
  session.needsReload = false;
  const worker = new Worker(new URL("worker.js", base), { type: "module", name: "GPUI Rust interpreter" });
  session.worker = worker;
  worker.onmessage = ({ data }) => {
    if (sessions.get(id) !== session || session.worker !== worker) return;
    if (data.kind === "cancel_ignored") {
      if (session.interrupting && data.generation === session.cancelGeneration) {
        clearTimeout(session.cancelTimer);
        session.cancelTimer = undefined;
        session.cancelGeneration = undefined;
        session.interrupting = false;
      }
      return;
    }
    if (data.kind === "program" || data.kind === "cancelled") {
      if (data.kind === "cancelled" && session.interrupting && data.generation === session.cancelGeneration) {
        finishInterruption(id, session);
      }
      return;
    }
    if (data.kind === "patched") {
      const installed = session.patchSources.get(data.generation);
      session.patchSources.delete(data.generation);
      if (session.patchTarget?.generation === data.generation) session.patchTarget = undefined;
      if (data.accepted && installed !== undefined) session.vmSource = installed;
      const pending = session.pending;
      if (!pending) return;
      // A newer input can target the same still-unacknowledged source. Rejecting
      // its older patch must restart that newest request rather than run it on
      // the previous program's heap and falsely label the resulting frame.
      if (!data.accepted && installed !== undefined && pending.source === installed) {
        pending.phase = "boot";
        clearTimeout(session.patchTimer);
        startVm(id, session, pending.source, pending.generation, pending.input);
        return;
      }
      if (pending.generation !== data.generation) return;
      if (data.accepted) {
        pending.phase = "input";
      } else {
        // Rust layout/definition changes cannot reuse the old heap. The last
        // good frame remains visible while a valid replacement initializes.
        pending.phase = "boot";
        clearTimeout(session.patchTimer);
        startVm(id, session, pending.source, pending.generation, pending.input);
      }
      return;
    }
    if (data.kind === "reply") {
      // A frame for an older input must not complete a pending compilation.
      if (data.failed) {
        session.needsReload = true;
        if (session.interrupting) { finishInterruption(id, session); return; }
        const pending = session.pending;
        if (pending?.phase === "compile") {
          worker.terminate();
          session.worker = undefined;
          return;
        }
        if (pending && pending.generation !== data.generation) {
          pending.phase = "boot";
          startVm(id, session, pending.source, pending.generation, pending.input);
          return;
        }
        reply(session, data);
        worker.terminate();
        session.worker = undefined;
        if (!data.recoverable) close(id, session, "Rust interpreter stopped");
        return;
      }
      if (data.generation >= session.cancelGeneration) {
        clearTimeout(session.cancelTimer);
        session.cancelTimer = undefined;
      }
      if (session.pending?.phase !== "compile") reply(session, data);
    }
  };
  worker.onerror = event => {
    if (session.worker === worker) close(id, session, event.message || "Rust interpreter Worker stopped");
  };
  worker.onmessageerror = () => {
    if (session.worker === worker) close(id, session, "Could not exchange a Rust interpreter message");
  };
  const bytes = new Uint8Array(input);
  worker.postMessage({ kind: "start", mode: "vm", ...session.bundle, generation, source, input: bytes }, [bytes.buffer]);
}

function compile(id, session, pending) {
  pending.phase = "compile";
  const accept = ({ data }) => {
    if (sessions.get(id) !== session || session.compiler !== worker) return;
    if (data.kind !== "compiled" && !(data.kind === "reply" && data.failed)) return;
    const current = session.pending;
    if (!current || current.generation !== data.generation || current.phase !== "compile") return;
    clearTimeout(session.compileTimer);
    if (data.failed) {
      worker.terminate();
      session.compiler = undefined;
      reply(session, { generation: data.generation, diagnostics: data.diagnostics || "Rust compiler Worker stopped", failure: "unavailable" });
      return;
    }
    if (!data.patch) {
      reply(session, { generation: data.generation, diagnostics: data.diagnostics || "Rust compilation failed" });
      return;
    }
    if (session.needsReload) {
      current.phase = "boot";
      startVm(id, session, current.source, current.generation, current.input);
      return;
    }
    current.phase = "patch";
    session.patchSources.set(current.generation, current.source);
    session.patchTarget = { generation: current.generation, source: current.source };
    const input = new Uint8Array(current.input);
    session.worker.postMessage({ kind: "patch", generation: current.generation,
      patch: data.patch, compile_ms: data.compile_ms, input }, [data.patch.buffer, input.buffer]);
    session.patchTimer = setTimeout(() => {
      if (session.pending === current) {
        current.phase = "boot";
        startVm(id, session, current.source, current.generation, current.input);
      }
    }, 30000);
  };
  let worker = session.compiler;
  if (!worker) {
    worker = new Worker(new URL("worker.js", base), { type: "module", name: "GPUI Rust compiler" });
    session.compiler = worker;
    session.compilerIdentity = session.identity?.crate;
    worker.onmessage = accept;
    worker.onerror = event => {
      if (session.compiler !== worker) return;
      worker.terminate();
      session.compiler = undefined;
      const current = session.pending;
      if (current?.phase === "compile") reply(session, { generation: current.generation,
        diagnostics: event.message || "Rust compiler Worker stopped", failure: "unavailable" });
    };
    worker.onmessageerror = () => worker.onerror({ message: "Could not exchange a Rust compiler message" });
    worker.postMessage({ kind: "start", mode: "compiler", ...session.bundle,
      identity: session.identity, generation: pending.generation, source: pending.source });
  } else {
    worker.onmessage = accept;
    worker.postMessage({ kind: "compile", generation: pending.generation, source: pending.source });
  }
  session.compileTimer = setTimeout(() => {
    if (session.pending !== pending) return;
    worker.terminate();
    session.compiler = undefined;
    reply(session, { generation: pending.generation, diagnostics: "Rust compilation exceeded its 45 second time budget", failure: "unavailable" });
  }, 45000);
}

async function evaluate(id, generation, source, restart, input) {
  let session = sessions.get(id);
  if (session && restart) { close(id, session); session = undefined; }
  if (session?.pending) {
    if (session.pending.phase === "compile") cancel(id, session.pending.generation);
    else {
      boundObsoleteWork(id, session, session.pending.generation);
      session.pending.reject(new Error("Superseded by a newer input"));
      session.pending = undefined;
    }
  }
  if (!session) { session = {}; sessions.set(id, session); }
  clearTimeout(session.patchTimer);
  const started = performance.now();
  const result = new Promise((resolve, reject) => {
    session.pending = { generation, source, input: new Uint8Array(input), resolve, reject, started, phase: "boot" };
  });
  const pending = session.pending;
  const completion = result.catch(error => ({ diagnostics: String(error.message || error), failure: "unavailable",
    elapsed_ms: performance.now() - started }));
  try {
    session.bundle ||= await load();
    if (sessions.get(id) !== session || session.pending !== pending) return completion;
    if (!session.worker || session.needsReload) startVm(id, session, source, generation, pending.input);
    else if ((session.patchTarget?.source ?? session.vmSource) !== source) compile(id, session, pending);
    else {
      pending.phase = "input";
      const bytes = new Uint8Array(pending.input);
      session.worker.postMessage({ kind: "input", generation, input: bytes }, [bytes.buffer]);
    }
  } catch (error) { close(id, session, String(error.message || error)); }
  return completion;
}

globalThis.gpuiCodepenMiri = {
  evaluate,
  cancel,
  // Hosts can overlap immutable compiler loading with their own UI startup.
  preload: load,
  release(id) { const session = sessions.get(id); if (session) close(id, session, "Preview closed"); },
};
