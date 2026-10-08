// Real Preview 1 layouts used by the rustc/Miri Worker and mio's clock poll.
import assert from "node:assert/strict";
import { WASI } from "../../vendor/browser_wasi_shim/dist/index.js";
import { Filestat, Subscription } from "../../vendor/browser_wasi_shim/dist/wasi_defs.js";
import { copyFile, mkdtemp, rm, symlink } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";

const wasi = new WASI([], [], [], { debug: false });
const memory = new WebAssembly.Memory({ initial: 1 });
wasi.inst = { exports: { memory } };
const view = new DataView(memory.buffer);
const subscription = 64, event = 128, count = 192;
view.setBigUint64(subscription, 0x123456789abcdef0n, true);
view.setUint8(subscription + 8, 0); // eventtype::clock
view.setUint32(subscription + 16, 1, true); // clockid::monotonic
view.setBigUint64(subscription + 24, 1n, true); // absolute deadline in the past
view.setBigUint64(subscription + 32, 0n, true); // precision must not supply flags
view.setUint16(subscription + 40, 1, true); // subclockflags::abstime
assert.equal(Subscription.read_bytes(view, subscription).flags, 1);
view.setUint32(count, 0xdeadbeef, true);
assert.equal(wasi.wasiImport.poll_oneoff(subscription, event, 1, count), 0);
assert.equal(view.getUint32(count, true), 1, "poll must initialize the event count");
assert.equal(view.getBigUint64(event, true), 0x123456789abcdef0n);
assert.equal(view.getUint16(event + 8, true), 0);
assert.equal(view.getUint8(event + 10), 0);
assert.equal(wasi.wasiImport.poll_oneoff(subscription, event, 0, count), 28);
const stat = new Filestat(0x0102030405060708n, 4, 0x1122334455667788n);
stat.atim = 0x2233445566778899n;
stat.mtim = 0x33445566778899aan;
stat.ctim = 0x445566778899aabbn;
stat.write_bytes(view, 256);
assert.equal(view.getBigUint64(256 + 32, true), stat.size);
assert.equal(view.getBigUint64(256 + 40, true), stat.atim);
assert.equal(view.getBigUint64(256 + 48, true), stat.mtim);
assert.equal(view.getBigUint64(256 + 56, true), stat.ctim);
const directory = await mkdtemp(join(tmpdir(), "gpui-wasi-clock-"));
try {
  await copyFile(new URL("../../crates/gpui_codepen/web/miri/wasi-clock.js", import.meta.url), join(directory, "wasi-clock.mjs"));
  await symlink(fileURLToPath(new URL("../../vendor/browser_wasi_shim/dist", import.meta.url)), join(directory, "wasi"), "dir");
  const { pollClock } = await import(pathToFileURL(join(directory, "wasi-clock.mjs")));
  assert.equal(pollClock(wasi, subscription, event, 1, count), 0, "Expired clock polls must stay synchronous");
  view.setBigUint64(subscription + 24, 25_000_000n, true);
  view.setUint16(subscription + 40, 0, true); // relative deadline
  view.setUint32(count, 0xdeadbeef, true);
  let delivered = false;
  const waiting = pollClock(wasi, subscription, event, 1, count);
  assert(waiting instanceof Promise);
  setTimeout(() => { delivered = true; memory.grow(1); }, 0);
  assert.equal(await waiting, 0);
  assert(delivered, "Clock sleep must let the Worker receive messages before completing");
  const after = new DataView(memory.buffer);
  assert.equal(after.getUint32(count, true), 1, "The async poll must reacquire grown memory");
  assert.equal(after.getBigUint64(event, true), 0x123456789abcdef0n);
  assert.equal(after.getBigUint64(subscription + 24, true), 25_000_000n, "Polling must not mutate the subscription");
  assert.equal(after.getUint16(subscription + 40, true), 0);
} finally {
  await rm(directory, { recursive: true });
}
console.log("PASS WASI clock-subscription, event-count, file-stat ABI and asynchronous clock suspension");
