import assert from 'node:assert/strict';
import { test } from 'node:test';
import { boundsFor, center, solidVolumes } from './cad-test-helpers.mjs';

test('motor mount has two full-depth axial supports tied into both deeper pod rails', async () => {
  const volumes = await solidVolumes({
    posts: `difference() {
      for (y = [133, 213]) translate([-332, y, -26]) cube([24, 24, 144]);
      pod_frame();
    }`,
    crossmember: `difference() {
      translate([-241, 130, -100]) cube([20, 20, 218]);
      pod_frame();
    }`,
    notchedRails: `difference() {
      for (z = [-100, 90]) translate([-28, 90, z]) cube([80, 39.9, 10]);
      pod_frame();
    }`,
    plateSeats: `difference() {
      for (y = [133, 213]) translate([-332, y, -26]) cube([24, 24, 16]);
      motor_reaction_mount();
    }`,
    lowerPlateConnection: `intersection() {
      pod_frame(); motor_reaction_mount(); translate([-332,133,-26]) cube([24,24,16]);
    }`,
    upperPlateConnection: `intersection() {
      pod_frame(); motor_reaction_mount(); translate([-332,213,-26]) cube([24,24,16]);
    }`,
    carrierConnection: 'intersection() { pod_frame(); pod_carrier(); }',
  });
  for (const name of ['posts', 'crossmember', 'notchedRails', 'plateSeats']) {
    assert.ok(volumes[name] <= 0.01, `${name} is missing ${volumes[name]} mm³ of the required steel`);
  }
  assert.ok(volumes.lowerPlateConnection > 500, 'lower support overlaps the motor reaction plate');
  assert.ok(volumes.upperPlateConnection > 500, 'upper support overlaps the motor reaction plate');
  assert.ok(volumes.carrierConnection > 500, 'crossmember and rails tie into the fixed carrier');
});

test('front idler rails have deep continuous sections anchored behind the carriage', async () => {
  const [idlerX] = center(boundsFor('idler'));
  const volumes = await solidVolumes({
    rails: `difference() {
      for (z = [-140.5, 121.5])
        translate([${idlerX - 199.5}, 85.5, z]) cube([266, 64, 19]);
      pod_frame();
    }`,
    anchors: `difference() {
      for (z = [-140.5, 90.5])
        translate([${idlerX - 199.5}, 90.5, z]) cube([54, 49, 50]);
      pod_frame();
    }`,
  });
  assert.ok(volumes.rails <= 0.01, `front rails are missing ${volumes.rails} mm³ of steel`);
  assert.ok(volumes.anchors <= 0.01, `rear rail anchors are missing ${volumes.anchors} mm³ of steel`);
});

test('front rails retain 5 mm to the complete idler carriage sweep and the track', async () => {
  const frontFrame = 'union() { front_rail_reinforcement(-1); front_rail_reinforcement(1); }';
  const volumes = await solidVolumes({
    carriage: `intersection() {
      ${frontFrame}
      minkowski() {
        hull() { idler_carriage(-15); idler_carriage(15); }
        sphere(r = 5.1, $fn = 32);
      }
    }`,
    track: `intersection() {
      ${frontFrame}
      union() {
        linear_extrude(height = 210.2, center = true) difference() {
          capsule_2d(23);
          capsule_2d(-15.1);
        }
        linear_extrude(height = 34.2, center = true) difference() {
          capsule_2d(23);
          capsule_2d(-35.1);
        }
      }
    }`,
  });
  for (const [name, volume] of Object.entries(volumes)) {
    assert.ok(volume <= 0.01, `front ${name} violates the provisional 5 mm margin (${volume} mm³)`);
  }
});

test('reinforcement keeps 5 mm to the motor, moving track, drum and lower wheel', async () => {
  const motorRegion = 'intersection() { pod_frame(); translate([-360,80,-200]) cube([150,200,400]); }';
  const frameAndPlate = `union() { ${motorRegion} motor_reaction_mount(); }`;
  const volumes = await solidVolumes({
    motor: `intersection() {
      ${motorRegion}
      translate([-440,185,-10]) cylinder(d = 216.2, h = 126);
    }`,
    drum: `intersection() {
      ${frameAndPlate}
      for (z = [-105.1, 19.9]) translate([-440,185,z])
        difference() {
          cylinder(d = 360.2, h = 85.2);
          translate([0,0,-0.1]) cylinder(d = 319.8, h = 85.4);
        }
    }`,
    track: `intersection() {
      ${frameAndPlate}
      linear_extrude(height = 210.2, center = true) difference() {
        capsule_2d(21.1);
        capsule_2d(-35.1);
      }
    }`,
    lowerWheel: `intersection() {
      ${motorRegion}
      translate([-195,70,0]) cylinder(d = 130.2, h = 160.2, center = true);
    }`,
    phaseLeads: `intersection() {
      ${motorRegion}
      for (i = [0:2]) cable_path(motor_phase_path(i), diameter = 22.2);
    }`,
  });
  for (const [name, volume] of Object.entries(volumes)) {
    assert.ok(volume <= 0.01, `${name} violates the provisional 5 mm margin (${volume} mm³)`);
  }
});
