class PlayerRoute extends N.Route
  Config: ->
    @Get \/:id @IsOwn('id'), ~> @resource.Fetch it.params.id
    @Get ~> @resource.List!

Player = N.AccountResource \player PlayerRoute, schema: \strict, maxDepth: 2
  ..Field \username \string
  ..Field \password \string

module.exports = Player

require! {
  \./Planet
  \./MetalMine
  \./CrystalMine
  \./DeutMine
  \./SolarPlant
}

Player
  ..HasMany Planet

Player.Watch \new (player) ->
  planet = Planet
    .Create do
      position: \test
      playerId: player.id
    .Catch console.error

  MetalMine
    .Create planetId: planet, level: 10
    .Catch console.error

  CrystalMine
    .Create planetId: planet, level: 10
    .Catch console.error

  DeutMine
    .Create planetId: planet, level: 10
    .Catch console.error

  SolarPlant
    .Create planetId: planet, level: 20
    .Catch console.error

