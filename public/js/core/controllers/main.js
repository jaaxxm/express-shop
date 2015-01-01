(function() {
  'use strict';

  angular.module('core').controller('MainCtrl', ['$state',
    function ($state) {

      var main = this;
      main.title = 'Express Shop';

    }
  ]);

})();