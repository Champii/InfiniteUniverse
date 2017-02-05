module.exports =
  metal:
    price: (level) ->
      metal:   60 * (1.5 ^ level)
      crystal: 15 * (1.5 ^ level)
    production: (level) -> 30 * level * (1.1 ^ level)
    consumption: (level) -> 10 * level * (1.1 ^ level)

  crystal:
    price: (level) ->
      metal:   48 * (1.6 ^ level)
      crystal: 24 * (1.6 ^ level)
    production: (level) -> 20 * level * (1.1 ^ level)
    consumption: (level) -> 10 * level * (1.1 ^ level)

  deut:
    price: (level) ->
      metal:   225 * (1.5 ^ level)
      crystal: 75 * (1.5 ^ level)
    production: (level) -> 10 * level * (1.1 ^ level) * (-0.002 * 250tempPlanet + 1.28)
    consumption: (level) -> 20 * level * (1.1 ^ level)

  solarplant:
    price: (level) ->
      metal:   75 * (1.5 ^ level)
      crystal: 30 * (1.5 ^ level)

    production: (level) -> 20 * level * (1.1 ^ level)

  roboticfactory:
    price: (level) ->
      metal:   400 * (2 ^ level)
      crystal: 120 * (2 ^ level)
      deut:    200 * (2 ^ level)

  lab:
    price: (level) ->
      metal:   200 * (2 ^ level)
      crystal: 400 * (2 ^ level)
      deut:    200 * (2 ^ level)

  shipyard:
    price: (level) ->
      metal:   400 * (2 ^ level)
      crystal: 200 * (2 ^ level)
      deut:    100 * (2 ^ level)
    buildings:
      roboticfactory: 2


# Researches

  energy:
    isResearch: true #fixme
    price: (level) ->
      metal:   0
      crystal: 800 * (2 ^ level)
      deut:    400 * (2 ^ level)
    buildings:
      lab: 1

  combustionDrive:
    isResearch: true #fixme
    price: (level) ->
      metal:   400 * (2 ^ level)
      crystal: 0
      deut:    600 * (2 ^ level)
    buildings:
      lab: 1
    researches:
      energy: 1
