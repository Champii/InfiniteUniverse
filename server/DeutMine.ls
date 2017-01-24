require! {
  \./Mine
}

class DeutMine extends Mine.Extend \deutmine, Mine.Route, schema: \strict, maxDepth: 2

  _Price: (level) ->
    metal:   225 * (1.5 ^ (level - 1))
    crystal: 75 * (1.5 ^ (level - 1))

  _Production: (level) -> 10 * level * (1.1 ^ level) * (-0.002 * 250tempPlanet + 1.28) * @_PercentProduction!

  _Consumption: (level) -> 20 * level * (1.1 ^ level)

DeutMine
  ..Field \amount     \int .Default 0
  ..Field \production \int .Default 0
  ..Field \price      \obj .Virtual -> @_Price @level

module.exports = DeutMine
