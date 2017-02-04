require! {
  \./Building
  \./Queue
}

class SolarPlant extends Building.Extend \solarplant, Building.Route, schema: \strict, maxDepth: 3

  _Price: (level) ->
    metal:   75 * (1.5 ^ level)
    crystal: 30 * (1.5 ^ level)

  _Production: (level) -> 20 * level * (1.1 ^ level)

  ToJSON: ->
    serie = super!
    delete serie.planet
    delete serie.player
    serie

  ToPage: ->
    super! <<< @{ energy }

SolarPlant
  ..Field \available \bool .Default true
  ..Field \energy \int     .Virtual -> Math.floor @_Production @level

module.exports = SolarPlant

require! {
  \./Player
  \./Planet
}

SolarPlant
  ..HasOneThrough Player, Planet
