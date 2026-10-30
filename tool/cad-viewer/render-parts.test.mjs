import assert from 'node:assert/strict';
import { test } from 'node:test';
import { validateRenderParts } from './assets.mjs';

test('render parts use safe unique model IDs, module names and colors', () => {
  const component = {
    id: 'harness',
    renderParts: [
      { id: 'positive', module: 'positive_harness', color: '#d62218' },
      { id: 'negative', module: 'negative_harness', color: '#101112' },
    ],
  };
  assert.doesNotThrow(() => validateRenderParts([component, { id: 'motor' }]));
  for (const renderParts of [
    null,
    [],
    [{ id: 'motor', module: 'lead', color: '#000000' }],
    [{ id: 'bad/path', module: 'lead', color: '#000000' }],
    [{ id: 'positive', module: 'lead(); bogus', color: '#000000' }],
    [{ id: 'positive', module: 'lead', color: 'black' }],
    [component.renderParts[0], component.renderParts[0]],
  ]) {
    assert.throws(() => validateRenderParts([{ ...component, renderParts }, { id: 'motor' }]));
  }
});
