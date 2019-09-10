module ExcaliburDal
  (
    connect,
    ExcaliburDal.disconnect,
    insertTransaction,
    lookupTransaction,
    listTransactions,
    Connection
  ) where


import Database.HDBC
import qualified Database.HDBC.PostgreSQL as PSQL
import Data.Time.Calendar
import Data.Time.Format
import qualified Data.UUID as UUID
import Data.Maybe

import qualified ExcaliburData.Transaction as Transaction

type Connection = PSQL.Connection


connect :: IO Connection
connect =
  PSQL.connectPostgreSQL "host=localhost dbname=excalibur user=excalibur password=Starkle5! application_name=ExcaliburDal"



disconnect :: PSQL.Connection -> IO ()
disconnect = Database.HDBC.disconnect



insertTransaction :: Connection -> Transaction.Transaction -> IO ()
insertTransaction connection transaction =
  let
    sqlId = toSql $ UUID.toString $ Transaction.id transaction
    sqlDate = toSql $ showGregorian $ Transaction.date transaction
    sqlVendor = toSql $ Transaction.vendor transaction
    sqlAmount = toSql $ Transaction.amount transaction

    sqlString = "insert into " ++
                "   transactions " ++
                "      (id, date, vendor, amount) " ++
                "   values (?, ?, ?, ?) " ++
                "on conflict " ++
                "   (id) " ++
                "do update set " ++
                "   date = ?, " ++
                "   vendor = ?, " ++
                "   amount = ?;"

    --The duplicates are for the update clause in the insert
    sqlArgList = [sqlId,
                  sqlDate,
                  sqlVendor,
                  sqlAmount,

                  sqlDate,
                  sqlVendor,
                  sqlAmount]
  in
    withTransaction connection $ \c -> run c sqlString sqlArgList
    >> return ()


dayFromIsoString :: Maybe String -> Maybe Day
dayFromIsoString maybeIsoString =
  case maybeIsoString of
    Just isoString ->
      parseTimeM True defaultTimeLocale "%F" isoString
    Nothing ->
      Nothing


maybeTransactionFromRow :: [SqlValue] -> Maybe Transaction.Transaction
maybeTransactionFromRow transactionRow =
  let
    maybeId = UUID.fromString $ fromSql $ transactionRow !! 0
    maybeDate = dayFromIsoString $ fromSql $ transactionRow !! 1
    vendor = fromSql $ transactionRow !! 2
    amount = fromSql $ transactionRow !! 3

    anyNothings = (isNothing maybeId) && (isNothing maybeDate)
  in
    case anyNothings of
      True ->
        Nothing
      False ->
        Just $ Transaction.Transaction (fromJust maybeId) (fromJust maybeDate) vendor amount


maybeTransactionFromRows :: [[SqlValue]] -> Maybe Transaction.Transaction
maybeTransactionFromRows [transactionRow] =
  maybeTransactionFromRow transactionRow

maybeTransactionFromRows _ = Nothing



transactionsFromRows :: [[SqlValue]] -> [Transaction.Transaction]
transactionsFromRows transactionRowList =
  mapMaybe maybeTransactionFromRow transactionRowList




lookupTransaction :: Connection -> UUID.UUID -> IO (Maybe Transaction.Transaction)
lookupTransaction connection transactionId =
  let
    sqlId = toSql $ UUID.toString transactionId

    sqlString = "select " ++
                "   id, date, vendor, amount::numeric(20, 2) " ++
                "from " ++
                "   transactions " ++
                "where " ++
                "       id = ?;"

    sqlArgList = [sqlId]
  in
    withTransaction connection $ \c -> quickQuery' c sqlString sqlArgList
    >>= \listOfRows -> return (maybeTransactionFromRows listOfRows)




listTransactions :: Connection -> IO [Transaction.Transaction]
listTransactions connection =
  let
    sqlString = "select " ++
                "   id, date, vendor, amount::numeric(20, 2) " ++
                "from " ++
                "   transactions;"

  in
    withTransaction connection $ \c -> quickQuery' c sqlString []
    >>= \listOfRows -> return (transactionsFromRows listOfRows)
