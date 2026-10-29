import assert from 'node:assert/strict';
import { execFileSync, spawnSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { test } from 'node:test';

const meshes = new Map();
const source = 'docs/engineering/technical/cad/module-01-track-pod-fit.scad';

function boundsFor(component) {
  if (meshes.has(component)) return meshes.get(component);
  const directory = mkdtempSync(join(tmpdir(), 'mowerbot-cad-test-'));
  try {
    const output = join(directory, 'component.stl');
    execFileSync(process.env.OPENSCAD || 'openscad', [
      '--export-format', 'binstl', '-o', output,
      '-D', `viewer_component="${component}"`,
      source,
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
    const mesh = { min, max, triangles, size: max.map((value, axis) => Math.round(value - min[axis])) };
    meshes.set(component, mesh);
    return mesh;
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
}

function solidVolume(body) {
  const directory = mkdtempSync(join(tmpdir(), 'mowerbot-fit-test-'));
  try {
    const output = join(directory, 'probe.stl');
    const result = spawnSync(process.env.OPENSCAD || 'openscad', [
      '--export-format', 'binstl', '-o', output, '-',
    ], { input: `use <${resolve(source)}>;\n$fn = 64;\n${body}`, encoding: 'utf8' });
    assert.ifError(result.error);
    assert.doesNotMatch(result.stderr, /WARNING|ERROR/);
    if (result.status === 1 && result.stderr.includes('Current top level object is empty')) return 0;
    assert.equal(result.status, 0, result.stderr);
    const data = readFileSync(output);
    let volume = 0;
    for (let i = 0; i < data.readUInt32LE(80); i++) {
      const vertices = [0, 1, 2].map(j => [0, 1, 2].map(axis =>
        data.readFloatLE(84 + i * 50 + 12 + j * 12 + axis * 4)));
      const [a, b, c] = vertices;
      volume += a.reduce((sum, value, k) => sum + value
        * (b[(k + 1) % 3] * c[(k + 2) % 3] - b[(k + 2) % 3] * c[(k + 1) % 3]), 0) / 6;
    }
    return Math.abs(volume);
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
}

const center = mesh => mesh.min.map((value, axis) => (value + mesh.max[axis]) / 2);

function pitchPath(circles) {
  const normals = circles.map((a, i) => {
    const b = circles[(i + 1) % circles.length];
    const dx = b[0] - a[0], dy = b[1] - a[1], distance = Math.hypot(dx, dy);
    const k = (a[2] - b[2]) / distance, q = Math.sqrt(1 - k * k);
    return [(dx * k + dy * q) / distance, (dy * k - dx * q) / distance];
  });
  const length = circles.reduce((total, a, i) => {
    const b = circles[(i + 1) % circles.length];
    const incoming = normals[(i + circles.length - 1) % circles.length];
    const outgoing = normals[i];
    const arc = (Math.atan2(outgoing[1], outgoing[0])
      - Math.atan2(incoming[1], incoming[0]) + 2 * Math.PI) % (2 * Math.PI);
    return total + Math.sqrt((b[0] - a[0]) ** 2 + (b[1] - a[1]) ** 2
      - (b[2] - a[2]) ** 2) + a[2] * arc;
  }, 0);
  return { normals, length };
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
  assert.equal(Math.round(max[2]), 100, 'body starts at the 200 mm drum outboard face');
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
  assert.deepEqual(roller.size, [120, 120, 150]);
  assert.deepEqual(boundsFor('lower-roller-4').size, [120, 120, 150]);
  assert.ok(roller.max[0] < boundsFor('lower-roller-4').min[0]);
  const x = (roller.min[0] + roller.max[0]) / 2, y = (roller.min[1] + roller.max[1]) / 2;
  assert.equal(contains(roller, [x, y + 45, 0]), false, 'central guide channel stays open');
  assert.equal(contains(roller, [x, y + 56, 45]), true, 'TPU tread at each wheel');
  assert.equal(contains(roller, [x, y, 45]), false, '20 mm shaft bore');
  assert.equal(contains(roller, [x, y + 15, 74.5]), false, 'bearing is recessed below outer face');
  assert.equal(contains(roller, [x, y + 15, 70]), true, '6004 bearing envelope');
});

test('track has the candidate width, discrete internal guides and external tread bars', () => {
  const track = boundsFor('track');
  assert.equal(track.size[2], 200);
  const drum = boundsFor('drive-drum');
  const driveX = (drum.min[0] + drum.max[0]) / 2;
  assert.equal(contains(track, [driveX, 20, 0]), true, 'first internal guide lug');
  assert.equal(contains(track, [driveX + 36, 20, 0]), false, 'space between 72 mm guide pitches');
  assert.equal(contains(track, [driveX, 20, 30]), false, 'guides do not span belt width');
  assert.equal(contains(track, [driveX, -13, 45]), true, 'external tread bar');
  assert.equal(contains(drum, [driveX, drum.max[1] - 5, 0]), false, 'drum guide relief');
});

test('three-circle 40-link path clears the unchanged battery through the provisional return sweep', () => {
  const idler = boundsFor('idler');
  assert.deepEqual(idler.size, [200, 200, 160]);
  const x = (idler.min[0] + idler.max[0]) / 2, y = (idler.min[1] + idler.max[1]) / 2;
  assert.equal(contains(idler, [x, y + 70, 0]), false, 'idler guide channel');
  const battery = boundsFor('battery');
  assert.deepEqual(battery.size, [504, 233, 268]);
  const drum = boundsFor('drive-drum');
  const upper = boundsFor('upper-roller');
  assert.deepEqual(upper.size, [120, 120, 150]);
  const circles = [[...center(drum).slice(0, 2), 185], [x, y, 110],
    [...center(upper).slice(0, 2), 70]];
  const nominal = pitchPath(circles);
  assert.ok(Math.abs(nominal.length - 72 * 40) < 0.02,
    'actual three-circle nominal pitch path closes at 40 pitches');
  for (const i of [1, 2]) {
    const [nx, ny] = nominal.normals[i], [cx, cy, radius] = circles[i];
    const cornerX = nx > 0 ? battery.max[0] : battery.min[0];
    const gap = cx * nx + cy * ny + radius - cornerX * nx - battery.max[1] * ny - 30;
    assert.ok(gap >= 35, 'nominal gap reserves 10 mm motion + 5 deflection + 20 running');
  }
  assert.equal(circles[0][1] - 185, y - 110, 'lower tangencies share the same plane');
  for (let travel = -10; travel <= 10; travel++) {
    const swept = circles.map(circle => [...circle]);
    swept[2][1] += travel;
    const { normals } = pitchPath(swept);
    for (const i of [1, 2]) {
      const [nx, ny] = normals[i], [cx, cy, radius] = swept[i];
      const cornerX = nx > 0 ? battery.max[0] : battery.min[0];
      const gap = cx * nx + cy * ny + radius - cornerX * nx
        - battery.max[1] * ny - 10 - 20;
      assert.ok(gap >= 25, `return at ${travel} mm: ${gap} >= 20 running + 5 deflection reserve`);
    }
    assert.ok(upper.min[1] + travel - battery.max[1] >= 20, 'upper wheel sweep above battery');
  }
  for (const wheel of [drum, idler]) {
    const [cx, cy] = center(wheel);
    const distance = Math.hypot(Math.max(battery.min[0] - cx, 0, cx - battery.max[0]),
      Math.max(battery.min[1] - cy, 0, cy - battery.max[1])) - wheel.size[1] / 2;
    assert.ok(distance >= 20, `battery to end wheel: ${distance} >= 20`);
  }
});

test('tray, roller spacing, guide passage and reducer stack retain positive margins', () => {
  const tray = boundsFor('pod-carrier'), battery = boundsFor('battery');
  assert.deepEqual(tray.size, [524, 10, 288]);
  assert.equal(tray.min[2], -100, 'no tray overhang into the inboard adjustment space');
  assert.equal(battery.min[2] - tray.min[2], 10);
  assert.equal(tray.max[2] - battery.max[2], 10);
  let previous;
  for (let i = 1; i <= 4; i++) {
    const roller = boundsFor(`lower-roller-${i}`);
    assert.ok(tray.min[1] - roller.max[1] >= 10, 'roller to tray running gap');
    if (previous) assert.ok(roller.min[0] - previous.max[0] >= 10, 'adjacent roller separation');
    previous = roller;
  }
  const drum = boundsFor('drive-drum'), carrier = boundsFor('output-carrier');
  assert.ok(carrier.min[2] - drum.min[2] >= 5, 'internal axial remainder is not negative');
  let prior = boundsFor('motor');
  for (const id of ['planetary-1', 'planetary-2', 'planetary-3', 'output-carrier']) {
    const current = boundsFor(id);
    // The motor shaft shares the sun bores; use the published body mounting face.
    const previousFace = id === 'planetary-1' ? prior.max[2] - 126 : prior.min[2];
    assert.ok(previousFace - current.max[2] >= 2, 'separate schematic axial envelopes');
    prior = current;
  }
  const idler = boundsFor('idler'), [x, y] = center(idler);
  assert.equal(contains(idler, [x, y + 25, 19.9]), false, '40 mm clear hub gap around 24 mm guide');
  assert.equal(contains(idler, [x, y + 25, 20.1]), true, 'hub begins outside the clear passage');
});

test('boolean meshes have no forbidden payload, extraction or track-guide intersections', () => {
  assert.ok(solidVolume('intersection() { battery_envelope(); battery_envelope(); }') > 1,
    'positive control proves imported geometry exists');
  const runningGear = ['track', 'drive-drum', 'idler', 'motor', 'planetary-1',
    'planetary-2', 'planetary-3', 'output-carrier', 'lower-roller-1', 'lower-roller-2',
    'lower-roller-3', 'lower-roller-4', 'upper-roller'];
  const parts = ids => ids.map(id => `pod_component("${id}");`).join('\n');
  // Coincident running contacts can leave float32 STL shells below 0.01 mm³.
  const numericalVolume = 0.01;
  assert.ok(solidVolume(`intersection() {
    union() { battery_envelope(); pod_carrier(); }
    union() { ${parts(runningGear)} }
  }`) <= numericalVolume, 'payload and tray clear actual gear/track material, not just bounding boxes');
  assert.ok(solidVolume(`intersection() {
    hull() { battery_envelope(); translate([0, 0, 400]) battery_envelope(); }
    union() { ${parts(runningGear)} }
  }`) <= numericalVolume, 'outboard body extraction is clear of all represented running gear');
  assert.ok(solidVolume(`intersection() {
    pod_component("track");
    union() { ${parts(runningGear.filter(id => id !== 'track'))} }
  }`) <= numericalVolume, 'guide lugs pass through wheels and drum without solid interference');
  assert.ok(solidVolume(`intersection() {
    pod_component("motor");
    union() { ${parts(['planetary-1', 'planetary-2', 'planetary-3', 'output-carrier'])} }
  }`) <= numericalVolume, 'shaft clears schematic suns and output carrier');
  const assembly = boundsFor('assembly');
  assert.ok(assembly.size[0] < 1300 && assembly.size[1] < 620, 'bounded single-pod study');
});

test('unknown SCAD component names fail instead of producing an assembly', () => {
  assert.throws(() => boundsFor('unknown'), /Command failed/);
});
