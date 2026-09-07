#!/usr/bin/env node
// The live compiler behind the field guide's editable GPUI exhibits.
//
// It accepts a standalone GPUI example program, compiles it to WebAssembly with
// the real Rust toolchain, and serves the resulting bundle. Nothing in it is
// clever: each request is a `cargo build` plus `wasm-bindgen`, deduplicated by
// source hash and serialised through one queue so parallel edits never fight
// over the target directory.
//
//   node site/scripts/live-compiler.mjs            # http://127.0.0.1:1117
//   LIVE_COMPILER_PORT=9000 node site/scripts/live-compiler.mjs
//
// The site discovers it through `extra.live_compiler` in zola.toml (dev builds)
// or the `data-compiler` attribute on <gpui-playground>.
import { createHash } from 'node:crypto';
import { spawn } from 'node:child_process';
import { createServer } from 'node:http';
import { mkdir, readFile, readdir, stat, writeFile, cp, rm } from 'node:fs/promises';
import { existsSync } from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const site = fileURLToPath(new URL('..', import.meta.url));
const demo = path.join(site, 'wasm', 'gpui-demo');
const live = path.join(site, 'wasm', '.live');
const crate = path.join(live, 'crate');
const builds = path.join(live, 'builds');
const port = Number(process.env.LIVE_COMPILER_PORT || 1117);
const host = process.env.LIVE_COMPILER_HOST || '127.0.0.1';
const target = 'wasm32-unknown-unknown';
const maxSource = 64 * 1024;

const log = (...parts) => console.log(new Date().toISOString().slice(11, 19), ...parts);

async function findWasmBindgen() {
  if (process.env.WASM_BINDGEN) return process.env.WASM_BINDGEN;
  const lock = await readFile(path.join(demo, 'Cargo.lock'), 'utf8');
  const version = /name = "wasm-bindgen"\nversion = "([^"]+)"/.exec(lock)?.[1];
  const candidates = [
    path.join(os.homedir(), 'Library', 'Caches', 'dev.trunkrs.trunk', `wasm-bindgen-${version}`, 'wasm-bindgen'),
    path.join(os.homedir(), '.cache', 'trunk', `wasm-bindgen-${version}`, 'wasm-bindgen'),
    path.join(os.homedir(), '.cargo', 'bin', 'wasm-bindgen'),
  ];
  for (const candidate of candidates) if (existsSync(candidate)) return candidate;
  throw new Error(`wasm-bindgen ${version} not found. Run ./site/scripts/build-wasm.sh once (Trunk downloads it) or set WASM_BINDGEN=/path/to/wasm-bindgen.`);
}

function run(command, args, options = {}) {
  return new Promise((resolve) => {
    const child = spawn(command, args, { ...options, stdio: ['ignore', 'pipe', 'pipe'] });
    let stdout = '', stderr = '';
    child.stdout.on('data', (chunk) => { stdout += chunk; });
    child.stderr.on('data', (chunk) => { stderr += chunk; });
    child.on('close', (code) => resolve({ code, stdout, stderr }));
  });
}

async function prepareCrate() {
  await mkdir(path.join(crate, 'src'), { recursive: true });
  const manifest = (await readFile(path.join(demo, 'Cargo.toml'), 'utf8'))
    .replace(/name = "gpui-site-demo"/, 'name = "gpui-site-live"')
    .replace(/name = "gpui-site-demo"\npath = "src\/main.rs"/, 'name = "gpui-site-live"\npath = "src/main.rs"')
    .replace(/path = "\.\.\/\.\.\/\.\.\/crates\//g, `path = "${path.join(site, '..', 'crates').replace(/\\/g, '/')}/`);
  await writeFile(path.join(crate, 'Cargo.toml'), manifest);
  await cp(path.join(demo, 'Cargo.lock'), path.join(crate, 'Cargo.lock'));
  await cp(path.join(demo, 'fonts'), path.join(crate, 'fonts'), { recursive: true });
  await cp(path.join(demo, 'src', 'bridge.rs'), path.join(crate, 'src', 'bridge.rs'));
  await writeFile(path.join(crate, 'src', 'main.rs'), [
    '// Generated host for a live-compiled exhibit. The editable program is `live.rs`.',
    'mod bridge;',
    'mod live;',
    'fn main() { live::main(); }',
    '',
  ].join('\n'));
}

function diagnostics(jsonLines) {
  const found = [];
  for (const line of jsonLines.split('\n')) {
    if (!line.startsWith('{')) continue;
    let message;
    try { message = JSON.parse(line); } catch { continue; }
    if (message.reason !== 'compiler-message') continue;
    const m = message.message;
    if (!['error', 'warning'].includes(m.level)) continue;
    const span = m.spans.find((s) => s.is_primary && s.file_name.endsWith('live.rs')) || m.spans.find((s) => s.file_name.endsWith('live.rs'));
    found.push({
      level: m.level,
      message: m.message,
      line: span?.line_start ?? null,
      column: span?.column_start ?? null,
      rendered: m.rendered?.replace(/src\/live\.rs/g, 'example.rs') ?? m.message,
    });
  }
  return found;
}

let queue = Promise.resolve();
const results = new Map();

function compile(source) {
  const id = createHash('sha256').update(source).digest('hex').slice(0, 16);
  if (results.has(id)) return results.get(id);
  const job = queue.then(async () => {
    const dist = path.join(builds, id);
    if (existsSync(path.join(dist, 'index.html'))) return { id, cached: true };
    const started = performance.now();
    await prepareCrate();
    await writeFile(path.join(crate, 'src', 'live.rs'), source);
    const cargo = await run('cargo', ['build', '--release', '--target', target, '--message-format=json-diagnostic-rendered-ansi'], {
      cwd: crate,
      env: { ...process.env, CARGO_TARGET_DIR: path.join(demo, 'target'), CARGO_TERM_COLOR: 'never' },
    });
    const messages = diagnostics(cargo.stdout);
    if (cargo.code !== 0) {
      const error = new Error('Rust compilation failed');
      error.diagnostics = messages;
      error.log = cargo.stderr.slice(-4000);
      throw error;
    }
    const wasm = path.join(demo, 'target', target, 'release', 'gpui-site-live.wasm');
    await mkdir(dist, { recursive: true });
    const bindgen = await run(await findWasmBindgen(), ['--target', 'web', '--no-typescript', '--out-dir', dist, '--out-name', 'exhibit', wasm]);
    if (bindgen.code !== 0) {
      await rm(dist, { recursive: true, force: true });
      const error = new Error('wasm-bindgen failed');
      error.log = bindgen.stderr.slice(-4000);
      throw error;
    }
    await writeFile(path.join(dist, 'index.html'), [
      '<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Live GPUI exhibit</title>',
      '<style>*{box-sizing:border-box}html,body{height:100%;margin:0;background:oklch(16% .05 250)}canvas{display:block;width:100%;height:100%;outline:none;touch-action:none}</style>',
      '<script type="module">import init from "./exhibit.js"; await init({ module_or_path: "./exhibit_bg.wasm" });</script>',
      '</head><body></body></html>',
      '',
    ].join('\n'));
    return { id, seconds: Math.round((performance.now() - started) / 100) / 10, warnings: messages.filter((m) => m.level === 'warning') };
  });
  const tracked = job.catch((error) => { results.delete(id); throw error; });
  results.set(id, tracked);
  queue = tracked.catch(() => {});
  return tracked;
}

const types = { '.html': 'text/html; charset=utf-8', '.js': 'text/javascript; charset=utf-8', '.wasm': 'application/wasm', '.json': 'application/json' };

function headers(extra = {}) {
  return {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'content-type',
    'Access-Control-Allow-Methods': 'GET, POST, OPTIONS',
    'Cross-Origin-Resource-Policy': 'cross-origin',
    'Cache-Control': 'no-store',
    ...extra,
  };
}

function json(response, status, body) {
  response.writeHead(status, headers({ 'Content-Type': 'application/json' }));
  response.end(JSON.stringify(body));
}

const server = createServer(async (request, response) => {
  const url = new URL(request.url, `http://${request.headers.host}`);
  if (request.method === 'OPTIONS') { response.writeHead(204, headers()); return response.end(); }
  if (url.pathname === '/status') return json(response, 200, { ok: true, builds: (await readdir(builds).catch(() => [])).length, target });
  if (url.pathname === '/compile' && request.method === 'POST') {
    let body = '';
    for await (const chunk of request) { body += chunk; if (body.length > maxSource * 2) { return json(response, 413, { error: 'Source is too large' }); } }
    let source;
    try { ({ source } = JSON.parse(body)); } catch { return json(response, 400, { error: 'Expected JSON { source }' }); }
    if (typeof source !== 'string' || !source.trim()) return json(response, 400, { error: 'Expected a Rust source string' });
    if (source.length > maxSource) return json(response, 413, { error: 'Source is too large' });
    try {
      const result = await compile(source);
      log('built', result.id, result.cached ? '(cached)' : `${result.seconds}s`);
      return json(response, 200, { ...result, url: `/builds/${result.id}/index.html` });
    } catch (error) {
      log('failed', error.message);
      return json(response, 422, { error: error.message, diagnostics: error.diagnostics ?? [], log: error.log ?? '' });
    }
  }
  if (url.pathname.startsWith('/builds/') && request.method === 'GET') {
    const relative = path.normalize(url.pathname.slice('/builds/'.length));
    const file = path.join(builds, relative);
    if (!file.startsWith(builds) || !existsSync(file) || !(await stat(file)).isFile()) { response.writeHead(404, headers()); return response.end('Not found'); }
    response.writeHead(200, headers({ 'Content-Type': types[path.extname(file)] || 'application/octet-stream', 'Cache-Control': 'public, max-age=31536000, immutable' }));
    return response.end(await readFile(file));
  }
  response.writeHead(404, headers());
  response.end('Not found');
});

await mkdir(builds, { recursive: true });
await findWasmBindgen().then((found) => log('wasm-bindgen:', found)).catch((error) => log('warning:', error.message));
server.listen(port, host, () => log(`GPUI live compiler listening on http://${host}:${port} (target ${target})`));
