entertainIoApp = angular.module('entertain.io.app', [
  require 'entertain.io-app/src/ui/feed/feed'
  require 'entertain.io-app/src/ui/feeds/feeds'
  require 'angular-ui-router'
])

.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise '/'

  $stateProvider
    .state 'feed',
      url: '/'
      templateUrl: 'feed/feed.html'

    .state 'feeds',
      url: '/feeds'
      templateUrl: 'feeds/feeds.html'

module.exports = entertainIoApp.name