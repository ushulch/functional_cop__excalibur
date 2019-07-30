module ExcaliburData.TransactionSpec (spec) where

import Test.Hspec
import qualified ExcaliburData.Transaction as Transaction
import qualified Data.UUID as UUID
import Data.Time.Calendar

getUUID :: UUID.UUID
getUUID =
  let
    maybeUUID = UUID.fromString "b6df5836-a643-44c2-86ee-78e0113f5e80"
  in
    case maybeUUID of
      Just uuid -> uuid
      Nothing -> error "UUID is invalid"


spec :: Spec
spec = do
  describe "Transact" $ do
    it "can be constructed" $
      let
        transId = getUUID
        date = fromGregorian 2019 07 26
        vendor = "Amazon.com"
        amount = 23.68

        transaction = Transaction.Transaction transId date vendor amount
      in
        transaction `shouldBe` transaction
