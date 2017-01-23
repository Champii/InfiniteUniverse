require! {
  \./MetalMine
  \./CrystalMine
}

class Planet extends  N \planet N.Route.Collection, schema: \strict maxDepth: 2

  Buy: @_WrapResolvePromise (price) ->
    if @amount.metal < price.metal || @amount.crystal < price.crystal
      throw 'Not enought resources'

    @Metalmine
      .Set amount: @Metalmine.amount - price.metal
      .Then ~> @Crystalmine
      .Set amount: @Crystalmine.amount - price.crystal

Planet
  ..Field \position \string
  ..Field \amount   \obj    .Virtual ->
    metal:   it.Metalmine?.amount || 0
    crystal: it.Crystalmine?.amount || 0

  ..HasOne MetalMine
  ..HasOne CrystalMine

module.exports = Planet