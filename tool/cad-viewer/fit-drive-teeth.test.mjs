import assert from 'node:assert/strict';
import { test } from 'node:test';
import { boundsFor, contains, solidVolumes } from './cad-test-helpers.mjs';

function lobesAt(mesh, x, y, z, radius, samples) {
  const occupied = Array.from({ length: samples }, (_, i) => {
    const angle = 2 * Math.PI * (i + 0.173) / samples;
    return contains(mesh, [x + radius * Math.cos(angle), y + radius * Math.sin(angle), z]);
  });
  return occupied.filter((value, i) => value && !occupied[(i + samples - 1) % samples]).length;
}

test('planetary stages display the specified sun tooth counts rather than pitch cylinders', () => {
  for (const [i, teeth] of [24, 24, 16].entries()) {
    const stage = boundsFor(`planetary-${i + 1}`);
    const radius = teeth * 1.5 + 2;
    const orbit = i === 2 ? 49.5 : 72;
    const planetTip = i === 2 ? 28.5 : 39;
    let exposedGaps = 0;
    for (let tooth = 0; tooth < teeth; tooth++) {
      const tip = 2 * Math.PI * tooth / teeth;
      assert.ok(contains(stage, [-440 + radius * Math.cos(tip), 185 + radius * Math.sin(tip), -37 - i * 20]),
        `stage ${i + 1} sun tooth ${tooth}`);
      const gap = 2 * Math.PI * (tooth + 0.5) / teeth;
      const x = radius * Math.cos(gap), y = radius * Math.sin(gap);
      // At meshing sectors the mating planet can occupy a sun gap; inspect only exposed gaps.
      if ([0, 1, 2].every(j => Math.hypot(x - orbit * Math.cos(j * 2 * Math.PI / 3),
        y - orbit * Math.sin(j * 2 * Math.PI / 3)) > planetTip + 0.5)) {
        assert.equal(contains(stage, [-440 + x, 185 + y, -37 - i * 20]), false);
        exposedGaps++;
      }
    }
    assert.ok(exposedGaps >= teeth / 2, 'at least half the sun gaps are observable without planet masking');
  }
});

test('traction drum has sixteen discrete central teeth connected to both running bands', async () => {
  const drum = boundsFor('drive-drum');
  assert.equal(lobesAt(drum, -440, 185, 0, 180, 720), 16);
  const wrapped = (-90 + 12.5 * 360 / 16) * Math.PI / 180;
  const tip = [-440 + 182 * Math.cos(wrapped), 185 + 182 * Math.sin(wrapped), 0];
  assert.equal(contains(drum, tip), true, 'wrapped tooth reaches past the belt inner face');
  assert.equal(contains(boundsFor('track'), tip), false, 'wrapped tooth sits in an open link window');
  assert.equal(contains(drum, [tip[0], tip[1], 8]), false, 'tooth stays inside the horn-pair passage');
  const volumes = await solidVolumes({
    bandConnection: `intersection() {
      main_driven_roller(-440);
      for (z = [-40, 39]) translate([-440,185,z])
        difference() { cylinder(r = 170, h = 1); cylinder(r = 165, h = 1); }
    }`,
    track: 'intersection() { main_driven_roller(-440); track_loop(); }',
    motor: 'intersection() { main_driven_roller(-440); hpm5000b_motor_envelope(-440); }',
    supports: 'intersection() { main_driven_roller(-440); motor_frame_braces(); }',
  });
  assert.ok(volumes.bandConnection > 10000, 'toothed hub has side webs joined to both bands');
  assert.ok(volumes.track <= 0.01, 'teeth engage link windows and clear the R2 horns and lands');
  assert.ok(volumes.motor <= 0.01, 'central tooth root clears the motor body and shaft');
  assert.ok(volumes.supports <= 0.01, 'rotating hub and teeth clear all four stationary motor posts');
});
