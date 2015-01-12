(function () {
  'use strict';

  function jmInputMatch ($parse) {
    return {
      restrict: 'A',
      require: 'ngModel',
      link: function (scope, element, attr, ctrl) {
        
        scope.$watch((function() {
          return $parse(attr.jmInputMatch)(scope) === ctrl.$modelValue;
        }), function(currentValue) {
          ctrl.$setValidity('unique', currentValue);
        });
      }

    };
  }

  angular.module('common').directive('jmInputMatch', jmInputMatch);

})();
