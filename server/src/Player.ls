class PlayerRoute extends N.Route

  Config: ->
    super!

    @Get @Auth!, (.user)

class Player extends N.AccountResource \player PlayerRoute, schema: \strict

  ToJSON: ->
    super!{ id, username }

Player
  ..Field \username \string
  ..Field \password \string

module.exports = Player

require! {
  \./Planet
  \./Mine
  \./SolarPlant
  \./RoboticFactory
  \./Research

  \./pages/Resource
  \./pages/Facility
}

Player
  ..HasMany Planet, \planets
  ..HasOne  Research

Mine
  ..HasOneThrough Player, Planet

Player.Watch \new (player) ->
  Planet
    .Create do
      position: \test
      playerId: player.id
    .Then -> Research.Create do
      playerId: player.id
    .Catch console.error
