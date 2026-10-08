/** Add the canonical native launcher to the component currently in the editor. */
export function nativeSource(component, canonicalProgram) {
  const supportStart = canonicalProgram.lastIndexOf('\nmod support {\n');
  if (supportStart < 0) throw new Error('The native launcher is missing. Download the original project from the walkthrough.');
  return component.trimEnd()
    + '\n\nfn main() {\n    support::run(component);\n}\n'
    + canonicalProgram.slice(supportStart);
}
