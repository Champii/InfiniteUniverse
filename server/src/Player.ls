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
    delete serie.queues
    serie

Player
  ..Field \username      \string
  ..Field \password      \string

  ..Field \researchQueue \obj    .Virtual ->
    it.queues || []
      |> filter -> it.event is \research_up
      |> map (.ToJSON!)

  ..Field \fleetQueue \obj    .Virtual ->
    it.queues || []
      |> filter -> it.event in <[ fly fly_return ]>
      |> map ->
        res = it.ToJSON! <<< JSON.parse it.data
        delete res.active
        res

module.exports = Player

require! {
  \./Planet
  \./Research
  \./Queue
}

Player
  ..HasMany    Planet,   \planets
  ..HasOne     Research, \researches
  ..MayHasMany Queue,    \queues

Player.Watch \new (player) ->
  Planet
    .Create do
      gal: 0
      sol: 0
      pla: 0
      playerId: player.id
    .Then -> Planet.Create do
      gal: 0
      sol: 0
      pla: 1
      playerId: player.id
    .Then -> Research.Create do
      playerId: player.id
    .Catch console.error
