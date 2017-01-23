class Queue extends N \queue schema: \strict

  @Timeout = (ev, planetId, delay, data) ->
    @List {planetId}
      .Then ~>
        if it.length > 1
          throw 'Already constructing'

        @Create event: ev, planetId: planetId, data: JSON.stringify data
          .Then (queue) ~>
            setTimeout ~>
              queue.Delete!

              N.bus.emit queue.event, JSON.parse queue.data
            , delay * 1000

            queue

Queue
  ..Field \planetId \int
  ..Field \event    \string
  ..Field \data     \string

module.exports = Queue
