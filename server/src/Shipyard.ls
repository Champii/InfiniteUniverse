require! {
  \./Building
}

class Shipyard extends Building.Extend \Shipyard, Building.Route, schema: \strict, maxDepth: 3

module.exports = Shipyard

require! {
  \./Player
  \./Planet
}

Shipyard
  ..HasOneThrough Player, Planet
  # ..Field \planet .Internal!
  # ..Field \player .Internal!
