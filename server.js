const { start } = require('faas-js-runtime');

// My function directory is in ./function-dir
const funcPath = `${__dirname}/function-dir/`;
const options = {
  logLevel: 'info',
  port: 8080,
  config: funcPath
};

start(require(funcPath), options)
