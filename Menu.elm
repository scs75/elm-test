module Menu (Model, init, Action, update, view) where

import Html exposing (Html, li, text, ul, div, span, strong, button, br, a, nav)
import Html.Attributes exposing (attribute, class, id, type', href)
--import Graphics.Element exposing (show)
import StartApp.Simple exposing (start)
import Html.Events exposing (onClick)

-- MODEL

type Node a = Child a | Parent a (List (Node a))
type alias MenuItem = { id: String, title: String }
type alias Model = { active: String, tree: List (Node MenuItem) }

initTree : List (Node MenuItem)
initTree =
  [
    Child { id="m1", title="Első" },
    Child { id="m2", title="Második" },
    Parent { id="m3", title="Harmadik" } [
      Child { id="m31", title="Harmadik/1" },
      Child { id="m32", title="Harmadik/2" },
      Child { id="m331", title="Harmadik/3/1" },
      Child { id="m332", title="Harmadik/3/2" }
    ],
    Child { id="m4", title="Negyedik" }
  ]

init : Model
init =
  { active = "m1", tree = initTree }

-- UPDATE

type Action a = Select a

update : Action String -> Model -> Model
update action model =
  case action of
    Select a -> { model | active = a }


-- VIEW

view : Signal.Address (Action String) -> Model -> Html
view address model =
  nav [class "navbar navbar-default navbar-static-top"] [
    div [class "container"] [
      div [class "navbar-header"] [
        button [
          type' "button",
          class "navbar-toggle collapsed",
          attribute "data-toggle" "collapse",
          attribute "data-target" "#navbar",
          attribute "aria-expanded" "false",
          attribute "aria-controls" "navbar"
        ] [
          span [class "sr-only"] [text "Toggle navigation"],
          span [class "icon-bar"] [],
          span [class "icon-bar"] [],
          span [class "icon-bar"] []
        ],
        a [class "navbar-brand", href "#"] [text "Project name"]
      ],
      div [ id "navbar", class "navbar-collapse collapse"] [
        toMarkup address model.active model.tree 0
      ]
    ]
--    button [ onClick address (Select "m3") ] [ text "Select" ],
--    span [] [ text (model.active) ]
  ]

toMarkup : Signal.Address (Action String) -> String -> List (Node MenuItem) -> Int -> Html
--toMarkup : Model -> Int -> Html
toMarkup address active tree i =
  ul [ulClass i] <| List.map (wrap address active i) tree

ulClass : Int -> Html.Attribute
ulClass counter =
  if counter == 0 then
    class "nav navbar-nav"
  else
    class "dropdown-menu"

wrap : Signal.Address (Action String) -> String -> Int -> Node MenuItem -> Html
wrap address active i tree =
  case tree of
    Child mi           -> li
                            (activeClass active mi.id)
                            <| a [(onClick address (Select mi.id)), href ("#"++mi.id)] [text mi.title] :: []
    Parent mi children -> li [class "dropdown"]
                            <| a [
                              href ("#"++mi.id),
                              class "dropdown-toggle",
                              attribute "data-toggle" "dropdown",
                              attribute "role" "button",
                              attribute "aria-haspopup" "true",
                              attribute "aria-expanded" "false"
                              ] [text mi.title, span [class "caret"] []]
                            :: [ toMarkup address active children (i+1) ]

activeClass : String -> String -> List Html.Attribute
activeClass active id =
  if active == id then
    [class "active"]
  else
    []


main : Signal Html
main = start { model = init, update = update, view = view }



