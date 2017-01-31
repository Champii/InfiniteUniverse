require! {
  \./Building
  \./Queue
  \./Planet
  \./formulas
}

class ResearchRoute extends Building.Route

  Config: ->
    super!

    isOwnPlanet = @IsOwnDeep (req) ->
      console.log 'IsOwn', req.query.planetId, find (.id is +req.query.planetId), req._instance.player.planets
      if find (.id is +req.query.planetId), req._instance.player.planets
        req.user.id
      else
        0

    # Check if is own planet (bug N middlewares ? Not executed)
    @Put \/:id/levelup @deepAuth, isOwnPlanet, ->
      throw "Missing query parameter 'planetId'" if not it.query.planetId?
      it.instance.LevelUp +it.query.planetId

class Research extends Building.Extend \research, ResearchRoute, schema: \strict, maxDepth: 3

  LevelUp: (planetId) ->
    throw 'Research not available now' if not @available

    time = @_BuildingTime!

    Queue.List playerId: @player.id
      .Then ~>
        if it.length
          throw 'Already researching'
      .Then ~> Planet.Fetch planetId
      .Then !~> it.Buy @price
      .Then ~> Queue.Timeout \level_up, @player.id, time, id: @id, type: capitalize(@_type), planetId: planetId
      .Then ~> N[capitalize @_type].Fetch @id #fixme by @Fetch!
      .Set buildingFinish: new Date().getTime() + time

  LevelUpApply: (data) ->
    @
      .Set ->
        level: it.level++
        buildingFinish: 0
      .Then (instance) !~>
        researchIdx = find-index (.name is instance.name), instance.player.researches
        instance.player.researches[researchIdx] = instance # avoid refetch research
        instance.planet = find (.id is data.planetId), instance.player.planets
        instance._CheckAvailability!
        instance

  _Price: -> formulas[@name].price @level

Research
  ..Field \name \string

module.exports = Research
