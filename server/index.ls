require! {
  \./Player
}

Player
  .Create do
    username: \toto
    password: \toto
  .Catch console.error
