(function() {
  'use strict';

  angular.module('core').controller('AutheticateDialogCtrl', ['$state', '$mdDialog', 'AuthFactory',
    function ($state, $mdDialog, AuthFactory) {

      var dialog = this;
      dialog.login = login;
      dialog.reset = reset;
      dialog.signup = signup;
      dialog.resend = resend;

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

      function reset(user, valid){
        if (valid) {
          var promise = AuthFactory.reset(user);
          promise.then(
            function (response) {
              console.log(response);
              $mdDialog.hide();
              $state.go('user.reset');
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

      function resend(data, valid){
        if (valid) {
          var promise = AuthFactory.resend(data);
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