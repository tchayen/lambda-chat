module Model exposing (..)

{-|
Model consists of content of the input field.

# Types
@docs Message, Model, Msg, init, url
-}

{-| Constant URL of backend server
-}
url : String
url = "ws://127.0.0.1:9160"


{-| Msg model for update.
-}
type Msg
  = Send
  | Receive String
  | ChangeLogin String
  | ChangeMessage String
  | Join


{-| Message from and to server.
-}
type alias Message =
  { author : String
  , content : String
  }


{-| Application model.
-}
type alias Model =
  { input : String
  , message : String
  , login : Maybe String
  , chat : List Message
  , users : List String
  }


{-| init function.
-}
init : ( Model, Cmd Msg )
init =
  ( Model "" "" Nothing [] []
  , Cmd.none
  )
