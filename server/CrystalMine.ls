require! {
  \./Mine
}

class CrystalMine extends Mine.Extend \crystalmine, Mine.Route, schema: \strict

  _Price: (level) ->
    metal:   48 * (1.6 ^ (level - 1))
    crystal: 24 * (1.6 ^ (level - 1))

  _Production: (level) -> 20 * level * (1.1 ^ level)

  _Consumption: (level) -> 10 * level * (1.1 ^ level)


CrystalMine
  ..Field \amount     \int .Default 70
  ..Field \price      \obj .Virtual -> @_Price @level

module.exports = CrystalMine
