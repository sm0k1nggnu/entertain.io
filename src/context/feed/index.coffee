eventric = require("eventric")
feedContext = eventric.context("Feed")

feedContext.defineDomainEvents
  FeedCreated: (params) ->

  FeedCaptionChanged: (params) ->
    @caption = params.caption
    return

feedContext.addAggregate "Feed", ->
  @create = (callback) ->
    @$emitDomainEvent "FeedCreated"
    callback()
    return

  @changeCaption = (caption) ->
    @$emitDomainEvent "FeedCaptionChanged",
      caption: caption
    return
  return

feedContext.addCommandHandler "CreateFeed", (params, done) ->
  @$aggregate.create("Feed").then((feed) ->
    feed.caption = params.caption
    feed.$save()
  ).then (feedId) ->
    done null, feedId
    return
  return

feedContext.addProjection "Feeds", ->
  @stores = ["mongodb"]
  @handleFeedCreated = (domainEvent, done) ->
    
    # console.log('Feeds Projection');
    # console.log(domainEvent);
    feed =
      id: domainEvent.aggregate.id
      caption: "No Caption"

    @$store.mongodb.insert feed, ->
      done()
      return
    return
  return

feedContext.addQueryHandler "getAllFeeds", (params, callback) ->
  console.log "geefefe"
  @$projectionStore("mongodb", "Feeds").then (feedsMongoDbCollection) ->
    feedsMongoDbCollection.find {}, (feedsCursor) ->
      feedsCursor.toArray (feedsArray) ->
        console.log "feedsArray"
        console.log feedsArray
        callback null, feedsArray
        return
      return
    return
  return


module.exports = feedContext