require! {
  \../AuthRoute
  \../Planet
}

class FacilityRoute extends AuthRoute


  Config: ->
    @resource = Planet

    super!

    @Get \/:id @deepAuth, ~>
      @resource
        .Fetch it.params.id
        .Then ->
          console.log it
          it{ roboticfactory, lab }
            |> Obj.map (.ToPage!)

new FacilityRoute \facility
