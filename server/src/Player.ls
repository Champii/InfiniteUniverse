class PlayerRoute extends N.Route

  Config: ->
    @Get \/:id @IsOwn('id'), ~> @resource.Fetch it.params.id
    @Get ~> @resource.List 0

class Player extends N.AccountResource \player PlayerRoute, schema: \strict, maxDepth: 1

  ToJSON: ->
    serie = super!
    each (-> delete it.mines), serie?.planets?
    serie

Player
  ..Field \username \string
  ..Field \password \string

module.exports = Player

require! {
  \./Planet
  \./Mine
  \./SolarPlant
}

Player
  ..HasMany Planet, \planets

Mine
  ..HasOneThrough Player, Planet

Player.Watch \new (player) ->
  planet = Planet
    .Create do
      position: \test
      playerId: player.id
    .Catch console.error

  Mine
    .Create name: \metal amount: 500 planetId: planet, level: 10
    .Then -> Mine.Create name: \crystal amount: 350 planetId: planet, level: 10
    .Then -> Mine.Create name: \deut planetId: planet, level: 10
    .Then -> SolarPlant.Create planetId: planet, level: 20
    .Catch console.error

