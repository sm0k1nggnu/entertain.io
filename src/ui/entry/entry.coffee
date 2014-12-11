entryModule = angular.module("entertain.io.app.entry", [])

.controller 'EntryCtrl', ['$scope', '$http'
  ($scope, $http) ->
    $scope.entries = []

    socket = io()

    $scope.yeah = ->
      socket.emit 'yeah', "foobar"
      false

    socket.on 'yeah', (socket) ->
      console.log "OMFG"
      return

]

module.exports = entryModule.name