import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readFileSync } from 'node:fs';
import { boundsFor, solidVolumes } from './cad-test-helpers.mjs';

const gap = (a, b) => Math.hypot(...[0, 1, 2].map(axis =>
  Math.max(0, a.min[axis] - b.max[axis], b.min[axis] - a.max[axis])));

test('E-stop is reachable from outboard, beside the controller, guarded from the track', async () => {
  const config = JSON.parse(readFileSync('docs/engineering/presentation/viewer/components.json'));
  const ids = config.components.map(part => part.id);
  for (const id of ['estop-button', 'estop-mount']) assert.ok(ids.includes(id), `${id} is a viewer component`);
  const track = boundsFor('track');
  const button = boundsFor('estop-button');
  const mount = boundsFor('estop-mount');
  const controller = boundsFor('controller');
  assert.ok(button.min[2] >= track.max[2] + 30,
    'the whole operator is outboard of the track width, never over the belt');
  assert.ok(gap(button, controller) <= 60, 'E-stop sits beside the controller');
  assert.ok(button.max[1] >= controller.max[1] + 20,
    'mushroom head stands proud on top so it is pressed downward, parallel to the track side');
  assert.ok(mount.max[1] >= track.max[1] + 5,
    'finger guard rises above the track top so a slipping hand cannot reach the belt');
  const extracted = boundsFor('battery');
  assert.ok(button.max[2] <= extracted.min[2] + 305 - 10,
    'E-stop stays inboard of the extracted battery lift path');
  const others = ids.filter(id => !['estop-button', 'estop-mount', 'removal-arrow'].includes(id))
    .map(id => `pod_component("${id}");`).join('\n');
  const head = [(button.min[0] + button.max[0]) / 2, button.max[1] - 5, (button.min[2] + button.max[2]) / 2];
  const volume = await solidVolumes({
    seated: 'intersection() { estop_button(); controller_support(); }',
    bearing: 'intersection() { translate([0, -1, 0]) estop_button(); controller_support(); }',
    tied: 'intersection() { estop_mount(); controller_support(); }',
    guardOnly: 'intersection() { estop_mount(); translate([-1000, 400, 112]) cube(2000); }',
    clash: `intersection() { union() { estop_button(); estop_mount(); }
      union() { ${others.replace('pod_component("controller-support");', '')} } }`,
    reachTrack: `intersection() { estop_mount();
      hull() { translate([${head}]) sphere(d = 4); translate([${head[0]}, ${track.max[1] - 10}, ${track.max[2] - 1}]) sphere(d = 4); } }`,
    reachSide: `intersection() { estop_mount();
      hull() { translate([${head}]) sphere(d = 4); translate([${head[0]}, ${head[1]}, ${track.max[2] - 1}]) sphere(d = 4); } }`,
  });
  assert.ok(volume.seated <= 0.01, 'button enclosure sits on, not inside, the electrical plate');
  assert.ok(volume.bearing > 1, 'button enclosure bears directly on the electrical plate');
  assert.ok(volume.tied > 1, 'finger guard is bolted to the electrical plate, not the moving cassette');
  assert.ok(volume.guardOnly <= 0.01, 'no separate E-stop arm or platform remains; only the guard tab');
  assert.ok(volume.clash <= 0.01, 'E-stop and guard clear every other component');
  assert.ok(volume.reachTrack > 0.1 && volume.reachSide > 0.1,
    'guard blocks straight reach from the head to the track side and top run');
});

test('battery and motor power cables stay within their shortest-route length budgets', async () => {
  const volume = await solidVolumes({
    budget: `assert(path_length(battery_positive_path_a()) + path_length(battery_positive_path_b()) <= 335, "P+ too long");
      assert(path_length(battery_negative_path()) <= 320, "P- too long");
      // Phases follow the motor rail, rear post and electrical plate so they
      // can be cleated (measured 774/717/712 mm); budgets add about 5 mm.
      for (i = [0 : 2]) assert(path_length(motor_phase_path(i)) <= [780, 722, 717][i], "phase too long");
      assert(path_length(motor_phase_path(0)) + path_length(motor_phase_path(1))
        + path_length(motor_phase_path(2)) <= 2215, "phase set too long");
      cube(1);`,
  });
  assert.ok(volume.budget > 0.9, 'length budget probe rendered');
});
