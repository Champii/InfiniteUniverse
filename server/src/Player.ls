class PlayerRoute extends N.Route

  Config: ->
    @Get @Auth!, ~> @resource.Fetch it.user.id

class Player extends N.AccountResource \player PlayerRoute, schema: \strict

  ToJSON: ->
    serie = super!
    if @planets?
      serie.planets = @planets
        |> map ->
          obj = it.ToJSON!
          delete obj.amount
          obj
    serie

Player
  ..Field \username \string
  ..Field \password \string

module.exports = Player

require! {
  \./Planet
  \./Research
}

Player
  ..HasMany Planet, \planets
  ..HasOne  Research

Player.Watch \new (player) ->
  Planet
    .Create do
      position: \test
      playerId: player.id
    .Then -> Research.Create do
      playerId: player.id
    .Catch console.error
