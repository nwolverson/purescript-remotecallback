/* global exports */
"use strict";

exports.callPhantom = function (code) {
  return function () {
    window.callPhantom(code);
  };
};

exports.callWindowFunction = function (name) {
  return function(arg) {
    return function () {
      window[name](arg);
      return {};
    };
  };
};
