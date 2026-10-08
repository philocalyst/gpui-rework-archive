/** Map rustc's source locations to the editor's UTF-16 offsets. */
export function compilerDiagnostics(text, source) {
  const sourceLines = source.split('\n');
  const starts = [];
  let offset = 0;
  for (const line of sourceLines) {
    starts.push(offset);
    offset += line.length + 1;
  }
  const diagnostics = [];
  let message = '', sourceContext = false;
  for (const line of text.split('\n')) {
    if (/^(error|warning)(\[.*?\])?:/.test(line)) {
      message = line;
      sourceContext = false;
    }
    const position = line.match(/(?:-->|:::)\s+(.*?):(\d+):(\d+)/);
    if (position && message) {
      sourceContext = false;
      if (!/(?:^|[/\\])component\.rs$/.test(position[1])) continue;
      const index = Number(position[2]) - 1;
      if (index < 0) continue;
      if (index >= sourceLines.length) {
        // An unclosed delimiter can place the primary span in our appended
        // harness. A related source line below it is still useful to the reader.
        sourceContext = true;
        continue;
      }
      const content = sourceLines[index];
      const prefix = [...content].slice(0, Number(position[3]) - 1).join('');
      const from = starts[index] + prefix.length;
      const next = [...content.slice(prefix.length)][0]?.length || 0;
      diagnostics.push({ from, to: from + next,
        severity: message.startsWith('warning') ? 'warning' : 'error', message });
      continue;
    }
    if (!sourceContext) continue;
    const context = line.match(/^\s*(\d+)\s*\| ?(.*)$/);
    if (!context) continue;
    const index = Number(context[1]) - 1;
    if (index < 0 || index >= sourceLines.length || context[2] !== sourceLines[index]) continue;
    diagnostics.push({ from: starts[index], to: starts[index] + sourceLines[index].length,
      severity: message.startsWith('warning') ? 'warning' : 'error', message });
    sourceContext = false;
  }
  return diagnostics;
}
