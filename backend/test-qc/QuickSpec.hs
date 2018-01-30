{-# LANGUAGE TemplateHaskell #-}
module Main where

import Test.QuickCheck.All
import Test.QuickCheck
import qualified VulgarismsHandler as VH
import Data.Text (Text, pack, unpack, isInfixOf)

instance Arbitrary Text where
  arbitrary = pack <$> arbitrary
  shrink xs = pack <$> shrink (unpack xs)

prop_fuckHandler text =
  not ((pack "fuck") `isInfixOf` (VH.removeUglyWords text))

prop_bitchHandler text =
  not ((pack "bitch") `isInfixOf` (VH.removeUglyWords text))

prop_dickHandler text =
  not ((pack "dick") `isInfixOf` (VH.removeUglyWords text))

return []

main :: IO Bool
main = $quickCheckAll
