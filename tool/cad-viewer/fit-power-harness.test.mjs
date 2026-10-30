import assert from 'node:assert/strict';
import { test } from 'node:test';
import { readFileSync } from 'node:fs';
import { solidVolume, solidVolumes, boundsFor } from './cad-test-helpers.mjs';

test('battery leads have distinct red positive and black negative render parts', () => {
  const config = JSON.parse(readFileSync('docs/engineering/presentation/viewer/components.json'));
  const harness = config.components.find(part => part.id === 'battery-harness');
  assert.deepEqual(harness?.renderParts, [
    { id: 'battery-positive-lead', module: 'battery_positive_harness', color: '#d62218' },
    { id: 'battery-negative-lead', module: 'battery_negative_harness', color: '#101112' },
  ]);
});

test('battery terminal end and polarity turn 180 degrees about the upright axis', () => {
  const battery = boundsFor('battery');
  const controller = boundsFor('controller');
  const centerZ = (battery.min[2] + battery.max[2]) / 2;
  assert.ok(solidVolume(`
    let(positivePath = battery_positive_path_a(), outputPath = battery_positive_path_b(),
        negativePath = battery_negative_path(),
        positive = positivePath[0], negative = negativePath[0])
      assert(positive[0] > ${battery.max[0]} && negative[0] > ${battery.max[0]},
        "both terminal leads start on the +X battery end")
      assert(positive[2] < ${centerZ} && negative[2] > ${centerZ},
        "rotation also reverses the positive/negative transverse positions")
      assert(norm(positive - [305,348,-35]) < 0.001 && norm(negative - [305,348,123]) < 0.001,
        "photo-oriented battery P+ and P- landings are preserved")
      assert(norm(positivePath[len(positivePath)-1] - [175,493,-35]) < 0.001
        && norm(outputPath[0] - [150,493,-35]) < 0.001,
        "P+ enters and leaves the separate placeholder contactor studs")
      assert(norm(outputPath[len(outputPath)-1]
        - [${controller.min[0] + 100},${controller.max[1] + 6},${controller.min[2] + 25}]) < 0.001,
        "contactor output lands on the B+ end of the A-series row")
      assert(norm(negativePath[len(negativePath)-1]
        - [${controller.min[0] + 100},${controller.max[1] + 6},${controller.max[2] - 23}]) < 0.001,
        "battery P- lands on the B- end of the A-series row")
      cube(1);
  `) > 0.9);
});

test('rendered lead solids follow their matching battery and controller terminals', async () => {
  const probes = {
    positiveBattery: `let(point = battery_positive_path_a()[0]) intersection() {
      battery_positive_harness(); translate(point) sphere(d=1);
    }`,
    positiveController: `let(path = battery_positive_path_b(), point = path[len(path)-1]) intersection() {
      battery_positive_harness(); translate(point) sphere(d=1);
    }`,
    negativeBattery: `let(point = battery_negative_path()[0]) intersection() {
      battery_negative_harness(); translate(point) sphere(d=1);
    }`,
    negativeController: `let(path = battery_negative_path(), point = path[len(path)-1]) intersection() {
      battery_negative_harness(); translate(point) sphere(d=1);
    }`,
    positiveAtNegative: `let(point = battery_negative_path()[0]) intersection() {
      battery_positive_harness(); translate(point) sphere(d=1);
    }`,
    negativeAtPositive: `let(point = battery_positive_path_a()[0]) intersection() {
      battery_negative_harness(); translate(point) sphere(d=1);
    }`,
    negativeAtContactor: `intersection() {
      battery_negative_harness(); translate([0,1,0]) main_contactor();
    }`,
    missing: `difference() {
      battery_power_harness(); union() { battery_positive_harness(); battery_negative_harness(); }
    }`,
    extra: `difference() {
      union() { battery_positive_harness(); battery_negative_harness(); } battery_power_harness();
    }`,
  };
  const volumes = await solidVolumes(probes);
  for (const name of ['positiveBattery', 'positiveController', 'negativeBattery', 'negativeController']) {
    assert.ok(volumes[name] > 0.1, `${name} is covered by the matching colored lead`);
  }
  for (const name of ['positiveAtNegative', 'negativeAtPositive', 'negativeAtContactor']) {
    assert.ok(volumes[name] <= 0.01, `${name} does not connect to the opposite circuit`);
  }
  assert.ok(volumes.missing <= 0.01 && volumes.extra <= 0.01,
    'colored render parts exactly cover the existing battery harness geometry');
});

test('power leads retain 5 mm separation from each other and running gear', async () => {
  const probes = {
    'battery-positive-negative': `intersection() {
      union() {
        cable_path(battery_positive_path_a(), diameter = 23);
        cable_path(battery_positive_path_b(), diameter = 23);
      }
      cable_path(battery_negative_path());
    }`,
  };
  for (const [a, b] of [[0, 1], [0, 2], [1, 2]]) {
    probes[`phase-${a}-${b}`] = `intersection() {
      cable_path(motor_phase_path(${a}), diameter = 23);
      cable_path(motor_phase_path(${b}));
    }`;
  }
  for (let i = 0; i < 3; i++)
    for (const id of ['track', 'drive-drum', 'upper-roller-support', 'upper-roller', 'upper-roller-2']) {
      probes[`${id}-${i}`] = `intersection() {
        cable_path(motor_phase_path(${i}), diameter = 23);
        pod_component("${id}");
      }`;
    }
  for (const id of ['upper-roller-support', 'upper-roller', 'upper-roller-2']) {
    probes[`battery-${id}`] = `intersection() {
      battery_power_harness(grow = 5.5); pod_component("${id}");
    }`;
  }
  const volumes = await solidVolumes(probes);
  for (const [name, volume] of Object.entries(volumes)) {
    assert.ok(volume <= 0.01, `${name} keeps a provisional 5 mm clearance (overlap ${volume})`);
  }
});

test('battery leads bolt directly to terminals via the contactor; phases run direct inside the track silhouette', () => {
  for (const id of ['battery-harness', 'motor-harness']) {
    for (const body of ['battery_envelope()', 'battery_service_tray()',
      'traction_controller()', 'controller_support()', 'main_contactor()', 'hpm5000b_motor_envelope(-440)']) {
      const overlap = solidVolume(`intersection() { pod_component("${id}"); ${body}; }`);
      assert.ok(overlap <= 0.01, `${id} lands at faces instead of cutting through ${body} (overlap ${overlap})`);
    }
    assert.ok(solidVolume(`intersection() {
      pod_component("${id}"); translate([0, 1, 0]) traction_controller();
    }`) > 1, `${id} lands directly on the controller terminals`);
    assert.ok(solidVolume(`intersection() {
      pod_component("${id}");
      hull() { battery_envelope(); translate([0, 0, 305]) battery_envelope(); }
    }`) <= 0.01, `stationary ${id} stays out of the battery extraction path`);
  }
  assert.ok(solidVolume(`intersection() {
    battery_power_harness(); translate([0, 1, 0]) main_contactor();
  }`) > 1, 'battery positive is switched by the E-stop contactor');
  assert.ok(solidVolume(`intersection() {
    battery_power_harness(); translate([1, 0, 0]) battery_envelope();
  }`) > 1, 'ring lugs land directly on the battery terminal face, no service connector');
  assert.ok(solidVolume(`intersection() {
    motor_power_harness(); translate([0, 0, 1]) hpm5000b_motor_envelope(-440);
  }`) > 1, 'phase leads land directly on the motor terminal face');
  assert.ok(solidVolume(`difference() {
    motor_power_harness();
    linear_extrude(height = 2000, center = true) capsule_2d(10);
  }`) <= 0.01, 'phase leads do not protrude beyond the track side silhouette');
  // Grown battery leads (5.5 mm radius margin over low-poly cables) must not touch any phase lead.
  assert.ok(solidVolume(`intersection() {
    battery_power_harness(grow = 5.5); motor_power_harness();
  }`) <= 0.01, 'battery leads keep at least 5 mm to every phase lead');
  const plan = body => `linear_extrude(10) projection() rotate([-90, 0, 0]) intersection() {
    ${body} translate([-1000, 399.5, -1000]) cube(2000);
  }`;
  assert.ok(solidVolume(`intersection() {
    ${plan('battery_power_harness();')}
    ${plan('motor_power_harness();')}
  }`) <= 0.01, 'above the battery, battery leads and phase leads never cross in plan');
});
