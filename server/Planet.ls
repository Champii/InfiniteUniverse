require! {
  \./MetalMine
  \./CrystalMine
  \./DeutMine
}

class Planet extends  N \planet N.Route.Collection, schema: \strict

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

Planet
  ..Field \position \string
  ..Field \amount   \obj    .Virtual ->
    if not it.Metalmine?
      return

    metal:   it.Metalmine?.amount || 0
    crystal: it.Crystalmine?.amount || 0
    deut:    it.Deutmine?.amount || 0

  ..HasOne MetalMine
  ..HasOne CrystalMine
  ..HasOne DeutMine

module.exports = Planet