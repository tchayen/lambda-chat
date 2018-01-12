import Test.Hspec

main :: IO ()
main = hspec spec

spec :: Spec
spec = do
  describe "even" $ do
    it "checks if number is even" $ do
      even 3 `shouldBe` False