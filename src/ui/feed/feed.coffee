feedModule = angular.module("entertain.io.app.feed", [])

.filter 'unsafe', ($sce) ->
  return (
    (val) ->
      return $sce.trustAsHtml val
  )

.controller 'FeedCtrl', ['$scope', '$http', '$sce'
  ($scope, $http, $sce) ->
    $scope.feeds = []

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
          image = _feed_.description.match(/src="([^\"]*)"/g)[0].replace(/src=|"/g, "")
          if image.split('.').pop() in ['png','jpg','jpeg','gif']
            feed.image = image
        feed.description = _feed_.description.replace(/<(?:.|\n)*?>/gm, '')
        $scope.feeds.push feed
        $scope.$apply()
      return

]

module.exports = feedModule.name