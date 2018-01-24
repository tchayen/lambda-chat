module Main exposing (..)

{-| Main function of the app.
@docs main
-}
import Model exposing (init, Model, Msg)
import View exposing (view)
import Update exposing (update)
import Subscriptions exposing (subscriptions)
import Html exposing (..)

{-| main function of the app.
-}
main : Program Never Model Msg
main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }
