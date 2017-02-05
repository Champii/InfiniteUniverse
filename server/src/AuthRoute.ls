class AuthRoute extends N.Route

  Config: ->
    @All \/:id* ~> it.SetInstance @resource.Fetch +it.params.id

    @deepAuth = @IsOwnDeep ->
      it._instance.playerId || it._instance.player?.id || it._instance.planet?.playerId

module.exports = AuthRoute
