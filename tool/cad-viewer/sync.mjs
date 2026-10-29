// One command after any SCAD, component-map or engineering Markdown change:
// validate SCAD <-> manifest <-> Markdown, re-export only when stale, then verify.
import { spawnSync } from 'node:child_process';
import { root, loadConfig, assertFresh, readRepositoryFile } from './assets.mjs';
import { checkDocumentationLinks, readMarkdownDocuments } from './links.mjs';

const checkOnly = process.argv.includes('--check');
try {
  const config = loadConfig();
  const documents = readMarkdownDocuments(root);
  for (const file of Object.keys(documents)) {
    documents[file] = readRepositoryFile(file).toString();
  }
  const errors = checkDocumentationLinks(config, documents);
  if (errors.length) throw new Error(`Documentation and CAD components differ:\n- ${errors.join('\n- ')}`);
  console.log(`Links in sync: ${config.components.length} components, ${Object.keys(documents).length} Markdown files`);

  let stale = null;
  try {
    assertFresh(config);
  } catch (error) {
    stale = error;
  }
  if (stale && checkOnly) throw stale;
  if (stale) {
    console.log(`Re-exporting: ${stale.message.split('.')[0]}`);
    const result = spawnSync(process.execPath, ['tool/cad-viewer/export.mjs'], {
      cwd: root, stdio: 'inherit',
    });
    if (result.status !== 0) throw new Error('CAD export failed');
    assertFresh(config);
  }
  console.log(stale ? 'CAD exports regenerated and fresh' : 'CAD exports already fresh');
  console.log('Restart a running viewer to load a changed component map or geometry.');
} catch (error) {
  console.error(error.message);
  process.exitCode = 1;
}
