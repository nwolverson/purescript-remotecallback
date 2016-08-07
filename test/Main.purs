module Test.Main where

import Prelude
import Control.Monad.Aff (forkAff)
import Control.Monad.Aff.AVar (takeVar, putVar, makeVar)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import DOM (DOM)
import Data.Either (Either(..))
import Data.Foreign (readString)
import Network.RemoteCallback (externalCall, generateName, jsonp)
import Test.Unit (timeout, test)
import Test.Unit.Assert (assert)
import Test.Unit.Main (runTest)

foreign import callWindowFunction :: forall eff. String -> String -> Eff (dom :: DOM | eff) Unit

main :: Eff _ Unit
main = do
  runTest do
    test "jsonp with fixed callback name" do
      timeout 5000 do
        result <- jsonp "PS_Fixed_Callback" "test_jsonp_result.js"
        assert "wrong result" $ readString result == Right "Callback argument."
    test "externalCall" do
      timeout 5000 do
        name <- liftEff $ generateName "PS_Callback"
        v <- makeVar
        forkAff do
          r <- externalCall name
          putVar v r
        liftEff $ callWindowFunction name "Result 1"
        result <- takeVar v
        assert  "yielded wrong result" $ readString result == Right "Result 1"
