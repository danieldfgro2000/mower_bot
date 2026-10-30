import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readFileSync } from 'node:fs';
import { boundsFor, solidVolumes } from './cad-test-helpers.mjs';

test('controller and E-stop contactor stay on a fixed support and the cassette clears fixed gear', async () => {
  const controller = boundsFor('controller');
  assert.deepEqual(controller.size, [164, 70, 200],
    'published 70.47 mm overall depth already includes terminal projections');
  assert.ok(Math.abs(controller.max[1] - controller.min[1] - 70.47) < 0.001,
    'controller is not oversized by adding pads beyond its published envelope');
  assert.equal(controller.min[1], 411, 'fixed 6 mm support plate sits above the battery');
  const battery = boundsFor('battery');
  for (const axis of [0, 2]) {
    assert.ok(Math.abs((controller.min[axis] + controller.max[axis]
      - battery.min[axis] - battery.max[axis]) / 2) <= 0.01,
    `controller is centered over the battery on axis ${axis}`);
  }
  const config = JSON.parse(readFileSync('docs/engineering/presentation/viewer/components.json'));
  const animation = config.animations.find(item => item.id === 'battery-removal');
  const fixed = config.components.map(part => part.id).filter(id =>
    !animation.components.includes(id) && !Object.hasOwn(animation.tracks, id));
  const parts = fixed.map(id => `pod_component("${id}");`).join('\n');
  const runningGear = fixed.filter(id => !['slide-fixed', 'tray-lock-pin'].includes(id))
    .map(id => `pod_component("${id}");`).join('\n');
  const clearanceFixed = fixed.filter(id => !['battery-harness', 'pod-carrier'].includes(id))
    .map(id => `pod_component("${id}");`).join('\n');
  const sweeps = ['battery-tray', 'tray-lock-strike'];
  const frames = ['upper_roller_support()', 'pod_frame()'];
  const stages = [0, 1, 2];
  const volume = await solidVolumes({
    seated: 'intersection() { traction_controller(); controller_support(); }',
    bearing: `intersection() {
    translate([0, -1, 0]) traction_controller(); controller_support();
  }`,
    contactorSeated: 'intersection() { main_contactor(); controller_support(); }',
    contactorBearing: 'intersection() { translate([0, -1, 0]) main_contactor(); controller_support(); }',
    ...Object.fromEntries(frames.map(frame => [frame,
      `intersection() { controller_support(); ${frame}; }`])),
    motor: 'intersection() { traction_controller(); hpm5000b_motor_envelope(-440); }',
    ...Object.fromEntries(sweeps.map(id => [id, `intersection() {
      hull() { pod_component("${id}"); translate([0,0,305]) pod_component("${id}"); }
      union() { ${parts} }
    }`])),
    lift: `intersection() {
    hull() { translate([0,0,305]) battery_envelope(); translate([0,300,305]) battery_envelope(); }
    union() { ${parts} }
  }`,
    margin: `intersection() {
    minkowski() {
      union() {
        hull() { battery_envelope(); translate([0,0,305]) battery_envelope(); }
      }
      // Circumscribe the required 5 mm ball: an inscribed low-poly sphere
      // at radius 5 would under-test clearance between its vertices.
      sphere(r=5.1, $fn=32);
    }
    union() { ${clearanceFixed}
      for (t=[-15,15]) translate([t,0,0]) pod_component("idler");
      for (t=[-15,15]) idler_carriage(t);
    }
  }`,
    pinGuide: `intersection() {
    battery_service_mounts(); union() { ${runningGear.replace('pod_component("pod-frame");', '')} }
  }`,
    ...Object.fromEntries(stages.map(stage => [`stage-${stage}`, `intersection() {
      slide_stage(${stage}, ${stage * 152.5});
      union() { ${runningGear} }
    }`])),
  });
  assert.ok(volume.seated <= 0.01,
    'controller sits on, not inside, its support');
  assert.ok(volume.bearing > 1, 'controller mounting face bears on the fixed support');
  assert.ok(volume.contactorSeated <= 0.01,
    'contactor sits on, not inside, its bracket');
  assert.ok(volume.contactorBearing > 1,
    'contactor is carried by the fixed controller support');
  for (const frame of frames) {
    assert.ok(volume[frame] > 1,
      `controller support is tied to ${frame}, not to the moving cassette`);
  }
  for (const id of ['controller', 'main-contactor', 'battery-harness', 'motor-harness']) {
    const mesh = boundsFor(id);
    assert.ok(mesh.min[2] >= -125 && mesh.max[2] <= 183,
      `${id} stays inside the pod envelope, not on the exposed outer side`);
  }
  assert.equal(volume.motor, 0,
    'the controller terminal side has no solid interference with the motor envelope');
  const physical = config.components.filter(part => part.id !== 'removal-arrow')
    .map(part => boundsFor(part.id));
  assert.equal(Math.max(...physical.map(mesh => mesh.max[2])), 205,
    'the fixed guide and strip, not exposed hardware, set the seated outboard envelope');
  assert.equal(Math.min(...physical.map(mesh => mesh.min[2])), -141,
    'the reinforced front rail is the explicit inboard envelope');
  for (const id of sweeps) {
    assert.ok(volume[id] <= 0.01, `${id} complete linear sweep clears actual fixed gear`);
  }
  assert.ok(volume.lift <= 0.01,
    'with its base fixings released the extracted battery lifts vertically clear');
  assert.ok(volume.margin <= 0.01,
    'battery sweep retains a provisional 5 mm fixed-gear margin');
  assert.ok(volume.pinGuide <= 0.01, 'fixed pin guide does not cut through running gear');
  for (const stage of stages) {
    assert.ok(volume[`stage-${stage}`] <= 0.01,
      `guide stage ${stage} clears running gear, seat and frame throughout travel`);
  }
});
