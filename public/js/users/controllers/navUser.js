(function() {
  'use strict';

  function NavUserCtrl ($state, AuthFactory) {

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

  angular.module('users').controller('NavUserCtrl', NavUserCtrl);

})();