import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readFileSync } from 'node:fs';
import { solidVolumes } from './cad-test-helpers.mjs';

// Provisional maximum unsupported phase-cable span between clamped points
// (motor lug, cleats, grommet and controller lug); vibration rating is HOLD.
const maxSpan = 200;
const stations = 5;

test('motor phase cables are clamped to fixed structure with no long free span', async () => {
  const config = JSON.parse(readFileSync('docs/engineering/presentation/viewer/components.json'));
  assert.ok(config.components.some(part => part.id === 'motor-harness-supports'),
    'phase cable cleats are a selectable viewer component');
  const probes = {
    spans: `for (i = [0 : 2]) let(path = motor_phase_path(i), points = motor_phase_supports(i),
        s = [0, for (p = points) path_position(path, p), path_length(path)])
      assert(len(points) == ${stations}, "every phase has the same support stations")
      for (k = [1 : len(s) - 1]) assert(s[k] - s[k - 1] > 0 && s[k] - s[k - 1] <= ${maxSpan},
        str("phase ", i, " span ", k, " is ", s[k] - s[k - 1]));
      cube(1);`,
    cut: 'intersection() { motor_harness_supports(); motor_power_harness(); }',
    fixedOverlap: `intersection() { motor_harness_supports(); union() {
      pod_component("track"); pod_component("drive-drum"); pod_component("motor");
      traction_controller(); battery_envelope(); battery_service_tray(); } }`,
    runningGear: `intersection() {
      minkowski() { motor_harness_support_envelopes(); sphere(r = 5.1, $fn = 16); }
      union() { ${['track', 'drive-drum', 'upper-roller', 'upper-roller-2', 'idler',
    'planetary-1', 'planetary-2', 'planetary-3', 'output-carrier']
    .map(id => `pod_component("${id}");`).join(' ')} } }`,
  };
  for (let i = 0; i < 3; i++) {
    for (let k = 0; k < stations; k++) {
      probes[`grip-${i}-${k}`] = `let(p = motor_phase_supports(${i})[${k}]) intersection() {
        motor_harness_supports(); translate(p) sphere(d = 16, $fn = 24);
        cable_path(motor_phase_path(${i}), diameter = 13); }`;
    }
  }
  const anchors = {
    'motor riser clip': ['pod_frame()', [-475, 225, 120], [90, 80, 40]],
    'post cleat': ['upper_roller_support()', [-300, 285, 100], [30, 70, 40]],
    grommet: ['controller_support()', [-280, 400, 95], [60, 20, 60]],
    'plate bridge': ['controller_support()', [-175, 400, 70], [30, 20, 90]],
    'riser clamp': ['controller_support()', [-80, 400, 70], [40, 20, 100]],
  };
  for (const [name, [parent, at, size]] of Object.entries(anchors)) {
    probes[name] = `intersection() { motor_harness_supports(); ${parent};
      translate([${at}]) cube([${size}]); }`;
  }
  const volume = await solidVolumes(probes);
  assert.ok(volume.spans > 0.9, `every phase is clamped at least every ${maxSpan} mm`);
  assert.ok(volume.cut <= 0.01, 'cleat bores are cable-sized and do not cut into the leads');
  for (let i = 0; i < 3; i++) {
    for (let k = 0; k < stations; k++) {
      assert.ok(volume[`grip-${i}-${k}`] > 1, `phase ${i} station ${k} is gripped by a cleat`);
    }
  }
  for (const name of Object.keys(anchors)) {
    assert.ok(volume[name] > 100, `${name} is fastened to fixed structure (${volume[name]} mm3)`);
  }
  assert.ok(volume.fixedOverlap <= 0.01, 'cleats do not cut into the track, drum, motor, controller or battery');
  assert.ok(volume.runningGear <= 0.01, 'cleats keep a provisional 5 mm clearance from moving running gear');
});
