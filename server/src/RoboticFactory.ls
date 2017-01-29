require! {
  \./Building
  \./Queue
}

class RoboticFactory extends Building.Extend \roboticfactory, Building.Route, schema: \strict, maxDepth: 3

  Dependancies: ->
    2: -> it.planet.shipyard.Set available: true

  LevelUpApply: ->
    super!Then !~> @Dependancies![it.level]? it

  _Price: (level) ->
    metal:   400 * (2 ^ level)
    crystal: 120 * (2 ^ level)
    deut:    200 * (2 ^ level)

  ToJSON: ->
    serie = super!
    delete serie.planet
    delete serie.player
    serie

module.exports = RoboticFactory

require! {
  \./Player
  \./Planet
}

RoboticFactory
  ..Field \available \bool .Default true
  ..HasOneThrough Player, Planet

