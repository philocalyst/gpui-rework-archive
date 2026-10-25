// Immutable WASI files. Byte ranges are initialized before rustc borrows them;
// cold page fetches suspend only the Worker through JSPI's fd_read import.
import { File } from "./wasi/index.js";
import { ERRNO_INVAL, ERRNO_ROFS, WHENCE_SET, WHENCE_CUR, WHENCE_END } from "./wasi/wasi_defs.js";

function range(position, size, length) {
  if (position < 0n || !Number.isSafeInteger(size) || size < 0) throw new Error("Invalid metadata read range");
  if (position >= BigInt(length)) return [length, 0];
  const start = Number(position);
  return [start, Math.min(size, length - start)];
}

class RangeFile extends File {
  constructor(length) { super(new ArrayBuffer(0), { readonly: true }); this.length = length; }
  get size() { return BigInt(this.length); }
  get data() { throw new Error("Metadata must be read by immutable byte range"); }
  set data(bytes) { if (bytes.byteLength) throw new Error("Immutable metadata cannot be overwritten"); }
  path_open(...args) {
    const result = super.path_open(...args);
    const file = result.fd_obj;
    if (!file) return result;
    file.fd_read = size => {
      const [start, length] = range(file.file_pos, size, this.length);
      const data = this.read(start, length);
      file.file_pos += BigInt(data.length);
      return { ret: 0, data };
    };
    file.fd_pread = (size, offset) => {
      const [start, length] = range(offset, size, this.length);
      return { ret: 0, data: this.read(start, length) };
    };
    file.prepare_read = (size, offset = file.file_pos) => {
      const [start, length] = range(offset, size, this.length);
      return this.prepare?.(start, length);
    };
    file.fd_seek = (offset, whence) => {
      let position;
      if (whence === WHENCE_SET) position = offset;
      else if (whence === WHENCE_CUR) position = file.file_pos + offset;
      else if (whence === WHENCE_END) position = this.size + offset;
      else return { ret: ERRNO_INVAL, offset: 0n };
      if (position < 0n) return { ret: ERRNO_INVAL, offset: 0n };
      file.file_pos = position;
      return { ret: 0, offset: position };
    };
    file.fd_allocate = file.fd_filestat_set_size = () => ERRNO_ROFS;
    return result;
  }
}

export class BlobMetadataFile extends RangeFile {
  constructor(blob, path, bytes, record) {
    super(blob.size);
    this.blob = blob; this.path = path; this.bytes = bytes; this.record = record;
  }
  read(start, length) {
    this.record?.(this.path, length);
    return this.bytes ? this.bytes.subarray(start, start + length)
      : new Uint8Array(new FileReaderSync().readAsArrayBuffer(this.blob.slice(start, start + length)));
  }
}

async function fetchChunk(url) {
  const cache = await globalThis.caches?.open("gpui-miri-v1").catch(() => undefined);
  let response = await cache?.match(url);
  if (!response) {
    response = await fetch(url);
    if (!response.ok) throw new Error(`Could not load Rust metadata: ${response.status} ${url.pathname}`);
    if (cache) void cache.put(url, response.clone()).catch(() => {});
  }
  return new Uint8Array(await new Response(response.body.pipeThrough(new DecompressionStream("gzip"))).arrayBuffer());
}

export class MetadataPageStore {
  constructor(manifest, bootstrap, bytes, base = new URL("./", import.meta.url), loader = fetchChunk) {
    this.pageSize = manifest.metadata_paging.page_size;
    this.chunkSize = manifest.metadata_paging.chunk_size;
    if (!Number.isSafeInteger(this.pageSize) || this.pageSize <= 0
      || !Number.isSafeInteger(this.chunkSize) || this.chunkSize < this.pageSize || this.chunkSize % this.pageSize) {
      throw new Error("Invalid metadata page/chunk alignment");
    }
    this.bootstrap = bootstrap; this.bytes = bytes; this.base = base; this.loader = loader;
    this.loading = new Map(); this.resident = new Map();
    this.files = new Map(manifest.files.map(entry => [entry.path, {
      entry, pages: new Map((entry.bootstrap || []).map(([page, offset, length]) => [page, { offset, length }])),
    }]));
  }
  page(file, page) {
    const value = file.pages.get(page);
    if (value instanceof Uint8Array) return value;
    if (!value) throw new Error(`Metadata page was read before initialization: ${file.entry.path}:${page}`);
    const bytes = this.bytes ? this.bytes.subarray(value.offset, value.offset + value.length)
      : new Uint8Array(new FileReaderSync().readAsArrayBuffer(this.bootstrap.slice(value.offset, value.offset + value.length)));
    // Rust retains each initialized page. Keep the shared Blob descriptor here
    // instead of retaining a second FileReaderSync allocation for its lifetime.
    return bytes;
  }
  ensure(file, start, length) {
    if (!length) return;
    const missing = new Set();
    for (let page = Math.floor(start / this.pageSize); page <= Math.floor((start + length - 1) / this.pageSize); page++) {
      if (!file.pages.has(page)) missing.add(Math.floor(page * this.pageSize / this.chunkSize));
    }
    if (!missing.size) return;
    return Promise.all([...missing].map(chunk => {
      const asset = file.entry.chunks[chunk];
      if (!asset) throw new Error("Metadata chunk is missing from the manifest");
      let loading = this.loading.get(asset);
      if (!loading) {
        loading = (this.resident.has(asset) ? Promise.resolve(this.resident.get(asset))
          : this.loader(new URL(asset, this.base))).then(bytes => {
            const expected = Math.min(this.chunkSize, file.entry.length - chunk * this.chunkSize);
            if (bytes.byteLength !== expected) throw new Error(`Metadata chunk length differs: ${asset}`);
            this.resident.set(asset, bytes);
            return bytes;
          }).finally(() => this.loading.delete(asset));
        this.loading.set(asset, loading);
      }
      return loading.then(bytes => {
        const first = chunk * this.chunkSize / this.pageSize;
        for (let offset = 0; offset < bytes.length; offset += this.pageSize) {
          const page = first + offset / this.pageSize;
          if (!file.pages.has(page)) file.pages.set(page, bytes.subarray(offset, offset + this.pageSize));
        }
      });
    }));
  }
  read(file, start, length) {
    if (!length) return new Uint8Array();
    const first = Math.floor(start / this.pageSize), last = Math.floor((start + length - 1) / this.pageSize);
    if (first === last) return this.page(file, first).subarray(start % this.pageSize, start % this.pageSize + length);
    const result = new Uint8Array(length);
    let copied = 0;
    for (let page = first; page <= last; page++) {
      const from = Math.max(start - page * this.pageSize, 0);
      const to = Math.min(start + length - page * this.pageSize, this.pageSize);
      const bytes = this.page(file, page).subarray(from, to);
      result.set(bytes, copied); copied += bytes.length;
    }
    return result;
  }
}

export class PagedMetadataFile extends RangeFile {
  constructor(store, entry, record) {
    super(entry.length); this.store = store; this.file = store.files.get(entry.path); this.record = record;
  }
  prepare(start, length) { return this.store.ensure(this.file, start, length); }
  read(start, length) { this.record?.(this.file.entry.path, length); return this.store.read(this.file, start, length); }
}

export function readMetadata(wasi, method, args) {
  const [fd, pointer, count] = args;
  const file = wasi.fds[fd];
  if (!file?.prepare_read) return wasi.wasiImport[method](...args);
  const memory = new DataView(wasi.inst.exports.memory.buffer);
  let length = 0;
  for (let index = 0; index < count; index++) length += memory.getUint32(pointer + index * 8 + 4, true);
  const prepared = file.prepare_read(length, method === "fd_pread" ? args[3] : undefined);
  return prepared ? prepared.then(() => wasi.wasiImport[method](...args)) : wasi.wasiImport[method](...args);
}
