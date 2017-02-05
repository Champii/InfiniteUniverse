require! {
  async
  \./AuthRoute
  \./Building
  \./Ship
  \./Queue
  \../../common/src : Lib
}

class PlanetRoute extends AuthRoute

  Config: ->
    super!

    @Get \/:id @deepAuth, (.instance.Update!)

class Planet extends N \planet PlanetRoute, schema: \strict

  Update: ->
    return Player
      .Fetch @playerId
      .Then ~>
        planet = new Lib.Planet @, it
        planet.update!
        @Set ({} <<< planet.amount) <<< lastUpdate: new Date

  ToJSON: ->
    serie = super!
    delete serie.player
    delete serie.queues

    serie.amount = Obj.map Math.floor, serie.amount

    serie

Planet
  ..Field \name          \string .Default \Planet
  ..Field \position      \string
  ..Field \lastUpdate    \date   .Default new Date .Internal!

  ..Field \metal         \int    .Default 50000     .Internal!
  ..Field \crystal       \int    .Default 50000     .Internal!
  ..Field \deut          \int    .Default 50000     .Internal!

  ..Field \amount        \obj    .Virtual -> it{ metal, crystal, deut }
  ..Field \buildingQueue \obj    .Virtual ->
    it.queues || []
      |> filter -> it.event is \level_up
      |> map (.ToJSON!)

  ..Field \shipQueue     \obj    .Virtual ->
    it.queues || []
      |> filter -> it.event is \ship_buy
      |> map (.ToJSON!)

  ..HasOne     Building, \buildings
  ..HasOne     Ship,     \ships
  ..MayHasMany Queue,    \queues

Planet.Watch \new ->
  Building
    .Create do
      planetId: it.id
    .Then -> Ship.Create do
      planetId: it.id
    .Catch console.error

Building.HasOneThrough \./Player, Planet

module.exports = Planet

require! {
  \./Player
}
