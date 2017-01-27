require! {
  \./MetalMine
  \./CrystalMine
  \./DeutMine
  \./SolarPlant
}

class Planet extends  N \planet N.Route.Collection, schema: \strict, maxDepth: 3

  Buy: @_WrapResolvePromise (price) ->
    if @amount.metal < price.metal || @amount.crystal < price.crystal || @amount.deut < (price.deut || 0)
      throw 'Not enought resources'

    @Metalmine
      .Set amount: @Metalmine.amount - price.metal
      .Then ~> @Crystalmine
      .Set amount: @Crystalmine.amount - price.crystal
      .Then ~>
        if price.deut
          return @Deutmine.Set amount: @Deutmine.amount - price.deut
        @

  _AvailableEnergy: ->
    @Solarplant.energy - @Metalmine.consumption - @Crystalmine.consumption - @Deutmine.consumption

  ToJSON: ->
    serie = super!
    delete serie.Metalmine?.Planet
    delete serie.Crystalmine?.Planet
    delete serie.Deutmine?.Planet
    delete serie.Solarplant?.Planet
    delete serie.Player?.Planets
    serie

Planet
  ..Field \position \string
  ..Field \amount   \obj    .Virtual ->
    if not @Metalmine?
      return

    metal:   Math.floor @Metalmine?.amount || 0
    crystal: Math.floor @Crystalmine?.amount || 0
    deut:    Math.floor @Deutmine?.amount || 0
    energy:  Math.floor @_AvailableEnergy! || 0

  ..HasOne MetalMine
  ..HasOne CrystalMine
  ..HasOne DeutMine
  ..HasOne SolarPlant

module.exports = Planet
