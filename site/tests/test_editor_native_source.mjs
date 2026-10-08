import test from 'node:test';
import assert from 'node:assert/strict';
import {readFileSync, readdirSync} from 'node:fs';
import {nativeSource} from '../editor/native-source.js';

test('exports every canonical component with the shared native launcher', () => {
  const components = new URL('../static/components/', import.meta.url);
  const names = readdirSync(components).filter(name => name.endsWith('.rs'));
  assert.ok(names.length > 0);
  for (const name of names) {
    const component = readFileSync(new URL(name, components), 'utf8');
    const canonical = readFileSync(new URL(`../static/examples/${name}`, import.meta.url), 'utf8');
    const exported = nativeSource(component, canonical);
    assert.ok(exported.startsWith(component.trimEnd() + '\n\nfn main()'), name);
    assert.ok(exported.endsWith(canonical.slice(canonical.lastIndexOf('\nmod support {\n'))), name);
  }
});

test('keeps edited Rust verbatim and rejects a missing launcher', () => {
  const canonical = 'fn component() {}\n\nmod support {\n    // Native setup.\n}\n';
  const edited = 'const LABEL: &str = "🦀";\nfn component() { /* edited */ }\n';
  assert.ok(nativeSource(edited, canonical).startsWith(edited + '\nfn main()'));
  assert.throws(() => nativeSource(edited, 'fn component() {}'), /native launcher is missing/);
});
