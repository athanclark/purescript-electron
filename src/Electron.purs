module Electron (OpenWindowParams, ELECTRON, openWindow, webview) where

import Prelude
import Control.Monad.Eff (kind Effect, Eff)
import Control.Monad.Eff.Uncurried (EffFn1, runEffFn1)

import React (ReactElement, createElementTagName)



type OpenWindowParams =
  { file :: String -- Relative
  , width :: Int
  , height :: Int
  }

foreign import data ELECTRON :: Effect

foreign import openWindowImpl :: forall eff. EffFn1 (electron :: ELECTRON | eff) OpenWindowParams Unit


openWindow :: forall eff. OpenWindowParams -> Eff (electron :: ELECTRON | eff) Unit
openWindow = runEffFn1 openWindowImpl



webview :: forall props. { | props } -> Array ReactElement -> ReactElement
webview = createElementTagName "webview"
