import assert from 'node:assert/strict';

export async function checkLayout(page, origin) {
  // Let the previous check's document request finish before leaving the page.
  await page.waitForLoadState('networkidle');
  await page.setViewportSize({ width: 1440, height: 1000 });
  await page.goto(`${origin}/?component=battery&visible=motor,battery&mode=engineering`);
  await page.waitForSelector('#viewport[data-ready="true"]', { state: 'attached' });
  const shown = selector => page.locator(selector).isVisible();
  const width = selector => page.locator(selector).boundingBox().then(box => box?.width ?? 0);
  const pressed = id => page.locator(`#layout-${id}`).getAttribute('aria-pressed');
  const param = name => new URL(page.url()).searchParams.get(name);

  assert.equal(await pressed('split'), 'true', 'split view is the default');
  const splitCanvas = await width('canvas');
  await page.locator('#layout-cad').click();
  assert.equal(await shown('.document-pane'), false, 'CAD focus collapses documentation');
  await page.waitForFunction(previous =>
    document.querySelector('canvas').getBoundingClientRect().width > previous * 1.5, splitCanvas);
  assert.equal(await pressed('cad'), 'true');
  assert.equal(param('layout'), 'cad');
  assert.equal(param('component'), 'battery', 'layout keeps the inspected part');
  assert.equal(param('visible'), 'motor,battery', 'layout keeps the display set');

  await page.selectOption('#component', 'motor');
  await page.waitForFunction(() => document.querySelector('canvas').dataset.selected === 'motor');
  assert.equal(param('layout'), 'cad', 'inspection does not leave CAD focus');
  await page.reload();
  await page.waitForSelector('#viewport[data-ready="true"]', { state: 'attached' });
  assert.equal(await shown('.document-pane'), false, 'reload restores CAD focus');

  await page.locator('#layout-docs').click();
  assert.equal(await shown('.model-pane'), false, 'documentation focus collapses the CAD pane');
  assert.ok(await width('.document-pane') > 1300, 'documentation uses the full width');
  assert.equal(param('layout'), 'docs');
  // Navigating while the canvas is collapsed must not corrupt the camera aspect.
  await page.locator('#document a').filter({ hasText: 'Mounting to the track' }).first().click();
  await page.waitForFunction(() => document.querySelector('#document').dataset.anchor
    === '#motor-to-track-mounting');
  assert.equal(param('layout'), 'docs', 'documentation links keep documentation focus');

  await page.goBack();
  await page.waitForFunction(() => new URL(location.href).searchParams.get('layout') === 'docs'
    && document.querySelector('#document').dataset.anchor === '#hpm5000b-main-motor-candidate');
  await page.goBack();
  await page.waitForFunction(() => new URL(location.href).searchParams.get('layout') === 'cad');
  assert.equal(await shown('.document-pane'), false, 'Back restores the previous layout');
  await page.goForward();
  await page.waitForFunction(() => new URL(location.href).searchParams.get('layout') === 'docs');

  await page.goto(`${origin}/?doc=docs%2Fengineering%2Ftechnical%2Fmodules%2F04-battery-and-charging%2Fbatteries.md&mode=engineering&layout=docs`);
  await page.waitForSelector('#viewport[data-ready="true"]', { state: 'attached' });
  await page.locator('#document a[href="/?component=removal-arrow"]').first().click();
  await page.waitForFunction(() => document.querySelector('canvas').dataset.selected === 'removal-arrow');
  assert.equal(await shown('.model-pane'), true, '3D thumbnail reopens the model from documentation focus');
  assert.equal(await shown('.document-pane'), true);
  assert.equal(param('layout'), null, 'thumbnail opens split view');
  const box = await page.locator('canvas').boundingBox();
  assert.ok(box.width > 300 && box.height > 200, 'canvas regains a usable size');
  assert.equal(await page.evaluate(() => document.querySelector('canvas').dataset.camera), 'finite',
    'fit while collapsed leaves a usable camera');

  await page.locator('#layout-split').click();
  assert.equal(await pressed('split'), 'true');

  for (const layout of ['cad', 'docs']) {
    await page.setViewportSize({ width: 390, height: 844 });
    await page.goto(`${origin}/?layout=${layout}`);
    await page.waitForSelector('#viewport[data-ready="true"]', { state: 'attached' });
    assert.equal(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), true,
      `${layout} focus fits a narrow screen`);
    assert.equal(await shown(`#layout-${layout === 'cad' ? 'docs' : 'cad'}`), true, 'layout remains switchable');
  }
  await page.setViewportSize({ width: 1440, height: 1000 });
}
