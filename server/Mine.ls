require! {
  \./Building
}

class Mine extends Building.Extend \mine, Building.Route, abstract: true, maxDepth: 2

  @Fetch = (arg, done, _depth) ->
    if done?
      oldDone = done
      done = (err, instance) ~>
        return oldDone err if err?

        if not instance.Planet?Solarplant?
          return oldDone null, instance

        instance
          .Update!
          .Then -> oldDone null, it
          .Catch oldDone

      return super ...

    else
      instance = super ...

      if not instance.Planet?Solarplant?
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
    delete serie.Planet?.Metalmine
    delete serie.Planet?.Crystalmine
    delete serie.Planet?.Deutmine
    delete serie.Planet?.Solarplant
    delete serie.Planet?.Player
    serie

  _PercentProduction: ->
    if not @Planet?Solarplant?
      return 0

    if @Planet.Solarplant.energy is 0
      return 0

    if @Planet.amount.energy >= 0
      return 1

    consumption = @Planet.Metalmine.consumption + @Planet.Crystalmine.consumption + @Planet.Deutmine.consumption

    @Planet.Solarplant.energy / consumption

  _Consumption: -> ...


Mine
  ..Field \amount      \int  .Default 0
  ..Field \production  \int  .Virtual -> Math.floor @_Production @level
  ..Field \consumption \int  .Virtual -> Math.floor @_Consumption @level
  ..Field \lastUpdate  \date .Default new Date

module.exports = Mine
