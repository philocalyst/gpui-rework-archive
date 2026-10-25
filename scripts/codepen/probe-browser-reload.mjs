// Production browser runtime, real full rustc/Miri Workers, and native GPUI
// reference frames. No compiler, interpreter, or rendering mocks are used.
import assert from "node:assert/strict";
import { readFile, writeFile, mkdtemp, rm, readdir, mkdir } from "node:fs/promises";
import { Worker as ThreadWorker } from "node:worker_threads";
import { pathToFileURL } from "node:url";
import { tmpdir } from "node:os";
import { join, resolve, basename } from "node:path";

const bundle = resolve(process.argv[2] || "target/codepen-browser/miri");
const documentationCounter = process.argv.includes("--documentation-counter");
const documentationStarters = process.argv.includes("--documentation-starters");
const guideLessons = process.argv.includes("--guide-lessons");
const warmOnly = process.argv.includes("--warm-only");
const prewarmBenchmark = process.argv.includes("--prewarm-benchmark");
const prewarmOverlap = process.argv.includes("--prewarm-overlap");
const redrawBenchmark = process.argv.includes("--redraw-benchmark");
const profileFrames = Number(process.env.GPUI_CODEPEN_CPU_PROFILE_FRAMES || 1);
assert(Number.isInteger(profileFrames) && profileFrames > 0 && profileFrames <= 100);
const fixture = resolve("target/codepen-browser-probe");
const artifactDirectory = resolve(process.env.GPUI_CODEPEN_ARTIFACTS || fixture);
await mkdir(artifactDirectory, { recursive: true });
const temporary = await mkdtemp(join(tmpdir(), "gpui-miri-reload-"));
const bootstrap = join(temporary, "worker.mjs");
await writeFile(bootstrap, `import { parentPort, workerData } from "node:worker_threads";
// Node adapter for production Workers fetching immutable range assets.
const nativeFetch = globalThis.fetch;
globalThis.fetch = async (url, options) => {
  const resolved = new URL(url);
  if (resolved.protocol !== "file:") return nativeFetch(url, options);
  const { readFile } = await import("node:fs/promises");
  return new Response(await readFile(resolved));
};
globalThis.onmessage = undefined;
globalThis.postMessage = (data, transfer) => parentPort.postMessage(data, transfer);
await import(workerData);
parentPort.on("message", data => globalThis.onmessage({ data }));
`);
const workers = [];
const artifacts = [];
const profiles = [];
const benchmarkTrials = [];
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
        (this.completedCompiles ||= new Set()).add(data.generation);
        timing.compiler_finished_ms = performance.now();
        timing.compile_ms = data.compile_ms;
        timing.compiler_wasm_memory_bytes = data.wasm_memory_bytes;
        timing.patch_bytes = data.patch?.byteLength || 0;
        if (data.patch && !prewarmBenchmark) artifacts.push(writeFile(join(artifactDirectory, `browser-${data.generation}.mir`), data.patch.slice()));
      } else if (data.kind === "patched") {
        timing.patch_roundtrip_ms = performance.now() - timing.patch_started;
        Object.assign(timing, data.timings);
        timing.accepted = data.accepted;
        if (data.diagnostics) timing.rejection = data.diagnostics;
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
      if (data.metadata_reads) artifacts.push(writeFile(join(artifactDirectory, `${this.mode}-${data.generation}-metadata-reads.json`),
        JSON.stringify(data.metadata_reads, null, 2) + "\n"));
      if (data.metadata_pages) artifacts.push(writeFile(join(artifactDirectory, `${this.mode}-${data.generation}-metadata-pages.txt`),
        data.metadata_pages));
      if (data.contract_map) artifacts.push(writeFile(join(artifactDirectory, `${this.mode}-${data.generation}-contract-map.txt`),
        data.contract_map));
      if (this.profile && data.kind === "reply" && --this.profileRemaining === 0) {
        const profile = this.profile;
        this.profile = undefined;
        profiles.push(profile.then(async handle => {
          const path = process.env.GPUI_CODEPEN_ARTIFACTS
            ? join(artifactDirectory, `${this.mode}-${data.generation}.cpuprofile`)
            : resolve(`target/codepen-browser-${this.mode}-${data.generation}.cpuprofile`);
          await writeFile(path, await handle.stop());
          console.log(`Saved warm Worker CPU profile: ${path}`);
        }));
      }
      this.onmessage?.({ data });
    });
    this.thread.on("error", error => this.onerror?.({ message: error.message }));
    workers.push(this);
  }
  postMessage(message, transfer) {
    (this.messages ||= []).push({ kind: message.kind, generation: message.generation });
    if (message.kind === "start") {
      this.mode = message.mode;
      if (message.mode === "vm") vmBoots++;
    }
    if (this.mode === "compiler" && ["start", "compile"].includes(message.kind)) {
      measurement(message.generation).compiler_started_ms = performance.now();
    }
    if (message.kind === "patch") measurement(message.generation).patch_started = performance.now();
    if (this.mode === "vm" && message.generation === Number(process.env.GPUI_CODEPEN_CPU_PROFILE_GENERATION)
      && ["input", "patch"].includes(message.kind) && this.thread.startCpuProfile) {
      this.profile = this.thread.startCpuProfile();
      this.profileRemaining = profileFrames;
    }
    this.thread.postMessage(message, transfer);
  }
  terminate() { return this.thread.terminate(); }
}
globalThis.Worker = BrowserWorker;
globalThis.fetch = async url => {
  const name = basename(new URL(url).pathname);
  if (name === "profile-module.wasm" && process.env.GPUI_CODEPEN_PROFILE_MODULE) {
    return new Response(await readFile(process.env.GPUI_CODEPEN_PROFILE_MODULE),
      { headers: { "Content-Type": "application/wasm" } });
  }
  const bytes = await readFile(join(bundle, name));
  if (name === "assets.json") {
    return Response.json({ ...JSON.parse(bytes),
      ...(process.env.GPUI_CODEPEN_PROFILE_MODULE ? {
        module: "profile-module.wasm", module_compression: undefined,
      } : {}),
      incremental_compiler: process.env.GPUI_CODEPEN_TEST_INCREMENTAL === "1",
      incremental_verify_ich: process.env.GPUI_CODEPEN_TEST_INCREMENTAL === "1",
      ...(process.env.GPUI_CODEPEN_TEST_PREWARM !== undefined
        ? { prewarm_compiler: process.env.GPUI_CODEPEN_TEST_PREWARM === "1" } : {}),
      profile_functions: process.env.GPUI_CODEPEN_PROFILE === "functions",
      profile_metadata: process.env.GPUI_CODEPEN_PROFILE_METADATA === "1",
      profile_contract: process.env.GPUI_CODEPEN_PROFILE_CONTRACT === "1",
      software_float: process.env.GPUI_CODEPEN_SOFT_FLOAT === "1" });
  }
  return new Response(bytes, { headers: { "Content-Type": name.endsWith(".json")
    ? "application/json" : "application/octet-stream" } });
};
await import("../../crates/gpui_codepen/web/miri/runtime.js");
const runtime = globalThis.gpuiCodepenMiri;
const source = await readFile(documentationCounter
  ? "crates/gpui_codepen/tests/fixtures/documentation_counter.rs" : join(fixture, "counter.rs"), "utf8");
const inputs = documentationCounter ? join(fixture, "documentation-counter") : fixture;
const idle = new Uint8Array(await readFile(join(inputs, "idle.input")));
const click = new Uint8Array(await readFile(join(inputs, "click.input")));
let generation = 0;
async function evaluate(source, input = idle, expected) {
  const started = performance.now();
  const sequence = ++generation;
  measurement(sequence).request_started_ms = started;
  let timeout;
  try {
    const reply = await Promise.race([
      runtime.evaluate("real-hot-reload", sequence, source, false, input),
      new Promise((_, reject) => { timeout = setTimeout(() => reject(new Error("Full browser hot reload timed out")), 120000); }),
    ]);
    measurement(sequence).total_ms = performance.now() - started;
    measurement(sequence).request_finished_ms = performance.now();
    Object.assign(measurement(sequence), reply.timings);
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
  assert(documentationStarters || guideLessons || manifest.starters.some(starter => starter.source === source && starter.packet),
    "Bundle the native counter fixture with --starter-dir target/codepen-browser-probe");
  if (documentationStarters || guideLessons) {
    const names = (await readdir(join(fixture, "cases"))).filter(name => name.startsWith(guideLessons ? "guide-" : "documentation-")).sort();
    assert.equal(names.length, guideLessons ? 5 : 12, "Every shipped starter needs native reference frames");
    for (const name of names) {
      const directory = join(fixture, "cases", name);
      const component = await readFile(join(directory, "source.rs"), "utf8");
      assert(manifest.starters.some(starter => starter.source === component && starter.packet),
        `The shipped source and initial MIR must match ${name} verbatim`);
      // Each component starts with a fresh application, just as selecting a
      // different example does. Subsequent inputs reuse that same live heap.
      runtime.release("real-hot-reload");
      const count = Number(await readFile(join(directory, "count"), "utf8"));
      for (let index = 0; index < count; index++) {
        await evaluate(component, new Uint8Array(await readFile(join(directory, `${index}.input`))),
          `cases/${name}/${index}.frame`);
      }
      console.log(`PASS shipped documentation browser/native parity: ${name}`);
    }
    passed = true;
  } else if (redrawBenchmark) {
    assert(documentationCounter, "Measure the canonical documentation counter");
    const directory = join(fixture, "cases", "redraw-counter");
    assert.equal(await readFile(join(directory, "source.rs"), "utf8"), source);
    const count = Number(await readFile(join(directory, "count"), "utf8"));
    assert.equal(count, 21);
    for (let index = 0; index < count; index++) {
      await evaluate(source, new Uint8Array(await readFile(join(directory, `${index}.input`))),
        `cases/redraw-counter/${index}.frame`);
    }
    assert.equal(vmBoots, 1);
    console.log("PASS 20 canonical redraws: every actual click matches its entire native GPUI frame");
    passed = true;
  } else if (prewarmBenchmark) {
    assert(documentationCounter, "Use the canonical documentation counter for warmup comparisons");
    const enabled = process.env.GPUI_CODEPEN_TEST_PREWARM === "1";
    assert(["0", "1"].includes(process.env.GPUI_CODEPEN_TEST_PREWARM));
    const trials = Number(process.env.GPUI_CODEPEN_BENCHMARK_TRIALS || 3);
    assert(Number.isInteger(trials) && trials >= 1 && trials <= 20);
    async function waitFor(check, description) {
      const deadline = performance.now() + 45000;
      while (!check()) {
        assert(performance.now() < deadline, description);
        await new Promise(resolve => setTimeout(resolve, 10));
      }
    }
    for (let trial = 0; trial < trials; trial++) {
      runtime.release("real-hot-reload");
      const firstGeneration = generation + 1;
      await evaluate(source, idle, "documentation-counter/initial.frame");
      let warmCompiler;
      if (enabled) {
        await waitFor(() => workers.some(worker => worker.mode === "compiler"
          && worker.messages.some(message => message.generation === firstGeneration)), "Warm compiler must actually start");
        warmCompiler = workers.findLast(worker => worker.mode === "compiler");
        if (!prewarmOverlap) await waitFor(() => warmCompiler.completedCompiles?.has(firstGeneration),
          "Warm compilation must finish before measuring the first edit");
      }
      const record = { trial: trial + 1, initial_generation: firstGeneration,
        click_generation: generation + 1,
        background_active_before_click: !!warmCompiler && !warmCompiler.completedCompiles?.has(firstGeneration) };
      const clicked = await evaluate(source, click, "documentation-counter/clicked.frame");
      const edited = source.replace("saturating_add(1)", "saturating_add(5)");
      record.edit_generation = generation + 1;
      record.background_active_before_edit = !!warmCompiler && !warmCompiler.completedCompiles?.has(firstGeneration);
      const patched = await evaluate(edited, idle, "documentation-counter/patched.frame");
      assert.deepEqual(patched.frame, clicked.frame);
      assert.equal(measurement(generation).accepted, true);
      record.updated_click_generation = generation + 1;
      await evaluate(edited, click, "documentation-counter/six.frame");
      benchmarkTrials.push(record);
      assert.equal(vmBoots, trial + 1, "Warmup and edits must preserve each application's original heap");
      console.log(`PASS prewarm benchmark trial ${trial + 1}: enabled=${enabled} overlap=${prewarmOverlap}`);
    }
    passed = true;
  } else if (documentationCounter) {
    const first = await evaluate(source, idle, "documentation-counter/initial.frame");
    const clicked = await evaluate(source, click, "documentation-counter/clicked.frame");
    assert.equal(clicked.diagnostics, "");
    assert.notDeepEqual(clicked.frame, first.frame);
    const edited = source.replace("saturating_add(1)", "saturating_add(5)");
    assert.notEqual(edited, source);
    const patched = await evaluate(edited, idle, "documentation-counter/patched.frame");
    assert.equal(patched.diagnostics, "");
    assert.equal(measurement(generation).accepted, true,
      "A helper-method body edit must install into the original Miri heap");
    assert.deepEqual(patched.frame, clicked.frame, "Editing the canonical helper must retain its rendered state");
    const next = await evaluate(edited, click, "documentation-counter/six.frame");
    assert.equal(next.diagnostics, "");
    assert.notDeepEqual(next.frame, patched.frame);
    assert.equal(vmBoots, 1);
    if (warmOnly) {
      for (let frame = 0; frame < 20; frame++) {
        await evaluate(edited, idle, "documentation-counter/six.frame");
      }
    }
    const localEdit = await readFile(join(fixture, "documentation-counter/local-edit.rs"), "utf8");
    await evaluate(localEdit, idle, "documentation-counter/six.frame");
    assert.equal(measurement(generation).accepted, true, "New helper locals require a new body-specific layout cache");
    await evaluate(localEdit, click, "documentation-counter/eleven.frame");
    assert.equal(vmBoots, 1);
    console.log("PASS canonical documentation counter: saturating_add helper edit preserves the live entity and installs new Rust");
    passed = true;
  } else {
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
  const compiler = workers.findLast(worker => worker.mode === "compiler");
  const obsoleteGeneration = ++generation;
  const obsoleteCompile = runtime.evaluate("real-hot-reload", obsoleteGeneration, color + "\n// obsolete real compile\n", false, idle);
  const dispatchDeadline = performance.now() + 1000;
  while (!compiler.messages.some(message => message.generation === obsoleteGeneration)) {
    assert(performance.now() < dispatchDeadline, "The obsolete compiler session must actually start before coalescing");
    await new Promise(resolve => setTimeout(resolve, 1));
  }
  const skippedGeneration = ++generation;
  const skippedCompile = runtime.evaluate("real-hot-reload", skippedGeneration, color + "\n// skipped intermediate source\n", false, idle);
  const coalesced = evaluate(color + "\n// newest coalesced source\n", idle, "recolored.frame");
  assert.match((await obsoleteCompile).diagnostics, /Superseded/);
  assert.match((await skippedCompile).diagnostics, /Superseded/);
  await coalesced;
  assert.equal(workers.filter(worker => worker.mode === "compiler").length, 1,
    "Rapid edits must reuse the actual rustc incremental Worker");
  assert(!compiler.messages.some(message => message.generation === skippedGeneration),
    "The intermediate source must never enter rustc");
  assert.equal(vmBoots, 1);
  for (const name of ["async", "animation", "ime", "layouts", "actions"]) {
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
  }
} finally {
  runtime.release("real-hot-reload");
  await Promise.all(artifacts);
  await Promise.all(profiles);
  await Promise.all(workers.map(worker => worker.terminate()));
  if (process.env.GPUI_CODEPEN_MEASUREMENTS) {
    await writeFile(process.env.GPUI_CODEPEN_MEASUREMENTS, JSON.stringify({ passed, vmBoots,
      incremental_compiler: process.env.GPUI_CODEPEN_TEST_INCREMENTAL === "1",
      ...(prewarmBenchmark ? { prewarm_compiler: process.env.GPUI_CODEPEN_TEST_PREWARM === "1",
        prewarm_overlap: prewarmOverlap, benchmark_trials: benchmarkTrials } : {}),
      generations: Object.fromEntries([...measurements].map(([generation, timing]) => {
        const { patch_started, ...record } = timing;
        return [generation, record];
      })),
    }, null, 2) + "\n");
  }
  await rm(temporary, { recursive: true });
}
