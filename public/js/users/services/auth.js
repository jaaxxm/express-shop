(function() {
  'use strict';

  function AuthFactory ($q, $http, localStorageService) {

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
      
      var req = {
        method: 'POST',
        url: '/rest/login',
        data: credentials
      };

      return $q(function(resolve, reject) {
        $http(req).then(
          function(response) {
            setUp(response);
            resolve($user);
          },
          function(response) {
            tearDown();
            reject(response.data);
          }
        );
      });
    };

    var reset = function(user) {
      
      var req = {
        method: 'POST',
        url: '/rest/forgot-password',
        data: user
      };

      return $q(function(resolve, reject) {
        $http(req).then(
          function(response) {
            resolve();
          },
          function(response) {
            reject(response.data);
          }
        );
      });
    };

    var newPassword = function(data, token) {
      
      var req = {
        method: 'POST',
        url: '/rest/forgot-password/' + token,
        data: data
      };

      return $q(function(resolve, reject) {
        $http(req).then(
          function(response) {
            resolve();
          },
          function(response) {
            reject(response.data);
          }
        );
      });
    };

    var logout = function() {
      var req = {
        method: 'GET',
        url: '/rest/logout'
      };

      return $q(function(resolve, reject) {
        $http(req).then(
          function(response) {
            tearDown();
            resolve(response);
          },
          function(response) {
            reject(response.data);
          }
        );
      });
    };

    var signup = function(user) {
      console.log(user);
      return $q(function(resolve, reject) {
        $http.post('/rest/signup', user).then(
          function(response) {
            resolve();
          },
          function(response) {
            reject(response.data);
          }
        );
      });
    };

    var resend = function(data) {
      console.log(data);
      return $q(function(resolve, reject) {
        $http.post('/rest/signup/resend-verification', data).then(
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
      reset: reset,
      newPassword: newPassword,
      logout: logout,
      signup: signup,
      resend: resend
    };

  }

  angular.module('users').factory('AuthFactory', AuthFactory);

})();