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
    metadata: "metadata-sdk.gz", metadata_parts: ["metadata-sdk.gz", "metadata-starter.gz"] });
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
assert.equal(compiler.terminated, true, "Obsolete compilation must stop independently");
assert.equal(worker.terminated, false, "Cancelling compilation must keep the live preview");
const newest = runtime.evaluate("hot", 6, "newest source", false, input);
await tick();
const newestCompiler = workers.at(-1);
compiler.onmessage({ data: { kind: "compiled", generation: 5, patch: new Uint8Array([5]) } });
assert.notEqual(worker.messages.at(-1).generation, 5, "A stale compiler must never patch the resident VM");
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
console.log("PASS: completed/stale cancellation, ordered inputs, generation-bound deadlines, independent compilation, atomic patches, failed-edit recovery and asset-loading replacement");
