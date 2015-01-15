feedsModule = angular.module("entertain.io.app.feeds", [])

.controller 'FeedsCtrl', ['$scope', '$http', '$sce'
  ($scope, $http, $sce) ->
    $scope.feeds = []

    socket = io()

    socket.emit 'FeedContextGetFeeds', (feeds) ->
      $scope.feeds = feeds
      $scope.$apply()

    $scope.createFeed = ->
      $scope.feeds.push {name:''}
      socket.emit 'FeedContextCreateFeed',


    $scope.removeFeeds = ->
      $scope.feeds = [{}]
      socket.emit 'FeedContextRemoveAllFeeds',


    $scope.updateFeed = (index) ->
      console.log $scope.feeds[index].name
      socket.emit 'FeedContextChangeFeedTitle',
        payload =
          feedId: index
          feedTitle: $scope.feeds[index].name


    socket.on 'FeedContextFeedTitleChanged', (payload) ->
      $scope.feeds[payload.feedId].name = payload.feedTitle
      $scope.$apply()


    socket.on 'FeedContextFeedCreated', () ->
      $scope.feeds.push {name:''}
      $scope.$apply()


    socket.on 'FeedContextFeedsRemoved', () ->
      console.log "foobar"
      $scope.feeds = [{}]
      $scope.$apply()

]

module.exports = feedsModule.name