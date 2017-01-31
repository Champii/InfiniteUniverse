require! {
  \./Building
}

class Lab extends Building.Extend \lab, Building.Route, schema: \strict, maxDepth: 3

module.exports = Lab

require! {
  \./Player
  \./Planet
}

Lab
  ..Field \available \bool .Default true
  ..HasOneThrough Player, Planet
