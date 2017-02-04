require! {
  async
  \./AuthRoute

}

class PlanetRoute extends AuthRoute

  Config: ->
    super!

    @Get \/:id @deepAuth, (.instance.ToLightJSON!)

    @Get @Auth!, ~>
      @resource
        .List { playerId: it.user.id }, 0
        .Then map (.ToLightJSON!)

class Planet extends  N \planet PlanetRoute, schema: \strict, maxDepth: 3

  Buy: @_WrapResolvePromise (price) ->
    if @amount.metal < price.metal || @amount.crystal < price.crystal || @amount.deut < (price.deut || 0)
      throw 'Not enought resources'

    @metalmine
      .Set amount: @metalmine.amount - price.metal
      .Then ~> @crystalmine
      .Set amount: @crystalmine.amount - price.crystal
      .Then ~>
        if price.deut
          return @deutmine.Set amount: @deutmine.amount - price.deut
        @

  _AvailableEnergy: ->
    return 0 if not @solarplant?

    @solarplant.energy - (sum map (.consumption), @mines)

  _ProdRatio: ->
    if not @solarplant?
      return 0

    if @solarplant.energy is 0
      return 0

    if @_AvailableEnergy! >= 0
      return 1

    consumption = (sum map (.consumption), @mines)

    @solarplant.energy / consumption

  ToLightJSON: ->
    @ToJSON!{ id, name, position, type, amount }


Planet
  ..Field \name     \string .Default \Planet
  ..Field \position \string
  ..Field \metalmine        .Virtual -> it.mines.0
  ..Field \crystalmine      .Virtual -> it.mines.1
  ..Field \deutmine         .Virtual -> it.mines.2
  ..Field \prodRatio \obj   .Internal! .Virtual -> +(@_ProdRatio!toFixed 4)
  ..Field \amount   \obj    .Virtual ->
    if not @metalmine?
      return

    metal:   Math.floor @metalmine?.amount || 0
    crystal: Math.floor @crystalmine?.amount || 0
    deut:    Math.floor @deutmine?.amount || 0
    energy:  Math.floor @_AvailableEnergy! || 0


module.exports = Planet

require! {
  \./Mine
  \./SolarPlant
  \./RoboticFactory
  \./Shipyard
  \./Lab
}

Planet
  ..HasMany Mine, \mines
  ..HasOne SolarPlant
  ..HasOne RoboticFactory
  ..HasOne Shipyard
  ..HasOne Lab

Planet.Watch \new (planet) ->
  Mine
    .Create do
      name: \metal
      amount: 5000
      planetId: planet.id
      level: 0
    .Then -> Mine.Create do
      name: \crystal
      amount: 3500
      planetId: planet.id
      level: 0
    .Then -> Mine.Create do
      amount: 3500
      name: \deut
      planetId: planet.id
      level: 0
    .Then -> SolarPlant.Create do
      planetId: planet.id
      level: 0
    .Then -> RoboticFactory.Create do
      planetId: planet.id
      level: 0
    .Then -> Shipyard.Create do
      planetId: planet.id
      level: 0
    .Then -> Lab.Create do
      planetId: planet.id
      level: 0
    .Catch console.error
