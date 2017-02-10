require! {
  \./AuthRoute
  \./Queue
  \../../common/src : Lib
}

class ShipRoute extends AuthRoute

  Config: ->
    super!
    @Put \/:id/fly                 @deepAuth, (.instance.Fly it.body)
    @Put \/:id/:name/buy/:quantity @deepAuth, (.instance.Buy it.params.name, +it.params.quantity)

class Ship extends N \ship, ShipRoute, schema: \strict, maxDepth: 2

  Fly: (order, back = false) ->
    user   = {}
    planet = {}
    destPlanet = {}

    Player
      .Fetch @planet.playerId
      .Then ~> user := it
      .Then ~>
        throw 'No ships'                          if not order.ships? or order.ships is {}
        throw 'No mission'                        if not order.mission?
        throw "Invalid mission: #{order.mission}" if order.mission not in <[ transport ]>
        throw 'No destination'                    if not order.dest? or
                                                     not order.dest.gal? or
                                                     not order.dest.sol? or
                                                     not order.dest.pla?

        throw 'No amount given for transport'     if order.mission is \transport and
                                                     not order.amount? or
                                                     not order.amount.metal? or
                                                     not order.amount.crystal? or
                                                     not order.amount.deut?

      .Then ~> Planet.Fetch order.dest
      .Then (_destPlanet) ~>
        destPlanet := _destPlanet
        destPlanet.player.Fetch!
      .Then (destPlayer) ~>

        planet := new Lib.Planet @planet, user
        destLibPlanet = new Lib.Planet destPlanet, destPlayer

        fleet = planet.fleet order, destLibPlanet

        fleet.fly!

        Queue.QueueX do
          \fly
          { playerId: user.id }
          fleet.time
          order <<< id: @id, back: back, time: fleet.time, playerId: user.id, targetPlanetId: destPlanet.id
          1                   # fixme: get computer technology level to set maxSize of queue
          true

      .Then ~>
        @planet.ships.Set Obj.map (.quantity), planet.ships
        @planet.Set planet.amount

  FlyApply: (order) ->
    destPlanet = {}
    destPlayer = {}

    Planet
      .Fetch order.targetPlanetId
      .Then (_destPlanet) ~>
        destPlanet := _destPlanet
        Player.Fetch destPlanet.playerId
      .Then (_destPlayer) ~>
        destPlayer := _destPlayer
        @
      .Then ~>
        # console.log 'Destplanet' it.player
        planet = new Lib.Planet it.planet, it.player
        fleet = planet.fleet order

        destLibPlanet = new Lib.Planet destPlanet, destPlayer

        fleet.applyMission destLibPlanet

        destPlanet.Set destLibPlanet.amount
      .Then ->
        Queue.QueueX do
          \fly_return
          { playerId: order.playerId }
          order.time
          order <<< back: true
          10000
          true

  FlyReturnApply: (order) ->
    @
      .Then ~>
        planet = new Lib.Planet it.planet, it.player
        fleet = planet.fleet order
        fleet.flyReturn!

        it.planet.ships.Set Obj.map (.quantity), planet.ships


  Buy: (name, quantity) ->
    planet = {}
    ship = {}
    user = {}

    Player
      .Fetch @planet.playerId
      .Then ~> user := it
      .Then ~>
        planet := new Lib.Planet @planet, user
        ship := planet.ships[name]

        throw "Unknown ship: #{name}" if not ship?

        throw 'Ship not available now' if not ship.available

        price = ship.price |> Obj.map (* quantity)

        if not planet.buy price
          throw 'Not enougth resources'

        @planet.Set (planet.quantity <<< lastUpdate: planet.lastUpdate)

      .Then ~>
        Queue.QueueSlot do
          \ship_buy
          { planetId: it.id }
          ship.buildingTime
          { id: @id, name, quantity }

      .Then ~> @

  BuyApply: (params) ->
    @Set -> it[params.name] = ++it[params.name]

  ToJSON: ->
    serie = super!
    delete serie.id
    delete serie.planetId
    delete serie.planet
    delete serie.player
    serie

<[ smallFighter largeFighter smallTransporter largeTransporter ]>
  |> each -> Ship.Field it, \int .Default 1

module.exports = Ship

require! {
  \./Player
  \./Planet
}

Ship
  ..HasOneThrough Player, Planet
  # ..Field \planet .Internal!
  # ..Field \player .Internal!

N.bus.on \ship_buy ->
  Ship
    .Fetch it.id
    .BuyApply it
    .Catch console.error

N.bus.on \fly ->
  Ship
    .Fetch it.id
    .FlyApply it
    .Catch console.error

N.bus.on \fly_return ->
  Ship
    .Fetch it.id
    .FlyReturnApply it
    .Catch console.error

