(function() {
  'use strict';

  angular.module('core').controller('NavPublicCtrl', ['$mdDialog',
    function ($mdDialog) {

      var nav = this;
      nav.showUserDialog = showUserDialog;

      function showUserDialog(ev, tabIndex){
        $mdDialog.show({
          controller: 'SigninDialogCtrl',
          controllerAs: 'dialog',
          templateUrl: '/js/core/views/dialog.sign.html',
          targetEvent: ev,
          locals: {
            activeTabIndex: tabIndex
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