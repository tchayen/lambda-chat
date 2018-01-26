{-# LANGUAGE OverloadedStrings #-}
module ServerSpec where

import Test.Hspec
import Network.WebSockets
import Network.WebSockets.Connection
import qualified Server as S
import qualified Network.WebSockets as WS
import Text.Regex.Posix
import qualified VulgarismsHandler as VH

main = hspec spec
spec = do
  describe "even" $ do
    it "checks if number is even" $
      even 3 `shouldBe` False
  describe "beach test" $ do
    it "check `bitch` behavior" $
      VH.removeUglyWords "son of the bitch" `shouldBe` "son of the beach"
  describe "duck test" $ do
    it "check `dick` behavior" $
      VH.removeUglyWords "you dick!" `shouldBe` "you duck!"
  describe "beach test" $ do
    it "check `fuck` behavior" $
      VH.removeUglyWords "fuck off!" `shouldBe` "fork off!"
