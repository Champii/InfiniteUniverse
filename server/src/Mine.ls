require! {
  async
  \./Building
}

formulas =
  metal:
    price: (level) ->
      metal:   60 * (1.5 ^ (level - 1))
      crystal: 15 * (1.5 ^ (level - 1))
    production: (level) -> 30 * level * (1.1 ^ level)
    consumption: (level) -> 10 * level * (1.1 ^ level)

  crystal:
    price: (level) ->
      metal:   48 * (1.6 ^ (level - 1))
      crystal: 24 * (1.6 ^ (level - 1))
    production: (level) -> 20 * level * (1.1 ^ level)
    consumption: (level) -> 10 * level * (1.1 ^ level)

  deut:
    price: (level) ->
      metal:   225 * (1.5 ^ (level - 1))
      crystal: 75 * (1.5 ^ (level - 1))
    production: (level) -> 10 * level * (1.1 ^ level) * (-0.002 * 250tempPlanet + 1.28)
    consumption: (level) -> 20 * level * (1.1 ^ level)


class Mine extends Building.Extend \mine, Building.Route, schema: \strict maxDepth: 3

  @Fetch = (...args) ->
    doneIdx = @_FindDone args
    if doneIdx?
      oldDone = args[doneIdx]
      args[doneIdx] = (err, instance) ->
        return oldDone err if err?

        instance
          .Update!
          .Then -> oldDone null, it
          .Catch oldDone

      return super ...args

    else
      instance = super ...
      instance.Then -> it.Update!

  @List = (...args) ->
    doneIdx = @_FindDone args
    if doneIdx?
      oldDone = args[doneIdx]
      args[doneIdx] = (err, instances) ->
        return oldDone err if err?

        async.map instances, (instance, done) ->
          instance
            .Update!
            .Then -> done null, it
            .Catch done
        , oldDone

      return super ...args

    else
      instances = super ...
      instances.Then map (.Update!)

  Update: ->
    lapsedTime = (new Date - @lastUpdate) / 1000

    @Set do
      amount: @amount + ((@production / 3600) * lapsedTime)
      lastUpdate: new Date

  ToJSON: ->
    serie = super!
    serie.amount      = Math.floor serie.amount
    delete serie.planet
    delete serie.player
    serie

  _ProdRatio: ->
    @planet?_ProdRatio! || 0

  _Price:       -> formulas[@name].price @level
  _Production:  -> (formulas[@name].production @level) * @_ProdRatio!
  _Consumption: -> formulas[@name].consumption @level

Mine
  ..Field \name        \string
  ..Field \amount      \int    .Default 0
  ..Field \production  \int    .Virtual -> Math.floor @_Production @level
  ..Field \consumption \int    .Virtual -> Math.floor @_Consumption @level
  ..Field \lastUpdate  \date   .Default new Date

module.exports = Mine

