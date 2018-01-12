module QuickSpec where

import Test.QuickCheck

reverse :: [a] -> [a]
reverse []     = []
reverse (x:xs) = Prelude.reverse xs ++ [x]

prop_ReverseReverseId :: [Integer] -> Bool
prop_ReverseReverseId xs = Prelude.reverse (Prelude.reverse xs) == xs

main = quickCheck prop_ReverseReverseId
