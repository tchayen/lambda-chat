{-|
Module      : Main
Description : Main module of the app
Copyright   : (c) osdnk   2018
                  tchayen 2018
-}
module Main where

import qualified Server as S

main :: IO ()
main = S.server
