(function() {
  'use strict';

  angular.module('core').config(['$stateProvider',
    function ($stateProvider) {

      $stateProvider
        .state('app.public', {
          abstract: true,
          templateUrl: '/js/core/views/layout.public.html'
        })
        .state('app.public.home', {
          url: '/',
          views: {
            "content": {
              templateUrl: '/js/core/views/home.html',
              controller: 'HomeCtrl as home'
            }
          }
        })
        .state('app.public.contact', {
          url: '/contact',
          views: {
            "content": {
              templateUrl: '/js/core/views/contact.html',
              controller: 'ContactCtrl as contact'
            }
          }
        });

    }
  ]);

})();
