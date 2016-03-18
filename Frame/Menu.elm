--module Frame.Menu (update, view) where

import Frame.MenuItem as MenuItem
import Html exposing (Html, li, text, ul, div, span, strong, button, br)
import Graphics.Element exposing (show)
import StartApp.Simple exposing (start)
import Html.Events exposing (onClick)

-- MODEL

type alias Model =
  { selectedID : ID
  , nextID : ID
  , items : List ( ID, MenuItem.Model )
  }

type alias ID = Int

init : Model
init =
  { selectedID = 0
  , nextID = 0
  , items = []
  }

-- UPDATE

type Action
  = Insert
--  | Remove ID
  | Modify ID MenuItem.Action

update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      { model |
        nextID = model.nextID + 1,
        items = ( model.nextID, MenuItem.init "Új" ) :: model.items
      }
--    Remove ID -> { model | selected = False }
    Modify id itemAction ->
      let updateItem (itemID, itemModel) =
        if itemID == id
          then (itemID, MenuItem.update itemAction itemModel)
          else (itemID, itemModel)
      in
        { model | items = List.map updateItem model.items }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let
    insert = button [ onClick address Insert ] [ text "Add" ]
    selected = span [] [text <| toString model.selectedID]
    next = span [] [text <| toString model.nextID]
  in
    div []
    [ insert,
      selected,
      text "|",
      next,
      ul [] <| List.map (viewCounter address) model.items
    ]
    --(insert :: )

viewCounter : Signal.Address Action -> (ID, MenuItem.Model) -> Html
viewCounter address (id, model) =
  MenuItem.view (Signal.forwardTo address (Modify id)) model

main = start { model = init, update = update, view = view }
