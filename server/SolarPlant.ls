require! {
  \./Building
  \./Queue
}

class SolarPlant extends Building.Extend \solarplant, Building.Route, schema: \strict

  _Price: (level) ->
    metal:   75 * (1.5 ^ (level - 1))
    crystal: 30 * (1.5 ^ (level - 1))

  _Production: (level) -> 20 * level * (1.1 ^ level)

SolarPlant
  ..Field \energy     \int  .Virtual -> @_Production @level

module.exports = SolarPlant
