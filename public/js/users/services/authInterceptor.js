(function() {
  'use strict';

  angular.module('users').factory('AuthInterceptor', ['TokenFactory',
    function (TokenFactory) {

      function addToken(config) {
        var token = TokenFactory.getToken();
        if (token) {
          config.headers = config.headers || {};
          config.headers.Authorization = 'Bearer ' + token.access_token;
        }
        return config;
      }

      return {
        request: addToken
      };


    }
  ]);

})();