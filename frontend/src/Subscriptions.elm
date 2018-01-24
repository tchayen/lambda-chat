module Subscriptions exposing (..)

import Model exposing (Model, Msg, url)
import WebSocket


subscriptions : Model -> Sub Msg
subscriptions model =
  WebSocket.listen url Model.Receive