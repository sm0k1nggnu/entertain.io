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

        $descriptionHtml = $ _feed_.summary.replace(/'/g, '"')
        descriptionHtml = _feed_.summary.replace(/'/g, '"')

        feed.image = $descriptionHtml.find('img').first().attr('src')
        texts = descriptionHtml.match /<p>(.*?)<\/p>/g

        txt = texts.join ' '

        feed.description = txt.replace(/<(?:.|\n)*?>/gm, '')
        # console.log $(_feed_.description.replace(/'/g, '"'))
        # console.log jQuery.parseHTML(_feed_.description.replace(/'/g, '"'))

        $scope.entries.push feed
        $scope.$apply()
      return

]

module.exports = entryModule.name