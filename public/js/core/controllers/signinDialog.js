(function() {
  'use strict';

  angular.module('core').controller('SigninDialogCtrl', ['$state', '$mdDialog', 'AuthFactory',
    function ($state, $mdDialog, AuthFactory) {

      var dialog = this;
      dialog.login = login;
      dialog.signup = signup;

      function login(credentials, valid){
        if (valid) {
          var promise = AuthFactory.login(credentials);
          promise.then(
            function (response) {
              console.log(response);
              $mdDialog.hide();
              $state.go('user.info');
            },
            function (error) {
              dialog.serverError = error;
            }
          );
        }
      }

      function signup(data, valid){
        if (valid) {
          var promise = AuthFactory.signup(data);
          promise.then(
            function (response) {
              console.log(response);
            },
            function (error) {
              dialog.serverError = error;
            }
          );
        }
      }

    }
  ]);

})();