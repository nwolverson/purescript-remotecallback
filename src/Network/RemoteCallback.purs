module Network.RemoteCallback (jsonp, externalCall, generateName, Name()) where

import Prelude
import DOM
import Control.Monad.Eff
import Control.Monad.Aff(makeAff,Aff())
import Data.Foreign

foreign import addScript :: forall eff. String -> Eff (dom :: DOM | eff) Node
foreign import removeScript :: forall eff. Node -> Eff (dom :: DOM | eff) Unit

-- | Register a raw self-unregistering external (global) call handler.
foreign import addExternalCallHandler :: forall eff. String -> (Foreign -> Eff eff Unit) -> Eff eff Unit

foreign import data Name :: !

-- | Generate new callback name
foreign import generateName :: forall eff. String -> Eff (name :: Name | eff) String


-- | Call an external JSONP service given callback name and url
jsonp :: forall eff. String -> String -> Aff (dom :: DOM | eff) Foreign
jsonp name url = makeAff $ (\_ callback -> do
  script <- addScript url
  addExternalCallHandler name $ (\x -> do
    callback x
    removeScript script))

-- | Register a raw self-unregistering external (global) call handler.
externalCall :: forall eff. String -> Aff (dom :: DOM | eff) Foreign
externalCall name = makeAff $ \_ cb -> addExternalCallHandler name cb
