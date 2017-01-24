require! {
  \./Queue
}

class BuildingRoute extends N.Route.Collection

  Config: ->
    super!
    @Put \/:id/levelup (.instance.LevelUp!)
    @Get -> null

class Building extends N \building, BuildingRoute, abstract: true

  LevelUp: ->
    time = @_BuildingTime!

    Queue.List planetId: @Planet.id
      .Then ~>
        if it.length
          throw 'Already constructing'
      .Then ~> @Planet.Fetch!
      .Then !~> it.Buy @_Price @level
      .Then ~> Queue.Timeout \level_up, it.id, time, id: @id, type: capitalize @_type
      .Then ~> N[capitalize @_type].Fetch @id #fixme by @Fetch!
      .Set buildingFinish: new Date().getTime() + time

  _BuildingTime: ->
    price = @_Price @level
    Math.floor (price.metal * price.crystal) / (2500 * (1 + 0roboticLevel) * 100universeSpeed * 2 ^ 0naniteLevel) * 3600
    #
    0

Building
  ..Field \level          \int .Default 0
  ..Field \buildingFinish \int .Default 0
  ..Field \consumption    \int .Default 0

module.exports = Building

N.bus.on \level_up ->
  N[it.type]
    .Fetch it.id
    .Set (.level++)
    .Set (.buildingFinish = 0)
    .Catch console.error
