(function() {
  'use strict';

  angular.module('core').controller('NavPublicCtrl', ['$mdDialog',
    function ($mdDialog) {

      var nav = this;
      nav.showUserDialog = showUserDialog;

      function showUserDialog(ev, tab){

        $mdDialog.show({
          controller: 'SigninDialogCtrl',
          controllerAs: 'dialog',
          templateUrl: '/js/core/views/dialog.signin.html',
          targetEvent: ev,
          locals: {
            tab: tab
          },
          bindToController: true
        })
        .then(function(answer) {
          console.log('You said the information was "' + answer + '".');
        }, function() {
          console.log('You cancelled the dialog.');
        });
      }

    }
  ]);

})();