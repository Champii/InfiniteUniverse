require! {
  async
  \./AuthRoute

}

class PlanetRoute extends AuthRoute

  Config: ->
    super!
    @Get @Auth!, ~>
      @resource
        .List { playerId: it.user.id }, {fields: ['id', 'position']}, 0
        .Then map -> it{id, position}

class Planet extends  N \planet PlanetRoute, schema: \strict, maxDepth: 3

  Buy: @_WrapResolvePromise (price) ->
    if @amount.metal < price.metal || @amount.crystal < price.crystal || @amount.deut < (price.deut || 0)
      throw 'Not enought resources'

    mines = @_GetMines!

    mines.metalmine
      .Set amount: mines.metalmine.amount - price.metal
      .Then ~> mines.crystalmine
      .Set amount: mines.crystalmine.amount - price.crystal
      .Then ~>
        if price.deut
          return mines.deutmine.Set amount: mines.deutmine.amount - price.deut
        @

  _AvailableEnergy: ->
    return 0 if not @solarplant?

    @solarplant.energy - (sum map (.consumption), @mines)

  _ProdRatio: ->
    if not @solarplant?
      return 0

    if @solarplant.energy is 0
      return 0

    if @_AvailableEnergy! >= 0
      return 1

    consumption = (sum map (.consumption), @mines)

    @solarplant.energy / consumption

  _GetMines: ->
    return {} if not @mines?

    # async.mapSeries @mines, (mine, done) ~>
    #   mine
    #     .Update!
    #     .Then flip done
    #     .Catch done
    # , (err, res) ~>
    #   console.log err, res

    metalmine:   find (.name is \metal),  @mines
    crystalmine: find (.name is \crystal),  @mines
    deutmine:    find (.name is \deut),  @mines

  ToJSON: ->
    serie = super!
    delete serie.player
    serie

Planet
  ..Field \position \string
  ..Field \amount   \obj    .Virtual ->
    mines = @_GetMines!
    if not mines.metalmine?
      return

    metal:   Math.floor mines.metalmine?.amount || 0
    crystal: Math.floor mines.crystalmine?.amount || 0
    deut:    Math.floor mines.deutmine?.amount || 0
    energy:  Math.floor @_AvailableEnergy! || 0

  ..Field \prodRatio \obj  .Virtual -> +(@_ProdRatio!toFixed 4)

module.exports = Planet

require! {
  \./Mine
  \./SolarPlant
}

Planet
  ..HasMany Mine, \mines
  ..HasOne SolarPlant
