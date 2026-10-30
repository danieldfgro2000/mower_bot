// Shared fit-study helpers for the *.test.mjs geometry files. OpenSCAD output
// comes from the content-addressed cache in scad.mjs (CAD_CACHE=0 disables it).
import { render, renderSync, inParallel } from './scad.mjs';

export const source = 'docs/engineering/technical/cad/module-01-track-pod-fit.scad';
const meshes = new Map();

export function boundsFor(component) {
  if (meshes.has(component)) return meshes.get(component);
  const data = renderSync(source, 'stl', { component });
  const triangles = [];
  const min = [Infinity, Infinity, Infinity];
  const max = [-Infinity, -Infinity, -Infinity];
  for (let triangle = 0; triangle < data.readUInt32LE(80); triangle++) {
    const vertices = [];
    for (let vertex = 0; vertex < 3; vertex++) {
      const point = [];
      for (let axis = 0; axis < 3; axis++) {
        const value = data.readFloatLE(84 + triangle * 50 + 12 + vertex * 12 + axis * 4);
        point.push(value);
        min[axis] = Math.min(min[axis], value);
        max[axis] = Math.max(max[axis], value);
      }
      vertices.push(point);
    }
    triangles.push(vertices);
  }
  const mesh = { min, max, triangles, size: max.map((value, axis) => Math.round(value - min[axis])) };
  meshes.set(component, mesh);
  return mesh;
}

export function solidVolume(body) {
  return meshVolume(renderSync(source, 'stl', { body }));
}

/** Parallel solidVolume for independent probes: { name: body } -> { name: volume }. */
export async function solidVolumes(bodies) {
  const entries = Object.entries(bodies);
  const volumes = await inParallel(entries, async ([, body]) =>
    meshVolume(await render(source, 'stl', { body })));
  return Object.fromEntries(entries.map(([name], i) => [name, volumes[i]]));
}

function meshVolume(data) {
  if (data === null) return 0;
  let volume = 0;
  for (let i = 0; i < data.readUInt32LE(80); i++) {
    const vertices = [0, 1, 2].map(j => [0, 1, 2].map(axis =>
      data.readFloatLE(84 + i * 50 + 12 + j * 12 + axis * 4)));
    const [a, b, c] = vertices;
    volume += a.reduce((sum, value, k) => sum + value
      * (b[(k + 1) % 3] * c[(k + 2) % 3] - b[(k + 2) % 3] * c[(k + 1) % 3]), 0) / 6;
  }
  return Math.abs(volume);
}

export const center = mesh => mesh.min.map((value, axis) => (value + mesh.max[axis]) / 2);

export function pitchPath(circles) {
  const normals = circles.map((a, i) => {
    const b = circles[(i + 1) % circles.length];
    const dx = b[0] - a[0], dy = b[1] - a[1], distance = Math.hypot(dx, dy);
    const k = (a[2] - b[2]) / distance, q = Math.sqrt(1 - k * k);
    return [(dx * k + dy * q) / distance, (dy * k - dx * q) / distance];
  });
  const length = circles.reduce((total, a, i) => {
    const b = circles[(i + 1) % circles.length];
    const incoming = normals[(i + circles.length - 1) % circles.length];
    const outgoing = normals[i];
    const arc = (Math.atan2(outgoing[1], outgoing[0])
      - Math.atan2(incoming[1], incoming[0]) + 2 * Math.PI) % (2 * Math.PI);
    return total + Math.sqrt((b[0] - a[0]) ** 2 + (b[1] - a[1]) ** 2
      - (b[2] - a[2]) ** 2) + a[2] * arc;
  }, 0);
  return { normals, length };
}

export function contains(mesh, point) {
  const subtract = (a, b) => a.map((value, i) => value - b[i]);
  const dot = (a, b) => a.reduce((sum, value, i) => sum + value * b[i], 0);
  const cross = (a, b) => [
    a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2],
    a[0] * b[1] - a[1] * b[0],
  ];
  const direction = [0.137, 0.263, 1];
  const hits = [];
  for (const [a, b, c] of mesh.triangles) {
    const edge1 = subtract(b, a), edge2 = subtract(c, a);
    const p = cross(direction, edge2);
    const determinant = dot(edge1, p);
    if (Math.abs(determinant) < 1e-8) continue;
    const offset = subtract(point, a);
    const u = dot(offset, p) / determinant;
    if (u < 0 || u > 1) continue;
    const q = cross(offset, edge1);
    const v = dot(direction, q) / determinant;
    if (v < 0 || u + v > 1) continue;
    const distance = dot(edge2, q) / determinant;
    if (distance > 1e-5 && !hits.some(hit => Math.abs(hit - distance) < 1e-4)) hits.push(distance);
  }
  return hits.length % 2 === 1;
}
