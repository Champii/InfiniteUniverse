# require! {
#   \./Mine
# }

# class CrystalMine extends Mine.Extend \crystalmine, Mine.Route, schema: \strict, maxDepth: 3

#   _Price: (level) ->
#     metal:   48 * (1.6 ^ (level - 1))
#     crystal: 24 * (1.6 ^ (level - 1))

#   _Production: (level) -> 20 * level * (1.1 ^ level) * @_ProdRatio!

#   _Consumption: (level) -> 10 * level * (1.1 ^ level)

# CrystalMine
#   ..Field \amount     \int .Default 350

# module.exports = CrystalMine

# require! {
#   \./Player
#   \./Planet
# }

# CrystalMine
#   ..HasOneThrough Player, Planet