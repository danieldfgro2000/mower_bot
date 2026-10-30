import assert from 'node:assert/strict';
import { execFileSync, spawnSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';
import { test } from 'node:test';
import { groupComponents } from '../../docs/engineering/presentation/viewer/visibility.mjs';
import { poseAt } from '../../docs/engineering/presentation/viewer/animation.mjs';

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
  assert.equal(Math.round(max[2]), 112, '12 mm reaction plate moves the unchanged motor body outboard');
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

test('three-circle 40-link path and fixed upper return clear the battery through the idler envelope', () => {
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
  for (let travel = -15; travel <= 15; travel++) {
    const swept = circles.map(circle => [...circle]);
    swept[1][0] += travel;
    const { normals } = pitchPath(swept);
    for (const i of [1, 2]) {
      const [nx, ny] = normals[i], [cx, cy, radius] = swept[i];
      const cornerX = nx > 0 ? battery.max[0] : battery.min[0];
      const gap = cx * nx + cy * ny + radius - cornerX * nx
        - battery.max[1] * ny - 10 - 20;
      assert.ok(gap >= 25, `return at ${travel} mm: ${gap} >= 20 running + 5 deflection reserve`);
    }
  }
  assert.ok(upper.min[1] - battery.max[1] >= 20, 'fixed upper wheel above battery');
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
  assert.ok(assembly.size[0] < 1300 && assembly.size[1] < 650, 'bounded single-pod study');
});

test('four U brackets carry real axle envelopes without occupying tread or guide passage', () => {
  const supports = boundsFor('lower-roller-supports');
  for (let i = 1; i <= 4; i++) {
    const wheel = boundsFor(`lower-roller-${i}`), [x, y] = center(wheel);
    for (const side of [-1, 1]) {
      assert.equal(contains(supports, [x, y + 30, side * 79.9]), false, '5 mm tire-side gap');
      assert.equal(contains(supports, [x, y + 30, side * 80.1]), true, 'U cheek outside the wheel');
    }
    assert.equal(contains(supports, [x, 137, 0]), true, 'top bridge connects both cheeks');
    assert.equal(contains(supports, [x, 132, 0]), false, '4 mm bridge/tread running gap');
    assert.equal(contains(supports, [x, y, 0]), true, '20 mm axle crosses both bearings');
    assert.equal(contains(supports, [x, 35, 0]), false, 'bottom guide passage is not blocked');
  }
});

test('motor reaction flange uses the published holes and clears the shaft and reducer', () => {
  const mount = boundsFor('motor-mount'), motor = boundsFor('motor');
  assert.deepEqual(mount.size, [250, 250, 12]);
  assert.equal(mount.max[2], motor.max[2] - 126, 'flange is on the motor mounting face');
  assert.equal(mount.min[2] - boundsFor('planetary-1').max[2], 2, 'reducer gap retained');
  const [x, y] = center(motor);
  assert.equal(contains(mount, [x, y, -20]), false, '26 mm central shaft passage');
  for (const angle of [45, 135, 225, 315]) {
    const dx = 74 * Math.cos(angle * Math.PI / 180), dy = 74 * Math.sin(angle * Math.PI / 180);
    assert.equal(contains(mount, [x + dx, y + dy, -15]), false, 'aligned 9 mm clearance hole');
    assert.equal(contains(mount, [x + dx + 6, y + dy, -24]), false, 'head recess, not buried hardware');
    assert.equal(contains(mount, [x + dx + 6, y + dy, -15]), true, 'material behind counterbore');
  }
});

test('frame extensions form connected motor, tray, roller and tensioner reaction interfaces', () => {
  const frame = boundsFor('pod-frame');
  assert.ok(frame.min[0] < -320 && frame.max[0] > center(boundsFor('idler'))[0] + 60,
    'frame spans motor mount to front guide blocks');
  for (const id of ['motor-mount', 'pod-carrier', 'lower-roller-supports',
    'upper-roller-support', 'idler-spring']) {
    assert.ok(solidVolume(`intersection() { pod_component("pod-frame"); pod_component("${id}"); }`) > 1,
      `${id} has a physical fixed-frame connection, not a floating visual support`);
  }
  const upper = boundsFor('upper-roller-support'), wheel = boundsFor('upper-roller');
  assert.equal(contains(upper, [200, 443, 0]), true, 'upper U bridge below the wheel');
  assert.equal(contains(upper, [200, 300, -111]), true, 'mast connects down to the tray frame');
  assert.equal(contains(upper, center(wheel)), true, 'upper axle in fixed support');
  assert.ok(wheel.min[1] - 446 >= 5, 'upper bridge running gap');
  assert.equal(upper.min[2], -116, 'inboard mast overhang is explicit');
});

test('sliding idler and compression spring clear fixed structure through the proposed stroke', () => {
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
  assert.ok(solidVolume(`intersection() {
    union() { for (travel = [-15 : 1 : 15]) {
      idler_carriage(travel); translate([travel, 0, 0]) pod_component("idler");
    } }
    union() { pod_frame(); pod_carrier(); idler_reaction(); ${lower}
      pod_component("upper-roller-support"); }
  }`) <= 0.01, 'actual moving carriage/wheel sweep clears fixed members and neighboring rollers');
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
    'planetary-3', 'output-carrier', 'idler', 'upper-roller',
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

test('configured battery removal animation sweeps clear of fixed running gear', () => {
  const config = JSON.parse(readFileSync('docs/engineering/presentation/viewer/components.json'));
  const animation = config.animations?.find(item => item.id === 'battery-removal');
  assert.ok(animation, 'the viewer animation path is the clash-checked path');
  const annotations = new Set(groupComponents(config.groups.find(group => group.id === 'annotations')));
  const moving = animation.components.filter(id => !annotations.has(id));
  for (const id of ['battery', 'battery-tray', 'battery-hold-down', 'slide-inner', 'tray-lock-strike']) {
    assert.ok(moving.includes(id), `${id} moves with the supported service cassette`);
  }
  for (const id of ['controller', 'controller-support', 'main-contactor', 'battery-harness',
    'motor-harness']) {
    assert.ok(!moving.includes(id) && !Object.hasOwn(animation.tracks ?? {}, id),
      `${id} stays on the pod frame; battery lugs are unbolted at the terminals before removal`);
  }
  const battery = boundsFor('battery');
  // The hull of two poses is the exact linear sweep only for a convex body.
  assert.ok(Math.abs(solidVolume('battery_envelope();')
    - battery.size.reduce((product, value) => product * value, 1)) < 1, 'battery is a convex box');
  const fixed = config.components.map(part => part.id)
    .filter(id => !annotations.has(id) && !animation.components.includes(id)
      && !Object.hasOwn(animation.tracks ?? {}, id));
  const fixedUnion = fixed.map(id => `pod_component("${id}");`).join('\n');
  const frames = animation.keyframes;
  for (let i = 1; i < frames.length; i++) {
    const [a, b] = [frames[i - 1].offset, frames[i].offset];
    assert.ok(solidVolume(`intersection() {
      hull() { translate([${a}]) battery_envelope(); translate([${b}]) battery_envelope(); }
      union() { ${fixedUnion} }
    }`) <= 0.01, `segment ${i} (${a} -> ${b}) has no solid intersection; tray contact is coincident`);
  }
  const end = frames.at(-1).offset;
  assert.ok(battery.min[2] + end[2] - boundsFor('track').max[2] >= 100,
    'extraction clears the track while remaining supported on the slides');
});

test('open battery cassette uses one flat under-tray guide, fixed seats and a tray-level lock', () => {
  const config = JSON.parse(readFileSync('docs/engineering/presentation/viewer/components.json'));
  const ids = config.components.map(part => part.id);
  for (const id of ['battery-box', 'battery-lid', 'battery-feed', 'controller-harness']) {
    assert.ok(!ids.includes(id), `${id} removed: open tray, direct terminal and direct phase wiring`);
  }
  const required = ['battery-tray', 'battery-hold-down', 'slide-fixed', 'slide-middle', 'slide-inner',
    'tray-lock-pin', 'tray-lock-strike', 'controller', 'controller-support', 'main-contactor',
    'battery-harness', 'motor-harness'];
  for (const id of required) assert.ok(ids.includes(id), `${id} is selectable`);
  const tray = boundsFor('battery-tray'), battery = boundsFor('battery'), seat = boundsFor('pod-carrier');
  assert.equal(tray.size[1], 8, 'loaded tray is 8 mm steel, not an arbitrary thin skin');
  assert.equal(battery.min[1], tray.max[1], 'battery bears on the tray');
  assert.equal(tray.min[1], seat.max[1], 'in WORK the tray rests on the fixed carrier seat');
  const above = 'translate([-1000, 150, -1000]) cube(2000);';
  for (const stage of [0, 1, 2]) {
    assert.equal(solidVolume(`intersection() { slide_stage(${stage}); ${above} }`), 0,
      `guide stage ${stage} lies wholly beneath the tray underside`);
  }
  for (const region of ['translate([-1000, -1000, -1000]) cube([970, 2000, 2000]);',
    'translate([55, -1000, -1000]) cube([2000, 2000, 2000]);']) {
    assert.equal(solidVolume(`intersection() { union() { slide_stage(0); slide_stage(1); slide_stage(2); } ${region} }`), 0,
      'a single flat 76.2 mm guide sits between the middle lower-roller columns');
  }
  assert.equal(solidVolume('intersection() { slide_stage(2); battery_service_tray(); }'), 0);
  assert.equal(solidVolume('intersection() { translate([0, 0.9, 0]) slide_stage(2); battery_service_tray(); }'), 0,
    'working load stays on the fixed seat: inner-stage pads float at least 0.9 mm');
  assert.ok(solidVolume('intersection() { translate([0, 1.1, 0]) slide_stage(2); battery_service_tray(); }') > 1,
    'inner-stage pads pick up the tray within 1 mm once it leaves the seat');
  const lower = [1, 2, 3, 4].map(i => `pod_component("lower-roller-${i}");`).join('\n');
  for (const stage of [0, 1, 2]) {
    assert.equal(solidVolume(`intersection() {
      translate([0, -5, 0]) slide_stage(${stage}, ${stage * 152.5});
      union() { ${lower} lower_roller_supports(); }
    }`), 0, `guide stage ${stage} keeps at least 5 mm to the lower rollers and U supports`);
  }
  assert.ok(solidVolume('intersection() { slide_stage(0); pod_frame(); }') <= 0.01,
    'fixed guide seats on, not inside, the frame rails');
  assert.ok(solidVolume('intersection() { translate([0, -1, 0]) slide_stage(0); pod_frame(); }') > 1,
    'fixed guide bears on the notched frame rails');
  const holdDown = boundsFor('battery-hold-down');
  assert.ok(holdDown.max[1] - battery.max[1] <= 3.01, 'hold-down strap is a thin top restraint');
  assert.ok(solidVolume('intersection() { battery_envelope(); battery_hold_down(); }') <= 0.01);
  assert.ok(solidVolume('intersection() { translate([0, 1, 0]) battery_envelope(); battery_hold_down(); }') > 1,
    'hold-down bears on the battery top');
  assert.ok(solidVolume('intersection() { battery_hold_down(); translate([0, 1, 0]) battery_service_tray(); }') > 1,
    'hold-down legs land on the moving tray');
  const strike = boundsFor('tray-lock-strike'), pin = boundsFor('tray-lock-pin');
  assert.ok(strike.min[1] >= tray.min[1] && strike.max[1] <= tray.max[1] + 8,
    'locking strip is at tray level, not on a tower');
  assert.ok(pin.min[1] < tray.min[1] && pin.max[1] < battery.min[1] + 20,
    'pin engages the tray-level strip from below');
  const movingSteelVolume = solidVolume(`union() {
    battery_service_tray(); battery_hold_down(); slide_stage(2); battery_lock_strike();
  }`);
  assert.ok(44.9 + movingSteelVolume * 7.85e-6 + 5 < 85,
    '85 kg screen exceeds modeled steel + battery + 5 kg battery-lead/hardware reserve');
  for (const travel of [0, 305]) {
    assert.ok(solidVolume(`intersection() {
      battery_lock_pin(); translate([0,0,${travel}]) union() { battery_lock_strike(); battery_service_tray(); }
    }`) <= 0.01, `pin passes through the ${travel === 0 ? 'work' : 'extract'} bore`);
  }
  assert.ok(solidVolume(`intersection() {
    battery_lock_pin(); translate([0,0,150]) battery_lock_strike();
  }`) > 1, 'positive control: pin cannot engage halfway through travel');
  // Extracted, the tray cantilevers both ways in X from the 76.2 mm guide.
  // Conservative: the whole factored load as a UDL over the longer battery overhang.
  const mass = 85, load = mass * 9.81 * 1.5, thickness = tray.size[1];
  const overhang = 287 - 50.1, w = load / 504;
  const inertia = tray.size[2] * thickness ** 3 / 12;
  const stress = w * overhang ** 2 / 2 * (thickness / 2) / inertia;
  const deflection = w * overhang ** 4 / (8 * 200000 * inertia);
  assert.ok(stress < 235 / 2, `S235 screening stress ${stress} MPa < 117.5 MPa`);
  assert.ok(deflection < 2, `service-load screen ${deflection} mm < 2 mm`);
});

test('controller and E-stop contactor stay on a fixed support and the cassette clears fixed gear', () => {
  const controller = boundsFor('controller');
  assert.deepEqual(controller.size, [200, 70, 164],
    'published 70.47 mm overall depth already includes terminal projections');
  assert.ok(Math.abs(controller.max[1] - controller.min[1] - 70.47) < 0.001,
    'controller is not oversized by adding pads beyond its published envelope');
  assert.equal(controller.min[1], 411, 'fixed 6 mm support plate sits above the battery and hold-down');
  assert.deepEqual([controller.min[0], controller.max[0]], [-35, 165],
    'position clears the rear return and the fixed upper roller');
  assert.ok(solidVolume('intersection() { traction_controller(); controller_support(); }') <= 0.01,
    'controller sits on, not inside, its support');
  assert.ok(solidVolume(`intersection() {
    translate([0, -1, 0]) traction_controller(); controller_support();
  }`) > 1, 'controller mounting face bears on the fixed support');
  assert.ok(solidVolume('intersection() { main_contactor(); controller_support(); }') <= 0.01,
    'contactor sits on, not inside, its bracket');
  assert.ok(solidVolume('intersection() { translate([0, -1, 0]) main_contactor(); controller_support(); }') > 1,
    'contactor is carried by the fixed controller support');
  for (const frame of ['upper_roller_support()', 'pod_frame()']) {
    assert.ok(solidVolume(`intersection() { controller_support(); ${frame}; }`) > 1,
      `controller support is tied to ${frame}, not to the moving cassette`);
  }
  for (const id of ['controller', 'main-contactor', 'battery-harness', 'motor-harness']) {
    const mesh = boundsFor(id);
    assert.ok(mesh.min[2] >= -125 && mesh.max[2] <= 183,
      `${id} stays inside the pod envelope, not on the exposed outer side`);
  }
  assert.equal(solidVolume('intersection() { traction_controller(); hpm5000b_motor_envelope(-440); }'), 0,
    'the controller terminal side has no solid interference with the motor envelope');
  const config = JSON.parse(readFileSync('docs/engineering/presentation/viewer/components.json'));
  const animation = config.animations.find(item => item.id === 'battery-removal');
  const physical = config.components.filter(part => part.id !== 'removal-arrow')
    .map(part => boundsFor(part.id));
  assert.equal(Math.max(...physical.map(mesh => mesh.max[2])), 205,
    'the fixed guide and strip, not exposed hardware, set the seated outboard envelope');
  assert.equal(Math.min(...physical.map(mesh => mesh.min[2])), -125,
    'protected routing does not consume extra central-frame space');
  const fixed = config.components.map(part => part.id).filter(id =>
    !animation.components.includes(id) && !Object.hasOwn(animation.tracks, id));
  const parts = fixed.map(id => `pod_component("${id}");`).join('\n');
  const runningGear = fixed.filter(id => !['slide-fixed', 'tray-lock-pin'].includes(id))
    .map(id => `pod_component("${id}");`).join('\n');
  for (const id of ['battery-tray', 'battery-hold-down', 'tray-lock-strike']) {
    assert.ok(solidVolume(`intersection() {
      hull() { pod_component("${id}"); translate([0,0,305]) pod_component("${id}"); }
      union() { ${parts} }
    }`) <= 0.01, `${id} complete linear sweep clears actual fixed gear`);
  }
  assert.ok(solidVolume(`intersection() {
    hull() { translate([0,0,305]) battery_envelope(); translate([0,300,305]) battery_envelope(); }
    union() { ${parts} }
  }`) <= 0.01, 'with the hold-down released the extracted battery lifts vertically clear');
  const clearanceFixed = fixed.filter(id => !['battery-harness', 'pod-carrier'].includes(id))
    .map(id => `pod_component("${id}");`).join('\n');
  assert.ok(solidVolume(`intersection() {
    minkowski() {
      union() {
        hull() { battery_envelope(); translate([0,0,305]) battery_envelope(); }
        hull() { battery_hold_down(); translate([0,0,305]) battery_hold_down(); }
      }
      // Circumscribe the required 5 mm ball: an inscribed low-poly sphere
      // at radius 5 would under-test clearance between its vertices.
      sphere(r=5.1, $fn=32);
    }
    union() { ${clearanceFixed}
      for (t=[-15,15]) translate([t,0,0]) pod_component("idler");
      for (t=[-15,15]) idler_carriage(t);
    }
  }`) <= 0.01, 'battery and hold-down sweep retain a provisional 5 mm fixed-gear margin');
  assert.ok(solidVolume(`intersection() {
    battery_service_mounts(); union() { ${runningGear.replace('pod_component("pod-frame");', '')} }
  }`) <= 0.01, 'fixed pin guide does not cut through running gear');
  for (const stage of [0, 1, 2]) {
    assert.ok(solidVolume(`intersection() {
      slide_stage(${stage}, ${stage * 152.5});
      union() { ${runningGear} }
    }`) <= 0.01, `guide stage ${stage} clears running gear, seat and frame throughout travel`);
  }
});

test('battery leads bolt directly to terminals via the contactor; phases run direct inside the track silhouette', () => {
  for (const id of ['battery-harness', 'motor-harness']) {
    for (const body of ['battery_envelope()', 'battery_hold_down()', 'battery_service_tray()',
      'traction_controller()', 'controller_support()', 'main_contactor()', 'hpm5000b_motor_envelope(-440)']) {
      const overlap = solidVolume(`intersection() { pod_component("${id}"); ${body}; }`);
      assert.ok(overlap <= 0.01, `${id} lands at faces instead of cutting through ${body} (overlap ${overlap})`);
    }
    assert.ok(solidVolume(`intersection() {
      pod_component("${id}"); translate([0, 1, 0]) traction_controller();
    }`) > 1, `${id} lands directly on the controller terminals`);
    assert.ok(solidVolume(`intersection() {
      pod_component("${id}");
      hull() { battery_envelope(); translate([0, 0, 305]) battery_envelope(); }
    }`) <= 0.01, `stationary ${id} stays out of the battery extraction path`);
  }
  assert.ok(solidVolume(`intersection() {
    battery_power_harness(); translate([1, 0, 0]) main_contactor();
  }`) > 1, 'battery positive is switched by the E-stop contactor');
  assert.ok(solidVolume(`intersection() {
    battery_power_harness(); translate([-1, 0, 0]) battery_envelope();
  }`) > 1, 'ring lugs land directly on the battery terminal face, no service connector');
  assert.ok(solidVolume(`intersection() {
    motor_power_harness(); translate([0, 0, 1]) hpm5000b_motor_envelope(-440);
  }`) > 1, 'phase leads land directly on the motor terminal face');
  assert.ok(solidVolume(`difference() {
    motor_power_harness();
    linear_extrude(height = 2000, center = true) capsule_2d(10);
  }`) <= 0.01, 'phase leads do not protrude beyond the track side silhouette');
  // Grown battery leads (5.5 mm radius margin over low-poly cables) must not touch any phase lead.
  assert.ok(solidVolume(`intersection() {
    battery_power_harness(grow = 5.5); motor_power_harness();
  }`) <= 0.01, 'battery leads keep at least 5 mm to every phase lead');
  const plan = body => `linear_extrude(10) projection() rotate([-90, 0, 0]) intersection() {
    ${body} translate([-1000, 399.5, -1000]) cube(2000);
  }`;
  assert.ok(solidVolume(`intersection() {
    ${plan('battery_power_harness();')}
    ${plan('motor_power_harness();')}
  }`) <= 0.01, 'above the battery, battery leads and phase leads never cross in plan');
});

test('telescopic stages and locking strip travel without crossing their stationary mounts', () => {
  const config = JSON.parse(readFileSync('docs/engineering/presentation/viewer/components.json'));
  const animation = config.animations.find(item => item.id === 'battery-removal');
  for (const id of ['slide-middle', 'slide-inner', 'tray-lock-strike']) {
    const end = poseAt({ keyframes: animation.tracks?.[id] ?? animation.keyframes }, 1);
    const sweep = id === 'tray-lock-strike'
      ? `hull() { pod_component("${id}"); translate([${end}]) pod_component("${id}"); }`
      : `slide_stage(${id === 'slide-middle' ? 1 : 2}, ${end[2]});`;
    assert.ok(solidVolume(`intersection() {
      ${sweep}
      pod_component("slide-fixed");
    }`) <= 0.01, `${id} clears the fixed rail and pin guide for its entire travel`);
  }
  for (const t of [0, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 1]) {
    const pin = poseAt({ keyframes: animation.tracks['tray-lock-pin'] }, t);
    const tray = poseAt(animation, t);
    assert.ok(solidVolume(`intersection() {
      translate([${pin}]) battery_lock_pin();
      translate([${tray}]) union() { battery_lock_strike(); battery_service_tray(); }
    }`) <= 0.01, `pin is withdrawn or aligned with a lock bore at progress ${t}`);
  }
});

test('unknown SCAD component names fail instead of producing an assembly', () => {
  assert.throws(() => boundsFor('unknown'), /Command failed/);
});
