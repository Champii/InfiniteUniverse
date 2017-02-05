require! {
  \./AuthRoute
  \./Queue
  \../../common/src/formulas
}

class BuildingRoute extends AuthRoute

  Config: ->
    super!
    @All \/:name* @deepAuth, ~> @resource.Fetch { name }
    @Put \/:name/levelup, @deepAuth, (.instance.LevelUp!)

class Building extends N \building, BuildingRoute

  # LevelUp: ->
  #   throw 'Building not available now' if not @available

  #   time = @_BuildingTime!

  #   Queue.List planetId: @planet.id
  #     .Then ~>
  #       if it.length
  #         throw 'Already constructing'
  #     .Then ~> @planet.Fetch!
  #     .Then !~> it.Buy @price
  #     .Then ~> Queue.Timeout \level_up, it.id, time, id: @id, type: capitalize @_type
  #     .Then ~> N[capitalize @_type].Fetch @id #fixme by @Fetch!
  #     .Set buildingFinish: new Date().getTime() + time

  # LevelUpApply: ->
  #   @
  #     .Set ->
  #       level: it.level++
  #       buildingFinish: 0
  #     .Then !~>
  #       it.planet[@_type] = it # avoid refetch planet
  #       it._CheckAvailability!



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

N.bus.on \level_up ->
  N[it.type]
    .Fetch it.id
    .LevelUpApply it
    .Catch console.error

