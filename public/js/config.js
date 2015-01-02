var AppConfiguration = (function () {
  'use strict';

  var moduleName = 'app';
  var vendorDependencies = ['ngAnimate', 'ngMessages', 'ngMaterial', 'ui.router'];

  var registerModule = function (name, dependencies) {
    angular.module(name, dependencies || []);
    angular.module(moduleName).requires.push(name);
  };

  return {
    moduleName: moduleName,
    vendorDependencies: vendorDependencies,
    accessConfig: null,
    registerModule: registerModule
  };
})();