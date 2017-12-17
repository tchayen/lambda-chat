{-# LANGUAGE OverloadedStrings #-}
module Main where
import Data.Char (isPunctuation, isSpace)
import Data.Monoid (mappend)
import Data.Text (Text)
import Data.String
import Data.List
import Control.Exception (finally)
import Control.Monad (forM_, forever)
import Control.Concurrent (MVar, newMVar, modifyMVar_, modifyMVar, readMVar)
import qualified Data.Text as T
import qualified Data.Text.IO as T
import Text.Regex.Posix

import qualified Network.WebSockets as WS

type Client = (Text, WS.Connection)
type ServerState = [Client]

newServerState :: ServerState
newServerState = []

numClients :: ServerState -> Int
numClients = length

clientExists :: Client -> ServerState -> Bool
clientExists client = any ((== fst client) . fst)

addClient :: Client -> ServerState -> ServerState
addClient client clients = client : clients

removeClient :: Client -> ServerState -> ServerState
removeClient client = filter ((/= fst client) . fst)

sendDirectMessage :: Text -> Text -> ServerState -> IO ()
sendDirectMessage user msg clients = do
  let recipient = (words (T.unpack msg))!!1
  let client = find (\(name, _)->(T.unpack name)==recipient) clients

  case client of
    Nothing -> broadcast ("SYSTEM: " `mappend` user `mappend` " is extremely stupid. She or he wanna send message to nobody") clients
    Just (_, conn) -> WS.sendTextData conn (user `mappend` " directly to you: " `mappend` T.pack(drop (9+ (length $ T.unpack user)) (T.unpack msg)))





session conn state client = do
   modifyMVar_ state $ \s -> do
     let s' = addClient client s
     broadcast ("SYSTEM: " `mappend` fst client `mappend` " joined.") s'
     return s'
   talk conn state client

broadcast :: Text -> ServerState -> IO ()
broadcast message clients = do
  T.putStrLn message
  forM_ clients $ \(_, conn) -> WS.sendTextData conn message

main :: IO ()
main = do
  state <- newMVar newServerState
  T.putStrLn "I'm server and I'm here to serve you."
  WS.runServer "127.0.0.1" 9160 $ application state

application :: MVar ServerState -> WS.ServerApp
application state pending = do
  conn <- WS.acceptRequest pending
  WS.forkPingThread conn 30
  msg <- WS.receiveData conn
  clients <- readMVar state
  case msg of
          _   | any ($ fst client)
                [T.null, T.any isPunctuation, T.any isSpace] ->
                    WS.sendTextData conn ("Name cannot " `mappend`
                        "contain punctuation or whitespace, and " `mappend`
                        "cannot be empty." :: Text)
              | clientExists client clients ->
                WS.sendTextData conn ("User already exists." :: Text)
              | otherwise -> finally (session conn state client) disconnect

            where
              client     = (T.drop 5 msg, conn)
              disconnect = do
                  s <- modifyMVar state $ \s ->
                      let s' = removeClient client s in return (s', s')
                  broadcast ("SYSTEM: " `mappend` fst client `mappend` " disconnected.") s

talk :: WS.Connection -> MVar ServerState -> Client -> IO ()
talk conn state (user, _) = forever $ do
  msg <- WS.receiveData conn
  T.putStrLn(  msg )
  case msg of
          _
              | ("direct " `T.isPrefixOf` msg) && (length (words $ T.unpack msg) > 4) -> readMVar state >>= broadcast
                ("SYSTEM: " `mappend` user `mappend` " is so stupid that she or he cannot send proper direct message!😄")
              | ("direct " `T.isPrefixOf` msg) -> readMVar state >>= sendDirectMessage user msg
              | otherwise -> readMVar state >>= broadcast
                (user `mappend` ": " `mappend` msg)
