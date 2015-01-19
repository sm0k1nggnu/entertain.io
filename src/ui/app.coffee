entertainIoApp = angular.module('entertain.io.app', [
  require 'entertain.io-app/src/ui/feed/feed'
  require 'entertain.io-app/src/ui/feedManager/feedManager'
  require 'angular-ui-router'
])

.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise '/'

  $stateProvider
    .state 'feed',
      url: '/'
      templateUrl: 'feed/feed.html'

    .state 'feedManager',
      url: '/feedManager'
      templateUrl: 'feedManager/feedManager.html'

module.exports = entertainIoApp.name