feedsModule = angular.module("entertain.io.app.feedManager", [])

.controller 'FeedManagerCtrl', ['$scope', '$http', '$sce'
  ($scope, $http, $sce) ->
    $scope.feedSources = []

    socket = io()

    socket.emit 'FeedContextGetFeedSources', (feedDB) ->
      $scope.feedSources = feedDB
      $scope.$apply()



    $scope.createFeed = ->
      console.log "create"
      $scope.feedSources.push {name:'',url:'',items:[]}
      socket.emit 'FeedContextCreateFeedSource'


    $scope.removeFeeds = ->
      $scope.feedSources = []
      socket.emit 'FeedContextRemoveAllFeedSources'


    $scope.updateFeed = (index) ->
      socket.emit 'FeedContextChangeFeedSource',
        payload =
          feedId: index
          feedTitle: $scope.feedSources[index].name
          feedURL: $scope.feedSources[index].url



    socket.on 'FeedContextFeedSourceTitleChanged', (payload) ->
      $scope.feedSources[payload.feedId].name = payload.feedTitle
      $scope.feedSources[payload.feedId].url = payload.feedURL
      $scope.$apply()


    socket.on 'FeedContextFeedSourceCreated', () ->
      $scope.feedSources.push {name:'', url: '', items:[]}
      $scope.$apply()


    socket.on 'FeedContextFeedSourceRemoved', () ->
      console.log "foobar"
      $scope.feedSources = [{name:'',url:'',items:[]}]
      $scope.$apply()


    socket.on 'FeedSourceContextUpdateDB', (db) ->
      console.log "jiha"
      $scope.feedSources = db
      $scope.$apply()

]

module.exports = feedsModule.name