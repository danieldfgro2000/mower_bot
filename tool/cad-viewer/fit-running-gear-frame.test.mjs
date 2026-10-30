import assert from 'node:assert/strict';
import { test } from 'node:test';
import { boundsFor, solidVolume, center, pitchPath, contains } from './cad-test-helpers.mjs';

test('motor includes the published shaft envelope and four mounting openings', () => {
  const motor = boundsFor('motor');
  const { min, max, size } = motor;
  assert.deepEqual(size, [206, 206, 179]);
  assert.ok(max[0] < 0, 'motor remains at the drive end, not recentered for export');
  assert.equal(Math.round(max[2]), 116, '16 mm reaction plate moves the unchanged motor body outboard');
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
  assert.equal(contains(roller, [x, y + 56, 34.9]), false, '70 mm R2 groove clears the horn pair');
  assert.equal(contains(roller, [x, y + 50, 35.1]), true, '40 mm wheel core begins outside the groove');
  assert.equal(contains(roller, [x, y + 56, 45]), true, 'TPU tread at each wheel');
  assert.equal(contains(roller, [x, y, 45]), false, '20 mm shaft bore');
  assert.equal(contains(roller, [x, y + 15, 74.5]), false, 'bearing is recessed below outer face');
  assert.equal(contains(roller, [x, y + 15, 70]), true, '6004 bearing envelope');
});

test('track follows the R2 profile: twin link horns, centre lands and staggered tread', () => {
  const track = boundsFor('track');
  assert.equal(track.size[2], 200);
  const drum = boundsFor('drive-drum');
  const driveX = (drum.min[0] + drum.max[0]) / 2;
  for (const side of [-1, 1]) {
    assert.equal(contains(track, [driveX, 20, side * 19.5]), true, 'twin trapezoidal horn on the link');
    assert.equal(contains(track, [driveX, 11, side * 28]), true, 'wide horn base');
    assert.equal(contains(track, [driveX, 27, side * 25]), false, 'horn tapers towards its tip');
    assert.equal(contains(track, [driveX + 36, 20, side * 19.5]), false, 'horns only at the 72 mm link pitch');
    assert.equal(contains(track, [driveX, 20, side * 32]), false, 'horns do not span the belt width');
    assert.equal(contains(track, [driveX, 0, side * 60]), true, 'rubber carcass beside the link');
    assert.equal(contains(track, [driveX, -5, side * 85]), true, 'full-depth rubber inside the edge chamfer');
    assert.equal(contains(track, [driveX, -5, side * 98]), false, 'ground-side edge chamfer');
  }
  assert.equal(contains(track, [driveX, 20, 0]), false, 'drive passage between the horn pair');
  assert.equal(contains(track, [driveX, 5, 0]), true, 'metal link land between the horns');
  assert.equal(contains(track, [driveX + 36, 5, 0]), false, 'sprocket window between links');
  assert.equal(contains(track, [driveX, -5, 0]), false, 'open ground-side centre channel');
  assert.equal(contains(track, [driveX, -13, 45]), true, 'outboard tread block on the link');
  assert.equal(contains(track, [driveX, -13, -45]), false, 'tread blocks are staggered');
  assert.equal(contains(track, [driveX + 36, -13, -45]), true, 'inboard tread block between links');
  assert.equal(contains(track, [driveX + 36, -13, 45]), false, 'outboard gap between links');
  assert.equal(contains(drum, [driveX, 185 + 160, 20]), false, 'drum horn passage');
  assert.equal(contains(drum, [driveX, 185 + 170, 50]), true, 'drum running band');
});

test('four-circle 40-link path and two minimum upper returns clear the battery through the idler envelope', () => {
  const idler = boundsFor('idler');
  assert.deepEqual(idler.size, [200, 200, 180]);
  const x = (idler.min[0] + idler.max[0]) / 2, y = (idler.min[1] + idler.max[1]) / 2;
  assert.equal(contains(idler, [x, y + 70, 0]), false, 'idler guide channel');
  const battery = boundsFor('battery');
  assert.deepEqual(battery.size, [504, 233, 268]);
  const drum = boundsFor('drive-drum');
  const upper = boundsFor('upper-roller'), upperRear = boundsFor('upper-roller-2');
  assert.deepEqual(upper.size, [70, 70, 150], 'minimum 70 mm upper roller');
  assert.deepEqual(upperRear.size, [70, 70, 150], 'second minimum upper roller');
  assert.ok(upperRear.max[0] < upper.min[0], 'rear upper roller is behind the front roller');
  assert.ok(upperRear.min[0] < battery.max[0] && upperRear.max[0] > battery.min[0],
    'second upper roller sits above the battery');
  const circles = [[...center(drum).slice(0, 2), 185], [x, y, 110],
    [...center(upper).slice(0, 2), 45], [...center(upperRear).slice(0, 2), 45]];
  const nominal = pitchPath(circles);
  assert.ok(Math.abs(nominal.length - 72 * 40) < 0.02,
    'actual four-circle nominal pitch path closes at 40 pitches');
  for (const i of [1, 3]) {
    const [nx, ny] = nominal.normals[i], [cx, cy, radius] = circles[i];
    const cornerX = nx > 0 ? battery.max[0] : battery.min[0];
    const gap = cx * nx + cy * ny + radius - cornerX * nx - battery.max[1] * ny - 30;
    assert.ok(gap >= 35, 'nominal gap reserves 10 mm motion + 5 deflection + 20 running');
  }
  // Drum teeth set its float32 STL bounds, so compare centres within mesh precision.
  assert.ok(Math.abs(circles[0][1] - 185 - (y - 110)) < 1e-3, 'lower tangencies share the same plane');
  for (let travel = -15; travel <= 15; travel++) {
    const swept = circles.map(circle => [...circle]);
    swept[1][0] += travel;
    const { normals } = pitchPath(swept);
    for (const i of [1, 3]) {
      const [nx, ny] = normals[i], [cx, cy, radius] = swept[i];
      const cornerX = nx > 0 ? battery.max[0] : battery.min[0];
      const gap = cx * nx + cy * ny + radius - cornerX * nx
        - battery.max[1] * ny - 10 - 20;
      assert.ok(gap >= 25, `return at ${travel} mm: ${gap} >= 20 running + 5 deflection reserve`);
    }
  }
  assert.ok(upperRear.min[1] - battery.max[1] >= 20, 'second upper wheel above battery');
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
  assert.deepEqual(tray.size, [650, 10, 288], 'fixed side wings extend the original carrier, not the sliding tray');
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
  assert.equal(contains(idler, [x, y + 75, 34.9]), false, '70 mm tread gap around the 58 mm horn pair');
  assert.equal(contains(idler, [x, y + 75, 35.1]), true, 'catalog 50 mm tread begins outside the gap');
  assert.equal(contains(idler, [x, y + 25, 29.9]), false, '60 mm clear hub gap');
  assert.equal(contains(idler, [x, y + 25, 30.1]), true, 'hub begins outside the clear passage');
});

test('boolean meshes have no forbidden payload, extraction or track-guide intersections', () => {
  assert.ok(solidVolume('intersection() { battery_envelope(); battery_envelope(); }') > 1,
    'positive control proves imported geometry exists');
  const runningGear = ['track', 'drive-drum', 'idler', 'motor', 'planetary-1',
    'planetary-2', 'planetary-3', 'output-carrier', 'lower-roller-1', 'lower-roller-2',
    'lower-roller-3', 'lower-roller-4', 'upper-roller', 'upper-roller-2'];
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
  }`) <= numericalVolume, 'R2 horns, lands and tread clear wheels and drum without solid interference');
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
  assert.deepEqual(mount.size, [290, 290, 16]);
  assert.equal(mount.max[2], motor.max[2] - 126, 'flange is on the motor mounting face');
  assert.equal(mount.min[2] - boundsFor('planetary-1').max[2], 2, 'reducer gap retained');
  const [x, y] = center(motor);
  assert.equal(contains(mount, [x, y, -20]), false, '26 mm central shaft passage');
  for (const angle of [45, 135, 225, 315]) {
    const dx = 74 * Math.cos(angle * Math.PI / 180), dy = 74 * Math.sin(angle * Math.PI / 180);
    assert.equal(contains(mount, [x + dx, y + dy, -15]), false, 'aligned 9 mm clearance hole');
    assert.equal(contains(mount, [x + dx + 6, y + dy, -24]), false, 'head recess, not buried hardware');
    assert.equal(contains(mount, [x + dx + 6, y + dy, -19]), false, '8 mm head recess');
    assert.equal(contains(mount, [x + dx + 6, y + dy, -17]), true, '8 mm material behind counterbore');
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
  const upper = boundsFor('upper-roller-support');
  for (const id of ['upper-roller', 'upper-roller-2']) {
    const wheel = boundsFor(id), [wx] = center(wheel);
    assert.equal(contains(upper, [wx, 443, 0]), true, `${id} U bridge below the wheel`);
    assert.equal(contains(upper, [wx, 300, -111]), true, `${id} mast connects down to the tray frame`);
    assert.equal(contains(upper, center(wheel)), true, `${id} axle in fixed support`);
    assert.ok(wheel.min[1] - 446 >= 5, `${id} bridge running gap`);
  }
  assert.equal(upper.min[2], -116, 'inboard mast overhang is explicit');
});

test('unknown SCAD component names fail instead of producing an assembly', () => {
  assert.throws(() => boundsFor('unknown'), /OpenSCAD failed for unknown/);
});
