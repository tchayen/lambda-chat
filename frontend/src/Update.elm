module Update exposing (..)

{-|
@docs parseMessage, update
-}

import Regex exposing (contains, regex, find, HowMany)
import Maybe exposing (Maybe)
import List exposing (head)
import String exposing (isEmpty, split, concat, uncons)
import Model exposing (Model, Msg, Message, url)
import WebSocket


{-| Helper function for parsing messages.
-}
parseMessage : String -> Maybe Message
parseMessage input =
  let
    message = split ": " input
  in
    case message of
      [author, content] ->
        Just <| Message author content
      _ ->
        Nothing


{-| update function.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Model.Receive input ->
      case parseMessage input of
        Just message ->
          case message.author of
            "SYSTEM" ->
              let
                joined =
                  find (Regex.AtMost 1) (regex ".*(?= joined)") message.content
                  |> List.map .match
                  |> List.head
                disconnected =
                  find (Regex.AtMost 1) (regex ".*(?= disconnected)") message.content
                  |> List.map .match
                  |> List.head
              in
                -- if  then
                --   ({ model | chat = message :: model.chat
                --            , users = model.users
                --            }
                --   , Cmd.none)
                -- else
                ({ model | chat = message :: model.chat }, Cmd.none)
            _ ->
              ({ model | chat = message :: model.chat }, Cmd.none)
        Nothing ->
          (model, Cmd.none)

    Model.ChangeLogin input ->
      ({ model | input = input }, Cmd.none)

    Model.ChangeMessage input ->
      ({ model | message = input }, Cmd.none)

    Model.Send ->
      if not <| isEmpty model.message then
        ({ model | message = "" }, WebSocket.send url model.message)
      else
        (model, Cmd.none)

    Model.Join ->
      if not <| isEmpty model.input then
        (Model "" "" (Just model.input) [] [model.input]
        , WebSocket.send url
          <| concat ["JOIN ", model.input ] )
      else
        (model, Cmd.none)
