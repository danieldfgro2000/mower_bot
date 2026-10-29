import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';

function boundsFor(component) {
  const directory = mkdtempSync(join(tmpdir(), 'mowerbot-cad-test-'));
  try {
    const output = join(directory, 'component.stl');
    execFileSync(process.env.OPENSCAD || 'openscad', [
      '--export-format', 'binstl', '-o', output,
      '-D', `viewer_component="${component}"`,
      'docs/engineering/technical/cad/module-01-track-pod-fit.scad',
    ], { stdio: 'pipe' });
    const data = readFileSync(output);
    const triangles = [];
    const min = [Infinity, Infinity, Infinity];
    const max = [-Infinity, -Infinity, -Infinity];
    for (let triangle = 0; triangle < data.readUInt32LE(80); triangle++) {
      const vertices = [];
      for (let vertex = 0; vertex < 3; vertex++) {
        const point = [];
        for (let axis = 0; axis < 3; axis++) {
          const value = data.readFloatLE(84 + triangle * 50 + 12 + vertex * 12 + axis * 4);
          point.push(value);
          min[axis] = Math.min(min[axis], value);
          max[axis] = Math.max(max[axis], value);
        }
        vertices.push(point);
      }
      triangles.push(vertices);
    }
    return { min, max, triangles, size: max.map((value, axis) => Math.round(value - min[axis])) };
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
}

function contains(mesh, point) {
  const subtract = (a, b) => a.map((value, i) => value - b[i]);
  const dot = (a, b) => a.reduce((sum, value, i) => sum + value * b[i], 0);
  const cross = (a, b) => [
    a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2],
    a[0] * b[1] - a[1] * b[0],
  ];
  const direction = [0.137, 0.263, 1];
  const hits = [];
  for (const [a, b, c] of mesh.triangles) {
    const edge1 = subtract(b, a), edge2 = subtract(c, a);
    const p = cross(direction, edge2);
    const determinant = dot(edge1, p);
    if (Math.abs(determinant) < 1e-8) continue;
    const offset = subtract(point, a);
    const u = dot(offset, p) / determinant;
    if (u < 0 || u > 1) continue;
    const q = cross(offset, edge1);
    const v = dot(direction, q) / determinant;
    if (v < 0 || u + v > 1) continue;
    const distance = dot(edge2, q) / determinant;
    if (distance > 1e-5 && !hits.some(hit => Math.abs(hit - distance) < 1e-4)) hits.push(distance);
  }
  return hits.length % 2 === 1;
}

test('motor includes the published shaft envelope and four mounting openings', () => {
  const motor = boundsFor('motor');
  const { min, max, size } = motor;
  assert.deepEqual(size, [206, 206, 179]);
  assert.ok(max[0] < 0, 'motor remains at the drive end, not recentered for export');
  assert.equal(Math.round(max[2]), 90, 'body starts at the 180 mm drum outboard face');
  const x = (min[0] + max[0]) / 2, y = (min[1] + max[1]) / 2;
  const face = max[2] - 126;
  for (const angle of [45, 135, 225, 315]) {
    const dx = 74 * Math.cos(angle * Math.PI / 180);
    const dy = 74 * Math.sin(angle * Math.PI / 180);
    assert.equal(contains(motor, [x + dx, y + dy, face + 2]), false, `M8 opening at ${angle}`);
    assert.equal(contains(motor, [x + dx + 9, y + dy, face + 2]), true, 'material beside opening');
  }
  assert.equal(contains(motor, [x, y, face - 40]), true, 'shaft extends into reduction');
  assert.equal(contains(motor, [x + 15, y, face - 40]), false, 'shaft is not a full body cylinder');
  assert.equal(contains(motor, [x, y + 10, face - 25]), false, '5 mm keyway is recessed');
});

test('120 mm printed rollers are paired around a guide channel, with bearing recesses', () => {
  const roller = boundsFor('lower-roller-1');
  assert.deepEqual(roller.size, [120, 120, 140]);
  assert.deepEqual(boundsFor('lower-roller-4').size, [120, 120, 140]);
  assert.ok(roller.max[0] < boundsFor('lower-roller-4').min[0]);
  const x = (roller.min[0] + roller.max[0]) / 2, y = (roller.min[1] + roller.max[1]) / 2;
  assert.equal(contains(roller, [x, y + 45, 0]), false, 'central guide channel stays open');
  assert.equal(contains(roller, [x, y + 56, 45]), true, 'TPU tread at each wheel');
  assert.equal(contains(roller, [x, y, 45]), false, '20 mm shaft bore');
  assert.equal(contains(roller, [x, y + 15, 69.5]), false, 'bearing is recessed below outer face');
  assert.equal(contains(roller, [x, y + 15, 65]), true, '6004 bearing envelope');
});

test('track has the candidate width, discrete internal guides and external tread bars', () => {
  const track = boundsFor('track');
  assert.equal(track.size[2], 180);
  const drum = boundsFor('drive-drum');
  const driveX = (drum.min[0] + drum.max[0]) / 2;
  assert.equal(contains(track, [driveX, 20, 0]), true, 'first internal guide lug');
  assert.equal(contains(track, [driveX + 36, 20, 0]), false, 'space between 72 mm guide pitches');
  assert.equal(contains(track, [driveX, 20, 30]), false, 'guides do not span belt width');
  assert.equal(contains(track, [driveX, -13, 45]), true, 'external tread bar');
  assert.equal(contains(drum, [driveX, drum.max[1] - 5, 0]), false, 'drum guide relief');
});

test('idler and battery use current candidate envelopes without concealing the packaging hold', () => {
  const idler = boundsFor('idler');
  assert.deepEqual(idler.size, [200, 200, 150]);
  const x = (idler.min[0] + idler.max[0]) / 2, y = (idler.min[1] + idler.max[1]) / 2;
  assert.equal(contains(idler, [x, y + 70, 0]), false, 'idler guide channel');
  const battery = boundsFor('battery');
  assert.deepEqual(battery.size, [504, 233, 268]);
  const drum = boundsFor('drive-drum');
  const driveX = (drum.min[0] + drum.max[0]) / 2;
  const driveY = (drum.min[1] + drum.max[1]) / 2;
  const spacing = x - driveX;
  const largeRadius = 185, smallRadius = 110, delta = largeRadius - smallRadius;
  const loop = 2 * spacing + Math.PI * (largeRadius + smallRadius)
    + 2 * delta * Math.atan(delta / spacing);
  assert.ok(Math.abs(loop - 72 * 37) < 0.02, 'unequal-radius tangent path closes at 37 pitches');
  assert.equal(driveY - largeRadius, y - smallRadius, 'lower tangencies share the same plane');
  const angle = Math.PI / 2 - 2 * Math.atan(delta / spacing);
  const probeX = 251;
  const innerReturnY = (driveX * Math.cos(angle) + driveY * Math.sin(angle)
    + largeRadius - 10 - probeX * Math.cos(angle)) / Math.sin(angle);
  const probe = [probeX, innerReturnY + 10, 45];
  assert.equal(contains(boundsFor('track'), probe), true, 'sloping upper return at battery corner');
  assert.equal(contains(battery, probe), true, 'battery/return interference remains visible');
  const assembly = boundsFor('assembly');
  assert.ok(assembly.size[0] < 1300 && assembly.size[1] < 450, 'lightweight single-pod study');
});

test('unknown SCAD component names fail instead of producing an assembly', () => {
  assert.throws(() => boundsFor('unknown'), /Command failed/);
});
