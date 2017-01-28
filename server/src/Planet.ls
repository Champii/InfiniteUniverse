require! {
  \./AuthRoute
}

class PlanetRoute extends AuthRoute

  Config: ->
    super!
    @Get @Auth!, ~> @resource.List { playerId: it.user.id }, 0

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
    @solarplant.energy - @metalmine.consumption - @crystalmine.consumption - @deutmine.consumption

  ToJSON: ->
    serie = super!
    delete serie.metalmine?.planet
    delete serie.crystalmine?.planet
    delete serie.deutmine?.planet
    delete serie.solarplant?.planet
    delete serie.player?.planet
    serie

Planet
  ..Field \position \string
  ..Field \amount   \obj    .Virtual ->
    if not @metalmine?
      return

    metal:   Math.floor @metalmine?.amount || 0
    crystal: Math.floor @crystalmine?.amount || 0
    deut:    Math.floor @deutmine?.amount || 0
    energy:  Math.floor @_AvailableEnergy! || 0

module.exports = Planet

require! {
  \./MetalMine
  \./CrystalMine
  \./DeutMine
  \./SolarPlant
}

Planet
  ..HasOne MetalMine
  ..HasOne CrystalMine
  ..HasOne DeutMine
  ..HasOne SolarPlant
