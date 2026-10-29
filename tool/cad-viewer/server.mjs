import { createServer } from 'node:http';
import { readFileSync, realpathSync } from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';
import {
  root, viewerDirectory, outputDirectory, loadConfig, assertFresh, readRepositoryFile,
} from './assets.mjs';
import { renderDocument, resolveServedFile } from './core.mjs';

const mime = {
  '.html': 'text/html; charset=utf-8', '.js': 'text/javascript',
  '.css': 'text/css', '.json': 'application/json', '.md': 'text/plain; charset=utf-8',
  '.scad': 'text/plain; charset=utf-8', '.csv': 'text/plain; charset=utf-8',
  '.png': 'image/png', '.svg': 'image/svg+xml', '.stl': 'model/stl',
};

export function createViewerServer() {
  const config = loadConfig();
  assertFresh(config);
  return createServer((request, response) => {
    const send = (status, data, type = 'text/plain; charset=utf-8') => {
      response.writeHead(status, {
        'Content-Type': type, 'X-Content-Type-Options': 'nosniff',
        'Cache-Control': 'no-store', 'Referrer-Policy': 'no-referrer',
      });
      response.end(data);
    };
    try {
      if (request.method !== 'GET' && request.method !== 'HEAD') return send(405, 'Read-only viewer');
      const url = new URL(request.url, 'http://127.0.0.1');
      if (url.pathname === '/api/health') return send(200, 'ok');
      if (url.pathname === '/api/config') {
        return send(200, JSON.stringify(config), 'application/json');
      }
      if (url.pathname === '/api/document') {
        const document = url.searchParams.get('path') || config.defaultDocument;
        if (resolveServedFile(`/files/${document}`) !== document || !document.endsWith('.md')) {
          return send(400, 'Invalid documentation path');
        }
        return send(200, renderDocument(readRepositoryFile(document).toString(), document),
          'text/html; charset=utf-8');
      }
      let file;
      if (url.pathname === '/') file = `${viewerDirectory}/index.html`;
      else if (/^\/viewer\/(app\.js|scene\.js|style\.css)$/.test(url.pathname)) {
        file = `${viewerDirectory}/${path.basename(url.pathname)}`;
      } else if (url.pathname.startsWith('/models/')) {
        const id = url.pathname.slice('/models/'.length).replace(/\.stl$/, '');
        if (!config.components.some(part => part.id === id) || !url.pathname.endsWith('.stl')) {
          return send(404, 'Unknown model');
        }
        file = `${outputDirectory}/${id}.stl`;
      } else if (url.pathname.startsWith('/vendor/three/')) {
        const relative = url.pathname.slice('/vendor/three/'.length);
        if (!/^(build|examples\/jsm)\/[a-zA-Z0-9_./-]+\.js$/.test(relative)
            || relative.split('/').some(part => part.startsWith('.'))) {
          return send(404, 'Unknown module');
        }
        const vendorRoot = path.join(root, 'tool/cad-viewer/node_modules/three');
        const resolved = realpathSync(path.join(vendorRoot, relative));
        if (!resolved.startsWith(`${vendorRoot}${path.sep}`)) return send(403, 'Invalid module');
        return send(200, readFileSync(resolved), 'text/javascript');
      } else file = resolveServedFile(url.pathname);
      if (!file) return send(404, 'Not found');
      return send(200, readRepositoryFile(file), mime[path.extname(file)] || 'application/octet-stream');
    } catch (error) {
      const status = error.code === 'ENOENT' ? 404 : 500;
      console.error(`${request.method} ${request.url}: ${error.message}`);
      send(status, status === 404 ? 'File not found' : `Viewer error: ${error.message}`);
    }
  });
}

if (process.argv[1] && fileURLToPath(import.meta.url) === path.resolve(process.argv[1])) {
  try {
    const port = Number(process.env.PORT || 8765);
    if (!Number.isInteger(port) || port < 1 || port > 65535) throw new Error('Invalid PORT');
    const server = createViewerServer();
    server.on('error', error => {
      console.error(`Cannot start local CAD viewer: ${error.message}`);
      process.exitCode = 1;
    });
    server.listen(port, '127.0.0.1', () => {
      console.log(`MowerBot CAD and documentation: http://127.0.0.1:${port}/`);
    });
  } catch (error) {
    console.error(`Cannot start local CAD viewer: ${error.message}`);
    process.exitCode = 1;
  }
}
