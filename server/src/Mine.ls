require! {
  \./Building
}

class Mine extends Building.Extend \mine, Building.Route, abstract: true, maxDepth: 3

  @Fetch = (arg, done, _depth) ->
    if done?
      oldDone = done
      done = (err, instance) ~>
        return oldDone err if err?

        if not instance.planet?solarplant?
          return oldDone null, instance

        instance
          .Update!
          .Then -> oldDone null, it
          .Catch oldDone

      return super ...

    else
      instance = super ...

      if not instance.planet?solarplant?
        return instance

      instance.Then -> it.Update!

  Update: ->
    lapsedTime = (new Date - @lastUpdate) / 1000

    @Set do
      amount: @amount + ((@production / 3600) * lapsedTime)
      lastUpdate: new Date

  ToJSON: ->
    serie = super!
    serie.amount      = Math.floor serie.amount
    delete serie.planet?.metalmine
    delete serie.planet?.crystalmine
    delete serie.planet?.deutmine
    delete serie.planet?.solarplant
    delete serie.planet?.player
    delete serie.player
    serie

  _ProdRatio: ->
    @planet?_ProdRatio! || 0

  _Consumption: -> ...


Mine
  ..Field \amount      \int  .Default 0
  ..Field \production  \int  .Virtual -> Math.floor @_Production @level
  ..Field \consumption \int  .Virtual -> Math.floor @_Consumption @level
  ..Field \lastUpdate  \date .Default new Date

module.exports = Mine
