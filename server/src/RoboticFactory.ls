require! {
  \./Building
}

class RoboticFactory extends Building.Extend \roboticfactory, Building.Route, schema: \strict, maxDepth: 3

module.exports = RoboticFactory

require! {
  \./Player
  \./Planet
}

RoboticFactory
  ..Field \available \bool .Default true
  ..HasOneThrough Player, Planet

