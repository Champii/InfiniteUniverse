require! {
  \./Building
  \./Queue
}

class Shipyard extends Building.Extend \Shipyard, Building.Route, schema: \strict, maxDepth: 3

  _Price: (level) ->
    metal:   400 * (2 ^ level)
    crystal: 200 * (2 ^ level)
    deut:    100 * (2 ^ level)

  ToJSON: ->
    serie = super!
    delete serie.planet
    delete serie.player
    serie

module.exports = Shipyard

require! {
  \./Player
  \./Planet
}

Shipyard
  ..HasOneThrough Player, Planet
