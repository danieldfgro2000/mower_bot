import assert from 'node:assert/strict';
import { existsSync } from 'node:fs';
import { chromium } from 'playwright';
import { createViewerServer } from './server.mjs';
import { loadConfig } from './assets.mjs';
import { checkVisibility } from './visibility-browser.mjs';
import { checkLayout } from './layout-browser.mjs';
import { checkAnimation } from './animation-browser.mjs';

const server = createViewerServer();
await new Promise(resolve => server.listen(0, '127.0.0.1', resolve));
const origin = `http://127.0.0.1:${server.address().port}`;
const macChrome = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const executablePath = process.env.CHROME_PATH || (existsSync(macChrome) ? macChrome : undefined);
let browser;
try {
  browser = await chromium.launch({ executablePath, headless: true });
  const page = await browser.newPage({ viewport: { width: 1440, height: 1000 } });
  const errors = [];
  page.on('pageerror', error => errors.push(error.message));
  page.on('console', message => { if (message.type() === 'error') errors.push(message.text()); });
  const failures = [];
  page.on('response', response => { if (response.status() >= 400) failures.push(response.url()); });
  await page.goto(origin);
  await page.waitForSelector('#viewport[data-ready="true"]');

  // The mode toggle switches the same component between pitch and technical detail.
  await page.goto(`${origin}/?component=track&mode=presentation`);
  await page.waitForSelector('#viewport[data-ready="true"]');
  await page.waitForFunction(() => document.querySelector('#document').dataset.path
    === 'docs/engineering/presentation/parts.md');
  await page.waitForFunction(() => document.querySelector('#document').dataset.anchor === '#track');
  await page.selectOption('#mode', 'engineering');
  await page.waitForFunction(() => new URL(location.href).searchParams.get('mode') === 'engineering');
  await page.waitForFunction(() => document.querySelector('#document').dataset.path
    === 'docs/engineering/technical/modules/01-structure-and-running-gear/running-gear.md');
  await page.waitForFunction(() => document.querySelector('#document').dataset.anchor
    === '#pod-fit-cad-assumptions');
  await page.selectOption('#mode', 'presentation');
  await page.waitForFunction(() => document.querySelector('#document').dataset.anchor === '#track');

  // Markdown thumbnail -> selected geometry and the current engineering section.
  await page.goto(`${origin}/?doc=docs%2Fengineering%2Ftechnical%2Fcad%2FREADME.md&mode=engineering`);
  await page.waitForFunction(() => document.querySelector('#document').dataset.path
    === 'docs/engineering/technical/cad/README.md');
  await page.locator('#document a[href="/?component=motor"]').click();
  await page.waitForFunction(() => document.querySelector('canvas').dataset.selected === 'motor');
  await page.waitForFunction(() => document.querySelector('#document').dataset.anchor
    === '#hpm5000b-main-motor-candidate');
  assert.equal(await page.locator('#component').inputValue(), 'motor');

  // A real raycast on the isolated motor returns to its section from another section.
  await page.locator('#isolate').check();
  await page.locator('#document a').filter({ hasText: 'Mounting to the track' }).first().click();
  await page.waitForFunction(() => document.querySelector('#document').dataset.anchor === '#motor-to-track-mounting');
  const viewport = await page.locator('canvas').boundingBox();
  await page.mouse.click(viewport.x + viewport.width / 2, viewport.y + viewport.height / 2);
  await page.waitForFunction(() => document.querySelector('#document').dataset.anchor
    === '#hpm5000b-main-motor-candidate');

  // Every separately exported mesh has a reachable, rendered documentation section.
  for (const component of loadConfig().components) {
    await page.selectOption('#mode', 'presentation');
    await page.selectOption('#component', component.id);
    await page.waitForFunction(id => document.querySelector('canvas').dataset.selected === id, component.id);
    const [file, fragment] = component.presentation.split('#');
    await page.waitForFunction(({ file, fragment }) => {
      const article = document.querySelector('#document');
      return article.dataset.path === file && article.dataset.anchor === `#${fragment}`;
    }, { file, fragment });
    const box = await page.locator(`#document [id="${fragment}"]`).boundingBox();
    const article = await page.locator('#document').boundingBox();
    assert.ok(box.y >= article.y - 2 && box.y < article.y + article.height,
      `${component.id} scrolls to the target section`);
  }

  // The logical battery harness retains one selection but visibly renders both polarities.
  await page.goto(`${origin}/?visible=battery-harness`);
  await page.waitForSelector('#viewport[data-ready="true"]');
  const inspectWirePixels = async () => page.evaluate(async png => {
    const image = new Image();
    image.src = `data:image/png;base64,${png}`;
    await image.decode();
    const canvas = document.createElement('canvas');
    canvas.width = image.width;
    canvas.height = image.height;
    const context = canvas.getContext('2d');
    context.drawImage(image, 0, 0);
    const pixels = context.getImageData(0, 0, image.width, image.height).data;
    let red = 0, black = 0, redPoint, blackPoint;
    const colorAt = (x, y) => {
      const i = (y * image.width + x) * 4;
      return [pixels[i], pixels[i + 1], pixels[i + 2]];
    };
    const isRed = ([r, g, b]) => r > 110 && r > g * 1.5 && r > b * 1.5;
    const isBlack = rgb => Math.max(...rgb) < 120 && Math.max(...rgb) - Math.min(...rgb) < 15;
    for (let i = 0; i < pixels.length; i += 4) {
      const [r, g, b] = [pixels[i], pixels[i + 1], pixels[i + 2]];
      const x = (i / 4) % image.width, y = Math.floor(i / 4 / image.width);
      const redPixel = isRed([r, g, b]), blackPixel = isBlack([r, g, b]);
      if (redPixel) red++;
      if (blackPixel) black++;
      if (x < 2 || y < 2 || x >= image.width - 2 || y >= image.height - 2) continue;
      const interior = predicate => [[0, 0], [-2, 0], [2, 0], [0, -2], [0, 2]]
        .every(([dx, dy]) => predicate(colorAt(x + dx, y + dy)));
      if (redPixel && !redPoint && interior(isRed)) redPoint = [x, y];
      if (blackPixel && !blackPoint && interior(isBlack)) blackPoint = [x, y];
    }
    return { red, black, redPoint, blackPoint, width: image.width, height: image.height };
  }, (await page.locator('#viewport canvas').screenshot()).toString('base64'));
  const wirePixels = await inspectWirePixels();
  assert.ok(wirePixels.red > 20, `battery positive is visibly red (${wirePixels.red} pixels)`);
  assert.ok(wirePixels.black > 20, `battery negative is visibly black (${wirePixels.black} pixels)`);
  const wireCanvas = await page.locator('#viewport canvas').boundingBox();
  for (const [label, point] of [['red', wirePixels.redPoint], ['black', wirePixels.blackPoint]]) {
    assert.ok(point, `${label} lead has a clickable interior`);
    await page.mouse.click(wireCanvas.x + point[0] * wireCanvas.width / wirePixels.width,
      wireCanvas.y + point[1] * wireCanvas.height / wirePixels.height);
    await page.waitForFunction(() => document.querySelector('canvas').dataset.selected === 'battery-harness');
    await page.waitForFunction(() => new URL(location.href).searchParams.get('component') === 'battery-harness');
    await page.goto(`${origin}/?visible=battery-harness`);
    await page.waitForSelector('#viewport[data-ready="true"]');
  }
  await page.goto(`${origin}/?component=battery-harness&isolate=1`);
  await page.waitForSelector('#viewport[data-ready="true"]');
  const selectedWires = await inspectWirePixels();
  assert.ok(selectedWires.red > 20, `selected battery positive stays red (${selectedWires.red} pixels)`);
  assert.ok(selectedWires.black > 20, `selected battery negative stays black (${selectedWires.black} pixels)`);

  // Reload/bookmark, Back/Forward, invalid selection, missing docs and narrow layout.
  await page.goto(`${origin}/?component=motor`);
  await page.waitForSelector('#viewport[data-ready="true"]');
  await page.selectOption('#component', 'battery');
  await page.waitForFunction(() => document.querySelector('#document').dataset.anchor === '#battery');
  await page.goBack();
  await page.waitForFunction(() => document.querySelector('canvas').dataset.selected === 'motor');
  await page.goForward();
  await page.waitForFunction(() => document.querySelector('canvas').dataset.selected === 'battery');
  await page.selectOption('#mode', 'engineering');

  // A slow previous document must not overwrite the latest address or selection.
  let release;
  const gate = new Promise(resolve => { release = resolve; });
  let intercepted;
  const started = new Promise(resolve => { intercepted = resolve; });
  await page.route('**/api/document?path=*propulsion.md', async route => {
    intercepted();
    await gate;
    await route.continue();
  });
  await page.selectOption('#component', 'motor');
  await started;
  await page.selectOption('#component', 'track');
  await page.waitForFunction(() => document.querySelector('#document').dataset.anchor === '#pod-fit-cad-assumptions');
  const delayedResponse = page.waitForResponse(response => response.url().includes('propulsion.md'));
  release();
  await delayedResponse;
  await page.evaluate(() => new Promise(resolve => requestAnimationFrame(() => requestAnimationFrame(resolve))));
  assert.equal(new URL(page.url()).searchParams.get('component'), 'track');
  assert.equal(await page.locator('#component').inputValue(), 'track');
  await page.unroute('**/api/document?path=*propulsion.md');

  await checkVisibility(page, origin, loadConfig());
  await checkLayout(page, origin);
  await checkAnimation(page, origin, loadConfig());

  await page.setViewportSize({ width: 390, height: 844 });
  await page.waitForFunction(() => document.documentElement.scrollWidth <= innerWidth);
  assert.equal(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), true);
  assert.equal((await page.request.get(`${origin}/files/arduino/MowerESP32/secrets.h`)).status(), 404);
  assert.equal((await page.request.get(`${origin}/api/document?path=../../.git/config`)).status(), 400);
  assert.deepEqual(errors, []);
  assert.deepEqual(failures, []);
  await page.goto(`${origin}/?component=does-not-exist`);
  await page.waitForSelector('#error:not([hidden])');
  assert.match(await page.locator('#error').textContent(), /Unknown component/);
  await page.goto(`${origin}/?visible=does-not-exist`);
  await page.waitForSelector('#error:not([hidden])');
  assert.match(await page.locator('#error').textContent(), /Unknown visible component/);
  await page.goto(`${origin}/?isolate=no`);
  await page.waitForSelector('#error:not([hidden])');
  assert.match(await page.locator('#error').textContent(), /Invalid isolate/);
  await page.goto(`${origin}/?layout=wide`);
  await page.waitForSelector('#error:not([hidden])');
  assert.match(await page.locator('#error').textContent(), /Invalid layout/);
  await page.goto(`${origin}/?animation=does-not-exist`);
  await page.waitForSelector('#error:not([hidden])');
  assert.match(await page.locator('#error').textContent(), /Unknown animation/);
  await page.goto(`${origin}/?t=0.5`);
  await page.waitForSelector('#error:not([hidden])');
  assert.match(await page.locator('#error').textContent(), /without an animation/);
  await page.goto(`${origin}/?doc=docs%2Fdoes-not-exist.md`);
  await page.waitForSelector('#error:not([hidden])');
  assert.match(await page.locator('#error').textContent(), /404: File not found/);
  console.log(`Browser checks passed: grouped visibility, isolation restore, display bookmarks/history, split/focus layouts, battery removal animation, thumbnails, mesh raycast, all ${loadConfig().components.length} routes, rapid navigation, errors and mobile layout`);
} finally {
  await browser?.close();
  await new Promise(resolve => server.close(resolve));
}
