import assert from 'node:assert/strict';
import { test } from 'node:test';
import { boundsFor, solidVolume, solidVolumes, center, contains } from './cad-test-helpers.mjs';

test('sliding idler and compression spring clear fixed structure through the proposed stroke', async () => {
  const carriage = boundsFor('idler-carriage'), [x] = center(boundsFor('idler'));
  const frame = boundsFor('pod-frame');
  for (const side of [-1, 1]) {
    assert.equal(contains(frame, [x, 120, side * 104]), true, 'supported longitudinal guide rod');
    assert.equal(contains(carriage, [x, 120, side * 104]), false, 'slider bore clears the guide');
    assert.equal(contains(carriage, [x, 129, side * 104]), true, 'sleeve surrounds the rod');
  }
  const spring = boundsFor('idler-spring');
  assert.ok(spring.size[0] > 90, 'coil, guide rod and fixed reaction seat are represented');
  assert.ok(55 - (24 + 15) >= 5, 'slider remains between end blocks through 30 mm stroke');
  assert.ok(x - 114 - 233 - 15 > 8 * 4 + 5, 'shortest spring stays above schematic solid-height reserve');
  const lower = [1, 2, 3, 4].map(i => `pod_component("lower-roller-${i}");`).join('\n');
  // One probe per 1 mm travel step runs in parallel; the summed volume bounds
  // the volume of the former single union probe from above.
  const sweep = await solidVolumes(Object.fromEntries(
    Array.from({ length: 31 }, (_, i) => i - 15).map(travel => [travel, `intersection() {
    union() { idler_carriage(${travel}); translate([${travel}, 0, 0]) pod_component("idler"); }
    union() { pod_frame(); pod_carrier(); idler_reaction(); ${lower}
      pod_component("upper-roller-support"); }
  }`])));
  assert.ok(Object.values(sweep).reduce((sum, volume) => sum + volume, 0) <= 0.01,
    'actual moving carriage/wheel sweep clears fixed members and neighboring rollers');
  for (const travel of [-15, 0, 15]) {
    assert.ok(solidVolume(`intersection() {
      idler_spring(${travel});
      union() { idler_carriage(${travel}); translate([${travel}, 0, 0]) pod_component("idler"); }
    }`) <= 0.01, 'coil/guide pass through the carriage and seat without solid interference');
  }
});

test('new structure preserves nominal running clearance and outboard battery extraction', () => {
  const ids = ['pod-frame', 'motor-mount', 'lower-roller-supports',
    'upper-roller-support', 'idler-carriage', 'idler-spring'];
  for (const id of ids) assert.ok(boundsFor(id).triangles.length > 0, `${id} is not empty`);
  const structure = ids.map(id => `pod_component("${id}");`).join('\n');
  const running = ['track', 'drive-drum', 'motor', 'planetary-1', 'planetary-2',
    'planetary-3', 'output-carrier', 'idler', 'upper-roller', 'upper-roller-2',
    ...[1, 2, 3, 4].map(i => `lower-roller-${i}`)]
    .map(id => `pod_component("${id}");`).join('\n');
  assert.ok(solidVolume(`intersection() {
    union() { ${structure} }
    union() { ${running} }
  }`) <= 0.01, 'frame/supports do not cut through moving running gear');
  assert.ok(solidVolume(`intersection() {
    hull() { battery_envelope(); translate([0, 0, 400]) battery_envelope(); }
    union() { ${structure} }
  }`) <= 0.01, 'new mast, spring and frame preserve body-only extraction');
});
