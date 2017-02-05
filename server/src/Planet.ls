require! {
  async
  \./AuthRoute
  \./Building
}

class PlanetRoute extends AuthRoute

  Config: ->
    super!

    @Get \/:id @deepAuth, (.instance)
    # @Get \/:id  ~> @resource.Fetch +it.params.id

class Planet extends N \planet PlanetRoute, schema: \strict

  ToJSON: ->
    serie = super!
    delete serie.player
    serie

Planet
  ..Field \name     \string .Default \Planet
  ..Field \position \string
  ..HasOne Building, \buildings


Planet.Watch \new ->
  Building
    .Create do
      planetId: it.id
    .Catch console.error

module.exports = Planet
