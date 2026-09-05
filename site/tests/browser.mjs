import { chromium } from 'playwright';
import assert from 'node:assert/strict';
import { spawn } from 'node:child_process';
import { mkdir } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const root = fileURLToPath(new URL('..', import.meta.url));
const origin = process.env.SITE_URL || 'http://127.0.0.1:1112';
const server = process.env.SITE_URL ? null : spawn('zola', ['--root', root, 'serve', '--interface', '127.0.0.1', '--port', '1112'], { stdio: 'pipe' });
let browser;
try {
  for (let attempt = 0; attempt < 100; attempt++) {
    try { if ((await fetch(origin)).ok) break; } catch {}
    if (attempt === 99) throw new Error('Zola preview did not start');
    await new Promise(resolve => setTimeout(resolve, 100));
  }
  browser = await chromium.launch(process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE ? { executablePath: process.env.PLAYWRIGHT_CHROMIUM_EXECUTABLE } : {});
  const context = await browser.newContext({ viewport: { width: 1440, height: 900 }, deviceScaleFactor: 1 });
  const errors = [];
  const page = await context.newPage();
  page.on('pageerror', error => errors.push(error.message));
  page.on('console', message => { if (message.type() === 'error') errors.push(message.text()); });
  page.on('response', response => { if (response.status() >= 400) errors.push(`${response.status()} ${response.url()}`); });
  await page.addInitScript(() => {
    window.fieldSamples = [];
    const names = new WeakMap();
    const locate = WebGLRenderingContext.prototype.getUniformLocation;
    const write = WebGLRenderingContext.prototype.uniform1f;
    WebGLRenderingContext.prototype.getUniformLocation = function(program, name) {
      const location = locate.call(this, program, name);
      if (location) names.set(location, name);
      return location;
    };
    WebGLRenderingContext.prototype.uniform1f = function(location, value) {
      if (this.canvas.matches('[data-field]') && names.get(location) === 'phase') window.fieldSamples.push({ value, time: performance.now() });
      return write.call(this, location, value);
    };
  });
  await page.goto(origin, { waitUntil: 'networkidle' });
  await page.locator('gpui-playground[data-ready=true]').waitFor();
  await page.locator('[data-motion]:not([hidden])').waitFor();
  await page.locator('[data-delta="1"]:not([disabled])').waitFor({ timeout: 60000 });
  const gpuCanvas = page.frameLocator('iframe[data-gpui]').locator('canvas');
  await gpuCanvas.waitFor();
  const initialGpu = await gpuCanvas.screenshot();
  await page.locator('[data-delta="1"]').click();
  await page.waitForFunction(() => document.querySelector('[data-count]').value === '1');
  const changedGpu = await gpuCanvas.screenshot();
  assert(!initialGpu.equals(changedGpu), 'The actual GPUI canvas must redraw after a state change');
  await page.locator('[data-delta="1"]').focus();
  await page.keyboard.press('Space');
  await page.waitForFunction(() => document.querySelector('[data-count]').value === '2');
  await page.locator('[data-view=source]').click();
  assert(await page.locator('[data-panel=source]').isVisible());
  await page.locator('[data-view=result]').click();
  assert.equal(await page.locator('[data-count]').evaluate(element => element.value), '2', 'GPUI state must survive a source/result switch');
  await page.locator('[data-reset]').click();
  await page.waitForFunction(() => document.querySelector('[data-count]').value === '0');
  await page.waitForFunction(() => window.fieldSamples.length > 5);
  const sampleRate = async () => {
    await page.evaluate(() => { window.fieldSamples = []; });
    await page.waitForTimeout(600);
    return page.evaluate(() => {
      const a = window.fieldSamples[0], b = window.fieldSamples.at(-1);
      return (b.value - a.value) / (b.time - a.time);
    });
  };
  const idle = await sampleRate();
  await page.locator('[data-accelerate]').hover();
  await page.waitForTimeout(600);
  const engaged = await sampleRate();
  assert(engaged > idle * 2, 'Get started should accelerate the real GPU shader');
  await page.locator('[data-motion]').click();
  const paused = await page.evaluate(() => window.fieldSamples.length);
  await page.waitForTimeout(200);
  assert.equal(await page.evaluate(() => window.fieldSamples.length), paused, 'Pause must stop background rendering');

  await mkdir(path.join(root, '.preview'), { recursive: true });
  for (const width of [320, 390, 768, 1024, 1440]) {
    await page.setViewportSize({ width, height: 900 });
    await page.waitForTimeout(120);
    assert(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), `Home overflows at ${width}px`);
    if (width >= 1024) {
      const bottom = await page.locator('body > footer').evaluate(element => element.getBoundingClientRect().bottom);
      assert(bottom <= 900, `Landing page must fit one desktop screen at ${width}px; footer is at ${bottom}`);
    }
    if (width === 390 || width === 1440) await page.screenshot({ path: path.join(root, `.preview/home-${width}.png`), fullPage: true });
  }

  await page.goto(`${origin}/examples/layout/`, { waitUntil: 'networkidle' });
  await page.locator('gpui-playground[data-ready=true]').waitFor();
  const range = page.locator('gpui-playground input[type=range]');
  await range.focus();
  await page.keyboard.press('Home');
  assert.match(await page.locator('[data-measurement]').innerText(), /260px.*column/i);
  await page.keyboard.press('End');
  assert.match(await page.locator('[data-measurement]').innerText(), /680px.*spacious row/i);
  await page.locator('[data-view=source]').click();
  assert(await page.locator('[data-panel=source]').isVisible());
  await page.locator('[data-view=result]').click();
  assert.equal(await range.inputValue(), '680', 'Source toggle must preserve experiment state');
  await page.locator('[data-reset]').click();
  assert.equal(await range.inputValue(), '480');

  await page.goto(`${origin}/examples/interaction/`, { waitUntil: 'networkidle' });
  await page.locator('gpui-playground[data-ready=true]').waitFor();
  await page.locator('[data-interaction]').focus();
  await page.keyboard.down('Space');
  assert.equal(await page.locator('output[data-state]').textContent(), 'Pressed');
  await page.keyboard.up('Space');
  assert.equal(await page.locator('output[data-state]').textContent(), 'Activated');
  await page.locator('[data-reset]').click();
  assert.equal(await page.locator('output[data-state]').textContent(), 'Idle');

  for (const width of [320, 768, 1440]) {
    await page.setViewportSize({ width, height: 900 });
    await page.goto(`${origin}/guide/getting-started/counter-tutorial/`, { waitUntil: 'networkidle' });
    assert(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), `Article overflows at ${width}px`);
  }
  await page.screenshot({ path: path.join(root, '.preview/counter-tutorial.png'), fullPage: true });
  assert.deepEqual(errors, [], 'Pages should load without broken resources or runtime errors');

  const quiet = await browser.newContext({ reducedMotion: 'reduce' });
  const quietPage = await quiet.newPage();
  await quietPage.goto(origin, { waitUntil: 'networkidle' });
  await quietPage.locator('[data-motion]:not([hidden])').waitFor();
  assert.equal(await quietPage.locator('[data-motion]').getAttribute('aria-pressed'), 'true');
  assert.match(await quietPage.locator('[data-motion]').innerText(), /Play/i);
  await quiet.close();

  const staticContext = await browser.newContext({ javaScriptEnabled: false });
  const staticPage = await staticContext.newPage();
  await staticPage.goto(`${origin}/examples/layout/`);
  assert(await staticPage.locator('[data-panel=source]').isVisible(), 'Source must remain readable without JavaScript');
  assert(await staticPage.locator('h1').isVisible());
  await staticContext.close();
  console.log('Browser checks passed: compact desktop layout, five widths, live shader acceleration/pause, WASM studies, source/result, reduced motion, and no-JS reading.');
} finally {
  if (browser) await browser.close();
  server?.kill();
}
