import Html exposing (Html, li, text, ul, div, span, strong, button, br)
import Graphics.Element exposing (show)
import StartApp.Simple exposing (start)
import Html.Events exposing (onClick)

-- MODEL

type alias Model = Int


-- UPDATE

type Action = Reset | Increment

update : Action -> Model -> Model
update action model =
  case action of
    Reset -> 0
    Increment -> model+1


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div [] [
    button [ onClick address Increment ] [ text "Increment" ],
    br [] [],
    button [ onClick address Reset ] [ text "Reset" ],
    br [] [],
    span [] [ text (toString model) ]
  ]

main = start { model = 0, update = update, view = view }
