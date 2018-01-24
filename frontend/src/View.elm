module View exposing (..)

{-|
@docs renderMessage, view
-}
import List exposing (map)
import Html exposing (Html, div, ul, li, text, em, input, button, h2)
import Html.Attributes exposing (class, value, placeholder, classList)
import Html.Events exposing (onClick, onInput)
import Html.Events.Extra exposing (onEnter)
import Model exposing (Model, Msg, Message)


{-| renderMessage helper.
-}
renderMessage : Message -> Html Msg
renderMessage message =
  case message.author of
    "SYSTEM" ->
      li [ class "line" ]
        [ em [] [ text message.content ]
        ]
    _ ->
      li [ class "line" ]
        [ div [ class "login" ] [ text message.author ]
        , div [ class "text" ] [ text message.content ]
        ]


{-| Generate view.
-}
view : Model -> Html Msg
view model =
  case model.login of
    Nothing ->
      div [ class "join" ]
        [ input
          [ placeholder "Enter your login to join 😉"
          , onInput Model.ChangeLogin
          , onEnter Model.Join
          , value model.input ] []
        , button
          [ classList [ ("visible", not <| String.isEmpty model.input ) ]
          , onClick Model.Join
          ] [ text "Join" ]
        ]
    Just login ->
      div [ class "content" ]
      [ div [ class "chat" ]
        [ div [ class "form" ]
          [ input
            [ placeholder "Say something nice 😁"
            , onInput Model.ChangeMessage
            , onEnter Model.Send
            , value model.message ] []
          , button
            [ classList [ ("visible", not <| String.isEmpty model.message ) ]
            , onClick Model.Send
            ] [ text "Send" ]
          ]
        , ul [ class "messages" ]
          (map renderMessage model.chat)
        ]
      -- , div [ class "users" ]
      --   [ h2 [] [ text "Users" ]
      --   , ul []
      --     [ li [] [ text "TODO" ]
      --     ]
      --   ]
      ]
