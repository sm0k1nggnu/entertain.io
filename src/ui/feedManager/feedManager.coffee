feedsModule = angular.module("entertain.io.app.feedManager", [])

.controller 'FeedManagerCtrl', ['$scope', '$http', '$sce'
  ($scope, $http, $sce) ->
    $scope.feeds = []

    socket = io()

    socket.emit 'FeedContextGetFeeds', (feedDB) ->
      $scope.feeds = feedDB
      $scope.$apply()



    $scope.createFeed = ->
      console.log "create"
      $scope.feeds.push {name:'',url:'',items:[]}
      socket.emit 'FeedContextCreateFeed'


    $scope.removeFeeds = ->
      $scope.feeds = []
      socket.emit 'FeedContextRemoveAllFeeds'


    $scope.updateFeed = (index) ->
      socket.emit 'FeedContextChangeFeed',
        payload =
          feedId: index
          feedTitle: $scope.feeds[index].name
          feedURL: $scope.feeds[index].url



    socket.on 'FeedContextFeedTitleChanged', (payload) ->
      $scope.feeds[payload.feedId].name = payload.feedTitle
      $scope.feeds[payload.feedId].url = payload.feedURL
      $scope.$apply()


    socket.on 'FeedContextFeedCreated', () ->
      $scope.feeds.push {name:'', url: '', items:[]}
      $scope.$apply()


    socket.on 'FeedContextFeedsRemoved', () ->
      console.log "foobar"
      $scope.feeds = [{name:'',url:'',items:[]}]
      $scope.$apply()


    socket.on 'FeedContextUpdateDB', (db) ->
      console.log "jiha"
      $scope.feeds = db
      $scope.$apply()

]

module.exports = feedsModule.name