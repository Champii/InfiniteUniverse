class QueueRoute extends N.Route

  Config: ->
    @Get \/player @Auth!, ~> @resource.List playerId: it.user.id .Then (.0)

class Queue extends N \queue QueueRoute, schema: \strict

  @MonoSlot = (...args) ->
    @QueueX ...args, 1

  @QueueSlot = (...args) ->
    @QueueX ...args, 5

  @QueueX = (event, inObj, delay, data, maxSize, isActive) ->
    if isActive?
      @Push ({ event, data, delay, active: isActive } <<< inObj), delay
    else
      @_IsActive (inObj <<< { event }), maxSize
        .Then (active) ~>
          @Push ({ event, data, delay, active: !active.length } <<< inObj), delay

  @_IsActive = (inObj, maxSize) ->
    @List inObj
      .Then ~>
        if it.length >= maxSize
          throw 'Queue full'

        !it.length

  @Push = (obj) ->
    obj.data = JSON.stringify obj.data

    @Create obj <<< ({ end: new Date(new Date().getTime! + (obj.delay * 1000))})
      .Then @~SetTimeout

  @SetTimeout = (queue) ->
    if queue.active
      setTimeout ~>
        queue.data = JSON.parse queue.data

        N.bus.emit queue.event, queue.data

        if not queue.data.quantity || (queue.data.quantity - 1) <= 0
          queue.Delete!
          @SetNextTimeout queue
        else
          queue.data.quantity -= 1
          queue.end = new Date(new Date().getTime! + (queue.delay * 1000))

          queue.data = JSON.stringify queue.data
          queue
            .Set data: queue.data, end: queue.end
            .Then !~>
              @SetTimeout it

      , queue.delay * 1000
    queue

  @SetNextTimeout = (queue) ->
    toList = queue{ event, planetId, playerId }
    toList.active = false
    @List toList
      .Then (.0) >> (.Set active: true)
      .Then @~SetTimeout

  ToJSON: ->
    serie = super!
    data = JSON.parse serie.data
    res = serie{ active, end } <<< data{ name, amount }
    res

Queue
  ..Field \active   \bool   .Default true
  ..Field \delay    \int
  ..Field \end      \date
  ..Field \event    \string
  ..Field \data     \string

module.exports = Queue
