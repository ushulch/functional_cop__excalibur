module ExcaliburData.Transaction (Transaction(..)) where

import qualified Data.UUID as UUID
import qualified Data.Time.Calendar as Calendar


data Transaction = Transaction {id :: UUID.UUID,
                                date :: Calendar.Day,
                                vendor :: String,
                                amount :: Double}
  deriving (Show, Eq)
