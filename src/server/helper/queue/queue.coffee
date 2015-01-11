class Queue
  constructor : () ->
    @_loopCounter   = 0
    @_loopTo        = 1
    @_repeat        = false
    @_sleep         = false
    @_jobDone       = false

  # Array of data which will be looped
  loop : (@loopArray) ->
    @

  # What should we do with each arrayItem?
  job : (@job) ->
    @

  # Run when all loops are finished
  done : (@done) ->
    @

  run: ->
    le = @loopArray.length
    c = 0
    item = @loopArray
    asd = =>
      @job item[c], =>
        ++c
        asd() if c < le
    asd()
    # ++@_loopCounter
    # if @_sleep
    #   setTimeout =>
    #     @run()
    #   , @_sleep
    # if @_loopCounter >= @_loopTo and @_jobDone is false
    #   @done()
    # else
    #   @run()

  # should we restart the loop?
  repeat : (@_repeat) ->
    @

  sleep: (@_sleep) ->
    @

  # give a param how often we should run the loop
  times : (@_loopTo) ->
    @

module.exports = new Queue
