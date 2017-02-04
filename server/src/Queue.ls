class QueueRoute extends N.Route

  Config: ->
    @Get \/player @Auth!, ~> @resource.List playerId: it.user.id .Then (.0)

class Queue extends N \queue QueueRoute, schema: \strict

  @MonoSlot = (event, idObj, data, delay) ->
    @_IsActive inObj, 1
      .Then (active) ~>
        @SetTimeout ({ event, data, active } <<< inObj), delay

  @QueueSlot = (event, inObj, data, delay) ->
    @_IsActive inObj, 4
      .Then (active) ~>
        @SetTimeout ({ event, data, active } <<< inObj), delay

  @QueueX = (event, inObj, data, delay, maxSize) ->
    @_IsActive inObj, maxSize
      .Then (active) ~>
        @SetTimeout ({ event, data, active } <<< inObj), delay

  @_IsActive: (inObj, maxSize)->
    @List idObj
      .Then ~>
        if it.length > maxSize
          throw 'Queue full'

        !it.length

  @SetTimeout = (obj, delay) ->
    obj.data = JSON.stringify obj.data

    @Create obj
      .Then (queue) ~>
        setTimeout ~>
          queue.Delete!

          N.bus.emit queue.event, JSON.parse queue.data
        , delay * 1000

        queue

Queue
  ..Field \planetId \int    .Optional!
  ..Field \playerId \int    .Optional!
  ..Field \active   \bool   .Default true
  ..Field \event    \string
  ..Field \data     \string

module.exports = Queue
