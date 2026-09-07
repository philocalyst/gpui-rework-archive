import { chromium } from 'playwright';
const out = '/private/tmp/claude-501/-Users-mileswirht-projects-gpui-ce3/28cb9ab6-2e91-40ae-9b5f-133c15b6b9af/scratchpad/shots';
import { mkdirSync } from 'node:fs'; mkdirSync(out, { recursive: true });
const browser = await chromium.launch();
const pages = process.argv.slice(2);
for (const spec of pages) {
  const [path, width = '1440', full = 'full'] = spec.split('@');
  const ctx = await browser.newContext({ viewport: { width: Number(width), height: 900 }, deviceScaleFactor: 1 });
  const page = await ctx.newPage();
  const errors = [];
  page.on('pageerror', e => errors.push('pageerror: ' + e.message));
  page.on('console', m => { if (m.type() === 'error') errors.push('console: ' + m.text()); });
  await page.goto('http://127.0.0.1:1111' + path, { waitUntil: 'networkidle' });
  await page.waitForTimeout(1500);
  const name = (path.replace(/[^a-z0-9]+/gi, '_') || 'home') + '_' + width;
  await page.screenshot({ path: `${out}/${name}.png`, fullPage: full === 'full' });
  const h = await page.evaluate(() => ({ scrollW: document.documentElement.scrollWidth, innerW: innerWidth, h: document.documentElement.scrollHeight }));
  console.log(name, JSON.stringify(h), errors.slice(0, 5).join(' | '));
  await ctx.close();
}
await browser.close();
