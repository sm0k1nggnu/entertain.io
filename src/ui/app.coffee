entertainIoApp = angular.module('entertain.io.app', [
  require 'entertain.io-app/src/ui/feed/feed'
  require 'angular-ui-router'
])

.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise '/'

  $stateProvider
    .state 'feed',
      url: '/'
      templateUrl: 'feed/feed.html'

module.exports = entertainIoApp.name