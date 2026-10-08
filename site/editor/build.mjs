import { build } from 'esbuild';
import { access, mkdir, readFile, writeFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';
import { createHash } from 'node:crypto';

const site = dirname(dirname(fileURLToPath(import.meta.url)));
const output = join(site, 'static/workbench');
await mkdir(output, { recursive: true });
const result = await build({
  absWorkingDir: site,
  entryPoints: ['editor/workbench.js'],
  outfile: join(output, 'editor.js'),
  bundle: true,
  minify: true,
  format: 'esm',
  target: ['es2022'],
  legalComments: 'linked',
  metafile: true,
});
// Keep the editor's source and stylesheet beside its bundled script. The
// published page uses only local assets; npm is a build dependency.
const stylesheet = await readFile(join(site, 'editor/workbench.css'));
await writeFile(join(output, 'workbench.css'), stylesheet);
const fingerprint = bytes => createHash('sha256').update(bytes).digest('hex').slice(0, 16);
const page = (await readFile(join(site, 'editor/index.html'), 'utf8'))
  .replace('./editor.js', `./editor.js?v=${fingerprint(await readFile(join(output, 'editor.js')))}`)
  .replace('./workbench.css', `./workbench.css?v=${fingerprint(stylesheet)}`);
await writeFile(join(output, 'index.html'), page);

// Include the notices for packages whose code appears in the browser bundle.
const packages = new Map();
for (const input of Object.keys(result.metafile.inputs)) {
  if (!input.startsWith('node_modules/')) continue;
  let directory = dirname(join(site, input));
  while (directory.startsWith(join(site, 'node_modules'))) {
    try {
      const metadata = JSON.parse(await readFile(join(directory, 'package.json'), 'utf8'));
      packages.set(metadata.name, { directory, metadata });
      break;
    } catch {
      directory = dirname(directory);
    }
  }
}
const notices = [];
for (const [name, { directory, metadata }] of [...packages].sort(([a], [b]) => a.localeCompare(b))) {
  let licensePath;
  for (const filename of ['LICENSE', 'LICENSE.md', 'LICENSE.txt', 'COPYING']) {
    try { await access(join(directory, filename)); licensePath = join(directory, filename); break; } catch {}
  }
  if (!licensePath) throw new Error(`Missing distribution license for ${name}`);
  notices.push(`${name} ${metadata.version}\n${await readFile(licensePath, 'utf8')}`);
}
await writeFile(join(output, 'licenses.txt'), notices.join('\n\n--------------------\n\n'));
