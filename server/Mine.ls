require! {
  \./Building
}

class Mine extends Building.Extend \mine, Building.Route, abstract: true

  @Fetch = ->
    instance = super ...
    instance.Then ~> it.Update!

  Update: ->
    lapsedTime = (new Date - @lastUpdate) / 1000

    @Set do
      amount: @amount + ((@_Formula(@level) / 3600) * lapsedTime)
      lastUpdate: new Date

  ToJSON: ->
    serie = super!
    serie.amount     = Math.floor serie.amount
    serie.production = Math.floor serie.production
    serie

Mine
  ..Field \amount     \int  .Default 0
  ..Field \production \int  .Virtual -> @_Formula @level
  ..Field \lastUpdate \date .Default new Date

module.exports = Mine
