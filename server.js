const { start } = require('faas-js-runtime');
const options = {
  // Pino is used as the logger implementation. Supported log levels are
  // documented at this link:
  // https://github.com/pinojs/pino/blob/master/docs/api.md#options
  logLevel: 'info'
}

// My function directory is in ./function-dir
start(require(`${__dirname}/function-dir/`), server => {
  // The server is now listening on localhost:8080
  // and the function will be invoked for each HTTP
  // request to this endpoint.
  console.log('Server listening');

  // Whenever you want to shutdown the framework
  server.close();
}, options);

