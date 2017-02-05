class QueueRoute extends N.Route

  Config: ->
    @Get \/player @Auth!, ~> @resource.List playerId: it.user.id .Then (.0)

class Queue extends N \queue QueueRoute, schema: \strict

  @MonoSlot = (...args) ->
    @QueueX ...args, 1

  @QueueSlot = (...args) ->
    @QueueX ...args, 4

  @QueueX = (event, inObj, delay, data, maxSize) ->
    @_IsActive inObj, maxSize
      .Then (active) ~>

        if active.length
          maxDate = (maximum-by (.id), active .end)
          if maxDate
            delay += maxDate / 1000

        @SetTimeout ({ event, data, active: !active.length } <<< inObj), delay

  @_IsActive = (inObj, maxSize) ->
    @List inObj
      .Then ~>
        if it.length >= maxSize
          throw 'Queue full'

        !it.length

  @SetTimeout = (obj, delay) ->
    obj.data = JSON.stringify obj.data

    @Create (obj <<< { end: new Date(new Date().getTime! + (delay * 1000)) })
      .Then (queue) ~>
        if queue.active
          setTimeout ~>
            queue.Delete!

            N.bus.emit queue.event, JSON.parse queue.data
            @SetNextTimeout obj
          , delay * 1000

        queue

  @SetNextTimeout = (obj) ->
    @List obj{ event, active: false }

Queue
  ..Field \planetId \int    .Optional!
  ..Field \playerId \int    .Optional!
  ..Field \active   \bool   .Default true
  ..Field \end      \date
  ..Field \event    \string
  ..Field \data     \string

module.exports = Queue
