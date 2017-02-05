require! {
  async
  \./AuthRoute
  \./Building
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
        console.log \Update planet.amount
        planet.update!
        console.log \Update planet.amount
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

  ..Field \metal         \int    .Default 3750000     .Internal!
  ..Field \crystal       \int    .Default 2750000     .Internal!
  ..Field \deut          \int    .Default 75000     .Internal!

  ..Field \amount        \obj    .Virtual -> it{ metal, crystal, deut }
  ..Field \buildingQueue \obj    .Virtual -> it.queues || [] |> filter -> it.event is \level_up

  ..HasOne  Building, \buildings
  ..MayHasMany Queue, \queues

Planet.Watch \new ->
  Building
    .Create do
      planetId: it.id
    .Catch console.error

Building.HasOneThrough \./Player, Planet

module.exports = Planet

require! {
  \./Player
}
