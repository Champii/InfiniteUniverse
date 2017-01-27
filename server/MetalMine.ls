require! {
  \./Mine
}

class MetalMine extends Mine.Extend \metalmine, Mine.Route, schema: \strict, maxDepth: 2

  _Price: (level) ->
    metal:   60 * (1.5 ^ (level - 1))
    crystal: 15 * (1.5 ^ (level - 1))

  _Production: (level) -> 30 * level * (1.1 ^ level) * @_PercentProduction!

  _Consumption: (level) -> 10 * level * (1.1 ^ level)


MetalMine
  ..Field \amount     \int .Default 500

module.exports = MetalMine
