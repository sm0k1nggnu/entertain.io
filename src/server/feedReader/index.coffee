###
  Jonathan <jonathan.haeberle@gmail.com>

   @feeds: Array<{url :string}> Array mit einzelnen URLs der feeds
   @cb: function(feedItem)  neuer Feed
###

async = require 'async'
request = require 'request'
{parseString} = require 'xml2js'

class FeedReader
  constructor: (@feeds, @feedItemCallback) ->
    @allItems = {}

    async.forever (next) =>
      @fetch feeds, (err) ->
#        console.log 'done fetching feeds'
        console.log 'Error while fetching', err if err

      setTimeout(next, 10000);  # restart request

  fetch: (feeds, callback) =>
    async.each feeds, @request, callback

  request: (feed, callback) =>
    request.get feed.url, (err, req, body) =>
      return callback err if err
      @handleFeed feed, body, callback

  handleFeed: (feed, feedStr, callback) =>
    parseString feedStr, (err, f) =>
      return callback err if err
      items = f.rss.channel[0].item
      items.forEach (item) =>
        guid = item.guid[0]._
        unless @allItems.hasOwnProperty guid
          @allItems[guid] = item
          @feedItemCallback item, feed
      callback()


module.exports = FeedReader

