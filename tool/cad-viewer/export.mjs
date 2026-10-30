import { mkdirSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import {
  root, viewerDirectory, outputDirectory,
  loadConfig, digest, inputDigest, assertFresh,
} from './assets.mjs';
import { render, inParallel } from './scad.mjs';

try {
  const config = loadConfig();
  if (process.argv.includes('--check')) {
    assertFresh(config);
    console.log(`CAD exports fresh: ${config.components.length} separate components and thumbnails`);
  } else {
    mkdirSync(path.join(root, outputDirectory), { recursive: true });
    mkdirSync(path.join(root, viewerDirectory, 'previews'), { recursive: true });
    const jobs = config.components.flatMap(({ id, renderParts = [] }) => [
      [`${outputDirectory}/${id}.stl`, 'stl', { component: id }],
      [`${viewerDirectory}/previews/${id}.png`, 'png', { component: id }],
      ...renderParts.map(part => [
        `${outputDirectory}/${part.id}.stl`, 'stl', { body: `${part.module}();` },
      ]),
    ]);
    const started = Date.now();
    const files = {};
    await inParallel(jobs, async ([file, kind, target]) => {
      const data = await render(config.source, kind, target);
      if (!data?.length) throw new Error(`Empty export: ${file}`);
      writeFileSync(path.join(root, file), data);
      files[file] = digest(data);
    });
    const ordered = Object.fromEntries(jobs.map(([file]) => [file, files[file]]));
    writeFileSync(path.join(root, outputDirectory, 'state.json'), JSON.stringify({
      input: inputDigest(config), files: ordered,
    }, null, 2) + '\n');
    assertFresh(config);
    console.log(`CAD components and linked thumbnails exported: ${config.components.length} `
      + `components in ${((Date.now() - started) / 1000).toFixed(1)} s`);
  }
} catch (error) {
  console.error(error.stderr?.toString() || error.message);
  process.exitCode = 1;
}
