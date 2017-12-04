module Model exposing (..)


url : String
url = "ws://127.0.0.1:9160"


type Msg
  = Send
  | Receive String
  | ChangeLogin String
  | ChangeMessage String
  | Join


type alias Message =
  { author : String
  , content : String
  }


type alias Model =
  { input : String
  , message : String
  , login : Maybe String
  , chat : List Message
  , users : List String
  }


init : ( Model, Cmd Msg )
init =
  ( Model "" "" Nothing [] []
  , Cmd.none
  )
