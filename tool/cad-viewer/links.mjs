import { readdirSync } from 'node:fs';
import path from 'node:path';

const componentLink = /(?:presentation\/)?viewer\/index\.html\?component=([a-z0-9-]+)/g;
const thumbnail = /(?:presentation\/)?viewer\/previews\/([a-z0-9-]+)\.png/g;
const linkedThumbnail =
  /\[!\[[^\]]*\]\([^)]*(?:presentation\/)?viewer\/previews\/([a-z0-9-]+)\.png\)\]\([^)]*(?:presentation\/)?viewer\/index\.html\?component=([a-z0-9-]+)\)/g;

// Pure check: SCAD/manifest components versus Markdown 3D entry points.
export function checkDocumentationLinks(config, documents) {
  const ids = new Set(config.components.map(part => part.id));
  const linked = new Set();
  const errors = [];
  for (const [file, markdown] of Object.entries(documents)) {
    for (const [, id] of markdown.matchAll(componentLink)) {
      if (ids.has(id)) linked.add(id);
      else errors.push(`${file}: link to unknown component "${id}"`);
    }
    for (const [, id] of markdown.matchAll(thumbnail)) {
      if (!ids.has(id)) errors.push(`${file}: unknown thumbnail "${id}"`);
    }
    for (const [, image, target] of markdown.matchAll(linkedThumbnail)) {
      if (image !== target) {
        errors.push(`${file}: thumbnail "${image}" links to component "${target}"`);
      }
    }
  }
  for (const id of ids) {
    if (!linked.has(id)) errors.push(`Component "${id}" has no Markdown entry point`);
  }
  return errors;
}

export function readMarkdownDocuments(root) {
  const documents = {};
  const visit = relative => {
    for (const entry of readdirSync(path.join(root, relative), { withFileTypes: true })) {
      const child = path.posix.join(relative, entry.name);
      if (entry.name.startsWith('.') || entry.name === 'node_modules') continue;
      if (entry.isDirectory()) visit(child);
      else if (entry.name.endsWith('.md')) documents[child] = null;
    }
  };
  visit('docs');
  for (const file of ['README.md', 'plan.md']) documents[file] = null;
  return documents;
}
