require! {
  async
  \./AuthRoute
  \./Building
}

class PlanetRoute extends AuthRoute

  Config: ->
    super!

    @Get \/:id @deepAuth, (.instance)

class Planet extends N \planet PlanetRoute, schema: \strict

  ToJSON: ->
    serie = super!
    delete serie.player
    serie

Planet
  ..Field \name     \string .Default \Planet
  ..Field \position \string

  ..Field \metal    \int    .Default 0 .Internal!
  ..Field \crystal  \int    .Default 0 .Internal!
  ..Field \deut     \int    .Default 0 .Internal!

  ..Field \amount   \obj    .Virtual -> it{ metal, crystal, deut }

  ..HasOne Building, \buildings


Planet.Watch \new ->
  Building
    .Create do
      planetId: it.id
    .Catch console.error

module.exports = Planet
