(function() {
  'use strict';

  angular.module('core').controller('HomeCtrl', ['$state',
    function ($state) {

      var home = this;
      home.title = 'homectrl bind';

    }
  ]);

})();