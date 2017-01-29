require! {
  \./Building
}

class Lab extends Building.Extend \lab, Building.Route, schema: \strict, maxDepth: 3

  _Price: (level) ->
    metal:   400 * (2 ^ level)
    crystal: 200 * (2 ^ level)
    deut:    100 * (2 ^ level)

  ToJSON: ->
    serie = super!
    delete serie.planet
    delete serie.player
    serie

module.exports = Lab

require! {
  \./Player
  \./Planet
}

Lab
  ..Field \available \bool .Default true
  ..HasOneThrough Player, Planet
