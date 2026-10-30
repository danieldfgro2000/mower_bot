import assert from 'node:assert/strict';
import { test } from 'node:test';
import { boundsFor, center, solidVolumes } from './cad-test-helpers.mjs';

test('motor plate has four separated broad seats and a cradle tied to the fixed carrier', async () => {
  const volumes = await solidVolumes({
    notchedRails: `difference() {
      for (z = [-100, 90]) translate([-28, 90, z]) cube([80, 39.9, 10]);
      pod_frame();
    }`,
    carrierConnection: 'intersection() { pod_frame(); pod_carrier(); }',
    cradleSeat: 'intersection() { motor_frame_braces(); pod_carrier(); }',
    continuousPosts: `difference() {
      for (x = [-572.5, -332.5]) for (y = [132.5, 212.5])
        translate([x, y, -26]) cube([25, 25, 179]);
      motor_frame_braces();
    }`,
    ...Object.fromEntries([-1, 1].flatMap(side => [-1, 1].map(level => [
      `plateSeat${side}:${level}`,
      `intersection() {
        motor_frame_braces(); motor_reaction_mount();
        translate([-440 + ${side} * 120 - 12.5,
          185 + ${level} * 40 - 12.5, -26]) cube([25, 25, 16]);
      }`,
    ]))),
  });
  assert.ok(volumes.notchedRails <= 0.01, 'retain the deeper notched rails');
  assert.ok(volumes.continuousPosts <= 0.01, 'all four seats have continuous full-depth supports');
  assert.ok(volumes.cradleSeat >= 6999, 'the cradle overlaps the actual fixed carrier over 700 mm²');
  for (const [name, volume] of Object.entries(volumes).filter(([name]) => name.startsWith('plateSeat'))) {
    assert.ok(volume >= 9000, `${name} needs at least 562.5 mm² of actual plate seat, got ${volume / 16}`);
  }
  assert.ok(volumes.carrierConnection > 10000, 'cradle and rails tie broadly into the fixed carrier');
});

test('outboard upper-roller supports never sit over the sliding idler carriage', async () => {
  const volumes = await solidVolumes({
    // Post landings (below the arms) against the full carriage stroke extruded upward
    // in plan and grown by the 5 mm margin.
    carriagePlan: `intersection() {
      intersection() { upper_roller_support(); translate([-1000, 0, 101]) cube([2000, 300, 2000]); }
      minkowski() {
        hull() { idler_carriage(-15); idler_carriage(15);
          translate([0, 500, 0]) { idler_carriage(-15); idler_carriage(15); } }
        cube(10.2, center = true);
      }
    }`,
  });
  assert.ok(volumes.carriagePlan <= 0.01,
    `outboard support lies over the idler carriage stroke (${volumes.carriagePlan} mm³)`);
});

test('both roller crossheads join the actual U bridge and straight posts on fixed carrier extensions', async () => {
  for (const rear of [false, true]) {
    const x = rear ? -195 : 245;
    const postX = rear ? -300 : 325;
    const postZ = rear ? 128 : 154;
    const volumes = await solidVolumes({
      bridge: `intersection() {
        upper_roller_support();
        roller_u_support(${x}, 510, true);
        translate([${rear ? x - 18 : x}, 440, 74]) cube([18, 6, 12]);
      }`,
      crosshead: `difference() {
        difference() {
          translate([${rear ? postX : x}, 440, 74])
            cube([${rear ? x + 18 - postX : postX + 25 - x}, 12, ${postZ + 25 - 74}]);
          translate([${rear ? postX - 1 : x + 18}, 439, 73])
            cube([${rear ? x - 18 - postX + 1 : postX + 25 - x - 17}, 14, 33]);
        }
        upper_roller_support();
      }`,
      post: `difference() {
        translate([${postX}, 140, ${postZ}]) cube([25, 312, 25]);
        upper_roller_support();
      }`,
      seat: `intersection() {
        upper_roller_support(); pod_carrier();
        translate([${postX}, 140, ${postZ}]) cube([25, 10, 25]);
      }`,
      fixedRoot: `intersection() {
        pod_carrier();
        translate([${rear ? -227 : 245}, 140, ${postZ}]) cube([32, 10, 24]);
      }`,
    });
    assert.ok(volumes.bridge >= 1295, `${rear ? 'rear' : 'front'} bridge is not directly joined`);
    assert.ok(volumes.crosshead <= 0.01, 'one flat crosshead with a square belt relief, no gap or dogleg');
    assert.ok(volumes.post <= 0.01, 'one continuous straight post');
    assert.ok(volumes.seat >= 6249, 'entire 25 x 25 post foot seats on the fixed carrier');
    assert.ok(volumes.fixedRoot >= 7679, 'carrier extension has a broad root into the original seat');
  }
});

test('front outboard post keeps 5 mm clearance from the full idler-carriage stroke', async () => {
  const volumes = await solidVolumes({
    continuousSweep: `intersection() {
      upper_roller_support();
      minkowski() {
        hull() { idler_carriage(-15); idler_carriage(15); }
        cube(10.2, center = true);
      }
    }`,
  });
  assert.ok(Object.values(volumes).every(volume => volume <= 0.01),
    `fixed upper support violates the 5 mm idler clearance: ${JSON.stringify(volumes)}`);
});

test('all four motor supports and the complete cradle keep 5 mm from running gear and phase leads', async () => {
  const volumes = await solidVolumes({
    ...Object.fromEntries(['motor', 'drive-drum', 'track'].map(id => [id, `intersection() {
      motor_frame_braces();
      minkowski() {
        pod_component("${id}");
        cube(10.2, center = true);
      }
    }`])),
    leads: `intersection() {
      motor_frame_braces();
      for (i = [0:2]) cable_path(motor_phase_path(i), diameter = 22.2);
    }`,
  });
  for (const [name, volume] of Object.entries(volumes)) {
    assert.ok(volume <= 0.01, `complete motor cradle violates the 5 mm ${name} margin (${volume} mm³)`);
  }
});

test('outboard upper-roller supports keep 5 mm to battery service, harnesses and running gear', async () => {
  const grown = `minkowski() {
    intersection() { upper_roller_support(); translate([-1000, 0, 101]) cube(2000); }
    cube(10, center = true);
  }`;
  const moving = ['battery', 'battery-tray', 'battery-base-clamps', 'slide-inner',
    'tray-lock-strike', 'tray-lock-pin'].map(id => `pod_component("${id}");`).join('\n');
  const near = ids => `union() { ${ids.map(id => `pod_component("${id}");`).join('\n')} }`;
  const volumes = await solidVolumes({
    serviceSweep: `intersection() { ${grown}
      hull() { union() { ${moving} } translate([0, 0, 400]) union() { ${moving} } } }`,
    harness: `intersection() { ${grown} ${near(['battery-harness', 'motor-harness'])} }`,
    // The electrical plate is bolted to these posts by design (joint proven in
    // fit-controller-support); the devices on it must still keep 5 mm.
    electrical: `intersection() { ${grown}
      ${near(['controller', 'main-contactor', 'estop-button', 'estop-mount'])} }`,
    running: `intersection() { ${grown}
      ${near(['track', 'drive-drum', 'motor', 'idler', 'idler-carriage', 'upper-roller', 'upper-roller-2'])} }`,
  });
  for (const [name, volume] of Object.entries(volumes)) {
    assert.ok(volume <= 0.01, `outboard support violates the 5 mm ${name} margin (${volume} mm³)`);
  }
});

test('front idler rails have deep continuous sections anchored behind the carriage', async () => {
  const [idlerX] = center(boundsFor('idler'));
  const volumes = await solidVolumes({
    rails: `difference() {
      for (z = [-150.5, 131.5])
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
        linear_extrude(height = 68.2, center = true) difference() {
          capsule_2d(23);
          capsule_2d(-34.1);
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
