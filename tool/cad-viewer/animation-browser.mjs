import assert from 'node:assert/strict';
import { poseAt } from '../../docs/engineering/presentation/viewer/animation.mjs';

export async function checkAnimation(page, origin, config) {
  const animation = config.animations.find(item => item.id === 'battery-removal');
  const ready = () => page.waitForSelector('#viewport[data-ready="true"]', { state: 'attached' });
  const pose = () => page.evaluate(() => JSON.parse(document.querySelector('canvas').dataset.pose));
  const param = name => new URL(page.url()).searchParams.get(name);
  const expected = t => ({ battery: poseAt(animation, t), 'removal-arrow': poseAt(animation, t) });
  const close = (actual, wanted) => {
    assert.deepEqual(Object.keys(actual).toSorted(), Object.keys(wanted).toSorted());
    for (const id of Object.keys(wanted)) {
      wanted[id].forEach((value, axis) => assert.ok(Math.abs(actual[id][axis] - value) < 0.01,
        `${id} axis ${axis}: ${actual[id][axis]} ~ ${value}`));
    }
  };

  await page.waitForLoadState('networkidle');
  await page.setViewportSize({ width: 1440, height: 1000 });
  await page.goto(`${origin}/?component=motor&mode=engineering`);
  await ready();
  assert.equal(await page.locator('#animation-play').isDisabled(), true, 'no animation selected');
  assert.deepEqual(await pose(), {}, 'assembled pose by default');

  await page.selectOption('#animation', 'battery-removal');
  assert.equal(param('animation'), 'battery-removal');
  assert.equal(param('t'), null);
  assert.equal(param('component'), 'motor', 'animation keeps the inspected component');
  assert.deepEqual(await pose(), {}, 'a newly selected animation starts assembled');

  await page.locator('#animation-progress').fill('500');
  close(await pose(), expected(0.5));
  await page.waitForFunction(() => new URL(location.href).searchParams.get('t') === '0.5');
  await page.reload();
  await ready();
  close(await pose(), expected(0.5));
  assert.equal(await page.locator('#animation-progress').inputValue(), '500', 'reload restores progress');

  await page.locator('#animation-play').click();
  assert.equal(await page.locator('#animation-play').textContent(), 'Pause');
  await page.waitForFunction(() => document.querySelector('canvas').dataset.progress === '1',
    null, { timeout: animation.durationMs * 3 });
  assert.equal(await page.locator('#animation-play').textContent(), 'Replay');
  close(await pose(), expected(1));
  assert.equal(param('t'), '1', 'end of playback is bookmarkable');

  await page.selectOption('#component', 'battery');
  await page.waitForFunction(() => document.querySelector('canvas').dataset.selected === 'battery');
  assert.equal(param('animation'), 'battery-removal', 'inspection keeps the animation');
  close(await pose(), expected(1));
  await page.goBack();
  await page.waitForFunction(() => document.querySelector('canvas').dataset.selected === 'motor');
  assert.equal(param('t'), '1', 'progress changes replace rather than flood history');
  await page.goBack();
  await page.waitForFunction(() => !new URL(location.href).searchParams.has('animation'));
  assert.deepEqual(await pose(), {}, 'Back before the animation reassembles the battery');
  await page.goForward();
  await page.waitForFunction(() => document.querySelector('canvas').dataset.progress === '1');
  close(await pose(), expected(1));

  await page.locator('#animation-play').click();
  await page.waitForFunction(() => Number(document.querySelector('canvas').dataset.progress) < 0.9);
  await page.locator('#animation-play').click();
  assert.equal(await page.locator('#animation-play').textContent(), 'Play', 'Replay restarts and pauses');
  const paused = await page.evaluate(() => document.querySelector('canvas').dataset.progress);
  await page.waitForTimeout(300);
  assert.equal(await page.evaluate(() => document.querySelector('canvas').dataset.progress), paused);

  await page.locator('#assembly').click();
  await page.waitForFunction(() => !new URL(location.href).searchParams.has('animation'));
  assert.deepEqual(await pose(), {}, 'Reset assembly also resets the animation');
  assert.equal(await page.locator('#animation').inputValue(), '');

  await page.goto(`${origin}/?animation=battery-removal&visible=motor`);
  await ready();
  assert.match(await page.locator('#animation-status').textContent(), /hidden/i,
    'hidden animated parts are reported, not silently animated off-screen');
  await page.goto(`${origin}/?visible=motor`);
  await ready();
  assert.equal(await page.locator('#animation-status').textContent(), '');
  await page.selectOption('#animation', 'battery-removal');
  assert.match(await page.locator('#animation-status').textContent(), /hidden/i,
    'choosing an animation with its parts already hidden reports them');
  await page.selectOption('#animation', '');
  assert.equal(await page.locator('#animation-status').textContent(), '',
    'clearing the animation clears the warning');

  const [file, anchor] = animation.document.split('#');
  await page.goto(`${origin}/?doc=${encodeURIComponent(file)}&mode=engineering&layout=docs`);
  await ready();
  await page.locator('#document a[href="/?animation=battery-removal"]').first().click();
  await page.waitForFunction(() => new URL(location.href).searchParams.get('animation') === 'battery-removal');
  await page.waitForFunction(anchor => document.querySelector('#document').dataset.anchor === `#${anchor}`, anchor);
  assert.equal(await page.locator('.model-pane').isVisible(), true, 'animation link opens the model');
  assert.equal(await page.locator('#animation').inputValue(), 'battery-removal');
}
