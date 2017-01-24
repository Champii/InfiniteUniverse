require! {
  \./Building
}

class Mine extends Building.Extend \mine, Building.Route, abstract: true

  @Fetch = (arg, done, _depth) ->
    if done?
      oldDone = done
      done = (err, instance) ~>
        return oldDone err if err?

        instance
          .Update!
          .Then -> oldDone null, it
          .Catch oldDone

      return super ...

    else
      instance = super ...
      instance.Then -> it.Update!

  Update: ->
    lapsedTime = (new Date - @lastUpdate) / 1000

    @Set do
      amount: @amount + ((@_Production(@level) / 3600) * lapsedTime)
      lastUpdate: new Date

  ToJSON: ->
    serie = super!
    serie.amount      = Math.floor serie.amount
    serie.production  = Math.floor serie.production
    serie.consumption = Math.floor serie.consumption
    delete serie.Planet?.Metalmine
    delete serie.Planet?.Crystalmine
    delete serie.Planet?.Deutmine
    delete serie.Planet?.Solarplant
    delete serie.Planet?.Player
    serie

  _PercentProduction: ->
    if not @Planet?.Solarplant? || @Planet.Solarplant?.energy is 0
      return 0

    if @Planet?.amount?.energy >= 0
      return 1 * 100serverspeed


    1 - Math.floor (Math.abs(@Planet.amount.energy) / @Planet.Solarplant.energy)

Mine
  ..Field \amount      \int  .Default 0
  ..Field \production  \int  .Virtual -> @_Production @level
  ..Field \consumption \int  .Virtual -> @_Consumption @level
  ..Field \lastUpdate  \date .Default new Date

module.exports = Mine
