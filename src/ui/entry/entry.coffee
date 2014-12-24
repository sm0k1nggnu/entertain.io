entryModule = angular.module("entertain.io.app.entry", [])

.filter 'unsafe', ($sce) ->
  return (
    (val) ->
      return $sce.trustAsHtml val
  )

.controller 'EntryCtrl', ['$scope', '$http', '$sce'
  ($scope, $http, $sce) ->
    $scope.entries = []

    socket = io()

    $scope.updateFeed = ->
      socket.emit 'updateFeed'
      false

    $http.get('/feeds.json')
    socket.on 'feedUpdate', (feeds) ->
      console.log "feedupdate"
      for _feed_ in feeds
        feed =
          title: _feed_.title
          link: _feed_.link

        descriptionHtml = _feed_.summary.replace(/'/g, '"')
        try
          feed.image = _feed_.description.match(/src="([^\"]*)"/g)[0].replace(/src=|"/g, "")
        feed.description = _feed_.description.replace(/<(?:.|\n)*?>/gm, '')
        $scope.entries.push feed
        $scope.$apply()
      return

]

module.exports = entryModule.name