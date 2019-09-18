{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Transactions where

import Import
import qualified ExcaliburDal


getTransactionsR :: Handler Value
getTransactionsR = do
  connection <- liftIO $ ExcaliburDal.connect
  transactionList <- liftIO $ ExcaliburDal.listTransactions connection
  returnJson $ transactionList
