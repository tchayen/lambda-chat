module Subscriptions exposing (..)

{-|
@docs subscriptions
-}

import Model exposing (Model, Msg, url)
import WebSocket


{-| Create websocket session with backend.
-}
subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen url Model.Receive