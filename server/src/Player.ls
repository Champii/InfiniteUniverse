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
  \./RoboticFactory
}

Player
  ..HasMany Planet, \planets

Mine
  ..HasOneThrough Player, Planet

Player.Watch \new (player) ->
  Planet
    .Create do
      position: \test
      playerId: player.id
    .Catch console.error
