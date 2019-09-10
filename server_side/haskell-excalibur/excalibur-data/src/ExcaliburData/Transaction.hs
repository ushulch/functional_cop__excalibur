{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}


module ExcaliburData.Transaction (Transaction(..)) where

import GHC.Generics
import qualified Data.UUID as UUID
import qualified Data.Time.Calendar as Calendar
import Data.Aeson.Types



data Transaction = Transaction {id :: UUID.UUID,
                                date :: Calendar.Day,
                                vendor :: String,
                                amount :: Double}
  deriving (Show, Eq, Generic)


instance FromJSON Transaction
instance ToJSON Transaction
