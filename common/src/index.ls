global import require \prelude-ls
require! {
  \./formulas
}

class Player

  (@id, @username) ->


class Planet

  (@id, @player, @amount, buildingLevels, researchLevels) ->
    @buildings = {}
    @researches = {}

    @prodRatio = @_prodRatio!
    buildingLevels
      |> obj-to-pairs
      |> each ~>
        type = if specialBuildings[it.0] => that else Building
        @buildings[it.0] = new type it.0, it.1, @player, @

    researchLevels
      |> obj-to-pairs
      |> each ~> @researches[it.0] = new Research it.0, it.1, @player, @

    @buildings |> Obj.each ~> it._init!
    @researches |> Obj.each ~> it._init!
    @prodRatio = @_prodRatio!


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
    @buildings.metal.update!
    @buildings.crystal.update!
    @buildings.deut.update!

  buy: (price) ->
    if @amount.metal < price.metal || @amount.crystal < price.crystal || @amount.deut < (price.deut || 0)
      return false

    @amouont.metal   -= price.metal
    @amouont.crystal -= price.crystal
    @amouont.deut    -= price.deut if price.deut

    true

class Entity

  (@name, @level, @player, @planet) ->
    @price = @_price!

  _init: ->
    @available = @_availability!
    @buildingTime = @_buildingTime!

  _buildingTime: ->
    Math.floor ((@price.metal * @price.crystal) / (25000 * (1 + @planet.buildings.roboticfactory.level) * (2 ^ 0naniteLevel) * 1universeSpeed)) * 3600

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
    (@price.metal + @price.crystal) / (1000 * (@planet.buildings.lab.level + 1)) * 3600

class Building extends Entity

class Mine extends Building

  ->
    super ...
    @production = (formulas[@name].production @level) * @planet.prodRatio
    @consumption = formulas[@name].consumption @level
    @lastUpdate = new Date

  update: ->
    @production = (formulas[@name].production @level) * @planet.prodRatio
    @consumption = formulas[@name].consumption @level
    lapsedTime = (new Date - @lastUpdate) / 1000

    @planet.amount[@name] += ((@production / 3600) * lapsedTime)
    @lastUpdate = new Date

class SolarPlant extends Building

  ->
    super ...
    @energy = formulas.solarplant.production @level

specialBuildings =
  metal:      Mine
  crystal:    Mine
  deut:       Mine
  solarplant: SolarPlant


player = new Player 1 \toto

buildings =
  metal: 10
  crystal: 10
  deut: 1
  solarplant: 1
  roboticfactory: 0
  lab: 0

researches =
  energy: 0
  combustionDrive: 0

amounts =
  metal: 1000
  crystal: 1000
  deut: 1000

planet = new Planet 1 player, amounts, buildings, researches

console.log planet

setInterval ->
  planet.update!
, 1000
