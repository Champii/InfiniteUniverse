require! {
  \./Building
  \./Queue
}

class SolarPlant extends Building.Extend \solarplant, Building.Route, schema: \strict, maxDepth: 3

  _Price: (level) ->
    metal:   75 * (1.5 ^ (level - 1))
    crystal: 30 * (1.5 ^ (level - 1))

  _Production: (level) -> 20 * level * (1.1 ^ level)

  ToJSON: ->
    serie = super!
    delete serie.planet
    delete serie.player
    serie

SolarPlant
  ..Field \energy     \int  .Virtual -> Math.floor @_Production @level

module.exports = SolarPlant

require! {
  \./Player
  \./Planet
}

SolarPlant
  ..HasOneThrough Player, Planet