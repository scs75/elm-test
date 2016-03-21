module Frame.Navbar (init, update, view) where

import Frame.Menu as Menu

import Html exposing (Html, nav, a, text, div, span, strong, button, br)
import Html.Attributes exposing (attribute, class, id, type', href)
import Graphics.Element exposing (show)
import StartApp.Simple exposing (start)
import Html.Events exposing (onClick)

--main = start { model = init, update = update, view = view' }

-- MODEL

type NavItem
  = NavHeader Header
  | NavMenu Menu.Model
  | NavButton Button

type alias Header =
  { title : String
  , img : Maybe String
  }

type alias Button =
  { title : String
  }

type alias Model =
  { items : List NavItem
  , sclass : String
  }

initHeader : String -> Maybe String -> NavItem
initHeader title img =
  NavHeader
  { title = title
  , img = img
  }

initButton : String -> NavItem
initButton title =
  NavButton
  { title = title }

init : Model
init =
  { items =
    [ initHeader "Brand" Nothing
    , NavMenu (Menu.init Menu.initItems True False)
    ]
  , sclass = "navbar navbar-default navbar-static-top" -- navbar-inverse navbar-fixed-top
  }

-- UPDATE

type Action
  = Reset
  | Insert
  | Modify Menu.Action

update : Action -> Model -> Model
update action model =
  case action of
    Reset ->
      init
    Insert ->
      { model | items = initButton "Sign in" :: model.items }
    Modify menuAction ->
      let updateItem item =
        case item of
          NavHeader header -> NavHeader header
          NavMenu menu -> NavMenu (Menu.update menuAction menu)
          NavButton butt -> NavButton butt
      in
        { model | items = List.map updateItem model.items }

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  nav [ class model.sclass ]
    [ div [ class "container" ] <| List.map (viewItem address) model.items

    ]

view' : Signal.Address Action -> Model -> Html
view' address model =
  let
    insertb = button [ onClick address Insert ] [ text "Insert" ]
    resetb = button [ onClick address Reset ] [ text "Reset" ]
  in
    div []
    [ insertb
    , resetb
    , view address model
    ]

viewItem : Signal.Address Action -> NavItem -> Html
viewItem address item =
  case item of
    NavHeader header ->
      div [ class "navbar-header" ]
        [ button
          [ type' "button"
          , class "navbar-toggle collapsed"
          , attribute "data-toggle" "collapse"
          , attribute "data-target" "#navbar"
          , attribute "aria-expanded" "false"
          , attribute "aria-controls" "navbar"
          ]
          [ span [ class "sr-only" ] [ text "Toggle navigation" ]
          , span [class "icon-bar"] []
          , span [class "icon-bar"] []
          , span [class "icon-bar"] []
          ]
        , a
          [ class "navbar-brand"
          , href "#"
          ] [ text header.title ]
        ]
    NavMenu menu ->
      Menu.view (Signal.forwardTo address Modify) menu
    NavButton butt ->
      button
      [ type' "button"
      , class "btn btn-default navbar-btn"
      ] [ text butt.title ]

