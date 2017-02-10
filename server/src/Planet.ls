require! {
  \./AuthRoute
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
module.exports = Planet

require! {
  async
  \./AuthRoute
  \./Building
  \./Ship
  \./Queue
  \../../common/src : Lib
}


Planet
  ..Field \name          \string .Default \Planet
  ..Field \lastUpdate    \date   .Default new Date .Internal!

  ..Field \metal         \int    .Default 5000     .Internal!
  ..Field \crystal       \int    .Default 5000     .Internal!
  ..Field \deut          \int    .Default 5000     .Internal!

  ..Field \gal           \int    .Internal!
  ..Field \sol           \int    .Internal!
  ..Field \pla           \int    .Internal!

  ..Field \amount        \obj    .Virtual -> it{ metal, crystal, deut }
  ..Field \pos           \obj    .Virtual -> it{ gal, sol, pla }

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



require! {
  \./Player
}

# Building.HasOneThrough Player, Planet
