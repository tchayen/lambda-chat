{-|
Module      : Vulgarisms Handler
Description : Module hadling removing vulgsrisms from messages
Copyright   : (c) osdnk, 2018
                  tcheyen, 2018
-}
module VulgarismsHandler ( removeUglyWords ) where
  import qualified Data.Text as T
  import Data.Text (Text)


  removeUglyWords :: Text -> Text
  removeUglyWords =
    T.replace (T.pack "fuck") (T.pack  "fork")
    .T.replace (T.pack "dick") (T.pack  "duck")
    .T.replace (T.pack "bitch") (T.pack  "beach")
