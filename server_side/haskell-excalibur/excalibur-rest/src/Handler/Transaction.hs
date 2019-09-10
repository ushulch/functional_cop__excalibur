{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}

module Handler.Transaction where
import qualified Data.UUID as UUID

import Import
import qualified ExcaliburDal
import qualified ExcaliburData.Transaction as Transaction



getTransaction :: String -> IO (Maybe Transaction.Transaction)
getTransaction uuidString = do
  maybeUuid <- return (UUID.fromString uuidString)
  connection <- ExcaliburDal.connect
  case maybeUuid of
       Just uuid -> ExcaliburDal.lookupTransaction connection uuid
       Nothing -> return (Nothing)

getTransactionR :: String -> Handler Value
getTransactionR uuidString = do
  maybeTransaction <- liftIO $ getTransaction uuidString

  case maybeTransaction of
    Just transaction -> returnJson transaction
    Nothing -> notFound


putTransactionR :: String -> Handler Value
putTransactionR _uuidString = do
  connection <- liftIO $ ExcaliburDal.connect
  transaction <- requireJsonBody :: Handler Transaction.Transaction
  liftIO $ ExcaliburDal.insertTransaction connection transaction
  sendResponseStatus status200 ("UPDATED" :: Text)
