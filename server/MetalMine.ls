require! {
  \./Mine
}

class MetalMine extends Mine.Extend \metalmine, Mine.Route, schema: \strict

  _Price: (level) ->
    metal:   60 * (1.5 ^ (level - 1))
    crystal: 15 * (1.5 ^ (level - 1))

  _Production: (level) -> 30 * level * (1.1 ^ level)

  _Consumption: (level) -> 10 * level * (1.1 ^ level)


MetalMine
  ..Field \amount     \int .Default 100
  ..Field \production \int .Default 30
  ..Field \price      \obj .Virtual -> @_Price @level

module.exports = MetalMine
