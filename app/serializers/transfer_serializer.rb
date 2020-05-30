class TransferSerializer < ActiveModel::Serializer
  attributes :id, :destination_account_id, :amount
  has_one :account
end
