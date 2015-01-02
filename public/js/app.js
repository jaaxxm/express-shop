(function() {
  'use strict';
    //Start by defining the main module and adding the module dependencies
    angular.module(AppConfiguration.moduleName, AppConfiguration.vendorDependencies)
      .config(['$locationProvider', '$stateProvider', '$urlRouterProvider',
        function ($locationProvider, $stateProvider, $urlRouterProvider) {
          // $locationProvider.hashPrefix('!');
          $locationProvider.html5Mode(true);

          $urlRouterProvider.otherwise('/');

        }
      ])
      .constant('accessLevels', AppConfiguration.accessConfig.accessLevels)
      .constant('userRoles', AppConfiguration.accessConfig.userRoles);

    //Then define the init function for starting up the application
    angular.element(document).ready(function () {
      //Fixing facebook bug with redirect
      // if (window.location.hash === '#_=_') window.location.hash = '#!';

      //Then init the app
      angular.bootstrap(document, [AppConfiguration.moduleName]);
    });  

})();