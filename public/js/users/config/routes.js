(function() {
  'use strict';

  angular.module('users').config(['$stateProvider',
    function ($stateProvider) {

      $stateProvider
        .state('users', {
          url: '/profile',
          abstract: true,
          templateUrl: '/js/users/views/layout.users.html'
        })
        .state('users.info', {
          url: '/info',
          views: {
            "content": {
              templateUrl: '/js/users/views/info.html'
            }
          }
        })
        .state('users.security', {
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
