import assert from 'node:assert/strict';
import { test } from 'node:test';
import { solidVolume, center } from './cad-test-helpers.mjs';

test('battery leads bolt directly to terminals via the contactor; phases run direct inside the track silhouette', () => {
  for (const id of ['battery-harness', 'motor-harness']) {
    for (const body of ['battery_envelope()', 'battery_hold_down()', 'battery_service_tray()',
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
    battery_power_harness(); translate([1, 0, 0]) main_contactor();
  }`) > 1, 'battery positive is switched by the E-stop contactor');
  assert.ok(solidVolume(`intersection() {
    battery_power_harness(); translate([-1, 0, 0]) battery_envelope();
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
