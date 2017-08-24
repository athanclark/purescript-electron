module Electron.Renderer (registerAsyncHandler, send, sendSync) where

import Electron.Types (ELECTRON)

import Prelude
import Data.Argonaut (Json)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Uncurried (EffFn1, runEffFn1, mkEffFn1)


foreign import registerAsyncHandlerImpl :: forall eff.
                 EffFn1 (electron :: ELECTRON | eff)
                   { channel :: String
                   , handle :: EffFn1 (electron :: ELECTRON | eff)
                       { message :: Json
                       } Unit
                   } Unit

registerAsyncHandler :: forall eff
                      . { channel :: String
                        , handle ::
                            { message :: Json
                            } -> Eff (electron :: ELECTRON | eff) Unit
                        }
                     -> Eff (electron :: ELECTRON | eff) Unit
registerAsyncHandler {channel,handle} =
  runEffFn1 registerAsyncHandlerImpl
    { channel
    , handle: mkEffFn1 handle
    }


foreign import sendImpl :: forall eff.
                 EffFn1 (electron :: ELECTRON | eff)
                   { channel :: String
                   , message :: Json
                   } Unit

send :: forall eff
      . { channel :: String
        , message :: Json
        }
     -> Eff (electron :: ELECTRON | eff) Unit
send = runEffFn1 sendImpl


foreign import sendSyncImpl :: forall eff.
                 EffFn1 (electron :: ELECTRON | eff)
                   { channel :: String
                   , message :: String
                   } String

sendSync :: forall eff
          . { channel :: String
            , message :: String
            }
         -> Eff (electron :: ELECTRON | eff) String
sendSync = runEffFn1 sendSyncImpl
