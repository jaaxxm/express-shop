(function() {
  'use strict';

  angular.module('core').controller('SignupTokenCtrl', ['$stateParams', '$http',
    function ($stateParams, $http) {

      var vm = this;
      
      var token = $stateParams.token;
      $http.get('/rest/signup/' + token)
        .success(function(data, status) {
          vm.success = true;
        })
        .error(function(data, status) {
          vm.error = true;
        });


    }
  ]);

})();