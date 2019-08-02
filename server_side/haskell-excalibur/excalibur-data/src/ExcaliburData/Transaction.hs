{-# LANGUAGE OverloadedStrings #-}


module ExcaliburData.Transaction (Transaction(..)) where

import qualified Data.UUID as UUID
import qualified Data.Time.Calendar as Calendar
import Data.Aeson.Types



data Transaction = Transaction {id :: UUID.UUID,
                                date :: Calendar.Day,
                                vendor :: String,
                                amount :: Double}
  deriving (Show, Eq)


instance ToJSON Transaction where
  toJSON (Transaction transId transDate transVendor transAmount) =
    object [
            "id" .= transId,
            "date" .= transDate,
            "vendor" .= transVendor,
            "amount" .= transAmount
           ]

  toEncoding (Transaction transId transDate transVendor transAmount) =
    pairs ("id" .= transId <>
           "date" .= transDate <>
           "vendor" .= transVendor <>
           "amount" .= transAmount)
