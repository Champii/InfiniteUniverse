class Player

  (@id, @username) ->

class Planet

  (@id, @player, @buildingLevels) ->
    @buildingLevels
      |> obj-to-pairs
      |> map ~>

  findBuilding: (name) ->

class Entity

  (@id, @level, @planet) ->
    @price = @_price!
    @available = @_availability!

  _buildingTime: ->
    return 0 if not @planet?roboticfactory
    Math.floor ((@price.metal * @price.crystal) / (25000 * (1 + @planet.roboticfactory.level) * (2 ^ 0naniteLevel) * 1universeSpeed)) * 3600

  _price: -> formulas[@displayName].price @level

  _availability: ->
    allBuildings = formulas[@displayName].buildings?
      |> obj-to-pairs
      |> all ~> @planet[it.0].level >= it.0

    allResearches = formulas[@displayName].researches?
      |> obj-to-pairs
      |> all ~> @planet.player.researches[it.0].level >= it.0

    allBuildings && allResearches


class Research extends Entity


class Building extends Entity





  #     |> Obj.filter ~>
  #       if @displayName is \research
  #         it.researches?[@name] <= @level
  #       else
  #         it.buildings?[@displayName] <= @level

  #     |> Obj.filter ~>

  #       allBuildings = it.buildings
  #         |> obj-to-pairs
  #         |> all ~> @planet[it.0].level >= it.1

  #       allResearches = it.researches
  #         |> obj-to-pairs
  #         |> all (pair) ~>
  #           research = find (.name is pair.0), @player.researches
  #           research.level >= pair.1

  #       allBuildings && allResearches

  #     |> obj-to-pairs
  #     |> map (pairs) ~>
  #       if pairs.1.isResearch
  #         research = find (.name is pairs.0), @player.researches
  #         research.Set available: true
  #       else
  #         @planet[pairs.0].Set available: true



class Mine extends Building


player = new Player 1 \toto
planet = new Planet 1 player
metalmine = new Mine 1 0 planet

