(function() {
  'use strict';

  angular.module('users').factory('TokenFactory', ['$window',
    function ($window) {

      var store = $window.localStorage;
      var key = 'tokenInfo';

      function getToken() {
        var tokenInfo = JSON.parse(store.getItem(key));
        return tokenInfo;
      }

      function setToken(token) {
        if (token) {
          store.setItem(key, JSON.stringify(token));
        } else {
          store.removeItem(key);
        }
      }

      return {
        getToken: getToken,
        setToken: setToken
      };

    }
  ]);

})();