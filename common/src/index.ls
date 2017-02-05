global import require \prelude-ls
require! {
  \./formulas
}

export class Planet

  (planet, player) ->
    @buildings  = {}
    @researches = {}
    @ships      = {}

    @amount = planet.amount
    @lastUpdate = new Date planet.lastUpdate
    buildingLevels = planet.buildings.ToJSON!
    researchLevels = player.researches.ToJSON!
    ships          = planet.ships.ToJSON!

    @prodRatio = @_prodRatio!
    buildingLevels
      |> obj-to-pairs
      |> each ~>
        type = if specialBuildings[it.0] => that else Building
        @buildings[it.0] = new type it.0, it.1, @

    researchLevels
      |> obj-to-pairs
      |> each ~> @researches[it.0] = new Research it.0, it.1, @

    ships
      |> obj-to-pairs
      |> each ~> @ships[it.0] = new Ship it.0, it.1, @

    @buildings  |> Obj.each ~> it._init!
    @researches |> Obj.each ~> it._init!
    @ships      |> Obj.each ~> it._init!

    @update!

  _availableEnergy: ->
    @buildings.solarplant.energy - @buildings.metal.consumption - @buildings.crystal.consumption - @buildings.deut.consumption

  _prodRatio: ->
    if not @buildings?.solarplant?
      return 0

    if @buildings.solarplant.energy is 0
      return 0

    if @_availableEnergy! >= 0
      return 1

    consumption = @buildings.metal.consumption + @buildings.crystal.consumption + @buildings.deut.consumption

    @buildings.solarplant.energy / consumption

  update: ->
    @prodRatio = @_prodRatio!
    @buildings.metal.update @lastUpdate
    @buildings.crystal.update @lastUpdate
    @buildings.deut.update @lastUpdate
    @lastUpdate = new Date

  buy: (price) ->
    if @amount.metal < price.metal || @amount.crystal < price.crystal || @amount.deut < (price.deut || 0)
      return false

    @amount.metal   -= price.metal
    @amount.crystal -= price.crystal
    @amount.deut    -= price.deut if price.deut

    true

class Entity

  (@name, @level, @planet) ->
    @price = @_price!

  _init: ->
    @available = @_availability!
    @buildingTime = @_buildingTime!

  _buildingTime: ->
    Math.floor ((@price.metal * @price.crystal) / (25000 * (1 + @planet.buildings.roboticfactory.level) * (2 ^ 0naniteLevel) * 1universeSpeed)) * 3600 / 100tmpVal

  _price: -> formulas[@name].price @level

  _availability: ->
    allBuildings = formulas[@name].buildings
      |> obj-to-pairs
      |> all ~> @planet.buildings[it.0].level >= it.1

    allResearches = formulas[@name].researches
      |> obj-to-pairs
      |> all ~> @planet.researches[it.0].level >= it.1

    allBuildings && allResearches

class Research extends Entity

  _buildingTime: ->
    ((@price.metal + @price.crystal) / (1000 * (@planet.buildings.lab.level + 1))) * 3600 / 100

class Ship extends Entity

  _price: ->
    formulas[@name].price

  _buildingTime: (name) ->
    Math.floor ((@price.metal * @price.crystal) / (25000 * (1 + @planet.buildings.shipyard.level) * (2 ^ 0naniteLevel) * 1universeSpeed)) * 3600 / 1000tmpVal

class Building extends Entity

class Mine extends Building

  ->
    super ...
    @production = (formulas[@name].production @level) * @planet.prodRatio
    @consumption = formulas[@name].consumption @level


  update: (lastUpdate) ->
    @production = (formulas[@name].production @level) * @planet.prodRatio
    @consumption = formulas[@name].consumption @level
    lapsedTime = (new Date - lastUpdate) / 1000

    @planet.amount[@name] += ((@production / 3600) * lapsedTime)

class SolarPlant extends Building

  ->
    super ...
    @energy = formulas.solarplant.production @level

specialBuildings =
  metal:      Mine
  crystal:    Mine
  deut:       Mine
  solarplant: SolarPlant
