import assert from "node:assert/strict";
import { copyFile, mkdtemp, rm, symlink } from "node:fs/promises";
import { tmpdir } from "node:os";
import { join } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import { gzipSync } from "node:zlib";

const directory = await mkdtemp(join(tmpdir(), "gpui-metadata-"));
try {
  await copyFile(new URL("../../crates/gpui_codepen/web/miri/metadata-files.js", import.meta.url), join(directory, "metadata-files.mjs"));
  await symlink(fileURLToPath(new URL("../../vendor/browser_wasi_shim/dist", import.meta.url)), join(directory, "wasi"), "dir");
  const { BlobMetadataFile, MetadataPageStore, PagedMetadataFile, readMetadata } = await import(pathToFileURL(join(directory, "metadata-files.mjs")));
  const { WASI } = await import("../../vendor/browser_wasi_shim/dist/index.js");
  const { ERRNO_ROFS, RIGHTS_FD_READ, RIGHTS_FD_WRITE, WHENCE_END } = await import("../../vendor/browser_wasi_shim/dist/wasi_defs.js");
  const pageSize = 64, chunkSize = pageSize * 4;
  const content = Uint8Array.from({ length: pageSize * 9 + 7 }, (_, index) => index % 251);
  const chunks = Array.from({ length: Math.ceil(content.length / chunkSize) }, (_, chunk) => `metadata-page-${chunk}.gz`);
  const entry = { path: "/deps/test.rmeta", length: content.length, chunks, bootstrap: [[0, 0, pageSize]] };
  const bootstrap = new Blob([content.subarray(0, pageSize)]);
  const manifest = { metadata_paging: { page_size: pageSize, chunk_size: chunkSize }, files: [entry] };
  const loads = [];
  let release;
  const store = new MetadataPageStore(manifest, bootstrap, content.subarray(0, pageSize), new URL("https://example.test/miri/"), async url => {
    const chunk = chunks.indexOf(url.pathname.split("/").at(-1));
    loads.push(chunk);
    if (chunk === 1) await new Promise(resolve => { release = resolve; });
    return content.slice(chunk * chunkSize, (chunk + 1) * chunkSize);
  });
  const file = new PagedMetadataFile(store, entry);
  const fd = file.path_open(0, BigInt(RIGHTS_FD_READ), 0).fd_obj;
  assert(fd);
  assert.equal(file.path_open(0, BigInt(RIGHTS_FD_WRITE), 0).fd_obj, null);
  assert.equal(fd.fd_filestat_set_size(0n), ERRNO_ROFS);
  assert.equal(fd.fd_allocate(0n, 4096n), ERRNO_ROFS);
  assert.equal(fd.prepare_read(17), undefined, "Bootstrap reads stay synchronous");
  assert.deepEqual(fd.fd_read(17).data, content.subarray(0, 17));
  assert.equal(fd.fd_pread(4, 2n).data[0], content[2]);
  assert.deepEqual(store.files.get(entry.path).pages.get(0), { offset: 0, length: pageSize },
    "Bootstrap reads retain the shared backing descriptor instead of a duplicate page allocation");
  assert.equal(fd.file_pos, 17n, "pread must not alter the sequential cursor");
  assert.equal(fd.fd_seek(-7n, WHENCE_END).offset, BigInt(content.length - 7));
  assert.equal(fd.file_pos, BigInt(content.length - 7));
  const first = file.prepare(chunkSize + 3, 77);
  const second = file.prepare(chunkSize + 50, 99);
  assert(first instanceof Promise && second instanceof Promise);
  assert.deepEqual(loads, [1], "Overlapping reads share one in-flight chunk fetch");
  assert.equal(store.files.get(entry.path).pages.has(4), false, "Missing bytes stay unpublished during fetch");
  release();
  await Promise.all([first, second]);
  assert.deepEqual(file.read(chunkSize + 3, 77), content.subarray(chunkSize + 3, chunkSize + 80));
  assert.equal(file.prepare(chunkSize + 3, 77), undefined, "Resident page reads never create a Promise");
  await file.prepare(pageSize, pageSize);
  assert.deepEqual(store.files.get(entry.path).pages.get(0), { offset: 0, length: pageSize },
    "Fetching another page in the same chunk must not replace its shared bootstrap page");

  const wasi = new WASI([], [], [fd], { debug: false });
  const memory = new WebAssembly.Memory({ initial: 1 });
  wasi.inst = { exports: { memory } };
  const view = new DataView(memory.buffer);
  view.setUint32(64, 1024, true); view.setUint32(68, 19, true);
  view.setUint32(72, 2048, true); view.setUint32(76, 23, true);
  fd.file_pos = 0n;
  assert.equal(readMetadata(wasi, "fd_read", [0, 64, 2, 80]), 0);
  assert.equal(view.getUint32(80, true), 42);
  assert.deepEqual(new Uint8Array(memory.buffer, 1024, 19), content.subarray(0, 19));
  assert.deepEqual(new Uint8Array(memory.buffer, 2048, 23), content.subarray(19, 42));
  fd.file_pos = BigInt(chunkSize * 2);
  const pending = readMetadata(wasi, "fd_read", [0, 64, 2, 80]);
  assert(pending instanceof Promise);
  memory.grow(1);
  assert.equal(await pending, 0, "Async reads reacquire the grown WASM memory");
  assert.deepEqual(new Uint8Array(memory.buffer, 1024, 19), content.subarray(chunkSize * 2, chunkSize * 2 + 19));
  assert.equal(fd.file_pos, BigInt(chunkSize * 2 + 42));
  assert.equal(readMetadata(wasi, "fd_pread", [0, 64, 2, 0n, 80]), 0);
  assert.equal(fd.file_pos, BigInt(chunkSize * 2 + 42));

  const blob = new BlobMetadataFile(new Blob([content]), "/deps/blob.rmeta", content);
  const blobFd = blob.path_open(0, BigInt(RIGHTS_FD_READ), 0).fd_obj;
  assert.deepEqual(blobFd.fd_pread(13, 7n).data, content.subarray(7, 20));
  assert.equal(blobFd.fd_seek(-3n, WHENCE_END).offset, BigInt(content.length - 3));
  assert.deepEqual(blobFd.fd_read(100).data, content.subarray(content.length - 3));
  assert.equal(blobFd.fd_read(1).data.length, 0);
  let fetches = 0, failNext = true;
  globalThis.fetch = async url => {
    fetches++;
    const chunk = chunks.indexOf(url.pathname.split("/").at(-1));
    if (failNext) { failNext = false; return new Response("unavailable", { status: 503 }); }
    return new Response(gzipSync(content.subarray(chunk * chunkSize, (chunk + 1) * chunkSize)));
  };
  globalThis.caches = { open: async () => ({ match: async () => undefined, put: () => new Promise(() => {}) }) };
  const fetched = new MetadataPageStore(manifest, bootstrap, content.subarray(0, pageSize), new URL("https://example.test/miri/"));
  const remote = new PagedMetadataFile(fetched, entry);
  await assert.rejects(remote.prepare(chunkSize, 17), /503/);
  assert.equal(fetched.files.get(entry.path).pages.has(4), false, "Failed fetches publish no partial pages");
  await remote.prepare(chunkSize, 17);
  assert.deepEqual(remote.read(chunkSize, 17), content.subarray(chunkSize, chunkSize + 17));
  assert.equal(fetches, 2, "A failed immutable fetch can retry without poisoning the page cache");
  console.log("PASS immutable metadata range reads, chunk deduplication, page publication, readonly files, seek/pread, multi-iovec JSPI reads and memory growth");
} finally { await rm(directory, { recursive: true }); }
