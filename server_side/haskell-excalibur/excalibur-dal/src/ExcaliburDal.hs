module ExcaliburDal
  (
    connect,
    ExcaliburDal.disconnect,
    insertTransaction
  ) where


import Database.HDBC
import qualified Database.HDBC.PostgreSQL as PSQL
import Date.Time.Calendar
import Data.UUID

type Connection = PSQL.Connection


connect :: IO Connection
connect =
  PSQL.connectPostgreSQL "host=localhost dbname=excalibur user=excalibur password=Starkle5! application_name=ExcaliburDal"



disconnect :: PSQL.Connection -> IO ()
disconnect = Database.HDBC.disconnect



insertTransaction :: Connection -> Transaction -> IO ()
insertTransaction connection transaction =
  let
    sqlId = UUID.toString Transaction.id transaction
    sqlDate = toSql $ showGregorian $ Transaction.date transaction,
    sqlVendor = toSql $ Transaction.vendor
    sqlAmount = toSql $ Transaction.amount

    sqlString = "insert into " ++
                "   transactions " ++
                "      (id, date, vendor, amount) " ++
                "   values (?, ?, ?, ?) " ++
                "on conflict " ++
                "   (key) " ++
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



maybeValueFromRows :: [[SqlValue]] -> Maybe Value
maybeValueFromRows [characterRow] =
  let
    value = fromSql $ characterRow !! 0
  in
    Just value

maybeValueFromRows _ = Nothing



lookup :: Connection -> Collection -> Key -> IO (Maybe Value)
lookup  connection collection key =
  let
    sqlString = "select " ++
                "   value " ++
                "from " ++
                    (T.unpack collection) ++ " " ++
                "where " ++
                "       key = ?;"

    sqlArgList = [toSql key]
  in
    withTransaction connection $ \c -> quickQuery' c sqlString sqlArgList
    >>= \listOfRows -> return (maybeValueFromRows listOfRows)
