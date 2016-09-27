var page = require("webpage").create();
page.viewportSize = { width: 70 , height: 30};

var system = require('system');
var testScript = system.args[1];

page.onConsoleMessage = function(msg, lineNum, sourceId) {
  console.log(msg);
};
page.onCallback = function (code) {
  phantom.exit(code);
};

page.open('test-util/test.html', function () {
    page.injectJs(testScript);
});
