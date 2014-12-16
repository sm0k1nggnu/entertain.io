entryModule = angular.module("entertain.io.app.entry", [])

.controller 'EntryCtrl', ['$scope', '$http'
  ($scope, $http) ->
    $scope.entries = []

    socket = io()

    $scope.updateFeed = ->
      socket.emit 'updateFeed'
      false

    socket.on 'feedUpdate', (feeds) ->
      $scope.entries.push feeds
      $scope.$apply()
      return

]

module.exports = entryModule.name