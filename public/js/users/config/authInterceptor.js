(function() {
  'use strict';

  angular.module('users').config(['$httpProvider',
    function ($httpProvider) {
      $httpProvider.interceptors.push('AuthInterceptor');
    }
  ]);

})();
