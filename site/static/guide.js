const local = ['localhost', '127.0.0.1', '[::1]'].includes(location.hostname);

for (const block of document.querySelectorAll('pre:has(code)')) {
  const code = block.querySelector('code');
  const button = document.createElement('button');
  button.type = 'button';
  button.className = 'copy-button';
  button.textContent = 'Copy';
  button.setAttribute('aria-label', 'Copy this code');
  button.addEventListener('click', async () => {
    try {
      await navigator.clipboard.writeText(code.textContent);
      button.textContent = 'Copied';
    } catch {
      const range = document.createRange();
      range.selectNodeContents(code);
      const selection = getSelection();
      selection.removeAllRanges(); selection.addRange(range);
      button.textContent = 'Selected — copy';
    }
    setTimeout(() => { button.textContent = 'Copy'; }, 2000);
  });
  block.append(button);
}

const input = document.querySelector('[data-search]');
if (input) {
  const results = document.querySelector('[data-search-results]');
  let index;
  const load = async () => {
    if (!index) {
      const response = await fetch(input.dataset.index);
      if (!response.ok) throw new Error('Search index unavailable');
      const data = await response.json();
      index = Array.isArray(data) ? data : (data.documents || []);
    }
    return index;
  };
  const search = async () => {
    const query = input.value.trim().toLocaleLowerCase();
    results.replaceChildren(); results.hidden = !query;
    if (!query) return;
    try {
      const words = query.split(/\s+/);
      const rows = (await load()).map(row => {
        const title = (row.title || '').toLocaleLowerCase();
        const text = `${title} ${row.description || ''} ${row.body || row.content || ''}`.toLocaleLowerCase();
        return { row, score: words.every(word => text.includes(word)) ? words.reduce((score, word) => score + (title.includes(word) ? 10 : 1), 0) : 0 };
      }).filter(result => result.score).sort((a, b) => b.score - a.score).slice(0, 8);
      for (const { row } of rows) {
        const li = document.createElement('li');
        const a = document.createElement('a');
        a.href = row.url || row.permalink || row.id;
        a.textContent = row.title;
        li.append(a); results.append(li);
      }
      if (!rows.length) { const li = document.createElement('li'); li.textContent = 'No matching guide.'; results.append(li); }
      const api = document.createElement('li');
      const apiLink = document.createElement('a');
      const apiURL = new URL(input.dataset.api);
      apiURL.searchParams.set('search', input.value.trim());
      apiLink.href = apiURL.href;
      apiLink.textContent = `Search the API for “${input.value.trim()}”`;
      api.append(apiLink); results.append(api);
    } catch { const li = document.createElement('li'); li.textContent = 'Search could not load. Use the topic indexes below.'; results.append(li); }
  };
  input.addEventListener('input', search);
  input.form.addEventListener('submit', event => { event.preventDefault(); search(); });
  input.addEventListener('keydown', event => {
    if (event.key === 'Escape') { results.hidden = true; }
    if (event.key === 'ArrowDown') { results.querySelector('a')?.focus(); event.preventDefault(); }
  });
  const query = new URLSearchParams(location.search).get('q');
  if (query) { input.value = query; search(); }
}

let compiler;
const connect = async () => {
  if (!local) return null;
  if (!compiler) compiler = fetch('http://127.0.0.1:1117/health', { signal: AbortSignal.timeout(3000) })
    .then(response => response.ok ? response.json() : null).catch(() => null);
  return compiler;
};

for (const playground of document.querySelectorAll('[data-playground]')) {
  const frame = playground.querySelector('[data-preview]');
  const status = playground.querySelector('[data-preview-status]');
  const editor = playground.querySelector('[data-editor]');
  const button = playground.querySelector('[data-run]');
  const diagnostics = playground.querySelector('[data-diagnostics]');
  const original = editor.value;
  const originalURL = frame.src;
  let generation = 0;
  const report = message => { diagnostics.textContent = message; };
  window.addEventListener('message', event => {
    if (event.source !== frame.contentWindow) return;
    if (event.origin !== new URL(frame.src).origin) return;
    if (event.data === 'gpui-preview-ready') status.textContent = 'Ready. Click inside the preview to use it.';
    if (typeof event.data === 'object' && event.data?.type === 'gpui-preview-error') {
      status.textContent = `Preview unavailable: ${event.data.message}. The source and walkthrough remain available.`;
    }
  });
  connect().then(service => {
    button.disabled = !service?.ready;
    report(service?.ready ? 'Local compiler ready. Run with Ctrl/⌘ + Enter.' : 'To run edits, start python3 site/scripts/dev.py and open its localhost URL.');
  });
  const run = async () => {
    const service = await connect();
    if (!service?.ready) return;
    const current = ++generation;
    report('Compiling Rust… The last successful preview stays visible.');
    button.disabled = true;
    try {
      const response = await fetch('http://127.0.0.1:1117/compile', {
        method: 'POST', headers: { 'Content-Type': 'application/json', 'X-GPUI-Compiler-Token': service.token },
        body: JSON.stringify({ source: editor.value }), signal: AbortSignal.timeout(900000),
      });
      const result = await response.json();
      if (current !== generation) return;
      if (!response.ok || !result.url) {
        report(result.diagnostics || result.error || 'Compilation failed.'); return;
      }
      frame.src = new URL(result.url, 'http://127.0.0.1:1117').href;
      report(result.diagnostics || 'Build succeeded. The preview is running the edited source.');
    } catch (error) { if (current === generation) report(`Compiler request failed: ${error.message}`); }
    finally { if (current === generation) button.disabled = false; }
  };
  button.addEventListener('click', run);
  editor.addEventListener('keydown', event => {
    if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') { event.preventDefault(); run(); }
    if (event.key === 'Tab') {
      // Keep Tab available for keyboard navigation; source editing can insert spaces normally.
      return;
    }
  });
  playground.querySelector('[data-restore]').addEventListener('click', () => {
    generation++; editor.value = original; frame.src = originalURL;
    button.disabled = false; report('Original source and preview restored.');
  });
}
