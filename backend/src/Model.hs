{-# LANGUAGE OverloadedStrings #-}
{-|
Module      : Model
Description : Simple models for client and server
Copyright   : (c) osdnk, 2018
                  tcheyen, 2018
-}
module Model ( Client, ServerState ) where
  import qualified Network.WebSockets as WS
  import Data.Text (Text)

-- | `Client` consists of its name and its WebSocket
  type Client = (Text, WS.Connection)
-- | `Server State is just an array of connected websockerts with active session`
  type ServerState = [Client]
