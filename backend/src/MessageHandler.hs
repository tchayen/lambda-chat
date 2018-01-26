{-# LANGUAGE OverloadedStrings #-}
{-|
Module      : Message Handler
Description : Module hadling sending messages
Copyright   : (c) osdnk   2018
                  tchayen 2018
-}
module MessageHandler ( sendDirectMessage, sendMessage, broadcast ) where

import Data.Monoid (mappend)
import Data.Text (Text)
import Data.List
import Control.Monad (forM_)
import Control.Concurrent (MVar, readMVar)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Network.WebSockets as WS
import qualified VulgarismsHandler as VH
import Model (ServerState)

-- | Managing sending direct messages prefixed with `direct ` and receiver
sendDirectMessage :: Text -> Text -> ServerState -> IO ()
sendDirectMessage user msg clients = do
  let recipient = words (T.unpack msg) !! 1
  let client = find (\(name, _) -> T.unpack name == recipient) clients

  case client of
    Nothing -> broadcast
      ("SYSTEM: " `mappend` user `mappend` " is so stupid. She or he wanna send message to user that does not exist 😳") clients
    Just (_, conn) ->
      WS.sendTextData conn (user `mappend` " directly to you: " `mappend` T.pack (drop (8 + length (T.unpack user)) (T.unpack msg)))

-- | sending messages handler
sendMessage :: MVar ServerState -> Text -> Text -> IO()
sendMessage state user msg =
  readMVar state >>= broadcast
    (user `mappend`": " `mappend` VH.removeUglyWords msg)

-- | Send message for each user
broadcast :: Text -> ServerState -> IO ()
broadcast message clients = do
  T.putStrLn message
  forM_ clients $ \(_, conn) -> WS.sendTextData conn message
