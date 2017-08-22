module Electron (OpenWindowParams, openWindow, webview) where

import Electron.Types (ELECTRON)

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Uncurried (EffFn1, runEffFn1)

import React (ReactElement, createElementTagName)



type OpenWindowParams =
  { file :: String -- Relative
  , width :: Int
  , height :: Int
  }

foreign import openWindowImpl :: forall eff. EffFn1 (electron :: ELECTRON | eff) OpenWindowParams Unit

openWindow :: forall eff. OpenWindowParams -> Eff (electron :: ELECTRON | eff) Unit
openWindow = runEffFn1 openWindowImpl


webview :: forall props. { | props } -> Array ReactElement -> ReactElement
webview = createElementTagName "webview"
