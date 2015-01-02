(function () {
  'use strict';

  angular.module('common')
    .directive('jmInputMatch', ['$parse', function ($parse) {
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
    }]);

})();
