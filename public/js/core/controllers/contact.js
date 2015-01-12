(function() {
  'use strict';

  function ContactCtrl ($state) {

    var contact = this;
    contact.email = 'jaaxxm@gmail.com';

  }

  angular.module('core').controller('ContactCtrl', ContactCtrl);

})();