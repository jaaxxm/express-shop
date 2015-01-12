(function() {
  'use strict';

  function ForgotPasswordCtrl ($stateParams, AuthFactory) {

    var vm = this;
    vm.newPassword = newPassword;
    
    var token = $stateParams.token;

    function newPassword(data, valid){
      if (valid) {
        var promise = AuthFactory.newPassword(data, token);
        promise.then(
          function (response) {
            vm.success = true;
          }, function (response) {
            vm.serverError = response.error;
          });
      }
    }

  }

  angular.module('core').controller('ForgotPasswordCtrl', ForgotPasswordCtrl);

})();