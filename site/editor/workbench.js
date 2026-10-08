import { basicSetup } from 'codemirror';
import { EditorView, keymap, hoverTooltip } from '@codemirror/view';
import { Compartment, EditorState } from '@codemirror/state';
import { indentWithTab } from '@codemirror/commands';
import { rust } from '@codemirror/lang-rust';
import { autocompletion } from '@codemirror/autocomplete';
import { setDiagnostics } from '@codemirror/lint';
import { compilerDiagnostics } from './diagnostics.js';
import { nativeSource } from './native-source.js';

/** @typedef {{type:'gpui-workbench-command', command:'source'|'run'|'reset'|'auto', revision:number, source?:string, enabled?:boolean}} Command */
/** @typedef {{type:'gpui-workbench-status', revision:number, phase:'ready'|'edited'|'running'|'live'|'error'|'unavailable', diagnostics:string, elapsed_ms:number, backend:string, has_frame:boolean}} Status */

const $ = selector => document.querySelector(selector);
const preview = $('#preview');
const status = $('#status');
const panels = $('#panels');
const splitter = $('#splitter');
const encoder = new TextEncoder();
const slug = decodeURIComponent(location.hash.slice(1));
const sourceURL = new URL(`../components/${encodeURIComponent(slug)}.rs`, location.href);
const draftKey = `gpui-example:${slug}`;
// A fragment change selects another program and must replace its runtime too.
addEventListener('hashchange', () => location.reload());
let original = '', editor, revision = 0, ready = false, timer, startupTimer, apiEntries = [];
let split = 50;
const wrapping = new Compartment();

function announce(text, state = '') {
  status.textContent = text;
  status.dataset.state = state;
}
function command(command, extra = {}) {
  if (!ready) return;
  /** @type {Command} */
  const message = { type: 'gpui-workbench-command', command, revision, ...extra };
  preview.contentWindow.postMessage(message, location.origin);
}
function run() {
  if (!editor || !ready) return;
  clearTimeout(timer);
  command('run');
  showDiagnostics(false);
  announce('Running Rust…', 'running');
}
function schedule() {
  clearTimeout(timer);
  if ($('#auto-run').checked) timer = setTimeout(run, 700);
}
function setSource() {
  if (!editor) return;
  command('source', { source: editor.state.doc.toString() });
}
function showDiagnostics(show) {
  $('#diagnostics').hidden = !show;
  $('#diagnostics-toggle').setAttribute('aria-expanded', String(show));
}
function diagnosticRanges(text) {
  return compilerDiagnostics(text, editor.state.doc.toString());
}
function apiInfo(entry) {
  const box = document.createElement('div');
  box.className = 'api-completion';
  const name = document.createElement('strong');
  name.textContent = entry.symbol;
  box.append(name, document.createElement('br'));
  const contract = document.createElement('a');
  contract.href = entry.docs; contract.target = '_blank'; contract.rel = 'noopener'; contract.textContent = 'API contract';
  box.append(contract);
  for (const example of entry.examples.slice(0, 2)) {
    const link = document.createElement('a');
    link.href = new URL(example.url.replace(/^\//, ''), new URL('../', location.href));
    link.target = '_blank'; link.rel = 'noopener'; link.textContent = example.step_title;
    box.append(link);
  }
  return box;
}
function completeAPI(context) {
  const word = context.matchBefore(/[A-Za-z_][\w:]*/);
  if (!word || (!context.explicit && word.text.length < 2)) return null;
  const qualified = word.text.includes('::');
  return { from: word.from, options: apiEntries.map(entry => ({
    label: qualified ? entry.symbol : entry.name,
    type: /^[A-Z]/.test(entry.name) ? 'type' : 'function',
    detail: entry.symbol.replace(/^gpui::/, ''),
    info: () => apiInfo(entry),
  })), validFor: /^[\w:]*$/ };
}
const apiHover = hoverTooltip((view, pos, side) => {
  const line = view.state.doc.lineAt(pos);
  let from = pos, to = pos;
  while (from > line.from && /[\w:]/.test(line.text[from - line.from - 1])) from--;
  while (to < line.to && /[\w:]/.test(line.text[to - line.from])) to++;
  if ((from === pos && side < 0) || (to === pos && side > 0)) return null;
  const word = view.state.doc.sliceString(from, to);
  const entry = apiEntries.find(entry => entry.symbol === word || entry.name === word);
  return entry ? { pos: from, end: to, above: true, create: () => ({ dom: apiInfo(entry) }) } : null;
});

function resizeSplit(value) {
  split = Math.min(80, Math.max(20, value));
  panels.style.setProperty('--split', `${split}%`);
  splitter.setAttribute('aria-valuenow', String(Math.round(split)));
}
function verticalStack() { return matchMedia('(max-width:950px)').matches; }
function splitterOrientation() {
  splitter.setAttribute('aria-orientation', verticalStack() ? 'horizontal' : 'vertical');
}
splitter.addEventListener('pointerdown', event => {
  if (event.button !== 0) return;
  splitter.setPointerCapture(event.pointerId);
  document.body.classList.add('dragging');
});
splitter.addEventListener('pointermove', event => {
  if (!splitter.hasPointerCapture(event.pointerId)) return;
  const bounds = panels.getBoundingClientRect();
  resizeSplit(verticalStack() ? 100 * (event.clientY - bounds.top) / bounds.height : 100 * (event.clientX - bounds.left) / bounds.width);
});
splitter.addEventListener('pointerup', event => {
  if (splitter.hasPointerCapture(event.pointerId)) splitter.releasePointerCapture(event.pointerId);
  document.body.classList.remove('dragging');
});
splitter.addEventListener('lostpointercapture', () => document.body.classList.remove('dragging'));
splitter.addEventListener('keydown', event => {
  const previous = verticalStack() ? 'ArrowUp' : 'ArrowLeft';
  const next = verticalStack() ? 'ArrowDown' : 'ArrowRight';
  if (event.key === previous || event.key === next) { event.preventDefault(); resizeSplit(split + (event.key === previous ? -5 : 5)); }
  if (event.key === 'Home' || event.key === 'End') { event.preventDefault(); resizeSplit(event.key === 'Home' ? 20 : 80); }
});
matchMedia('(max-width:950px)').addEventListener('change', splitterOrientation);
splitterOrientation();
for (const button of document.querySelectorAll('button[data-view]')) button.addEventListener('click', () => {
  panels.dataset.view = button.dataset.view;
  for (const control of document.querySelectorAll('button[data-view]')) control.setAttribute('aria-pressed', String(control === button));
  if (button.dataset.view === 'code') editor?.focus();
});
$('#run').addEventListener('click', run);
$('#wrap').addEventListener('click', () => {
  if (!editor) return;
  const enabled = $('#wrap').getAttribute('aria-pressed') !== 'true';
  $('#wrap').setAttribute('aria-pressed', String(enabled));
  editor.dispatch({ effects: wrapping.reconfigure(enabled ? EditorView.lineWrapping : []) });
});
$('#reset').addEventListener('click', () => command('reset'));
$('#auto-run').addEventListener('change', () => {
  clearTimeout(timer);
  // The shell controls the typing pause. The controller still invalidates
  // old source immediately, so the retained result cannot accept stale input.
  command('auto', { enabled: false });
  if ($('#auto-run').checked) run();
});
$('#restore').addEventListener('click', () => {
  if (!editor) return;
  editor.dispatch({ changes: { from: 0, to: editor.state.doc.length, insert: original } });
  editor.focus();
});
$('#copy').addEventListener('click', async () => {
  try { await navigator.clipboard.writeText(editor.state.doc.toString()); $('#copy').textContent = 'Copied'; }
  catch { editor.dispatch({ selection: { anchor: 0, head: editor.state.doc.length } }); editor.focus(); $('#copy').textContent = 'Selected; copy now'; }
  setTimeout(() => $('#copy').textContent = 'Copy Rust', 2000);
});
$('#download').addEventListener('click', async () => {
  if (!editor) return;
  const component = editor.state.doc.toString();
  try {
    const response = await fetch(new URL(`../examples/${encodeURIComponent(slug)}.rs`, location.href));
    if (!response.ok) throw new Error('The native launcher could not be loaded. Your Rust source is still available through Copy Rust.');
    const program = nativeSource(component, await response.text());
    const url = URL.createObjectURL(new Blob([program], { type: 'text/plain;charset=utf-8' }));
    const link = document.createElement('a'); link.href = url; link.download = 'main.rs'; link.click();
    setTimeout(() => URL.revokeObjectURL(url), 1000);
  } catch (error) {
    announce(error.message, 'error');
  }
});
$('#diagnostics-toggle').addEventListener('click', () => showDiagnostics($('#diagnostics').hidden));
window.addEventListener('message', event => {
  if (event.source !== preview.contentWindow || event.origin !== location.origin) return;
  const message = event.data;
  if (message?.type === 'gpui-workbench-ready') {
    if (ready) return;
    ready = true;
    clearTimeout(startupTimer);
    $('#run').disabled = false;
    $('#reset').disabled = false;
    command('auto', { enabled: false });
    setSource(); run();
    return;
  }
  if (message?.type === 'gpui-preview-error') {
    clearTimeout(startupTimer);
    $('#runtime-label').textContent = 'Preview unavailable';
    announce(`Preview unavailable: ${message.message}`, 'error');
    return;
  }
  if (message?.type !== 'gpui-workbench-status' || message.revision !== revision) return;
  /** @type {Status} */
  const update = message;
  $('#runtime-label').textContent = update.backend === 'miri-wasm' ? 'Runs in your browser' : update.backend === 'miri-native' ? 'Local Miri · development' : 'Rust / GPUI';
  if (update.phase === 'running') { announce('Running Rust…', 'running'); return; }
  if (update.phase === 'edited') { announce($('#auto-run').checked ? 'Waiting for edits…' : 'Edited · press Run'); return; }
  const diagnostics = typeof update.diagnostics === 'string' ? update.diagnostics : '';
  $('#diagnostic-text').textContent = diagnostics || 'No Rust diagnostics.';
  const ranges = diagnosticRanges(diagnostics);
  editor.dispatch(setDiagnostics(editor.state, ranges));
  $('#error-count').textContent = ranges.length ? String(ranges.length) : diagnostics ? '!' : '';
  if (update.phase === 'unavailable') {
    announce(update.has_frame ? 'Preview unavailable. The last working result is still visible.' : 'Preview unavailable. Your source is still editable.', 'error');
    showDiagnostics(true);
  } else if (diagnostics) {
    announce(update.has_frame ? 'Rust needs a fix. The last working result is still visible.' : 'Rust needs a fix.', 'error');
    showDiagnostics(true);
  } else if (update.phase === 'live') {
    announce(`Live · ${update.elapsed_ms} ms`);
    showDiagnostics(false);
  } else announce('Ready');
});

try {
  if (!/^[a-z][a-z0-9-]*$/.test(slug)) throw new Error('Choose a walkthrough before opening its editor.');
  const response = await fetch(sourceURL);
  if (!response.ok) throw new Error('The canonical Rust source could not be loaded.');
  original = await response.text();
  if (encoder.encode(original).length > 65536) throw new Error('The Rust source exceeds the 64 KiB editor limit.');
  let draft;
  try { draft = localStorage.getItem(draftKey); } catch {}
  if (draft && encoder.encode(draft).length > 65536) draft = null;
  // Reference links enrich the editor, but a missing index must not prevent
  // reading, editing, or downloading the Rust source.
  try {
    const apiResponse = await fetch(new URL('../api-examples.json', location.href));
    if (apiResponse.ok) {
      const map = await apiResponse.json();
      apiEntries = Object.entries(map).map(([symbol, entry]) => ({ symbol, name: symbol.split('::').at(-1), ...entry }));
      const example = apiEntries.flatMap(entry => entry.examples).find(example => example.example === slug);
      if (example) $('#example-title').textContent = example.title;
    }
  } catch {}
  $('#walkthrough-link').href = new URL(`../examples/${slug}/`, location.href);
  editor = new EditorView({ parent: $('#editor'), state: EditorState.create({
    doc: draft || original,
    extensions: [basicSetup, rust(), wrapping.of([]), keymap.of([{ key: 'Mod-Enter', run: () => { run(); return true; } }, { key: 'Ctrl-Enter', run: () => { run(); return true; } }, indentWithTab]),
      EditorView.contentAttributes.of({ 'aria-label': 'Rust source', spellcheck: 'false' }),
      autocompletion({ override: [completeAPI] }), apiHover,
      EditorState.transactionFilter.of(transaction => {
        if (transaction.docChanged && encoder.encode(transaction.newDoc.toString()).length > 65536) {
          announce('Source is limited to 64 KiB. That edit was not applied.', 'error'); return [];
        }
        return transaction;
      }),
      EditorView.updateListener.of(update => {
        const head = update.state.selection.main.head;
        const line = update.state.doc.lineAt(head);
        $('#position').textContent = `Ln ${line.number}, Col ${head - line.from + 1}`;
        if (!update.docChanged) return;
        revision++;
        try { localStorage.setItem(draftKey, update.state.doc.toString()); } catch {}
        setSource(); schedule();
        announce($('#auto-run').checked ? 'Waiting for edits…' : 'Edited · press Run');
        $('#error-count').textContent = '';
        $('#diagnostic-text').textContent = 'Source changed. Run it to refresh diagnostics.';
        showDiagnostics(false);
        queueMicrotask(() => editor.dispatch(setDiagnostics(editor.state, [])));
      }),
    ],
  }) });
  const url = new URL('../preview/index.html?workbench', location.href);
  url.hash = `host/${slug}`;
  preview.src = url;
  if (window.parent !== window) window.parent.postMessage({ type: 'gpui-workbench-shell-ready' }, location.origin);
  startupTimer = setTimeout(() => {
    if (ready) return;
    $('#runtime-label').textContent = 'Preview unavailable';
    announce('The preview has not started. Your Rust source is still editable and downloadable.', 'error');
  }, 45000);
  announce(draft ? 'Local draft restored. Preparing the preview…' : 'Preparing the preview…');
} catch (error) {
  announce(error.message, 'error');
  for (const button of document.querySelectorAll('.actions button, .panel-heading button')) button.disabled = true;
}
