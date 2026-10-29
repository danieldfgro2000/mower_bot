import assert from 'node:assert/strict';
import { test } from 'node:test';
import { loadConfig } from './assets.mjs';
import { checkDocumentationLinks } from './links.mjs';
import {
  validateAnimations, poseAt, readAnimation, writeAnimation,
} from '../../docs/engineering/presentation/viewer/animation.mjs';

const parts = [{ id: 'box' }, { id: 'arrow' }, { id: 'frame' }];
const valid = {
  id: 'box-removal', label: 'Box removal', durationMs: 1000,
  document: 'docs/a.md#box', components: ['box', 'arrow'],
  keyframes: [{ at: 0, offset: [0, 0, 0] }, { at: 0.5, offset: [0, 10, 0] },
    { at: 1, offset: [0, 10, 100] }],
};

test('battery removal is a validated keyframed animation of the battery and its annotation', () => {
  const config = loadConfig();
  const animation = config.animations.find(item => item.id === 'battery-removal');
  assert.ok(animation, 'battery removal animation is configured');
  for (const id of ['battery', 'battery-tray', 'battery-box', 'controller', 'removal-arrow']) {
    assert.ok(animation.components.includes(id), `${id} follows the service cassette`);
  }
  assert.ok(animation.tracks['tray-lock-pin'], 'pin releases before sliding and reengages at the stop');
  assert.ok(animation.tracks['slide-middle'], 'telescopic middle stages move at half stroke');
  assert.deepEqual(animation.keyframes[0], { at: 0, offset: [0, 0, 0] });
  assert.equal(animation.keyframes.at(-1).at, 1);
  assert.ok(animation.keyframes.at(-1).offset[2] > 0, 'battery leaves outboard (+Z)');
  assert.match(animation.document, /batteries\.md#/);
});

test('invalid animations are rejected instead of silently moving geometry', () => {
  assert.doesNotThrow(() => validateAnimations([valid], parts));
  assert.doesNotThrow(() => validateAnimations(undefined, parts), 'animations are optional');
  const bad = change => () => validateAnimations([{ ...valid, ...change }], parts);
  assert.throws(() => validateAnimations([valid, valid], parts), /duplicate/i);
  assert.throws(bad({ id: 'Bad id' }), /Invalid/);
  assert.throws(bad({ label: '' }), /Invalid/);
  assert.throws(bad({ durationMs: 0 }), /duration/);
  assert.throws(bad({ components: [] }), /components/);
  assert.throws(bad({ components: ['unknown'] }), /Unknown animated component/);
  assert.throws(bad({ keyframes: [valid.keyframes[0]] }), /keyframes/);
  assert.throws(bad({ keyframes: [{ at: 0, offset: [0, 0, 1] }, valid.keyframes[2]] }),
    /assembled position/);
  assert.throws(bad({ keyframes: [valid.keyframes[0], { at: 0.9, offset: [0, 0, 1] }] }), /end at 1/);
  assert.throws(bad({ keyframes: [valid.keyframes[0], valid.keyframes[1], valid.keyframes[1],
    valid.keyframes[2]] }), /increasing/);
  assert.throws(bad({ keyframes: [valid.keyframes[0], { at: 1, offset: [0, 'x', 0] }] }), /offset/);
  assert.throws(bad({ tracks: { missing: valid.keyframes } }), /Unknown animated component/);
  assert.throws(bad({ tracks: { box: valid.keyframes } }), /Duplicate animated component/);
  assert.throws(bad({ tracks: { frame: [{ at: 0, offset: [0, 0, 0] }] } }), /keyframes/);
});

test('poses interpolate linearly between keyframes and clamp to the path ends', () => {
  assert.deepEqual(poseAt(valid, 0), [0, 0, 0]);
  assert.deepEqual(poseAt(valid, 0.25), [0, 5, 0]);
  assert.deepEqual(poseAt(valid, 0.75), [0, 10, 50]);
  assert.deepEqual(poseAt(valid, 1), [0, 10, 100]);
  assert.deepEqual(poseAt(valid, -1), [0, 0, 0]);
  assert.deepEqual(poseAt(valid, 2), [0, 10, 100]);
});

test('animation and progress round-trip through the URL; invalid values are errors', () => {
  const animations = [valid];
  const read = search => readAnimation(new URL(`http://x/${search}`), animations);
  assert.deepEqual(read(''), { id: '', t: 0 });
  assert.deepEqual(read('?animation=box-removal'), { id: 'box-removal', t: 0 });
  assert.deepEqual(read('?animation=box-removal&t=0.5'), { id: 'box-removal', t: 0.5 });
  assert.throws(() => read('?animation=unknown'), /Unknown animation/);
  assert.throws(() => read('?t=0.5'), /without an animation/);
  assert.throws(() => read('?animation=box-removal&t=1.5'), /Invalid animation progress/);
  assert.throws(() => read('?animation=box-removal&t=abc'), /Invalid animation progress/);
  const base = new URL('http://x/?component=box&animation=old&t=0.2');
  const written = writeAnimation(base, { id: 'box-removal', t: 0.123456 });
  assert.equal(written.searchParams.get('t'), '0.123');
  assert.equal(written.searchParams.get('component'), 'box', 'other state is kept');
  assert.equal(writeAnimation(base, { id: 'box-removal', t: 0 }).searchParams.has('t'), false);
  const cleared = writeAnimation(base, { id: '', t: 0.4 });
  assert.equal(cleared.searchParams.has('animation') || cleared.searchParams.has('t'), false);
});

test('Markdown animation links must name a configured animation with an entry point', () => {
  const config = { components: [{ id: 'box' }], animations: [valid] };
  const thumbnail = '[x](viewer/index.html?component=box)';
  assert.deepEqual(checkDocumentationLinks(config,
    { 'a.md': `${thumbnail} [play](viewer/index.html?animation=box-removal)` }), []);
  assert.match(checkDocumentationLinks(config, { 'a.md': thumbnail }).join('\n'),
    /Animation "box-removal" has no Markdown entry point/);
  assert.match(checkDocumentationLinks(config,
    { 'a.md': `${thumbnail} [x](viewer/index.html?animation=nope)` }).join('\n'),
  /unknown animation "nope"/);
});
