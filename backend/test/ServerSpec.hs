module ServerSpec where

import Test.Hspec
import Test.QuickCheck

main = hspec spec

spec = do
  describe "even" $ do
    it "checks if number is even" $
      even 3 `shouldBe` False