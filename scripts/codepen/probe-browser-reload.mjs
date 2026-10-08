// Production browser runtime, real full rustc/Miri Workers, and native GPUI
// reference frames. No compiler, interpreter, or rendering mocks are used.
import assert from "node:assert/strict";
import { readFile, writeFile, mkdtemp, rm } from "node:fs/promises";
import { Worker as ThreadWorker } from "node:worker_threads";
import { pathToFileURL } from "node:url";
import { tmpdir } from "node:os";
import { join, resolve, basename } from "node:path";

const bundle = resolve(process.argv[2] || "target/codepen-browser/miri");
const fixture = resolve("target/codepen-browser-probe");
const temporary = await mkdtemp(join(tmpdir(), "gpui-miri-reload-"));
const bootstrap = join(temporary, "worker.mjs");
await writeFile(bootstrap, `import { parentPort, workerData } from "node:worker_threads";
globalThis.onmessage = undefined;
globalThis.postMessage = (data, transfer) => parentPort.postMessage(data, transfer);
await import(workerData);
parentPort.on("message", data => globalThis.onmessage({ data }));
`);
const workers = [];
const artifacts = [];
const measurements = new Map();
function measurement(generation) {
  if (!measurements.has(generation)) measurements.set(generation, {});
  return measurements.get(generation);
}
let vmBoots = 0;
let passed = false;
class BrowserWorker {
  constructor() {
    this.thread = new ThreadWorker(pathToFileURL(bootstrap), {
      workerData: pathToFileURL(join(bundle, "worker.js")).href,
    });
    this.previousCpu = Promise.resolve({ user: 0, system: 0 });
    this.thread.on("message", data => {
      const timing = measurement(data.generation);
      if (data.kind === "compiled") {
        timing.compile_ms = data.compile_ms;
        timing.patch_bytes = data.patch?.byteLength || 0;
        if (data.patch) artifacts.push(writeFile(join(fixture, `browser-${data.generation}.mir`), data.patch.slice()));
      } else if (data.kind === "patched") {
        timing.patch_roundtrip_ms = performance.now() - timing.patch_started;
        Object.assign(timing, data.timings);
        timing.accepted = data.accepted;
      } else if (data.kind === "startup") {
        timing[`${this.mode}_${data.phase}_ms`] = data.elapsed_ms;
      } else if (data.kind === "reply" && data.timings) {
        Object.assign(timing, data.timings);
      }
      if ((data.kind === "compiled" || data.kind === "reply") && this.thread.cpuUsage) {
        const previous = this.previousCpu;
        const current = this.thread.cpuUsage();
        this.previousCpu = current.catch(() => previous);
        artifacts.push(Promise.all([previous, current]).then(([before, after]) => {
          timing[`${this.mode}_cpu_ms`] =
            (after.user + after.system - before.user - before.system) / 1000;
        }).catch(() => { timing.cpu_unavailable = true; }));
      }
      if (data.profile) console.log(`Guest MIR profile, generation ${data.generation}:\n${data.profile}`);
      this.onmessage?.({ data });
    });
    this.thread.on("error", error => this.onerror?.({ message: error.message }));
    workers.push(this);
  }
  postMessage(message, transfer) {
    if (message.kind === "start") {
      this.mode = message.mode;
      if (message.mode === "vm") vmBoots++;
    }
    if (message.kind === "patch") measurement(message.generation).patch_started = performance.now();
    this.thread.postMessage(message, transfer);
  }
  terminate() { return this.thread.terminate(); }
}
globalThis.Worker = BrowserWorker;
globalThis.fetch = async url => {
  const name = basename(new URL(url).pathname);
  const bytes = await readFile(join(bundle, name));
  if (name === "assets.json") {
    return Response.json({ ...JSON.parse(bytes),
      incremental_compiler: process.env.GPUI_CODEPEN_TEST_INCREMENTAL === "1",
      profile_functions: process.env.GPUI_CODEPEN_PROFILE === "functions",
      software_float: process.env.GPUI_CODEPEN_SOFT_FLOAT === "1" });
  }
  return new Response(bytes, { headers: { "Content-Type": name.endsWith(".json")
    ? "application/json" : "application/octet-stream" } });
};
await import("../../crates/gpui_codepen/web/miri/runtime.js");
const runtime = globalThis.gpuiCodepenMiri;
const source = await readFile(join(fixture, "counter.rs"), "utf8");
const idle = new Uint8Array(await readFile(join(fixture, "idle.input")));
const click = new Uint8Array(await readFile(join(fixture, "click.input")));
let generation = 0;
async function evaluate(source, input = idle, expected) {
  const started = performance.now();
  const sequence = ++generation;
  let timeout;
  try {
    const reply = await Promise.race([
      runtime.evaluate("real-hot-reload", sequence, source, false, input),
      new Promise((_, reject) => { timeout = setTimeout(() => reject(new Error("Full browser hot reload timed out")), 120000); }),
    ]);
    measurement(sequence).total_ms = performance.now() - started;
    measurement(sequence).frame_bytes = reply.frame?.byteLength || 0;
    const timing = { ...measurement(sequence) };
    delete timing.patch_started;
    for (const key of Object.keys(timing)) {
      if (key.endsWith("_ms")) timing[key] = Math.round(timing[key]);
    }
    console.log(`Browser generation ${sequence}: ${Math.round(performance.now() - started)} ms; ${reply.frame?.byteLength || 0} bytes; ${JSON.stringify(timing)}`);
    if (expected) {
      assert.equal(reply.diagnostics, "", reply.diagnostics);
      assert.deepEqual(reply.frame, new Uint8Array(await readFile(join(fixture, expected))),
        `Browser generation ${sequence} must match the entire native GPUI frame`);
    }
    return reply;
  } finally { clearTimeout(timeout); }
}
try {
  const manifest = JSON.parse(await readFile(join(bundle, "assets.json"), "utf8"));
  assert(manifest.starters.some(starter => starter.source === source && starter.packet),
    "Bundle the native counter fixture with --starter-dir target/codepen-browser-probe");
  await evaluate(source, idle, "initial.frame");
  await evaluate(source, click, "clicked.frame");
  const edited = source.replace("this.count+=1", "this.count+=5");
  await evaluate(edited, idle, "patched.frame");
  await evaluate(edited, click, "six.frame");
  const broken = await evaluate("fn component(é");
  assert.match(broken.diagnostics, /error/);
  assert(broken.diagnostics.includes("é"));
  await evaluate(edited, idle, "six.frame");
  const color = edited.replace("0x100000", "0x200000");
  await evaluate(color, idle, "recolored.frame");
  assert.equal(vmBoots, 1, "Every compatible edit must retain the original Miri heap and GPUI entities");
  assert.equal(workers.filter(worker => worker.mode === "compiler").length, 1,
    "Successive compiler sessions must reuse their Worker without a registry ICE");
  const obsolete = runtime.evaluate("real-hot-reload", ++generation, "fn component(obsolete", false, idle);
  const newest = evaluate(color, idle, "recolored.frame");
  assert.match((await obsolete).diagnostics, /Superseded/);
  await newest;
  assert.equal(vmBoots, 1, "Cancelling stale compilation must retain the live interpreter");
  for (const name of ["async", "animation", "ime", "layouts"]) {
    const directory = join(fixture, "cases", name);
    const component = await readFile(join(directory, "source.rs"), "utf8");
    const count = Number(await readFile(join(directory, "count"), "utf8"));
    for (let index = 0; index < count; index++) {
      await evaluate(component, new Uint8Array(await readFile(join(directory, `${index}.input`))),
        `cases/${name}/${index}.frame`);
    }
    console.log(`PASS full browser/native frame parity: ${name}`);
  }
  console.log("PASS full browser rustc/Miri: bundled starter MIR, state-preserving handler/render patches, exact native scene parity, Unicode diagnostics, compiler reuse and stale-edit cancellation");
  passed = true;
} finally {
  runtime.release("real-hot-reload");
  await Promise.all(artifacts);
  await Promise.all(workers.map(worker => worker.terminate()));
  if (process.env.GPUI_CODEPEN_MEASUREMENTS) {
    await writeFile(process.env.GPUI_CODEPEN_MEASUREMENTS, JSON.stringify({ passed, vmBoots,
      incremental_compiler: process.env.GPUI_CODEPEN_TEST_INCREMENTAL === "1",
      generations: Object.fromEntries([...measurements].map(([generation, timing]) => {
        const { patch_started, ...record } = timing;
        return [generation, record];
      })),
    }, null, 2) + "\n");
  }
  await rm(temporary, { recursive: true });
}
