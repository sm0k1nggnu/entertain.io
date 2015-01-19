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

    socket.on 'FeedSourceContextAddedFeedItem', (feedItem) ->
      console.log "FeedSourceContextAddedFeedItem"
      $scope.feeds.push feedItem
      $scope.$apply()


    socket.emit 'FeedContextGetFeedItems', (feedItems) ->
      console.log "FeedContextGetFeedItems"
      $scope.feeds = feedItems
      $scope.$apply()

]

module.exports = feedModule.name