require! {
  \./AuthRoute
  \./Queue
}

class BuildingRoute extends AuthRoute

  Config: ->
    super!
    @Put \/:id/levelup, @deepAuth, (.instance.LevelUp!)

class Building extends N \building, BuildingRoute, abstract: true

  LevelUp: ->
    throw 'Building not available now' if not @available

    time = @_BuildingTime!

    Queue.List planetId: @planet.id
      .Then ~>
        if it.length
          throw 'Already constructing'
      .Then ~> @planet.Fetch!
      .Then !~> it.Buy @price
      .Then ~> Queue.Timeout \level_up, it.id, time, id: @id, type: capitalize @_type
      .Then ~> N[capitalize @_type].Fetch @id #fixme by @Fetch!
      .Set buildingFinish: new Date().getTime() + time

  LevelUpApply: ->
    @
      .Set (.level++)
      .Set (.buildingFinish = 0)

  _BuildingTime: ->
    return 0 if not @planet?roboticfactory
    Math.floor ((@price.metal * @price.crystal) / (25000 * (1 + @planet.roboticfactory.level) * (2 ^ 0naniteLevel) * 1universeSpeed)) * 3600
    0 # dev tmp

  _Price: -> ...

Building
  ..Field \level          \int  .Default 0
  ..Field \available      \bool .Default false
  ..Field \buildingFinish \int  .Default 0
  ..Field \price          \obj  .Virtual ->
    @price = @_Price @level

    metal:   Math.floor @price.metal
    crystal: Math.floor @price.crystal
    deut:    Math.floor @price.deut || 0
    time:    @_BuildingTime! if @planet?

module.exports = Building

N.bus.on \level_up ->
  N[it.type]
    .Fetch it.id
    .LevelUpApply!
    .Catch console.error

