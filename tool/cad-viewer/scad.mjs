// Shared OpenSCAD runner with a content-addressed result cache.
// The cache key covers the OpenSCAD binary/version and every included SCAD
// file, so a geometry edit invalidates all results, while unchanged geometry
// (re-runs, component-map or test-only edits) reuses STL/PNG/probe output.
import { spawn, spawnSync } from 'node:child_process';
import { createHash } from 'node:crypto';
import {
  existsSync, mkdirSync, readdirSync, readFileSync, renameSync, rmSync, statSync, writeFileSync,
} from 'node:fs';
import { availableParallelism } from 'node:os';
import path from 'node:path';
import { root, outputDirectory, scadSources, readRepositoryFile } from './assets.mjs';

export const openscad = process.env.OPENSCAD || 'openscad';
const cacheRoot = path.join(root, outputDirectory, 'cache');
const keepCacheEntries = 6;
const cacheDisabled = process.env.CAD_CACHE === '0';
let identity;

const formats = {
  stl: ['--export-format', 'binstl'],
  png: ['--imgsize=240,160', '--viewall', '--autocenter', '--projection=ortho',
    '--render', '--colorscheme=Tomorrow'],
};

function openscadIdentity() {
  identity ??= `${openscad}\n${spawnSync(openscad, ['--version'], { encoding: 'utf8' }).stderr}`;
  return identity;
}

export function geometryKey(source) {
  const hash = createHash('sha256').update(openscadIdentity());
  for (const file of scadSources(source)) hash.update(`\0${file}\0`).update(readRepositoryFile(file));
  return hash.digest('hex').slice(0, 20);
}

function cacheDirectory(source) {
  const directory = path.join(cacheRoot, geometryKey(source));
  if (!existsSync(directory)) {
    mkdirSync(directory, { recursive: true });
    const entries = readdirSync(cacheRoot).map(name => path.join(cacheRoot, name))
      .sort((a, b) => statSync(b).mtimeMs - statSync(a).mtimeMs);
    for (const stale of entries.slice(keepCacheEntries)) rmSync(stale, { recursive: true, force: true });
  }
  return directory;
}

function job(source, kind, { component, body }) {
  const directory = cacheDirectory(source);
  const name = component !== undefined
    ? `${component}.${kind}`
    : `probe-${createHash('sha256').update(body).digest('hex').slice(0, 24)}.${kind}`;
  const file = path.join(directory, name);
  const temporary = `${file.slice(0, -kind.length - 1)}.${process.pid}-${Math.random().toString(36).slice(2)}.tmp.${kind}`;
  const args = [...formats[kind], '-o', temporary];
  const options = { cwd: root };
  if (component !== undefined) args.push('-D', `viewer_component="${component}"`, source);
  else {
    args.push('-');
    options.input = `use <${path.join(root, source)}>;\n$fn = 64;\n${body}`;
  }
  return { file, emptyMarker: `${file}.empty`, temporary, args, options, label: component ?? body };
}

function finish(work, status, output) {
  if (!/WARNING|ERROR/.test(output) && status === 1 && work.options.input !== undefined
      && output.includes('Current top level object is empty')) {
    if (!cacheDisabled) writeFileSync(work.emptyMarker, '');
    rmSync(work.temporary, { force: true });
    return null;
  }
  if (status !== 0 || /WARNING|ERROR/.test(output)) {
    rmSync(work.temporary, { force: true });
    throw new Error(`OpenSCAD failed for ${work.label}:\n${output}`);
  }
  if (cacheDisabled) {
    const data = readFileSync(work.temporary);
    rmSync(work.temporary, { force: true });
    return data;
  }
  renameSync(work.temporary, work.file);
  return readFileSync(work.file);
}

function cached(work) {
  if (cacheDisabled) return undefined;
  if (existsSync(work.file)) return readFileSync(work.file);
  if (existsSync(work.emptyMarker)) return null;
  return undefined;
}

/** Synchronous render; returns the output Buffer, or null for an empty probe. */
export function renderSync(source, kind, target) {
  const work = job(source, kind, target);
  const hit = cached(work);
  if (hit !== undefined) return hit;
  const result = spawnSync(openscad, work.args, { ...work.options, encoding: 'utf8' });
  if (result.error) throw result.error;
  return finish(work, result.status, result.stdout + result.stderr);
}

/** Asynchronous render with the same cache and failure rules as renderSync. */
export function render(source, kind, target) {
  const work = job(source, kind, target);
  const hit = cached(work);
  if (hit !== undefined) return Promise.resolve(hit);
  return new Promise((resolve, reject) => {
    const child = spawn(openscad, work.args, { cwd: work.options.cwd });
    let output = '';
    child.stdout.on('data', chunk => { output += chunk; });
    child.stderr.on('data', chunk => { output += chunk; });
    child.on('error', reject);
    child.on('close', status => {
      try { resolve(finish(work, status, output)); } catch (error) { reject(error); }
    });
    child.stdin.end(work.options.input ?? '');
  });
}

/** Run async jobs with a bounded worker pool, preserving result order. */
export async function inParallel(items, worker, limit = availableParallelism()) {
  const results = new Array(items.length);
  let next = 0;
  await Promise.all(Array.from({ length: Math.min(limit, items.length) }, async () => {
    while (next < items.length) {
      const index = next++;
      results[index] = await worker(items[index], index);
    }
  }));
  return results;
}
