--import Menu exposing (init, update, view)
import Frame.MenuItem exposing (update, view)
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
    { model = 0
    , update = update
    , view = view
    }
