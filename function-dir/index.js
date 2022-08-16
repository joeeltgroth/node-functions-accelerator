module.exports = async function myFunction(context) {
  const ret = 'This is a test function for Node.js FaaS. Success. Test2';
  return new Promise((resolve, reject) => {
    setTimeout(_ => {
      context.log.info('sending response to client')
      resolve(ret);
    }, 500);
  });
};

