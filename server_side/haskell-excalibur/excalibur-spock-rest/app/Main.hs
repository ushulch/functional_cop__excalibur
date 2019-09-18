{-# LANGUAGE OverloadedStrings #-}
module Main where

import Web.Spock
import Web.Spock.Config

import qualified Data.Text as T

data MySession = EmptySession
data MyAppState = DummyAppState


main :: IO ()
main = do
  spockCfg <- defaultSpockCfg EmptySession PCNoDatabase DummyAppState
  runSpock 4000 (spock spockCfg app)


add :: Int -> Int -> Int
add x y = x + y


app :: SpockM () MySession MyAppState ()
app = do
  get root $
    text "Hello World!"
  get ("values" <//> var <//> var) $
    \x y -> do
      let res = add x y
      json ( T.pack (show (res)) )
