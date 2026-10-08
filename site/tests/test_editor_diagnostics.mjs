import assert from 'node:assert/strict';
import { test } from 'node:test';
import { compilerDiagnostics } from '../editor/diagnostics.js';

test('Rust character columns map past supplementary Unicode characters', () => {
  const source = 'let s = "🦀"; missing();';
  const from = source.indexOf('missing');
  const column = [...source.slice(0, from)].length + 1;
  const [diagnostic] = compilerDiagnostics(`error[E0425]: cannot find function\n --> /gpui-codepen/component.rs:1:${column}`, source);
  assert.equal(diagnostic.from, from);
  assert.equal(diagnostic.to, from + 1);
  const [crab] = compilerDiagnostics('error: invalid token\n --> component.rs:1:10', source);
  assert.equal(source.slice(crab.from, crab.to), '🦀');
});

test('an appended-harness span uses its related user-source line', () => {
  const source = 'fn component() {}\nfn broken(é';
  const text = 'error: this file contains an unclosed delimiter\n --> /gpui-codepen/component.rs:3:51\n  |\n2 | fn broken(é\n  |          - unclosed delimiter\n3 | fn main() { gpui_codepen_guest::run(component); }';
  const [diagnostic] = compilerDiagnostics(text, source);
  assert.equal(source.slice(diagnostic.from, diagnostic.to), 'fn broken(é');
  assert.equal(diagnostic.severity, 'error');
});

test('dependency spans and mismatching excerpts do not highlight unrelated source', () => {
  assert.deepEqual(compilerDiagnostics('error: dependency failed\n --> /deps/library.rs:1:1', 'user code'), []);
  assert.deepEqual(compilerDiagnostics('error: invalid program\n --> component.rs:2:1\n1 | different source', 'user code'), []);
});
