module Frame.Menu (Model, init, initItems, ID, Action, update, view) where

--import Frame.MenuItem as MenuItem
import Html exposing (Html, li, text, ul, div, span, strong, button, br, a)
import Html.Attributes exposing (attribute, class, id, type', href)
import Graphics.Element exposing (show)
import StartApp.Simple exposing (start)
import Html.Events exposing (onClick)
import Random

--main = start { model = init [] True False, update = update, view = view' }

-- MODEL

type Node a = Child a | Parent a (List (Node a))

type alias MenuItem =
  { id : ID
  , title : String
  }

initMenuItem : ID -> String -> Node MenuItem
initMenuItem id title =
  Child
  { id = id
  , title = title
  }

type alias Model =
  { selectedID : ID
  , items : List (Node MenuItem)
  , seed : Random.Seed
  , showActive : Bool
  , right : Bool
  }

type alias ID = String

init : List (Node MenuItem) -> Bool -> Bool -> Model
init items showActive right =
  { selectedID = ""
  , items = items
  , seed = Random.initialSeed 1001
  , showActive = showActive
  , right = right
  }

initItems : List (Node MenuItem)
initItems =
  [ Child { id="m1", title="Első" }
  , Child { id="m2", title="Második" }
  , Parent { id="m3", title="Harmadik" }
    [ Child { id="m31", title="Harmadik/1" }
    , Child { id="m32", title="Harmadik/2" }
    , Child { id="m331", title="Harmadik/3/1" }
    , Child { id="m332", title="Harmadik/3/2" }
    ]
  , Child { id="m4", title="Negyedik" }
  ]

-- UPDATE

type Action
  = Insert
  | Init
  | Remove ID
  | Select ID

update : Action -> Model -> Model
update action model =
  case action of
    Insert ->
      let
        ( id, seed ) = randomID model.seed
      in
      { model | items = initMenuItem id "Új" :: model.items
        , seed = seed
      }
    Init ->
      init initItems True False
    Remove id ->
      { model | items = remove id model.items }
    Select id ->
      { model | selectedID = id }

randomID : Random.Seed -> (ID, Random.Seed)
randomID seed =
  let
    (i, seed) = randomInt seed
    id = "m" ++ toString i
  in
  (id, seed)

randomInt : Random.Seed -> (Int, Random.Seed)
randomInt seed =
  Random.generate (Random.int 0 100) seed

remove : ID -> List (Node MenuItem) -> List (Node MenuItem)
remove id items =
  let
    predicate item =
      case item of
        Child mi -> mi.id /= id
        Parent mi children -> mi.id /= id
  in
    List.filter predicate items

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let
    class =
      if model.right then
        "nav navbar-nav navbar-right"
      else
        "nav navbar-nav"
  in
  viewMenu address model.selectedID model.showActive model.items class

view' : Signal.Address Action -> Model -> Html
view' address model =
  let
    insertb = button [ onClick address Insert ] [ text "Insert" ]
    initb = button [ onClick address Init ] [ text "Init" ]
    removeb = button [ onClick address (Remove "m2") ] [ text "Remove" ]
    selected = span [] [text <| toString model.selectedID]
  in
    div []
    [ insertb
    , initb
    , removeb
    , selected
    , text "|"
    , view address model
    ]

viewMenu : Signal.Address Action -> ID -> Bool -> List (Node MenuItem) -> String -> Html
viewMenu address activeID showActive items ulClass =
  ul [ class ulClass ] <| List.map (viewMenuItem address activeID showActive) items

viewMenuItem : Signal.Address Action -> ID -> Bool -> Node MenuItem -> Html
viewMenuItem address activeID showActive item =
  case item of
    Child mi ->
      let
        attrib =
          if showActive && activeID == mi.id then
            [ class "active" ]
          else
            []
      in
        li attrib [ a
          [ onClick address (Select mi.id)
          , href ("#"++mi.id)
          ]
          [ text mi.title ] ]
    Parent mi children -> li [ class "dropdown" ]
      [ a
        [ href ("#"++mi.id)
        , class "dropdown-toggle"
        , attribute "data-toggle" "dropdown"
        , attribute "role" "button"
        , attribute "aria-haspopup" "true"
        , attribute "aria-expanded" "false"
        ]
        [ text mi.title
        , span [class "caret"] []
        ]
      , viewMenu address activeID showActive children "dropdown-menu"
      ]


