/* global exports */
"use strict";

exports.addScript = function (url) {
  return function () {
    var script = document.createElement("script");
    script.setAttribute("type", "text/javascript");
    script.setAttribute("src", url);
    document.head.appendChild(script);
    return script;
  };
};

exports.removeScript = function (node) {
  return function () {
    document.head.removeChild(node);
    return {};
  };
};

exports.generateName = function (prefix) {
  return function () {
    return prefix + "_" + Date.now();
  };
};

exports.addExternalCallHandler = function (name) {
  return function (cb) {
    return function () {
      window[name] = function (x) {
        cb(x)();
        delete window[name];
      }
      return {};
    };
  };
};
