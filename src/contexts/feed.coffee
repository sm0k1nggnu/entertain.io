eventric = require 'eventric'

feedContext = eventric.context 'Feed'

feedContext.defineDomainEvents
  FeedCreated: () ->
  FeedTitleChanged : (params) ->
    @title = params.title
    return


feedContext.addAggregate 'Feed', ->
  @create = (callback) ->
    @$emitDomainEvent 'FeedCreated'
    callback()
    return
  @changeTitle = (title) ->
    @$emitDomainEvent 'FeedTitleChanged',
      title: title
    return
  return



feedContext.addCommandHandler 'CreateFeed', (params, done) ->
  @$aggregate.create 'Feed'
  .then (feed) ->
    feed.$save()
  .then (feedId) ->
    done(null, feedId)
   return


feedContext.addCommandHandler 'ChangeFeedTitle', (params, done) ->
  @$aggregate.load 'Feed', params.id
  .then (feed) ->
    feed.changeTitle params.title
    feed.$save()
  .then () ->
    done()
  return


feedContext.subscribeToDomainEvent 'FeedTitleChanged', (domainEvent) ->
  console.log domainEvent.payload.title
  return



feedContext.initialize ->
  feedContext.command 'CreateFeed'
  .then (feedId) ->
    console.log 'asd', feedId
  return