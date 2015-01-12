(function() {
  'use strict';

  function AutheticateDialogCtrl ($state, $mdDialog, AuthFactory) {

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
          }, handleError);
      }
    }

    function reset(user, valid){
      if (valid) {
        var promise = AuthFactory.reset(user);
        promise.then(
          function (response) {
            dialog.signinStep = 'reset-sent';
          }, handleError);
      }
    }

    function signup(data, valid){
      if (valid) {
        var promise = AuthFactory.signup(data);
        promise.then(
          function (response) {
            console.log(response);
          }, handleError);
      }
    }

    function resend(data, valid){
      if (valid) {
        var promise = AuthFactory.resend(data);
        promise.then(
          function (response) {
            console.log(response);
          }, handleError);
      }
    }

    function handleError (response) {
      dialog.serverError = response.error;
    }

  }

  angular.module('core').controller('AutheticateDialogCtrl', AutheticateDialogCtrl);

})();