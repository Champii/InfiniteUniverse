require! {
  \./AuthRoute
  \./Queue
  \./formulas
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
      .Set ->
        level: it.level++
        buildingFinish: 0
      .Then !~>
        it.planet[@_type] = it # avoid refetch planet
        it._CheckAvailability!

  _CheckAvailability: ->
    formulas
      |> Obj.filter ~>
        if @_type is \research
          it.researches?[@name] <= @level
        else
          it.buildings?[@_type] <= @level

      |> Obj.filter ~>

        allBuildings = it.buildings
          |> obj-to-pairs
          |> all ~> @planet[it.0].level >= it.1

        allResearches = it.researches
          |> obj-to-pairs
          |> all (pair) ~>
            research = find (.name is pair.0), @player.researches
            research.level >= pair.1

        allBuildings && allResearches

      |> obj-to-pairs
      |> map (pairs) ~>
        if pairs.1.isResearch
          research = find (.name is pairs.0), @player.researches
          research.Set available: true
        else
          @planet[pairs.0].Set available: true



  _BuildingTime: ->
    return 0 if not @planet?roboticfactory
    Math.floor ((@price.metal * @price.crystal) / (25000 * (1 + @planet.roboticfactory.level) * (2 ^ 0naniteLevel) * 1universeSpeed)) * 3600
    1 # dev tmp

  _Price: -> formulas[@_type].price @level

  ToJSON: ->
    serie = super!
    delete serie.planet
    delete serie.player
    serie

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
    .LevelUpApply it
    .Catch console.error

