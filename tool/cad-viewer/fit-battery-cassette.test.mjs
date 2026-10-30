import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readFileSync } from 'node:fs';
import { groupComponents } from '../../docs/engineering/presentation/viewer/visibility.mjs';
import { poseAt } from '../../docs/engineering/presentation/viewer/animation.mjs';
import { boundsFor, solidVolume, solidVolumes } from './cad-test-helpers.mjs';

test('configured battery removal animation sweeps clear of fixed running gear', () => {
  const config = JSON.parse(readFileSync('docs/engineering/presentation/viewer/components.json'));
  const animation = config.animations?.find(item => item.id === 'battery-removal');
  assert.ok(animation, 'the viewer animation path is the clash-checked path');
  const annotations = new Set(groupComponents(config.groups.find(group => group.id === 'annotations')));
  const moving = animation.components.filter(id => !annotations.has(id));
  for (const id of ['battery', 'battery-tray', 'battery-base-clamps', 'slide-inner', 'tray-lock-strike']) {
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
  for (const id of ['battery-box', 'battery-lid', 'battery-feed', 'battery-hold-down', 'controller-harness']) {
    assert.ok(!ids.includes(id), `${id} removed: open tray, base clamps and direct wiring`);
  }
  const required = ['battery-tray', 'battery-base-clamps', 'slide-fixed', 'slide-middle', 'slide-inner',
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
  const strike = boundsFor('tray-lock-strike'), pin = boundsFor('tray-lock-pin');
  assert.ok(strike.min[1] >= tray.min[1] && strike.max[1] <= tray.max[1] + 8,
    'locking strip is at tray level, not on a tower');
  assert.ok(pin.min[1] < tray.min[1] && pin.max[1] < battery.min[1] + 20,
    'pin engages the tray-level strip from below');
  const movingSteelVolume = solidVolume(`union() {
    battery_service_tray(); battery_base_clamps(); slide_stage(2); battery_lock_strike();
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

test('slotted base clamps move with the tray and release clear after extraction', async () => {
  const config = JSON.parse(readFileSync('docs/engineering/presentation/viewer/components.json'));
  const animation = config.animations.find(item => item.id === 'battery-removal');
  assert.ok(animation.components.includes('battery-base-clamps'), 'clamps are carried by the tray');
  const battery = boundsFor('battery'), clamps = boundsFor('battery-base-clamps');
  assert.ok(clamps.min[1] >= battery.min[1] && clamps.max[1] <= battery.min[1] + 25,
    'restraint stays low at the base, not over the battery');
  const fixed = config.components.map(part => part.id).filter(id =>
    id !== 'removal-arrow' && !animation.components.includes(id)
      && !Object.hasOwn(animation.tracks ?? {}, id))
    .map(id => `pod_component("${id}");`).join('\n');
  const probes = {
    body: 'intersection() { battery_base_clamps(); battery_envelope(); }',
    seated: 'intersection() { battery_base_clamps(); battery_service_tray(); }',
    bearing: 'intersection() { translate([0,-1,0]) battery_base_clamps(); battery_service_tray(); }',
    trayIdler: `intersection() {
      minkowski() {
        hull() { battery_service_tray(); translate([0,0,305]) battery_service_tray(); }
        sphere(r=5.1, $fn=32);
      }
      union() {
        hull() { translate([-15,0,0]) pod_component("idler"); translate([15,0,0]) pod_component("idler"); }
        hull() { idler_carriage(-15); idler_carriage(15); }
      }
    }`,
  };
  for (const end of [0, 1]) for (const lane of [0, 1]) {
    const clamp = `battery_base_clamp(${end}, ${lane});`;
    const jaw = `battery_base_jaw(${end}, ${lane});`;
    const stud = `battery_base_stud(${end}, ${lane});`;
    const direction = end === 0 ? -1 : 1;
    // Test fixture only: a 4 mm projection and 6 mm thickness, not the unknown pack flange.
    const fixtureX = end === 0 ? battery.min[0] - 4 : battery.max[0];
    const fixture = `translate([${fixtureX},${battery.min[1]},${[10, 140][lane] - 7}]) cube([4,6,14]);`;
    probes[`exists-${end}-${lane}`] = clamp;
    probes[`jaw-exists-${end}-${lane}`] = jaw;
    probes[`jaw-stud-${end}-${lane}`] = `intersection() { ${jaw} ${stud} }`;
    probes[`knob-stud-${end}-${lane}`] = `intersection() {
      battery_base_knob(${end}, ${lane}); ${stud}
    }`;
    probes[`knob-bearing-${end}-${lane}`] = `intersection() {
      translate([0,-1,0]) battery_base_knob(${end}, ${lane}); ${jaw}
    }`;
    probes[`slide-stud-${end}-${lane}`] = `intersection() {
      translate([0,5,0]) ${jaw}
      hull() { ${stud} translate([${-direction * 14},0,0]) ${stud} }
    }`;
    probes[`lift-stud-${end}-${lane}`] = `intersection() {
      ${jaw} hull() { ${stud} translate([0,-5,0]) ${stud} }
    }`;
    probes[`slide-knob-${end}-${lane}`] = `intersection() {
      hull() { translate([0,5,0]) ${jaw} translate([${direction * 14},5,0]) ${jaw} }
      translate([0,5.1,0]) battery_base_knob(${end}, ${lane});
    }`;
    probes[`fixture-bearing-${end}-${lane}`] = `intersection() {
      ${jaw} translate([0,1,0]) ${fixture}
    }`;
    probes[`fixture-seated-${end}-${lane}`] = `intersection() { ${clamp} ${fixture} }`;
    probes[`fixture-lift-${end}-${lane}`] = `intersection() {
      hull() { ${fixture} translate([0,300,0]) ${fixture} }
      union() { battery_base_mount(${end}, ${lane}); battery_base_knob(${end}, ${lane}); }
    }`;
    probes[`sweep-${end}-${lane}`] = `intersection() {
      minkowski() {
        hull() { ${clamp} translate([0,0,305]) ${clamp} }
        sphere(r=5.1, $fn=32);
      }
      union() { ${fixed}
        hull() { translate([-15,0,0]) pod_component("idler"); translate([15,0,0]) pod_component("idler"); }
        hull() { idler_carriage(-15); idler_carriage(15); }
      }
    }`;
    probes[`release-${end}-${lane}`] = `intersection() {
      translate([0,5,305]) minkowski() {
        ${jaw}
        translate([${direction < 0 ? -14 : 0},0,0]) cube([14,0.001,0.001]);
      }
      union() {
        translate([0,0,305]) union() {
          battery_envelope(); battery_service_tray(); battery_lock_strike();
          battery_base_mount(${end}, ${lane});
          translate([0,5.1,0]) battery_base_knob(${end}, ${lane});
          for (otherEnd = [0:1], otherLane = [0:1])
            if (otherEnd != ${end} || otherLane != ${lane}) battery_base_clamp(otherEnd, otherLane);
        }
        ${fixed}
      }
    }`;
    probes[`lift-jaw-${end}-${lane}`] = `intersection() {
      translate([0,0,305]) minkowski() {
        ${jaw} cube([0.001,5,0.001]);
      }
      union() {
        translate([0,0,305]) union() {
          battery_envelope(); battery_service_tray(); battery_lock_strike();
          battery_base_mount(${end}, ${lane});
          translate([0,5.1,0]) battery_base_knob(${end}, ${lane});
        }
        ${fixed}
      }
    }`;
  }
  const volumes = await solidVolumes(probes);
  assert.ok(volumes.body <= 0.01, 'clamp concepts stay outside the published battery envelope');
  assert.ok(volumes.seated <= 0.01 && volumes.bearing > 1, 'clamps bear on the tray without penetrating it');
  assert.ok(volumes.trayIdler <= 0.01, 'entire tray sweep keeps 5 mm to the full idler stroke');
  for (const end of [0, 1]) for (const lane of [0, 1]) {
    assert.ok(volumes[`exists-${end}-${lane}`] > 1, `clamp ${end}/${lane} is present`);
    assert.ok(volumes[`jaw-exists-${end}-${lane}`] > 1, `clamp ${end}/${lane} has a removable jaw`);
    assert.ok(volumes[`jaw-stud-${end}-${lane}`] <= 0.01, `jaw ${end}/${lane} clears its mounting stud`);
    assert.ok(volumes[`knob-stud-${end}-${lane}`] <= 0.01, `knob ${end}/${lane} clears its mounting stud`);
    assert.ok(volumes[`knob-bearing-${end}-${lane}`] > 1, `knob ${end}/${lane} bears on its jaw`);
    assert.ok(volumes[`slide-stud-${end}-${lane}`] <= 0.01, `jaw ${end}/${lane} slides off its stud`);
    assert.ok(volumes[`lift-stud-${end}-${lane}`] <= 0.01, `jaw ${end}/${lane} lifts along its stud`);
    assert.ok(volumes[`slide-knob-${end}-${lane}`] <= 0.01, `jaw ${end}/${lane} slides under its loosened knob`);
    assert.ok(volumes[`fixture-seated-${end}-${lane}`] <= 0.01, `clamp ${end}/${lane} does not penetrate the hypothetical flange`);
    assert.ok(volumes[`fixture-bearing-${end}-${lane}`] > 1, `jaw ${end}/${lane} can press a hypothetical flange`);
    assert.ok(volumes[`fixture-lift-${end}-${lane}`] <= 0.01, `hypothetical flange ${end}/${lane} clears fixed hardware after release`);
    assert.ok(volumes[`sweep-${end}-${lane}`] <= 0.01, `clamp ${end}/${lane} keeps a 5 mm fixed-gear margin while moving`);
    assert.ok(volumes[`lift-jaw-${end}-${lane}`] <= 0.01, `jaw ${end}/${lane} can lift at EXTRACT`);
    assert.ok(volumes[`release-${end}-${lane}`] <= 0.01, `jaw ${end}/${lane} can slide away at EXTRACT`);
  }
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
