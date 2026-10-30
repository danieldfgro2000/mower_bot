import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readFileSync } from 'node:fs';
import { groupComponents } from '../../docs/engineering/presentation/viewer/visibility.mjs';
import { poseAt } from '../../docs/engineering/presentation/viewer/animation.mjs';
import { boundsFor, solidVolume } from './cad-test-helpers.mjs';

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
