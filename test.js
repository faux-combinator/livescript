var nodeunit = require('nodeunit');
var reporter = nodeunit.reporters.default;
console.log('running conpiled tests from ./out/test/');
console.log(' (please run `compile-watch` to compile the tests)');
reporter.run(['out/test']);
