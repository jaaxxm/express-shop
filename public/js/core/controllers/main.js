(function() {
  'use strict';

  function MainCtrl ($state) {

    var main = this;
    main.title = 'Express Shop';

  }

  angular.module('core').controller('MainCtrl', MainCtrl);

})();