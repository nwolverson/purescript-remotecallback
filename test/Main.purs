module Test.Main where

import Prelude
import Control.Monad.Eff
import Control.Monad.Eff.Console
import Control.Monad.Eff.Class(liftEff)
import Control.Monad.Aff(launchAff,forkAff,Aff())

import Test.Unit
import DOM
import Network.RemoteCallback

import Control.Monad.Aff.AVar

foreign import callWindowFunction :: forall eff. String -> String -> Eff (dom :: DOM | eff) Unit

main = do
  runTest do
    test "jsonp with fixed callback name" do
      timeout 5000 $ assertFn "yielded wrong result" \done ->
        launchAff $ do
          result <- jsonp "PS_Fixed_Callback" "test_jsonp_result.js"
          liftEff $ done $ result == "Callback argument."
    test "externalCall" do
      timeout 5000 $ assertFn "yielded wrong result" \done ->
        launchAff $ do
          name <- liftEff $ generateName "PS_Callback"
          v <- makeVar
          forkAff do
            r <- externalCall name
            putVar v r
          liftEff $ callWindowFunction name "Result 1"
          result <- takeVar v
          liftEff $ done $ result == "Result 1"
