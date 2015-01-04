(function() {
  'use strict';

  angular.module('users').controller('NavUserCtrl', ['$state', 'AuthFactory',
    function ($state, AuthFactory) {

      var nav = this;
      nav.logout = logout;

      function logout(){
        var promise = AuthFactory.logout();
        promise.then(
          function (response) {
            console.log(response);
            $state.go('core.home');
          },
          function (error) {
            
          }
        );
      }

    }
  ]);

})();