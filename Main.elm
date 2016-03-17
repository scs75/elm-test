import Menu exposing (init, update, view)
import StartApp.Simple exposing (start)
import Html

--import Html exposing (text)
--import Graphics.Element exposing (show)

--main : Graphics.Element.Element
--main =
--  show ["a", "b", "e"]

main : Signal Html.Html
main =
  start
    { model = init
    , update = update
    , view = view
    }
