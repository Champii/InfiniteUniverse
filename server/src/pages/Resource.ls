require! {
  \../AuthRoute
  \../Planet
}

class ResourceRoute extends AuthRoute


  Config: ->
    @resource = Planet

    super!

    @Get \/:id @deepAuth, ~>
      @resource
        .Fetch +it.params.id
        .Then ->
          it{ metalmine, crystalmine, deutmine, solarplant }
            |> Obj.map (.ToPage!)

new ResourceRoute \resource
