// A reusable browser compiler thread must not retain arena-keyed hashes from
// earlier rustc sessions. Exercise green-query replay and recovery with ICH
// verification forced on every query, using the production JSPI Worker.
import assert from "node:assert/strict";
import { readFile, writeFile, mkdtemp, rm } from "node:fs/promises";
import { Worker } from "node:worker_threads";
import { pathToFileURL } from "node:url";
import { tmpdir } from "node:os";
import { basename, join, resolve } from "node:path";

const bundle = resolve(process.argv[2] || "target/codepen-browser/miri");
const manifest = JSON.parse(await readFile(join(bundle, "assets.json"), "utf8"));
manifest.incremental_compiler = true;
manifest.incremental_verify_ich = true;
const source = await readFile("target/codepen-browser-probe/counter.rs", "utf8");
const identity = manifest.starters.find(starter => starter.source === source);
assert(identity, "Bundle the native counter fixture before testing incremental compilation");
async function expanded(name, gzip) {
  const blob = new Blob([await readFile(join(bundle, name))]);
  return gzip ? new Response(blob.stream().pipeThrough(new DecompressionStream("gzip"))).blob() : blob;
}
const [module, metadata] = await Promise.all([
  expanded(manifest.module, manifest.module_compression === "gzip")
    .then(blob => blob.arrayBuffer()).then(bytes => WebAssembly.compile(bytes)),
  Promise.all((manifest.metadata_parts || [manifest.metadata]).map(part => expanded(part, true)))
    .then(parts => new Blob(parts)),
]);
const temporary = await mkdtemp(join(tmpdir(), "gpui-miri-incremental-"));
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
const worker = new Worker(pathToFileURL(bootstrap), {
  workerData: pathToFileURL(join(bundle, "worker.js")).href,
});
let generation = 0;
let pending;
worker.on("message", message => {
  if (!pending || message.generation !== pending.generation) return;
  if (message.kind === "compiled" || message.kind === "reply" && message.failed) {
    clearTimeout(pending.timeout);
    pending.resolve(message);
    pending = undefined;
  }
});
worker.on("error", error => {
  if (pending) { clearTimeout(pending.timeout); pending.reject(error); pending = undefined; }
});
async function compile(component, invalid = false) {
  const sequence = ++generation;
  const started = performance.now();
  const result = new Promise((resolve, reject) => {
    pending = { generation: sequence, resolve, reject,
      timeout: setTimeout(() => reject(new Error(`Compiler session ${sequence} timed out`)), 120000) };
  });
  worker.postMessage(sequence === 1 ? { kind: "start", mode: "compiler", generation: sequence,
    source: component, manifest, module, metadata, identity }
    : { kind: "compile", generation: sequence, source: component });
  const reply = await result;
  console.log(`Incremental session ${sequence}: ${Math.round(performance.now() - started)} ms; ${reply.patch?.byteLength || 0} MIR bytes`);
  assert.doesNotMatch(reply.diagnostics || "", /unstable fingerprints|internal compiler error|compiler unexpectedly panicked/i);
  if (invalid) assert.match(reply.diagnostics || "", /error/);
  else {
    assert.equal(reply.diagnostics || "", "");
    assert(reply.patch?.byteLength > 0, "Successful compilation must export actual MIR");
  }
}
try {
  await compile(source);
  await compile(source); // Identical source and green-query replay.
  const edited = source.replace("this.count+=1", "this.count+=5");
  assert.notEqual(edited, source);
  await compile(edited);
  await compile("fn component(é", true);
  await compile(edited);
  const color = edited.replace("0x100000", "0x200000");
  assert.notEqual(color, edited);
  await compile(color);
  for (let cycle = 0; cycle < 4; cycle++) {
    const next = (cycle % 2 ? color : edited) + `\n// Incremental arena reuse ${cycle}\n`;
    await compile(next);
    await compile(next);
  }
  console.log(`PASS ${generation} compiler sessions in one browser Worker, shared incremental directory, forced ICH verification and syntax-error recovery (${basename(bundle)})`);
} finally {
  if (pending) clearTimeout(pending.timeout);
  await worker.terminate();
  await rm(temporary, { recursive: true });
}
