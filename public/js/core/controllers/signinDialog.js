(function() {
  'use strict';

  angular.module('core').controller('SigninDialogCtrl', ['$mdDialog',
    function ($mdDialog) {

      var dialog = this;
      dialog.login = login;
      dialog.register = register;

      function login(credentials){
        console.log(credentials);
      }
      function register(data){
        console.log(data);
      }

    }
  ]);

})();