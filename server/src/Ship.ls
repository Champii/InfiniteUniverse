require! {
  \./AuthRoute
  \./Queue
  \../../common/src : Lib
}

class ShipRoute extends AuthRoute

  Config: ->
    super!
    @Put \/:id/:name/buy/:amount @deepAuth, (.instance.Buy it.params.name, +it.params.amount)

class Ship extends N \ship, ShipRoute, schema: \strict, maxDepth: 2

  Buy: (name, amount) ->
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

        price = ship.price |> Obj.map (* amount)

        if not planet.buy price
          throw 'Not enougth resources'

        @planet.Set (planet.amount <<< lastUpdate: planet.lastUpdate)

      .Then ~>
        Queue.QueueSlot do
          \ship_buy
          { planetId: it.id }
          ship.buildingTime
          { id: @id, name, amount }

      .Then ~> @

  BuyApply: (params) ->
    console.log 'BuyApply'
    @Set -> it[params.name] = ++it[params.name]

  ToJSON: ->
    serie = super!
    delete serie.id
    delete serie.planetId
    delete serie.planet
    delete serie.player
    serie

<[ smallFighter largeFighter smallTransporter largeTransporter ]>
  |> each -> Ship.Field it, \int .Default 0

module.exports = Ship

require! {
#   \./Planet
  \./Player
}

# Ship
#   ..HasOneThrough Player, Planet
  # ..Field \planet .Internal!
  # ..Field \player .Internal!

N.bus.on \ship_buy ->
  Ship
    .Fetch it.id
    .BuyApply it
    .Catch console.error

