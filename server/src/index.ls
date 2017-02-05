require! {
  \./Player
}

Player
  .Create do
    username: \toto
    password: \toto
  .Catch -> console.error \Player it

Player
  .Create do
    username: \toto2
    password: \toto2
  .Then ->
  .Catch -> console.error \Player it
