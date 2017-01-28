class AuthRoute extends N.Route

  Config: ->
    @All \/:id* ~> it.SetInstance @resource.Fetch it.params.id

    @deepAuth = @IsOwnDeep (._instance.player.id)

    @Get \/:id @deepAuth, (.instance)

module.exports = AuthRoute
