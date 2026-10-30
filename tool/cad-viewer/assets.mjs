import { createHash } from 'node:crypto';
import { existsSync, readFileSync, realpathSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import { isDocumentPath, renderDocument } from './core.mjs';
import { validateGroups } from '../../docs/engineering/presentation/viewer/visibility.mjs';
import { validateAnimations } from '../../docs/engineering/presentation/viewer/animation.mjs';

export const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '../..');
export const viewerDirectory = 'docs/engineering/presentation/viewer';
export const outputDirectory = 'build/cad-viewer';

export function readRepositoryFile(relative) {
  const resolved = realpathSync(path.join(root, relative));
  if (!resolved.startsWith(`${root}${path.sep}`)) throw new Error('File escapes repository');
  return readFileSync(resolved);
}

export function loadConfig() {
  const config = JSON.parse(readRepositoryFile(`${viewerDirectory}/components.json`));
  if (!config.source.startsWith('docs/engineering/technical/cad/') || !config.source.endsWith('.scad')) {
    throw new Error('Component source must be an engineering SCAD file');
  }
  const ids = new Set();
  for (const component of config.components) {
    if (!/^[a-z][a-z0-9-]*$/.test(component.id) || ids.has(component.id)) {
      throw new Error(`Invalid or duplicate component ID: ${component.id}`);
    }
    if (!/^#[a-f\d]{6}$/i.test(component.color) || !component.label) {
      throw new Error(`Missing label or invalid color: ${component.id}`);
    }
    if (component.presentation
        !== `docs/engineering/presentation/parts.md#${component.id}`) {
      throw new Error(`Invalid presentation target: ${component.id}`);
    }
    ids.add(component.id);
  }
  validateGroups(config.groups, config.components);
  validateAnimations(config.animations, config.components);
  const source = readRepositoryFile(config.source).toString();
  const selectors = source.match(/viewer_components\s*=\s*\[([\s\S]*?)\]/)?.[1]
    .match(/"[^"]+"/g)?.map(value => JSON.parse(value));
  if (!selectors || selectors.length !== ids.size || selectors.some(id => !ids.has(id))) {
    throw new Error('SCAD component selectors and documentation manifest differ');
  }
  for (const target of [
    config.defaultDocument,
    config.defaultPresentation,
    ...config.components.flatMap(part => [part.document, part.presentation]),
    ...(config.animations ?? []).map(animation => animation.document),
  ]) {
    const [document, anchor] = target.split('#');
    if (!isDocumentPath(document) || !document.endsWith('.md')) {
      throw new Error(`Invalid component documentation path: ${target}`);
    }
    const html = renderDocument(readRepositoryFile(document).toString(), document);
    if (anchor && !html.includes(`id="${anchor}"`)) {
      throw new Error(`Missing component documentation anchor: ${target}`);
    }
  }
  return config;
}

export function digest(data) {
  return createHash('sha256').update(data).digest('hex');
}

/** Entry SCAD file plus every file it includes or uses, repository-relative. */
export function scadSources(entry) {
  const files = [];
  const visit = file => {
    if (files.includes(file)) return;
    files.push(file);
    for (const [, target] of readRepositoryFile(file).toString()
      .matchAll(/^\s*(?:include|use)\s*<([^>]+)>/gm)) {
      visit(path.posix.join(path.posix.dirname(file), target));
    }
  };
  visit(entry);
  return files;
}

export function inputDigest(config) {
  return digest(Buffer.concat([
    ...scadSources(config.source).map(file => readRepositoryFile(file)),
    readRepositoryFile(`${viewerDirectory}/components.json`),
    readRepositoryFile('tool/cad-viewer/export.mjs'),
  ]));
}

export function assertFresh(config) {
  if (!existsSync(path.join(root, outputDirectory, 'state.json'))) {
    throw new Error('CAD exports missing. Run npm run export --prefix tool/cad-viewer');
  }
  const state = JSON.parse(readRepositoryFile(`${outputDirectory}/state.json`));
  if (state.input !== inputDigest(config)) {
    throw new Error('CAD exports are stale. Run npm run export --prefix tool/cad-viewer');
  }
  const expected = config.components.flatMap(part => [
    `${outputDirectory}/${part.id}.stl`, `${viewerDirectory}/previews/${part.id}.png`,
  ]);
  if (Object.keys(state.files).length !== expected.length) throw new Error('Incomplete CAD exports');
  for (const file of expected) {
    if (state.files[file] !== digest(readRepositoryFile(file))) {
      throw new Error(`Missing or modified CAD export: ${file}. Run npm run export --prefix tool/cad-viewer`);
    }
  }
}
