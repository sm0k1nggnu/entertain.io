eventric = require "eventric"

feedContext = eventric.context("Feed")


feedContext.defineDomainEvents
  FeedCreated: (params) ->

  FeedCaptionChanged: (params) ->
    @caption = params.caption


feedContext.addAggregate "Feed", ->
  @create = (params, callback) ->
    @$emitDomainEvent "FeedCreated"
    @changeCaption params.caption  if params.caption
    callback()

  @changeCaption = (caption) ->
    @$emitDomainEvent "FeedCaptionChanged",
      caption: caption
  return


feedContext.addCommandHandler "TestCommand", (params, done) ->
  console.log "---------------- TestCommand ----------------"


feedContext.addCommandHandler "CreateFeed", (params, done) ->
  @$aggregate.create("Feed", params).then((feed) ->
    feed.$save()
  ).then (feedId) ->
    done null, feedId


feedContext.addProjection "Feeds", ->
  @stores = ["mongodb"]
  @handleFeedCreated = (domainEvent, done) ->
    feed = id: domainEvent.aggregate.id
    @$store.mongodb.insert feed, ->
      done()

  @handleFeedCaptionChanged = (domainEvent, done) ->
    @$store.mongodb.update
      id: domainEvent.aggregate.id
    ,
      $set:
        caption: domainEvent.payload.caption
    , ->
      done()
  return



feedContext.addQueryHandler "getAllFeeds", (params, callback) ->
  @$projectionStore("mongodb", "Feeds").then (feedsMongoDbCollection) ->
    feedsMongoDbCollection.find (err, feedsCursor) ->
      feedsCursor.toArray (err, feedsArray) ->
        callback null, feedsArray

  return


module.exports = feedContext