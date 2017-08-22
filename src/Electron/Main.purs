module Electron.Main (registerAsyncHandler, registerSyncHandler) where

import Electron.Types (ELECTRON)

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Uncurried (EffFn1, runEffFn1, mkEffFn1)



foreign import registerAsyncHandlerImpl :: forall eff.
                 EffFn1 (electron :: ELECTRON | eff)
                   { channel :: String
                   , handle :: EffFn1 (electron :: ELECTRON | eff)
                       { message :: String
                       , send :: EffFn1 (electron :: ELECTRON | eff)
                           { channel :: String
                           , message :: String
                           } Unit
                       } Unit
                   } Unit


registerAsyncHandler :: forall eff
                      . { channel :: String
                        , handle ::
                            { message :: String
                            , send :: { channel :: String
                                      , message :: String
                                      }
                                   -> Eff (electron :: ELECTRON | eff) Unit
                            } -> Eff (electron :: ELECTRON | eff) Unit
                        } -> Eff (electron :: ELECTRON | eff) Unit
registerAsyncHandler {channel,handle} =
  runEffFn1 registerAsyncHandlerImpl
    { channel
    , handle: mkEffFn1 \{message,send} ->
        handle
          { message
          , send: runEffFn1 send
          }
    }


foreign import registerSyncHandlerImpl :: forall eff.
                 EffFn1 (electron :: ELECTRON | eff)
                   { channel :: String
                   , handle :: EffFn1 (electron :: ELECTRON | eff)
                       String String
                   } Unit

registerSyncHandler :: forall eff
                     . { channel :: String
                       , handle :: String -> Eff (electron :: ELECTRON | eff) String
                       }
                    -> Eff (electron :: ELECTRON | eff) Unit
registerSyncHandler {channel,handle} = runEffFn1 registerSyncHandlerImpl
  { channel
  , handle: mkEffFn1 handle
  }
