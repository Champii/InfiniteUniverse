require! {
  async
  \./AuthRoute
  \./Building
  \./Queue
}

class PlanetRoute extends AuthRoute

  Config: ->
    super!

    @Get \/:id @deepAuth, (.instance)

class Planet extends N \planet PlanetRoute, schema: \strict

  ToJSON: ->
    serie = super!
    delete serie.player
    delete serie.queues
    serie

Planet
  ..Field \name          \string .Default \Planet
  ..Field \position      \string

  ..Field \metal         \int    .Default 5000 .Internal!
  ..Field \crystal       \int    .Default 5000 .Internal!
  ..Field \deut          \int    .Default 5000 .Internal!

  ..Field \amount        \obj    .Virtual -> it{ metal, crystal, deut }
  ..Field \buildingQueue \obj    .Virtual -> it.queues || [] |> filter -> it.event is \level_up
  ..Field \researchQueue \obj    .Virtual -> it.queues || [] |> filter -> it.event is \research_up

  ..HasOne  Building, \buildings
  ..HasMany Queue,    \queues


Planet.Watch \new ->
  Building
    .Create do
      planetId: it.id
    .Catch console.error

Building.HasOneThrough \./Player, Planet

module.exports = Planet
