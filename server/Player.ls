require! {
  \./Planet
  \./MetalMine
  \./CrystalMine
}

Player = N \player N.Route.Collection, schema: \strict , maxDepth: 2
  ..Field \login    \string
  ..Field \password \string
  ..HasMany Planet

Player.Watch \new (player) ->

  planet = Planet
    .Create do
      position: \test
      playerId: player.id
    .Catch console.error

  MetalMine
    .Create planetId: planet
    .Catch console.error

  CrystalMine
    .Create planetId: planet
    .Catch console.error

module.exports = Player