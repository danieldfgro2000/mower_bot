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
  const plate = boundsFor('controller-support');
  assert.deepEqual([plate.min[1], plate.max[1]], [405, 411],
    'one flat 6 mm electrical plate carries the controller, contactor and E-stop');
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
  // Plate joints: rear and front inboard masts, rear and front outboard posts.
  const joints = {
    'rear mast': [[-215, 400, -120], [40, 15, 20]],
    'front mast': [[225, 400, -120], [40, 15, 20]],
    'rear post': [[-305, 400, 123], [35, 15, 35]],
    'front post': [[320, 400, 149], [35, 15, 35]],
  };
  const stages = [0, 1, 2];
  const volume = await solidVolumes({
    seated: 'intersection() { traction_controller(); controller_support(); }',
    bearing: `intersection() {
    translate([0, -1, 0]) traction_controller(); controller_support();
  }`,
    contactorSeated: 'intersection() { main_contactor(); controller_support(); }',
    contactorBearing: 'intersection() { translate([0, -1, 0]) main_contactor(); controller_support(); }',
    estopSeated: 'intersection() { estop_button(); controller_support(); }',
    estopBearing: 'intersection() { translate([0, -1, 0]) estop_button(); controller_support(); }',
    ...Object.fromEntries(Object.entries(joints).map(([name, [at, size]]) => [name,
      `intersection() { controller_support(); upper_roller_support();
        translate([${at}]) cube([${size}]); }`])),
    cassetteTie: `intersection() { controller_support(); union() {
      battery_service_tray(); pod_carrier(); slide_stage(0); } }`,
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
  assert.ok(volume.estopSeated <= 0.01, 'E-stop enclosure sits on, not inside, the plate');
  assert.ok(volume.estopBearing > 1, 'E-stop enclosure is carried by the same plate');
  for (const name of Object.keys(joints)) {
    assert.ok(volume[name] > 500, `electrical plate overlaps the ${name} for a bolted joint (${volume[name]} mm3)`);
  }
  assert.ok(volume.cassetteTie <= 0.01, 'electrical plate is not tied to the tray or cassette');
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
