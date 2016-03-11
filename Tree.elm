import Html exposing (li, text, ul, div, span, strong)
import Graphics.Element exposing (show)


type Node a = Child a | Parent a (List (Node a))

init : List (Node String)
init = [
  Child "első",
  Child "második",
  Parent "harmadik" [
    Child "negyedik",
    Child "negyedik2",
    Parent "negyedik3" [
      Child "izé",
      Child "Hozé"
    ]
  ],
  Child "ötödik"
  ]

ulist : List (Node String) -> Html.Html
ulist list =
  ul [] <| List.map wrap list

wrap : Node String -> Html.Html
wrap tree =
  case tree of
    Child a           -> li [] [text a]
    Parent a children -> li [] <| text a :: [ ulist children ]

main = ulist( init )
