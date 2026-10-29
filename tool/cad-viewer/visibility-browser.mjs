import assert from 'node:assert/strict';

export async function checkVisibility(page, origin, config) {
  await page.goto(origin);
  await page.waitForSelector('#viewport[data-ready="true"]');
  const moduleBox = id => page.locator(`input[data-group="${id}"]`);
  const partBox = id => page.locator(`input[data-part="${id}"]`);
  const visible = () => page.locator('canvas').getAttribute('data-visible')
    .then(value => JSON.parse(value).sort());
  assert.equal(await moduleBox('structure-and-running-gear').count(), 1,
    'module visibility tree is present');
  await page.locator('#hide-all').click();
  assert.deepEqual(await visible(), []);
  await moduleBox('drive-train').check();
  const drive = ['motor', 'planetary-1', 'planetary-2', 'planetary-3', 'output-carrier'].sort();
  assert.deepEqual(await visible(), drive);
  await moduleBox('battery-and-charging').check();
  assert.deepEqual(await visible(), [...drive, 'battery'].sort());
  await partBox('planetary-2').uncheck();
  assert.equal(await moduleBox('drive-train').evaluate(input => input.indeterminate), true);
  assert.equal(await moduleBox('reducer').evaluate(input => input.indeterminate), true);
  await page.locator('[data-only-group="lower-rollers"]').click();
  const lower = ['lower-roller-1', 'lower-roller-2', 'lower-roller-3',
    'lower-roller-4', 'lower-roller-supports'].sort();
  assert.deepEqual(await visible(), lower);
  await partBox('lower-roller-2').uncheck();
  const subset = lower.filter(id => id !== 'lower-roller-2');
  await page.selectOption('#component', 'motor');
  assert.deepEqual(await visible(), subset, 'inspection does not replace the displayed set');
  await page.locator('#isolate').check();
  assert.deepEqual(await visible(), ['motor'], 'isolation can temporarily inspect a hidden part');
  await page.reload();
  await page.waitForSelector('#viewport[data-ready="true"]');
  assert.deepEqual(await visible(), ['motor'], 'bookmark restores temporary isolation');
  await page.locator('#isolate').uncheck();
  assert.deepEqual(await visible(), subset, 'leaving isolation restores the exact custom display');
  await page.locator('#isolate').check();
  await partBox('battery').check();
  assert.equal(await page.locator('#isolate').isChecked(), false);
  assert.deepEqual(await visible(), [...subset, 'battery'].sort(),
    'checkbox edits leave temporary isolation without losing the underlying custom set');
  await partBox('battery').uncheck();
  await page.selectOption('#mode', 'engineering');
  await page.waitForFunction(() => document.querySelector('#document').dataset.path.includes('propulsion.md'));
  assert.deepEqual(await visible(), subset);
  await page.locator('#document a').filter({ hasText: 'Mounting to the track' }).first().click();
  await page.waitForFunction(() => document.querySelector('#document').dataset.anchor === '#motor-to-track-mounting');
  assert.deepEqual(await visible(), subset, 'documentation links preserve display settings');
  await page.locator('header a').filter({ hasText: 'Viewer guide' }).click();
  await page.waitForFunction(() => document.querySelector('#document').dataset.path
    === 'docs/engineering/technical/cad/README.md');
  assert.deepEqual(await visible(), subset, 'header guide navigation preserves display settings');
  await page.reload();
  await page.waitForSelector('#viewport[data-ready="true"]');
  assert.deepEqual(await visible(), subset, 'reload restores URL visibility');
  await page.locator('#show-all').click();
  assert.equal((await visible()).length, config.components.length);
  await page.goBack();
  await page.waitForFunction(count => JSON.parse(document.querySelector('canvas').dataset.visible).length === count,
    subset.length);
  assert.deepEqual(await visible(), subset, 'Back restores custom display');
  await page.goForward();
  await page.waitForFunction(count => JSON.parse(document.querySelector('canvas').dataset.visible).length === count,
    config.components.length);
  await page.locator('#component-search').fill('spring');
  assert.equal(await page.locator('[data-component-row="idler-spring"]').isVisible(), true);
  assert.equal(await page.locator('[data-component-row="motor"]').isVisible(), false);
  assert.equal((await visible()).length, config.components.length, 'search filters the list, not the geometry');
  await page.locator('#component-search').fill('');
  await page.locator('[data-only-part="battery"]').click();
  assert.deepEqual(await visible(), ['battery']);
  await page.locator('#fit-visible').click();
  await page.locator('#hide-all').click();
  assert.equal(await page.locator('#fit-visible').isDisabled(), true);
  assert.match(await page.locator('#visibility-status').textContent(), /0 of/);
  await page.reload();
  await page.waitForSelector('#viewport[data-ready="true"]');
  assert.deepEqual(await visible(), [], 'explicit empty display survives reload');
  await page.locator('#assembly').click();
  assert.equal((await visible()).length, config.components.length);
  assert.equal(await page.locator('#component').inputValue(), '');
  await page.waitForFunction(() => !new URL(location.href).searchParams.has('component'));
  await page.selectOption('#mode', 'engineering');
  await page.waitForFunction(() => document.querySelector('#document').dataset.path
    === 'docs/engineering/technical/cad/README.md');
  let release, intercepted;
  const gate = new Promise(resolve => { release = resolve; });
  const started = new Promise(resolve => { intercepted = resolve; });
  await page.route('**/api/document?path=*propulsion.md', async route => {
    intercepted();
    await gate;
    await route.continue();
  });
  await page.selectOption('#component', 'motor');
  await started;
  await partBox('battery').uncheck();
  const response = page.waitForResponse(item => item.url().includes('propulsion.md'));
  release();
  await response;
  await page.waitForFunction(() => document.querySelector('#document').dataset.path.includes('propulsion.md'));
  assert.equal(new URL(page.url()).searchParams.get('component'), 'motor',
    'visibility changes during a slow document request preserve the inspected part in history');
  assert.deepEqual(await visible(), config.components.map(part => part.id).filter(id => id !== 'battery').sort());
  await page.unroute('**/api/document?path=*propulsion.md');
  await page.locator('#assembly').click();
}
