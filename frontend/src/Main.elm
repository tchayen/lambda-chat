module Main exposing (..)

import Model exposing (init, Model, Msg)
import View exposing (view)
import Update exposing (update)
import Subscriptions exposing (subscriptions)
import Html exposing (..)


main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
