require! {
  \./AuthRoute
  \./Building
  \./Queue
  \../../common/src : Lib
}

class ResearchRoute extends AuthRoute

  Config: ->
    super!
    @Put \/:id/:name/levelup @deepAuth, (.instance.LevelUp it.params.name)


class Research extends N \research, ResearchRoute, schema: \strict

  LevelUp: (name) ->
    planet = {}
    research = {}
    user = {}

    Player
      .Fetch @player.id
      .Then ~> user := it
      .Then ~> Planet.Fetch @id
      .Then ->
        planet := new Lib.Planet it, user
        research := planet.researches[name]

        throw "Unknown research: #{name}" if not research?

        throw 'Research not available now' if not research.available

        if not planet.buy research.price
          throw 'Not enougth resources'

        it.Set planet.amount

      .Then ~>
        Queue.MonoSlot do
          \research_up
          { playerId: @player.id }
          research.buildingTime
          { id: @id, name: name }

      .Then ~> @

  LevelUpApply: (params) ->
    @Set -> it[params.name] = ++it[params.name]

  ToJSON: ->
    serie = super!
    delete serie.id
    delete serie.planetId
    delete serie.planet
    delete serie.player
    serie

  ToJSON: ->
    serie = super!
    delete serie.id
    delete serie.playerId
    serie

<[ energy combustionDrive impulseDrive armor ]>
  |> each -> Research.Field it, \int .Default 3

module.exports = Research

require! {
  \./Player
  \./Planet

}

N.bus.on \research_up ->
  Research
    .Fetch it.id
    .LevelUpApply it
    .Catch console.error

