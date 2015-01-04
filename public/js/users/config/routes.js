(function() {
  'use strict';

  angular.module('users').config(['$stateProvider',
    function ($stateProvider) {

      $stateProvider
        .state('user', {
          url: '/profile',
          abstract: true,
          templateUrl: '/js/users/views/layout.users.html'
        })
        .state('user.info', {
          url: '/info',
          views: {
            "content": {
              templateUrl: '/js/users/views/info.html'
            }
          }
        })
        .state('user.security', {
          url: '/security',
          views: {
            "content": {
              templateUrl: '/js/users/views/security.html'
            }
          }
        });

    }
  ]);

})();
