module Electron (openWindow, webview, module Types) where

import Electron.Types (ELECTRON)
import Electron.Types as Types

import Prelude
import Data.Argonaut (Json)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Uncurried (EffFn1, runEffFn1, mkEffFn1)

import React (ReactElement, createElementTagName)



foreign import openWindowImpl :: forall eff. EffFn1 (electron :: ELECTRON | eff)
                                    { file :: String
                                    , width :: Int
                                    , height :: Int
                                    , devTools :: Boolean
                                    , whenLoaded :: EffFn1 (electron :: ELECTRON | eff)
                                                      { send :: EffFn1 (electron :: ELECTRON | eff) {channel :: String, message :: Json} Unit
                                                      } Unit
                                    } Unit

openWindow :: forall eff. { file :: String
                          , width :: Int
                          , height :: Int
                          , devTools :: Boolean
                          , whenLoaded :: { send :: {channel :: String, message :: Json} -> Eff (electron :: ELECTRON | eff) Unit
                                          } -> Eff (electron :: ELECTRON | eff) Unit
                          } -> Eff (electron :: ELECTRON | eff) Unit
openWindow {file,width,height,devTools,whenLoaded} =
  runEffFn1 openWindowImpl
    { file, width, height, devTools
    , whenLoaded: mkEffFn1 \{send} -> whenLoaded {send: runEffFn1 send}
    }


webview :: forall props. { | props } -> Array ReactElement -> ReactElement
webview = createElementTagName "webview"
