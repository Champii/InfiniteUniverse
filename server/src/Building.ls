require! {
  \./AuthRoute
  \./Queue
  \../../common/src : Lib
}

class BuildingRoute extends AuthRoute

  Config: ->
    super!
    @Put \/:id/:name/levelup, @deepAuth, (.instance.LevelUp it.params.name, it.user)

class Building extends N \building, BuildingRoute, maxDepth: 2

  LevelUp: (name, user) ->
    planet = {}
    building = {}

    return Player
      .Fetch user.id
      .Then ~>
        planet := new Lib.Planet @planet, it
        building := planet.buildings[name]

        throw "Unknown building: #{name}" if not building?

        throw 'Building not available now' if not building.available

        if not planet.buy building.price
          throw 'Not enougth resources'

        @planet.Set planet.amount

      .Then ~>
        Queue.MonoSlot do
          \level_up
          { planetId: it.id }
          building.buildingTime
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


Building

buildings = <[ metal crystal deut solarplant roboticfactory lab ]>

buildings |> each -> Building.Field it, \int .Default 0

module.exports = Building

Player = require \./Player

N.bus.on \level_up ->
  Building
    .Fetch it.id
    .LevelUpApply it
    .Catch console.error

