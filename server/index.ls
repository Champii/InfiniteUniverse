require! {
  \./Player
}

Player
  .Create do
    login:    \toto
    password: \toto
  .Catch console.error
