module Test.Main where

import Prelude
import Test.Unit.Output.Simple as Simple
import Control.Monad.Aff (forkAff, runAff)
import Control.Monad.Aff.AVar (AVAR, takeVar, putVar, makeVar)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE)
import DOM (DOM)
import Data.Either (Either(..))
import Data.Foreign (readString)
import Network.RemoteCallback (externalCall, generateName, jsonp)
import Test.Unit (TestSuite, timeout, test)
import Test.Unit.Assert (assert)
import Test.Unit.Console (TESTOUTPUT)
import Test.Unit.Main (runTestWith)

foreign import callWindowFunction :: forall eff. String -> String -> Eff (dom :: DOM | eff) Unit

foreign import callPhantom :: forall eff. Int -> Eff (console :: CONSOLE | eff) Unit

runTest :: forall e. TestSuite (console :: CONSOLE, testOutput :: TESTOUTPUT, avar :: AVAR | e) -> Eff (console :: CONSOLE, testOutput :: TESTOUTPUT, avar :: AVAR | e) Unit
runTest suite = void $ runAff errorHandler successHandler $ runTestWith Simple.runTest suite
  where errorHandler _ = callPhantom 1
        successHandler _ = callPhantom 0

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
