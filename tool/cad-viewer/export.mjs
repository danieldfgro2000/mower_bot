import { spawnSync } from 'node:child_process';
import { mkdirSync, writeFileSync } from 'node:fs';
import path from 'node:path';
import {
  root, viewerDirectory, outputDirectory, readRepositoryFile,
  loadConfig, digest, inputDigest, assertFresh,
} from './assets.mjs';

try {
  const config = loadConfig();
  if (process.argv.includes('--check')) {
    assertFresh(config);
    console.log(`CAD exports fresh: ${config.components.length} separate components and thumbnails`);
  } else {
    mkdirSync(path.join(root, outputDirectory), { recursive: true });
    mkdirSync(path.join(root, viewerDirectory, 'previews'), { recursive: true });
    const files = {};
    for (const component of config.components) {
      const stl = `${outputDirectory}/${component.id}.stl`;
      const png = `${viewerDirectory}/previews/${component.id}.png`;
      for (const [file, options] of [
        [stl, ['--export-format', 'binstl']],
        [png, ['--imgsize=240,160', '--viewall', '--autocenter',
          '--projection=ortho', '--render', '--colorscheme=Tomorrow']],
      ]) {
        const result = spawnSync(process.env.OPENSCAD || 'openscad', [
          ...options, '-o', file,
          '-D', `viewer_component="${component.id}"`, config.source,
        ], { cwd: root, encoding: 'utf8', stdio: 'pipe' });
        if (result.error) throw result.error;
        const output = result.stdout + result.stderr;
        if (result.status !== 0 || /\b(ERROR|WARNING):/.test(output)) {
          throw new Error(`OpenSCAD failed for ${component.id} (${file}):\n${output}`);
        }
        const data = readRepositoryFile(file);
        if (!data.length) throw new Error(`Empty export: ${file}`);
        files[file] = digest(data);
      }
      console.log(`Exported ${component.id}`);
    }
    writeFileSync(path.join(root, outputDirectory, 'state.json'), JSON.stringify({
      input: inputDigest(config), files,
    }, null, 2) + '\n');
    assertFresh(config);
    console.log('CAD components and linked thumbnails exported');
  }
} catch (error) {
  console.error(error.stderr?.toString() || error.message);
  process.exitCode = 1;
}
