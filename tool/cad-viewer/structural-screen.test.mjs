import assert from 'node:assert/strict';
import { test } from 'node:test';
import {
  cantileverScreen, simplySupportedScreen, evaluateFrameStudy, readFrameGeometry,
} from './structural-screen.mjs';

const near = (actual, expected, tolerance = 1e-6) =>
  assert.ok(Math.abs(actual - expected) <= tolerance, `${actual} should be ${expected}`);

const geometry = {
  post_width_mm: 24,
  post_height_mm: 24,
  post_span_mm: 144,
  post_spacing_mm: 80,
  post_offset_mm: 120,
  motor_cg_from_post_root_mm: 79,
  rail_width_mm: 10,
  rail_height_mm: 39.9,
  rail_span_mm: 140.103,
  cross_width_mm: 20,
  cross_height_mm: 20,
  cross_span_mm: 190,
  front_width_mm: 20,
  front_height_mm: 65,
  front_span_mm: 212,
  front_guide_offset_mm: 27,
  plate_net_thickness_mm: 8,
  motor_pcd_mm: 148,
  motor_bolt_mm: 8,
};

test('cantilever screen matches orthogonal hand-calculated bending and tip deflection', () => {
  const result = cantileverScreen({
    forceX: 1000, forceY: 500, span: 100, width: 20, height: 20, modulus: 200000,
  });
  near(result.bendingMPa, 112.5);
  near(result.shearMPa, 1.5 * Math.hypot(1000, 500) / 400);
  near(result.deflectionMm, Math.hypot(1000, 500) * 100 ** 3 / (3 * 200000 * (20 * 20 ** 3 / 12)));
  assert.ok(result.combinedMPa > result.bendingMPa);
});

test('simply supported screen matches a central point-load reference', () => {
  const result = simplySupportedScreen({
    load: 1000, span: 200, width: 20, height: 20, modulus: 200000,
  });
  near(result.bendingMPa, 37.5);
  near(result.shearMPa, 1.875);
  near(result.deflectionMm, 0.0625);
  assert.ok(result.combinedMPa > result.bendingMPa);
});

test('eccentric axial and vertical forces add bending and torsion to a cantilever', () => {
  const result = cantileverScreen({
    forceX: 0, forceY: 0, axialForce: 1000, widthMomentNmm: 10000,
    torqueNmm: 10000, span: 100, width: 20, height: 20, modulus: 200000,
  });
  near(result.bendingMPa, 7.5);
  near(result.axialMPa, 2.5);
  near(result.torsionShearMPa, 10000 / (0.2 * 20 * 20 ** 2));
  const torsionTip = 10000 * 100 / ((200000 / 2.6) * (0.14 * 20 * 20 ** 3))
    * Math.hypot(20, 20) / 2;
  near(result.torsionTipMm, torsionTip);
  near(result.deflectionMm, Math.hypot(0.01875, 0.00125) + torsionTip);
  assert.ok(result.combinedMPa > 10, 'torque increases combined stress');
});

test('study reports local cases, their loads and limits without claiming qualification', () => {
  const result = evaluateFrameStudy(geometry);
  assert.equal(result.qualified, false);
  assert.equal(result.passed, true);
  const cases = Object.fromEntries(result.cases.map(item => [item.id, item]));
  near(cases['motor-post'].forceX, 1448.73);
  near(cases['motor-post'].forceY, 107.91);
  near(cases['motor-post'].axialForce, 213.12225);
  near(cases['notched-rail'].loadN, 2207.25);
  near(cases['rear-crossmember'].loadN, 2943);
  assert.ok(cases['front-idler-rail'], 'the front idler rail has a separate load case');
  near(cases['front-idler-rail'].loadN, 2943);
  near(cases['front-idler-rail'].axialForce, 2943);
  near(cases['front-idler-rail'].widthMomentNmm, 2943 * 27);
  near(cases['front-idler-rail'].torqueNmm, 2943 * 27);
  near(cases['motor-post'].combinedMPa, 97.8796, 0.001);
  near(cases['rear-crossmember'].combinedMPa, 105.2791, 0.001);
  near(cases['front-idler-rail'].combinedMPa, 72.5178, 0.001);
  near(cases['front-idler-rail'].deflectionMm, 0.33225, 0.00001);
  for (const item of result.cases) {
    assert.ok(item.combinedMPa > 0 && item.combinedMPa < 117.5, item.id);
    assert.ok(item.deflectionMm > 0 && item.deflectionMm < 1, item.id);
    assert.equal(item.passed, true);
  }
});

test('motor weight at an offset increases the post couple and axial load', () => {
  const offset = evaluateFrameStudy(geometry).cases[0];
  const centered = evaluateFrameStudy({
    ...geometry, post_offset_mm: 0, motor_cg_from_post_root_mm: 0,
  }).cases[0];
  assert.ok(offset.forceX > centered.forceX);
  assert.ok(offset.axialForce > centered.axialForce);
  assert.ok(offset.combinedMPa > centered.combinedMPa);
});

test('smaller posts, the original notch, and a thin crossmember fail their screens', () => {
  for (const [changes, id] of [
    [{ post_width_mm: 8 }, 'motor-post'],
    [{ rail_height_mm: 19.9 }, 'notched-rail'],
    [{ cross_height_mm: 8 }, 'rear-crossmember'],
    [{ front_height_mm: 13 }, 'front-idler-rail'],
  ]) {
    const result = evaluateFrameStudy({ ...geometry, ...changes });
    assert.equal(result.passed, false, id);
    assert.equal(result.cases.find(item => item.id === id).passed, false, id);
  }
});

test('invalid input is rejected and geometry is read from the actual SCAD design', () => {
  assert.throws(() => simplySupportedScreen({
    load: 1000, span: 200, width: 0, height: 20, modulus: 200000,
  }), /width/i);
  assert.throws(() => evaluateFrameStudy({ ...geometry, rail_height_mm: NaN }), /rail_height_mm/i);
  assert.throws(() => evaluateFrameStudy({ ...geometry, front_guide_offset_mm: -1 }), /front_guide_offset_mm/i);
  assert.throws(() => cantileverScreen({
    forceX: 0, forceY: 0, torqueNmm: Infinity, span: 100, width: 20, height: 20, modulus: 200000,
  }), /torqueNmm/i);
  const actual = readFrameGeometry();
  for (const [key, value] of Object.entries(geometry)) near(actual[key], value, 0.001);
});
