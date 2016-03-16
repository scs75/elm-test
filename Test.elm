import Html exposing (li, text, ul, div, span, strong)
import Graphics.Element exposing (show)

type alias Pair = { i : Int, j: Int}

type Egesz n = Nothing | Just n

incrementE : Egesz Int -> Egesz Int
incrementE i =
  case i of
    Nothing   -> Nothing
    Just i    -> Just (i+1)

increment : Int -> Int
increment i =
  i+1

increment' : Pair -> Pair
increment' pair =
  {i=increment pair.i, j=increment pair.j}

main = show( increment'({i=5, j=5}) )
