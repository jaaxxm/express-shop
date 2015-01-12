(function() {
  'use strict';

  angular.module('core').config(['$stateProvider',
    function ($stateProvider) {

      $stateProvider
        .state('core', {
          abstract: true,
          templateUrl: '/js/core/views/layout.core.html'
        })
        .state('core.home', {
          url: '/',
          views: {
            "content": {
              templateUrl: '/js/core/views/home.html',
              controller: 'HomeCtrl as home'
            }
          }
        })
        .state('core.contact', {
          url: '/contact',
          views: {
            "content": {
              templateUrl: '/js/core/views/contact.html',
              controller: 'ContactCtrl as contact'
            }
          }
        })
        .state('core.signuptoken', {
          url: '/signup/:token',
          views: {
            "content": {
              templateUrl: '/js/core/views/signup.token.html',
              controller: 'SignupTokenCtrl as vm'
            }
          }
        })
        .state('core.resettoken', {
          url: '/forgot-password/:token',
          views: {
            "content": {
              templateUrl: '/js/core/views/forgot.password.html',
              controller: 'ForgotPasswordCtrl as vm'
            }
          }
        });

    }
  ]);

})();
