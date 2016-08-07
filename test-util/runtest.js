var page = require("webpage").create();
page.viewportSize = { width: 70 , height: 30};

var system = require('system');
var args = system.args;
var testScript = args[1];

page.onConsoleMessage = function(msg, lineNum, sourceId) {
  console.log(msg);
};
page.onCallback = function (code) {
  phantom.exit(code);
};

page.open('test-util/test.html', function(status) {
    page.evaluate(function() {
       window.phantom = window.phantom || {};
       window.phantom.exit = function (code) {
         callPhantom(code);
       }
       window.process = null;
    });
    page.injectJs(testScript);
});
