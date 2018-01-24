{-# LANGUAGE OverloadedStrings #-}
{-|
Module      : Server
Description : Module hadling main functionality for managing WebSockets
Copyright   : (c) osdnk, 2018
                  tcheyen, 2018
-}
module Server ( server ) where

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
  import qualified VulgarismsHandler as VH
  import MessageHandler (sendDirectMessage, sendMessage, broadcast)
  import Model (ServerState, Client)


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

  -- | Managing session
  session :: WS.Connection -> MVar ServerState -> Client -> IO()
  session conn state client = do
    modifyMVar_ state $ \s -> do
      let s' = addClient client s
      broadcast ("SYSTEM: " `mappend` fst client `mappend` " joined.") s'
      return s'
    talk conn state client

  -- | Starter function
  server :: IO ()
  server = do
    state <- newMVar newServerState
    T.putStrLn "I'm server and I'm here to serve you."
    WS.runServer "127.0.0.1" 9160 $ application state

  -- | Main functionality
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

  -- | Managing signals to server
  talk :: WS.Connection -> MVar ServerState -> Client -> IO ()
  talk conn state (user, _) = forever $ do
    msg <- WS.receiveData conn
    case msg of
      _   | ("direct " `T.isPrefixOf` msg) && (length (words $ T.unpack msg) > 4) -> readMVar state >>= broadcast
          ("SYSTEM: " `mappend` user `mappend` " is so stupid that she or he cannot send proper direct message! 😄")
          | "direct " `T.isPrefixOf` msg -> readMVar state >>= sendDirectMessage user msg
          | T.toLower msg == T.pack "ping" -> WS.sendTextData conn (T.pack "👻: pong")
          | otherwise -> sendMessage state user msg
