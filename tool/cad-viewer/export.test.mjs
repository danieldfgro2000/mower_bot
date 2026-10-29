import assert from 'node:assert/strict';
import { execFileSync } from 'node:child_process';
import { mkdtempSync, readFileSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { test } from 'node:test';

function boundsFor(component) {
  const directory = mkdtempSync(join(tmpdir(), 'mowerbot-cad-test-'));
  try {
    const output = join(directory, 'component.stl');
    execFileSync(process.env.OPENSCAD || 'openscad', [
      '--export-format', 'binstl', '-o', output,
      '-D', `viewer_component="${component}"`,
      'docs/engineering/cad/module-01-track-pod-fit.scad',
    ], { stdio: 'pipe' });
    const data = readFileSync(output);
    const min = [Infinity, Infinity, Infinity];
    const max = [-Infinity, -Infinity, -Infinity];
    for (let triangle = 0; triangle < data.readUInt32LE(80); triangle++) {
      for (let vertex = 0; vertex < 3; vertex++) {
        for (let axis = 0; axis < 3; axis++) {
          const value = data.readFloatLE(84 + triangle * 50 + 12 + vertex * 12 + axis * 4);
          min[axis] = Math.min(min[axis], value);
          max[axis] = Math.max(max[axis], value);
        }
      }
    }
    return { min, max, size: max.map((value, axis) => Math.round(value - min[axis])) };
  } finally {
    rmSync(directory, { recursive: true, force: true });
  }
}

test('SCAD component selector exports only the motor at its assembly position', () => {
  const { max, size } = boundsFor('motor');
  assert.deepEqual(size, [206, 206, 126]);
  assert.ok(max[0] < 0, 'motor remains at the drive end, not recentered for export');
  assert.equal(Math.round(max[2]), 100, 'published body starts at the outboard drum face');
});

test('assembly retains its pre-selector envelope and rollers export individually', () => {
  assert.deepEqual(boundsFor('assembly').size, [1105, 390, 387]);
  assert.deepEqual(boundsFor('lower-roller-1').size, [80, 80, 140]);
  assert.deepEqual(boundsFor('lower-roller-4').size, [80, 80, 140]);
  assert.ok(boundsFor('lower-roller-1').max[0] < boundsFor('lower-roller-4').min[0]);
});

test('unknown SCAD component names fail instead of producing an assembly', () => {
  assert.throws(() => boundsFor('unknown'), /Command failed/);
});
