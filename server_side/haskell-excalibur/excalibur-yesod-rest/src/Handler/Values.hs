{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Values where

import Import
import qualified Data.Text as T


getValuesR :: Handler Value
getValuesR = do
  returnJson (["value1", "value2"] :: [T.Text])
