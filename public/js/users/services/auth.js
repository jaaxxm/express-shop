(function() {
  'use strict';

  angular.module('users').factory('AuthFactory', ['$q', '$http', 'localStorageService',
    function ($q, $http, localStorageService) {

      var user_key = 'user';
      var loaded = false;

      function setUp(response) {
        $user = response.data;
        localStorageService.add(user_key, $user);
        setAuthorization($user.token);
        // $rootScope.$broadcast('JM.events.onLogin', $user);
      }

      function tearDown() {
        $user = undefined;
        localStorageService.remove(user_key);
        clearAuthorization();
        // $rootScope.$broadcast('JM.events.onLogout');
      }

      var login = function(credentials) {
        console.log(credentials);
        
        var req = {
          method: 'POST',
          url: '/auth/local',
          data: credentials
        };

        return $q(function(resolve, reject) {
          $http(req).then(
            function(response) {
              console.log(response);
              setUp(response);
              resolve($user);
            },
            function(response) {
              tearDown();
              reject({
                text: response.statusText, 
                reason: response.data.reason
              });
            }
          );
        });
      };

      var logout = function() {
        var req = {
          method: 'DELETE',
          url: '/auth/local'
        };

        return $q(function(resolve, reject) {
          $http(req).then(
            function(response) {
              tearDown();
              resolve(response);
            },
            function(response) {
              reject({
                text: response.statusText, 
                reason: response.data.reason
              });
            }
          );
        });
      };

      var signup = function(user) {
        console.log(user);
        return $q(function(resolve, reject) {
          $http.post('/auth/signup', user).then(
            function(response) {
              // setup User
              resolve(response);
            },
            function(response) {
              // tear down User
              reject({
                text: response.statusText, 
                reason: response.data.reason
              });
            }
          );
        });
      };
  
      var setAuthorization = function(token)
      {
        $http.defaults.headers.common.Authorization = 'Bearer ' + token;
      };

      var clearAuthorization = function()
      {
        $http.defaults.headers.common.Authorization = null;
      };

      var $user = localStorageService.get(user_key);
      if($user) { setAuthorization($user.token); }
      else { $user = null; }

      return {
        login: login,
        logout: logout,
        signup: signup
      };

    }
  ]);

})();