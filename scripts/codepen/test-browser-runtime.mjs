// Transport regressions: the full Rust/GPUI execution probe is separate.
import assert from "node:assert/strict";
import { gzipSync } from "node:zlib";

const workers = [];
class Worker {
  messages = [];
  terminated = false;
  constructor() { workers.push(this); }
  postMessage(message) { this.messages.push(message); }
  terminate() { this.terminated = true; }
  reply(generation, extra = {}) {
    this.onmessage({ data: { kind: "reply", generation, frame: new Uint8Array([generation]), ...extra } });
  }
  notify(kind, generation) { this.onmessage({ data: { kind, generation } }); }
}
globalThis.Worker = Worker;
let cacheWrites = 0;
const cacheDeletes = [];
const bundleBase = new URL("../../crates/gpui_codepen/web/miri/", import.meta.url);
let prewarmCompiler = false;
globalThis.caches = { open: async () => ({
  match: async () => undefined,
  // Slow or blocked persistent storage must never gate compiler startup.
  put: () => { cacheWrites++; return new Promise(() => {}); },
  keys: async () => ["metadata-old.gz", "metadata-old.gz.raw", "metadata-sdk.gz", "metadata-sdk.gz.raw", "../metadata-other.gz"]
    .map(path => ({ url: new URL(path, bundleBase).href })),
  delete: async request => { cacheDeletes.push(request.url); return true; },
}) };
globalThis.fetch = async url => {
  if (url.pathname.endsWith("assets.json")) return Response.json({ module: "driver.wasm.gz", module_compression: "gzip",
    prewarm_compiler: prewarmCompiler,
    metadata: "metadata-sdk.gz", metadata_parts: ["metadata-sdk.gz", "metadata-starter.gz"],
    starters: [{ source: "identity A", crate: "a" }, { source: "identity B", crate: "b" }] });
  if (url.pathname.endsWith(".wasm.gz")) return new Response(gzipSync(new Uint8Array([0, 97, 115, 109, 1, 0, 0, 0])));
  if (url.pathname.endsWith("metadata-sdk.gz")) {
    await new Promise(resolve => setTimeout(resolve, 30));
    return new Response(gzipSync(new Uint8Array([1, 2])));
  }
  return new Response(gzipSync(new Uint8Array([3, 4])));
};
await import("../../crates/gpui_codepen/web/miri/runtime.js");
const runtime = globalThis.gpuiCodepenMiri;
const input = new Uint8Array(34);
const tick = () => new Promise(resolve => setTimeout(resolve, 10));
const latestCompiler = () => workers.findLast(worker => worker.messages[0]?.mode === "compiler" && !worker.terminated);

let reply = runtime.evaluate("idle", 1, "source", false, input);
for (let attempts = 0; !workers.length && attempts < 500; attempts++) await tick();
assert.ok(workers.length, "Compressed compiler startup must not wait for cache writes");
assert.equal(cacheWrites, 5, "Compressed assets and independently expanded metadata should persist in the background");
let worker = workers.at(-1);
assert.deepEqual(new Uint8Array(await worker.messages[0].metadata.arrayBuffer()), new Uint8Array([1, 2, 3, 4]),
  "Metadata chunks must retain manifest order when network completion order differs");
await tick();
assert.deepEqual(cacheDeletes, ["metadata-old.gz", "metadata-old.gz.raw"].map(path => new URL(path, bundleBase).href),
  "Cache pruning must retain current chunks and leave other bundle directories alone");
worker.reply(1);
assert.equal((await reply).frame[0], 1);
runtime.cancel("idle", 1);
assert.equal(worker.messages.length, 1, "A dropped completed future must not cancel the resident app");

const oldInput = runtime.evaluate("idle", 2, "source", false, input);
const newInput = runtime.evaluate("idle", 3, "source", false, input);
assert.match((await oldInput).diagnostics, /Superseded/);
runtime.cancel("idle", 2);
assert.equal(worker.messages.at(-1).kind, "input");
worker.reply(2);
worker.reply(3);
assert.equal((await newInput).frame[0], 3);
assert.equal(worker.terminated, false);
runtime.release("idle");

reply = runtime.evaluate("hot", 1, "first", false, input);
await tick();
worker = workers.at(-1);
worker.reply(1);
await reply;
const edited = runtime.evaluate("hot", 2, "edited", false, input);
await tick();
let compiler = workers.at(-1);
assert.notEqual(compiler, worker);
assert.equal(compiler.messages[0].mode, "compiler");
assert.equal(worker.terminated, false, "Compilation must retain the live interpreter");
compiler.onmessage({ data: { kind: "compiled", generation: 2, patch: new Uint8Array([9]), compile_ms: 3 } });
assert.equal(worker.messages.at(-1).kind, "patch");
worker.onmessage({ data: { kind: "patched", generation: 2, accepted: true } });
worker.reply(2);
assert.equal((await edited).frame[0], 2);
assert.equal(worker.terminated, false, "Compatible MIR patches must retain the entity heap");

const broken = runtime.evaluate("hot", 3, "invalid Rust", false, input);
await tick();
assert.equal(workers.at(-1), compiler, "Completed compiler sessions should reuse their Worker");
assert.equal(compiler.messages.at(-1).kind, "compile");
compiler.onmessage({ data: { kind: "compiled", generation: 3, diagnostics: "expected item" } });
const brokenReply = await broken;
assert.match(brokenReply.diagnostics, /expected item/);
assert.equal(brokenReply.failure, "rust");
const restored = runtime.evaluate("hot", 4, "edited", false, input);
await tick();
assert.equal(worker.messages.at(-1).kind, "input", "Restoring the last good source must retain its state");
worker.reply(4);
await restored;

const cancelledCompile = runtime.evaluate("hot", 5, "obsolete source", false, input);
await tick();
runtime.cancel("hot", 5);
assert.match((await cancelledCompile).diagnostics, /Superseded/);
assert.equal(compiler.terminated, false, "Short obsolete compilations must preserve the warm incremental Worker");
assert.equal(worker.terminated, false, "Cancelling compilation must keep the live preview");
const newest = runtime.evaluate("hot", 6, "newest source", false, input);
await tick();
const newestCompiler = workers.at(-1);
assert.equal(newestCompiler, compiler);
assert.equal(compiler.messages.at(-1).generation, 5, "The newest edit queues while the previous compiler session drains");
compiler.onmessage({ data: { kind: "compiled", generation: 5, patch: new Uint8Array([5]) } });
assert.notEqual(worker.messages.at(-1).generation, 5, "A stale compiler must never patch the resident VM");
assert.equal(compiler.messages.at(-1).generation, 6, "Only the newest source starts after the obsolete session finishes");
newestCompiler.onmessage({ data: { kind: "compiled", generation: 6, patch: new Uint8Array([6]) } });
worker.onmessage({ data: { kind: "patched", generation: 6, accepted: false } });
const replacementVm = workers.at(-1);
assert.equal(replacementVm.messages[0].mode, "vm");
assert.equal(replacementVm.messages[0].source, "newest source");
assert.equal(worker.terminated, true, "An incompatible Rust layout needs a fresh interpreter");
replacementVm.reply(6);
await newest;
const nextEdit = runtime.evaluate("hot", 7, "incompatible second edit", false, input);
await tick();
const nextCompiler = latestCompiler();
assert.equal(nextCompiler, newestCompiler, "VM layout restarts must retain the compiler cache when its identity matches");
nextCompiler.onmessage({ data: { kind: "compiled", generation: 7, patch: new Uint8Array([7]) } });
const newerSameSource = runtime.evaluate("hot", 8, "incompatible second edit", false, input);
await tick();
assert.match((await nextEdit).diagnostics, /Superseded/);
assert.equal(replacementVm.messages.at(-1).kind, "input");
replacementVm.onmessage({ data: { kind: "patched", generation: 7, accepted: false } });
const latestVm = workers.at(-1);
assert.notEqual(latestVm, replacementVm, "Rejected old patches must restart newer inputs targeting that same source");
assert.equal(latestVm.messages[0].generation, 8);
assert.equal(latestVm.messages[0].source, "incompatible second edit");
replacementVm.reply(8);
latestVm.reply(8);
assert.equal((await newerSameSource).frame[0], 8);
runtime.release("hot");

reply = runtime.evaluate("coalesced", 1, "original", false, input);
await tick();
worker = workers.at(-1);
worker.reply(1); await reply;
const compiling = runtime.evaluate("coalesced", 2, "edit one", false, input);
await tick();
compiler = latestCompiler();
const skipped = runtime.evaluate("coalesced", 3, "edit two", false, input);
const coalesced = runtime.evaluate("coalesced", 4, "edit three", false, input);
assert.match((await compiling).diagnostics, /Superseded/);
assert.match((await skipped).diagnostics, /Superseded/);
await tick();
assert.equal(compiler.messages.length, 1, "Rapid edits have one active compilation and one latest source slot");
compiler.onmessage({ data: { kind: "compiled", generation: 2, patch: new Uint8Array([2]) } });
assert.deepEqual(compiler.messages.map(message => message.generation), [2, 4], "Intermediate source never enters rustc");
compiler.onmessage({ data: { kind: "compiled", generation: 3, patch: new Uint8Array([3]) } });
assert.notEqual(worker.messages.at(-1).generation, 3);
compiler.onmessage({ data: { kind: "compiled", generation: 4, patch: new Uint8Array([4]) } });
worker.onmessage({ data: { kind: "patched", generation: 4, accepted: true } });
worker.reply(4); await coalesced;
const stuck = runtime.evaluate("coalesced", 5, "expensive obsolete Rust", false, input);
await tick();
const afterStuck = runtime.evaluate("coalesced", 6, "latest after timeout", false, input);
await stuck;
await new Promise(resolve => setTimeout(resolve, 2200));
const recoveredCompiler = latestCompiler();
assert.notEqual(recoveredCompiler, compiler, "Obsolete compiler work has a bounded drain deadline");
assert.equal(compiler.terminated, true);
assert.equal(worker.terminated, false, "Compiler deadline must retain the preview entity heap");
assert.equal(recoveredCompiler.messages[0].generation, 6);
compiler.onmessage({ data: { kind: "compiled", generation: 5, patch: new Uint8Array([5]) } });
assert.notEqual(worker.messages.at(-1).generation, 5);
recoveredCompiler.onmessage({ data: { kind: "compiled", generation: 6, patch: new Uint8Array([6]) } });
worker.onmessage({ data: { kind: "patched", generation: 6, accepted: true } });
worker.reply(6); await afterStuck;
runtime.release("coalesced");

reply = runtime.evaluate("undo", 1, "original", false, input);
await tick();
worker = workers.at(-1); worker.reply(1); await reply;
const undoFirst = runtime.evaluate("undo", 2, "edit A", false, input);
await tick(); compiler = latestCompiler();
const undoMiddle = runtime.evaluate("undo", 3, "edit B", false, input);
const undoLatest = runtime.evaluate("undo", 4, "edit A", false, new Uint8Array([42]));
await undoFirst; await undoMiddle; await tick();
compiler.onmessage({ data: { kind: "compiled", generation: 2, patch: new Uint8Array([2]) } });
assert.equal(compiler.messages.length, 1, "Undo to the active exact source must reuse its compilation");
assert.equal(worker.messages.at(-1).generation, 4);
assert.deepEqual(worker.messages.at(-1).input, new Uint8Array([42]), "Adopted MIR must use the latest input");
worker.onmessage({ data: { kind: "patched", generation: 4, accepted: true } });
worker.reply(4); await undoLatest; runtime.release("undo");

for (const failure of ["reply", "onerror"]) {
  const id = `obsolete-${failure}`;
  reply = runtime.evaluate(id, 1, "original", false, input);
  await tick(); worker = workers.at(-1); worker.reply(1); await reply;
  const obsolete = runtime.evaluate(id, 2, "obsolete source", false, input);
  await tick(); compiler = latestCompiler();
  const queued = runtime.evaluate(id, 3, "latest source", false, input);
  await obsolete; await tick();
  if (failure === "reply") compiler.reply(2, { failed: true, diagnostics: "old compiler trap" });
  else compiler.onerror({ message: "old compiler trap" });
  const replacement = latestCompiler();
  assert.equal(compiler.terminated, true);
  assert.notEqual(replacement, compiler);
  assert.equal(replacement.messages[0].generation, 3);
  assert.equal(replacement.messages[0].source, "latest source");
  assert.equal(worker.terminated, false);
  await new Promise(resolve => setTimeout(resolve, 2100));
  assert.equal(replacement.terminated, false, "An obsolete deadline must not stop the replacement compiler's own budget");
  replacement.onmessage({ data: { kind: "compiled", generation: 3, patch: new Uint8Array([3]) } });
  worker.onmessage({ data: { kind: "patched", generation: 3, accepted: true } });
  worker.reply(3); await queued; runtime.release(id);
}

reply = runtime.evaluate("identity", 1, "identity A", false, input);
await tick(); worker = workers.at(-1); worker.reply(1); await reply;
const oldIdentityJob = runtime.evaluate("identity", 2, "edit A", false, input);
await tick(); compiler = latestCompiler();
const oldIdentityQueue = runtime.evaluate("identity", 3, "edit A again", false, input);
await oldIdentityJob; await tick();
worker.reply(1, { failed: true, recoverable: true, diagnostics: "old VM stopped" });
const newIdentity = runtime.evaluate("identity", 4, "identity B", false, input);
await oldIdentityQueue; await tick();
const identityVm = workers.at(-1);
assert.equal(compiler.terminated, true, "Changing starter identity must discard the previous compiler and deadline");
assert.equal(identityVm.messages[0].source, "identity B");
identityVm.reply(4); await newIdentity;
const identityEdit = runtime.evaluate("identity", 5, "edit B", false, input);
await tick(); const identityCompiler = latestCompiler();
assert.equal(identityCompiler.messages[0].identity.crate, "b");
await new Promise(resolve => setTimeout(resolve, 2100));
assert.equal(identityCompiler.terminated, false, "The old identity's stale timer must not stop the replacement compiler");
compiler.onmessage({ data: { kind: "compiled", generation: 2, patch: new Uint8Array([2]) } });
assert.notEqual(identityVm.messages.at(-1).generation, 2);
identityCompiler.onmessage({ data: { kind: "compiled", generation: 5, patch: new Uint8Array([5]) } });
identityVm.onmessage({ data: { kind: "patched", generation: 5, accepted: true } });
identityVm.reply(5); await identityEdit; runtime.release("identity");

reply = runtime.evaluate("deadline", 1, "first", false, input);
await tick();
worker = workers.at(-1);
runtime.cancel("deadline", 1);
await reply;
worker.notify("program", 0);
worker.notify("cancelled", 0);
await new Promise(resolve => setTimeout(resolve, 2200));
assert.equal(worker.terminated, true, "Stale acknowledgments must not disable a cancellation deadline");

reply = runtime.evaluate("late-cancel", 1, "same", false, input);
await tick();
worker = workers.at(-1);
worker.reply(1); await reply;
const obsoleteInput = runtime.evaluate("late-cancel", 2, "same", false, input);
const currentInput = runtime.evaluate("late-cancel", 3, "same", false, input);
await obsoleteInput;
await new Promise(resolve => setTimeout(resolve, 2020));
assert.equal(worker.messages.at(-1).kind, "cancel");
worker.notify("cancel_ignored", 2);
await new Promise(resolve => setTimeout(resolve, 150));
assert.equal(worker.terminated, false, "A cancel arriving after the VM advances must keep the newer generation alive");
worker.reply(3);
assert.equal((await currentInput).frame[0], 3);
runtime.release("late-cancel");

reply = runtime.evaluate("recovery", 1, "original", false, input);
await tick();
worker = workers.at(-1);
worker.reply(1); await reply;
const acceptedEdit = runtime.evaluate("recovery", 2, "accepted edit", false, input);
await tick();
compiler = workers.at(-1);
compiler.onmessage({ data: { kind: "compiled", generation: 2, patch: new Uint8Array([2]) } });
worker.onmessage({ data: { kind: "patched", generation: 2, accepted: true } });
worker.reply(2); await acceptedEdit;
const failingOldInput = runtime.evaluate("recovery", 3, "accepted edit", false, input);
const newerInput = runtime.evaluate("recovery", 4, "accepted edit", false, input);
await tick();
await failingOldInput;
worker.reply(3, { frame: undefined, failed: true, recoverable: true, diagnostics: "panic" });
const recoveredVm = workers.at(-1);
assert.notEqual(recoveredVm, worker, "A stale failure must restart an already queued newer input");
assert.equal(recoveredVm.messages[0].source, "accepted edit", "Recovery must preserve the latest accepted source");
assert.equal(recoveredVm.messages[0].generation, 4);
worker.reply(4);
recoveredVm.reply(4); await newerInput;

const compilerFailure = runtime.evaluate("recovery", 5, "another edit", false, input);
await tick();
const failedCompiler = latestCompiler();
failedCompiler.reply(5, { failed: true, frame: undefined, diagnostics: "instantiate trap" });
const unavailableReply = await compilerFailure;
assert.match(unavailableReply.diagnostics, /instantiate trap/);
assert.equal(unavailableReply.failure, "unavailable");
assert.equal(failedCompiler.terminated, true, "Compiler startup failure must finish immediately");

const infiniteInput = runtime.evaluate("recovery", 6, "accepted edit", false, input);
await tick();
const supersedingInput = runtime.evaluate("recovery", 7, "accepted edit", false, input);
await tick(); await infiniteInput;
const latestInput = runtime.evaluate("recovery", 8, "accepted edit", false, input);
await tick(); await supersedingInput;
await new Promise(resolve => setTimeout(resolve, 2025));
assert.equal(recoveredVm.messages.at(-1).kind, "cancel", "Superseding input must retain the bounded interruption deadline");
assert.equal(recoveredVm.messages.at(-1).generation, 7);
recoveredVm.notify("cancelled", 7);
const responsiveVm = workers.at(-1);
assert.notEqual(responsiveVm, recoveredVm);
assert.equal(responsiveVm.messages[0].generation, 8);
assert.equal(responsiveVm.messages[0].source, "accepted edit");
responsiveVm.reply(8); await latestInput;
runtime.release("recovery");

reply = runtime.evaluate("hard-stop", 1, "stuck", false, input);
await tick();
worker = workers.at(-1);
const newestAfterHardStop = runtime.evaluate("hard-stop", 2, "stuck", false, input);
await tick(); await reply;
await new Promise(resolve => setTimeout(resolve, 2200));
const hardStopVm = workers.at(-1);
assert.equal(worker.terminated, true, "Missing JSPI cancellation acknowledgments must retain the hard deadline");
assert.notEqual(hardStopVm, worker);
assert.equal(hardStopVm.messages[0].generation, 2);
assert.equal(hardStopVm.messages[0].source, "stuck");
assert.deepEqual(hardStopVm.messages[0].input, input);
hardStopVm.reply(2); await newestAfterHardStop;
runtime.release("hard-stop");

const loadingOld = runtime.evaluate("loading", 1, "old", false, input);
const loadingNew = runtime.evaluate("loading", 2, "new", false, input);
assert.match((await loadingOld).diagnostics, /Superseded/);
await tick();
worker = workers.at(-1);
assert.equal(worker.messages[0].generation, 2, "Cancelled asset loading must not launch a stale Worker");
assert.equal(worker.messages[0].source, "new");
worker.reply(2);
await loadingNew;
runtime.release("loading");

// A separate runtime instance loads the production prewarm policy. Background
// compilation must never publish a patch or take ownership of a foreground input.
prewarmCompiler = true;
await import("../../crates/gpui_codepen/web/miri/runtime.js?prewarm");
const warmRuntime = globalThis.gpuiCodepenMiri;
async function warmSession(id) {
  const ready = warmRuntime.evaluate(id, 1, "identity A", false, input);
  await new Promise(resolve => setTimeout(resolve, 60));
  const vm = workers.at(-1);
  assert.equal(vm.messages[0].mode, "vm");
  vm.reply(1); await ready;
  await new Promise(resolve => setTimeout(resolve, 300));
  const compiler = workers.at(-1);
  assert.equal(compiler.messages[0].mode, "compiler");
  assert.equal(compiler.messages[0].source, "identity A");
  assert.equal(compiler.messages[0].identity.crate, "a");
  return { vm, compiler };
}
let warm = await warmSession("warm-ready");
warm.compiler.onmessage({ data: { kind: "compiled", generation: 1, patch: new Uint8Array([1]) } });
assert.equal(warm.vm.messages.length, 1, "Prewarming must not install MIR into the live application");
const warmEdit = warmRuntime.evaluate("warm-ready", 2, "edited identity A", false, input);
await tick();
assert.equal(workers.at(-1), warm.compiler, "The first edit must reuse the prewarmed compiler");
warm.compiler.onmessage({ data: { kind: "compiled", generation: 2, patch: new Uint8Array([2]) } });
warm.vm.onmessage({ data: { kind: "patched", generation: 2, accepted: true } });
warm.vm.reply(2); await warmEdit;
warmRuntime.release("warm-ready");

warm = await warmSession("warm-queued-success");
const obsoleteWarmEdit = warmRuntime.evaluate("warm-queued-success", 2, "obsolete warm edit", false, input);
await tick();
const newestWarmEdit = warmRuntime.evaluate("warm-queued-success", 3, "latest warm edit", false, input);
await tick();
assert.equal(warm.compiler.messages.length, 1);
warm.compiler.onmessage({ data: { kind: "compiled", generation: 1, patch: new Uint8Array([1]) } });
assert.equal(warm.vm.messages.length, 1, "Background success must not patch a queued edit with stale MIR");
assert.equal(warm.compiler.messages.length, 2);
assert.equal(warm.compiler.messages[1].generation, 3, "Warm completion must drain only the newest foreground edit");
warm.compiler.onmessage({ data: { kind: "compiled", generation: 3, patch: new Uint8Array([3]) } });
warm.vm.onmessage({ data: { kind: "patched", generation: 3, accepted: true } });
warm.vm.reply(3);
await Promise.all([obsoleteWarmEdit, newestWarmEdit]);
warmRuntime.release("warm-queued-success");

warm = await warmSession("warm-input-success");
const successfulWarmInput = warmRuntime.evaluate("warm-input-success", 2, "identity A", false, input);
await tick();
warm.compiler.onmessage({ data: { kind: "compiled", generation: 1, patch: new Uint8Array([1]) } });
assert.equal(warm.vm.messages.length, 2, "Background success must leave the pending VM input alone");
assert.equal(warm.vm.messages[1].kind, "input");
warm.vm.reply(2);
assert.equal((await successfulWarmInput).diagnostics, "");
warmRuntime.release("warm-input-success");

const originalSetTimeout = globalThis.setTimeout;
const originalClearTimeout = globalThis.clearTimeout;
let backgroundDeadline;
let cancelledBackgroundDeadline = false;
globalThis.setTimeout = (callback, delay, ...args) => {
  const handle = originalSetTimeout(callback, delay, ...args);
  if (delay === 45000) backgroundDeadline = { handle, callback };
  return handle;
};
globalThis.clearTimeout = handle => {
  if (backgroundDeadline && handle === backgroundDeadline.handle) cancelledBackgroundDeadline = true;
  return originalClearTimeout(handle);
};
try {
  for (const action of ["reply", "cancel"]) {
    backgroundDeadline = undefined;
    cancelledBackgroundDeadline = false;
    const id = `warm-input-deadline-${action}`;
    warm = await warmSession(id);
    assert(backgroundDeadline);
    const inputBeforeWarmCompletion = warmRuntime.evaluate(id, 2, "identity A", false, input);
    await tick();
    if (action === "cancel") {
      warmRuntime.cancel(id, 2);
      assert.match((await inputBeforeWarmCompletion).diagnostics, /Superseded/);
      assert.equal(cancelledBackgroundDeadline, false,
        "Cancelling a VM input must retain the independent background compiler's deadline");
      // The superseded input can drain normally without stopping either Worker.
      warm.vm.reply(2);
    } else {
      warm.vm.reply(2); await inputBeforeWarmCompletion;
    }
    assert.equal(cancelledBackgroundDeadline, false,
      "A foreground VM reply must retain the independent background compiler's deadline");
    originalClearTimeout(backgroundDeadline.handle);
    backgroundDeadline.callback();
    assert.equal(warm.compiler.terminated, true, "A stuck background compiler must still expire");
    assert.equal(warm.vm.terminated, false, "Background expiry must retain the live application");
    warmRuntime.release(id);
  }
} finally {
  globalThis.setTimeout = originalSetTimeout;
  globalThis.clearTimeout = originalClearTimeout;
}

warm = await warmSession("warm-queued");
const queuedWarmEdit = warmRuntime.evaluate("warm-queued", 2, "newest after background failure", false, input);
await tick();
assert.equal(warm.compiler.messages.length, 1, "An edit queues behind the bounded background job");
warm.compiler.onmessage({ data: { kind: "reply", generation: 1, failed: true, diagnostics: "background compiler trap" } });
const replacementWarmCompiler = workers.at(-1);
assert.equal(warm.compiler.terminated, true);
assert.equal(replacementWarmCompiler.messages[0].generation, 2);
replacementWarmCompiler.onmessage({ data: { kind: "compiled", generation: 2, patch: new Uint8Array([2]) } });
warm.vm.onmessage({ data: { kind: "patched", generation: 2, accepted: true } });
warm.vm.reply(2); await queuedWarmEdit;
warmRuntime.release("warm-queued");

warm = await warmSession("warm-input");
const duringWarmInput = warmRuntime.evaluate("warm-input", 2, "identity A", false, input);
await tick();
warm.compiler.onmessage({ data: { kind: "reply", generation: 1, failed: true, diagnostics: "background-only failure" } });
assert.equal(warm.vm.terminated, false);
warm.vm.reply(2);
assert.equal((await duringWarmInput).diagnostics, "", "Background diagnostics must not replace a foreground input");
warmRuntime.release("warm-input");
const releasedWarm = warmRuntime.evaluate("warm-released", 1, "identity A", false, input);
await tick();
const releasedWarmVm = workers.at(-1);
releasedWarmVm.reply(1); await releasedWarm;
warmRuntime.release("warm-released");
const afterRelease = workers.length;
await new Promise(resolve => setTimeout(resolve, 300));
assert.equal(workers.length, afterRelease, "Releasing the preview must cancel its pending prewarm timer");
console.log("PASS: completed/stale cancellation, ordered inputs, generation-bound deadlines, independent compilation, atomic patches, failed-edit recovery and asset-loading replacement");
console.log("PASS: idle compiler prewarming, first-edit cache reuse, queued edits, background failure isolation and release cleanup");
