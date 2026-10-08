// Runs the production JSPI Worker against the bundled full Rust compiler/Miri.
// Node's Worker adapter changes only message plumbing; WASI, compilation,
// procedural macros, GPUI execution and scene bytes use production code.
import assert from "node:assert/strict";
import { readFile, writeFile, mkdtemp, rm } from "node:fs/promises";
import { Worker as ThreadWorker } from "node:worker_threads";
import { pathToFileURL, fileURLToPath } from "node:url";
import { tmpdir } from "node:os";
import { join, resolve } from "node:path";

const bundle = resolve(process.argv[2] || "target/codepen-browser/miri");
assert.equal(typeof WebAssembly.Suspending, "function", "Use Node with WebAssembly Promise Integration");
const manifest = JSON.parse(await readFile(join(bundle, "assets.json"), "utf8"));
const bootstrapOnly = process.argv.includes("--bootstrap-only");
if (bootstrapOnly) manifest.args = manifest.args.filter(arg => !arg.startsWith("-Cincremental="));
const profileModule = process.env.GPUI_CODEPEN_PROFILE_MODULE;
let moduleBytes = new Blob([await readFile(profileModule || join(bundle, manifest.module))]);
if (!profileModule && manifest.module_compression === "gzip") {
  moduleBytes = await new Response(moduleBytes.stream().pipeThrough(new DecompressionStream("gzip"))).blob();
}
const module = await WebAssembly.compile(await moduleBytes.arrayBuffer());
console.log("Full Miri WASM imports:", WebAssembly.Module.imports(module).map(i => `${i.module}.${i.name}`).join(", "));
const metadata = new Blob(await Promise.all((manifest.metadata_parts || [manifest.metadata]).map(async part => {
  const compressed = new Blob([await readFile(join(bundle, part))]);
  return new Response(compressed.stream().pipeThrough(new DecompressionStream("gzip"))).blob();
})));
const temporary = await mkdtemp(join(tmpdir(), "gpui-miri-worker-"));
const bootstrap = join(temporary, "worker.mjs");
await writeFile(bootstrap, `import { parentPort, workerData } from "node:worker_threads";
globalThis.onmessage = undefined;
globalThis.postMessage = (data, transfer) => parentPort.postMessage(data, transfer);
parentPort.postMessage({kind: "startup", phase: "adapter"});
await import(workerData);
parentPort.postMessage({kind: "startup", phase: "imported"});
parentPort.on("message", data => globalThis.onmessage({ data }));
`);

function input(elapsed = 16) {
  const bytes = new Uint8Array(34);
  const view = new DataView(bytes.buffer);
  view.setFloat32(0, 400, true);
  view.setFloat32(4, 300, true);
  view.setFloat32(8, 1, true);
  view.setBigUint64(20, BigInt(elapsed), true);
  return bytes;
}
const source = `use gpui::{*, prelude::*};
#[derive(IntoElement)]
struct Card { color: u32 }
impl RenderOnce for Card {
 fn render(self, _: &mut Window, _: &mut App) -> impl IntoElement {
  div().size_full().bg(rgb(self.color)).child("Real Rust GPUI Aé😀")
 }
}
struct View { renders: u32 }
impl Render for View {
 fn render(&mut self, window: &mut Window, _: &mut Context<Self>) -> impl IntoElement {
  self.renders += 1;
  if self.renders < 3 { window.request_animation_frame(); }
  Card { color: 0x100000 + self.renders }
 }
}
fn component(_: &mut Window, cx: &mut App) -> Entity<View> { cx.new(|_| View { renders: 0 }) }
`;
let generation = 0;
let worker;
let pending;
const profiles = [];
const observations = new Set();
const observationTimeouts = new Set();
function observe(kind, generation, phase) {
  return new Promise((resolve, reject) => {
    const observer = message => {
      if (message.kind !== kind || message.generation !== generation || phase !== undefined && message.phase !== phase) return;
      clearTimeout(timeout);
      observationTimeouts.delete(timeout);
      observations.delete(observer);
      resolve(message);
    };
    const timeout = setTimeout(() => {
      observationTimeouts.delete(timeout);
      observations.delete(observer);
      reject(new Error(`Worker did not send ${kind} for generation ${generation}`));
    }, kind === "cancelled" ? 2000 : 120_000);
    observations.add(observer);
    observationTimeouts.add(timeout);
  });
}
function create() {
  const started = performance.now();
  worker = new ThreadWorker(pathToFileURL(bootstrap), { workerData: pathToFileURL(join(bundle, "worker.js")).href });
  worker.on("message", message => {
    if (message.kind === "phase" || message.kind === "startup") console.log(`Worker ${message.kind} ${message.phase}, generation ${message.generation}: ${Math.round(performance.now() - started)} ms`);
    for (const observer of observations) observer(message);
    if (message.kind === "phase" && message.phase === 1 && pending
      && message.generation === Number(process.env.GPUI_CODEPEN_CPU_PROFILE_GENERATION)) {
      pending.profile = worker.startCpuProfile();
    }
    if (message.kind !== "reply" || !pending || message.generation !== pending.generation) return;
    const active = pending;
    pending = undefined;
    if (active.profile) profiles.push(active.profile.then(async profile => {
      const path = resolve(`target/codepen-browser-${active.generation}.cpuprofile`);
      await writeFile(path, await profile.stop());
      console.log(`Saved execution CPU profile: ${path}`);
    }));
    clearTimeout(active.timeout);
    active.resolve(message);
  });
  worker.on("error", error => {
    if (!pending) return;
    clearTimeout(pending.timeout);
    pending.reject(error);
    pending = undefined;
  });
}
function send(start, component = source) {
  const sequence = ++generation;
  const started = performance.now();
  return new Promise((resolveReply, reject) => {
    pending = { generation: sequence, resolve: message => {
      console.log(`WASM GPUI frame ${sequence}: ${Math.round(performance.now() - started)} ms, ${message.frame?.byteLength || 0} bytes`);
      if (message.timings) console.log("  Compiler/GPUI execution:", message.timings);
      resolveReply(message);
    }, reject, timeout: setTimeout(() => reject(new Error("Full browser Miri request timed out")), 120_000) };
    const bytes = input();
    worker.postMessage(start === "reload" ? { kind: "reload", generation: sequence, source: component, input: bytes }
      : start ? { kind: "start", generation: sequence, source: component, manifest, module, metadata, input: bytes }
      : { kind: "input", generation: sequence, input: bytes }, [bytes.buffer]);
  });
}
function valid(reply) {
  assert.equal(reply.diagnostics, "", reply.diagnostics);
  assert(reply.frame instanceof Uint8Array);
  assert.equal(new DataView(reply.frame.buffer, reply.frame.byteOffset).getUint32(0, true), manifest.protocol);
}
try {
  create();
  const initial = manifest.starters?.[0];
  assert(initial, "The production bundle must ship initial component MIR");
  const precompiled = await send(true, initial.source);
  valid(precompiled);
  // A trailing newline is a different cache identity but the same Rust
  // program. This checks the shipped metadata against ordinary compilation.
  // The starter's baseline is bound to its immutable rmeta. A fresh ordinary
  // source gets a fresh VM; subsequent source reloads exercise registry reuse.
  await worker.terminate();
  create();
  const compiled = await send(true, initial.source + "\n");
  valid(compiled);
  assert.deepEqual(compiled.frame, precompiled.frame, "Shipped initial MIR must produce the same GPUI scene as fresh Rust");
  const first = await send("reload");
  valid(first);
  const second = await send(false);
  valid(second);
  assert.notDeepEqual(first.frame, second.frame, "Actual GPUI entity state must persist across inputs");
  const ignored = observe("cancel_ignored", generation - 1);
  worker.postMessage({ kind: "cancel", generation: generation - 1 });
  await ignored;
  const third = await send(false);
  valid(third);
  assert.notDeepEqual(second.frame, third.frame);
  const idle = await send(false);
  valid(idle);
  assert.deepEqual(third.frame, idle.frame, "Idle frames must preserve the completed scene and state");
  const reloaded = await send("reload", source.replace("0x100000", "0x200000"));
  valid(reloaded);
  assert.notDeepEqual(reloaded.frame, first.frame, "Reload must execute the edited render body in the same Worker");
  valid(await send("reload", source));
  if (bootstrapOnly) {
    console.log("PASS: first full WASM compiler/Miri module, actual GPUI scenes and resident reload; error recovery and incremental caching require the unwind build");
  } else {
  const broken = await send("reload", "fn component(é");
  assert.equal(broken.failed, true);
  assert.equal(broken.recoverable, true);
  assert(broken.diagnostics.includes("error"));
  assert(broken.diagnostics.includes("é"), "Non-ASCII compiler diagnostics must survive streaming WASI output");
  valid(await send("reload", source));
  const panicking = await send("reload", source.replace("self.renders += 1;", 'panic!("interpreted GPUI failure");'));
  assert.equal(panicking.failed, true);
  assert.equal(panicking.recoverable, true);
  assert(panicking.diagnostics.includes("interpreted GPUI failure"));
  valid(await send("reload", source));
  const spinningGeneration = generation + 1;
  // Ready follows compiler/Miri initialization. This measures interruption of
  // executing Rust; compilation is separately bounded by the runtime fallback.
  const executing = observe("ready", spinningGeneration);
  const spinning = send("reload", source.replace("self.renders += 1;", "loop { std::hint::black_box(0u32); }"));
  await executing;
  const cancelled = observe("cancelled", spinningGeneration);
  const cancelStarted = performance.now();
  worker.postMessage({ kind: "cancel", generation: spinningGeneration });
  await cancelled;
  console.log(`Infinite Rust cancellation: ${Math.round(performance.now() - cancelStarted)} ms`);
  const stopped = await spinning;
  assert.equal(stopped.recoverable, true, "Cancelled Miri must return through compiler cleanup");
  valid(await send("reload", source));
  console.log("PASS: full WASM rustc/Miri, actual GPUI derive/Render/RenderOnce/text, resident input state, idle frames, resident compiler reload, diagnostics and recovery");
  }
} finally {
  if (pending) clearTimeout(pending.timeout);
  for (const timeout of observationTimeouts) clearTimeout(timeout);
  await worker?.terminate();
  await Promise.all(profiles);
  await rm(temporary, { recursive: true });
}
