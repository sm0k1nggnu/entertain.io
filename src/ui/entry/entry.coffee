entryModule = angular.module("entertain.io.app.entry", [])

.controller 'EntryCtrl', ['$scope', '$http'
  ($scope, $http) ->
    $scope.entries = []
    $http.get('http://api.pnd.gs/v1/sources/dribbble/shots')
      .success (data, status, headers, config) ->
        console.log data
        $scope.entries = data
        setTimeout ->
          $scope.$apply()
]

module.exports = entryModule.name