const http = require('http');
const fs = require('fs');
const path = require('path');
const url = require('url');

const defaultPort = 4173;
const defaultHost = '127.0.0.1';
const defaultRootDir = path.resolve(__dirname, '..', 'app');

const mimeTypes = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json; charset=utf-8',
  '.svg': 'image/svg+xml',
};

function getMimeType(filePath) {
  return mimeTypes[path.extname(filePath).toLowerCase()] || 'application/octet-stream';
}

function buildFilePath(rootDir, pathname) {
  const normalizedRoot = path.resolve(rootDir);
  const normalizedPath = pathname.startsWith('/') ? pathname : `/${pathname}`;
  const resolvedPath = path.resolve(normalizedRoot, `.${normalizedPath}`);
  if (resolvedPath === normalizedRoot) {
    return resolvedPath;
  }
  if (!resolvedPath.startsWith(`${normalizedRoot}${path.sep}`)) {
    return null;
  }
  return resolvedPath;
}

function createServer(rootDir = defaultRootDir) {
  const normalizedRoot = path.resolve(rootDir);

  return http.createServer((req, res) => {
    const parsedUrl = url.parse(req.url);
    let pathname = decodeURIComponent(parsedUrl.pathname || '/');
    if (pathname === '/') {
      pathname = '/index.html';
    }

    const filePath = buildFilePath(normalizedRoot, pathname);
    if (!filePath) {
      res.writeHead(403);
      res.end('Forbidden');
      return;
    }

    fs.stat(filePath, (error, stat) => {
      if (error || !stat.isFile()) {
        res.writeHead(404);
        res.end('Not found');
        return;
      }

      res.writeHead(200, { 'Content-Type': getMimeType(filePath) });
      fs.createReadStream(filePath).pipe(res);
    });
  });
}

function startServer({
  port = defaultPort,
  host = defaultHost,
  rootDir = defaultRootDir,
  onReady,
  onError,
} = {}) {
  const server = createServer(rootDir);

  server.on('error', (error) => {
    if (onError) {
      onError(error);
    }
  });

  server.listen(port, host, () => {
    const address = server.address();
    const actualPort = address && typeof address === 'object' ? address.port : port;
    const readyUrl = `http://${host}:${actualPort}`;

    if (onReady) {
      onReady({ url: readyUrl, host, port: actualPort });
    }
  });

  return server;
}

module.exports = {
  createServer,
  startServer,
  defaultPort,
  defaultHost,
  defaultRootDir,
};
