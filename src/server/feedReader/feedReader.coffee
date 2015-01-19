###
  @author: Jonathan <jonathan.haeberle@gmail.com>
  @feeds: Array<{url :string}> Array mit einzelnen URLs der feeds
  @cb: function(feedItem) new feed-item
###

async         = require 'async'
request       = require 'request'
parseRSSFeed  = require('xml2js').parseString

class FeedReader
  constructor: (@feeds, @feedItemCallback) ->
    @allItems = {}

    async.forever (next) =>
      @fetch feeds, (err) ->
        console.log 'Error while fetching', err if err

      # restart request
      setTimeout(next, 1000)


  fetch: (feeds, callback) =>
    async.each feeds, @request, callback


  request: (feed, callback) =>
    request.get feed.url, (err, req, body) =>
      if err
        return callback err

      @handleFeed feed, body, callback


  handleFeed: (feed, feedBody, callback) =>
    parseRSSFeed feedBody, (err, feed) =>
      if err
        return callback err

      items = feed.rss.channel[0].item

      items.forEach (item) =>
        # find a unique part of the feed to prevent double-saving
        guid = item.guid[0]._

        # if not found in db, save!
        unless @allItems.hasOwnProperty guid
          @allItems[guid] = item
          @feedItemCallback item, feed

      callback()


module.exports = FeedReader

