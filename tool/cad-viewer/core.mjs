import path from 'node:path';
import { Marked } from 'marked';
import { gfmHeadingId } from 'marked-gfm-heading-id';

const viewerPath = 'docs/engineering/cad/viewer/index.html';
const allowedExtensions = new Set(['.md', '.png', '.jpg', '.jpeg', '.svg', '.pdf',
  '.scad', '.csv', '.json', '.html', '.js', '.css', '.stl']);
const escapeHtml = text => text.replaceAll('&', '&amp;').replaceAll('<', '&lt;')
  .replaceAll('>', '&gt;').replaceAll('"', '&quot;');

export function isDocumentPath(value) {
  return value === 'plan.md' || value === 'README.md'
    || (value.startsWith('docs/') && !value.split('/').some(part => part.startsWith('.'))
      && !value.includes('\\') && !value.includes('\0'));
}

export function resolveDocumentLink(href, document) {
  if (/^(https?:|mailto:)/i.test(href)) return href;
  if (/^[a-z][a-z\d+.-]*:|^\/\//i.test(href)) return null;
  const url = new URL(href, `http://localhost/${document}`);
  const target = decodeURIComponent(url.pathname.slice(1));
  if (!isDocumentPath(target)) return null;
  if (target === viewerPath) return `/${url.search}${url.hash}`;
  if (target.endsWith('.md')) {
    return `/?doc=${encodeURIComponent(target)}${url.hash}`;
  }
  return `/files/${target}${url.search}${url.hash}`;
}

export function renderDocument(markdown, document) {
  const parser = new Marked(gfmHeadingId());
  parser.use({
    walkTokens(token) {
      if (token.type === 'link' || token.type === 'image') {
        token.href = resolveDocumentLink(token.href, document) || '';
      }
    },
    renderer: {
      html({ text }) {
        // Preserve the repository's explicit stable anchors, not arbitrary HTML.
        return /^\s*(<a id="[a-zA-Z0-9_-]+">(<\/a>)?|<\/a>)\s*$/.test(text)
          ? text : escapeHtml(text);
      },
    },
  });
  return parser.parse(markdown);
}

export function resolveServedFile(requestPath) {
  let decoded;
  try {
    decoded = decodeURIComponent(requestPath);
  } catch {
    return null;
  }
  if (decoded.includes('\0') || decoded.includes('\\')
      || decoded.split('/').some(part => part === '..' || part.startsWith('.'))) return null;
  if (!decoded.startsWith('/files/')) return null;
  const relative = decoded.slice('/files/'.length);
  return isDocumentPath(relative) && allowedExtensions.has(path.extname(relative))
    ? relative : null;
}
