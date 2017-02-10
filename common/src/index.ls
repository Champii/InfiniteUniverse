global import require \prelude-ls
require! {
  \./formulas
}

export class Planet

  (planet, player) ->
    @buildings  = {}
    @researches = {}
    @ships      = {}

    @amount        = planet.amount
    @lastUpdate    = new Date planet.lastUpdate
    buildingLevels = planet.buildings.ToJSON!
    researchLevels = player.researches.ToJSON!
    ships          = planet.ships.ToJSON!

    @pos           = planet.pos

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

  fleet: (order, destPlanet) ->
    new Fleet order, destPlanet, @

class Entity

  (@name, @level, @planet) ->
    @price = @_price!

  _init: ->
    @available = @_availability!
    @buildingTime = @_buildingTime!

  _buildingTime: ->
    Math.floor ((@price.metal + @price.crystal) / (2500 * (1 + @planet.buildings.roboticfactory.level) * (2 ^ 0naniteLevel) * 1universeSpeed)) * 3600

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
    ((@price.metal + @price.crystal) / (1000 * (@planet.buildings.lab.level + 1))) * 3600

class Ship extends Entity

  ->
    super ...
    @quantity = @level
    delete @level
    @specs = @_specs!

  _price: ->
    formulas[@name].price

  _buildingTime: ->
    Math.floor ((@price.metal + @price.crystal) / (2500 * (1 + @planet.buildings.shipyard.level) * (2 ^ 0naniteLevel) * 1universeSpeed)) * 3600

  _specs: ->
    formulas[@name].specs

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

class Fleet

  (@order, @destPlanet, @planet) ->
    @ <<< @order{ ships, dest, amount, mission }

  fly: ->

    if @dest{gal, sol, pla} === @planet.pos{gal, sol, pla}
      throw 'Cannot fly to your actual position'

    enoughtShips = @ships
      |> obj-to-pairs
      |> all ~> @planet.ships[it.0].quantity >= it.1

    if not enoughtShips
      throw 'Not enought ships'

    capacity = @ships
      |> obj-to-pairs
      |> map ~> @planet.ships[it.0].specs.capacity * it.1
      |> sum

    if capacity < sum values @amount
      throw 'Not enought storage capacity'

    @ships
      |> obj-to-pairs
      |> each ~> @planet.ships[it.0].quantity -= it.1

    speed = @ships
      |> keys
      |> minimum-by (-> formulas[it].specs.speed)
      |> -> formulas[it].specs.speed

    distance = @_calcDistance!

    @time = @_calcTime speed, distance

    @end = new Date!getTime! + (@time * 1000)

    @prepareMission!

  prepareMission: ->
    switch @mission
      | \transport => @prepareTransport!

  applyMission: (destPlanet) ->
    switch @mission
      | \transport => @doTransport destPlanet

  prepareTransport: ->
    throw 'Not enought resources' if not @planet.buy @amount

  doTransport: (destPlanet) ->
    destPlanet.amount.metal   += @amount.metal
    destPlanet.amount.crystal += @amount.crystal
    destPlanet.amount.deut    += @amount.deut

  flyReturn: ->
    @ships
      |> obj-to-pairs
      |> each ~> @planet.ships[it.0].quantity += it.1


  _calcDistance: ->
    if @dest.gal isnt @planet.pos.gal
      20000 * Math.abs(@dest.gal - @planet.pos.gal)
    else if @dest.sol isnt @planet.pos.sol
      2700 + (95 * Math.abs(@dest.sol - @planet.pos.sol))
    else
      1000 + (5 * Math.abs(@dest.pla - @planet.pos.pla))

  _calcTime: (speed, distance) ->
    10 + (3500 * Math.sqrt((10 * distance) / speed))
    5

specialBuildings =
  metal:      Mine
  crystal:    Mine
  deut:       Mine
  solarplant: SolarPlant
