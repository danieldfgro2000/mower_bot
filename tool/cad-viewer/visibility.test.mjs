import assert from 'node:assert/strict';
import { test } from 'node:test';
import { loadConfig } from './assets.mjs';
import {
  validateGroups, readDisplay, writeDisplay, displayedIds,
} from '../../docs/engineering/presentation/viewer/visibility.mjs';

test('viewer groups cover every component once under engineering modules and subassemblies', () => {
  const config = loadConfig();
  assert.ok(Array.isArray(config.groups), 'explicit module hierarchy is present');
  const ids = [];
  const collect = group => {
    assert.ok(group.id && group.label);
    ids.push(...(group.components || []));
    for (const child of group.children || []) collect(child);
  };
  config.groups.forEach(collect);
  assert.deepEqual(ids.toSorted(), config.components.map(part => part.id).toSorted());
  assert.deepEqual(config.groups.map(group => group.id),
    ['structure-and-running-gear', 'drive-train', 'battery-and-charging', 'power-harnesses', 'annotations']);
});

test('invalid grouping cannot leave missing, duplicate or unknown geometry in the tree', () => {
  const parts = [{ id: 'a' }, { id: 'b' }];
  const leaf = { id: 'group', label: 'Group', components: ['a', 'b'] };
  assert.doesNotThrow(() => validateGroups([leaf], parts));
  assert.throws(() => validateGroups([], parts), /Missing component groups/);
  assert.throws(() => validateGroups([{ ...leaf, components: ['a'] }], parts), /Every component/);
  assert.throws(() => validateGroups([{ ...leaf, components: ['a', 'a'] }], parts), /repeated/);
  assert.throws(() => validateGroups([{ ...leaf, components: ['a', 'unknown'] }], parts), /Unknown/);
  assert.throws(() => validateGroups([leaf, leaf], parts), /duplicate component group/);
  assert.throws(() => validateGroups([{ ...leaf, children: [] }], parts), /components or children/);
});

test('visibility URL distinguishes all, none and subsets while preserving documentation and isolation', () => {
  const ids = ['a', 'b', 'c'];
  const url = new URL('http://localhost/?component=c&doc=guide.md&mode=engineering#section');
  assert.deepEqual([...readDisplay(url, ids).visible], ids);
  for (const visible of [new Set(ids), new Set(), new Set(['b', 'a'])]) {
    const state = { visible, isolated: true };
    const written = writeDisplay(url, state, ids);
    assert.equal(written.hash, '#section');
    assert.equal(written.searchParams.get('doc'), 'guide.md');
    assert.equal(written.searchParams.get('component'), 'c');
    assert.equal(written.searchParams.get('mode'), 'engineering');
    const restored = readDisplay(written, ids);
    assert.deepEqual([...restored.visible], ids.filter(id => visible.has(id)));
    assert.equal(restored.isolated, true);
    assert.deepEqual(displayedIds(ids, restored, 'c'), ['c']);
    assert.deepEqual(displayedIds(ids, { ...restored, isolated: false }, 'c'),
      ids.filter(id => visible.has(id)));
  }
  assert.equal(writeDisplay(url, { visible: new Set(), isolated: false }, ids)
    .searchParams.get('visible'), '');
  assert.throws(() => readDisplay(new URL('http://localhost/?visible=unknown'), ids), /Unknown visible/);
  assert.throws(() => readDisplay(new URL('http://localhost/?visible=a,,b'), ids), /Unknown visible/);
  assert.throws(() => readDisplay(new URL('http://localhost/?isolate=no'), ids), /Invalid isolate/);
});
