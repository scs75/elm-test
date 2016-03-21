--import Task exposing (Task, andThen)
import Html exposing (Html, text, button, div, span)
import Html.Events exposing (onClick)

main : Signal Html
main =
--  Signal.map show contentMailbox.signal
  Signal.map layout contentMailbox.signal

layout : String -> Html
layout sig =
  div [] [ button [onClick contentMailbox.address "Hopp"] [text "Start"]
    , span [] [text sig]
  ]

contentMailbox : Signal.Mailbox String
contentMailbox =
  Signal.mailbox "Kezdeti"

{--
port updateContent : Task x ()
port updateContent =
  Signal.send contentMailbox.address "hello!"
--}
