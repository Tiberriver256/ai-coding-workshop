const { startServer, defaultHost, defaultPort, defaultRootDir } = require('./app-server');

const port = Number(process.env.PORT || defaultPort);
const host = process.env.HOST || defaultHost;

startServer({
  port,
  host,
  rootDir: defaultRootDir,
  onReady: ({ url }) => {
    console.log(`Serving app on ${url}`);
  },
  onError: (error) => {
    console.error(error);
    process.exitCode = 1;
  },
});
