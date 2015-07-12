/* global exports */
"use strict";

// module Test.Main

exports.callWindowFunction = function (name) {
  return function(arg) {
    return function () {
      window[name](arg);
      return {};
    };
  };
};
