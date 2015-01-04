(function() {
  'use strict';

  angular.module('users').factory('AuthFactory', ['$q', '$http', 'TokenFactory',
    function ($q, $http, TokenFactory) {

      var login = function(credentials) {
        console.log(credentials);
        angular.extend(credentials, {grant_type : 'password'});
        
        var req = {
          method: 'POST',
          url: '/oauth2/token',
          headers: {
            // This is used for authenticate this client by 
            // authorization server
            'Authorization' : 'Basic dEVZUUFGaUFBbUxyUzJEbDpZbUUyTFlUR0t1bmxWVzVPcktObFdGOUtRWlVaT0hEeQ=='
          },
          data: credentials
        };

        return $q(function(resolve, reject) {
          $http(req).then(
            function(response) {
              // setup User
              TokenFactory.setToken(response.data);
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

      var register = function(user) {
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

      return {
        login: login,
        register: register
      };

    }
  ]);

})();