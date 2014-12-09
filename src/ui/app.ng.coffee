entertainIoApp = angular.module('entertain.io.app', [
  require 'entertain.io-app/src/ui/entry/entry'
  require 'angular-ui-router'
])

.config ($stateProvider, $urlRouterProvider) ->

  $urlRouterProvider.otherwise '/'

  $stateProvider
    .state 'entry',
      url: '/'
      templateUrl: 'entry/entry.html'

module.exports = entertainIoApp.name