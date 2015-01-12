(function() {
  'use strict';

  function HomeCtrl ($state) {

    var home = this;
    home.title = 'homectrl bind';

  }

  angular.module('core').controller('HomeCtrl', HomeCtrl);

})();