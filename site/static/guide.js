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
  const announcement = document.querySelector('[data-search-status]');
  let indexes;
  let generation = 0;
  const load = () => indexes ||= Promise.all([input.dataset.index, input.dataset.apimap].map(async url => {
    const response = await fetch(url);
    if (!response.ok) throw new Error('Search index unavailable');
    return response.json();
  })).catch(error => { indexes = null; throw error; });
  const add = (title, url, detail) => {
    const li = document.createElement('li');
    const link = document.createElement('a');
    link.href = url; link.textContent = title;
    if (detail) { const label = document.createElement('small'); label.textContent = detail; link.append(label); }
    li.append(link); results.append(li);
  };
  const search = async () => {
    const current = ++generation;
    const raw = input.value.trim();
    const query = raw.toLocaleLowerCase();
    results.replaceChildren(); results.hidden = !query;
    if (!query) { announcement.textContent = ''; return; }
    announcement.textContent = 'Searching…';
    try {
      const [pages, apis] = await load();
      if (current !== generation) return;
      const compact = query.replace(/^gpui::/, '');
      const matches = Object.entries(apis).map(([symbol, entry]) => {
        const name = symbol.toLocaleLowerCase().replace(/^gpui::/, '');
        return { symbol, entry, score: name === compact ? 100 : name.endsWith(`::${compact}`) ? 50 : name.includes(compact) ? 10 : 0 };
      }).filter(row => row.score).sort((a, b) => b.score - a.score).slice(0, 3);
      const seen = new Set();
      for (const { symbol, entry } of matches) {
        add(symbol, entry.docs, 'API contract');
        for (const example of entry.examples.slice(0, 2)) {
          if (seen.has(example.url)) continue;
          seen.add(example.url);
          add(example.step_title, new URL(example.url.replace(/^\//, ''), input.dataset.base).href, example.title);
        }
      }
      const words = query.split(/\s+/);
      const rows = (Array.isArray(pages) ? pages : pages.documents || []).map(row => {
        const title = (row.title || '').toLocaleLowerCase();
        const description = (row.description || '').toLocaleLowerCase();
        const body = (row.body || row.content || '').toLocaleLowerCase();
        const text = `${title} ${description} ${body}`;
        return { row, score: words.every(word => text.includes(word)) ? words.reduce((score, word) => score + (title.includes(word) ? 10 : description.includes(word) ? 4 : 1), 0) : 0 };
      }).filter(result => result.score).sort((a, b) => b.score - a.score).slice(0, matches.length ? 3 : 8);
      for (const { row } of rows) add(row.title, row.url || row.permalink || row.id);
      if (!rows.length && !matches.length) {
        const li = document.createElement('li'); li.textContent = 'No matching topic. Try the API search below.'; results.append(li);
      }
      const apiURL = new URL(input.dataset.api);
      apiURL.searchParams.set('search', raw);
      add(`Search all APIs for “${raw}”`, apiURL.href);
      announcement.textContent = `${results.querySelectorAll('a').length} results for “${raw}”.`;
    } catch {
      if (current !== generation) return;
      announcement.textContent = 'Search unavailable.';
      const li = document.createElement('li'); li.textContent = 'Search could not load. Use the topic indexes below.'; results.append(li);
    }
  };
  input.addEventListener('input', search);
  input.form.addEventListener('submit', event => { event.preventDefault(); search(); });
  input.form.addEventListener('keydown', event => {
    if (event.key === 'Escape') { results.hidden = true; input.focus(); }
    if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
      const links = [...results.querySelectorAll('a')];
      const index = links.indexOf(document.activeElement);
      const next = index + (event.key === 'ArrowDown' ? 1 : -1);
      (next < 0 ? input : links[next] || links[0])?.focus();
      event.preventDefault();
    }
  });
  const query = new URLSearchParams(location.search).get('q');
  if (query) { input.value = query; search(); }
}

// The DOM editor hosts the existing GPUI preview controller and renderer.
for (const playground of document.querySelectorAll('[data-playground]')) {
  const frame = playground.querySelector('[data-preview]');
  const status = playground.querySelector('[data-preview-status]');
  const edit = playground.querySelector('[data-edit]');
  const restore = playground.querySelector('[data-restore]');
  const open = playground.querySelector('[data-workbench-link]');
  const originalURL = frame.src;
  let editing = false;
  window.addEventListener('message', event => {
    if (event.source !== frame.contentWindow || event.origin !== new URL(frame.src).origin) return;
    if (event.data === 'gpui-preview-ready') {
      status.textContent = 'Ready. Click inside the preview to use it.';
    }
    if (event.data?.type === 'gpui-workbench-shell-ready') {
      status.textContent = 'Rust editor open. Your edits are saved in this browser.';
    }
    if (typeof event.data === 'object' && event.data?.type === 'gpui-preview-error') {
      status.textContent = `Preview unavailable: ${event.data.message}. The source and walkthrough remain available.`;
    }
  });
  edit.addEventListener('click', () => {
    editing = true;
    frame.src = open.href;
    frame.title = `${playground.getAttribute('aria-label')} — Rust editor and GPUI result`;
    playground.classList.add('editing');
    edit.hidden = true; restore.hidden = false; open.hidden = false;
    status.textContent = 'Opening the Rust editor…';
  });
  restore.addEventListener('click', () => {
    editing = false;
    frame.src = originalURL;
    frame.title = `${playground.getAttribute('aria-label')} — interactive GPUI preview`;
    playground.classList.remove('editing');
    edit.hidden = false; restore.hidden = true; open.hidden = true;
    status.textContent = 'Opening the original program…';
  });
}
