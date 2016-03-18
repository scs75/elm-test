module Frame.MenuItem (Model, init, Action, update, view) where

import Html exposing (Html, li, text, ul, div, span, strong, button, br)
import Graphics.Element exposing (show)
import StartApp.Simple exposing (start)
import Html.Events exposing (onClick)

-- MODEL

type alias Model =
  { selected: Bool
  , title: String
  }

init : String -> Model
init title =
  { selected = False
  , title = title
  }

-- UPDATE

type Action
  = Select
--  | Deselect

update : Action -> Model -> Model
update action model =
  case action of
    Select   -> { model | selected = True }
--    Deselect  -> { model | selected = False }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
    li [ (onClick address Select) ] [ text (model.title++" "++toString(model.selected)) ]

--main = start { model = init "Első", update = update, view = view }
