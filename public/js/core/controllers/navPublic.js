(function() {
  'use strict';

  angular.module('core').controller('NavPublicCtrl', ['$mdDialog',
    function ($mdDialog) {

      var nav = this;
      nav.showUserDialog = showUserDialog;

      function showUserDialog(ev, tabIndex){
        $mdDialog.show({
          controller: 'AutheticateDialogCtrl',
          controllerAs: 'dialog',
          templateUrl: '/js/core/views/dialog.authenticate.html',
          targetEvent: ev,
          locals: { activeTabIndex: tabIndex },
          bindToController: true
        });
      }

    }
  ]);

})();