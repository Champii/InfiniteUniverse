require! {
  async
  \./Building
  \./formulas
}

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
    serie.amount = Math.floor serie.amount
    serie

  ToPage: ->
    super! <<< @{ name, amount }

  _ProdRatio: ->
    @planet?_ProdRatio! || 0

  _Price:       -> formulas[@name].price @level
  _Production:  -> (formulas[@name].production @level) * @_ProdRatio!
  _Consumption: -> formulas[@name].consumption @level

Mine
  ..Field \name        \string
  ..Field \available   \bool   .Default true
  ..Field \amount      \int    .Default 0
  ..Field \lastUpdate  \date   .Default new Date

  ..Field \production  \int    .Virtual -> Math.floor @_Production @level
  ..Field \consumption \int    .Virtual -> Math.floor @_Consumption @level

module.exports = Mine

