import { spawnSync } from 'node:child_process';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { root } from './assets.mjs';

const dimensions = [
  'post_width_mm', 'post_height_mm', 'post_span_mm', 'post_spacing_mm',
  'post_offset_mm', 'motor_cg_from_post_root_mm',
  'rail_width_mm', 'rail_height_mm', 'rail_span_mm',
  'cross_width_mm', 'cross_height_mm', 'cross_span_mm',
  'front_width_mm', 'front_height_mm', 'front_span_mm', 'front_guide_offset_mm',
  'plate_net_thickness_mm', 'motor_pcd_mm', 'motor_bolt_mm',
];

const study = Object.freeze({
  modulusMPa: 200000,
  yieldMPa: 235,
  stressFactor: 2,
  deflectionLimitMm: 1,
  motorPeakNm: 45,
  torqueFactor: 2,
  motorMassKg: 11,
  motorAccelerationG: 2,
  botMassKg: 300,
  podFraction: 0.5,
  podAccelerationG: 2,
  worstRailFraction: 0.75,
  motorBolts: 4,
  gravity: 9.81,
});

function positive(name, value) {
  if (!Number.isFinite(value) || value <= 0) throw new Error(`${name} must be a positive finite number`);
}

function finite(name, value) {
  if (!Number.isFinite(value)) throw new Error(`${name} must be finite`);
}

function validateGeometry(geometry) {
  if (!geometry || typeof geometry !== 'object') throw new Error('Frame geometry is required');
  for (const name of dimensions) {
    if (['post_offset_mm', 'motor_cg_from_post_root_mm', 'front_guide_offset_mm'].includes(name)) {
      finite(name, geometry[name]);
      if (geometry[name] < 0) throw new Error(`${name} must not be negative`);
    } else {
      positive(name, geometry[name]);
    }
  }
}

function combinedStress(bendingMPa, shearMPa) {
  return Math.hypot(bendingMPa, Math.sqrt(3) * shearMPa);
}

export function cantileverScreen({
  forceX, forceY, axialForce = 0, widthMomentNmm = 0, torqueNmm = 0,
  span, width, height, modulus, shearModulus = modulus / 2.6,
}) {
  for (const [name, value] of Object.entries({ span, width, height, modulus, shearModulus })) {
    positive(name, value);
  }
  for (const [name, value] of Object.entries({ forceX, forceY, axialForce, widthMomentNmm, torqueNmm })) {
    finite(name, value);
  }
  const inertiaX = width * height ** 3 / 12;
  const inertiaY = height * width ** 3 / 12;
  const bendingMPa = (Math.abs(forceX) * span + Math.abs(widthMomentNmm)) * width / (2 * inertiaY)
    + Math.abs(forceY) * span * height / (2 * inertiaX);
  const axialMPa = Math.abs(axialForce) / (width * height);
  const longSide = Math.max(width, height), shortSide = Math.min(width, height);
  // Lower-bound solid-rectangle torsion coefficients conservatively bound stress and twist.
  const torsionShearMPa = Math.abs(torqueNmm) / (0.2 * longSide * shortSide ** 2);
  const torsionConstant = 0.14 * longSide * shortSide ** 3;
  const torsionTipMm = Math.abs(torqueNmm) * span / (shearModulus * torsionConstant)
    * Math.hypot(width, height) / 2;
  const shearMPa = 1.5 * Math.hypot(forceX, forceY) / (width * height) + torsionShearMPa;
  const deflectionMm = Math.hypot(
    (Math.abs(forceX) * span ** 3 / 3 + Math.abs(widthMomentNmm) * span ** 2 / 2)
      / (modulus * inertiaY),
    forceY * span ** 3 / (3 * modulus * inertiaX),
    axialForce * span / (modulus * width * height),
  ) + torsionTipMm;
  return {
    bendingMPa, axialMPa, shearMPa, torsionShearMPa, torsionTipMm,
    combinedMPa: combinedStress(bendingMPa + axialMPa, shearMPa), deflectionMm,
  };
}

export function simplySupportedScreen({ load, span, width, height, modulus }) {
  for (const [name, value] of Object.entries({ span, width, height, modulus })) positive(name, value);
  finite('load', load);
  if (load < 0) throw new Error('load must not be negative');
  const inertia = width * height ** 3 / 12;
  const bendingMPa = load * span * height / (8 * inertia);
  const shearMPa = 1.5 * load / (2 * width * height);
  const deflectionMm = load * span ** 3 / (48 * modulus * inertia);
  return { bendingMPa, shearMPa, combinedMPa: combinedStress(bendingMPa, shearMPa), deflectionMm };
}

export function evaluateFrameStudy(geometry) {
  validateGeometry(geometry);
  const motorForce = study.motorMassKg * study.gravity * study.motorAccelerationG;
  const podForce = study.botMassKg * study.podFraction * study.gravity * study.podAccelerationG;
  const torqueNm = study.motorPeakNm * study.torqueFactor;
  const motor = {
    id: 'motor-post',
    forceX: (torqueNm * 1000 + motorForce * geometry.post_offset_mm) / geometry.post_spacing_mm,
    forceY: motorForce / 2,
    axialForce: motorForce * geometry.motor_cg_from_post_root_mm / geometry.post_spacing_mm,
  };
  Object.assign(motor, cantileverScreen({
    forceX: motor.forceX, forceY: motor.forceY, axialForce: motor.axialForce,
    span: geometry.post_span_mm, width: geometry.post_width_mm,
    height: geometry.post_height_mm, modulus: study.modulusMPa,
  }));
  const beam = (id, loadN, width, height, span) => ({
    id, loadN, ...simplySupportedScreen({ load: loadN, span, width, height, modulus: study.modulusMPa }),
  });
  const front = {
    id: 'front-idler-rail',
    loadN: podForce,
    axialForce: podForce,
    widthMomentNmm: podForce * geometry.front_guide_offset_mm,
    torqueNmm: podForce * geometry.front_guide_offset_mm,
  };
  Object.assign(front, cantileverScreen({
    forceX: 0, forceY: front.loadN, axialForce: front.axialForce,
    widthMomentNmm: front.widthMomentNmm, torqueNmm: front.torqueNmm,
    span: geometry.front_span_mm, width: geometry.front_width_mm,
    height: geometry.front_height_mm, modulus: study.modulusMPa,
  }));
  const cases = [
    motor,
    beam('notched-rail', podForce * study.worstRailFraction,
      geometry.rail_width_mm, geometry.rail_height_mm, geometry.rail_span_mm),
    beam('rear-crossmember', podForce,
      geometry.cross_width_mm, geometry.cross_height_mm, geometry.cross_span_mm),
    front,
  ].map(item => ({
    ...item,
    stressLimitMPa: study.yieldMPa / study.stressFactor,
    deflectionLimitMm: study.deflectionLimitMm,
    passed: item.combinedMPa <= study.yieldMPa / study.stressFactor
      && item.deflectionMm <= study.deflectionLimitMm,
  }));
  const boltLoad = torqueNm * 1000 / (study.motorBolts * geometry.motor_pcd_mm / 2)
    + motorForce / study.motorBolts;
  return {
    qualified: false,
    passed: cases.every(item => item.passed),
    cases,
    averagePlateBearingMPa: boltLoad / (geometry.motor_bolt_mm * geometry.plate_net_thickness_mm),
  };
}

export function readFrameGeometry() {
  const source = path.join(root, 'docs/engineering/technical/cad/module-01-track-pod-fit.scad');
  const input = `use <${source}>;\necho("MOWERBOT_STRUCTURE", frame_structural_study());\n`;
  const result = spawnSync(process.env.OPENSCAD || 'openscad', ['-o', '-', '--export-format=echo', '-'], {
    cwd: root, input, encoding: 'utf8',
  });
  if (result.error) throw result.error;
  const output = result.stdout + result.stderr;
  if (result.status !== 0 || /\b(?:WARNING|ERROR):/.test(output)) {
    throw new Error(`OpenSCAD structural geometry probe failed:\n${output}`);
  }
  const matches = [...output.matchAll(/^ECHO: "MOWERBOT_STRUCTURE", (\[.*\])$/gm)];
  if (matches.length !== 1) throw new Error('OpenSCAD did not return exactly one structural geometry record');
  const entries = JSON.parse(matches[0][1]);
  if (!Array.isArray(entries) || entries.length !== dimensions.length
      || entries.some(entry => !Array.isArray(entry) || entry.length !== 2 || !dimensions.includes(entry[0]))
      || new Set(entries.map(entry => entry[0])).size !== dimensions.length) {
    throw new Error('OpenSCAD returned an invalid structural geometry record');
  }
  const geometry = Object.fromEntries(entries);
  validateGeometry(geometry);
  return geometry;
}

function report() {
  const geometry = readFrameGeometry();
  const result = evaluateFrameStudy(geometry);
  console.log('PRELIMINARY LOCAL BEAM SCREENS - NOT MACHINE OR JOINT QUALIFICATION');
  console.log('S235 assumed: E = 200000 MPa, Poisson ratio = 0.3, yield = 235 MPa;');
  console.log('screening limits = 117.5 MPa and 1 mm.');
  console.log('Motor: 45 Nm advertised peak x 2, plus 11 kg x 2 g at the motor axis;');
  console.log('the 120 mm post offset and assumed mid-body CG add to loading; full post span used.');
  console.log('Pod: 300 kg bot / 2 x 2 g = 2943 N; rear rail receives 75%, crossmember 100%.');
  console.log('Front: 2943 N each vertical and axial on one ideal cantilever, at the guide offset;');
  console.log('eccentric bending and solid-bar torsion included; guide joints and buckling unchecked.');
  console.log('Case                 Load                       Combined stress   Deflection   Screen');
  for (const item of result.cases) {
    const load = item.id === 'motor-post'
      ? `${item.forceX.toFixed(1)} / ${item.forceY.toFixed(1)} / ${item.axialForce.toFixed(1)} N`
      : item.id === 'front-idler-rail'
        ? `${item.loadN.toFixed(1)} + axial ${item.axialForce.toFixed(1)} N`
        : `${item.loadN.toFixed(1)} N`;
    console.log(`${item.id.padEnd(20)} ${load.padEnd(26)} ${item.combinedMPa.toFixed(1).padStart(6)} MPa`
      + ` ${item.deflectionMm.toFixed(3).padStart(8)} mm   ${item.passed ? 'PASS' : 'FAIL'}`);
  }
  console.log(`Ideal four-bolt average plate bearing: ${result.averagePlateBearingMPa.toFixed(1)} MPa`
    + ' (informational only; bolts, threads and joints unchecked).');
  console.log('Fixed-ring torque, bearings, welds, fatigue, impact, braking, scissor/spine loads,'
    + ' track forces, stiffness and full-vehicle stability remain unverified.');
  if (!result.passed) process.exitCode = 1;
}

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  report();
}
